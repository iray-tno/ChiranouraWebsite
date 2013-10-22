# coding: utf-8
# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc::Helpers::Blogging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::CategoryAndTag
include Nanoc::Helpers::Rendering

Encoding.default_external = 'UTF-8'
