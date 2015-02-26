---

title: "CygwinでLessを動かすメモ"
author: iray_tno
category: Science
tags: ["Computer","Less","Cygwin","Nanoc"]
changefreq: yearly
priority: 1.0

---

#### はじめに

nanocでbootstrapを使おうとしたときに、bootstrapで使われているLessが動かなくて困りました。

nanoc+bootstrapのサンプルはここ(https://github.com/mmc1ntyre/nanoc-bootstrap)

（たしか）windowsとcygwinはパスの形式の違いに由来する問題で動きませんでした。（もうだいぶ前のことで詳細は覚えていない。また必要になった時にやったら書きます）

'gem install less'して'lessc'すると'therubyracer'が必要だって怒られて'gem install therubyracer'するとビルドこけるとかそんなんだったような・・・

とにかく、応急処置的に動かせるようにできたので、メモとして残しておきます。

<!-- headline -->

#### 手順

windowsで動くLessをダウンロードしてきてパスを通すだけ。方法①はWinLessを使う。手順が簡単。方法②はless.js-windowsを使う。ファイルサイズが小さい。

##### 方法①

-　WinLessをインストールする。(http://winless.org/)

-　WinLessについてくるlesscにパスを通す。環境変数PATHに"C:\Program Files (x86)\Mark Lagendijk\WinLess\node_modules\less\bin"を追加。（デフォルトの場所にインストールしたなら）

これで動く

上のサンプルではlib/bootstrap.rbでlessのコンパイルをコマンドから行っている。この方法だと`.bashrc`が読まれないのでwindowsの環境変数に直接書き込む必要がある。

環境変数いじるならRapid Environment Editorがおすすめ。(http://www.rapidee.com/en/about)

##### 手順（方法②）

- less.js-windowsをダウンロードしてどこかに展開する（C:\lib\以下に展開するとする）(http://www.sigesaba.com/2012/10/install-less-and-less2cs-on-windows.php)

- 展開したフォルダのlessc.cmdがある場所にパスを通す。環境変数PATHに"C:\lib\"を追加。

- aliasがきかないので、lessc.cmdにリダイレクトするコマンドlesscを作る。

```plain
lessc.cmd $@
```

これで動く

#### 最後に

なんでこんなうろ覚えなのかというと、nanoc+bootstrapで作ろうと思ってたプロジェクトが立ち消えになったのと、bootstrap-sass使えばLessじゃなくてSass使えるやんってことに後になって気づいたから。
