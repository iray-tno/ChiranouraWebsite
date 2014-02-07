---

title: "RedcarpetのレンダラにCodeRayによるシンタックスハイライトを追加"
author: iray_tno
category: Science
tags: ["Computer","Ruby","nanoc","Redcarpet","CodeRay"]

---

このブログでは記事をMarkdownで書いて、Redcarpetとnanocで静的なHTMLを生成しています。

Redcarpetは、レンダラを独自に定義することで拡張が可能です。

そこで、CodeRay使ってMarkdown内のコードブロックにシンタックスハイライトを適用してみます。

* nanoc(http://nanoc.ws/)
* Redcarpet(https://github.com/vmg/redcarpet)
* CodeRay(http://coderay.rubychan.de/)

<!-- headline -->

CodeRayはgemでインストールします。

```plain
$ gem install coderay
```

nanoc上でRedcarpetのレンダラを追加するには、libディレクトリのrubyファイルで、Redcarpet::Render::XHTMLを継承して定義し、Rulesファイル内のfilterにrendererオプションで指定します。

今回は、lib/default.rbにレンダラを定義しました。:line_numbersオプションを定義することで行数が表示されます。
他にも様々なオプションがあります。

http://coderay.rubychan.de/doc/CodeRay/Encoders/HTML.html


```ruby
#lib/default.rb
require "redcarpet"
require "coderay"

class ArticlesRenderer < Redcarpet::Render::XHTML
  def block_code(code, language)
    if language then
      CodeRay.scan(code, language).div(:line_numbers => :table)
    else
      "\n<pre><code>#{code}</code></pre>\n"
    end
  end
end
```

Rulesファイルは以下のようになりました。

```ruby
#Rules
#compile ----------------------------------------------------------------------
compile '/stylesheet/' do
  # don’t filter or layout
end

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
      when 'haml'
        filter :haml
        layout 'default'
      when 'sass'
        filter :sass, sass_options.merge(:syntax => item[:extension].to_sym)
      else
        filter :haml
        layout 'default'
    end
  end
end
```

以下のようにmarkdown内でコードブロックを記述すると

~~~plain
　<!-- markdown -->
　```ruby
　puts 'hello, world'
　```
~~~

以下のようにhtmlが出力されます。

```html  
<table class="CodeRay"><tr>
  <td class="line-numbers"><pre><a href="#n1" name="n1">1</a>
  </pre></td>
  <td class="code"><pre>puts <span style="background-color:hsla(0,100%,50%,0.05)">
    <span style="color:#710">'</span><span style="color:#D20">hello, world</span>
    <span style="color:#710">'</span></span>
  </pre></td>
</tr></table>
```

参考

* nanoc導入メモ 4/5 「Markdown独自拡張」編

  http://n.blueblack.net/articles/2012-05-05_02_nanoc_markdown_customize/

* Redcarpet のシンタックスハイライトに CodeRay を使う

  http://superbrothers.hatenablog.com/entry/20120129/1327840871
