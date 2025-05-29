# ============================ CC and Flags ============================ #

CC = gcc
DEBUG_FLAGS = -g -O0
CPPLINT_FLAGS = --extensions=c,h

ifeq ($(shell uname), Darwin)
	TEST_LIBS = -lcheck -lm
else
	TEST_LIBS = -lcheck -lsubunit -lm
endif

TESTING_FLAGS = -g \
                -fsanitize=address \
                -fsanitize=undefined \
                -fsanitize=float-divide-by-zero \
                -fsanitize=float-cast-overflow \
                -fsanitize=integer-divide-by-zero \
                -fsanitize=object-size \
                -fsanitize=alignment \
                -fsanitize=vptr \
				-O1

CPPCHECK_FLAGS = --enable=all \
				--check-level=exhaustive \
				--inconclusive \
				--std=c11 \
				--force \
				--language=c \
				--inline-suppr \
				--suppress=checkersReport \
				--max-configs=10 \
				--max-ctu-depth=10 \
				--platform=unix64 \
				--verbose

VALGRIND_FLAGS = -s \
				--tool=memcheck \
				--leak-check=full \
				--show-leak-kinds=all \
				--track-origins=yes \
				--show-reachable=yes \
				--malloc-fill=0xAA \
				--free-fill=0x55 \
				--partial-loads-ok=no \
				--errors-for-leak-kinds=all \
				--error-exitcode=1 \
				--gen-suppressions=all \
				--smc-check=all \
				--expensive-definedness-checks=yes \
				--fair-sched=yes \
				--read-var-info=yes \
				--undef-value-errors=yes \
				--error-limit=no \
				--log-file=$(VALGRIND_LOG_FILE_NAME)

COMPILING_FLAGS = -std=c11 \
					-Wall \
					-Wextra \
					-Wpedantic \
					-Werror \
					-Waggregate-return \
					-Walloca \
					-Warray-bounds \
					-Wattributes \
					-Wbad-function-cast \
					-Wcast-align \
					-Wcast-qual \
					-Wchar-subscripts \
					-Wcomment \
					-Wconversion \
					-Wdeprecated-declarations \
					-Wdiv-by-zero \
					-Wdouble-promotion \
					-Wempty-body \
					-Wendif-labels \
					-Wenum-compare \
					-Wfloat-equal \
					-Wformat \
					-Wformat-extra-args \
					-Wformat-nonliteral \
					-Wformat-security \
					-Wformat-signedness \
					-Wformat-zero-length \
					-Wignored-qualifiers \
					-Wimplicit-fallthrough \
					-Wimplicit-function-declaration \
					-Wimplicit-int \
					-Winit-self \
					-Wint-conversion \
					-Wmissing-braces \
					-Wmissing-declarations \
					-Wmissing-field-initializers \
					-Wmissing-include-dirs \
					-Wmissing-noreturn \
					-Wmultichar \
					-Wnested-externs \
					-Wnull-dereference \
					-Woverflow \
					-Woverlength-strings \
					-Wpacked \
					-Wparentheses \
					-Wpointer-arith \
					-Wredundant-decls \
					-Wreturn-type \
					-Wsequence-point \
					-Wshadow \
					-Wsign-compare \
					-Wsign-conversion \
					-Wstack-protector \
					-Wstrict-aliasing \
					-Wstrict-prototypes \
					-Wswitch \
					-Wswitch-default \
					-Wswitch-enum \
					-Wtrigraphs \
					-Wtype-limits \
					-Wundef \
					-Wuninitialized \
					-Wunused \
					-Wunused-parameter \
					-Wunused-function \
					-Wunused-variable \
					-Wunused-value \
					-Wvariadic-macros \
					-Wwrite-strings \
					-Wvla

# ============================ CC and Flags ============================ #





# ============================ Names ============================ #

BINARY_NAME = s21_cat
TEST_DIRECTORY_NAME = tests
OBJECT_DIRECTORY_NAME = obj
BINARY_DIRECTORY_NAME = bin
CCPLINT_LOG_FILE_NAME = cpplint.log
TEST_FORWARD_FILE_NAME = forward.txt
CPPCHECK_LOG_FILE_NAME = cppcheck.log
VALGRIND_LOG_FILE_NAME = valgrind.log
TEST_BINARY_NAME = test_$(BINARY_NAME)
TEST_BACKWARD_FILE_NAME = backward.txt
DEBUG_BINARY_NAME = debug_$(BINARY_NAME)
COVERAGE_DIRECTORY_NAME = coverage-report
COVERAGE_OUTPUT_FILE_NAME = coverage.info
TEST_FILE_NAME_TO_RUN_TESTS_FORWARD = $(TEST_DIRECTORY_NAME)/scripts/$(TEST_FORWARD_FILE_NAME)
TEST_FILE_NAME_TO_RUN_TESTS_BACKWARD = $(TEST_DIRECTORY_NAME)/scripts/$(TEST_BACKWARD_FILE_NAME)

REMOVE_FILES_NAME_FOR_CLEAN = $(OBJECT_DIRECTORY_NAME) \
							$(BINARY_DIRECTORY_NAME) \
							$(VALGRIND_LOG_FILE_NAME) \
							$(COVERAGE_OUTPUT_FILE_NAME) \
							$(COVERAGE_DIRECTORY_NAME) \
							*.gcda \
							*.gcno \
							*.gcov \
							*.info \
							$(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) \
							$(TEST_FILE_NAME_TO_RUN_TESTS_BACKWARD) \
							$(CCPLINT_LOG_FILE_NAME) \
							$(CPPCHECK_LOG_FILE_NAME) \

# ============================ Names ============================ #





# ============================ Files and Paths ============================ #

SOURCE_FILES = $(wildcard *.c)
INCLUDE_FILES = $(wildcard includes/*.h)
TEST_SOURCE_FILES = $(wildcard $(TEST_DIRECTORY_NAME)/check/*.c)

BINARY_FILE_PATH = $(BINARY_DIRECTORY_NAME)/$(BINARY_NAME)
TEST_BINARY_PATH = $(BINARY_DIRECTORY_NAME)/$(TEST_BINARY_NAME)
DEBUG_BINARY_PATH = $(BINARY_DIRECTORY_NAME)/$(DEBUG_BINARY_NAME)
OBJECT_FILES_PATH = $(patsubst %.c,$(OBJECT_DIRECTORY_NAME)/%.o,$(SOURCE_FILES))

# ============================ Files and Paths ============================ #





# ============================ Colors ============================ #

COLOR_RED = \033[1;31m
COLOR_BLUE = \033[1;34m
COLOR_GREEN = \033[1;32m
COLOR_YELLOW = \033[1;33m


COLOR_RESET = \033[0m

# ============================ Colors ============================ #





# ============================ Targets ============================ #

.PHONY: all dirs bin test debug format cpplint cppcheck coverage lldb valgrind check clean rebuild help



all: bin
	@echo "$(COLOR_YELLOW)Building all...$(COLOR_RESET)"
	@echo "$(COLOR_GREEN)All built!$(COLOR_RESET)"
	@echo ""


dirs:
	@echo "$(COLOR_YELLOW)Make dirs...$(COLOR_RESET)"
	@mkdir -p $(BINARY_DIRECTORY_NAME)
	@mkdir -p $(OBJECT_DIRECTORY_NAME)
	@echo "$(COLOR_GREEN)Dirs created!$(COLOR_RESET)"
	@echo ""


$(OBJECT_DIRECTORY_NAME)/%.o: %.c $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Compiling object file $@...$(COLOR_RESET)"
	@$(CC) $(COMPILING_FLAGS) -c $< -o $@
	@echo "$(COLOR_GREEN)Object file compiled!$(COLOR_RESET)"
	@echo ""


bin: dirs $(OBJECT_FILES_PATH)
	@echo "$(COLOR_YELLOW)Building binary...$(COLOR_RESET)"
	@$(CC) $(OBJECT_FILES_PATH) -o $(BINARY_FILE_PATH)
	@echo "$(COLOR_GREEN)Binary built!$(COLOR_RESET)"
	@echo ""


test: dirs $(SOURCE_FILES) $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Building test binary...$(COLOR_RESET)"
	@$(CC) $(COMPILING_FLAGS) $(TESTING_FLAGS) $(SOURCE_FILES) -o $(TEST_BINARY_PATH)
	@echo "$(COLOR_GREEN)Test binary built!$(COLOR_RESET)"
	@echo ""


debug: dirs $(SOURCE_FILES) $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Building debug binary...$(COLOR_RESET)"
	@$(CC) $(COMPILING_FLAGS) $(DEBUG_FLAGS) $(SOURCE_FILES) -o $(DEBUG_BINARY_PATH)
	@echo "$(COLOR_GREEN)Debug binary built!$(COLOR_RESET)"
	@echo ""


format: $(SOURCE_FILES) $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Running clang-format...$(COLOR_RESET)"
	@clang-format --style=Google -i $(SOURCE_FILES) $(INCLUDE_FILES)
	@echo "$(COLOR_GREEN)Clang-format completed!$(COLOR_RESET)"
	@echo ""


cpplint: $(SOURCE_FILES) $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Running cpplint...$(COLOR_RESET)"
	@cpplint $(CPPLINT_FLAGS) $(SOURCE_FILES) $(INCLUDE_FILES) > $(CCPLINT_LOG_FILE_NAME) 2>&1 || true
	@echo "$(COLOR_GREEN)Cpplint completed!$(COLOR_RESET)"
	@echo ""


cppcheck: $(SOURCE_FILES) $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Running cppcheck...$(COLOR_RESET)"
	@cppcheck $(CPPCHECK_FLAGS) $(SOURCE_FILES) $(INCLUDE_FILES) > $(CPPCHECK_LOG_FILE_NAME) 2>&1 || true
	@echo "$(COLOR_GREEN)Cppcheck completed!$(COLOR_RESET)"
	@echo ""


coverage: dirs $(TEST_SOURCE_FILES) $(INCLUDE_FILES) $(SOURCE_FILES)
	@echo "$(COLOR_YELLOW)Generating code coverage...$(COLOR_RESET)"
	@cd $(TEST_DIRECTORY_NAME)/scripts && ./create_test_files.sh $(TEST_FORWARD_FILE_NAME) $(TEST_BACKWARD_FILE_NAME) > /dev/null 2>&1
	@$(CC) $(COMPILING_FLAGS) $(TESTING_FLAGS) -fprofile-arcs -ftest-coverage -o $(TEST_BINARY_PATH) $(SOURCE_FILES)
	@./$(TEST_BINARY_PATH) -bvnsteET $(TEST_FILE_NAME_TO_RUN_TESTS_BACKWARD) - < $(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) > /dev/null 2>&1
	@./$(TEST_BINARY_PATH) -bvnsteET $(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) - < $(TEST_FILE_NAME_TO_RUN_TESTS_BACKWARD) > /dev/null 2>&1
	@./$(TEST_BINARY_PATH) -bvnsteET Makefile - < $(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) > /dev/null 2>&1
	@./$(TEST_BINARY_PATH) -bvnsteET Makefile - < $(TEST_FILE_NAME_TO_RUN_TESTS_BACKWARD) > /dev/null 2>&1
	@./$(TEST_BINARY_PATH) -ERROR $(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) > /dev/null 2>&1 || true
	@./$(TEST_BINARY_PATH) -n $(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) > /dev/null 2>&1
	@./$(TEST_BINARY_PATH) < $(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) > /dev/null 2>&1
	@lcov --ignore-errors unsupported,unsupported --capture --directory . --output-file $(COVERAGE_OUTPUT_FILE_NAME) > /dev/null 2>&1
	@genhtml $(COVERAGE_OUTPUT_FILE_NAME) --output-directory $(COVERAGE_DIRECTORY_NAME) > /dev/null 2>&1
	@echo "$(COLOR_GREEN)Code coverage generated!$(COLOR_RESET)"
	@echo ""


lldb: debug
	@echo "$(COLOR_YELLOW)Running lldb...$(COLOR_RESET)"
	@$(CC) $(DEBUG_FLAGS) $(SOURCE_FILES) -o $(DEBUG_BINARY_PATH)
	@lldb ./$(DEBUG_BINARY_PATH)
	@echo "$(COLOR_GREEN)LLDB completed!$(COLOR_RESET)"
	@echo ""


valgrind: debug
	@echo "$(COLOR_YELLOW)Running Valgrind...$(COLOR_RESET)"

	@unameOut=$$(uname -s); \
	if [ "$$unameOut" = "Darwin" ]; then \
		echo "$(COLOR_RED)[WARNING] Valgrind is not supported on macOS (Darwin).$(COLOR_RESET)"; \
	else \
		valgrind $(VALGRIND_FLAGS) $(DEBUG_BINARY_PATH) -bsnet Makefile > /dev/null || true; \
		echo "$(COLOR_GREEN)Valgrind completed!$(COLOR_RESET)"; \
	fi

	@echo ""


check: bin $(TEST_SOURCE_FILES) $(INCLUDE_FILES) $(SOURCE_FILES)
	@echo "$(COLOR_BLUE)Running tests...$(COLOR_RESET)"
	@cd $(TEST_DIRECTORY_NAME)/scripts && ./run_tests.sh ../../$(BINARY_FILE_PATH) $(TEST_FORWARD_FILE_NAME) $(TEST_BACKWARD_FILE_NAME)
	@echo "$(COLOR_GREEN)Tests completed!$(COLOR_RESET)"
	@echo ""

	@echo "$(COLOR_YELLOW)Run check lib tests? [Y/n] $(COLOR_RESET)"
	@read choice; \
	if [ "$$choice" = "y" ] || [ "$$choice" = "Y" ]; then \
		echo "$(COLOR_YELLOW)Running check lib tests...$(COLOR_RESET)"; \
		$(CC) $(TEST_SOURCE_FILES) $(filter-out main.c, $(SOURCE_FILES)) $(TEST_LIBS) -o $(TEST_BINARY_PATH) && \
		./$(TEST_BINARY_PATH) 2>&1 | grep -E '^[0-9]+%: Checks:'; \
		rm -rf $(TEST_BINARY_PATH) 2> /dev/null; \
		echo "$(COLOR_GREEN)Check lib tests completed!$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_RED)Skipping check lib tests...$(COLOR_RESET)"; \
	fi
	@echo ""


rebuild: clean all
	@echo "$(COLOR_YELLOW)Rebuilding...$(COLOR_RESET)"
	@echo "$(COLOR_GREEN)Rebuild completed!$(COLOR_RESET)"
	@echo ""


clean:
	@echo "$(COLOR_RED)Cleaning...$(COLOR_RESET)"
	@rm -rf $(REMOVE_FILES_NAME_FOR_CLEAN) 2> /dev/null
	@echo "$(COLOR_GREEN)Cleaning completed!$(COLOR_RESET)"
	@echo ""


help:
	@echo "$(COLOR_YELLOW)Available commands:$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BLUE)make all$(COLOR_RESET) - Build the project"
	@echo "$(COLOR_BLUE)make dirs$(COLOR_RESET) - Create directories"
	@echo "$(COLOR_BLUE)make bin$(COLOR_RESET) - Build the binary"
	@echo "$(COLOR_BLUE)make test$(COLOR_RESET) - Build the test binary"
	@echo "$(COLOR_BLUE)make debug$(COLOR_RESET) - Build the debug binary"
	@echo "$(COLOR_BLUE)make format$(COLOR_RESET) - Format the code with clang-format"
	@echo "$(COLOR_BLUE)make cpplint$(COLOR_RESET) - Run cpplint"
	@echo "$(COLOR_BLUE)make cppcheck$(COLOR_RESET) - Run cppcheck"
	@echo "$(COLOR_BLUE)make coverage$(COLOR_RESET) - Generate code coverage report"
	@echo "$(COLOR_BLUE)make lldb$(COLOR_RESET) - Run lldb"
	@echo "$(COLOR_BLUE)make valgrind$(COLOR_RESET) - Run Valgrind"
	@echo "$(COLOR_BLUE)make check$(COLOR_RESET) - Run tests"
	@echo "$(COLOR_BLUE)make rebuild$(COLOR_RESET) - Rebuild the project"
	@echo "$(COLOR_BLUE)make clean$(COLOR_RESET) - Clean the project"
	@echo ""
	
# ============================ Targets ============================ #
