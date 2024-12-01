cmake_minimum_required(VERSION 3.28.3)
project(Compilador_MiniC_8_Bits)

message(STATUS "CMake source directory: ${CMAKE_SOURCE_DIR}")
message(STATUS "Project source directory: ${CMAKE_SOURCE_DIR}")

if(NOT UNIX)
  message(WARNING "Unsupported operating system")
endif()

set(ANTLR_BUILD_STATIC TRUE)  

set(antlr4-GENERATED_SRC
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TLexer.cpp 
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParser.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserBaseListener.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserBaseVisitor.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserListener.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserVisitor.cpp
)

foreach(src_file ${antlr4-GENERATED_SRC})
      set_source_files_properties(
          ${src_file}
          PROPERTIES
          GENERATED TRUE
          )
endforeach(src_file ${antlr4-GENERATED_SRC})


execute_process(
  COMMAND /bin/bash "${CMAKE_SOURCE_DIR}/generate.sh"
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  RESULT_VARIABLE result
  OUTPUT_VARIABLE output
  ERROR_VARIABLE error_output
)

add_custom_command(
  OUTPUT ${PROJECT_SOURCE_DIR}/src/parser_lexer/TLexer.cpp
  ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParser.cpp
  ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserBaseListener.cpp
  ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserBaseVisitor.cpp
  ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserListener.cpp
  ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserVisitor.cpp
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/generate.sh
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/generate.sh
)

add_custom_command(
  OUTPUT ${PROJECT_SOURCE_DIR}/demo/generated/TLexer.cpp
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/your_script.sh
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/your_script.sh
)

message(STATUS "Result: ${result}")
message(STATUS "Output: ${output}")
message(STATUS "Error Output: ${error_output}")

include_directories(
  ${PROJECT_SOURCE_DIR}/headers
  ${PROJECT_SOURCE_DIR}/runtime/src
  ${PROJECT_SOURCE_DIR}/runtime/src/misc
  ${PROJECT_SOURCE_DIR}/runtime/src/atn
  ${PROJECT_SOURCE_DIR}/runtime/src/dfa
  ${PROJECT_SOURCE_DIR}/runtime/src/tree
  ${PROJECT_SOURCE_DIR}/runtime/src/support
  ${PROJECT_SOURCE_DIR}/demo/generated
)

add_subdirectory(runtime)


set(project_SRC 
  ${PROJECT_SOURCE_DIR}/src/main.cpp
  ${antlr4-GENERATED_SRC}
)

if(NOT CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
  set (flags_1 "-Wno-overloaded-virtual")
else()
  set (flags_1 "-MP /wd4251")
endif()



foreach(src_file ${project_SRC})
      set_source_files_properties(
          ${src_file}
          PROPERTIES
          COMPILE_FLAGS "${COMPILE_FLAGS} ${flags_1}"
          )
endforeach(src_file ${project_SRC})


add_executable(project
  ${project_SRC}
)


target_link_libraries(project PRIVATE antlr4_static)

