#include "inode.h"

#define FUSE_USE_VERSION 317

#include <dirent.h>
#include <fuse_lowlevel.h>

#include <algorithm>
#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <memory>
#include <new>
#include <string>
#include <vector>
#include <map>

#include "http.h"
#include "util.h"

struct list_response {
  size_t entries_count;
  struct entry {
    unsigned char entry_type; // DT_DIR (4) or DT_REG (8)
    ino_t ino;
    char name[256];
  } entries[16];
};

struct create_response {
  ino_t ino;
};

struct read_response {
  uint64_t content_length;
  char content[512];
};

struct lookup_response {
  unsigned char entry_type; // DT_DIR (4) or DT_REG (8)
  ino_t ino;
};

struct file_buffer {
    char *data;
    size_t size;
};

static char* token = NULL;

std::map<int, struct stat> entries_attr;

fuse_ino_t ino_fs(fuse_ino_t x) {
  if (x == 1) x = 1000;
  return x;
}

fuse_ino_t ino_sf(fuse_ino_t x) {
  if (x == 1000) x = 1;
  return x;
}

bool status_processing(int64_t status, fuse_req_t req) {
  if (status == NFS_SUCCESS) return false;

  std::map<int64_t, int> err_to_fuse = {
        {NFS_ENOENT,       ENOENT},
        {NFS_ENOTFILE,     EISDIR},
        {NFS_ENOTDIR,      ENOTDIR},
        {NFS_ENOENT_DIR,   ENOENT},
        {NFS_EEXIST,       EEXIST},
        {NFS_EFBIG,        EFBIG},
        {NFS_ENOSPC_DIR,   ENOSPC},
        {NFS_ENOTEMPTY,    ENOTEMPTY},
        {NFS_ENAMETOOLONG, ENAMETOOLONG},
  };
  
  fuse_reply_err(req, err_to_fuse.count(status) ? err_to_fuse[status] : ENOSYS);
  
  return true;
}

#define BLOCK_SIZE 512

void set_entry_attr(struct stat* attr, fuse_ino_t ino, unsigned char entry_type) {
  memset(attr, 0, sizeof(struct stat));

  attr->st_ino = ino;
  attr->st_uid = getuid();
  attr->st_gid = getgid();
  attr->st_atime = time(nullptr);
  attr->st_mtime = time(nullptr);
  attr->st_ctime = time(nullptr);

  if (entry_type == 4) {
    attr->st_mode = S_IFDIR | 0755;
    attr->st_size = 4096;
    attr->st_nlink = 2;
    attr->st_blocks = attr->st_size / BLOCK_SIZE;
  } else {
    attr->st_mode = S_IFREG | 0644;
    attr->st_size = 0;
    attr->st_nlink = 1;
    attr->st_blocks = attr->st_size / BLOCK_SIZE; 
  }
}

void set_entry_param(fuse_entry_param* e, fuse_ino_t ino, const struct stat& attr, double timeout) {
  e->ino = ino;
  e->attr = attr;
  e->generation = 0;
  e->attr_timeout = e->entry_timeout = timeout;
}

void set_file_buffer(struct fuse_file_info* fi, file_buffer* fb) {
  fi->fh = reinterpret_cast<uint64_t>(fb);
  fi->direct_io = 0;
  fi->keep_cache = 1;
  fi->nonseekable = 0;
}

void init_entries_attr(fuse_ino_t ino, unsigned char entry_type){
  if (!entries_attr.count(ino)) {
    struct stat attr;
    set_entry_attr(&attr, ino, entry_type);
    entries_attr[ino] = attr;
  }
}

void networkfs_init(void* userdata, struct fuse_conn_info* conn) {
  if (userdata) {
    token = static_cast<char*>(userdata);
  }
  entries_attr.clear();
  struct stat root = {};
  set_entry_attr(&root, FUSE_ROOT_ID, DT_DIR);
  entries_attr[FUSE_ROOT_ID] = root;
}

void networkfs_destroy(void* private_data) {
  // Token string, which was allocated in main.
  free(private_data);
}

void networkfs_lookup(fuse_req_t req, fuse_ino_t parent, const char* name) {
  std::vector<std::pair<std::string, std::string>> args = {
        {"parent", std::to_string(ino_fs(parent))},
        {"name", name},
  };

  char response_buffer[sizeof(lookup_response)];

  int64_t status = networkfs_http_call(
    token, "lookup", response_buffer, sizeof(response_buffer), args);

  if (status_processing(status, req)) return;

  auto* server_response = reinterpret_cast<lookup_response*>(response_buffer);

  fuse_entry_param e;
  fuse_ino_t ino = ino_sf(server_response->ino);
  init_entries_attr(ino, server_response->entry_type);
  set_entry_param(&e, ino, entries_attr[ino], 0.0);

  fuse_reply_entry(req, &e);
}

void networkfs_getattr(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info* fi) {
  if (entries_attr.count(ino)) {
    fuse_reply_attr(req, &entries_attr[ino], 0.0);
  } else {
    fuse_reply_err(req, ENOENT);
  }
}

void networkfs_iterate(fuse_req_t req, fuse_ino_t i_ino, size_t size, off_t off, struct fuse_file_info* fi) {
  std::vector<std::pair<std::string, std::string>> args = {
        {"inode", std::to_string(ino_fs(i_ino))},
  };

  char response_buffer[sizeof(list_response)];

  int64_t status = networkfs_http_call(
    token, "list", response_buffer, sizeof(response_buffer), args);
      
  if (status_processing(status, req)) return;

  auto* server_response = reinterpret_cast<struct list_response*>(response_buffer);
  auto* entries = server_response->entries;

  char* buffer = new char[size];
  size_t buffer_offset = 0;

  for (size_t i = off; i < server_response->entries_count; ++i) {
    fuse_ino_t entry_ino = ino_sf(entries[i].ino);
    init_entries_attr(entry_ino, entries[i].entry_type);

    size_t entry_size = fuse_add_direntry(
      req, buffer + buffer_offset, size - buffer_offset, 
      entries[i].name, &entries_attr[entry_ino], i + 1);

    if (buffer_offset + entry_size > size) break;
    buffer_offset += entry_size;
  }

  fuse_reply_buf(req, buffer, buffer_offset);
  delete[] buffer;
}

void networkfs_create(fuse_req_t req, fuse_ino_t parent, const char* name, mode_t mode, struct fuse_file_info* fi) {
  std::vector<std::pair<std::string, std::string>> args = {
        {"parent", std::to_string(ino_fs(parent))},
        {"name", name},
        {"type", "file"},
  };

  char response_buffer[sizeof(create_response)];

  int64_t status = networkfs_http_call(
    token, "create", response_buffer, sizeof(response_buffer), args);

  if (status_processing(status, req)) return;

  auto* server_response = reinterpret_cast<create_response*>(response_buffer);
  fuse_ino_t entry_ino = ino_sf(server_response->ino);

  struct stat attr;
  set_entry_attr(&attr, entry_ino, DT_REG);
  attr.st_mode = S_IFREG | (mode & 0777);
  entries_attr[entry_ino] = attr;

  fuse_entry_param e;
  set_entry_param(&e, entry_ino, attr, 0.0);

  file_buffer* fb = new file_buffer();
  fb->size = 0;
  fb->data = nullptr;

  set_file_buffer(fi, fb);

  fuse_reply_create(req, &e, fi);
}

void networkfs_unlink(fuse_req_t req, fuse_ino_t parent, const char* name) {
  std::vector<std::pair<std::string, std::string>> args = {
        {"parent", std::to_string(ino_fs(parent))},
        {"name", name},
  };

  char lookup_buffer[sizeof(lookup_response)];

  int64_t lookup_status = networkfs_http_call(
    token, "lookup", lookup_buffer, sizeof(lookup_buffer), args);

  if (status_processing(lookup_status, req)) return;

  auto* response = reinterpret_cast<lookup_response*>(lookup_buffer);
  fuse_ino_t ino = ino_sf(response->ino);

  int64_t unlink_status = networkfs_http_call(
    token, "unlink", nullptr, 0, args);

  if (status_processing(unlink_status, req)) return;

  std::vector<std::pair<std::string, std::string>> args_2 = {
        {"inode", std::to_string(ino_fs(ino))},
  };

  char extra_buffer[sizeof(read_response)];

  int64_t check_status = networkfs_http_call(
    token, "read", extra_buffer, sizeof(extra_buffer), args_2);

  if (check_status == 0 && entries_attr.count(ino)) {
    entries_attr[ino].st_nlink--;
    entries_attr[ino].st_ctime = time(nullptr);
  } else if (check_status  == 1) {
    entries_attr.erase(ino);
  }

  fuse_reply_err(req, 0);
}

void networkfs_mkdir(fuse_req_t req, fuse_ino_t parent, const char* name,
                     mode_t mode) {
  std::vector<std::pair<std::string, std::string>> args = {
        {"parent", std::to_string(ino_fs(parent))},
        {"name",  name},
        {"type", "directory"},
  };

  char response_buffer[sizeof(create_response)];
  int64_t status = networkfs_http_call(
    token, "create", response_buffer, sizeof(response_buffer), args);

  if (status_processing(status, req)) return;

  auto* server_response = reinterpret_cast<create_response*>(response_buffer);
  fuse_ino_t entry_ino = ino_sf(server_response->ino);

  struct stat attr;
  set_entry_attr(&attr, entry_ino, DT_DIR);
  attr.st_mode = S_IFDIR | (mode & 0777);
  entries_attr[entry_ino] = attr;

  fuse_entry_param e;
  set_entry_param(&e, entry_ino, attr, 0.0);

  fuse_reply_entry(req, &e);
}

void networkfs_rmdir(fuse_req_t req, fuse_ino_t parent, const char* name) {
  std::vector<std::pair<std::string, std::string>> args = {
        {"parent", std::to_string(ino_fs(parent))},
        {"name",  name},
  };

  int64_t status = networkfs_http_call(
    token, "rmdir", nullptr, 0, args);

  if (status_processing(status, req)) return;

  fuse_reply_err(req, 0);
}

void networkfs_open(fuse_req_t req, fuse_ino_t i_ino, fuse_file_info* fi) {
  file_buffer* buffer = new file_buffer();

  int access = fi->flags & O_ACCMODE;

  if (access == O_RDONLY || ((access == O_RDWR || access == O_WRONLY) && !(fi->flags & O_TRUNC))) {
    std::vector<std::pair<std::string, std::string>> args = {
      {"inode", std::to_string(ino_fs(i_ino))},
    };

    char response_buffer[sizeof(read_response)];
    int64_t status = networkfs_http_call(
      token, "read", response_buffer, sizeof(response_buffer), args);

    if (status_processing(status, req)){
      delete buffer;
      return;
    }

    auto* server_response = reinterpret_cast<read_response*>(response_buffer);

    buffer->size = server_response->content_length;
    buffer->data = new char[buffer->size];
    memcpy(buffer->data, server_response->content, buffer->size);
  } else if (fi->flags & O_TRUNC && (access == O_WRONLY || access == O_RDWR)) {
    buffer->size = 0;
    buffer->data = nullptr;
  } else {
    delete buffer;
    fuse_reply_err(req, EINVAL);
    return;
  }

  init_entries_attr(i_ino, DT_REG);

  entries_attr[i_ino].st_size = buffer->size;
  entries_attr[i_ino].st_blocks = (buffer->size + BLOCK_SIZE - 1) / BLOCK_SIZE;
  entries_attr[i_ino].st_mtime = time(nullptr);

  set_file_buffer(fi, buffer);

  fuse_reply_open(req, fi);
}

void networkfs_release(fuse_req_t req, fuse_ino_t ino,
                       struct fuse_file_info* fi) {
  if (fi->fh) {
    auto* fb = reinterpret_cast<file_buffer*>(fi->fh);
    fi->fh = 0;
    delete[] fb->data;
    delete fb;
  }
  fuse_reply_err(req, 0);
}

void networkfs_read(fuse_req_t req, fuse_ino_t ino, size_t size, off_t off,
                    struct fuse_file_info* fi) {
  if (!fi->fh) {
    fuse_reply_err(req, EBADF);
    return;
  }

  auto* buffer = reinterpret_cast<file_buffer*>(fi->fh);

  if (off >= buffer->size) {
    fuse_reply_buf(req, nullptr, 0);
    return;
  }

  size_t read_size = std::min(buffer->size - off, size);
  fuse_reply_buf(req, buffer->data + off, read_size);

  if (entries_attr.count(ino)) {
    entries_attr[ino].st_atime = time(nullptr);
  }
}

void networkfs_write(fuse_req_t req, fuse_ino_t ino, const char* buffer,
                     size_t size, off_t off, struct fuse_file_info* fi) {
  if (!fi->fh) {
    fuse_reply_err(req, EBADF);
    return;
  }

  auto* cur_buffer = reinterpret_cast<file_buffer*>(fi->fh);

  if (fi->flags & O_APPEND) {
    off = cur_buffer->size;
  }

  size_t new_size = off + size;

  if (new_size > cur_buffer->size) {
    char* new_buffer = new char[new_size]();
    memcpy(new_buffer, cur_buffer->data, cur_buffer->size);
    delete[] cur_buffer->data;
    cur_buffer->data = new_buffer;
    cur_buffer->size = new_size;
  }

  memcpy(cur_buffer->data + off, buffer, size);

  if (entries_attr.count(ino)) {
    entries_attr[ino].st_size = cur_buffer->size;
    entries_attr[ino].st_blocks = (cur_buffer->size + BLOCK_SIZE - 1) / BLOCK_SIZE;
    entries_attr[ino].st_mtime = time(nullptr);
    entries_attr[ino].st_ctime = time(nullptr);
  }

  fuse_reply_write(req, size);
}

void networkfs_flush(fuse_req_t req, fuse_ino_t ino,
                     struct fuse_file_info* fi) {
  if (!fi->fh || fi->flags & O_ACCMODE == O_RDONLY) {
    fuse_reply_err(req, 0);
    return;
  }

  auto* buffer = reinterpret_cast<file_buffer*>(fi->fh);

  std::string content;
  if (buffer->size > 0) content = std::string(buffer->data, buffer->size);

  std::vector<std::pair<std::string, std::string>> args = {
        {"inode", std::to_string(ino_fs(ino))},
        {"content", content},
  };

  int64_t status = networkfs_http_call(
    token, "write", nullptr, 0, args);

  if (status_processing(status, req)) return;

  fuse_reply_err(req, 0);
}

void networkfs_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
                     struct fuse_file_info* fi) {
  networkfs_flush(req, ino, fi);
}

void networkfs_setattr(fuse_req_t req, fuse_ino_t ino, struct stat* attr,
                       int to_set, struct fuse_file_info* fi) {
  if (!entries_attr.count(ino)) {
    fuse_reply_err(req, ENOENT);
    return;
  }

  struct stat& cur_attr = entries_attr[ino];

  if (to_set & FUSE_SET_ATTR_SIZE && S_ISREG(cur_attr.st_mode)) {
    if (fi && fi->fh) {
      auto* buffer = reinterpret_cast<file_buffer*>(fi->fh);
      size_t new_size = attr->st_size;
      char* new_buffer = nullptr;
      if (new_size > 0) {
        new_buffer = new char[new_size]();
        if (buffer->data) {
          size_t copy_size = std::min(buffer->size, new_size);
          memcpy(new_buffer, buffer->data, copy_size);
        }
      }
      delete[] buffer->data;
      buffer->data = new_buffer;
      buffer->size = new_size;

      std::string content;
      if (buffer->size > 0) content = std::string(buffer->data, buffer->size);

      std::vector<std::pair<std::string, std::string>> args = {
            {"inode", std::to_string(ino_fs(ino))},
            {"content", content},
      };

      int64_t status = networkfs_http_call(
        token, "write", nullptr, 0, args);

      if (status_processing(status, req)) return;
    }
    cur_attr.st_size = attr->st_size;
    cur_attr.st_blocks = (attr->st_size + BLOCK_SIZE - 1) / BLOCK_SIZE;
    cur_attr.st_mtime = time(nullptr);
  }

  if (to_set & FUSE_SET_ATTR_MODE) cur_attr.st_mode = attr->st_mode;
  if (to_set & FUSE_SET_ATTR_UID) cur_attr.st_uid = attr->st_uid;
  if (to_set & FUSE_SET_ATTR_GID) cur_attr.st_gid = attr->st_gid;
  if (to_set & FUSE_SET_ATTR_ATIME) cur_attr.st_atime = attr->st_atime;
  if (to_set & FUSE_SET_ATTR_MTIME) cur_attr.st_mtime = attr->st_mtime;
  if (to_set & FUSE_SET_ATTR_CTIME) cur_attr.st_ctime = attr->st_ctime;

  fuse_reply_attr(req, &cur_attr, 0.0);
}

void networkfs_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t newparent,
                    const char* name) {
  std::vector<std::pair<std::string, std::string>> args = {
        {"source", std::to_string(ino_fs(ino))},
        {"parent", std::to_string(ino_fs(newparent))},
        {"name", name},
  };

  int64_t status = networkfs_http_call(
    token, "link", nullptr, 0, args);

  if (status_processing(status, req)) return;

  init_entries_attr(ino, DT_REG);
  entries_attr[ino].st_nlink++;
  entries_attr[ino].st_ctime = time(nullptr);

  fuse_entry_param e;
  set_entry_param(&e, ino, entries_attr[ino], 1.0);

  fuse_reply_entry(req, &e);
}

void networkfs_forget(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup) {
  (void)ino;
  (void)nlookup;
  fuse_reply_none(req);
}

const struct fuse_lowlevel_ops networkfs_oper = {
    .init = networkfs_init,
    .destroy = networkfs_destroy,
    .lookup = networkfs_lookup,
    .forget = networkfs_forget,
    .getattr = networkfs_getattr,
    .setattr = networkfs_setattr,
    .mkdir = networkfs_mkdir,
    .unlink = networkfs_unlink,
    .rmdir = networkfs_rmdir,
    .link = networkfs_link,
    .open = networkfs_open,
    .read = networkfs_read,
    .write = networkfs_write,
    .flush = networkfs_flush,
    .release = networkfs_release,
    .fsync = networkfs_fsync,
    .readdir = networkfs_iterate,
    .create = networkfs_create,
};