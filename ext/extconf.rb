require 'mkmf'

$CFLAGS = '-Wno-char-subscripts'

extension_name = "lib_uuid"

have_library('uuid')

dir_config extension_name
create_makefile extension_name
