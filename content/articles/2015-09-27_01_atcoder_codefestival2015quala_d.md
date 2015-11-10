---

title: "CODE FESTIVAL 2015 予選A D問題"
author: iray_tno
category: Science
tags: ["Computer","競プロ(CompProg)","二分探索(BinarySearch)"]
changefreq: yearly
priority: 1.0
publish: true

---

#### はじめに

CODE FESTIVAL 2015 予選A D問題

問題：http://code-festival-2015-quala.contest.atcoder.jp/tasks/codefestival_2015_qualA_d

解けなかったのでブログに書いておく。

<!-- headline -->

#### 考え方

Xを決めたとき、「全員がX回移動できるときにすべて埋められるかどうか」は整備士を左からなめていって高速に判定できる。

→二分探索で最大のXを求める。

制約を見てもdpはできなさそうだし貪欲も無理そうというところから二分探索にたどり着けるはずだった。

#### 解答

ついでににぶたんのスニペットも作った。

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int main(int, char** ){
	cin.tie(nullptr); ios::sync_with_stdio(false);
 
	//入力
	long long int n,m;
	cin >> n >> m;
	vector<long long int> x(m);
	for(int i = 0; i < m; ++i){
		cin >> x[i]; x[i]-=1;
	}


	//にぶたんすにぺっと
	long long int invalid_X,valid_X,middle_X;
	
	//↓書き換える
	invalid_X = 0;       //にぶたん開始点1 : invalidなX
	valid_X   = n*2+1;   //にぶたん開始点2 : validなX
	bool check_invalid_flag = true;  //invalid_Xがvalidかつそれが答えになる可能性
	auto is_valid = [&](long long int moves){  //validのときtrueを返す関数
		long long int ok=-1; //左から何両目まで埋められたか
		for(int i = 0; i < m; ++i){
			//x[i]より左にある埋めてない車両数==左にある埋める車両数
			long long int dl = x[i]-ok-1;
			dl=max(0LL,dl);
			if(moves < dl){
				return false;
			}
			//x[i]より右にある埋める車両数
			//（maxの中身：1つ目は最初に左方向、二つ目は最初に右方向
			//に進んで折り返すときの右側到達可能車両数）
			long long int dr = max((moves-dl*2),(moves-dl)/2);
			ok = x[i]+dr;
		}
		if((n-1)<=ok) return true;
		return false;
	};
	//↑終わり

	if(check_invalid_flag&&is_valid(invalid_X)){
		valid_X=invalid_X;
	}else{
		while(1<abs(valid_X-invalid_X)){
			middle_X = (valid_X+invalid_X)/2;
			if(is_valid(middle_X)){
				valid_X=middle_X;
			}else{
				invalid_X=middle_X;
			}
		}
	}

	cout << valid_X << endl;
	return 0;
}

```

#### テストケース

```plain
1 1
1
>>> 0
```

```plain
3 1
1
>>> 2
```

```plain
4 1
2
>>> 4
```

```plain
10 2
2
8
>>> 6
```
