// ===== メッセージ表示 =============================================

	// ユーザーにメッセージを表示
	function showSelecterMessage( id,arg1,arg2,arg3,arg4,arg5 ) {

		var message    = "";
		var arg1String = "";
		var arg2String = "";
		var arg3String = "";
		var arg4String = "";
		var arg5String = "";

		switch ( id ) {
		
			// セレクタ 軸メンバー情報ＸＭＬが非整形である
			case "1" :
				message = "セレクタ 軸メンバー情報ＸＭＬの取得に失敗しました。\n" + arg1;
				break;

		}

		alert( message );
	}
