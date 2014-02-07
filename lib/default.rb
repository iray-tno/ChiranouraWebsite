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
require "coderay"

class ArticleRenderer < Redcarpet::Render::XHTML
  #def link(link, title, alt_text)
  #  "<a href=\"#{CGI::escapeHTML(link)}\" target=\"_blank\">#{alt_text}</a>"
  #end

  def autolink(link, link_type)
    "<a href=\"#{CGI::escapeHTML(link)}\" target=\"_blank\">#{link}</a>"
  end

  def block_code(code, language)
    if language=="mathjax"
      "<script type=\"math/tex; mode=display\">\n#{code}\n</script>"
    elsif language
      CodeRay.scan(code, language).div(:line_numbers => :table, :line_number_anchors => false, :bold_every => false)
    else
      "\n<pre><code>#{code}</code></pre>\n"
    end
  end

  def codespan(code)
    if code[0] == "$" && code[-1] == "$"
      "<script type=\"math/tex\">#{code[1...-1]}</script>"
    elsif code[0..1] == "\\(" && code[-2..-1] == "\\)"
      "<script type=\"math/tex\">#{code[2...-2]}</script>"
    else
      "<code>#{code}</code>"
    end
  end
end
