set(CPACK_PACKAGE_NAME   "LIEF")
set(CPACK_PACKAGE_VENDOR "Quarkslab")

set(CPACK_PACKAGE_CONTACT "rthomas@quarkslab.com")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "LIEF - Library to Instrument Executable Formats")
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://lief.quarkslab.com")

if(UNIX AND NOT APPLE) # Linux
  set(CPACK_GENERATOR "TGZ")
  set(CPACK_SOURCE_GENERATOR "TGZ")
endif()

if(UNIX AND APPLE) # OSX / iOS
  set(CPACK_GENERATOR "TGZ")
endif()

if(WIN32) # Windows
  set(CPACK_GENERATOR "ZIP")
endif()

include(CPack)
