---

title: "Cygwin上でpipとsetuptoolsをインストールする方法"
author: iray_tno
category: Science
tags: ["Computer","Python","pip","setuptools","Cygwin"]
changefreq: yearly
priority: 1.0

---


#### はじめに

[Cygwin上でpipとsetuptoolsをインストールする方法](/articles/2014-03-04_01_how_to_install_pip_and_setuptools)で書いた、Cygwin64で最新版のpipが動かない問題の解決策がわかったので書き直しました。

Cygwinのsetup-x86_64.exeから、`binutils` と `libuuid-devel` の２つのパッケージを追加でインストールすれば動くようになります。64bitのwindows8とwindows7で確認しました。

一応以下に一連の手順を書いておきます。

<!-- headline -->

#### 依存の解決

pipは以下のパッケージに依存しているのでCygwinのsetup.exeからインストールします。

- python-setuptools（又はpython3-setuptools）
- binutils
- libuuid-devel

>hellerbarde commented on May 6  
>For future Unixers in Windows territory:  
>I'm using cygwin64 on windows 8, 64 bit and I had to install both "binutils" and "libuuid-devel" to make pip work.  
>(https://github.com/pypa/pip/issues/1448)

setup.exeは以下のurlからダウンロードします。32bitならsetup-x86.exe、64bitならsetup-x86_64.exeです。

http://cygwin.com/install.html

setuptoolsは、`easy_install`というコマンドから使えます。

```plain
$ easy_install --version
setuptools 2.1
```

#### 古いpipのアンインストール

前の記事に惑わされて（？）1.4.1のpipをインストールした人はアンインストールしてください。(参考:http://d.hatena.ne.jp/ikeas/20110611/1307801621)

```plain
$ easy_install -mxN pip
$ rm -r /lib/python2.7/site-packages/pip-1.4.1-py2.7.egg
```

#### pipのインストール

あとはsetuptoolsを使ってpipをインストールするだけです。

```plain
$ easy_install pip
$ pip help

Usage:
  pip <command> [options]

Commands:
  install                     Install packages.
  uninstall                   Uninstall packages.
  freeze                      Output installed packages in requirements format.
  list                        List installed packages.
  show                        Show information about installed packages.
  search                      Search PyPI for packages.
  wheel                       Build wheels from your requirements.
  zip                         DEPRECATED. Zip individual packages.
  unzip                       DEPRECATED. Unzip individual packages.
  bundle                      DEPRECATED. Create pybundles.
  help                        Show help for commands.

General Options:
  -h, --help                  Show help.
  -v, --verbose               Give more output. Option is additive, and can be 
  used up to 3 times.
  -V, --version               Show version and exit.
  -q, --quiet                 Give less output.
  --log-file <path>           Path to a verbose non-appending log, that only lo
  gs failures. This log is active by default at /home/Yuta/.pip/pip.log.
  --log <path>                Path to a verbose appending log. This log is inac
  tive by default.
  --proxy <proxy>             Specify a proxy in the form [user:passwd@]proxy.s
  erver:port.
  --timeout <sec>             Set the socket timeout (default 15 seconds).
  --exists-action <action>    Default action when a path already exists: (s)wit
  ch, (i)gnore, (w)ipe, (b)ackup.
  --cert <path>               Path to alternate CA bundle.
```
