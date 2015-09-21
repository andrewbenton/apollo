project(apollo)
cmake_minimum_required(VERSION 2.8)
cmake_policy(VERSION 2.8)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

enable_testing()
option(BUILD_VALADOC "Build API documentation if Valadoc is available" ON)

include(GNUInstallDirs)
if((${CMAKE_INSTALL_PREFIX} MATCHES "^/usr/local"))
    set(CMAKE_INSTALL_LIBDIR lib)
endif()

if(CMAKE_COMPILER_IS_GNUCC)
    set(CMAKE_C_FLAGS -std=c99)
endif()

set(HAVE_VALADOC OFF)
if(BUILD_VALADOC)
	find_package(Valadoc)
	if(VALADOC_FOUND)
		set(HAVE_VALADOC ON)
		include(Valadoc)
	else()
		message("Valadoc not found, will not build documentation")
	endif()
endif()

set(APOLLO_VERSION_MAJOR "1")
set(APOLLO_VERSION_MINOR "0")
set(APOLLO_VERSION_MICRO "0")

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
        "Choose the type of build, options are: Debug Release." FORCE)
endif()

set(APOLLO_BUILD_ROOT "${CMAKE_CURRENT_BINARY_DIR}")
set(APOLLO_SRC_ROOT "${CMAKE_CURRENT_SOURCE_DIR}")

set(APOLLO_DEFAULT_VERSION_STRING
    "${APOLLO_VERSION_MAJOR}.${APOLLO_VERSION_MINOR}.${APOLLO_VERSION_MINOR}")

if(UNIX)
    set(MATH_LIB -lm)
else()
    set(MATH_LIB)
endif()

find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)

set(MODULES_TO_CHECK ${MODULES_TO_CHECK} glib-2.0)
set(MODULES_TO_CHECK ${MODULES_TO_CHECK} gee-0.8)
set(MODULES_TO_CHECK ${MODULES_TO_CHECK} json-glib-1.0)
set(MODULES_TO_CHECK ${MODULES_TO_CHECK} gio-2.0)

pkg_check_modules(DEPS REQUIRED ${MODULES_TO_CHECK})

option(USE_COLOR "Enable colored output" ON)

if(USE_COLOR)
    add_definitions(-DUSE_COLOR)
endif()

add_subdirectory(src)
