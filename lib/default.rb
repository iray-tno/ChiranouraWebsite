# coding: utf-8
# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc::Helpers::Blogging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::CategoryAndTag
include Nanoc::Helpers::Rendering

Encoding.default_external = 'UTF-8'

require "redcarpet"
require "cgi"
require "redcarpet"
require "coderay"

class MyRedcarpetRenderer < Redcarpet::Render::XHTML
  def link(link, title, alt_text)
    "<a href=\"#{CGI::escapeHTML(link)}\" target=\"_blank\">#{alt_text}</a>"
  end

  def block_code(code, language)
    if language then
      CodeRay.scan(code, language).div
    else
      "\n<pre><code>#{code}</code></pre>\n"
    end
  end
end
