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

set(CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} ${CMAKE_BINARY_DIR}/src/behavioral/apollo-behavioral.vapi)


#Make executable for context executable and test
set(TC_APP_SOURCES ${TC_APP_SOURCES} tree_construct.vala)

vala_precompile(VALA_C_TC tree-context-test
    ${TC_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
)

add_executable(tree-context-test ${VALA_C_TC})

add_test(NAME tree-context-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/tree-context-test)

#Make executable for two-tier executable and test
set(TT_APP_SOURCES ${TT_APP_SOURCES} two_tier.vala)

vala_precompile(VALA_C_TT two-tier-test
    ${TT_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
)

add_executable(two-tier-test ${VALA_C_TT})

add_test(NAME two-tier-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/two-tier-test)

#make executable for json-configuration executable and test
set(JT_APP_SOURCES ${JT_APP_SOURCES} json_test.vala)

vala_precompile(VALA_C_JT json-conf-test
    ${JT_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
)

add_executable(json-conf-test ${VALA_C_JT})

add_test(NAME json-conf-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/json-conf-test)
