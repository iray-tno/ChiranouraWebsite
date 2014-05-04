---

title: "Cygwin上でMatplotlibをインストールする。"
author: iray_tno
category: Science
tags: ["Computer","Python","Cygwin","Matplotlib","Redcarpet"]

---

#### はじめに

前回pipをインストールしたのはMatplotlibを使うためでした。
しかし、`pip install matplotlib`とするとビルド時にエラーを吐いて止まりました。

調べてみると、これはCygwin固有のバグのようで、既に報告されており次のバージョンでは直ると思います。

修正方法もわかっていたので、練習も兼ねてpatchを作成し動くようにしました。

以下に手順をまとめます。windows8+cyginw64とwindows7+cygwin64で動くのを確認済です。

<!-- headline -->

#### 依存の解決

cygwinのsetup-x86_64.exeから以下のパッケージをインストールします。

- python-numpy
- X11カテゴリーすべて
- libfreetype-devel
- python-gtk2.0
- python-tkinter
- libpng-devel
- libX11-devel

また、以下のurlからmatplotlib-1.3.1.tar.gzをダウンロードし、適当なディレクトリに展開します。

matplotlib(http://matplotlib.org/downloads.html)

#### バグの修正とインストール

単に`python setup.py install`とすると、ビルドに失敗します。

matplotlib error while installing pyspeckit
(http://stackoverflow.com/questions/18560249/matplotlib-error-while-installing-pyspeckit)

修正方法は`_C`という名前の変数を出現箇所すべて`_Co`（なんでもいい）に変更するだけですが、練習としてpatchを作成しました。

```diff
--- ./lib/matplotlib/tri/_tri.cpp	2013-10-10 21:42:48.000000000 +0900
+++ ./lib/matplotlib/tri/_tri.cpp	2014-01-10 13:29:25.837581500 +0900
@@ -2177,13 +2177,13 @@
 
 
 RandomNumberGenerator::RandomNumberGenerator(unsigned long seed)
-    : _M(21870), _A(1291), _C(4621), _seed(seed % _M)
+    : _M(21870), _A(1291), _Co(4621), _seed(seed % _M)
 {}
 
 unsigned long
 RandomNumberGenerator::operator()(unsigned long max_value)
 {
-    _seed = (_seed*_A + _C) % _M;
+    _seed = (_seed*_A + _Co) % _M;
     return (_seed*max_value) / _M;
 }
 
--- ./lib/matplotlib/tri/_tri.h	2013-10-10 21:42:48.000000000 +0900
+++ ./lib/matplotlib/tri/_tri.h	2014-01-10 13:25:46.188018200 +0900
@@ -818,7 +818,7 @@
     unsigned long operator()(unsigned long max_value);
 
 private:
-    const unsigned long _M, _A, _C;
+    const unsigned long _M, _A, _Co;
     unsigned long _seed;
 };
```

上記パッチをコピペするか、下記urlからダウンロードして解凍し、matplotlib-1.3.1フォルダ直下に置きます。

gist（https://gist.github.com/iray-tno/3e3121cc26eb38e06530）

cygwinでmatplotlib-1.3.1フォルダ直下に移動し、以下のコマンドを実行します。

```plain
patch -p0 -d ./ < ./matplotlib-1.3.1_cygwin.patch
python setup.py install
```

これでビルドが成功したと思います。

#### サンプル

公式のサンプルを実行してみます。

http://matplotlib.org/examples/mplot3d/lines3d_demo.html

`startxwin`とするとX Serverが起動し、ターミナルがひらきます。

そのターミナルの中で、`python ./line3d_demo.py`とすると、新たにウィンドウが開き、プロットが表示されます。

![2014-03-20_01_lines3d_demo](/img/articles/2014-03-20_01_lines3d_demo.jpg "2014-03-20_01_lines3d_demo"){

#### Cygwin標準の端末（mintty）でXを使う

Cygwin標準の端末（mintty）でXを使う方法は以下のurlを参考にしてください。

CygwinでX Windowを使う（http://keisanbutsuriya.blog.fc2.com/blog-entry-40.html）

簡単にまとめると

- .bashrcの最後に`export DISPLAY=:0.0`を追加
- .bashrcと同じ場所に空のファイル`.startxwinrc`を作成