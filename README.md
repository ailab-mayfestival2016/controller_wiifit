# controller_wiifit
言語は相変わらずObjective-Cベースで、一部Swiftも使ってます。
なので、もし編集あるいは使用するならMac OSX、XCodeが必要です。
対応バージョンは調べてないです、すみません。
とりあえず僕の環境はOSX 10.11.3、XCode Version 7.3です。

リポジトリ内のwiiscaleCOGフォルダをローカルに移して
その中のWiiScale.xcodeprojをダブルクリックすればXCodeが起動し、
左上の再生ボタンみたいのを押せばアプリが起動します。
アプリが立ち上がるとWiifitBoardの電池のとこに赤いボタン(Syncボタン)を押します。
ここで何故かアプリの表示が一瞬Connectedになった後Disconnectedになりますが
二回Command+BをしてSearchingの状態にしてからもう一回Syncボタンを押すとアプリ内で重量が表示され、
接続されます。サーバーに送る情報はx軸（横)方向の小数点第3位まで重心位置のみです。
左端が-1.0、右端が1.0になってます。

http://localhost:8000に接続する設定にしていますが、
もし違うURLに繋ぐならXCodeでAppController.mの27行目、http://localhost:8000
を本来のアドレスに変えてください。
