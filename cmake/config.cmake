IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
SET(LINUX ON)
SET(POSIX ON)
MESSAGE(STATUS "OS: Linux")
ADD_DEFINITIONS(-DOS_LINUX -DOS_POSIX)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
MESSAGE(STATUS "OS: MacOS")
SET(MAC_OS ON)
SET(POSIX ON)
ADD_DEFINITIONS(-DOS_MAC -DOS_POSIX)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
MESSAGE(STATUS "OS: Windows")
SET(WINDOWS ON)
ADD_DEFINITIONS(-D_WIN32 -DOS_WIN)
ELSE()
MESSAGE(FATAL_ERROR "Not supported OS: "${CMAKE_SYSTEM_NAME})
ENDIF()
SET(CMAKE_MODULE_PATH
        ${CMAKE_MODULE_PATH}
        "${CMAKE_CURRENT_LIST_DIR}/"
)
include(cmake/projecthelper.cmake)
IF(BOOST_ENABLED)
ADD_DEFINITIONS(-DBOOST_SUPPORT_ENABLED)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/integrate-boost.cmake)
SET(Boost_USE_MULTITHREADED     ON)
SET(Boost_USE_STATIC_LIBS ON)
ENDIF(BOOST_ENABLED)

IF(UNICODE_ENABLED)
IF(MINGW)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -municode")
ENDIF()
        ADD_DEFINITIONS(-DUNICODE -D_UNICODE -D_CONSOLE)
ENDIF(UNICODE_ENABLED)

#IF(MINGW)
#set(DESKTOP_TARGET) # build console
#ENDIF()
#IF(MINGW OR CMAKE_COMPILER_IS_GNUCC)#-fno-enforce-eh-specs
#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Woverloaded-virtual")#-fno-rtti
#IF(CMAKE_COMPILER_IS_GNUCC)
#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
#ENDIF()
#ENDIF()

IF(QT_ENABLED)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/integrate-qt.cmake)
ADD_DEFINITIONS(-DQT_SUPPORT_ENABLED)
ENDIF(QT_ENABLED)
MACRO(ADD_APP_EXECUTABLE_MSVC PROJECT_NAME SOURCES LIBS)
ADD_EXECUTABLE(${PROJECT_NAME} ${SOURCES})
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${LIBS})
ENDMACRO()
MACRO(ADD_APP_LIBRARY_MSVC PROJECT_NAME SOURCES LIBS)
ADD_LIBRARY(${PROJECT_NAME} STATIC ${SOURCES})
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${LIBS} )
SET(CMAKE_BUILD_TYPE DEBUG)
ENDMACRO()

MACRO(ADD_APP_EXECUTABLE PROJECT_NAME SOURCES LIBS BUILD_TYPE)
  SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${BUILD_TYPE}/build)
  IF ("${BUILD_TYPE}" STREQUAL "Debug")
	SET(TARGET ${PROJECT_NAME}_d)
        ADD_EXECUTABLE(${TARGET} ${SOURCES})
        TARGET_LINK_LIBRARIES(${TARGET} ${LIBS})
        SET(CMAKE_BUILD_TYPE DEBUG)
    	SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS_DEBUG}")
  ELSEIF("${BUILD_TYPE}" STREQUAL "Release")
        SET(TARGET ${PROJECT_NAME})
        ADD_EXECUTABLE(${TARGET} ${SOURCES})
        TARGET_LINK_LIBRARIES(${TARGET} ${LIBS})
	SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS_RELEASE}")
  ENDIF() 
ENDMACRO()

MACRO(ADD_APP_LIBRARY PROJECT_NAME SOURCES LIBS BUILD_TYPE)
  SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${BUILD_TYPE}/build)
  IF ("${BUILD_TYPE}" STREQUAL "Debug")
        SET(TARGET ${PROJECT_NAME}_d)
        ADD_LIBRARY(${TARGET} STATIC ${SOURCES})
        TARGET_LINK_LIBRARIES(${TARGET} ${LIBS} )
        SET(CMAKE_BUILD_TYPE DEBUG)
        SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS_DEBUG}")
  ELSEIF("${BUILD_TYPE}" STREQUAL "Release")
        SET(TARGET ${PROJECT_NAME})
        ADD_LIBRARY(${TARGET} STATIC ${SOURCES})
        TARGET_LINK_LIBRARIES(${TARGET} ${LIBS})
        SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS_RELEASE}")
  ENDIF()
ENDMACRO()
MESSAGE(STATUS "CONFIG LOADED")
