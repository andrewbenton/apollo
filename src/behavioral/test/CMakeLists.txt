set(PREFIX ${CMAKE_INSTALL_PREFIX})
project(apollo-behavioral-test)

set(DOLLAR "$")

add_definitions(${DEPS_CFLAGS})
#add_definitions(${LUA_INCLUDE_DIR})
include_directories(${CMAKE_BINARY_DIR}/src/behavioral)
link_libraries(${DEPS_LIBRARIES} -lapollo-behavioral)
link_libraries(${LUA_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS} ${CMAKE_BINARY_DIR}/src/behavioral)
find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.27" MINIMUM)
include(ValaPrecompile)

set(VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set(VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set(VALA_PACKAGES ${VALA_PACKAGES} json-glib-1.0)
set(VALA_PACKAGES ${VALA_PACKAGES} gee-0.8)
set(VALA_PACKAGES ${VALA_PACKAGES} lua)

set(CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} ${CMAKE_BINARY_DIR}/src/behavioral/apollo-behavioral.vapi)

#debug flags
if(DEBUG)
    set(COMPILE_OPTIONS ${COMPILE_OPTIONS} -D DEBUG --debug)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDEBUG -g ")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DDEBUG -g ")
endif()

#Make executable for context executable and test
set(TC_APP_SOURCES ${TC_APP_SOURCES} tree_construct.vala)

vala_precompile(VALA_C_TC tree-context-test
    ${TC_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
OPTIONS
    ${COMPILE_OPTIONS}
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
OPTIONS
    ${COMPILE_OPTIONS}
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
OPTIONS
    ${COMPILE_OPTIONS}
)

add_executable(json-conf-test ${VALA_C_JT})

add_test(NAME json-conf-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/json-conf-test)

#make executable for shortcut-and executable and test
set(SCA_APP_SOURCES ${SCA_APP_SOURCES} sc_and_test.vala)

vala_precompile(VALA_C_SCA shortcut-and-test
    ${SCA_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
OPTIONS
    ${COMPILE_OPTIONS}
)

add_executable(shortcut-and-test ${VALA_C_SCA})

add_test(NAME shortcut-and-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/shortcut-and-test)

#make executable for shortcut-or executable and test
set(SCO_APP_SOURCES ${SCO_APP_SOURCES} sc_or_test.vala)

vala_precompile(VALA_C_SCO schortcut-or-test
    ${SCO_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
OPTIONS
    ${COMPILE_OPTIONS}
)

add_executable(shortcut-or-test ${VALA_C_SCO})

add_test(NAME shortcut-or-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/shortcut-or-test)

#make executable for echo-node executable and test
set(EFT_APP_SOURCES ${EFT_APP_SOURCES} echo_fmt_test.vala)

vala_precompile(VALA_C_EFT echo-fmt-test
    ${EFT_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
OPTIONS
    ${COMPILE_OPTIONS}
)

add_executable(echo-fmt-test ${VALA_C_EFT})

add_test(NAME echo-fmt-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/echo-fmt-test)

#make executable for lua-node executable and test
set(LNT_APP_SOURCES ${LNT_APP_SOURCES} lua_script_test.vala)

vala_precompile(VALA_C_LNT lua-node-test
    ${LNT_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
OPTIONS
    ${COMPILE_OPTIONS}
)

add_executable(lua-node-test ${VALA_C_LNT})

add_test(NAME lua-node-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/lua-node-test)

#make executable for json map loading
set(JMT_APP_SOURCES ${JMT_APP_SOURCES} map_node_test.vala)

vala_precompile(VALA_C_JMT json-map-test
    ${JMT_APP_SOURCES}
PACKAGES
    ${VALA_PACKAGES}
CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
OPTIONS
    ${COMPILE_OPTIONS}
)

add_executable(json-map-test ${VALA_C_JMT})

add_test(NAME json-map-test COMMAND ${CMAKE_BINARY_DIR}/src/behavioral/test/json-map-test)
