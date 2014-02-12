---

title: "MathJaxで数式描画"
author: iray_tno
category: Science
tags: ["Computer","Ruby","nanoc","MathJax","Redcarpet"]

---

#### はじめに

MathJaxを使ってtex形式で書いた数式を表示できるようにしました。

通常はhtmlに数行追加するだけで使えるようになります。

ただ、markdownでも数式を書けるようにするためには、レンダラの定義が必要だったのでメモしておきます。

* nanoc(http://nanoc.ws)
* Redcarpet(https://github.com/vmg/redcarpet)
* MathJax(http://www.mathjax.org)

<!-- headline -->

#### インストール

まずはテンプレートにMathJaxの設定を追加します。現在IE8対策は必要ないようです。

> In MathJax v2.0, IE8 and IE9 run faster in their IE8 and IE9 standards mode than in IE7 emulation mode.
(http://www.mathjax.org/resources/browser-compatibility/)

このブログではテンプレートにhamlを用いているので、default.hamlを以下のようにしました。(レイアウトの問題でurlの途中で改行しています。)

```haml
!!! XML
!!! 5
<!-- default.haml -->
%html{:xmlns =>"http://www.w3.org/1999/xhtml"}
  %head
    %script{:type => "text/x-mathjax-config"}
      MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
    %script{:type => "text/javascript", :src => "https://c328740.ssl.cf1.rackcd
n.com/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"}

  %body
```

markdown内でも書けるように、default.rbファイルで以下のようにレンダラを定義しました。codespanではinlineでの数式描画を設定しています。

```ruby
#default.rb
require "redcarpet"
require "cgi"
require "coderay"

class ArticleRenderer < Redcarpet::Render::XHTML
  def block_code(code, language)
    if language=="mathjax"
      "<script type=\"math/tex; mode=display\">\n#{code}\n</script>"
    elsif language
      CodeRay.scan(code, language).div(:line_numbers => :table, 
      	                               :line_number_anchors => false,
      	                               :bold_every => false)
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
```

Rulesでfilter適用時にrendererオプションを定義します。

```ruby
#Rules
#compile ----------------------------------------------------------------------
compile '*' do
  if item.binary?
    # don't filter binary items
  else
    case item[:extension]
      when 'md'
        filter :redcarpet, :options  => { :fenced_code_blocks => true,
                                          :autolink -> true },
                           :renderer => ArticleRenderer
        layout 'default'
      else
        filter :haml
        layout 'default'
    end
  end
end
```

これで使えるようになりました。

#### テスト

##### 例①

###### markdown内での記述

```plain
ニュートンの運動方程式は、`$F = ma$`です。
ピタゴラスの定理は、`\(a^2 = b^2 + c^2\)`です。
```

###### 出力

ニュートンの運動方程式は、`$F = ma$`です。ピタゴラスの定理は、`\(a^2 = b^2 + c^2\)`です。

##### 例②

###### markdown内での記述

~~~plain
ミカエリスメンテンの式

　```mathjax
　v = \rm\frac{V_{max}[S]}{K_m + [S]}
　```
~~~

###### 出力

ミカエリスメンテンの式

```mathjax
v = \rm\frac{V_{max}[S]}{K_m + [S]}
```

#### 参考

* MathJaxの使い方
  http://genkuroki.web.fc2.com/

* ruhoh plugin to overload the redcarpet parser with mathjax tags
  https://gist.github.com/plusjade/2699636