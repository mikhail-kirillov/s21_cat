#include "includes/main.h"

int getopt_parse_flags(const int argc, char *argv[], const char *short_flags,
                       const struct option *long_flags, CLIFlags *cli_flags) {
  if (short_flags == NULL || long_flags == NULL || cli_flags == NULL ||
      argv == NULL) {
    return RETURN_CODE_ERROR_NULL;
  }

  int ch = 0;
  while ((ch = getopt_long(argc, argv, short_flags, long_flags, NULL)) != -1) {
    switch (ch) {
      case 'b':
        cli_flags->number = true;
        cli_flags->number_nonblank = true;
        break;
      case 'e':
        cli_flags->ends = true;
        cli_flags->view = true;
        break;
      case 'E':
        cli_flags->ends = true;
        break;
      case 'n':
        cli_flags->number = true;
        break;
      case 's':
        cli_flags->squeeze_blank = true;
        break;
      case 't':
        cli_flags->tabs = true;
        cli_flags->view = true;
        break;
      case 'T':
        cli_flags->tabs = true;
        break;
      case 'v':
        cli_flags->view = true;
        break;
      case '?':
      default:
        PRINT_USAGE_ERROR_MACRO;
        return RETURN_CODE_ERROR;
        break;
    }
  }

  return RETURN_CODE_OK;
}

int file_operation(const char *file_path, const CLIFlags *cli_flags) {
  if (file_path == NULL || cli_flags == NULL) {
    return RETURN_CODE_ERROR_NULL;
  }

  FILE *file = NULL;
  if (strcmp(file_path, "-") == 0) {
    file = stdin;
    if (file == NULL) {
      return RETURN_CODE_ERROR;
    }
  } else {
    file = fopen(file_path, "r");
    if (file == NULL) {
      return RETURN_CODE_ERROR_NF_FILE_OR_DIR;
    }
  }

  int result_code = print_file(file, cli_flags);
  if (result_code != RETURN_CODE_OK) {
    return result_code;
  }

  if (file != stdin) {
    fclose(file);
  }

  return RETURN_CODE_OK;
}

int print_file(FILE *file, const CLIFlags *cli_flags) {
  if (file == NULL || cli_flags == NULL) {
    return RETURN_CODE_ERROR_NULL;
  }

  int line_number = 0;
  int blank_lines = 0;
  char prev_char = '\n';

  int ch = 0;
  while ((ch = fgetc(file)) != EOF) {
    char current_char = (char)ch;

    bool is_line_blank = (current_char == '\n' && prev_char == '\n');
    if (is_line_blank) {
      blank_lines++;
    } else {
      blank_lines = 0;
    }

    if (cli_flags->squeeze_blank && blank_lines > 1) {
      continue;
    }

    if (cli_flags->number && prev_char == '\n') {
      if (cli_flags->number_nonblank == true) {
        if (is_line_blank == false) {
          line_number++;
          printf("%6d\t", line_number);
        } else {
          printf("      \t");
        }
      } else if (cli_flags->number_nonblank == false) {
        line_number++;
        printf("%6d\t", line_number);
      }
    }

    if (cli_flags->tabs && current_char == '\t') {
      printf("^I");
    } else if (cli_flags->ends && current_char == '\n') {
      printf("$\n");
    } else if (cli_flags->view && (int)current_char < 32 &&
               current_char != '\n' && current_char != '\t') {
      printf("^%c", current_char + 64);
    } else if (cli_flags->view && current_char == 127) {
      printf("^?");
    } else {
      printf("%c", current_char);
    }

    prev_char = current_char;
  }

  return RETURN_CODE_OK;
}

int main(int argc, char *argv[]) {
  CLIFlags cli_flags = {
      .number_nonblank = false,
      .squeeze_blank = false,
      .number = false,
      .ends = false,
      .tabs = false,
      .view = false,
  };

  int return_code = getopt_parse_flags(argc, argv, kShortGetoptFlags,
                                       kLongGetoptFlags, &cli_flags);
  if (return_code != RETURN_CODE_OK) {
    return return_code;
  }

  if (optind >= argc) {
    return_code = file_operation("-", &cli_flags);
    if (return_code != RETURN_CODE_OK) {
      return return_code;
    }
  }

  for (int i = optind; i < argc; i++) {
    if (strcmp(argv[i], "-") == 0) {
      return_code = file_operation("-", &cli_flags);
    } else {
      return_code = file_operation(argv[i], &cli_flags);
    }

    if (return_code == RETURN_CODE_ERROR_NF_FILE_OR_DIR ||
        return_code == RETURN_CODE_OK) {
      continue;
    } else {
      return return_code;
    }
  }

  return RETURN_CODE_OK;
}
