#ifndef S21_CAT_MAIN_H_
#define S21_CAT_MAIN_H_

#include <getopt.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

typedef struct CLIFlags {
  bool number_nonblank;
  bool squeeze_blank;
  bool number;
  bool ends;
  bool tabs;
  bool view;
} CLIFlags;

typedef enum ReturnCode {
  RETURN_CODE_OK,
  RETURN_CODE_ERROR,
  RETURN_CODE_ERROR_NULL,
  RETURN_CODE_ERROR_NF_FILE_OR_DIR,
} ReturnCode;

const char *kShortGetoptFlags = "bvnEsTte";
const struct option kLongGetoptFlags[] = {
    {"number-nonblank", no_argument, 0, 'b'},
    {"squeeze-blank", no_argument, 0, 's'},
    {"number", no_argument, 0, 'n'},
    {NULL, 0, 0, 0},
};

#define APP_NAME_MACRO "s21_cat"

#define PRINT_USAGE_ERROR_MACRO                                     \
  do {                                                              \
    fprintf(stderr, "Usage: %s [-%s] [file ...]\n", APP_NAME_MACRO, \
            kShortGetoptFlags);                                     \
  } while (false)

#define PRINT_NF_FILE_ERROR_MACRO(path_to_dir_file)                        \
  do {                                                                     \
    const char *result;                                                    \
    if (path_to_dir_file != NULL) {                                        \
      result = path_to_dir_file;                                           \
    } else {                                                               \
      result = "(null)";                                                   \
    }                                                                      \
    fprintf(stderr, "%s: %s: No such file or directory\n", APP_NAME_MACRO, \
            result);                                                       \
  } while (false)

int getopt_parse_flags(const int argc, char *argv[], const char *short_flags,
                       const struct option *long_flags, CLIFlags *cli_flags);
int file_operation(const char *file_path, const CLIFlags *cli_flags);
int print_file(FILE *file, const CLIFlags *cli_flags);

#endif  // S21_CAT_MAIN_H_
