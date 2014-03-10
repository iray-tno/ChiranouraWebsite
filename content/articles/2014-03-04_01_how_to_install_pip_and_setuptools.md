---

title: "Cygwin上でpipとsetuptoolsをインストールする方法"
author: iray_tno
category: Science
tags: ["Computer","Python","pip","setuptools","Cygwin"]

---


#### はじめに

最近Pythonを使うようになりました。

Windows8（とWindows7）、64bit、Cygwinという環境だとpipを使えるようにするのに手間取ったのでメモしておきます。

Rubyには標準でgemという便利なパッケージ管理ツールがついてきますが、Pythonには何もついてこないので自分でインストールする必要があります。今はpipが主流のようです。setuptoolsもpipと同様にパッケージ管理ツールで、pipの動作に必要なのでインストールします。

<!-- headline -->

#### setuptoolsのインストール

Cygwinでのsetuptoolsのインストールは、setup.exeから行います。

以下のurlから32bitならsetup-x86.exe、64bitならsetup-x86_64.exeをダウンロードし、python-setuptools（又はpython3-setuptools）をインストールします。

http://cygwin.com/install.html

setuptoolsは、`easy_install`というコマンドから使えます。

```plain
$ easy_install --version
distribute 0.6.34
```

#### pipのインストール

setuptoolsが使えるようになったので、さっそく`easy_install pip`としたいところですが、最新版のpipは64bit版のcygwinでうまく動かないようなので、1.4のpipをインストールします。

>pip command exits immediately on Cygwin(https://github.com/pypa/pip/issues/1448)

最新版をインストールしてしまった場合は、以下のようにしてアンインストールしてください。（参考:http://d.hatena.ne.jp/ikeas/20110611/1307801621）

```plain
$ easy_install -mxN pip
$ rm -r /lib/python2.7/site-packages/pip-1.5.4-py2.7.egg
```

1.4.1のpipをインストールします。自分でダウンロードして、解凍、`python setup.py`としてもいいのですが、easy_installはurlを指定することもできるので、コマンドからインストールします。

```plain
$ easy_install https://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz
Downloading https://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz
Processing pip-1.4.1.tar.gz
Writing /tmp/easy_install-aWWXNk/pip-1.4.1/setup.cfg
Running pip-1.4.1/setup.py -q bdist_egg --dist-dir /tmp/easy_install-aWWXNk/pip
-1.4.1/egg-dist-tmp-Z2_i0p
warning: no files found matching '*.html' under directory 'docs'
warning: no previously-included files matching '*.rst' found under directory 'd
ocs/_build'
no previously-included directories found matching 'docs/_build/_sources'
Adding pip 1.4.1 to easy-install.pth file
Installing pip script to /usr/bin
Installing pip-2.7 script to /usr/bin

Installed /usr/lib/python2.7/site-packages/pip-1.4.1-py2.7.egg
Processing dependencies for pip==1.4.1
Finished processing dependencies for pip==1.4.1
```

これで、pipが使えるようになりました。

```plain
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
  zip                         Zip individual packages.
  unzip                       Unzip individual packages.
  bundle                      Create pybundles.
  help                        Show help for commands.

General Options:
  -h, --help                  Show help.
  -v, --verbose               Give more output. Option is additive, and can be 
  used up to 3 times.
  -V, --version               Show version and exit.
  -q, --quiet                 Give less output.
  --log <file>                Log file where a complete (maximum verbosity) rec
  ord will be kept.
  --proxy <proxy>             Specify a proxy in the form [user:passwd@]proxy.s
  erver:port.
  --timeout <sec>             Set the socket timeout (default 15 seconds).
  --exists-action <action>    Default action when a path already exists: (s)wit
  ch, (i)gnore, (w)ipe, (b)ackup.
  --cert <path>               Path to alternate CA bundle.
```
