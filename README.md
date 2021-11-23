# GitHubUsers
A sample app for SwiftUI MVVM Combine Rxswift GitHub REST API  etc.

## アプリ構造説明
概要：GitHubのユーザを検索と閲覧し、お気になりユーザとリポジトリーを保存するサンプルアプリです。

#### アーキテクチャ：**MVVM**　
![MVVM](https://user-images.githubusercontent.com/14342048/142783643-ba4d4900-7676-4baa-ab14-e5ee62e69350.png)
* View:  ViewModelの内容の表示、ユーザのアクションをViewModelへお知らせ。
* ViewModel：AppStateのデータ監視、Serviceと通信しデータ取得、Viewに表示するデータの更新。
* Model：App内データ型の定義、各モジュール用のデータ解析と構築手段。
* AppState：全領域参照できるデータの保持。（[CurrentValueSubject](https://developer.apple.com/documentation/combine/currentvaluesubject)利用しpublish機能付き）
* Service：ViewModelからのデータ処理を処理し、StubとRealの処理を振り分け。
* Repository：外部サーバと通信する。

参照情報：[Clean Architecture for SwiftUI ](https://nalexn.github.io/clean-architecture-swiftui/)

#### 画面構成：
* ユーザ画面：キーワード利用しユーザを検索し、検索したユーザ情報を表示する。　
	* 検索した履歴を検索Barの下に表示され、タップすると再び検索できます。（長押しで出たメニューで削除できる、上限20件設定済み） 
	* 検索したユーザ一覧をタップし選択したユーザのレポジトリ画面を表示する。 	
	* レポジトリ画面(ユーザ詳細)：ユーザ詳細情報とリポジトリを表示する。
	* ユーザとリポジトリにPin（お気に入り）機能あり。
	* ネットワーク負担を減らすために、毎回検索件数に変更機能付き。
	* ユーザ簡略情報の表示(Location、Mail、プロフィール、Follow情報など)。
	* リポジトリー画面に表示メールが表示する場所に直接Mailアプリ起動し送信機能付き。
	* リポジトリー画面にリポジトリーの開発言語の表示色をGitHubと統一する。
* ピン画面：リポジトリ画面にPinしたユーザとリポジトリを永続化表示、ユーザが再度アプリ起動するときにも見える。
* 感謝画面：感謝情報を表示する
#### API情報
**GitHubのREST API**利用しGitHubから情報を吸い上げます。
参照情報：[リファレンス - GitHub Docs](https://docs.github.com/ja/rest/reference)

#### 他の技術とライブラリー
* SwiftUI：画面の構築方式。
	* [SwiftUI](https://developer.apple.com/jp/xcode/swiftui/)
* Combine：App内部通信方式。
	* [Combine](https://developer.apple.com/documentation/combine) 
	* [Problem Solving with Combine Swift](https://medium.com/flawless-app-stories/problem-solving-with-combine-swift-4751885fda77)
* Rxswift：GitHubと通信するときに利用する。
	* [ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift) 
	* [RxSwift operators](http://reactivex.io/documentation/operators.html)
* Alamofire：GitHubと通信するときに利用する。　
	* [Alamofire/Alamofire](https://github.com/Alamofire/Alamofire)
* swagger-api/swagger-codegen：GitHubと通信するときに利用する。　
	* [swagger-api/swagger-codegen](https://github.com/swagger-api/swagger-codegen)
* R.swift：コード簡略化するため文字列、Color、画像などに利用。
	* [mac-cain13/R.swift](https://github.com/mac-cain13/R.swift)
* ResponseStatusCodeより通信エラー解析とエラー表示の汎用化。（CombineとSwiftUI）

## 認証情報：
認証情報：**個人アクセストークン**　生成方法：[個人アクセストークンを使用する - GitHub Docs](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
> GitHubに**レート制限**のAPIを利用するので、できるだけ個人アクセストークンを利用してください。
> 
> GitHubにTokenの公開ができないので、動作確認するときにはTokenの更新が必要になります。
> 
> 自分生成するかまた私(kangnux@outlook.com)を連絡して連携するも可能です。
> 
* Token入れ替える場所:
**GitHubUsers/GitHubUsers/Environments/Config.xcconfig**
[GitHubUsers/Config.xcconfig](https://github.com/kangnux/GitHubUsers/blob/3176dafd95c8edb155b720ac8c37b396e74e0e64/GitHubUsers/Environments/Config.xcconfig)

## 画面スクリーンショット

|ユーザ画面|検索履歴長押しメニュー|
|---|---|
|<img src=https://user-images.githubusercontent.com/14342048/142960483-e357c14a-2f44-437f-bfa7-b66876fd82f0.PNG width=540px>|<img src=https://user-images.githubusercontent.com/14342048/142960528-40616ba3-b15b-4359-af53-8a05329a78e4.PNG width=540px>|

|リポジトリー画面|
|---|
|<img src=https://user-images.githubusercontent.com/14342048/142960573-b821b68a-8953-4c96-9aae-d260d8fbde7b.PNG width=540px>|

|Pinユーザ画面|Pinリポジトリー画面|
|---|---|
|<img src=https://user-images.githubusercontent.com/14342048/142960601-5c13d5a3-3e0d-44bf-956c-d8dc8492dad2.PNG width=540px>| <img src=https://user-images.githubusercontent.com/14342048/142960628-956ac4c0-7dc5-424c-828b-2156086cd56b.PNG width=540px>|

## その他
これからもどんどん機能を作って導入する予定です。

- 2021.11.23 検索履歴保存機能機能追加

SwiftUI、Combine、Rxswiftなどの活用で技術力を上げましょう〜🧗

