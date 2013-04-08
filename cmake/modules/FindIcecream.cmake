# - Try to find the icecream library
# Once done this defines
#
#  LIBICECREAM_FOUND - system has libicecream
#  LIBICECREAM_INCLUDE_DIR - the libicecream include directory
#  LIBICECREAM_LIBRARIES - Link these to use libicecream

if (LIBICECREAM_INCLUDE_DIR AND LIBICECREAM_LIBRARIES)

  # in cache already
  set(LIBICECREAM_FOUND TRUE)

else (LIBICECREAM_INCLUDE_DIR AND LIBICECREAM_LIBRARIES)

  set( LIBICECREAM_LIB_EXTRA )

  if(NOT WIN32)
    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    find_package(PkgConfig)
    pkg_check_modules(PC_ICECC icecc)
    # The icecream lib may optionally need linking to -lcap-ng, so dig it out
    # of pkg-config data.
    # Somewhat hackish, but I can't find a simpler way to do this with CMake.
    foreach(lib ${PC_ICECC_STATIC_LIBRARIES})
        message(STATUS "A ${lib}")
      if(NOT ${lib} STREQUAL "icecc")
        list(APPEND LIBICECREAM_LIB_EXTRA "-l${lib}")
        message(STATUS "B ${lib}")
      endif(NOT ${lib} STREQUAL "icecc")
    endforeach(lib ${PC_ICECC_STATIC_LIBRARIES})
        message(STATUS "C ${LIBICECREAM_LIB_EXTRA}")
  endif(NOT WIN32)

  find_path(LIBICECREAM_INCLUDE_DIR icecc/comm.h
    HINTS
    ${PC_ICECC_INCLUDEDIR}
    ${PC_ICECC_INCLUDE_DIRS}
    /opt/icecream/include
  )

  find_library(LIBICECREAM_LIBRARY NAMES icecc
    HINTS
    ${PC_ICECC_LIBDIR}
    ${PC_ICECC_LIBRARY_DIRS}
    /opt/icecream/lib
  )

  set( LIBICECREAM_LIBRARIES ${LIBICECREAM_LIBRARY} ${LIBICECREAM_LIB_EXTRA} CACHE INTERNAL "The libraries for libicecream" )

  if (LIBICECREAM_INCLUDE_DIR AND LIBICECREAM_LIBRARIES)
     set( LIBICECREAM_FOUND TRUE)
  endif (LIBICECREAM_INCLUDE_DIR AND LIBICECREAM_LIBRARIES)

  if (LIBICECREAM_FOUND)
    if (NOT Icecream_FIND_QUIETLY)
      message(STATUS "Found LIBICECREAM: ${LIBICECREAM_LIBRARIES}")
    endif (NOT Icecream_FIND_QUIETLY)
  else (LIBICECREAM_FOUND)
    if (Icecream_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find LIBICECREAM")
    endif (Icecream_FIND_REQUIRED)
  endif (LIBICECREAM_FOUND)

  mark_as_advanced(
     LIBICECREAM_INCLUDE_DIR LIBICECREAM_LIBRARIES
  )

endif (LIBICECREAM_INCLUDE_DIR AND LIBICECREAM_LIBRARIES)
