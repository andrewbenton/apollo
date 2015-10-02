set(PREFIX ${CMAKE_INSTALL_PREFIX})
project(apollo-behavioral)

set (DOLLAR "$")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/apollo-behavioral.pc   ${CMAKE_CURRENT_BINARY_DIR}/apollo-behavioral.pc)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/apollo-behavioral.deps ${CMAKE_CURRENT_BINARY_DIR}/apollo-behavioral.deps)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})
find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.27" MINIMUM)
include(ValaPrecompile)

set(VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set(VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set(VALA_PACKAGES ${VALA_PACKAGES} json-glib-1.0)
set(VALA_PACKAGES ${VALA_PACKAGES} gee-0.8)

set(APP_SOURCES ${APP_SOURCES} behavioral_tree_error.vala)
set(APP_SOURCES ${APP_SOURCES} behavioral_tree_set.vala)
set(APP_SOURCES ${APP_SOURCES} node.vala)
set(APP_SOURCES ${APP_SOURCES} node_context.vala)
set(APP_SOURCES ${APP_SOURCES} status_value.vala)
set(APP_SOURCES ${APP_SOURCES} tree_context.vala)

include_directories(AFTER .)

set(CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} ${CMAKE_SOURCE_DIR}/src/behavioral/vapis/behavioral_utils.vapi)

vala_precompile(VALA_C apollo-behavioral
    ${APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
OPTIONS
    ${COMPILE_OPTIONS}
GENERATE_VAPI
    apollo-behavioral
GENERATE_HEADER
    apollo-behavioral
)

add_library(apollo-behavioral SHARED ${VALA_C})
set_target_properties(apollo-behavioral PROPERTIES
VERSION
    ${APOLLO_DEFAULT_VERSION_STRING}
SOVERSION
    ${APOLLO_DEFAULT_VERSION_STRING}
)

install(TARGETS
    apollo-behavioral
LIBRARY DESTINATION
    ${CMAKE_INSTALL_BINDIR}/
)
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/apollo-behavioral.h
DESTINATION
    ${CMAKE_INSTALL_INCLUDEDIR}/
)
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/apollo-behavioral.vapi
DESTINATION
    ${CMAKE_INSTALL_DATAROOTDIR}/vala/vapi/
)
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/apollo-behavioral.deps
DESTINATION
    ${CMAKE_INSTALL_DATAROOTDIR}/gir-1.0/
)
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/apollo-behavioral.pc
DESTINATION
    ${CMAKE_INSTALL_LIBDIR}/pkgconfig/
)

if(HAVE_VALADOC)
    valadoc(apollo-behavioral
        ${CMAKE_BINARY_DIR}/valadoc/apollo-behavioral
        ${APP_SOURCES}
    PACKAGES
        ${VALA_PACKAGES}
    CUSTOM_VAPIS
        ${CUSTOM_VAPIS_LIST}
    )
    install(DIRECTORY
        ${CMAKE_BINARY_DIR}/valadoc
    DESTINATION
        ${CMAKE_INSTALL_DATAROOTDIR}/doc/apollo-behavioral
    )
endif()

install(CODE "MESSAGE (\"
*********************************************************************************
* On some systems, running `sudo ldconfig` is required to complete installation *
*********************************************************************************
\") ")
