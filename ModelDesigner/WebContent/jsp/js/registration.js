




//***************************************************************
//	関数名		:submitData
//　機能概要	:
//　引数		:
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function submitData(filename,tp,objKind,objSeq,objName){
	if(tp!=2){
		if(checkData()){
			//整合性チェック
			document.form_main.action = "../hidden/regist_check.jsp?filename=" + filename + "&tp=" + tp + "&objKind=" + objKind + "&objSeq=" + objSeq + "&objName=" + objName;
			document.form_main.target = "frm_hidden";
			document.form_main.submit();
		}
	}else if(tp==2){
		//整合性チェック
		document.form_main.action = "../hidden/regist_check.jsp?filename=" + filename + "&tp=" + tp + "&objKind=" + objKind + "&objSeq=" + objSeq + "&objName=" + objName;
		document.form_main.target = "frm_hidden";
		document.form_main.submit();
	}
}


function formSubmit(filename,tp,formObj,objKind){
	var submitFlg=true;
	if(objKind.indexOf("SQLTuning")!=-1){
		submitFlg=showConfirm("CFM4",formObj.txt_name.value);
	}else{
		submitFlg=getConfirm(tp,formObj);
	}

	if(submitFlg){
		formObj.action = "../hidden/" + filename + "?tp=" + tp;
		formObj.target = "frm_hidden";
		formObj.submit();
	}
}



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
				}else if(obj.name.indexOf('_integer')!=-1){
					obj.value = TrimAllStr(obj.value);//全トリム
					errNum = IsNullChar(obj);//未入力チェック
					if(errNum==0){errNum = IntNumCheck(obj);}//数値チェック
					if(errNum==0){errNum = DecimalCheck(obj);}//整数チェック
				}else if(obj.name.indexOf('_numeric')!=-1){
					obj.value = TrimAllStr(obj.value);//全トリム
					errNum = IsNullChar(obj);//未入力チェック
					if(errNum==0){errNum = IntNumCheck(obj);}//数値チェック
					if(errNum==0){errNum = NumericCheck(obj);}//数値チェック

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
					if(errNum==0){errNum = MaxLengthCheck(obj);}//不正文字(& ")チェック
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
		}else if((obj.type=='textarea')&&(obj.mON!=undefined)&&(obj.disabled!=true)&&(obj.readonly==undefined)){
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
	var strObj = Obj.value;

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
	var strObj = Obj.value;

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
	var strObj = Obj.value;

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
	var strObj = Obj.value;
	var intMin = MinValue;
	var intMax = MaxValue;

	if ((strObj.valueOf(Number) > intMax || strObj.valueOf(Number) < intMin)&&(strObj != "")) {
		err_flg = 33;
	}

	return err_flg;

}


//***************************************************************
//	関数名		:NumericCheck
//　機能概要	:登録画面 小数点有効桁（第2位まで）チェック
//　引数		:Obj=オブジェクト
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function NumericCheck(Obj) {
	var err_flg = 0;
	var strObj = Obj.value;

	//小数点有効桁（第2位まで）チェック
	if(strObj.substring(0,strObj.length-3).indexOf(".")!=-1){
		err_flg = 34;
	}

	return err_flg;

}



//***************************************************************
//	関数名		:NumericCheck
//　機能概要	:登録画面 小数点有効桁（第2位まで）チェック
//　引数		:Obj=オブジェクト
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
function MaxLengthCheck(Obj) {
	var err_flg = 0;
	var strObj = Obj.value;

	//MAXLENGTH（250文字以内まで）チェック
	if(strObj.length>250){
		err_flg = 41;
	}

	return err_flg;

}





//***************************************************************
//	関数名		:
//　機能概要	:登録画面 半角スペース削除
//　引数		:strVal=文字列
//	作成		:
//	修正		:
//	備考		:
//***************************************************************
/*
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
*/

	//Trim全スペース（半角のみ）
	function TrimAllStr( strVal )   
	{
		var tmpStr;
		tmpStr = strVal.replace(/ /g,"");
		return tmpStr;
	}




function showMsg(msgId,arg1,arg2){
	var msg=new Array();
	msg["LOG01"] = "メタユーザーを入力してください。";
	msg["LOG02"] = "メタスキーマを入力してください。";
	msg["LOG03"] = "コネクトソースを入力してください。";
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
	msg["ERR34"] = arg1 + "は少数点以下第2位までの数値で入力してください。";
	msg["ERR41"] = arg1 + "は250文字以内で入力してください。";
	msg["ERR101"] = arg1 + "が未選択です。";
	msg["COM1"] = "オブジェクトをコピーしました。";
	msg["USR1"] = "使用可能なソースを一つ以上指定してください。";
	msg["USR2"] = arg1 + "スキーマは存在しません。";
	msg["USR3"] = arg1 + "スキーマは既にディメンションを登録済みであるため、削除できません。";
	msg["DIM1"] = "レベルを作成してください。";
	msg["DIM2"] = arg1 + "と" + arg2 + "のマッピングが正しく設定されていません。マッピングを確認してください。";
	msg["DIM3"] = "マッピングされていないレベルがあります。";
	msg["DIM4"] = "レベルは最大" + arg1 + "個までです。";
	msg["DIM5"] = "レベルのマッピングを循環させることはできません。";
	msg["DIM6"] = arg1 + "は既にメジャーで使用されているため、削除できません。";
	msg["CHT1"] = "マッピング済みです。";
	msg["CHT2"] = "不正なマッピングです。";
	msg["TIM1"] = "時間ディメンション構成を設定してください。";
	msg["TIM2"] = arg1 + "は既にキューブで使用されているため、削除できません。";
	msg["TIM3"] = "データ保持期間の範囲を正しく設定してください。";
	msg["MES1"] = "ディメンションを作成してマッピングしてください。";
	msg["MES2"] = arg1 + "と" + arg2 + "のマッピングが正しく設定されていません。マッピングを確認してください。";
	msg["MES3"] = "時間ディメンション以外のディメンションは最大" + arg1 + "個までです。";
	msg["MES4"] = arg1 + "は既に追加されています。";
	msg["MES5"] = "警告：" + arg1 + "と同じディメンションパターンのメジャーが既にキューブに登録されています。\nディメンションを追加する場合は他のメジャーも同様にディメンションを追加する必要があります。";
	msg["MES6"] = "メジャー名はPostgreSQLのカラム名に指定できる文字列を設定してください。";
	msg["MES7"] = "時間ディメンションが存在しません。時間ディメンションのマッピングを削除するか、時間ディメンションを作成後、再度登録してください。";
	msg["MES8"] = arg1 + "は既にキューブで使用されているため、削除できません。";
	msg["MES9"] = "ファクトテーブルは一つ以上のディメンションもしくは時間ディメンションとマッピングしなければなりません。";
	msg["MES10"] = arg1 + "は既にキューブで使用されているため、ディメンションを削除することはできません。";
	msg["CUB1"] = "選択メジャーを指定してください。";
	msg["CUB2"] = "選択メジャーにディメンションパターンが異なるメジャーを指定することはできません。";
	msg["CUB3"] = "追加するメジャーを選択してください。";
	msg["CUB4"] = "警告：各メジャーで設定されているファクトテーブルのリンクカラムが同一ではありません。ファクトリンクカラムを確認してください。";
	msg["CUB5"] = arg1 + "は実キューブが存在するため、削除できません。";
	msg["CUB6"] = "警告：キューブ構成が変更されている場合、キューブ構成は初期化されます。";
	msg["CUB7"] = "キューブに登録できるメジャーは最大" + arg1 + "個までです。";
	msg["CUB8"] = "削除するメジャーを選択してください。";
	msg["FML1"] = "自分自身を計算式に含めることはできません。";
	msg["CST1"] = "全てのオブジェクトを削除することはできません。";
	msg["TNG1"] = "SQLを登録しました。";
	msg["JRG1"] = "キューブが未選択です。";
	msg["JRG2"] = "「スクラップ＆ビルド」とそれ以外のプロセスを同時に指定することはできません。";
	msg["JRG3"] = "実行リストに追加しました。";
	msg["JRG4"] = arg1 + "を削除しました。";
	msg["JRG5"] = arg1 + "を中止します。";
	msg["JRG6"] = arg1 + "は既に終了しています。";
	msg["JRG7"] = "最近使用したジョブが未選択です。";
	msg["CSD1"] = "レベルのカスタマイズは最大15レベルまでです。";
	msg["CSD2"] = arg1 + "は既にキューブで使用されているため、削除できません。";


	alert(msg[msgId]);
}

function getConfirm(tp,formObj){
	var strTemp="";
	if(tp==0){
		strTemp="作成";
	}else if(tp==1){
		strTemp="更新";
	}else if(tp==2){
		strTemp="削除";
	}else if(tp==3){
		strTemp="作成後、実行リストに追加";
	}else if(tp==4){
		strTemp="更新後、実行リストに追加";
	}
	return confirm(formObj.txt_name.value + "を" + strTemp + "します。よろしいですか？");
}


function showConfirm(msgId,arg1){
	var msg=new Array();
	msg["CFM1"] = "変更情報は破棄されます。よろしいですか？";
	msg["CFM2"] = "カスタマイズされたSQLは初期化されます。よろしいですか？";
	msg["CFM3"] = "このオブジェクトをコピーします。よろしいですか？";
	msg["CFM4"] = arg1 + "を登録します。よろしいですか？";
	msg["CFM5"] = "ログアウトします。よろしいですか？";
	return confirm(msg[msgId]);
}


function getReturnMsg(objName,tp){
	var strTemp="";
	if(tp==0){
		strTemp="作成";
	}else if(tp==1){
		strTemp="更新";
	}else if(tp==2){
		strTemp="削除";
	}
	alert(objName + "を" + strTemp + "しました。");
}





function setChangeFlg(){
	//[navi_frm]フレームのHidden=1 -- 処理中フラグセット --
	top.frames[1].document.navi_form.change_flg.value = 1;
}