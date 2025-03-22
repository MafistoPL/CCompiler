################################################################################
# Detecting system and setting up appropriate delete command
################################################################################
ifeq ($(OS),Windows_NT)
    RM        = cmd /C del
    RMFLAGS   = /Q
    FixPath   = $(subst /,\,$1)
    ExeSuffix = .exe
else
    RM        = rm
    RMFLAGS   = -f
    FixPath   = $1
    ExeSuffix =
endif

################################################################################
# Project configuration
################################################################################

# Name of the main executable (without extension)
MAIN              = main
EXEC              = $(call FixPath,$(addsuffix $(ExeSuffix),$(MAIN)))

# Source and output directories
BUILD_DIR         = ./build
HELPERS_DIR       = ./helpers
HELPERS_OUT_DIR   = $(BUILD_DIR)/helpers

# Object files
OBJECTS = \
	$(BUILD_DIR)/compiler.o \
	$(BUILD_DIR)/cprocess.o \
	$(HELPERS_OUT_DIR)/buffer.o \
	$(HELPERS_OUT_DIR)/vector.o

# Include paths
INCLUDES = -I./

################################################################################
# Main targets
################################################################################

all: $(EXEC)

$(EXEC): $(OBJECTS)
	gcc main.c $(INCLUDES) $(OBJECTS) -g -o $(EXEC)

################################################################################
# Object file compilation
################################################################################

$(BUILD_DIR)/compiler.o: compiler.c | $(BUILD_DIR)
	gcc $(INCLUDES) -g -c $< -o $(call FixPath,$@)

$(BUILD_DIR)/cprocess.o: cprocess.c | $(BUILD_DIR)
	gcc $(INCLUDES) -g -c $< -o $(call FixPath,$@)

$(HELPERS_OUT_DIR)/buffer.o: $(HELPERS_DIR)/buffer.c | $(HELPERS_OUT_DIR)
	gcc $(INCLUDES) -g -c $< -o $(call FixPath,$@)

$(HELPERS_OUT_DIR)/vector.o: $(HELPERS_DIR)/vector.c | $(HELPERS_OUT_DIR)
	gcc $(INCLUDES) -g -c $< -o $(call FixPath,$@)

################################################################################
# Directory creation
################################################################################

# Ensure the main build directory exists
$(BUILD_DIR):
	@mkdir $(call FixPath,$(BUILD_DIR)) 2>NUL || true

# Ensure helpers output directory exists
$(HELPERS_OUT_DIR):
	@mkdir $(call FixPath,$(HELPERS_OUT_DIR)) 2>NUL || true

################################################################################
# Cleanup
################################################################################

clean:
	-$(RM) $(RMFLAGS) $(call FixPath,$(EXEC)) \
	       $(foreach obj,$(OBJECTS),$(call FixPath,$(obj)))

.PHONY: all clean
