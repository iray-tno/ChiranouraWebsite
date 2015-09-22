---

title: "Cygwinにredsvdをインストール。"
author: iray_tno
category: Science
tags: ["Computer","Cygwin","Eigen","redsvd","特異値分解(SVD)"]
changefreq: yearly
priority: 1.0
publish: true

---

#### はじめに

Cygwinに高速特異値分解ライブラリredsvdをインストールする方法です。

redsvdを使うと大規模疎行列に対する特異値分解が高速に計算できるらしい。

作者のブログ：http://hillbig.cocolog-nifty.com/do/2010/08/redsvd-aa59.html

公式：https://code.google.com/p/redsvd/

<!-- headline -->

#### 依存の解決

redsvdはEigenを使っているのでインストールしてないなら、[CygwinにEigenをインストール](/articles/2015-09-22_01_how_to_install_eigen/)を見て。

また、redsvdはビルドシステムにwafを使っているのでPythonが必要になります。

以下のパッケージをcygwinのsetup.exeからインストールしてください。

- python

（正直よくわからん。追加で必要なもの知っていたら教えてくださるとうれしいです。）

#### インストール

今回はredsvd0.2.0をインストールした。configureの時にeigenがないと怒られるが普通にビルドできる。（上記の記事の通りインストールしていれば）

```plain
$ cd /usr/src
$ wget https://redsvd.googlecode.com/files/redsvd-0.2.0.tar.bz2
$ tar -xvjf redsvd-0.2.0.tar.bz2
$ cd redsvd-0.2.0
$ ./waf configure
$ ./waf
$ ./waf install
```

おわり

#### チェック

```plain
$ redsvd
usage: redsvd --input=string --output=string [options] ...

redsvd supports the following format types (one line for each row)

[format=dense] (<value>+\n)+
[format=sparse] ((colum_id:value)+\n)+
Example:
>redsvd -i imat -o omat -r 10 -f dense
compuate SVD for a dense matrix in imat and output omat.U omat.V, and omat.S
with the 10 largest eigen values/vectors
>redsvd -i imat -o omat -r 3 -f sparse -m PCA
compuate PCA for a sparse matrix in imat and output omat.PC omat.SCORE
with the 3 largest principal components

options:
  -i, --input     input file (string)
  -o, --output    output file's prefix (string)
  -r, --rank      rank       (int [=10])
  -f, --format    format type (dense|sparse) See example.  (string [=dense])
  -m, --method    method (SVD|PCA|SymEigen) (string [=SVD])
```

#### 使ってみる

オプションはヘルプにある通り。フォーマットをsparseにするとインプットが疎行列を表現する形式になる。

サイズが10以上の行列に使うときはちゃんとランクを指定する（デフォルトだと10で切り上げられる）。

同じ行列のSVD計算結果を２つのフォーマットで以下に示す。

##### dense（密行列用）

inputはスペース区切り。（タブでもいけるかも？）

inputファイルの末尾に改行あってもなくても同じ。

```plain
$ cat input_d.txt
1 0 3
2 0 6
1 2 3
0 2 0

$ redsvd -i input_d.txt -o out_d -f dense
compute SVD
read matrix from input_d.txt ... 0.000178814 sec.
rows:   4
cols:   3
rank:   10
compute ... 3.69549e-05 sec.
write out_d.U
write out_d.S
write out_d.V
0.00354409 sec.
finished.

$ cat out_d.U
+0.402809 -0.139868 +0.000000
+0.805618 -0.279736 +0.000000
+0.433349 +0.598049 +0.000000
+0.030540 +0.737917 +0.000000

$ cat out_d.S
+7.794752
+2.691063
+0.000000

$ cat out_d.V
+0.313980 -0.037639 +0.000000
+0.119026 +0.992891 +0.000000
+0.941939 -0.112918 +0.000000
```

##### sparse（疎行列用）

疎行列フォーマットでは各行が行列の行に対応し、「0でない要素の列番号」を「その要素の値」に添えて記述する。（n列の値が1.14514ならn:1.14514）

公式のこの記述を誤解して列番号が1始まりだとしている記事があったけど0始まり。

密行列のinputと見比べたらわかるとおもう。

inputファイルの末尾に改行をつけると、全要素がゼロの行が追加されてしまうのかなあと思ったけどそんなことはなくて、以下の例でも末尾に改行つけている。

ただし、最後の行に半角スペースとかがあると最後に全要素がゼロの行が追加されてしまうみたい。

最後に全要素がゼロの行をいれたいなら半角スペースを使ってもいいけど、もっとわかりやすく`0:0`とか書いたほうがいいと思う。

```plain
$ cat input_s.txt
0:1 2:3
0:2 2:6
0:1 1:2 2:3
1:2

$ redsvd -i input_s.txt -o out_s -f sparse
compute SVD
read matrix from input_s.txt ... 0.000203133 sec.
rows:   4
cols:   3
rank:   10
compute ... 4.60148e-05 sec.
write out_s.U
write out_s.S
write out_s.V
0.0024538 sec.
finished.

$ cat out_s.U
+0.402809 -0.139868 +0.000000
+0.805618 -0.279736 +0.000000
+0.433349 +0.598049 +0.000000
+0.030540 +0.737917 +0.000000

$ cat out_s.S
+7.794752
+2.691063
+0.000000

$ cat out_s.V
+0.313980 -0.037639 +0.000000
+0.119026 +0.992891 +0.000000
+0.941939 -0.112918 +0.000000
```

##### 補足

各記事の下にあるRelatedPostsはredsvdを使ってLSIした結果です。

sparseのフォーマットだと各行が1つの記事のBOWに対応するように書いた方が楽だけど、その場合は行列Uの各行が各記事を示すベクトルに対応する。（行列Vは基底）

逆にinputの各列が各記事に対応するようにすると、行列Vの各行が各記事を示すベクトルになる。（行列Uは基底）
