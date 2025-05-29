// Copyright 2025 Burr Etienne
#include "includes/main.h"

const char *kShortGetoptFlags = "bvnEsTte";
const struct option kLongGetoptFlags[] = {
    {"number-nonblank", no_argument, 0, 'b'},
    {"squeeze-blank", no_argument, 0, 's'},
    {"number", no_argument, 0, 'n'},
    {NULL, 0, 0, 0},
};

int getopt_parse_flags(const int argc, char *argv[], const char *short_flags,
                       const struct option *long_flags, CLIFlags *cli_flags) {
  if (short_flags == NULL || long_flags == NULL || cli_flags == NULL ||
      argv == NULL) {
    // Check for null pointers to avoid segmentation fault. If any of the
    // arguments are NULL, return RETURN_CODE_ERROR_NULL
    return RETURN_CODE_ERROR_NULL;
  }

  // Parse command line arguments using getopt_long
  // Initialize the CLIFlags struct with parsed values
  int ch = 0;
  while ((ch = getopt_long(argc, argv, short_flags, long_flags, NULL)) != -1) {
    switch (ch) {
      case 'b':
        // --number-nonblank
        cli_flags->number = true;
        cli_flags->number_nonblank = true;
        break;
      case 'e':
        // --ends
        cli_flags->ends = true;
        cli_flags->view = true;
        break;
      case 'E':
        // --ends without -v
        cli_flags->ends = true;
        break;
      case 'n':
        // --number
        cli_flags->number = true;
        break;
      case 's':
        // --squeeze-blank
        cli_flags->squeeze_blank = true;
        break;
      case 't':
        // --tabs
        cli_flags->tabs = true;
        cli_flags->view = true;
        break;
      case 'T':
        // --tabs without -v
        cli_flags->tabs = true;
        break;
      case 'v':
        // --view
        cli_flags->view = true;
        break;
      // Other unrecognized flags or cases
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
    // Check for null pointers to avoid segmentation fault. If any of the
    // arguments are NULL, return RETURN_CODE_ERROR_NULL
    return RETURN_CODE_ERROR_NULL;
  }

  FILE *file = NULL;
  if (strcmp(file_path, "-") == 0) {
    // If the file path is "-", read from stdin
    file = stdin;
    if (file == NULL) {
      return RETURN_CODE_ERROR;
    }
  } else {
    // Otherwise, open the file for reading
    file = fopen(file_path, "r");
    if (file == NULL) {
      // Check if the file exists and is accessible
      return RETURN_CODE_ERROR_NF_FILE_OR_DIR;
    }
  }

  // Perform file operations printing the contents of the file to stdout
  // using the specified CLI flags
  int result_code = print_file(file, cli_flags);
  if (result_code != RETURN_CODE_OK) {
    // If the file operation fails, return the error code
    return result_code;
  }

  if (file != stdin) {
    // If the file is not stdin, close the file to free up resources
    fclose(file);
  }

  return RETURN_CODE_OK;
}

int print_file(FILE *file, const CLIFlags *cli_flags) {
  if (file == NULL || cli_flags == NULL) {
    // Check for null pointers to avoid segmentation fault. If any of the
    // arguments are NULL, return RETURN_CODE_ERROR_NULL
    return RETURN_CODE_ERROR_NULL;
  }

  int line_number = 0;    // Initialize line number to 0
  int blank_lines = 0;    // Initialize blank lines to 0
  char prev_char = '\n';  // Initialize previous character to newline

  int ch = 0;  // Variable to store the character read from the file. Read
               // characters from the file until EOF
  while ((ch = fgetc(file)) != EOF) {
    char current_char = (char)ch;  // Cast the character to char type

    // Check if the line is blank
    bool is_line_blank = (current_char == '\n' && prev_char == '\n');
    if (is_line_blank) {
      // If the line is blank, increment the blank lines counter
      blank_lines++;
    } else {
      // If the line is not blank, reset the blank lines counter
      blank_lines = 0;
    }

    if (cli_flags->squeeze_blank && blank_lines > 1) {
      // If the -s flag is set and there are more than 1 blank lines, skip
      // printing the blank lines. This is to avoid printing multiple blank
      // lines in a row
      continue;
    }

    if (cli_flags->number && prev_char == '\n') {
      // If the -n or -b flag is set, print the line number
      if (cli_flags->number_nonblank == true) {
        // If the -b flag is set, print the line number only for non-blank lines
        if (is_line_blank == false) {
          // If the line is not blank, print the line number
          line_number++;
          printf("%6d\t", line_number);
        } else {
          // If the line is blank, print a tab character. to maintain the
          // alignment of the line numbers
          printf("      \t");
        }
      } else if (cli_flags->number_nonblank == false) {
        // If the -n flag is set, print the line number for all lines
        line_number++;
        printf("%6d\t", line_number);
      }
    }

    if (cli_flags->tabs && current_char == '\t') {
      // If the -T or -t flag is set, print ^I for tab characters
      printf("^I");
    } else if (cli_flags->ends && current_char == '\n') {
      // If the -E or -e flag is set, print $ at the end of each line
      printf("$\n");
    } else if (cli_flags->view && (int)current_char < 32 &&
               current_char != '\n' && current_char != '\t') {
      // If the -v flag is set, print control characters
      printf("^%c", current_char + 64);
    } else if (cli_flags->view && current_char == 127) {
      // If the -v flag is set, print DEL character as ^?
      printf("^?");
    } else {
      // Otherwise, print the default characters
      printf("%c", current_char);
    }

    // Update the previous character to the current character
    prev_char = current_char;
  }

  return RETURN_CODE_OK;
}
