---

title: "CygwinでSciPyをインストール。"
author: iray_tno
category: Science
tags: ["Computer","Python","Cygwin","Scipy","Pip"]
changefreq: yearly
priority: 1.0

---

#### はじめに

SciPyというライブラリを使うとPythonで簡単に最適化問題が解けます。以下にインストール方法を書いておきます。環境はWindows8.1、Cygwin64です。Python3を使うならpipをpip3に適当に読み替えてください。

pipとmatplotlibを先にインストールしておきましょう。

- [Cygwin上でpipとsetuptoolsをインストールする方法](/articles/2014-05-27_01_how_to_install_pip_and_setuptools/)
- [Cygwin上でMatplotlibをインストールする。](/articles/2014-10-08_01_how_to_install_matplotlib_on_cygwin/)

<!-- headline -->

#### 依存の解決

以下のパッケージをcygwinのsetup.exeからインストールしてください。（matplotlibをインストールしていないなら、matplotlibの方で書いたものの中にも必要なものがあるかもしれない。）

- lapack
- liblapack-devel
- liblapack0
- bc
- ffftw3
- libfftw3-devel
- libfftw3_3
- libgmp10
- libgmpxx4
- libmpc3
- libmpfr4
- python-numpy（python3-numpy）
- gcc-fortran

もしいらないもの見つけたらコメント欄などで教えて頂けると嬉しいです。

#### インストール

ビルドめっちゃ時間かかる。

```plain
$ pip install scipy
Downloading/unpacking scipy
  Downloading scipy-0.15.1.tar.gz (11.4MB): 11.4MB downloaded
略
Successfully installed scipy
Cleaning up...
```

#### サンプル

以下のurlからいくつか実行してみてください。

- http://scipy.org/getting-started.html
- http://aidiary.hatenablog.com/entry/20140414/1397481258

