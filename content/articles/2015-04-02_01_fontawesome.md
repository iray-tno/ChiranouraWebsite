---

title: "fontawesomeをnanocで使えるようにするまで"
author: iray_tno
category: Science
tags: ["Computer","Nanoc","Cygwin","Sass"]
changefreq: yearly
priority: 1.0

---

#### はじめに

nanocでfontawesome使えるようにするのに手間取ったので手順をメモする。

<!-- headline -->

#### gemfileに'font-awesome-sass'を追加

```ruby
#gemfile
source 'https://rubygems.org'

gem 'nanoc'
gem 'sass'
gem 'susy'
gem 'compass'
gem 'coderay'
gem 'redcarpet'
gem 'haml'
gem 'builder'
gem 'adsf'
gem 'json'
gem 'font-awesome-sass'
```

あぷでと

```plain
bundle exec update
```

#### fontawesomeのデータを追加

fontawesome.zipをダウンロードして解凍して中身のfontsフォルダだけcssと同じディレクトリ（/stylesheets/）にコピー

compassのこんふぃぐについか

```ruby
#.compass/config.rb
# Require any additional compass plugins here.
require 'susy'
require 'font-awesome-sass'
```

scssファイルについか

```scss
#screen.scss
@import "font-awesome-compass";
@import "font-awesome";

@font-face {
font-family: "FontAwesome";
src: url("fonts/fontawesome-webfont.eot");
src: url("fonts/fontawesome-webfont.eot") format("embedded-opentype"),
url("fonts/fontawesome-webfont.woff") format("woff"),
url("fonts/fontawesome-webfont.ttf") format("truetype"),
url("fonts/fontawesome-webfont.svg") format("svg");
font-weight: normal;
font-style: normal;
}
```

#### nanocのコンパイルでスルーされるように設定

```yaml
#nanoc.yaml
data_sources:
  -
    type: filesystem_unified
    layouts_root: /
    allow_periods_in_identifiers: false
  -
    type: static
    items_root: /
    allow_periods_in_identifiers: true
```

```ruby
#rules.rb
#compileの一番上に書く
passthrough '/stylesheets/fonts/*/'
```

おわり

```plain
bundle exec nanoc co
```

#### 色変えたいなら

```scss
.fa-cc-paypal{
  color: white;
};
```
