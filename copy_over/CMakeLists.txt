cmake_minimum_required(VERSION 3.8)

PROJECT("net.sourceforge.freetype-ftjam"
        VERSION 2.5.2.1)

# Enable tests (see here for details: http://www.vtk.org/Wiki/CMake/Testing_With_CTest)
ENABLE_TESTING()

INCLUDE(cmake/platform.cmake)

#----------------------------------------------------------------------------
#
# Find all packages.
#

FIND_PACKAGE(Python3 REQUIRED COMPONENTS Interpreter)

#----------------------------------------------------------------------------

SET(SourcesCommon builtins.c
	command.c
	compile.c
	expand.c
	glob.c
	hash.c
	headers.c
	jamgram.c
	lists.c
	make.c
	make1.c
	newstr.c
	option.c
	parse.c
	regexp.c
	rules.c
	scan.c
	search.c
	timestamp.c
	variable.c
	hdrmacro.c)

SET(SourceListLinux execunix.c
	fileunix.c
	pathunix.c)

SET(SourceListWin execunix.c
	filent.c
	pathunix.c)


IF(UNIX)
	SET(SourceListPlatform ${SourceListLinux})
ELSE(UNIX)
	SET(SourceListPlatform ${SourceListWin})
ENDIF(UNIX)

ADD_LIBRARY(TARGET_libjam STATIC ${SourcesCommon} ${SourceListPlatform})
SET_TARGET_PROPERTIES(TARGET_libjam PROPERTIES OUTPUT_NAME "jam")
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	TARGET_COMPILE_DEFINITIONS(TARGET_libjam
	                           PRIVATE NT)
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))


ADD_EXECUTABLE(TARGET_jam jam.c jambase.c)
TARGET_LINK_LIBRARIES(TARGET_jam TARGET_libjam)
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	TARGET_COMPILE_DEFINITIONS(TARGET_jam
	                           PRIVATE NT)
	# On minGW link all compiler libraries static.
	SET_TARGET_PROPERTIES(TARGET_jam PROPERTIES LINK_FLAGS "-static -static-libgcc -static-libstdc++")
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
SET_TARGET_PROPERTIES(TARGET_jam PROPERTIES OUTPUT_NAME "jam")

# Add tests for this module.
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	# Here are the MinGW specific tests.
	ADD_TEST(NAME jam_MinGW_DLL_dependencies
	         COMMAND "${Python3_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tests/mingw_dll_dependencies.py -u lua5.1 -u lua5.2 -u lua5.3 $<TARGET_FILE:TARGET_jam>)
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))

#----------------------------------------------------------------------------
#
# Build a package for the selected platform.
#

SET(CPACK_OUTPUT_FILE_PREFIX ${CMAKE_BINARY_DIR}/../../repository/net/sourceforge/freetype/ftjam/${PROJECT_VERSION})
SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
SET(CPACK_PACKAGE_FILE_NAME "ftjam-${PROJECT_VERSION}-${JONCHKI_PLATFORM}")

SET(CPACK_GENERATOR "TXZ")
INCLUDE(CPack)
INSTALL(TARGETS TARGET_jam DESTINATION .)

#----------------------------------------------------------------------------
