// Copyright 2025 Burr Etienne
#include "includes/main.h"

int main(int argc, char *argv[]) {
  // Initialize the CLIFlags struct with default values
  CLIFlags cli_flags = {
      .number_nonblank = false,
      .squeeze_blank = false,
      .number = false,
      .ends = false,
      .tabs = false,
      .view = false,
  };

  // Parse command line arguments
  int return_code = getopt_parse_flags(argc, argv, kShortGetoptFlags,
                                       kLongGetoptFlags, &cli_flags);
  if (return_code != RETURN_CODE_OK) {
    // If parsing fails, print usage error and return
    return return_code;
  }

  if (optind >= argc) {
    // If no files are specified, read from stdin
    return_code = file_operation("-", &cli_flags);
    if (return_code != RETURN_CODE_OK) {
      return return_code;
    }
  }

  // Iterate through the remaining command line arguments (file paths) and
  // perform file operations If a file path is "-", read from stdin
  for (int i = optind; i < argc; i++) {
    if (strcmp(argv[i], "-") == 0) {
      // Check if the file path is "-", indicating stdin
      return_code = file_operation("-", &cli_flags);
    } else {
      // Otherwise, open the file and perform operations
      return_code = file_operation(argv[i], &cli_flags);
    }

    if (return_code == RETURN_CODE_ERROR_NF_FILE_OR_DIR ||
        return_code == RETURN_CODE_OK) {
      // If the file operation fails, print an error message and continue to the
      // next file
      continue;
    } else {
      // If the file operation fail with a different error code, return the
      // error code
      return return_code;
    }
  }

  return RETURN_CODE_OK;
}
