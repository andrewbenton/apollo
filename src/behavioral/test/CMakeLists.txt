set(PREFIX ${CMAKE_INSTALL_PREFIX})
project(apollo-behavioral-test)

set(DOLLAR "$")

add_definitions(${DEPS_CFLAGS})
include_directories(${CMAKE_BINARY_DIR}/src/behavioral)
link_libraries(${DEPS_LIBRARIES} -lapollo-behavioral)
link_directories(${DEPS_LIBRARY_DIRS} ${CMAKE_BINARY_DIR}/src/behavioral)
find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.27" MINIMUM)
include(ValaPrecompile)

set(VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set(VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set(VALA_PACKAGES ${VALA_PACKAGES} json-glib-1.0)
set(VALA_PACKAGES ${VALA_PACKAGES} gee-0.8)

set(APP_SOURCES ${APP_SOURCES} tree_construct.vala)

set(CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} ${CMAKE_BINARY_DIR}/src/behavioral/apollo-behavioral.vapi)

vala_precompile(VALA_C tree-context-test
    ${APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
)

add_executable(tree-context-test ${VALA_C})

add_test(NAME tree-context-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/tree-context-test)
