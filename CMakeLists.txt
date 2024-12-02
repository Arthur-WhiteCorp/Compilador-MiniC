cmake_minimum_required(VERSION 3.28.3)
project(Compilador_MiniC_8_Bits)

message(STATUS "CMake source directory: ${CMAKE_SOURCE_DIR}")
message(STATUS "Project source directory: ${CMAKE_SOURCE_DIR}")

if(NOT UNIX)
  message(WARNING "Unsupported operating system")
endif()

set(ANTLR_BUILD_STATIC TRUE)  


# Check for Java
find_package(Java REQUIRED)

# Display the Java version found
execute_process(
    COMMAND java -version
   
)


# Define the destination directory within your project
set(ANTLR_JAR_PATH "${CMAKE_SOURCE_DIR}/antlr4_tool/antlr-4.13.2-complete.jar")
set(ANTLR_URL "https://www.antlr.org/download/antlr-4.13.2-complete.jar")

# Ensure the destination directory exists within your project
file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/libs")

# Download the ANTLR jar if it doesn't already exist
if(NOT EXISTS "${ANTLR_JAR_PATH}")
    message(STATUS "Downloading ANTLR 4.13.2 jar...")
    file(DOWNLOAD ${ANTLR_URL} "${ANTLR_JAR_PATH}")
else()
    message(STATUS "ANTLR jar already exists at ${ANTLR_JAR_PATH}")
endif()


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

