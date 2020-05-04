# Modified from FindReadline.cmake (PH Feb 2012)

if(EDITLINE_INCLUDE_DIR AND EDITLINE_LIBRARY AND NCURSES_LIBRARY)
  set(EDITLINE_FOUND TRUE)
else(EDITLINE_INCLUDE_DIR AND EDITLINE_LIBRARY AND NCURSES_LIBRARY)
  FIND_PATH(EDITLINE_INCLUDE_DIR readline.h
    /usr/include/editline
    /usr/include/edit/readline  
    /usr/include/readline
  )
  
  FIND_LIBRARY(EDITLINE_LIBRARY NAMES edit)
  include(FindPackageHandleStandardArgs)
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(Editline DEFAULT_MSG EDITLINE_INCLUDE_DIR EDITLINE_LIBRARY )

  MARK_AS_ADVANCED(EDITLINE_INCLUDE_DIR EDITLINE_LIBRARY)
endif(EDITLINE_INCLUDE_DIR AND EDITLINE_LIBRARY AND NCURSES_LIBRARY)
