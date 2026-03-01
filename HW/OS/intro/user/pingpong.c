#include "kernel/types.h"
#include "user/user.h"

void get_and_print_msg(int fd, char* buf) {
  int n;
  int first_print = 1;
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    if (first_print) {
      printf("%d: got %s", getpid(), buf);
      first_print = 0;
    } else {
      printf("%s", buf);
    }
  }
  if (n < 0) {
    fprintf(2, "read error\n");
    exit(1);
  }
  printf("\n");
}

void send_msg(int fd, char* msg) {
  if (write(fd, msg, strlen(msg)) != strlen(msg)) {
    fprintf(2, "write error\n");
    exit(1);
  }
}

void close_fd(int fd) {
  if (close(fd) < 0) {
    fprintf(2, "close error\n");
    exit(1);
  }
}

int main(void) {
  int fd1[2];  // child -> parent
  int fd2[2];  // parent -> child
  char buf[512];

  if (pipe(fd1) < 0 || pipe(fd2) < 0) {
    fprintf(2, "pipe error\n");
    exit(1);
  }

  int pid = fork();

  if (pid == -1) {
    fprintf(2, "fork error\n");
    exit(1);
  } else if (pid == 0) {
    close_fd(fd1[0]);
    close_fd(fd2[1]);

    get_and_print_msg(fd2[0], buf);

    close_fd(fd2[0]);

    char* msg = "pong";
    send_msg(fd1[1], msg);

    close_fd(fd1[1]);
  } else {
    close_fd(fd1[1]);
    close_fd(fd2[0]);

    char* msg = "ping";
    send_msg(fd2[1], msg);

    close_fd(fd2[1]);

    get_and_print_msg(fd1[0], buf);

    close_fd(fd1[0]);
  }

  exit(0);
}
