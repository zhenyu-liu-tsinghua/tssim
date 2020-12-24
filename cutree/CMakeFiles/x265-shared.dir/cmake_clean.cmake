FILE(REMOVE_RECURSE
  "libx265.pdb"
  "libx265.so"
  "libx265.so.130"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/x265-shared.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
