#ifndef _COMPILER_H
#define _COMPILER_H

#include <stdio.h>
#include <stdbool.h>

struct pos
{
    int line;
    int col;
    const char *filename;
};

enum
{
    TOKEN_TYPE_IDENTIFIER,
    TOKEN_TYPE_KEYWORD,
    TOKEN_TYPE_OPERATOR,
    TOKEN_TYPE_SYMBOL,
    TOKEN_TYPE_NUMBER,
    TOKEN_TYPE_STRING,
    TOKEN_TYPE_COMMENT,
    TOKEN_TYPE_NEWLINE
};

struct token
{
    int type;
    int flags;

    union
    {
        char cval;
        const char *sval;
        unsigned int lnum;
        unsigned int llnum;
        void *any;
    };

    // True if there is whitespace between the token and the next token
    // i.e * a for operator token * woudle mean whitespace would be set for token "a"
    bool whitespace;

    // (5+10+20) for such a expression between_brackets would point to (
    const char *between_brackets;
};

enum
{
    COMPILER_FILE_COMPILED_OK,
    COMPILER_FAILED_WITH_ERRORS
};

struct compile_process
{
    // The flags in regards to how this file should be compiled
    int flags;

    struct compile_process_input_file
    {
        FILE *fp;
        const char *abs_path;
    } cfile;

    FILE *ofile;
};

int compile_file(const char *filename, const char *filename_out, int flags);

struct compile_process *compile_process_create(
    const char *filename,
    const char *filename_out,
    int flags);

#endif