---

title: "Cygwin上でMatplotlibをインストールする。"
author: iray_tno
category: Science
tags: ["Computer","Python","Cygwin","Matplotlib","pip"]
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

cygwinのsetup-x86_64.exeから以下のパッケージをインストールします。

- python-setuptools（又はpython3-setuptools）
- binutils
- libuuid-devel
- python-numpy
- X11カテゴリーすべて
- libfreetype-devel
- python-gtk2.0
- python-tkinter
- libpng-devel
- libX11-devel

（上から３つはpipが依存するパッケージ）

#### pipのインストール

Matplotlibのインストールにpipを使うので上でインストールしたsetuptoolsを使ってpipをインストールします。（[Cygwin上でpipとsetuptoolsをインストールする方法](/articles/2014-03-04_01_how_to_install_pip_and_setuptools/)）

```plain
$ easy_install pip
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

Cygwin標準の端末（mintty）からでもXを使うことができます多追加で設定が必要になります。以下のurlを参考にしてください。

CygwinでX Windowを使う(http://keisanbutsuriya.blog.fc2.com/blog-entry-40.html)

簡単にまとめると

- .bashrcの最後に`export DISPLAY=:0.0`を追加
- .bashrcと同じ場所に空のファイル`.startxwinrc`を作成

minttyを起動したら、`startxwin`コマンドを実行すると、裏でX Serverが起動し、minttyからXが使えるようになります。

```plain
$ startxwin
$ python ./line3d_demo.py
```
