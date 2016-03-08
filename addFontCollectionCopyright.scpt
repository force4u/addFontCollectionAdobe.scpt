(*

addFontCollection.scpt
20160304　初回作成　
20160305 displayed nameの処理を修正
20160306 Apache と　SIL　の処理を追加
20160306 addFontCollection.scptに名称変更
20160306　待ち時間を変更出来るように変更
20160308　リストにIPAを追加

フォントブックに登録されているフォントを調べて
フォントコレクションに登録します。

*)

---設定項目

set numWaitTime to 1.5 as number
#
#コレクションを作成してから、名称が確実に変更出来るための待ち時間
#コレクションが『名称未設定』で作られてしまう場合数値を大きく
#推奨１　名称未設定が出来る場合は２〜３に設定してください
------本処理ここから
---フォントブックを起動する
tell application "Font Book" to launch


tell application "Finder"
	activate
	----選択用のリストを定義
	set listLngList to {"Adobe", "Apple", "Bitstream", "Bureau", "DynaLab", "Google", "ITC", "Linotype", "Microsoft", "Monotype", "ParaType", "URW", "Esselte Letraset", "-------", "Morisawa", "Fontworks", "DynaComware", "Iwata", "TypeBank", "スクリーン", "-------", "Apache", "SIL", "IPA"} as list
	----リスト表示のダイアログを出します
	set theLangAns to (choose from list listLngList with title "言語選択" with prompt "フォントコレクションを作成するファウンダリを選択してください" default items "日本語" without multiple selections allowed and empty selection allowed) as text
	----エラーよけ
	if theLangAns is "-------" then
		return
	else if theLangAns is "false" then
		return
	end if
end tell



---フォントブック内での処理
tell application "Font Book"
	---前面に
	activate
	---Adobeの名前のフォントコレクションの有無を調べます
	set boolFontCollection to exists of font collection theLangAns
	---もしAdobeのコレクションが無い場合
	if boolFontCollection = false then
		try
			---新しいコレクションを作成
			set objFontCollection to make new font collection
		end try
		---おまじないの１秒
		delay numWaitTime
		---作ったコレクション
		tell objFontCollection
			---名前を変更
			set name to theLangAns
		end tell
		---おまじないの１秒
		delay numWaitTime
		tell font collection theLangAns
			---ローカライズ用？
			set displayed name to theLangAns
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
			set listFBFaceCopyrightName to FBFaceCopyrightName of listAdditionalnfo
		end try
		----許諾用のリストの制御　アパッチライセンス
		if theLangAns is "Apache" then
			try
				set listFBFaceCopyrightName to FBFaceLicenseName of listAdditionalnfo
			end try
			----許諾用のリストの制御　オープンフォントライセンス
		else if theLangAns is "SIL" then
			try
				set listFBFaceCopyrightName to FBFaceLicenseName of listAdditionalnfo
			end try
		end if
		---もしも、コピーライト情報をしらべて
		if listFBFaceCopyrightName contains theLangAns then
			---コレクションに追加する
			add theFont to font collection theLangAns
			---ITCの場合だけロングネームの場合があるので別処理
		else if theLangAns contains "ITC" then
			if listFBFaceCopyrightName contains "International Typeface Corporation" then
				---コレクションに追加する
				add theFont to font collection theLangAns
			end if
		end if
	end repeat
end tell

