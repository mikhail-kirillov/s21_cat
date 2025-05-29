#include "../../includes/main.h"
#include <check.h>
#include <stdlib.h>
#include <unistd.h>

// --- Тесты для getopt_parse_flags ---

START_TEST(test_getopt_parse_flags_null_args)
{
    CLIFlags flags;
    ck_assert_int_eq(getopt_parse_flags(0, NULL, kShortGetoptFlags, kLongGetoptFlags, &flags), RETURN_CODE_ERROR_NULL);
    ck_assert_int_eq(getopt_parse_flags(0, NULL, NULL, kLongGetoptFlags, &flags), RETURN_CODE_ERROR_NULL);
    ck_assert_int_eq(getopt_parse_flags(0, NULL, kShortGetoptFlags, NULL, &flags), RETURN_CODE_ERROR_NULL);
    ck_assert_int_eq(getopt_parse_flags(0, NULL, kShortGetoptFlags, kLongGetoptFlags, NULL), RETURN_CODE_ERROR_NULL);
}
END_TEST

START_TEST(test_getopt_parse_flags_valid_flags)
{
    CLIFlags flags = {0};
    char *argv[] = {"prog", "-b", "-n", "-s", "-E", "-T", "-v", "-e", "-t"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    ck_assert_int_eq(getopt_parse_flags(argc, argv, kShortGetoptFlags, kLongGetoptFlags, &flags), RETURN_CODE_OK);
    ck_assert(flags.number_nonblank);
    ck_assert(flags.number);
    ck_assert(flags.squeeze_blank);
    ck_assert(flags.ends);
    ck_assert(flags.tabs);
    ck_assert(flags.view);
}
END_TEST

START_TEST(test_getopt_parse_flags_invalid_flag)
{
    CLIFlags flags = {0};
    char *argv[] = {"prog", "-z"};
    int argc = 2;
    ck_assert_int_eq(getopt_parse_flags(argc, argv, kShortGetoptFlags, kLongGetoptFlags, &flags), RETURN_CODE_ERROR);
}
END_TEST

// --- Тесты для file_operation ---

START_TEST(test_file_operation_null_args)
{
    CLIFlags flags = {0};
    ck_assert_int_eq(file_operation(NULL, &flags), RETURN_CODE_ERROR_NULL);
    ck_assert_int_eq(file_operation("main.c", NULL), RETURN_CODE_ERROR_NULL);
}
END_TEST

START_TEST(test_file_operation_nonexistent_file)
{
    CLIFlags flags = {0};
    ck_assert_int_eq(file_operation("definitely_no_such_file_123.txt", &flags), RETURN_CODE_ERROR_NF_FILE_OR_DIR);
}
END_TEST

START_TEST(test_file_operation_stdin)
{
    CLIFlags flags = {0};
    // Подменяем stdin на временный файл
    FILE *tmp = tmpfile();
    fputs("test\n", tmp);
    rewind(tmp);
    int old_stdin = dup(STDIN_FILENO);
    dup2(fileno(tmp), STDIN_FILENO);
    ck_assert_int_eq(file_operation("-", &flags), RETURN_CODE_OK);
    dup2(old_stdin, STDIN_FILENO);
    fclose(tmp);
}
END_TEST

START_TEST(test_file_operation_regular_file)
{
    CLIFlags flags = {0};
    FILE *tmp = tmpfile();
    fputs("abc\n", tmp);
    fflush(tmp);
    char fname[] = "test_file_XXXXXX";
    int fd = mkstemp(fname);
    FILE *f = fdopen(fd, "w");
    fputs("abc\n", f);
    fclose(f);
    ck_assert_int_eq(file_operation(fname, &flags), RETURN_CODE_OK);
    remove(fname);
}
END_TEST

// --- Тесты для print_file ---

START_TEST(test_print_file_null_args)
{
    CLIFlags flags = {0};
    ck_assert_int_eq(print_file(NULL, &flags), RETURN_CODE_ERROR_NULL);
    FILE *tmp = tmpfile();
    ck_assert_int_eq(print_file(tmp, NULL), RETURN_CODE_ERROR_NULL);
    fclose(tmp);
}
END_TEST

START_TEST(test_print_file_basic)
{
    CLIFlags flags = {0};
    FILE *tmp = tmpfile();
    fputs("line1\nline2\n", tmp);
    rewind(tmp);
    ck_assert_int_eq(print_file(tmp, &flags), RETURN_CODE_OK);
    fclose(tmp);
}
END_TEST

START_TEST(test_print_file_flags)
{
    CLIFlags flags = {.number = true, .ends = true, .tabs = true, .view = true, .squeeze_blank = true, .number_nonblank = true};
    FILE *tmp = tmpfile();
    fputs("\t\n\nabc\n", tmp);
    rewind(tmp);
    ck_assert_int_eq(print_file(tmp, &flags), RETURN_CODE_OK);
    fclose(tmp);
}
END_TEST

Suite *cat_suite_create(void)
{
    Suite *suite = suite_create("cat");
    TCase *tc_flags = tcase_create("Flags");
    tcase_add_test(tc_flags, test_getopt_parse_flags_null_args);
    tcase_add_test(tc_flags, test_getopt_parse_flags_valid_flags);
    tcase_add_test(tc_flags, test_getopt_parse_flags_invalid_flag);
    suite_add_tcase(suite, tc_flags);

    TCase *tc_file = tcase_create("File");
    tcase_add_test(tc_file, test_file_operation_null_args);
    tcase_add_test(tc_file, test_file_operation_nonexistent_file);
    tcase_add_test(tc_file, test_file_operation_stdin);
    tcase_add_test(tc_file, test_file_operation_regular_file);
    suite_add_tcase(suite, tc_file);

    TCase *tc_print = tcase_create("Print");
    tcase_add_test(tc_print, test_print_file_null_args);
    tcase_add_test(tc_print, test_print_file_basic);
    tcase_add_test(tc_print, test_print_file_flags);
    suite_add_tcase(suite, tc_print);

    return suite;
}

int main(void)
{
    Suite *suite = cat_suite_create();
    SRunner *sr = srunner_create(suite);
    srunner_run_all(sr, CK_NORMAL);
    int failed = srunner_ntests_failed(sr);
    srunner_free(sr);
    return (failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}