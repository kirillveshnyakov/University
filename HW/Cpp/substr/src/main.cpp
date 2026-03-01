#include <cstdio>
#include <cstdlib>
#include <cstring>

static int find_new_prefix(int prefix_len, char char_symbol, const char* str, int* pf) {
  while (prefix_len > 0 && char_symbol != str[prefix_len]) {
    prefix_len = pf[prefix_len - 1];
  }
  return (char_symbol == str[prefix_len]) ? (prefix_len + 1) : 0;
}

int main(int argc, char* argv[]) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s <file_path> <string>\n", argv[0]);
    return EXIT_FAILURE;
  }

  const char* str = argv[2];
  size_t str_len = strlen(str);

  if (str_len == 0) {
    puts("Yes");
    return EXIT_SUCCESS;
  }

  const char* file_path = argv[1];
  FILE* fd = fopen(file_path, "rb");
  if (!fd) {
    fputs("error: open file failed\n", stderr);
    return EXIT_FAILURE;
  }

  int* pf = static_cast<int*>(malloc(str_len * sizeof(int)));
  int last_prefix_len = 0;
  pf[0] = 0;

  for (size_t ind = 1; ind < str_len; ind++) {
    last_prefix_len = find_new_prefix(last_prefix_len, str[ind], str, pf);
    pf[ind] = last_prefix_len;
  }

  int symbol;
  bool found = false;
  last_prefix_len = 0;

  while ((symbol = fgetc(fd)) != EOF) {
    unsigned char c = static_cast<unsigned char>(symbol);
    last_prefix_len = find_new_prefix(last_prefix_len, static_cast<char>(c), str, pf);
    if (last_prefix_len == str_len) {
      found = true;
      break;
    }
  }

  free(pf);

  if (ferror(fd)) {
    perror("io error");
    return EXIT_FAILURE;
  }
  if (fclose(fd)) {
    fputs("file close err\n", stderr);
    return EXIT_FAILURE;
  }
  puts(found ? "Yes" : "No");
  return EXIT_SUCCESS;
}
