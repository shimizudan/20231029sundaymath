### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ be1b28b6-0228-47f2-a234-f9999f34cd9a
using PlutoUI,Distributions,StatsPlots,QuadGK,Combinatorics,FreqTables,HypothesisTests,SymPy

# ╔═╡ 74463bf9-c388-4003-9ea1-2da605ab1e3d
TableOfContents(title="もくじ 📚")

# ╔═╡ 8acc204e-896e-11ed-1251-438ce5d793cb
md"""
# 高校数学B「統計的な推測」について

　　　


![test](https://shimizudan.github.io/20231029sundaymath/pic4.png)


__2023年10月29日　日曜数学会　　　　清水　団　[@dannchu](https://twitter.com/dannchu)__

　　　
"""

# ╔═╡ b304b95b-e807-4fee-9bde-2498bb21f35b
md"""
## はじめに


- 現在の高校２年生は新しい指導要領で学習しています。




- 数学IIBCの共通テストを受験する受験生は**次の4つの分野から3つ**選ばなくてはなりません。

　　　　　　**数列（数学B）**

　　　　　　**統計的な推測（数学B）**

　　　　　　**ベクトル（数学C）**

　　　　　　**平面上の曲線と複素数平面（数学C）**


　　　　
- みなさんだったら，どれを選びますか？

　　　　

"""

# ╔═╡ 9684fb5c-da77-46fc-b88a-25f55ea5cbf4
md"""
## 統計的な推測

### 高校の現場では？

- 私自身，20年以上高校で数学を教えていますがこの分野を教えたことは1回だけ。


- 多くの先生が「統計的な推測」を教えたことはない。


- 昔て比べて「仮説検定」が加わっている。（古い課程にはあったらしい。。。）



- ということで，教科書の問題を解き直してみたわけです。


- 教科書の中で，「？？？」となるところはないかチェックしました。


- 私自身は今年「統計的な推測」の授業はないのですが，勤務校では高校2年次に全員（文系・理系ともに）学習します。

　　　

"""

# ╔═╡ 0927baed-7e7f-4b75-8028-3508364c76de
md"""
### 内容について

項目は次のようになっています。

>**＜確率分布＞**
>- 確率変数と確率分布
>- 確率変数の期待値と分散
>- 確率変数の変換
>- 独立な確率変数と期待値・分散
>- 二項分布
>- 正規分布

>**＜統計的な推測＞**
>- 母集団と標本
>- 推定
>- 仮説検定



"""

# ╔═╡ d06ebc23-6e59-4b31-abba-dc3ebf6ce296
md"""

## 今回「？？？」となったところ

### 二項分布が正規分布に近づく？

まずは教科書を見てみましょう。（数研出版）


![](https://shimizudan.github.io/20231029sundaymath/pic1.png)

"""

# ╔═╡ f90c7029-e76a-4174-a51b-291fb1a3af64
md"""

** 二項分布は$n$が大きくなると正規分布とみなせる？**

この記述で生徒は納得できるのか？


![](https://shimizudan.github.io/20231029sundaymath/pic2.png)


"""

# ╔═╡ 53f94aac-1e64-4a4f-a8c8-671b9c492f13
md"""

### 二項分布の正規分布による近似

> - 二項分布 $B(n,p)$ に従う確率変数 $X$ が $n$が大きいとき，近似的に正規分布 $N(n,np(1-p))$ に従う。
>
>
> - 二項分布の正規分布で近似できるのは，$n$が十分大きくかつ，期待値$np$および分散$np(1−p)$も十分大きい場合である。
>
>
> - *$n$* が十分大きく，$p$が十分小さい場合，二項分布のポアソン分布で近似できる。


>正規分布に近似できる基準（統計ハンドブックより）
>
>3つの条件のどれかを満たせば，正規分布に近似できる。
> 1. *$\min(np,nq)>10$*
> 1. *$0.1\leqq p\leqq 0.9$* かつ $npq>5$
> 1. *$npq>25$*


>ポアソン分布に近似できる基準（統計ハンドブックより）
>
> *$n>50$* かつ $np≦5$

"""

# ╔═╡ a18c6d38-1417-4656-85ed-e620945f06d8
function approx(n,p)
   dist = Binomial(n,p)
   λ = n*p
   dist2 = Poisson(λ)
   μ,σ = mean(dist),sqrt(var(dist))
   dist3 = Normal(μ,σ)
   
   ymax = map(x -> pdf(dist3,x), μ)
   
   @show mean(dist),var(dist)
   @show rationalize.((mean(dist),var(dist)))

   xs = support(dist)
   bar(xs,dist,title="",label="$dist",ylim=(0,ymax*1.3),xlim=(μ-5σ,μ+5σ),color="skyblue")
   
	plot!(dist3,title="",label="$dist3",ylim=(0,ymax*1.3),xlim=(μ-3σ,μ+3σ),color="red")


     scatter!(dist2,title="",label="$dist2",ylim=(0,ymax*1.3),xlim=(μ-5σ,μ+5σ),color="red")
end;

# ╔═╡ 5558e7b8-57df-4292-b778-a08a827b9de7
begin
	n24_slider = @bind n24 Slider(1:100)
	p24_slider = @bind p24 Slider(0:.01:1)
	
	md"""

	`approx(n,p)`
	
	n: $(n24_slider)
	
	p: $(p24_slider)
	"""
end

# ╔═╡ 867caf60-c15e-4f90-bc56-749e4023c153
approx(n24,p24)

# ╔═╡ dd0ca2d0-71bf-4f92-a904-7f5f3a868d76
md"""

### 


"""

# ╔═╡ 86d9a754-3261-43a4-9d78-7ddf91c7e5f0
md"""

## 統計的な推測
### 母集団と標本
#### 全数調査と標本調査


__要点のまとめ__


> - **全数調査**　調べたい対象全体のデータを集める。
> - **標本調査**　対象全体から一部を抜き出して調べ，その結果から，全体の状況を推測する。
> - **母集団**　調べたい対象全体の集合。
> - **標本**　母集団から抜き出された要素の集合。
> - **抽出**　母集団から標本を抜き出すこと。
> - **母集団の大きさ**　母集団の集合を$U$とすると，$n(U)$のこと。
> - **標本の大きさ**　標本の集合を$A$とすると，$n(A)$のこと。**サンプルサイズ**
> - **標本数**　何回標本抽出を行ったか。**サンプル数**
> - **無作為抽出**　母集団の各要素を等しい確率で抽出する方法。乱数を用いることが多い。
> - **無作為標本**　無作為抽出で選ばれた標本。


#### 母集団分布



__要点のまとめ__


> - **母集団分布**　母集団における変量の$x$の分布。
> - **母平均**　母集団分布の平均値
> - **母分散**　母集団分布の分散
> - **母標準偏差**　母集団分布の標準偏差
> - 大きさ1の無作為標本における変量$x$の値$X$は，母集団分布に従う確率変数でその期待値，標準偏差は，それぞれ，母平均，母分散，母標準偏差と一致する。



__練習26__

1,1,2,2,2,3,3,3,3,4の数字を記入した 10 枚のカードがある。この 10 枚のカードを母集団，カードの数字を変量とするとき、母集団分布，母平均，母標準偏差を求めよ。


"""

# ╔═╡ 90dfadf5-50cf-45d1-a0ea-cad98f2f4751
begin

	X24=[1,1,2,2,2,3,3,3,3,4]

md"""

母集団分布

|$X$|$1$|$2$|$3$|$4$|計|
|:---:|:---:|:---:|:---:|:---:|:---:|
|$P$|$(count(i->(i==1),X24)//10)|$(count(i->(i==2),X24)//10)|$(count(i->(i==3),X24)//10)|$(count(i->(i==4),X24)//10)|$1$|


母平均 $(mean(X24))

母分散 $(var(X24,corrected=false))

母標準偏差 $(std(X24,corrected=false))


"""

end

# ╔═╡ 38ea5bb2-99bc-47ce-a4ee-be8423156941
md"""

#### 復元抽出・非復元抽出

__要点のまとめ__

> - **復元抽出**　母集団の中から標本を抽出するのに，毎回もとに戻しながら次のものを1個ずつ取り出すこと
> - **非復元抽出**　母集団の中から標本を抽出するのに，取り出したものを元に戻さずに続けて抽出すること
> - 母集団から大きさ $n$ の標本を無作為に抽出し，その $n$ 個の要素における変量 $x$ の値を $X_1$，$X_2$，$\cdots$，$X_n$ とする。この抽出が復元抽出ならば，それは母集団から大きさ1の標本を無作為に抽出するという試行を $n$ 回繰り返す反復試行であるから， $X_1$，$X_2$，$\cdots$，$X_n$ は，それぞれが母集団分布に従う互いに独立な確率変数となる。 非復元抽出の場合でも，母集団の大きさが標本の大きされに比べて十分大きい場合には，非復元抽出と復元抽出の違いは小さくなる。 したがって，非復元抽出による標本も近似的に復元抽出による標本とみなすことができ，$X_1$，$X_2$，$\cdots$，$X_n$ は，それぞれが母集団分布に従う互いに独立な確率変数と考えてよい。

__例__

*$K$* 個の成功状態をもつ$N$ 個の要素よりなる母集団から $n$ 個の要素を抽出したときに $k$ 個の成功状態が含まれている確率を与える確率分布を求める。

(1) 非復元抽出の場合は **超幾何分布** という。

(2) 復元抽出の場合は **二項分布** である。

- *$\lim_{N\to\infty}\dfrac KN=p\in[0,1]$* で$N$が十分大きいとき，超幾何分布は二項分布に近づく。

"""

# ╔═╡ 35e6801a-e827-4676-a6ff-616509fd6367
function approx3(N,p,n) # K=Np
	K = round(N*p)
	
   dist = Binomial(n,p)
   λ = n*p
   # dist2 = Poisson(λ)
   μ,σ = mean(dist),sqrt(var(dist))
	dist3 = Hypergeometric(K, N-K, n)
   dist4 = Normal(μ,σ)
   
   ymax = map(x -> pdf(dist4,x), μ)
   
   @show mean(dist),var(dist)
   @show mean(dist3),var(dist3)
	
#   @show rationalize.((mean(dist),var(dist)))

   xs = support(dist)
   bar(xs,dist,title="",label="$dist",ylim=(0,ymax*1.3),xlim=(μ-5σ,μ+5σ),color="skyblue",alpha=0.5)

	xs2 = support(dist3)
	bar!(xs2,dist3,title="",label="$dist3",ylim=(0,ymax*1.3),xlim=(μ-5σ,μ+5σ),color="purple",alpha=0.5)


     # scatter!(dist2,title="",label="$dist2",ylim=(0,0.3),xlim=(μ-5σ,μ+5σ),color="red")

	
end;

# ╔═╡ cee21820-d0a7-44ad-a1d9-9718c9f0a1c0
begin
	N266_slider = @bind N266 Slider(1:1000)
	p266_slider = @bind p266 Slider(0:0.01:1)
	n266_slider = @bind n266 Slider(1:1000)
	
	md"""

	`approx3(N,p,n)`
	
	N: $(N266_slider)
	
	p: $(p266_slider)

	n: $(n266_slider)

	
	"""
end

# ╔═╡ d421501a-2e0e-4c10-8836-47f7d65a4634
approx3(N266,p266,n266)

# ╔═╡ 2f78fdd1-2b12-42f1-9fed-787e17e9e278
md"""

### 標本平均とその分布
#### 標本平均の期待値と標準偏差

__要点のまとめ__

> 母集団から大きさ $n$ の標本を無作為に抽出し，変量 $x$ について，その標本のもつ $x$ の値を $X_1$，$X_2$，$\cdots$，$X_n$ とする。
>
> 標本平均 $\overline X=\dfrac{X_1+X_2+\cdots+X_n}{n}$
>
> 標本分散 $\displaystyle{S^2=\dfrac1n\sum_{k=1}^{n}(X_k-\overline X)^2}$
>
> 標本標準偏差 $\displaystyle{S=\sqrt{\dfrac1n\sum_{k=1}^{n}(X_k-\overline X)^2}}$　（ これは正直わかりません。）
>
> - 標本平均 $\overline X$， 標本分散 $S^2$，標本標準偏差 $S$は確率変数である。


> 母平均を$μ$，母標準偏差を$σ$とする。確率変数 $X_1$，$X_2$，$\cdots$，$X_n$は独立で，$X$と同分布出会うとする。
>
>$E(X_1)=E(X_2)=\cdots=E(X_n)=\mu=E(X)$
>$V(X_1)=V(X_2)=\cdots=V(X_n)=\sigma^2=V(X)$
>$\sqrt{V(X_1)}=\sqrt{V(X_2)}=\cdots=\sqrt{V(X_n)}=\sigma=\sigma(X)$
>

> 「標本平均」の平均 
>
>$\begin{aligned}E(\overline X)&=E\left(\dfrac{X_1+X_2+\cdots+X_n}{n}\right)\\&=\dfrac{E(X_1)+E(X_2)+\cdots+E(X_n)}{n}\\&=\dfrac{n\mu}{n}=\mu\end{aligned}$
>
> 「標本平均」の分散 
>
> $\begin{aligned}V(\overline X)&=V\left(\dfrac{X_1+X_2+\cdots+X_n}{n}\right)\\&=\dfrac{V(X_1)+V(X_2)+\cdots+V(X_n)}{n^2}\\&=\dfrac{n\sigma^2}{n^2}=\dfrac{\sigma^2}{n}\end{aligned}$
>
> 「標本平均」の標準偏差 
>
> $\begin{aligned}\sigma(\overline X)&=\sqrt{V(\overline X)}=\sqrt{\dfrac{\sigma^2}{n}}=\dfrac{\sigma}{\sqrt n}\end{aligned}$

__練習27__

ある県における高校 2 年生の男子の体重の平均値は 64.1 kg，標準偏差は 10.5 kgである。この県の高校2年生の男子 100 人を無作為抽出で選ぶとき，100 人の体重の平均やの期待値と標準偏差を求めよ。

"""

# ╔═╡ 0b239638-008f-4881-b87f-863929a878c4
md"""

- 母平均$\mu=64.1$，母標準偏差$\sigma=10.5$


- 標本平均の平均$E(\overline X)=\sigma=64.1$


- 標本平均の標準偏差$\sigma(\overline X)=\dfrac{\sigma}{\sqrt{100}}=\dfrac{10.5}{10}=1.05$



"""

# ╔═╡ 65c3eb79-0002-456d-af87-896ab3d4b576
md"""
__練習28__

ある国の人の血液型は 10 人に 1 人の割合でAB型である。その国の $n$ 人を無作為に抽出するとき，$k$ 番目に抽出された人がAB型ならば 1,それ以外の血液型ならば 0 の値を対応させる確率変数を $X_k$ とする。このとき，標本平均 $\overline X=\dfrac{X_1+X_2+\cdots+X_n}{n}$ の期待値と標準偏差を求めよ。


"""

# ╔═╡ 097723e5-50f4-4c67-9527-fe147b222931
md"""

*$X_1$*，$X_2$,$\cdots$，$X_n$は$X$と i.i.d.である。

*$X_k$*の確率分布は

|$X_k$|0|1|合計|
|:---:|:---:|:---:|:---:|
|$P$|0.9|0.1|1|

$E(X_k)=E(X)=\dfrac1{10}=0.1$

$V(X_k)=V(X)=(-0.1)^2\cdot0.9+(0.9)^2\cdot0.1=0.009+0.081=0.09$

標本平均の平均

$\begin{aligned}
E(\overline X)&=E\left(\dfrac{X_1+X_2+\cdots+X_n}{n}\right)
=\dfrac{E(X)\cdot n}{n}=E(X)=0.1
\end{aligned}$

標本平均の分散・標準偏差

$\begin{aligned}
V(\overline X)&=V\left(\dfrac{X_1+X_2+\cdots+X_n}{n}\right)
=\dfrac{V(X)\cdot n}{n^2}=\dfrac{V(X)}{n}=\dfrac{0.09}{n}\\
\sqrt{V(\overline X)}&=\sqrt{\dfrac{0.09}{n}}=\dfrac{0.3}{\sqrt n}
\end{aligned}$


"""

# ╔═╡ da48673d-ed2c-4590-a6ee-452de3bae8b5
begin
    X28=[0,0,0,1,1,1]
    Y28=(union(permutations(X28,3)))
	A28=[sum(Y28[i])//3 for i=1:8]
	P28=[]
	for i=1:8
		append!(P28,if sum(Y28[i])==0 (9//10)^3 elseif sum(Y28[i])==1 (9//10)^2*1//10 elseif sum(Y28[i])==2 9//10*(1//10)^2 elseif sum(Y28[i])==3 (1//10)^3 end)
	end
	F28=[]
    for i=1:8
	  	append!(F28,sum((Y28[i][j]-A28[i])^2//3 for j=1:3))
 	end
	
	
	sum(P28[i]*F28[i] for i=1:8)
	P28
end

# ╔═╡ beed7c81-4322-4767-957b-3b5a09118aad
md"""

*$n=3$*で考えてみる。

標本平均$\overline X$の確率分布は

|$\overline X$|0/3|1/3|2/3|3/3|計|
|:---:|:---:|:---:|:---:|:---:|:---:|
|$P$|0.729|0.243|0.027|0.001|1|

標本平均の平均は$E(\overline X)=0.1=\mu$ (OK)


|${\overline X}^2$|0/9|1/9|4/9|9/9|計|
|:---:|:---:|:---:|:---:|:---:|:---:|
|$P$|0.729|0.243|0.027|0.001|1|

標本平均の分散
$V(\overline X)=E({\overline X}^2)-\{E(\overline X)\}^2=0.04-0.01=0.03=\dfrac{0.09}{3}$ (OK)

標本平均の標準偏差
$\sigma(\overline X)=\sqrt{0.03}=0.17320508075688773...$

標本分散 $S^2=\displaystyle{\dfrac13\sum_{k=1}^{3}(X_k-\overline X)^2}$ の確率分布は



|$S^2$|0/9|2/9|計|
|:---:|:---:|:---:|:---:|
|$P$|0.73|0.27|1|



標本分散の平均は$E(S^2)=0.06=\dfrac{2}{3}\cdot0.09$ (OK)


標本標準偏差 $S=\displaystyle{\sqrt{\dfrac13\sum_{k=1}^{3}(X_k-\overline X)^2}}$ の確率分布は



|$S$|0/3|√2/3|計|
|:---:|:---:|:---:|:---:|
|$P$|0.73|0.27|1|



標本標準偏差の平均は$E(S)=0.09\sqrt2=0.12727922061357855$ (???)


"""

# ╔═╡ 384898ba-1c9b-4627-80d2-3b1ea1d168b7
md"""

#### 標本平均の分布と正規分布

__要点のまとめ__

> - **母比率** 母集団全体の中で特性Aをもつ要素の割合
> - **標本比率** 標本の中で特性Aをもつ要素の割合


> 母平均を $\mu$，母分散を $\sigma^2$とすると，標本平均$\overline X$は平均$\mu$，分散 $\dfrac{\sigma^2}{n}$なので，$n$ が大きいときには
>
> $\overline X\sim N\left(\mu,\dfrac{\sigma^2}n\right)$


__練習29__

母平均 50 ，母標準偏差 20 をもつ母集団から，大きさ 400 の無作為標本を抽出するとき，その標本平均 $\overline X$ が 49 より小さい値をとる確率を求めよ。

"""

# ╔═╡ 655629ea-2b05-4a0a-9902-2ed41e9f75d2
md"""

$\overline X\sim  N\left(50,\dfrac{20^2}{400}\right)=N\left(50,1\right)$

*$Z=\dfrac{\overline X-50}{1}$* とおくと，$Z\sim N(0,1)$

*$\overline X<49$* のとき$Z<-1$

*$P(\overline X<49)=P(Z<-1)=$*  $(cdf(Normal(0,1),-1))

"""

# ╔═╡ 67ee4594-56b7-4cd2-8463-475588a6a1f7
md"""

#### 大数の法則

> 大数の法則
> 母平均 $\mu$ の母集団から大きさ $n$ の無作為標本を抽出するとき， その標本平均 $\overline X$（値）は，$n$ が大きくなるに従って，母平均 $\mu$に近づく。
>


__練習30__

 硬貨を　＄n＄ 回投げるとき，表の出る相対度数を $R$ とする。

*$n=100,400,900$* の各場合について，$P\left(\left|R-\dfrac12\right|\leqq0.05\right)$の値を求めよ。


"""

# ╔═╡ 9e97fdf7-bc63-46ba-b276-3df6979020e5
md"""



標本平均$\overline X=nR$より，$R=\dfrac{\overline X}n$

*$E(R)=\dfrac12，V(R)=\dfrac{1}{4n}$* ，$R \sim N\left(\dfrac{1}2,\dfrac1{4n}\right)$

(1)
*$n=100$* のとき$R \sim N\left(\dfrac12,\dfrac1{400}\right)$

*$Z=20(R-0.5)$* すると，

*$P\left(\left|R-\dfrac12\right|\leqq0.05\right)=P\left(\left|Z\right|\leqq1\right)=$*  $(cdf(Normal(0,1),1)-cdf(Normal(0,1),-1))


(2)
*$n=400$* のとき$R \sim N\left(\dfrac12,\dfrac1{1600}\right)$

*$Z=40(R-0.5)$* すると，

*$P\left(\left|R-\dfrac12\right|\leqq0.05\right)=P\left(\left|Z\right|\leqq2\right)=$*  $(cdf(Normal(0,1),2)-cdf(Normal(0,1),-2))



(3)
*$n=900$* のとき$R \sim N\left(\dfrac12,\dfrac1{3600}\right)$

*$Z=60(R-0.5)$* すると，

*$P\left(\left|R-\dfrac12\right|\leqq0.05\right)=P\left(\left|Z\right|\leqq3\right)=$*  $(cdf(Normal(0,1),3)-cdf(Normal(0,1),-3))

"""

# ╔═╡ 43dd21b3-82a7-4f41-b32e-b1ad010e1066
md"""
### 推定

#### 母平均の推定

> 母平均$\mu$，母分散$\sigma^2$，標本サイズ$n$，標本平均$\overline X$とする。
>
> 信頼度95%の信頼区間（$\mu$の範囲）
> $P\left(\overline X-1.96\cdot\dfrac{\sigma}{\sqrt n}\leqq \mu\leqq\overline X+1.96\cdot\dfrac{\sigma}{\sqrt n}\right)\fallingdotseq0.95$ 
>
>信頼度99%の信頼区間（$\mu$の範囲）
> $P\left(\overline X-2.58\cdot\dfrac{\sigma}{\sqrt n}\leqq \mu\leqq\overline X+2.5 8\cdot\dfrac{\sigma}{\sqrt n}\right)\fallingdotseq0.99$




"""

# ╔═╡ e18af170-02f6-4f12-9e66-99b67237e33e
quantile(Normal(0,1),0.95+0.025)

# ╔═╡ bd8c3241-1553-4786-a507-d38695b34459
quantile(Normal(0,1),0.99+0.005)

# ╔═╡ 0a6832e3-7bb8-462d-98c3-ba9e634eae50
md"""


__練習31__

大量に生産されたある製品から， 400 個を無作為に抽出して長さを測ったところ，平均値が 105.4 cmであった。長さの母標準偏差を 2.0 cmとして，この製品の長さの平均値を，信頼度 95 %で推定せよ。

"""

# ╔═╡ dbc526b9-0487-49ac-86fd-eff03129178f
begin
	[
		quantile(Normal(105.4,2.0/20),0.025)
		quantile(Normal(105.4,2.0/20),0.975)
	]
end

# ╔═╡ 32d71674-635b-4dac-9200-b50a5418138e
md"""

*$n=400$*，$\overline X=105.4$，$\sigma=2.0$，母平均を$\mu$とすると，
信頼度95%の信頼区間は

$105.4-1.96\cdot\dfrac{2}{20}\leqq \mu\leqq105.4+1.96\cdot\dfrac{2}{20}$


$105.4-0.196\leqq \mu\leqq105.4+0.196$

$105.204\leqq \mu\leqq105.596$


"""

# ╔═╡ 1ce765b6-d38c-4760-9c01-174df9bc4750
md"""

__練習32__


ある清涼飲料水入りのびん 100 本について， A成分の含有量を検査したところ， 平均値 32.5 mg， 標準偏差 3.1 mgを得た。 この清涼飲料水 1 びんあたりのA成分の平均含有量を， 信頼度 95 %で推定せよ。

"""

# ╔═╡ 14a7e0a1-620f-4aec-b71c-187e296debf4
begin
	[
		quantile(Normal(32.5,3.1/10),0.025)
		quantile(Normal(32.5,3.1/10),0.975)
	]
end

# ╔═╡ 2a5de505-85df-46c1-8ace-0011770b6eb0
md"""


*$n=100$*，$\overline X=32.5$，$S=\sigma=3.1$，母平均を$\mu$とすると，
信頼度95%の信頼区間は

$32.5-1.96\cdot\dfrac{3.1}{10}\leqq \mu\leqq32.5+1.96\cdot\dfrac{3.1}{10}$


$32.5-1.96\times 0.31\leqq \mu\leqq32.5-1.96\times 0.31$

$31.8924\leqq \mu\leqq33.1076$

補足：普通は不偏分散を用いてt検定を行う。

標本標準偏差が標本分散からも求めたものであるとする。不偏分散から求めた標準偏差に直すと，

$\sqrt{3.1^2\times \dfrac{99}{1000}}=3.084461055030522$

自由度99のt検定を行う


$32.5-1.98\cdot\dfrac{3.08}{10}\leqq \mu\leqq32.5+1.98\cdot\dfrac{3.08}{10}$


$31.89016\leqq \mu\leqq33.10984$


"""

# ╔═╡ a7de4e3a-ce8b-4337-858a-cb565d554400
OneSampleTTest(32.5, 3.1, 99, 0)


# ╔═╡ 2a7a7193-589f-45ef-bfe5-cea3e81894d7
quantile(TDist(99),0.95+0.025)

# ╔═╡ ac435e53-7409-4954-ad25-4d561e582a92
32.5+1.98*0.308

# ╔═╡ 5edde4be-c503-49dd-9339-24f3ea62b80a
md"""

#### 母比率の推定

__要点のまとめ__

>標本比率$R$を元に母比率$r$を推定する。

__練習33__


ある県の高校 3 年生から無作為に900 人を選び，むし歯がある生徒を数えたところ，450 人であった。この県の高校 3 年生のむし歯の保有率を，信頼度 95 %で推定せよ。

"""

# ╔═╡ 515584a6-e926-41ef-aec8-58ae1273a8bf
begin
	[
		quantile(Normal(450,sqrt(900*450/900*450/900)),0.025)/900
		quantile(Normal(450,sqrt(900*450/900*450/900)),0.975)/900
	]
end

# ╔═╡ 8f2c401c-b579-408b-bdba-1acc5eb4316d
md"""

標本平均 $\overline X=450$，標本サイズ$n=900$， 標本比率$R=\dfrac{\overline X}{n}=\dfrac{450}{900}=0.5$，母比率$r$とする。

$E(R)=E\left(\dfrac{\overline X}{n}\right)=\dfrac1nE(\overline X)=\dfrac{nr}{n}=r$

$V(R)=V\left(\dfrac{\overline X}{n}\right)=\dfrac1{n^2}V(\overline X)=\dfrac{nr(1-r)}{n^2}=\dfrac{r(1-r)}{n}$


*$r$*に対する信頼度95%の信頼区間は


$R-1.96\cdot\sqrt{\dfrac{r(1-r)}{n}}\leqq r\leqq R-1.96\cdot\sqrt{\dfrac{r(1-r)}{n}}$

*$R$*は不偏推定量である。$E(R)=r$なので，左辺と右辺の$r$を$R$に置き換えて，


$R-1.96\cdot\sqrt{\dfrac{R(1-R)}{n}}\leqq r\leqq R-1.96\cdot\sqrt{\dfrac{R(1-R)}{n}}$

$0.5-1.96\cdot\dfrac{1}{60}\leqq r\leqq 0.5-1.96\cdot\dfrac{1}{60}$


$0.467\leqq r\leqq 0.533$

"""

# ╔═╡ 07647d6a-fc71-44d5-9ddd-8ac15f97bd4e
md"""

### 仮説検定
#### 仮説検定

__要点のまとめ__

> - **仮説検定**　正しいとしたい仮説。（「正しい」とできない場合もある。）
> - **帰無仮説**　正しくないとしたい仮説（**棄却** したい仮説。否定できないこともある）
> - **有意水準**，**危険率**，**棄却域** 　小さい確率が起こる範囲を設定しておく。
> 
> - **片側検定，両側検定**

__練習34__

ある 1 個のさいころを 180 回投げたところ，1 の目が 24 回出た。このさいころは，1 の目の出る確率が $\dfrac16$ ではないと判断してよいか。有意水準 5 %で検定せよ。


"""

# ╔═╡ d4c5fdf9-ef4e-4740-a8ec-5e5ec0df46bf
md"""

**対立仮説**　さいころは1 の目の出る確率が $\dfrac16$ ではない。

**帰無仮説**　さいころは1 の目の出る確率が $\dfrac16$ である。

まず，「さいころは1 の目の出る確率が $\dfrac16$ である。」と仮定する。

表が出る回数を$X$とすると，$X$は二項分布$B\left(180,\dfrac16\right)$に従う。

*$E(X)=180\times\dfrac16=30$*

*$V(X)=180\times\dfrac16\times \dfrac56=25$*


*$X$*は近似的に正規分布$N(30,5^2)$に従う。

*$Z=\dfrac{X-30}{5}$*とすると，$Z$は正規分布$N(0,1)$に従う。

有意水準が5%なので$P(-1.96\leqq Z\leqq 1.96)=0.95$より，

*$Z< -1.96,1.96<Z$*の範囲のときは小さな確率のことが起こったことになる。

*$X=24$*なので，$Z=\dfrac{24-30}{5}=-1.2$である。よって，小さな確率のことが起こったことはいえない。

**仮説は棄却できない。**

**「さいころは1 の目の出る確率が $\dfrac16$ ではない」と判断できない。**






"""

# ╔═╡ 8e9ff14d-2b4b-4aff-b069-a94d5dcc0c1b
md"""

__練習35__


ある種子の発芽率は従来 60 %であったが，発芽しやすいよう品種改良した。品種改良した種子から無作為に 600 個抽出し種をまいたところ 378 個が発芽した。このとき，品種改良によ って発芽率が上がったと判断してよいか。有意水準 5% で検定せよ。

"""

# ╔═╡ 1a788e47-6cb1-4801-8f8e-08ba9a1b3830
md"""


**対立仮説**　発芽率は 60 %より大きい。

**帰無仮説**　発芽率は 60 %である。

まず，「発芽率は 60 %である。」と仮定する。

発芽数を$X$とすると，$X$は二項分布$B\left(600,0.6\right)$に従う。

*$E(X)=600\times0.6=360$*

*$V(X)=180\times0.6\times 0.4=144$*


*$X$*は近似的に正規分布$N(360,12^2)$に従う。

*$Z=\dfrac{X-360}{12}$*とすると，$Z$は正規分布$N(0,1)$に従う。

片側検定で有意水準が5%なので$P( Z\leqq 1.64)=0.95$より，

*$1.64<Z$*の範囲のときは小さな確率のことが起こったことになる。

*$X=378$*なので，$Z=\dfrac{378-360}{12}=-0.67$である。よって，小さな確率のことが起こったことはいえない。

**仮説は棄却できない。**

**「発芽率は 60 %より大きくなった」と判断できない。**

今回は片側検定をしたが，どちらで検定するかは明記して欲しいものである。

"""

# ╔═╡ 2705d497-71b7-49d8-8366-3e4b9f99cc08
quantile(Normal(),0.95)

# ╔═╡ 4d888683-2b01-4f73-a90e-f13dade527de
12/18

# ╔═╡ 93319453-d9e4-4bf3-9fcc-d8a54456de85
md"""


__練習36__

内容量 300 gと表示されている大量の缶詰から，無作為に 100 個を取り出し，内容量を量ったところ，平均値が 298.6 g，標準偏差が 7.4 gであった。全製品の1年あたりの平均内容量は，表示通りでないと判断してよいか。有意水準 5 %で検定せよ

"""

# ╔═╡ 74b5fe08-9db0-4d18-b798-9d684ea1a1f1

md"""

**対立仮説**　全製品の1年あたりの平均内容量は表示通りでない。

**帰無仮説**　全製品の1年あたりの平均内容量は表示通りである。

まず，「全製品の1年あたりの平均内容量は，表示通り 300 gである。」と仮定する。


重さの標本平均を$\overline X$とする。$\overline X$は近似的に正規分布 $N\left(300,\dfrac{7.4^2}{100}\right)$に従う。

*$Z=\dfrac{\overline X-300}{0.74}$* とすると，$Z$は正規分布$N(0,1)$に従う。

両側検定で有意水準が5%なので$P(-1.96\leqq Z\leqq 1.96)=0.95$より，


*$Z< -1.96,1.96<Z$*の範囲のときは小さな確率のことが起こったことになる。

*$\overline X=298.6$*なので，$Z=\dfrac{298.6-300}{0.74}=-1.89$である。よって，小さな確率のことが起こったことはいえない。


**仮説は棄却できない。**

**「全製品の1年あたりの平均内容量は表示通りでない。」と判断できない。**

"""



# ╔═╡ 5c7442dd-16bb-4429-bd77-a90481ec6693
md"""
## 問題
### 1〜6

1. さいころを2回投げて，出る目の差の絶対値を $X$ とする。$X$ の期待値と分散を求めよ。

"""

# ╔═╡ e4d341a5-b40f-4e09-8ef6-fc04af4e7d87
md"""

|$X$|1|2|3|4|5|6|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|1|0|1|2|3|4|5|
|2|1|0|1|2|3|4|
|3|2|1|0|1|2|3|
|4|3|2|1|0|1|2|
|5|4|3|2|1|0|1|
|6|5|4|3|2|1|0|

*$\begin{aligned}
E(X)&=0\times \dfrac{6}{36}+1\times \dfrac{10}{36}+2\times \dfrac{8}{36}+3\times \dfrac{6}{36}+4\times \dfrac{4}{36}+5\times\dfrac{2}{36}\\
&=\dfrac{10+16+18+16+10}{36}=\dfrac{70}{36}=\dfrac{35}{18}
\end{aligned}$*

|$X^2$|1|2|3|4|5|6|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|1|0|1|4|9|16|25|
|2|1|0|1|4|9|16|
|3|4|1|0|1|4|9|
|4|9|4|1|0|1|4|
|5|16|9|4|1|0|1|
|6|25|16|9|4|1|0|


*$\begin{aligned}
E(X^2)&=0\times \dfrac{6}{36}+1\times \dfrac{10}{36}+4\times \dfrac{8}{36}+9\times \dfrac{6}{36}+16\times \dfrac{4}{36}+25\times\dfrac{2}{36}\\
&=\dfrac{10+32+54+64+50}{36}
=\dfrac{210}{36}=\dfrac{35}6
\end{aligned}$*

*$\begin{aligned}
V(X)&=E(X^2)-\{E(X)\}^2\\
&=\dfrac{35}6-\dfrac{35^2}{18^2}
=\dfrac{35}6\left(1-\dfrac{35}{54}\right)
=\dfrac{35}6\times \dfrac{19}{54}
=\dfrac{665}{324}
\end{aligned}$*

"""

# ╔═╡ a5a80d8a-8d98-4266-a13d-9e135c7da5f1
begin
	X001=[1//1,2,3,4,5,6]
	Y001=[]
	for i=1:6,j=1:6
		append!(Y001,abs(X001[i]-X001[j]))
	end
	[mean(Y001),var(Y001,corrected=false)]
end
		

# ╔═╡ 5fb2be0c-31eb-4af9-8b95-c206e0ca4a84
md"""

2. 黒玉 2 個と白玉 3 個が入っている袋Aと，黒玉 4 個と白玉 1 個が入っている袋Bから，2 個ずつ玉を取り出す。袋A,Bから取り出された黒玉の個数をそれぞれ $X$ ，$Y$ とするとき、確率変数 $X+Y$ の期待値と分散を求めよ。

"""

# ╔═╡ bf1c7491-7ad7-498f-bab4-1ca6a951ac16
begin
	EX002=sum(i*binomial(2,i)*binomial(3,2-i)//binomial(5,2) for i=1:2)
	EY002=sum(i*binomial(4,i)*binomial(1,2-i)//binomial(5,2) for i=1:2)
	EX002²=sum(i^2*binomial(2,i)*binomial(3,2-i)//binomial(5,2) for i=1:2)
	EY002²=sum(i^2*binomial(4,i)*binomial(1,2-i)//binomial(5,2) for i=1:2)

	[EX002+EY002,EX002²+EY002²-EX002^2-EY002^2]
end


# ╔═╡ 824dc643-157b-4fba-bb28-be897e8487dd
begin
	#超幾何分布である
	[
		rationalize.(mean(Hypergeometric(2, 3, 2))+mean(Hypergeometric(4, 1, 2)))
		rationalize.(var(Hypergeometric(2, 3, 2))+var(Hypergeometric(4, 1, 2)))
	]
end


# ╔═╡ 3bb764ca-0eb8-42ed-9d8c-2168d572390f
md"""

3.  確率変数 $X$ が二項分布 $B\left(100,\dfrac15\right)$ に従うとき，次の各場合に確率変数 $Y$ の期待値と分散を求めよ。

(1)  $Y=3X-2$

(4)  $Y=-X$

(3)  $Y=\dfrac{X-20}4$

"""

# ╔═╡ 620fad26-e43f-4784-89f3-11d4a68fbeec
begin
	#二項分布
	[
		rationalize.(mean(3*Binomial(100,1/5)-2)) rationalize.(var(3*Binomial(100,1/5)-2))
		
		rationalize.(mean(-1*Binomial(100,1/5))) rationalize.(var(-1*Binomial(100,1/5)))
		
		rationalize.(mean((Binomial(100,1/5)-20)/4)) rationalize.(var((Binomial(100,1/5)-20)/4))
	]

end

# ╔═╡ 09a99021-1771-4648-b511-c6290724fbc4
md"""

4. 確率変数やのとる値の範囲が $0\leqq X\leqq 2$ で，その確率密度関数 $f(x)$ が次の式で与えられるものとする。

$f(x)=\begin{cases}
ax\quad(0\leqq x\leqq 1)\\
a(2-x)\quad(1\leqq x\leqq 2)
\end{cases}$

(1) 定数 $a$ の値を求め，$X$の分布曲線をかけ。

(2) *$P(0.5\leqq X\leqq 1.5)$* を求めよ。
"""

# ╔═╡ 0a30daaa-932d-4193-a6b7-a6a2f3162c85
begin
	function f004(x)
		if 0<=x<=1 x
		elseif 1<=x<=2 2-x
		end
	end
	a = 1/quadgk(f004,0,2)[1]
	f0042(x)=a*f004(x)
	plot(f0042,xlim=(0,2),label="a=$a")	
end


# ╔═╡ cba98471-1f0f-4ae7-a540-589cf4884ebe
quadgk(f0042,0.5,1.5)[1] |>rationalize

# ╔═╡ 61fcff39-9a4a-41bc-871d-d171156d89dc
begin
	# 対称三角分布（ Symmetric triangular distribution）
	plot(SymTriangularDist(1, 1))
end

# ╔═╡ 9de30c19-df9c-4f15-96f6-0647edbec314
quadgk(x->pdf(SymTriangularDist(1, 1),x),0.5,1.5)[1] |>rationalize

# ╔═╡ db9c95da-0c56-4084-8544-6c39edb26b3f
md"""

5. 確率変数 $X$ が正規分布 $N(50,10^2)$ に従うとき，次の確率を求めよ。

(1) *$P(X\leqq70)$*

(2) *$P(55\leqq X\leqq65)$*



"""

# ╔═╡ a2a47818-9c7f-4960-835a-6d7220860c3e
begin
	#正規化
[
	cdf(Normal(),(70-50)/10)
	cdf(Normal(),(65-50)/10)-cdf(Normal(),(55-50)/10)
]
end

# ╔═╡ 1e2f0475-9621-4e0a-9696-d9617f87f44d
begin
	# そのまま求めていいよね...
[
	cdf(Normal(50,10),70)
	cdf(Normal(50,10),65)-cdf(Normal(50,10),55)
]
end
	

# ╔═╡ 762dea48-f66f-4897-bee1-9f70f6d09d9f
md"""

6. ある試験での成績の結果は，平均点 64 点，標準偏差 14 点であった。得点の分布を正規分布とみなすとき，次の問いに答えよ。ただし，いずれも小数第1位を四捨五入せよ。


(1)  36 点以上 92 点以下の人が 400 人いた。受験者の総数は約何人か。

(2)  (1)のとき，合格点を 50 点とすると，約何人が合格することになるか。 


"""

# ╔═╡ 5c929894-a526-4a87-828d-ec723f53280c
begin

	400/(cdf(Normal(64,14),92)-cdf(Normal(64,14),36)) |>round |>Int

end

# ╔═╡ 52ff258a-9c95-4251-9902-0037a3b55f5d
begin

	ccdf(Normal(64,14),50)*419 |>round |>Int

end

# ╔═╡ 00b00c5c-c064-4069-8ac8-9f306b37e358
md"""

### 7~11

7. 1 から 3 までの数字を書き込んだ玉が，その数字と同じ個数だけ袋に入っている。これを母集団とし，玉の数字を変量，その値を $X$ とする。

(1)  母集団分布を示せ。

(2)  母平均と母標準偏差を求めよ。 

"""

# ╔═╡ 2d600817-c533-4a9a-b89a-dffc9781e702
md"""

|$X$|1|2|3|計|
|:---:|:---:|:---:|:---:|:---:|
|$P$|1/6|2/6|3/6|1|

"""

# ╔═╡ ac2adc84-2e84-45da-8381-795ffcd54aa2
begin
	X007=[1,2,2,3,3,3]
	[
		mean(X007)
		std(X007,corrected=false)
	]
end


# ╔═╡ 028be70d-2651-41d9-82c6-509fb7de2717
md"""

8. 表は 5 人の生徒が 100 mを走ったときの，所要時間の測定記録である。

|生徒|A|B|C|D|E|
|:---:|:---:|:---:|:---:|:---:|:---:|
|所要時間(秒)|12|14|14|16|18|

この 5 人を母集団，所要時間を変量として，次の問いに答えよ。


(1)  母平均 $\mu$ と母標準偏差 $\sigma$ を求めよ。

(2)  この母集団から，非復元抽出によって大きさ 2 の標本を無作為抽出し，その変量の値を $X_1$，$X_2$ とする。このとき，標本平均 $\overline X=\dfrac{X_1+X_2}2$の確率分布を求めよ

(3) $\overline X$ の期待値 $E(\overline X)$ と標準偏差 $\sigma(\overline X)$ を求めよ
 

"""

# ╔═╡ 5eb91e5a-dbb4-4df7-94ed-5eac4b82cc05
begin
	X008 = [12,14,14,16,18]
	[
		mean(X008)
		std(X008,corrected=false)
	]	
end


# ╔═╡ 469798ff-8b80-44ed-b5ab-2dbb8336faa9
p=var(X008,corrected=false)|>rationalize

# ╔═╡ 11426954-fb99-4b3d-8cde-3db9801c2a7f
sympy.sqrt(sympy.Rational(104,25))

# ╔═╡ 71066b44-76f2-48ef-8558-55a0481d7383
begin
	Y008 = [sum(collect(permutations(X008,2))[i])/2 for i=1:20]
	freqtable(Y008)|> display

end

# ╔═╡ 1b19be21-1cfa-4433-81b9-c3940d6eaf6e
begin
	[
		mean(Y008)
		std(Y008,corrected=false)
	]	
end

# ╔═╡ 9d46027a-e6f4-4837-8f5d-ba1adb16ef2e
md"""

9. ある工場で生産されている照明器具の中から無作為抽出で 100 個を選び，有効時間の平均値と標準偏差を調べたところ，それぞれ 2000 時間，122 時間であった。この照明器具の平均有効時間を信頼度 95 %で推定せよ.


"""

# ╔═╡ b24f82bc-2ece-4bf6-a1f7-a2c9f61cc993
[
	quantile(Normal(2000,122/10),0.05-0.025)
	quantile(Normal(2000,122/10),0.95+0.025)
]

# ╔═╡ ffa34218-9adf-472d-b652-acd0ae381e8e
md"""

10. プロ野球のA, B両チームの年間の対戦成績は，Aの 16 勝 9 敗であった。 両チームの力に差があると判断してよいか。有意水準 95%で検定せよ。
"""

# ╔═╡ 03aa9c70-e160-4e94-ba2f-65632dd708ea
[
	quantile(Normal(25/2,sqrt(25/2/2)),0.05-0.025)
	quantile(Normal(25/2,sqrt(25/2/2)),0.95+0.025)
]

# ╔═╡ 49c09a21-08cb-42cd-a485-7e14a9205b76
md"""


11. 


"""

# ╔═╡ 9ffd2904-9430-47ef-8c64-b5652f208566
[
	quantile(Normal(0.05*1900,sqrt(1900*0.05*0.95)),0.01)
]

# ╔═╡ abc3c49e-92c4-42ba-9e4d-b35f5bc2cd6b
md"""


## 演習
### A 1~6

1. 1 個のさいころを 12 回投げるとき，出る目の和を $X$ とする。確率変数 $X$ の期待値と分散を求めよ。
"""

# ╔═╡ ef43b458-f0a5-495c-9ff7-42e7bcfe7cdf
begin
	X0A1 = [1,2,3,4,5,6]
	[
		12*mean(X0A1)|>rationalize
		12*var(X0A1,corrected=false)|>rationalize
	]



end

# ╔═╡ 019c2c55-2919-4d79-9b33-31aa7ef39c2f
md"""

2. 50 円硬貨 2 枚と 100 円硬貨 3 枚を同時に投げるとき，表の出た硬貨の金額の和の期待値と標準偏差を求めよ。

"""

# ╔═╡ 1f7a06c6-5d45-4a83-a7c7-e1da1fe569d1
begin
	[
		50*0.5*2+100*0.5*3
		((-25)^2*0.5+25^2*0.5)*2+((-50)^2*0.5+50^2*0.5)*3
		((-25)^2*0.5+25^2*0.5)*2+((-50)^2*0.5+50^2*0.5)*3 |>sqrt
	]
end


# ╔═╡ bb0861ea-f0e0-41ac-b92a-f2695a76889b
((-25)^2*0.5+25^2*0.5)*2+((-50)^2*0.5+50^2*0.5)*3|>sympy.Rational |>sympy.sqrt

# ╔═╡ 71b5707c-89e8-44c9-8e8f-47fb7035ec7c
md"""

3. 白玉 3 個と黒玉 2 個が入っている袋から玉を 1 個取り出し，もとに戻す操作を 100 回行う。白玉の出る回数の期待値と標準偏差を求めよ。

"""

# ╔═╡ 59d9ee92-1a09-4e60-a342-e01cf0beda1e
begin
	[
		Binomial(100,3//5)|> mean
		Binomial(100,3//5)|> var
	]



end

# ╔═╡ caf47a28-8152-40fb-af95-c7f49906c9e2
Binomial(100,3//5)|> var|>sympy.Rational|>sympy.sqrt

# ╔═╡ f06131c7-d48f-4ec3-b5ea-e5b40f17da1a
md"""

4. 母集団の変量 $x$ が下のような分布をしているとする。この母集団から復元抽出した大きさ 4 の無作為標本の変量 $x$ 値 を $X_1$，$X_2$，$X_3$，$X_4$ とするとき、標本平均 $\overline X$ の期待値と標準偏差を求めよ。

|$x$|1|2|3|計|
|:---:|:---:|:---:|:---:|:---:|
|度数|4|5|1|10|

"""

# ╔═╡ d58d1284-becc-4cdd-a34b-cbbe47af6fdd
begin
	X0A4=[1,1,1,1,2,2,2,2,2,3]
	4*mean(X0A4)/4|>rationalize|>println
	4*var(X0A4,corrected=false)/4^2|>rationalize|>println
	4*var(X0A4,corrected=false)/4^2|>sqrt|>println
	
end


# ╔═╡ fd1b6a96-7253-446d-ad58-697ae71e7987
sympy.Rational(41,400)|>sympy.sqrt

# ╔═╡ fef058b9-d46d-45a5-8fa4-6a56f170bee1
sqrt(41/400)

# ╔═╡ 34a2f734-c8b9-4b5b-bc07-3e844b617df1
md"""

5. ある工場の製品 400 個について検査したところ，不良品が 30 個あった。全製品における不良率を，信頼度 95 %で推定せよ。
"""

# ╔═╡ 027c7c80-59a7-4134-9304-18480475aa0d
begin
	[
		quantile(Normal(400*30/400,sqrt(400*30/400 *370/400)),0.025)/400
		quantile(Normal(400*30/400,sqrt(400*30/400 *370/400)),0.975)/400
	]



end


# ╔═╡ b6de7bfb-358c-43c8-9c8b-cacb92766dbd
md"""

6. ある会社が販売している 200 mL入りと表示された紙パック飲料から，無作為に 64 本を抽出して内容量を計ったところ，平均値は 199.5 mL,標準偏差は 2.8 mLであった。この商品の平均内容量は，表示通りでないと判断してよいか。有意水準 5 %で検定せよ




"""

# ╔═╡ a249391e-4528-4e10-8a31-0dcfdf12299d
begin
	[
		quantile(Normal(200,2.8/8),0.025)
		quantile(Normal(200,2.8/8),0.975)
		
	]
end

# ╔═╡ 89627520-f94b-4362-a618-17efefc68b35
md"""

### B 7~11

7.  1 個のさいころを 2 回投げるとき，出る目の最大値を $X$ とする。 


(1) 確率変数 $X$ の確率分布を求めよ。

(2) $X$ の期待値と標準偏差を求めよ。

"""

# ╔═╡ f6e95a53-22dd-456f-88cf-72e0f4b0e886
begin
	X0B7 = [1//1, 2//1, 3//1, 4//1,5//1,6//1]
	Y0B7 = []
		for i=1:6,j=1:6 
			append!(Y0B7,max(X0B7[i],X0B7[j]))
		end
	freqtable(Y0B7)|>display

end

# ╔═╡ bfad16a2-12bd-4c29-b1ae-114d82e6cce4
begin
	[
		mean(Y0B7)
		var(Y0B7,corrected=false)
	]
end

# ╔═╡ 4f04946e-ed80-4505-bd74-76a2d60af9e7
sympy.sqrt(sympy.Rational(2555,1296))

# ╔═╡ 2b205010-b8cc-49cd-b131-fdbd5d4e195f
md"""

8. ある大学の入学試験は，受験者数が 2600 名で， 500 点満点の試験に対し。平均値は 296 点，標準偏差は 52 点，合格者は 40 名という結果であった。得点の分布が正規分布であるとみなされるとき，合格最低点はおよそ何点であるか。

"""

# ╔═╡ af2e2e22-f007-4a0b-ba72-44ba45366e14
begin
	quantile(Normal(296,52),(2600-400)/2600)
end


# ╔═╡ 219a08d7-293b-4983-a233-e08e4c6182d3
md"""

9. 1 個のさいころをn回投げて， 1 の目が出る回数を $X$ とする。$\left|\dfrac{X}n-\dfrac16\right|\leqq 0.03$ となる確率が 0.95 以上になるためには，$n$ をどのくらい大きくするとよいか。10 未満を切り上げて答えよ。


$X\sim N\left(\dfrac n6,\dfrac{5n}{36}\right)$


$X-\dfrac{n}{6}\sim N\left(0,\dfrac{5n}{36}\right)$



$Y=\dfrac{X-\dfrac{n}{6}}{\sqrt{\dfrac{5n}{36}}}\sim N\left(0,1\right)$



$Y=\dfrac{\dfrac Xn-\dfrac{1}{6}}{\sqrt{\dfrac{5}{36n}}}\sim N\left(0,1\right)$



$P\left(-\dfrac{0.03}{\sqrt{\dfrac{5}{36n}}}\leqq Y\leqq \dfrac{0.03}{\sqrt{\dfrac{5}{36n}}}\right)\leqq 0.95$

$P\left(-\dfrac{0.18\sqrt n}{\sqrt{5}}\leqq Y\leqq \dfrac{0.18\sqrt n}{\sqrt{5}}\right)\leqq 0.95$

となる最小の $n$を求めればよい。


$\dfrac{0.18\sqrt n}{\sqrt{5}}=1.96$

$n=\left(\dfrac{1.96\sqrt5}{0.18}\right)^2=\left(\dfrac{98\sqrt5}{9}\right)^2=\dfrac{9604\times 5}{9}=\dfrac{48020}{81}=592.8395061728396...$

"""


# ╔═╡ 38cf3a99-0a91-4b24-a433-209f4ecabf68
(1.96*sqrt(5)/0.18)^2

# ╔═╡ e5490dc2-d0e1-4475-85f9-72d74570677a
(196/18)^2*5

# ╔═╡ 22948138-6ea2-477a-9523-1790857a7dcb
md"""

10.  ある意見に対する賛成率は約 60 %と予想されている。この意見に対する賛成率を， 信頼区間の幅が 4 %以下になるように推定したい。信頼度 95 %で推定するには，何人以上抽出して調べればよいか。



$X\sim N\left(0.6n,0.24n\right)$

$\dfrac{X-0.6n}{\sqrt{0.24n}}\sim N\left(0,1\right)$
$Y=\dfrac{\dfrac{X}n-0.6}{\sqrt{\dfrac{0.24}n}}\sim N\left(0,1\right)$

*$P(-1.96\leqq Y\leqq 1.96)=0.95$*より，

$-1.96\leqq\dfrac{\dfrac{X}n-0.6}{\sqrt{\dfrac{0.24}n}}\leqq 1.96$

$-1.96\sqrt{\dfrac{0.24}n}\leqq\dfrac{X}n-0.6\leqq 1.96\sqrt{\dfrac{0.24}n}$


$0.6-1.96\sqrt{\dfrac{0.24}n}\leqq\dfrac{X}n\leqq 0.6+1.96\sqrt{\dfrac{0.24}n}$


$0.6+1.96\sqrt{\dfrac{0.24}n}-\left(0.6-1.96\sqrt{\dfrac{0.24}n}\right)\leqq 0.04$

$2\times 1.96\sqrt{\dfrac{0.24}n}\leqq 0.04$

$\sqrt n\geqq \dfrac{2\times 1.96\sqrt{0.24}}{0.04}=98\sqrt{0.24}$

$n\geqq 98^2\times 0.24=2304.96$




"""

# ╔═╡ 90360aa7-b1d8-44a5-a50b-0c5f4134758b
98^2*0.24

# ╔═╡ c6d74468-7f61-4681-8ce0-3fd7da239a10
md"""

11.  ある高校で，生徒会の会長にA，Bの 2 人が立候補した。選挙の直前に，全生徒の中から 100 人を無作為抽出し，どちらを支持するか調査したところ，59 人がAを支持し，41 人がBを支持した。全生徒 1200 人が投票するものとして，次の問いに答えよ。ただし，白票や無効票はないものとする。


(1)  Aの得票数を信頼度 95 %で推定せよ。

(2)  Aの支持率の方が高いと判断してよいか。有意水準 5 %で検定せよ。


"""

# ╔═╡ b74a3a3f-cf1d-43a5-8819-43358907a640
begin
	[
		quantile(Normal(59,sqrt(59*41/100)),0.025)/100*1200
		quantile(Normal(59,sqrt(59*41/100)),0.975)/100*1200
	]
	
end


# ╔═╡ 7b168383-6b93-4467-b6b6-b2bc3efe6368
begin
	quantile(Normal(50,sqrt(100*50/100*50/100)),0.95)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Combinatorics = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
FreqTables = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
HypothesisTests = "09f84164-cd44-5f33-b23f-e6b0d136a0d5"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
StatsPlots = "f3b207a7-027a-5e70-b257-86293d7955fd"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
Combinatorics = "~1.0.2"
Distributions = "~0.25.99"
FreqTables = "~0.4.5"
HypothesisTests = "~0.11.0"
PlutoUI = "~0.7.52"
QuadGK = "~2.8.2"
StatsPlots = "~0.15.6"
SymPy = "~1.1.10"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "bfb3a7fddd43ce1127e0f7be408e7f48ae65e0fb"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "9b9b347613394885fd1c8c7729bfc60528faa436"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.4"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "1568b28f91293458345dabba6a5ea3f183250a61"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.8"

    [deps.CategoricalArrays.extensions]
    CategoricalArraysJSONExt = "JSON"
    CategoricalArraysRecipesBaseExt = "RecipesBase"
    CategoricalArraysSentinelArraysExt = "SentinelArrays"
    CategoricalArraysStructTypesExt = "StructTypes"

    [deps.CategoricalArrays.weakdeps]
    JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    SentinelArrays = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
    StructTypes = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "b86ac2c5543660d238957dbde5ac04520ae977a7"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "dd3000d954d483c1aad05fe1eb9e6a715c97013e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.22.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "8c86e48c0db1564a1d49548d3515ced5d604c408"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.9.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fe2838a593b5f776e1597e086dcd47560d94e816"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.3"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "b6def76ffad15143924a2199f72a5cd883a2e8a9"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.9"
weakdeps = ["SparseArrays"]

    [deps.Distances.extensions]
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "27a18994a5991b1d2e2af7833c4f8ecf9af6b9ea"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.99"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "b4fbdd20c889804969571cc589900803edda16b7"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.1"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "f372472e8672b1d993e93dada09e23139b509f9e"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.5.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FreqTables]]
deps = ["CategoricalArrays", "Missings", "NamedArrays", "Tables"]
git-tree-sha1 = "488ad2dab30fd2727ee65451f790c81ed454666d"
uuid = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
version = "0.4.5"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "d73afa4a2bb9de56077242d98cf763074ab9a970"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.9"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f61f768bf090d97c532d24b64e07b237e9bb7b6b"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.9+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "cb56ccdd481c0dd7f975ad2b3b62d9eda088f7e2"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.14"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.HypothesisTests]]
deps = ["Combinatorics", "Distributions", "LinearAlgebra", "Printf", "Random", "Rmath", "Roots", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "4b5d5ba51f5f473737ed9de6d8a7aa190ad8c72f"
uuid = "09f84164-cd44-5f33-b23f-e6b0d136a0d5"
version = "0.11.0"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0cb9352ef2e01574eeebdb102948a58740dcaf83"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.1.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "90442c50e202a5cdf21a7899c66b240fdef14035"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.7"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "154d7aaa82d24db6d8f7e4ffcfe596f40bff214b"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2023.1.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "68bf5103e002c44adfd71fea6bd770b3f0586843"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.2"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NamedArrays]]
deps = ["Combinatorics", "DataStructures", "DelimitedFiles", "InvertedIndices", "LinearAlgebra", "Random", "Requires", "SparseArrays", "Statistics"]
git-tree-sha1 = "b84e17976a40cb2bfe3ae7edb3673a8c630d4f95"
uuid = "86f7a689-2022-50b4-a561-43c23ac3c673"
version = "0.9.8"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "bbb5c2115d63c2f1451cb70e5ef75e8fe4707019"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.22+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "67eae2738d63117a196f497d7db789821bce61d1"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.17"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "43d304ac6f0354755f1d60730ece8c499980f7ba"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.96.1"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "364898e8f13f7eaaceec55fd3d08680498c0aa6e"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.4.2+3"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "6ec7ac8412e83d57e313393220879ede1740f9ee"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.8.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.Roots]]
deps = ["ChainRulesCore", "CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "de432823e8aab4dd1a985be4be768f95acf152d4"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.17"

    [deps.Roots.extensions]
    RootsForwardDiffExt = "ForwardDiff"
    RootsIntervalRootFindingExt = "IntervalRootFinding"
    RootsSymPyExt = "SymPy"

    [deps.Roots.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    IntervalRootFinding = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "7beb031cf8145577fbccacd94b8a8f4ce78428d3"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "9cabadf6e7cd2349b6cf49f1915ad2028d65e881"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.2"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "NaNMath", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "9115a29e6c2cf66cf213ccc17ffd61e27e743b24"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.15.6"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "c24256a64ccce99a360050af5a037500f6a024d9"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.10"

    [deps.SymPy.extensions]
    SymPyTermInterfaceExt = "TermInterface"

    [deps.SymPy.weakdeps]
    TermInterface = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "1cd9b6d3f637988ca788007b7466c132feebe263"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.16.1"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "2222b751598bd9f4885c9ce9cd23e83404baa8ce"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.3+1"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─be1b28b6-0228-47f2-a234-f9999f34cd9a
# ╟─74463bf9-c388-4003-9ea1-2da605ab1e3d
# ╟─8acc204e-896e-11ed-1251-438ce5d793cb
# ╟─b304b95b-e807-4fee-9bde-2498bb21f35b
# ╟─9684fb5c-da77-46fc-b88a-25f55ea5cbf4
# ╟─0927baed-7e7f-4b75-8028-3508364c76de
# ╟─d06ebc23-6e59-4b31-abba-dc3ebf6ce296
# ╟─f90c7029-e76a-4174-a51b-291fb1a3af64
# ╟─53f94aac-1e64-4a4f-a8c8-671b9c492f13
# ╠═a18c6d38-1417-4656-85ed-e620945f06d8
# ╟─5558e7b8-57df-4292-b778-a08a827b9de7
# ╠═867caf60-c15e-4f90-bc56-749e4023c153
# ╠═dd0ca2d0-71bf-4f92-a904-7f5f3a868d76
# ╟─86d9a754-3261-43a4-9d78-7ddf91c7e5f0
# ╟─90dfadf5-50cf-45d1-a0ea-cad98f2f4751
# ╟─38ea5bb2-99bc-47ce-a4ee-be8423156941
# ╟─35e6801a-e827-4676-a6ff-616509fd6367
# ╟─cee21820-d0a7-44ad-a1d9-9718c9f0a1c0
# ╟─d421501a-2e0e-4c10-8836-47f7d65a4634
# ╟─2f78fdd1-2b12-42f1-9fed-787e17e9e278
# ╟─0b239638-008f-4881-b87f-863929a878c4
# ╟─65c3eb79-0002-456d-af87-896ab3d4b576
# ╟─097723e5-50f4-4c67-9527-fe147b222931
# ╠═da48673d-ed2c-4590-a6ee-452de3bae8b5
# ╟─beed7c81-4322-4767-957b-3b5a09118aad
# ╟─384898ba-1c9b-4627-80d2-3b1ea1d168b7
# ╟─655629ea-2b05-4a0a-9902-2ed41e9f75d2
# ╟─67ee4594-56b7-4cd2-8463-475588a6a1f7
# ╟─9e97fdf7-bc63-46ba-b276-3df6979020e5
# ╟─43dd21b3-82a7-4f41-b32e-b1ad010e1066
# ╠═e18af170-02f6-4f12-9e66-99b67237e33e
# ╠═bd8c3241-1553-4786-a507-d38695b34459
# ╟─0a6832e3-7bb8-462d-98c3-ba9e634eae50
# ╠═dbc526b9-0487-49ac-86fd-eff03129178f
# ╟─32d71674-635b-4dac-9200-b50a5418138e
# ╟─1ce765b6-d38c-4760-9c01-174df9bc4750
# ╠═14a7e0a1-620f-4aec-b71c-187e296debf4
# ╟─2a5de505-85df-46c1-8ace-0011770b6eb0
# ╠═a7de4e3a-ce8b-4337-858a-cb565d554400
# ╠═2a7a7193-589f-45ef-bfe5-cea3e81894d7
# ╠═ac435e53-7409-4954-ad25-4d561e582a92
# ╟─5edde4be-c503-49dd-9339-24f3ea62b80a
# ╠═515584a6-e926-41ef-aec8-58ae1273a8bf
# ╟─8f2c401c-b579-408b-bdba-1acc5eb4316d
# ╟─07647d6a-fc71-44d5-9ddd-8ac15f97bd4e
# ╟─d4c5fdf9-ef4e-4740-a8ec-5e5ec0df46bf
# ╟─8e9ff14d-2b4b-4aff-b069-a94d5dcc0c1b
# ╟─1a788e47-6cb1-4801-8f8e-08ba9a1b3830
# ╠═2705d497-71b7-49d8-8366-3e4b9f99cc08
# ╠═4d888683-2b01-4f73-a90e-f13dade527de
# ╟─93319453-d9e4-4bf3-9fcc-d8a54456de85
# ╟─74b5fe08-9db0-4d18-b798-9d684ea1a1f1
# ╟─5c7442dd-16bb-4429-bd77-a90481ec6693
# ╟─e4d341a5-b40f-4e09-8ef6-fc04af4e7d87
# ╠═a5a80d8a-8d98-4266-a13d-9e135c7da5f1
# ╟─5fb2be0c-31eb-4af9-8b95-c206e0ca4a84
# ╠═bf1c7491-7ad7-498f-bab4-1ca6a951ac16
# ╠═824dc643-157b-4fba-bb28-be897e8487dd
# ╟─3bb764ca-0eb8-42ed-9d8c-2168d572390f
# ╠═620fad26-e43f-4784-89f3-11d4a68fbeec
# ╟─09a99021-1771-4648-b511-c6290724fbc4
# ╠═0a30daaa-932d-4193-a6b7-a6a2f3162c85
# ╠═cba98471-1f0f-4ae7-a540-589cf4884ebe
# ╠═61fcff39-9a4a-41bc-871d-d171156d89dc
# ╠═9de30c19-df9c-4f15-96f6-0647edbec314
# ╟─db9c95da-0c56-4084-8544-6c39edb26b3f
# ╠═a2a47818-9c7f-4960-835a-6d7220860c3e
# ╠═1e2f0475-9621-4e0a-9696-d9617f87f44d
# ╟─762dea48-f66f-4897-bee1-9f70f6d09d9f
# ╠═5c929894-a526-4a87-828d-ec723f53280c
# ╠═52ff258a-9c95-4251-9902-0037a3b55f5d
# ╟─00b00c5c-c064-4069-8ac8-9f306b37e358
# ╠═2d600817-c533-4a9a-b89a-dffc9781e702
# ╠═ac2adc84-2e84-45da-8381-795ffcd54aa2
# ╟─028be70d-2651-41d9-82c6-509fb7de2717
# ╠═5eb91e5a-dbb4-4df7-94ed-5eac4b82cc05
# ╠═469798ff-8b80-44ed-b5ab-2dbb8336faa9
# ╠═11426954-fb99-4b3d-8cde-3db9801c2a7f
# ╠═71066b44-76f2-48ef-8558-55a0481d7383
# ╠═1b19be21-1cfa-4433-81b9-c3940d6eaf6e
# ╟─9d46027a-e6f4-4837-8f5d-ba1adb16ef2e
# ╠═b24f82bc-2ece-4bf6-a1f7-a2c9f61cc993
# ╟─ffa34218-9adf-472d-b652-acd0ae381e8e
# ╠═03aa9c70-e160-4e94-ba2f-65632dd708ea
# ╠═49c09a21-08cb-42cd-a485-7e14a9205b76
# ╠═9ffd2904-9430-47ef-8c64-b5652f208566
# ╟─abc3c49e-92c4-42ba-9e4d-b35f5bc2cd6b
# ╠═ef43b458-f0a5-495c-9ff7-42e7bcfe7cdf
# ╠═019c2c55-2919-4d79-9b33-31aa7ef39c2f
# ╠═1f7a06c6-5d45-4a83-a7c7-e1da1fe569d1
# ╠═bb0861ea-f0e0-41ac-b92a-f2695a76889b
# ╟─71b5707c-89e8-44c9-8e8f-47fb7035ec7c
# ╠═59d9ee92-1a09-4e60-a342-e01cf0beda1e
# ╠═caf47a28-8152-40fb-af95-c7f49906c9e2
# ╟─f06131c7-d48f-4ec3-b5ea-e5b40f17da1a
# ╠═d58d1284-becc-4cdd-a34b-cbbe47af6fdd
# ╠═fd1b6a96-7253-446d-ad58-697ae71e7987
# ╠═fef058b9-d46d-45a5-8fa4-6a56f170bee1
# ╠═34a2f734-c8b9-4b5b-bc07-3e844b617df1
# ╠═027c7c80-59a7-4134-9304-18480475aa0d
# ╟─b6de7bfb-358c-43c8-9c8b-cacb92766dbd
# ╠═a249391e-4528-4e10-8a31-0dcfdf12299d
# ╟─89627520-f94b-4362-a618-17efefc68b35
# ╠═f6e95a53-22dd-456f-88cf-72e0f4b0e886
# ╠═bfad16a2-12bd-4c29-b1ae-114d82e6cce4
# ╠═4f04946e-ed80-4505-bd74-76a2d60af9e7
# ╟─2b205010-b8cc-49cd-b131-fdbd5d4e195f
# ╠═af2e2e22-f007-4a0b-ba72-44ba45366e14
# ╟─219a08d7-293b-4983-a233-e08e4c6182d3
# ╠═38cf3a99-0a91-4b24-a433-209f4ecabf68
# ╠═e5490dc2-d0e1-4475-85f9-72d74570677a
# ╟─22948138-6ea2-477a-9523-1790857a7dcb
# ╠═90360aa7-b1d8-44a5-a50b-0c5f4134758b
# ╟─c6d74468-7f61-4681-8ce0-3fd7da239a10
# ╠═b74a3a3f-cf1d-43a5-8819-43358907a640
# ╠═7b168383-6b93-4467-b6b6-b2bc3efe6368
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
