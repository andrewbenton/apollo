#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>

#ifndef __apollo_behavioral_utils__
#define __apollo_behavioral_utils__

#define behavioral_unused(par) (void)par

#ifndef NO_COLOR
#define HAS_COLOR (true)
#define MAGENTA "\033[1;31m"
#define ORANGE  "\033[1;33m"
#define GREEN   "\033[1;32m"
#define BLUE    "\033[1;34m"
#define PURPLE  "\033[1;35m"
#define WHITE   "\033[1;37m"
#define RESET   "\033[m"
#else
#define HAS_COLOR (false)
#define MAGENTA ""
#define ORANGE  ""
#define GREEN   ""
#define BLUE    ""
#define PURPLE  ""
#define WHITE   ""
#define RESET   ""
#endif

#define ERROR "[ERROR]: "
#define WARN  "[WARN]:  "
#define INFO  "[INFO]:  "
#define FUBAR "[FUBAR]: "

//show the error, then bomb out via a sigsegv, and if that fails to exit, then TERM
#define log_fubar(M, ...) \
    do { \
        fprintf(stderr, MAGENTA FUBAR "(%s:%d:%s) " M RESET, __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__); \
        exit(EXIT_FAILURE); \
    } while(0)

//always show errors.  your face is about to melt off
#define log_err(M, ...)   fprintf(stderr, ORANGE  ERROR "(%s:%d:%s) " M RESET, __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__)

//always show warnings.  these are bad, but not terrible
#define log_warn(M, ...)  fprintf(stderr, BLUE    WARN  "(%s:%d:%s) " M RESET, __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__)

//show debug events, go crazy with this
#ifdef DEBUG
#define log_info(M, ...)  fprintf(stdout, GREEN   INFO  "(%s:%d:%s) " M RESET, __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__)
#else
#define log_info(M, ...)
#endif

#endif
