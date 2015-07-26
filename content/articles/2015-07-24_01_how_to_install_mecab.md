---

title: "CygwinでMeCabインストール。"
author: iray_tno
category: Science
tags: ["Computer","MeCab","Cygwin","自然言語処理(NLP)"]
changefreq: yearly
priority: 1.0

---

#### はじめに

日本語の自然言語処理に欠かせない形態素解析エンジンMeCabをCygwinにインストールします。

MeCabの最新バージョンは0.996ですが、Cygwinでは0.996がビルドに失敗するため、0.98を使ってる人が多いようです。

少し前までは、0.99xをビルドできるようにするパッチを公開している方が居たようですが、現在は非公開になってしまいました。

僕もずっとそのパッチを探していたのですが、見つからなかったので作りました。

<!-- headline -->

#### 依存の解決

以下のパッケージをcygwinのsetup.exeからインストールしてください。

>- gcc-g++
>- make
>- expat
>- gettext
>- gettext-devel
>- libiconv
>- libtool
>
>　引用：http://www.mk-mode.com/octopress/2012/03/06/06002013/

#### パッチ

パッチを以下のURLからダウンロードするか、下にあるものをコピペして`mecab-0.996.patch`という名前で、/usr/src以下に保存しましょう。

https://gist.github.com/iray-tno/c0f00363fc2553218d5d

```patch
diff -ur mecab-0.996/src/dictionary.cpp mecab-0.996_new/src/dictionary.cpp
--- mecab-0.996/src/dictionary.cpp	2013-02-16 11:50:46.000000000 +0900
+++ mecab-0.996_new/src/dictionary.cpp	2015-07-24 21:27:47.671159100 +0900
@@ -5,6 +5,7 @@
 //  Copyright(C) 2004-2006 Nippon Telegraph and Telephone Corporation
 #include <fstream>
 #include <climits>
+#include <vector>
 #include "connector.h"
 #include "context_id.h"
 #include "char_property.h"
diff -ur mecab-0.996/src/feature_index.cpp mecab-0.996_new/src/feature_index.cpp
--- mecab-0.996/src/feature_index.cpp	2012-11-25 14:35:33.000000000 +0900
+++ mecab-0.996_new/src/feature_index.cpp	2015-07-24 21:28:32.020428600 +0900
@@ -7,6 +7,7 @@
 #include <cstring>
 #include <fstream>
 #include <string>
+#include <vector>
 #include "common.h"
 #include "feature_index.h"
 #include "param.h"
diff -ur mecab-0.996/src/tagger.cpp mecab-0.996_new/src/tagger.cpp
--- mecab-0.996/src/tagger.cpp	2013-02-18 01:55:30.000000000 +0900
+++ mecab-0.996_new/src/tagger.cpp	2015-07-24 21:25:32.112288000 +0900
@@ -6,6 +6,7 @@
 #include <cstring>
 #include <iostream>
 #include <iterator>
+#include <vector>
 #include "common.h"
 #include "connector.h"
 #include "mecab.h"
diff -ur mecab-0.996/src/tokenizer.cpp mecab-0.996_new/src/tokenizer.cpp
--- mecab-0.996/src/tokenizer.cpp	2013-01-23 23:58:03.000000000 +0900
+++ mecab-0.996_new/src/tokenizer.cpp	2015-07-24 21:27:12.790503000 +0900
@@ -3,6 +3,7 @@
 //
 //  Copyright(C) 2001-2011 Taku Kudo <taku@chasen.org>
 //  Copyright(C) 2004-2006 Nippon Telegraph and Telephone Corporation
+#include <vector>
 #include "common.h"
 #include "connector.h"
 #include "darts.h"
diff -ur mecab-0.996/src/viterbi.cpp mecab-0.996_new/src/viterbi.cpp
--- mecab-0.996/src/viterbi.cpp	2013-02-18 01:00:26.000000000 +0900
+++ mecab-0.996_new/src/viterbi.cpp	2015-07-24 21:24:20.645948500 +0900
@@ -7,6 +7,7 @@
 #include <iterator>
 #include <cmath>
 #include <cstring>
+#include <vector>
 #include "common.h"
 #include "connector.h"
 #include "mecab.h"
diff -ur mecab-0.996/src/winmain.h mecab-0.996_new/src/winmain.h
--- mecab-0.996/src/winmain.h	2012-10-28 13:07:01.000000000 +0900
+++ mecab-0.996_new/src/winmain.h	2015-07-24 23:19:06.803341500 +0900
@@ -2,7 +2,7 @@
 //
 //  Copyright(C) 2001-2011 Taku Kudo <taku@chasen.org>
 //  Copyright(C) 2004-2006 Nippon Telegraph and Telephone Corporation
-#if defined(_WIN32) || defined(__CYGWIN__)
+#if defined(_WIN32) && !defined(__CYGWIN__)
 
 #include <windows.h>
 #include <string>
```

#### インストール

以下のURLから、`mecab-0.996.tar.gz`と、IPA 辞書をダウンロードして、おなじく/usr/src以下に置きましょう。

http://taku910.github.io/mecab/#download

あとは以下のコマンドでインストールできます。（`CPPFLAGS=-DNOMINMAX LIBS=-liconv`はつけなくて大丈夫っぽい）

```plain
$ cd /usr/src
$ tar zxvf mecab-0.996.tar.gz
$ tar zxvf mecab-ipadic-2.7.0-20070801.tar.gz
$ patch -p1 -d ./mecab-0.996/ < ./mecab-0.996.patch
$ cd ./mecab-0.996
$ ./configure --with-charset=utf-8; make; make install
$ cd ../mecab-ipadic-2.7.0-20070801
$ ./configure --with-charset=utf-8; make; make install
```

#### サンプル

```plain
$ mecab
すもももももももものうち
すもも  名詞,一般,*,*,*,*,すもも,スモモ,スモモ
も      助詞,係助詞,*,*,*,*,も,モ,モ
もも    名詞,一般,*,*,*,*,もも,モモ,モモ
も      助詞,係助詞,*,*,*,*,も,モ,モ
もも    名詞,一般,*,*,*,*,もも,モモ,モモ
の      助詞,連体化,*,*,*,*,の,ノ,ノ
うち    名詞,非自立,副詞可能,*,*,*,うち,ウチ,ウチ
EOS
```

#### パッチを作るコマンド

よく忘れる。

```plain
$ diff -ur ./mecab-0.996 ./mecab-0.996_new/ > mecab-0.996.patch
```

