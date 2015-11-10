---

title: "Cygwinにnodejsとnpmをインストールする方法"
author: iray_tno
category: Science
tags: ["Computer","Cygwin","Eigen","redsvd","特異値分解(SVD)"]
changefreq: yearly
priority: 1.0
publish: true

---

#### はじめに

Electron( http://electron.atom.io/ )使ってみてえという気持ちが高まったのでCygwinにNode.jsをインストールしようとしたお話し。

結論：Cygwinはサポート外でいろいろ試しても超古いバージョンしか動かなかった。普通に公式からWindows用のバイナリをインスコしようぜ。

今回はWindows10にNode.js 5.0.0をインストールした。

Node.js公式( https://nodejs.org/en/ )

<!-- headline -->

#### Cygwinへのインストールに失敗したお話し

- naveを使ったnode.jsインストールと、最近のnpmの使い方
http://d.hatena.ne.jp/bellbind/20110530/1306764093

上の記事を見ながらNode.jsをインストールしようとしたんだけどnaveは入ってもNode.jsのlatestをビルドする段階でこける。よくよく調べてみるとCygwinはサポート外になったらしい。

> Cygwin is no longer supported, despite being POSIX compliant. The latest version that compiles is 0.4.12.  
> 引用元:https://github.com/nodejs/node-v0.x-archive/wiki/Installation#building-on-cygwin

最新バージョンは上で書いた5.0.0であるのに対してCygwinで動くのは0.4.12。もうちょっと調べるとパッチを当てて動かそうとしているものもあったけど(例えば https://www.robario.com/2015/10/08 )それでも4.1.2とかだったのであきらめた。

#### Windowsに普通にインストールしたらCygwinでも普通に動いた

ということで公式からWindows用の5.0.0をインストールした。

https://nodejs.org/en/

動かないんやろうな～と思いながらCygwinで試しにコマンド叩いてみたら

```plain
$ node --help
Usage: node [options] [ -e script | script.js ] [arguments]
       node debug script.js [arguments]

Options:
  -v, --version         print Node.js version
  -e, --eval script     evaluate script
  -p, --print           evaluate script and print result
  -c, --check           syntax check script without executing
  -i, --interactive     always enter the REPL even if stdin
                        does not appear to be a terminal
  -r, --require         module to preload (option can be repeated)
  --no-deprecation      silence deprecation warnings
  --throw-deprecation   throw an exception anytime a deprecated function is used
  --trace-deprecation   show stack traces on deprecations
  --trace-sync-io       show stack trace when use of sync IO
                        is detected after the first tick
  --track-heap-objects  track heap object allocations for heap snapshots
  --v8-options          print v8 command line options
  --tls-cipher-list=val use an alternative default TLS cipher list
  --icu-data-dir=dir    set ICU data load path to dir
                        (overrides NODE_ICU_DATA)

Environment variables:
NODE_PATH               ';'-separated list of directories
                        prefixed to the module search path.
NODE_DISABLE_COLORS     set to 1 to disable colors in the REPL
NODE_ICU_DATA           data path for ICU (Intl object) data
NODE_REPL_HISTORY       path to the persistent REPL history file

Documentation can be found at https://nodejs.org/

$ npm

Usage: npm <command>

where <command> is one of:
    access, add-user, adduser, apihelp, author, bin, bugs, c,
    cache, completion, config, ddp, dedupe, deprecate, dist-tag,
    dist-tags, docs, edit, explore, faq, find, find-dupes, get,
    help, help-search, home, i, info, init, install, issues, la,
    link, list, ll, ln, login, logout, ls, outdated, owner,
    pack, ping, prefix, prune, publish, r, rb, rebuild, remove,
    repo, restart, rm, root, run-script, s, se, search, set,
    show, shrinkwrap, star, stars, start, stop, t, tag, team,
    test, tst, un, uninstall, unlink, unpublish, unstar, up,
    update, upgrade, v, verison, version, view, whoami

npm <cmd> -h     quick help on <cmd>
npm -l           display full usage info
npm faq          commonly asked questions
npm help <term>  search for help on <term>
npm help npm     involved overview

Specify configs in the ini-formatted file:
    C:\Users\ryufran\.npmrc
or on the command line via: npm <command> --key value
Config info can be viewed via: npm help config

npm@3.3.6 C:\Program Files\nodejs\node_modules\npm

$ node -e "console.log('hello node')"
hello node
```

普通に動きました。パスも勝手に通っているしインストーラ―でnpmも勝手に入ってくれているようで楽ちん。（一応Cygwinの端末閉じてからインストールした。）

何で普通に動いているのかはよくわからない。改行コードとかパスとかも今のところ大丈夫。（なんで？）

おわり。
