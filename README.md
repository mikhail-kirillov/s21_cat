# s21_cat

School 21 | Own version of the cat application

## Description

The **s21_cat** project is an implementation of the standard UNIX utility `cat`, supporting core flags and options, including GNU analogs. The program is written in C according to the **C11** standard using the **GCC** compiler, and adheres to the Google Style coding guidelines.

The goal of the project is to provide a functional replacement for the standard `cat` utility with full compatibility in terms of command-line flags and behavior, while ensuring high code quality, readability, test coverage, and compliance with the POSIX.1-2017 standard.

---

## Features

The `s21_cat` utility supports the following flags:

| Flag         | GNU Equivalent             | Description |
|--------------|----------------------------|-------------|
| `-b`         | `--number-nonblank`        | Numbers only non-blank lines |
| `-e`         |                            | Displays end-of-line as `$` (implies `-v`) |
| `-n`         | `--number`                 | Numbers all output lines |
| `-s`         | `--squeeze-blank`          | Compresses multiple adjacent blank lines into one |
| `-t`         |                            | Displays tabs as `^I` (implies `-v`) |
| `-v`         |                            | Shows invisible control characters (except tabs and newlines) |
| `-E`         |                            | Same as `-e`, but without `-v` |
| `-T`         |                            | Same as `-t`, but without `-v` |

The program supports reading from files and standard input (`stdin`), as well as handling multiple files sequentially.

---

## System Requirements

- Operating System: Unix-like (Linux, BSD, macOS, etc.)
- Compiler: `gcc` (supporting C11 standard)
- Build Tool: `make`
- Optional tools for testing:
  - `valgrind` (memory leak detection)
  - `cppcheck` (static code analysis)
  - `cpplint` (style guide enforcement)
  - `lcov` / `genhtml` (test coverage reporting)

---

## Building

### Basic Build

```bash
make
```

Builds the executable file `s21_cat` into the `bin/` directory.

### Clean Build Artifacts

```bash
make clean
```

Removes object files, executables, logs, and intermediate files.

### Run Tests

```bash
make check
```

Runs integration tests comparing the output of `s21_cat` against the system's `cat` utility across all flag combinations and test files.

### Additional Targets

- `make valgrind` — Runs the program through Valgrind.
- `make coverage` — Generates code coverage report.
- `make cpplint` — Checks code style.
- `make cppcheck` — Runs static code analysis.
- `make format` — Formats code using `clang-format`.

---

## Project Structure

```bash
.
├── bin/                   # Исполняемые файлы (s21_cat, тесты)
├── includes/
│   └── main.h             # Заголовочный файл с объявлениями структур и функций
├── obj/                   # Объектные файлы (.o)
├── functions.c            # Исходный файл с реализацией функций
├── main.c                 # Главный исходный файл
├── Makefile               # Сценарий сборки
├── README.md              # Документация
├── .gitignore             # Файл игнорирования для git
└── tests/
    ├── check/
    │   └── main.c         # Тесты на библиотеке check
    └── scripts/
        ├── create_test_files.sh
        ├── diff_tests_cats.sh
        └── run_tests.sh
```

---

## Input Support

- Reading from one or more files.
- Reading from `stdin` (file `"-"`).
- Support for special characters (e.g., control characters, tabs, line endings).

---

## Implementation Details

- Full compliance with the **POSIX.1-2017** standard.
- Strict adherence to the **Google C++ Style Guide**.
- Safe memory and file handling.
- Avoidance of legacy and deprecated constructs.
- Minimized code duplication.
- Support for complex flag combinations.
- Easy extensibility for adding new features.

---
