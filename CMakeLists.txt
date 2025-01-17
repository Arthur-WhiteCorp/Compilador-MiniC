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


# Mostrar o valor inserido
execute_process(
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/permission.sh
  RESULT_VARIABLE result
  ERROR_VARIABLE error
)

if (result EQUAL 1)
  message(FATAL_ERROR "Download cancelado pelo usuário. O projeto não pode continuar sem o arquivo ANTLR.")
endif()

# Define the destination directory within your project
set(ANTLR_JAR_PATH "${CMAKE_SOURCE_DIR}/antlr4_tool/antlr-4.13.2-complete.jar")
set(ANTLR_URL "https://www.antlr.org/download/antlr-4.13.2-complete.jar")


# Download the ANTLR jar if it doesn't already exist
if(NOT EXISTS "${ANTLR_JAR_PATH}")
    message(STATUS "Baixando ANTLR 4.13.2 jar...")
    file(DOWNLOAD ${ANTLR_URL} "${ANTLR_JAR_PATH}")
else()
    message(STATUS "ANTLR ja existe em ${ANTLR_JAR_PATH}")
endif()


set(antlr4-GENERATED_SRC
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TLexer.cpp 
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParser.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserBaseListener.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserBaseVisitor.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserListener.cpp
   ${PROJECT_SOURCE_DIR}/src/parser_lexer/TParserVisitor.cpp
)
message(STATUS "ANTLR4 GENERATED SRC: ${antlr4-GENERATED_SRC}")

add_custom_command(
  OUTPUT ${antlr4-GENERATED_SRC}
  COMMAND ${CMAKE_COMMAND} -E echo "Running generate.sh script"
  COMMAND "${PROJECT_SOURCE_DIR}/generate.sh"
  DEPENDS 
    ${CMAKE_CURRENT_SOURCE_DIR}/generate.sh
    ${PROJECT_SOURCE_DIR}/grammar/TLexer.g4
    ${PROJECT_SOURCE_DIR}/grammar/TParser.g4
  COMMENT "Running ANTLR to generate lexer and parser files"
)
add_custom_target(generate_parser_files ALL DEPENDS ${antlr4-GENERATED_SRC})


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

add_dependencies(project generate_parser_files)


target_link_libraries(project PRIVATE antlr4_static)

