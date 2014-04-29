---

title: "Cygwin上でMatplotlibをインストールする。"
author: iray_tno
category: Science
tags: ["Computer","Python","Cygwin","Matplotlib","Redcarpet"]

---

#### はじめに

前回の記事でpipをインストールしましたが、それはMatplotlibをインストールする目的のためでした。

pipが動くことを確認して`pip install matplotlib`とやってみると、エラーが出てビルドできませんでした。

調べてみると、Cygwin固有の既に報告されている問題の様で、開発者も認識しているようなので次のバージョンでは直ると思います。

修正方法もわかっていたので、練習も兼ねてpatchを書いてみました。

以下の手順でwindows8+cyginw64とwindows7+cygwin64で動くのを確認済です。

