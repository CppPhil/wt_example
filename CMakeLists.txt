cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

project(wt_example_project VERSION 1.0.0)

enable_testing()

string(
  APPEND
  CMAKE_CXX_FLAGS
  " -Werror -Wall -Wextra -Wstrict-aliasing -Wcast-align -Wpointer-arith -Wunreachable-code -Wno-unused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-implicit-fallthrough -Wno-redundant-move -Wno-deprecated-declarations -Wno-deprecated-copy -Wno-sign-compare -Wno-misleading-indentation -Wno-switch -Wno-type-limits -Wno-empty-body -Wno-stringop-truncation -Wno-maybe-uninitialized"
)

string(APPEND CMAKE_CXX_FLAGS_DEBUG " -g -O0 -DDEBUG_MODE")
string(APPEND CMAKE_CXX_FLAGS_RELEASE " -g -O3 -DNDEBUG -DRELEASE_MODE")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Threads REQUIRED)

# Wt
set(SHARED_LIBS
    OFF
    CACHE BOOL "Compile shared libraries" FORCE)
set(BUILD_EXAMPLES
    OFF
    CACHE BOOL "Build examples" FORCE)
set(INSTALL_DOCUMENTATION
    OFF
    CACHE BOOL "Install documentation (tutorials and reference)" FORCE)
set(INSTALL_EXAMPLES
    OFF
    CACHE BOOL "Install examples (binaries and source)" FORCE)
set(INSTALL_RESOURCES
    OFF
    CACHE BOOL "Install resources directory" FORCE)
set(ENABLE_SSL
    ON
    CACHE BOOL "Enable cryptography functions, using OpenSSL" FORCE)
set(ENABLE_HARU
    OFF
    CACHE
      BOOL
      "Enable Haru Free PDF Library, which is used to provide support for painting to PDF (WPdfImage)"
      FORCE)
set(ENABLE_PANGO
    OFF
    CACHE
      BOOL
      "Enable Pango Library, which is used for improved font support (WPdfImage and WRasterImage)"
      FORCE)
set(ENABLE_EXT
    OFF
    CACHE
      BOOL
      "Build Wt Ext library with JavaScript-only widgets (http://extjs.com/) DEPRECATED"
      FORCE)
set(ENABLE_SQLITE
    OFF
    CACHE BOOL "Build SQLite3 backend for Wt::Dbo" FORCE)
set(ENABLE_POSTGRES
    OFF
    CACHE BOOL "Build PostgreSQL backend for Wt::Dbo" FORCE)
set(ENABLE_FIREBIRD
    OFF
    CACHE BOOL "Build FirebirdSQL backend for Wt::Dbo" FORCE)
set(ENABLE_MYSQL
    OFF
    CACHE BOOL "Build mariadb/mysql backend for Wt::Dbo" FORCE)
set(ENABLE_MSSQLSERVER
    OFF
    CACHE BOOL "Build Microsoft SQL Server backend for Wt::Dbo" FORCE)
set(ENABLE_QT4
    OFF
    CACHE BOOL "Build Qt4 interworking library (libwtwithqt)" FORCE)
set(ENABLE_QT5
    OFF
    CACHE BOOL "Build Qt5 interworking library (libwtwithqt5)" FORCE)
set(ENABLE_LIBWTTEST
    ON
    CACHE BOOL "Build Wt::Test" FORCE)
set(ENABLE_LIBWTDBO
    OFF
    CACHE BOOL "Build Wt::Dbo" FORCE)
set(WT_NO_STD_LOCALE
    OFF
    CACHE BOOL "Build Wt to run on a system without std::locale support" FORCE)
set(WT_NO_STD_WSTRING
    OFF
    CACHE BOOL "Build Wt to run on a system without std::wstring support" FORCE)
set(ENABLE_OPENGL
    OFF
    CACHE BOOL "Build Wt with support for server-side opengl rendering" FORCE)
set(ENABLE_UNWIND
    OFF
    CACHE BOOL "Build Wt with stacktrace support using libunwind" FORCE)
set(WT_CONNECTOR
    "wthttp"
    CACHE STRING "Connector used (wthttp or wtfcgi)")
include_directories(${CMAKE_CURRENT_BINARY_DIR}/external/wt)
add_subdirectory(external/wt)

add_subdirectory(external/philslib)

# STATIC LIBRARY
set(LIB_NAME wt_example_lib)

set(LIB_HEADERS include/global.hpp include/hello_application.hpp)

set(LIB_SOURCES src/hello_application.cpp)

add_library(${LIB_NAME} STATIC ${LIB_HEADERS} ${LIB_SOURCES})

target_include_directories(
  ${LIB_NAME}
  PUBLIC ${wt_example_project_SOURCE_DIR}/include
         ${wt_example_project_SOURCE_DIR}/external/wt/src/web
         ${wt_example_project_SOURCE_DIR}/external/wt/src
         ${wt_example_project_SOURCE_DIR}/external/wt/src/Wt/Date/include
         ${BOOST_INCLUDE_DIRS})

target_link_libraries(${LIB_NAME} PUBLIC Threads::Threads ${WT_CONNECTOR} wt
                                         CppPhil::philslib)

# APPLICATION
set(APP_NAME wt_example_app)

add_executable(${APP_NAME} src/main.cpp)

target_link_libraries(${APP_NAME} PRIVATE ${LIB_NAME})
