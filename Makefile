# ============================ CC and Flags ============================ #

CC = gcc
DFLAGS = -g -O0

CFLAGS =	-std=c11 \
			-Wall \
			-Wextra \
			-Wpedantic \
			-Werror \
			-Walloca \
			-Wbad-function-cast \
			-Wconversion \
			-Wdouble-promotion \
			-Wnull-dereference \
			-Woverlength-strings \
			-Wstack-protector \
			-Wvla

TFLAGS =	-g \
			-fsanitize=address \
			-fsanitize=undefined \
			-fsanitize=float-divide-by-zero \
			-fsanitize=float-cast-overflow \
			-fsanitize=integer-divide-by-zero \
			-fsanitize=object-size \
			-fsanitize=alignment \
			-fsanitize=vptr \
			-O1

VALGRIND_FLAGS =	--tool=memcheck \
					--leak-check=full \
					--show-leak-kinds=all \
					--track-origins=yes \
					--show-reachable=yes \
					--malloc-fill=0xAA \
					--free-fill=0x55 \
					--partial-loads-ok=no \
					--errors-for-leak-kinds=all \
					--smc-check=all \
					--expensive-definedness-checks=yes \
					--fair-sched=yes \
					--read-var-info=yes \
					--undef-value-errors=yes \
					--error-limit=no \
					--log-file=$(VALGRIND_LOG_FILE_NAME)

# ============================ CC and Flags ============================ #





# ============================ Names ============================ #

BIN_NAME = s21_cat
OBJ_DIR_NAME = obj
BIN_DIR_NAME = bin
TEST_DIR_NAME = tests
TEST_BIN_NAME = test_$(BIN_NAME)
DEBUG_BIN_NAME = debug_$(BIN_NAME)
TEST_FORWARD_FILE_NAME = forward.txt
VALGRIND_LOG_FILE_NAME = valgrind.log
TEST_BACKWARD_FILE_NAME = backward.txt
TEST_FILE_NAME_TO_RUN_TESTS_FORWARD = $(TEST_DIR_NAME)/$(TEST_FORWARD_FILE_NAME)
TEST_FILE_NAME_TO_RUN_TESTS_BACKWARD = $(TEST_DIR_NAME)/$(TEST_BACKWARD_FILE_NAME)

REMOVE_FILES_NAME_FOR_CLEAN =	$(OBJ_DIR_NAME) \
								$(BIN_DIR_NAME) \
								$(VALGRIND_LOG_FILE_NAME) \
								$(TEST_FILE_NAME_TO_RUN_TESTS_FORWARD) \
								$(TEST_FILE_NAME_TO_RUN_TESTS_BACKWARD) \
								$(TEST_DIR_NAME)/cat_output.txt \
								$(TEST_DIR_NAME)/s21_output.txt

# ============================ Names ============================ #





# ============================ Files and Paths ============================ #

SRC_FILES = $(wildcard *.c)
INCLUDE_FILES = $(wildcard includes/*.h)

BIN_FILE_PATH = $(BIN_DIR_NAME)/$(BIN_NAME)
TEST_BIN_PATH = $(BIN_DIR_NAME)/$(TEST_BIN_NAME)
DEBUG_BIN_PATH = $(BIN_DIR_NAME)/$(DEBUG_BIN_NAME)
OBJ_FILES_PATH = $(patsubst %.c,$(OBJ_DIR_NAME)/%.o,$(SRC_FILES))

# ============================ Files and Paths ============================ #





# ============================ Colors ============================ #

COLOR_RED = \033[1;31m
COLOR_BLUE = \033[1;34m
COLOR_GREEN = \033[1;32m
COLOR_YELLOW = \033[1;33m

COLOR_RESET = \033[0m

# ============================ Colors ============================ #





# ============================ Targets ============================ #

.PHONY: all dirs bin leaks test clean



all: bin
	@echo "$(COLOR_YELLOW)Building all...$(COLOR_RESET)"
	@echo "$(COLOR_GREEN)All built!$(COLOR_RESET)"
	@echo ""


dirs:
	@echo "$(COLOR_YELLOW)Make dirs...$(COLOR_RESET)"
	@mkdir -p $(BIN_DIR_NAME)
	@mkdir -p $(OBJ_DIR_NAME)
	@echo "$(COLOR_GREEN)Dirs created!$(COLOR_RESET)"
	@echo ""


$(OBJ_DIR_NAME)/%.o: %.c $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Compiling object file $@...$(COLOR_RESET)"
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "$(COLOR_GREEN)Object file compiled!$(COLOR_RESET)"
	@echo ""


bin: dirs $(OBJ_FILES_PATH)
	@echo "$(COLOR_YELLOW)Building binary...$(COLOR_RESET)"
	@$(CC) $(OBJ_FILES_PATH) -o $(BIN_FILE_PATH)
	@echo "$(COLOR_GREEN)Binary built!$(COLOR_RESET)"
	@echo ""


leaks: dirs $(SRC_FILES) $(INCLUDE_FILES)
	@echo "$(COLOR_YELLOW)Running leaks...$(COLOR_RESET)"
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		echo "$(COLOR_YELLOW)Building debug binary for leaks...$(COLOR_RESET)"; \
		$(CC) $(CFLAGS) $(TFLAGS) $(SRC_FILES) -o $(DEBUG_BIN_PATH); \
		echo "$(COLOR_GREEN)Debug binary built!$(COLOR_RESET)"; \
		echo "$(COLOR_BLUE)Running tests...$(COLOR_RESET)"; \
		cd $(TEST_DIR_NAME) && ./run.sh ../$(DEBUG_BIN_PATH) $(TEST_FORWARD_FILE_NAME) $(TEST_BACKWARD_FILE_NAME); \
		echo "$(COLOR_GREEN)Tests completed!$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_YELLOW)Running Valgrind...$(COLOR_RESET)"; \
		$(CC) $(CFLAGS) $(DFLAGS) $(SRC_FILES) -o $(DEBUG_BIN_PATH); \
		valgrind $(VALGRIND_FLAGS) $(DEBUG_BIN_PATH) -bsnet Makefile > /dev/null; \
		echo "$(COLOR_GREEN)Valgrind completed!$(COLOR_RESET)"; \
	fi
	@echo ""


test: bin $(INCLUDE_FILES) $(SRC_FILES)
	@echo "$(COLOR_BLUE)Running tests...$(COLOR_RESET)"
	@cd $(TEST_DIR_NAME) && ./run.sh ../$(BIN_FILE_PATH) $(TEST_FORWARD_FILE_NAME) $(TEST_BACKWARD_FILE_NAME)
	@echo "$(COLOR_GREEN)Tests completed!$(COLOR_RESET)"
	@echo ""


clean:
	@echo "$(COLOR_RED)Cleaning...$(COLOR_RESET)"
	@rm -rf $(REMOVE_FILES_NAME_FOR_CLEAN) 2> /dev/null
	@echo "$(COLOR_GREEN)Cleaning completed!$(COLOR_RESET)"
	@echo ""
	
# ============================ Targets ============================ #
