// Copyright 2025 Burr Etienne
#ifndef SRC_CAT_INCLUDES_MAIN_H_
#define SRC_CAT_INCLUDES_MAIN_H_

#include <getopt.h>   // Command line option parsing
#include <stdbool.h>  // Boolean type
#include <stdio.h>    // Standard input/output
#include <string.h>   // String manipulation

// Struct to hold command line flags
typedef struct CLIFlags {
  bool number_nonblank;  // -b --number-nonblank
  bool squeeze_blank;    // -s --squeeze-blank
  bool number;           // -n --number
  bool ends;             // -E and -e
  bool tabs;             // -T and -t
  bool view;             // -v and with -t or -e
} CLIFlags;

// Enum to hold return codes
typedef enum ReturnCode {
  RETURN_CODE_OK,                    // All operations successful
  RETURN_CODE_ERROR,                 // General error
  RETURN_CODE_ERROR_NULL,            // Null pointer error
  RETURN_CODE_ERROR_NF_FILE_OR_DIR,  // No such file or directory
} ReturnCode;

extern const char *kShortGetoptFlags;  // Short flags
// Long flags
extern const struct option kLongGetoptFlags[];

// Application name macros
#define APP_NAME_MACRO "s21_cat"

// Print usage error macros when invalid flag is encountered
// Prints usage error message to stderr
#define PRINT_USAGE_ERROR_MACRO                                     \
  do {                                                              \
    fprintf(stderr, "Usage: %s [-%s] [file ...]\n", APP_NAME_MACRO, \
            kShortGetoptFlags);                                     \
  } while (false)

// Print no such file or directory error macros when file or directory is not
// found prints no such file or directory error message to stderr
#define PRINT_NF_FILE_ERROR_MACRO(path_to_dir_file)                        \
  do {                                                                     \
    const char *result;                                                    \
    /*Checking for null pointer to avoid segmentation fault*/              \
    if (path_to_dir_file != NULL) {                                        \
      result = path_to_dir_file;                                           \
    } else {                                                               \
      result = "(null)";                                                   \
    }                                                                      \
    fprintf(stderr, "%s: %s: No such file or directory\n", APP_NAME_MACRO, \
            result);                                                       \
  } while (false)

// Parse command line flags
// argc: argument count
// argv: argument vector
// short_flags: short flags
// long_flags: long flags
// cli_flags: pointer to CLIFlags struct
// returns: RETURN_CODE_OK on success, RETURN_CODE_ERROR on failure
// If any of the arguments are NULL, returns RETURN_CODE_ERROR_NULL
// If an invalid flag is encountered, prints usage error and returns
// RETURN_CODE_ERROR if a valid flag is encountered, sets the corresponding
// field in cli_flags to true
int getopt_parse_flags(const int argc, char *argv[], const char *short_flags,
                       const struct option *long_flags, CLIFlags *cli_flags);

// Perform file operation
// file_path: path to the file
// cli_flags: pointer to CLIFlags struct
// returns: RETURN_CODE_OK on success, RETURN_CODE_ERROR on failure
// if file_path is NULL, returns RETURN_CODE_ERROR_NULL
// if file_path is "-", reads from stdin
// if file_path is a valid file, opens the file and reads from it
// if file_path is not a valid file, prints no such file or directory error and
// returns RETURN_CODE_ERROR_NF_FILE_OR_DIR if file_path is a valid file, closes
// the file after reading if file_path is stdin, does not close the file
int file_operation(const char *file_path, const CLIFlags *cli_flags);

// Print file function
// file: pointer to the file to be printed
// cli_flags: pointer to CLIFlags struct
// returns: RETURN_CODE_OK on success, RETURN_CODE_ERROR on failure
// If file is NULL or cli_flags is NULL, returns RETURN_CODE_ERROR_NULL
// If file is a valid file, prints its contents according to cli_flags
int print_file(FILE *file, const CLIFlags *cli_flags);

#endif  // SRC_CAT_INCLUDES_MAIN_H_
