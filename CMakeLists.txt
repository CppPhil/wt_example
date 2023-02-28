cmake_minimum_required(VERSION 3.25)

project(wt_example_project VERSION 1.0.0)

enable_testing()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

find_package(Threads REQUIRED)

# Boost
set(Boost_USE_STATIC_LIBS ON)
find_package(
  Boost
  ${BOOST_VERSION_TO_USE} EXACT REQUIRED
  COMPONENTS 
  atomic
  chrono
  container
  context
  coroutine
  date_time
  exception
  fiber
  filesystem
  graph
  iostreams
  locale
  log
  log_setup
  math_c99
  math_c99f
  math_c99l
  math_tr1
  math_tr1f
  math_tr1l
  nowide
  prg_exec_monitor
  program_options
  random
  regex
  serialization
  stacktrace_noop
  system
  test_exec_monitor
  thread
  timer
  type_erasure
  unit_test_framework
  wave
  wserialization)

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

set(LIB_HEADERS 
    include/global.hpp 
    include/hello_application.hpp)

set(LIB_SOURCES 
    src/hello_application.cpp)

add_library(${LIB_NAME} STATIC ${LIB_HEADERS} ${LIB_SOURCES})

target_include_directories(
  ${LIB_NAME}
  PUBLIC ${wt_example_project_SOURCE_DIR}/include
         ${wt_example_project_SOURCE_DIR}/external/wt/src/web
         ${wt_example_project_SOURCE_DIR}/external/wt/src
         ${wt_example_project_SOURCE_DIR}/external/wt/src/Wt/Date/include
         ${BOOST_INCLUDE_DIRS})

target_link_libraries(
  ${LIB_NAME} 
  PUBLIC 
  Threads::Threads 
  Boost::headers
  Boost::atomic
  Boost::chrono
  Boost::container
  Boost::context
  Boost::coroutine
  Boost::date_time
  Boost::exception
  Boost::fiber
  Boost::filesystem
  Boost::graph
  Boost::iostreams
  Boost::locale
  Boost::log
  Boost::log_setup
  Boost::math_c99
  Boost::math_c99f
  Boost::math_c99l
  Boost::math_tr1
  Boost::math_tr1f
  Boost::math_tr1l
  Boost::nowide
  Boost::prg_exec_monitor
  Boost::program_options
  Boost::random
  Boost::regex
  Boost::serialization
  Boost::stacktrace_noop
  Boost::system
  Boost::test_exec_monitor
  Boost::thread
  Boost::timer
  Boost::type_erasure
  Boost::unit_test_framework
  Boost::wave
  Boost::wserialization
  ${WT_CONNECTOR}
  wt
  CppPhil::philslib)

# APPLICATION
set(APP_NAME wt_example_app)

add_executable(${APP_NAME} src/main.cpp)

target_link_libraries(${APP_NAME} PRIVATE ${LIB_NAME})
