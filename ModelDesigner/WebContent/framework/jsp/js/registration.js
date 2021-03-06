

//***************************************************************
//	関数名		:checkData
//　機能概要	:エラーチェック
//　引数		:
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function checkData(){

	var objCount = document.all.length;
	var errNum = 0;





	for (i = 0; i < objCount; i++) {
		var obj = document.all[i];

		if (obj.tagName=='INPUT') {
			//テキストボックス
			if((obj.type=='text')&&(obj.mON!=undefined)){
				if(obj.name.indexOf('_comment')!=-1){
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//不正文字(& ' < >)チェック
				}else if(obj.name=='txt_sql'){
					if(errNum==0){errNum = IsIllegalChar(obj,2);}//不正文字(& ")チェック
				}else if(obj.name.indexOf('_integer')!=-1){
					obj.value = TrimAllStr(obj.value);//全トリム
					errNum = IsNullChar(obj);//未入力チェック
					if(errNum==0){errNum = IntNumCheck(obj);}//数値チェック
					if(errNum==0){errNum = DecimalCheck(obj);}//整数チェック
				}else{
					obj.value = TrimAllStr(obj.value);//全トリム
					errNum = IsNullChar(obj);//未入力チェック
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//不正文字(& ' < >)チェック
				}
			} else if (obj.type=='password') {
				errNum = IsNullChar(obj);//未入力チェック
				if(errNum==0){errNum = IsIllegalChar(obj,1);}//不正文字(& ' < >)チェック
			}else if((obj.type=='hidden')&&(obj.mON!=undefined)){
				if(obj.name.indexOf('_comment')!=-1){
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//不正文字(& ' < >)チェック
				}else if(obj.name.indexOf('where_clause')!=-1){
					if(errNum==0){errNum = IsIllegalChar(obj,2);}//不正文字(& ")チェック
				}else{
					obj.value = TrimAllStr(obj.value);//全トリム
					errNum = IsNullChar(obj);//未入力チェック
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//不正文字(& ' < >)チェック
				}
			}
		}else if((obj.tagName=='SELECT')&&(obj.mON!=undefined)&&(obj.disabled!=true)){
			if (obj.value=="") {
				errNum = 101;
			}
		}else if((obj.type=='textarea')&&(obj.disabled!=true)&&(obj.readonly!=undefined)){
			errNum = IsNullChar(obj);//未入力チェック
			if(errNum==0){errNum = IsIllegalChar(obj,2);}//不正文字(& ")チェック
		}



		//エラー処理
		if(errNum!=0){
			showMsg("ERR"+errNum,obj.mON,obj.title);
			if(obj.type!='hidden'){
				obj.focus();
				if (obj.tagName != 'SELECT') {//リストボックスではセレクトできない
					obj.select();
				}
			}
			return false;
		}




	}


	return true;


}











//***************************************************************
//	関数名		:IsIllegalChar
//　機能概要	:登録画面 不正文字チェック
//　引数		:Obj=オブジェクト intVal=チェックパターン
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function IsIllegalChar(Obj,intVal) {
	var err_flg = 0;
	var strObj = Obj.value;
	if (intVal == 1) {
			//不正文字 [& ' < > \]
			if(strObj.indexOf("&")!=-1 || strObj.indexOf("'")!=-1 || strObj.indexOf("<")!=-1 || strObj.indexOf(">")!=-1 || strObj.indexOf("\\")!=-1) {
				if(Obj.type!='hidden'){
					err_flg = 11;
				}else if(Obj.type=='hidden'){
					err_flg = 12;
				}
			}
	} else if (intVal == 2) {
			//[Where Clause]の場合 不正文字 [& " \]
			if(strObj.indexOf("&")!=-1 || strObj.indexOf("\"")!=-1 || strObj.indexOf("\\")!=-1) {
				if(Obj.type!='hidden'){
					err_flg = 13;
				}else if(Obj.type=='hidden'){
					err_flg = 14;
				}
			}
	}
	return err_flg;
}






//***************************************************************
//	関数名		:IsNullChar
//　機能概要	:登録画面 未入力チェック
//　引数		:Obj=オブジェクト
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function IsNullChar(Obj) {
	var err_flg = 0;

	if(Obj.value!=undefined){
		var strObj = Obj.value;
	}else if(Obj.value==undefined){
		var strObj = Obj;
	}

	//未入力チェック
	if (strObj == "") {
		if(Obj.type!='hidden'){
			err_flg = 21;
		}else if(Obj.type=='hidden'){
			err_flg = 22;
		}
	}

	return err_flg;

}




//***************************************************************
//	関数名		:IntNumCheck
//　機能概要	:登録画面 数値チェック
//　引数		:Obj=オブジェクト
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function IntNumCheck(Obj) {
	var err_flg = 0;

	if(Obj.value!=undefined){
		var strObj = Obj.value;
	}else if(Obj.value==undefined){
		var strObj = Obj;
	}

	//数値チェック
	if ((isNaN(strObj) == true)&&(strObj != "")) {
		err_flg = 31;
	}

	return err_flg;

}


//***************************************************************
//	関数名		:DecimalCheck
//　機能概要	:登録画面 数値チェック
//　引数		:Obj=オブジェクト
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function DecimalCheck(Obj) {
	var err_flg = 0;

	if(Obj.value!=undefined){
		var strObj = Obj.value;
	}else if(Obj.value==undefined){
		var strObj = Obj;
	}

	//小数点チェック
	if (strObj.indexOf(".") != -1) {
		err_flg = 32;
	}

	return err_flg;

}
 

//***************************************************************
//	関数名		:MinMaxCheck
//　機能概要	:登録画面 数値チェック
//　引数		:Obj=オブジェクト, MinValue=最小値, MaxValue=最大値
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function MinMaxCheck(Obj,MinValue,MaxValue) {
	var err_flg = 0;
	if(Obj.value!=undefined){
		var strObj = Obj.value;
	}else if(Obj.value==undefined){
		var strObj = Obj;
	}
	var intMin = MinValue;
	var intMax = MaxValue;

	if ((strObj.valueOf(Number) > intMax || strObj.valueOf(Number) < intMin)&&(strObj != "")) {
		err_flg = 33;
	}

	return err_flg;

}







//***************************************************************
//	関数名		:いろいろ
//　機能概要	:登録画面 半角スペース、全角スペース削除
//　引数		:strVal=文字列
//	作成		:
//	修正		:
//	備考		:
//***************************************************************

	//Trim左のスペース
	function TrimLeftStr( strVal )
	{
		var tmpStr;
		tmpStr = strVal;
		if ( strVal.charAt(0) == ' ' ) 
		{
			tmpStr = TrimLeftStr( strVal.substr(1, strVal.length ) );
		}
		return tmpStr;
	}
	
	//Trim右のスペース
	function TrimRightStr( strVal )
	{
		var tmpStr;
		tmpStr = strVal;
		if ( strVal.charAt(strVal.length-1) == ' ' ) 
		{
			tmpStr = TrimRightStr( strVal.substr(0, strVal.length - 1 ) );
		}
		return tmpStr
	}
	
	//Trim前と後のスペース
	function TrimStr( strVal )
	{
		var tmpStr;
		tmpStr = TrimLeftStr( strVal );
		return TrimRightStr( tmpStr );
	}

	//Trim全スペース（半角のみ）
	function TrimAllStr( strVal )   
	{
		var tmpStr;
		tmpStr = strVal.replace(/ /g,"");
		return tmpStr;
	}




function showMsg(msgId,arg1,arg2,arg3,arg4,arg5){
	var msg=new Array();
	msg["ERR11"] = arg1+ ":不正文字(& ' < > \\)が含まれています。入力し直してください。";
	if(arg2!=undefined){tempString = arg2 + "の";}
	msg["ERR12"] = tempString + arg1+ ":不正文字(& ' < > \\)が含まれています。入力し直してください。";
	msg["ERR13"] = arg1 + ":不正文字(& \" \\)が含まれています。入力し直してください。";
	if(arg2!=undefined){tempString = arg2 + "の";}
	msg["ERR14"] = tempString + arg1 + ":不正文字(& \" \\)が含まれています。入力し直してください。";
	msg["ERR21"] = arg1 + "が未入力です。" + arg1 + "を入力してください。";
	var tempString = "";
	if(arg2!=undefined&&arg2!=""){tempString = arg2 + "の";}
	msg["ERR22"] = tempString + arg1 + "が未設定です。";
	msg["ERR31"] = arg1 + "を数値で入力してください。";
	msg["ERR32"] = arg1 + "を整数で入力してください。";
	msg["ERR33"] = arg1 + "を有効な範囲で入力してください。";
	msg["ERR101"] = arg1 + "が未選択です。";
	msg["CSD1"] = "レベルのカスタマイズは最大15レベルまでです。";
	msg["CMN1"] = arg1 + "を選択してください。";


	alert(msg[msgId]);
}


function showConfirm(msgId,arg1){
	var msg=new Array();
	msg["CFM1"] = "変更情報は破棄されます。よろしいですか？";
	msg["CFM2"] = arg1 + "を登録します。よろしいですか？";
	msg["CFM3"] = arg1 + "を削除します。よろしいですか？";
	msg["CFM4"] = "";
	msg["CFM5"] = "ログアウトします。よろしいですか？";
	return confirm(msg[msgId]);
}



function setChangeFlg(){
	//[navi_frm]フレームのHidden=1 -- 処理中フラグセット --
	top.frames[1].document.navi_form.change_flg.value = 1;
}



// 画面フローでログアウト時に使用
function logout_flow(element, contextPath) {
//	if ((top.frames[1].document.navi_form.change_flg.value == 1)) {
		if ( showConfirm("CFM5") ) {
			element.href = contextPath + "/Controller?action=logout";
			element.target="_top";
		} else {
			return;
		}
//	}else{
//		element.href = contextPath + "/Controller?action=logout";
//		element.target="_top";
//	}
}
