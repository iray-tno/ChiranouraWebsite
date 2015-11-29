---

title: "CODE FESTIVAL 2015 予選B D問題"
author: iray_tno
category: Science
tags: ["Computer","競プロ(CompProg)","平衡二分探索木(SBSTree)"]
changefreq: yearly
priority: 1.0
publish: true

---

#### はじめに

CODE FESTIVAL 2015 予選B D問題

問題：http://code-festival-2015-qualb.contest.atcoder.jp/tasks/codefestival_2015_qualB_d

解けなかったのでブログに書いておく。

<!-- headline -->

#### 考え方

左方向に、すでに黒く塗られたところを飛ばしながら黒く塗っていく。

→黒く塗られた区間をsetで持ってマージしたりしながらシミュレーションするだけ。O(nlogn)

これを解いた時は、競プロから離れすぎていてsetを使う頭がなかった。

#### 解答

この場合は`lower_bound`でも`upper_bound`でも同じだけど一応違いを確認した。

参考：http://hpcmemo.hatenablog.com/entry/2014/01/15/005106

INFをそのまま持つと足し算したときにやばいということに気付いたので適当に割る引数を追加した。

```cpp
#include <algorithm>
#include <iostream>
#include <vector>
#include <set>
#include <limits>

using namespace std;

template<class T = int,T divided_by = 10>
constexpr T PINF(){ return std::numeric_limits<T>::max()/divided_by; }

template<class T = int,T divided_by = 10>
constexpr T MINF(){ return std::numeric_limits<T>::lowest()/divided_by; }

int main() {
    cin.tie(nullptr); ios::sync_with_stdio(false);

    long long n;
    cin >> n;

    set<pair<long long, long long>> black_seg; //first : start pos, second : length

    //lower_boundなどを使うときに-infとinfを追加しておくとせぐふぉしないので便利
    black_seg.insert({PINF<long long>(),PINF<long long>()});
    black_seg.insert({MINF<long long>(),MINF<long long>()});

    vector<long long> ans(n,0); //answers

    for(int i = 0; i < n; ++i){
        long long s,c;
        cin >> s >> c;

        long long ret = s+c-1; //last pos
        long long next_s = s,next_c = c;

        //左方向で重なる（又は隣接する）分をeraseしてnext_sとnext_cを更新
        auto left_it = --black_seg.lower_bound({s,0});
        auto left = *(left_it);
        if(s<=left.first+left.second-1 +1){ //隣接するものもくっつけるため+1
            next_s = left.first;
            next_c += left.second;
            ret = next_s+next_c-1;
            black_seg.erase(left_it);
        }

        //右方向で重なる分をeraseしてnext_cを更新
        auto right_it = black_seg.lower_bound({s,0});
        while(right_it != black_seg.end()){
            auto right = *right_it;
            if(ret<right.first){ break; }
            next_c += right.second;
            ret = next_s+next_c-1;
            right_it = black_seg.erase(right_it);
        }

        //新しいblack_segを追加
        black_seg.insert({next_s,next_c});
        
        ans[i] = ret;
    }
    
    for(int i = 0; i < n; ++i){
        cout << ans[i] << endl;
    }
    return 0;
}

```

#### テストケース

```plain
5
1000000000 1000000000
3 1
5 1
4 1
2 2
>>> 1999999999
>>> 3
>>> 5
>>> 4
>>> 6
```
