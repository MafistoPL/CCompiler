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

MAIN      = main
EXEC      = $(call FixPath,$(addsuffix $(ExeSuffix),$(MAIN)))
OBJECTS   = $(MAIN).o
INCLUDES  = -I./

all: $(EXEC)

$(EXEC): $(OBJECTS)
	gcc $(INCLUDES) $(OBJECTS) -g -o $(EXEC)

clean:
	-$(RM) $(RMFLAGS) $(EXEC) $(OBJECTS)

%.o: %.c
	gcc -c $< -o $@

.PHONY: all clean
