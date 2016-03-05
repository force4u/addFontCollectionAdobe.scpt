(*

addFontCollectionAdobe.scpt
20160305　初回作成　
201603004 displayed nameの処理を修正

フォントブックに登録されているフォントを調べて
コピーライトがAdobeの製品を
フォントコレクションに登録します。

*)



---フォントブックを起動する
tell application "Font Book" to launch

---フォントブック内での処理
tell application "Font Book"
	---前面に
	activate
	---Adobeの名前のフォントコレクションの有無を調べます
	set boolChFontCollection to exists of font collection "Adobe"
	---もしAdobeのコレクションが無い場合
	if boolChFontCollection = false then
		try
			---新しいコレクションを作成
			set objFontCollectionAdobe to make new font collection
		end try
		---おまじないの１秒
		delay 1
		---作ったコレクション
		tell objFontCollectionAdobe
			---名前を変更
			set name to "Adobe"
		end tell
		---おまじないの１秒
		delay 1
		tell font collection "Adobe"
			---ローカライズ用？
			set displayed name to "Adobe"
		end tell
	end if
	-----全てのタイプフェイスを取得　リストに格納
	set listAllTypeFaces to get every typeface as list
	---ファイプフェイスIDの数だけ繰り返す
	repeat with theFont in listAllTypeFaces
		---タイプフェイスのプロパティを取得
		set listFontProperties to properties of theFont
		---プロパティの追加情報部を取得
		set listAdditionalnfo to typeface additional info of listFontProperties
		---エラーよけの初期化
		set FBFaceCopyrightName to ""
		---追加情報からコピーライト情報を取得
		try
			set lisFBFaceCopyrightName to FBFaceCopyrightName of listAdditionalnfo
		end try
		---もしも、コピーライト情報にAdobeの文字があったら
		if lisFBFaceCopyrightName contains "Adobe" then
			---Adobeのコレクションに追加する
			add theFont to font collection "Adobe"
		end if
	end repeat
end tell

