# IntervalWalk
[iOSアプリのURL](https://apps.apple.com/app/id6445850986)

## 目次

- [アプリの内容](https://github.com/kasiwa-mesi/interval-walk#アプリの内容)
- [開発した経緯](https://github.com/kasiwa-mesi/interval-walk#開発した経緯)
- [技術要件](https://github.com/kasiwa-mesi/interval-walk#技術要件)
- [注意して実装した箇所](https://github.com/kasiwa-mesi/interval-walk#注意して実装した箇所)
  - [ViewControllerにif文を流入させないこと](https://github.com/kasiwa-mesi/interval-walk#ViewControllerにif文を流入させないこと)
  - [エラーハンドリング](https://github.com/kasiwa-mesi/interval-walk#エラーハンドリング)
  - [ハードコーディングを避ける](https://github.com/kasiwa-mesi/interval-walk#ハードコーディングを避ける)
- [機能](https://github.com/kasiwa-mesi/interval-walk#機能)
  - [インターバル速歩の計測画面](https://github.com/kasiwa-mesi/interval-walk#インターバル速歩の計測画面)
  - [記録一覧画面](https://github.com/kasiwa-mesi/interval-walk#記録一覧画面)
  - [会員登録機能](https://github.com/kasiwa-mesi/interval-walk#会員登録機能)
  - [ログイン・ログアウト](https://github.com/kasiwa-mesi/interval-walk#ログイン・ログアウト)
  - [メールアドレス変更](https://github.com/kasiwa-mesi/interval-walk#メールアドレス変更)
  - [パスワード再設定](https://github.com/kasiwa-mesi/interval-walk#パスワード再設定)

## アプリの内容
ゆっくり・早歩きを3分ずつ交互に繰り返すインターバル速歩を実践できるストップウォッチのアプリです。

## 開発した経緯
インターバル速歩を行っている祖母から公式アプリが使いにくいと相談された。
公式アプリには、「会員登録しないと使えない」、「15分までしかストップウォッチが起動しない」という問題点があった。

相談されたことをきっかけに**お年寄りが使いやすいインターバル速歩のアプリ**を開発し始めた。

<img src="https://gyazo.com/bab0df2351fc815294e668583147da25/raw" width="800" height="400">

## 技術要件
- Swift
- Firebase
  - Firebase Authentication)
    - アプリ内のログイン機能として活用
  - Firestore
    - ウォーキングを行ったokonatta記録を保存するデータベースとして活用
- アーキテクチャ
  - MVP(Model - View - Presenter)

## 注意して実装した箇所
### ViewControllerにif文を流入させないこと
MVPの設計に基づき、ViewControllerは**Viewに関する実装**, **Presenterに依存する実装**だけを記述するようにした。

### エラーハンドリング
エラーコードとエラーの内容をモーダルで表示している(参考下記画像)。ユーザーから問い合わせがあれば、スクリーンショットを撮ってもらって、エラーコードとエラーの内容に基づいて修正できるように実装

- <img src="https://gyazo.com/23e20b3e239c46d69ef334eecc1fdaa5/raw" width="200" height="400">

### ハードコーディングを避ける
各ファイルで使い回すダイアログの「"了解しました"」という文字列に関しては、修正するとき手間がかかる。

したがって、以下のようにextensionでまとめた。
```
extension String {
  static var ok: String { "了解しました" }
}
```

## 機能
### インターバル速歩の計測画面
以下の機能を実装している
- ストップウォッチ
- 画面を見て、早歩き・ゆっくりか判断できる
- 人工音声+バイブレーションによって、ゆっくり・早歩きを3分ずつ交互に切り替わるタイミングを通知する。
- <img src="https://gyazo.com/53679248cba0389d5851bf1d482cde76/raw" width="200" height="400">
- <img src="https://gyazo.com/fc2377c38dd3a1a24a64ba6f5f4591f6/raw" width="200" height="400">

### 記録画面一覧
計測画面で記録したデータを見れる。

データ
- 作成日時
- 歩いた時間(計測画面でストップウォッチを起動していた時間)
- <img src="https://gyazo.com/6f2d983315b4c5db5f158c487d5a3816/raw" width="200" height="400">

### 会員登録機能
- 打ち間違えた時の対策としてパスワードを2回入力させる
- <img src="https://gyazo.com/42f7eab0ddbdc294ee8379b7141e6d48/raw" width="200" height="400">

### ログイン・ログアウト
- <img src="https://gyazo.com/d9fb1b0b6c25190f00dcb4e72a5060af/raw" width="200" height="400">

### メールアドレス変更
- <img src="https://gyazo.com/48b131d09c7e4c596e6a1f854944c372/raw" width="200" height="400">

### パスワード再設定
- <img src="https://gyazo.com/deaa5ae62cfe599c875665cc38a6dfe8/raw" width="200" height="400">