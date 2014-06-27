---

title: "nanoc viewを使う便利なスクリプト"
author: iray_tno
category: Science
tags: ["Computer","Nanoc","Cygwin"]
changefreq: yearly
priority: 1.0

---

#### はじめに

nanocでレイアウトをいじりながらデザインを試行錯誤する時には、 `nanoc view` でローカルホストのサーバーを起動し、ブラウザでlocalhost:3000を開くという一連の動作を何度も繰り返すことになります。

今回はCygwin上で作業を行ってるとします。Cygwinでは `cygstart http://localhost:3000/` とすると規定のブラウザでプレビューを開くことができます。

この一連の動作を一つのコマンドでできるようにスクリプトを書きたいところですが、`nanoc view; cygstart http://localhost:3000/` としても、nanoc viewをCtrl+Cなどで終了するまで開いてくれません。

さて、どうしたらいいでしょうか？

<!-- headline -->

#### 答え

答えは単純で、順序を逆にするだけです。 `cygstart http://localhost:3000/; nanoc view`

（たまに失敗することもあるけど・・）
