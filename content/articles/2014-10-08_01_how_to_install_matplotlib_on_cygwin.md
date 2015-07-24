---

title: "Cygwin上でMatplotlibをインストールする。"
author: iray_tno
category: Science
tags: ["Computer","Python","Cygwin","Matplotlib","Pip"]
changefreq: yearly
priority: 1.0

---

#### はじめに

Matplotlibの1.4.0がリリースされたようです。

それに伴って[Cygwin上でMatplotlibをインストールする。](/articles/2014-03-20_01_how_to_install_matplotlib_on_cygwin/)で書いたバグも直っているようです。記事に書いたパッチの適用は必要なくなりました。

つまり、依存するパッケージをインストールして、pipを動くようにしたら`pip install matplotlib`とするだけでインストールは完了です。

（アップデートなら`pip install -U matplotlib`）

一応、前回の記事を読んでいない人のためにインストール手順を以下に簡単に書いておきます。

<!-- headline -->

#### 依存の解決

cygwinのsetup-x86_64.exeから以下のパッケージをインストールします。（上３つはpipが依存するパッケージ）

- python-setuptools（又はpython3-setuptools）
- binutils
- libuuid-devel
- python-numpy（又はpython3-numpy）
- X11カテゴリーすべて
- libfreetype-devel
- python-gtk2.0（python3-gtk2.0はまだ無い）
- python-tkinter（又はpython3-tkinter）
- libpng-devel
- libX11-devel
- pkg-config

参考：http://superuser.com/questions/770174/cannot-install-matplotlib-in-cygwin-freetype-issue

注意点としては、setup.exeから上記のパッケージ（特に`python-*`）をインストールする前に、pipからの自動で依存を解決するインストールを試みたり（`pip install matplotlib`）すると、ソースからビルドされたnumpyが入ってしまったりしてうまくインストールできなくなったりする。

そういうときは、`pip uninstall numpy`とかやったあとに、setup.exeから上記のパッケージをインストールしなおそう。

#### pipのインストール

Matplotlibのインストールにpipを使うので上でインストールしたsetuptoolsを使ってpipをインストールします。（[Cygwin上でpipとsetuptoolsをインストールする方法](/articles/2014-03-04_01_how_to_install_pip_and_setuptools/)）

```plain
$ easy_install-2.7 pip
```

#### Matplotlibのインストール

pipを使ってMatplotlibをインストールします。

```plain
$ pip install matplotlib
```

古いバージョンのMatplotlibが既にインストールされているなら、アップデートのオプションをつけます。

```plain
$ pip install -U matplotlib
```


#### サンプル

公式のサンプルを実行してみます。以下のurlからline3d_demo.pyをダウンロードして適当な場所に保存します。

http://matplotlib.org/examples/mplot3d/lines3d_demo.html

`startxwin`とするとX Serverが起動し、白いターミナルがひらきます。Cygwinではグラフィカルなアプリを起動するにはXが必要になります。

そのターミナルの中で、`python ./line3d_demo.py`とすると、新たにウィンドウが開き、プロットが表示されます。

![2014-03-20_01_lines3d_demo](/img/articles/2014-03-20_01_lines3d_demo.jpg "2014-03-20_01_lines3d_demo")

#### Cygwin標準の端末（mintty）でXを使う

Cygwin標準の端末（mintty）からでもXを使うことができますが追加で設定が必要になります。以下のurlを参考にしてください。

~~CygwinでX Windowを使う(http://keisanbutsuriya.blog.fc2.com/blog-entry-40.html)　~~

~~簡単にまとめると~~

- ~~.bashrcの最後に`export DISPLAY=:0.0`を追加~~
- ~~.bashrcと同じ場所に空のファイル`.startxwinrc`を作成~~

~~minttyを起動したら、`startxwin`コマンドを実行すると、裏でX Serverが起動し、minttyからXが使えるようになります。~~


__!!!2015/02/27追記!!!__

Xの挙動が変わったようです。詳しくは(http://keisanbutsuriya.hateblo.jp/entry/2015/01/25/221642)を参照してください。

以下に簡単なまとめ

- 上の手順で作った`.startxwinrc`は削除

- '.bashrc'に以下の2行を追加

```plain
export DISPLAY=:0.0
alias runx='run xwin -multiwindow -noclipboard'
```

使う前に`runx`するとmatplotlibが使えるようになる。

```plain
$ runx
$ python ./line3d_demo.py
```
