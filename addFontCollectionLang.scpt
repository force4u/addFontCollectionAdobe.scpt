(*

addFontCollectionLang.scpt
20160308　初回作成　


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
	---フルリスト
	---set listLngList to {"アイスランド語", "アイルランド語", "アゼルバイジャン語", "アフリカーンス語", "アラビア語", "アルバニア語", "イタリア語", "インドネシア語", "ウェールズ語", "ウクライナ語", "ウズベク語", "ウルドゥー語", "エストニア語", "エスペラント語", "オランダ語", "オロモ語", "カザフ語", "カタロニア語", "ガリシア語", "ギリシャ語", "グリーンランド語", "クロアチア語", "コーンウォール語", "スウェーデン語", "スペイン語", "スロバキア語", "スロベニア語", "スワヒリ語", "セルビア語", "ソマリ語", "チェコ語", "デンマーク語", "ドイツ語", "トルコ語", "ノルウェー語 (ニーノシュク)", "ノルウェー語 (ブークモール)", "バスク語", "ハワイ語", "ハンガリー語", "フィンランド語", "フェロー語", "フランス語", "ブルガリア語", "ベトナム語", "ヘブライ語", "ベラルーシ語", "ポーランド語", "ポルトガル語", "マケドニア語", "マルタ語", "ラトビア語", "リトアニア語", "ロシア語", "英語", "韓国語", "中国語", "中国語 (繁体字)", "中国語 (簡体字)"} as list
	---自分用リスト
	set listLngList to {"アラビア語", "イタリア語", "インドネシア語", "オランダ語", "ギリシャ語", "スウェーデン語", "スペイン語", "スワヒリ語", "チェコ語", "デンマーク語", "ドイツ語", "トルコ語", "ハンガリー語", "フランス語", "ベトナム語", "ヘブライ語", "ポーランド語", "ポルトガル語", "ロシア語", "英語", "韓国語", "中国語", "中国語 (繁体字)", "中国語 (簡体字)"} as list
	
	set theLangAns to (choose from list listLngList with title "言語選択" with prompt "フォントコレクションを作成する言語を選択してください" default items "日本語" without multiple selections allowed and empty selection allowed) as text
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
		set listFBLanguages to ""
		---追加情報から言語情報を取得
		try
			set listFBLanguages to FBFaceLanguages of listAdditionalnfo
		end try
		---もしも、言語情報に指定の文字があったら
		if listFBLanguages contains theLangAns then
			---コレクションに追加する
			add theFont to font collection theLangAns
		end if
	end repeat
end tell




