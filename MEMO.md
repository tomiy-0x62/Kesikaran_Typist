# Kesikaran_Typist

USキーボードでかな入力をしたいと言う変態のためのタイピングソフト



## 完成像

### 動作

次に押すべきキーをオレンジ色に -間違えて入力しているときはdeleteをオレンジに

SampleSentenceの正しく入力している場所までSampleSentence(かな)をオレンジに

(SampleSentence切り替え　ボタンで)

(サイドバーで例文の一覧)

(アプリケーションメニューからのサイドバーの表示切り替え)

(アプリケーションメニューからSampleSentence登録(テキストファイルからインポート))

(SampleSentenceには文字数制限 kanaが54文字まで(54文字でちょうどキーボードと同じ幅))

(SampleSentenceのインポート時読みの濁音等は自動で変換) ex) 「いだいだ、ぽけもん」-> 「いた゛いた゛、ほ゜けもん」

(アプリケーションメニューからSampleSentenceエクスポート(Zipで, デフォルトのSentenceを除くかをオプションに))





### UI

・Window

上から順に

キーボード

SampleSentence

SampleSentence(かな)

入力された文字列

入力欄　|　SampleSentence切り替えボタン 

入力されたキー

入力されたキーの刻印

・アプリケーションメニュー

File

​	-Import

​	-Export 

View

​	-Show Sidebar/Hide Sidebar

・サイドバー

１つのSampleSentenceが１つのブロックになっている

ダブルクリックで編集可能





## 変数名

・SampleSentence

​	ユーザーが入力する例文　ex) 数年に１回レベルの大変楽しい日本語訳を発見いたしました

・KanaSampleSentence

​		ユーザーが入力する例文の読み仮名 ex) すうねんにいっかいれへ゛るのたいへんたのしいにほんこ゛やくをはっけんいたしました

・TypedKanaSentence

​		ユーザーが入力したかな文 ex) すうねんにいっかいれへ゛るの

・typedKey　入力されたキー

・kana かな  ex) り

・char キーに刻印されている文字　ex) L

・keyNum　 keyViewListの何番目のキーか？

・KeycodesforNum　左右のshiftキーを区別したキーコード



## 設計

・SampleSentence

1SampleSentence 1ファイル(にする予定)

・keys.csv

ex) "ぁ" 421,20 "shift_3" 100

"かな"　keycodes "keyChar" keyNum

~~keyNumを複合キー(shift_3みたいやつ)に割り当てる必要はないけど、なにも割り当てないのは扱いづらいから意味のない値(100)を割り振っておく~~

keyNumは複合キーに対して"左シフト+ ○"は○のkeyNum + 100, "左シフト+ ○"は○のkeyNum + 200

### 各クラス,構造体,ファイルの役割

・class SentenceManager

​	ユーザーが入力したかな文を保持するクラス

​	SampleSentenceDataを格納

​	SampleSentenceの選択

・struct SampleSentenceData

​	SampleSentenceとそのかなを格納するための構造体

・class KeybordBackground

​	キーボードの背景をカスタマイズするためのクラス

・class KeyView

​	ストリーボードに並べたキーのViewに対して背景色を変えるためのクラス

・class CustomView

​	ウィンドウをkeyDownに対応させるためのViewのクラス

・struct KeyData

​	キーのkeycode,kana,char,keynum等を保管する構造体

・class KeysDataManager

​	キーのデータを保持し、キーの検索をするためのクラス

・keys.csv

​	キーのkeycode,kana,char,keynum等を保存したCSVファイル



# 日記 2021/1/31

プログラムを書いていて詰まった。

原因として２つの事柄が考えられる。

1. 変数の命名規則

   変数名が適当すぎ

   辞書をもっとたくさん引く必要がある

2. 無設計

   設計をしてない

    -設計を知らないから？

    -MVC(ModelViewController)とかの勉強

   文書として設計を残したり、頭の中で設計してからコードを書く

    -行き当たりばったりでコードを書かない

    -先の見通しをつけてからコードを書く

   



## keys.csv

shiftの扱いが少し特殊

-> 右シフトと左シフトでキーコードが違っているけど、その区別を外すめに421を自分で割り当てた。

区切り文字がスペースになっていることに注意

-> 文字コードを並列するためにカンマを使いたいから

一番左の列のkeyNumは押されたキーを光らせるためのもの

-> "を" "shift_0" みたいな組み合わせのについてはそれぞれ、[shift, 0]と出せばいい

-> 組み合わせのキーは全部100





## TODO

文章を登録

登録した文章をタイプするために次に打つキーをオレンジに

↑こいつ周りの調整

初回起動時にキーがオレンジにならない問題を解決







~~キーのレイアウト~~

~~通常サイズのキーはファイル:写真:xcoe=100:70:48~~

~~（写真はkey_sampereal.pxdのこと）~~



~~Kesikaran_Typist/Kesikaran_Typist/keys.json~~

~~を完成させる~~

~~キーコードとかなを結びつけるためのファイル~~

~~そのために必要なファイルとメモ~~

~~Kesikaran_Typist/Kesikaran_Typist/memo_keys_date.txt~~

~~Kesikaran_Typist/Kesikaran_Typist/keys.csv~~



~~/Users/ryosuke/PycharmProjects/test~~

~~の下にformat_json.pyを完成させる~~



~~JSONよりもCSVの方がいい~~

- ~~コードから仮名文字を検索するときにJSONだと面倒~~
- ~~CSVならコードの列を検索してヒットした行の仮名文字を取り出すだけだから楽~~

~~CSVからデータを読み込んでそれを格納するクラスを描いてる途中~~



