---

title: "CygwinにEigenをインストール。"
author: iray_tno
category: Science
tags: ["Computer","Cygwin","Eigen"]
changefreq: yearly
priority: 1.0
publish: true

---

#### はじめに

CygwinにC++用行列計算ライブラリEigenをインストールする方法です。

公式：http://eigen.tuxfamily.org/index.php?title=Main_Page

<!-- headline -->

#### 依存の解決

以下のパッケージをcygwinのsetup.exeからインストールしてください。

- gcc-g++
- gcc-fortran
- make
- cmake
- wget（ダウンロードにつかう）

（正直よくわからん。追加で必要なもの知っていたら教えてくださるとうれしいです。）

#### インストール

`wget`して`cmake`して`make install`するだけ。`/usr/local/include`以下にインストールされる。

今回はEigen3.2.5をインストールした。

```plain
$ cd /usr/src
$ wget http://bitbucket.org/eigen/eigen/get/3.2.5.tar.bz2
$ tar -xvjf ./3.2.5.tar.bz2
$ cd eigen-eigen-bdd17ee3b1b3/
$ mkdir build
$ cd build
$ cmake ..
$ make install
```

おわり
