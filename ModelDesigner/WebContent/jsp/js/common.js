function tabClick(strTh) {
	var strName = "";

	//this.className -> off を on にreplace
	strName = strTh.className;
	strTh.className = strName.replace("off","on");

	strName = "";

	var objCount = (document.all.length) - 0;

	for (i = 0; i < objCount; i++) {
		//TDタグの場合
		if (document.all(i).tagName == "TD") {
			if(document.all(i).name != undefined){
				if (strTh.name != document.all(i).name) {
					//this.name 以外のTdタグの場合
					strName = document.all(i).name.substr(0,3);
					if (strName == 'tab') {
						strName = document.all(i).className;
						//on -> off
						document.all(i).className = strName.replace("on","off");
					}
				}
			}
		}
	}
}



function tabChangeFrame(tp) {

	var intFrm_len = 0;

	//フレームの数
	intFrmLen = (parent.frames.length) - 0;

	//new表示
	if (tp == 1) {
		if (intFrmLen == 7) {
			parent.document.body.rows="90,*,0,0,0,0";
		} else if (intFrmLen == 6) {
			parent.document.body.rows = "90,*,0,0,0,0";
		} else if (intFrmLen == 5) {
			parent.document.body.rows = "90,*,0,0,0";
		} else if (intFrmLen == 4) {
			parent.document.body.rows = "90,*,0,0";
		}

	//説明表示
	} else if (tp == 2) {
		if (intFrmLen == 7) {
			parent.document.body.rows="90,0,*,0,0,0,0";
		} else if (intFrmLen == 6) {
			parent.document.body.rows = "90,0,*,0,0,0";
		} else if (intFrmLen == 5) {
			parent.document.body.rows = "90,0,*,0,0";
		} else if (intFrmLen == 4) {
			parent.document.body.rows = "90,0,*,0";
		}

	//一覧表示
	} else if (tp == 3) {
		if (intFrmLen == 7) {
			parent.document.body.rows="90,0,0,0,*,0,0";
		} else if (intFrmLen == 6) {
			parent.document.body.rows = "90,0,0,0,*,0";
		} else if (intFrmLen == 5) {
			parent.document.body.rows = "90,0,0,*,0";
		} else if (intFrmLen == 4) {
			parent.document.body.rows = "90,0,0,*";
		}
	}


}





function moveDim(tp) {
	var fm_nm = document.form_main;
	var max_cnt;
	var addOption;
	var remainCnt;

	if (tp == 1) {
		//追加
		max_cnt = fm_nm.lst_right.options.length - 0;
		remainCnt=0;

		//右側のセレクトメニューから選択されたデータを取得＆削除
		for (i = 0; i < max_cnt; i++) {
			if (fm_nm.lst_right.options[remainCnt].selected == true){
				addOption = document.createElement("OPTION");
				addOption.value = fm_nm.lst_right.options[remainCnt].value;
				addOption.text = fm_nm.lst_right.options[remainCnt].text;
				fm_nm.lst_right.remove(remainCnt);
				fm_nm.lst_left.options.add(addOption);
			}else{
				remainCnt=remainCnt+1;
			}
		}

	} else if (tp == 0) {
		//追加
		max_cnt = fm_nm.lst_left.options.length - 0;
		remainCnt=0;

		//左側のセレクトメニューから選択されたデータを取得＆削除
		for (i = 0; i < max_cnt; i++) {
			if (fm_nm.lst_left.options[remainCnt].selected == true){
				addOption = document.createElement("OPTION");
				addOption.value = fm_nm.lst_left.options[remainCnt].value;
				addOption.text = fm_nm.lst_left.options[remainCnt].text;
				fm_nm.lst_left.remove(remainCnt);
				fm_nm.lst_right.options.add(addOption);
			}else{
				remainCnt=remainCnt+1;
			}
		}
	}


}






//LEVELSEQを取得し（レベルアイコンを表示）
function getNewSeq(type){
	document.form_main.action="../hidden/dim_get_seq.jsp?type=" + type;
	document.form_main.target="frm_hidden";
	document.form_main.submit();
}


//テーブル名からリストを作成して、選択状態にする
function createColumnList(tableName,listBoxName,selectValue){
	resetList(document.form_main.elements[listBoxName]);
	if(document.form_main.elements[tableName]!=undefined){
		for(i=1;i<document.form_main.elements[tableName].length;i++){
			var tempOpValue = document.form_main.elements[tableName].childNodes[i].value;
			var tempOpText = document.form_main.elements[tableName].childNodes[i].text;
			addOption = document.createElement("OPTION");
			addOption.value = tempOpValue;
			addOption.text = tempOpText;
			document.form_main.elements[listBoxName].add(addOption);
		}
	}
	if(selectedValue!=undefined){
		document.form_main.elements[listBoxName].options[selectedValue(document.form_main.elements[listBoxName],selectValue)].selected=true;
	}
}



//リストボックスのメニューをリセット
function resetList(obj){
	for(i=1;i<obj.length;i++){
		obj.remove(i);
		i--;
	}
}


//リストボックスを選択状態にする為のモジュール
function selectedValue(obj,objValue){
	for(i=0;i<obj.length;i++){
		if(obj.options[i].value==objValue){
			return i;
		}
	}
	return 0;
}


function dispSqlViewer(){

	setBeforeRegist();

	document.form_main.action = "../hidden/dim_regist.jsp?tp=9";
	document.form_main.target = "frm_hidden";
	document.form_main.submit();

}


function setBeforeRegist() {
	setData();
	var levelNum=0;
	document.form_main.hid_levelseq_string.value="";
	for(i=1;i<=max_num;i++){
		div_id = "div_level" + i;
		if(chart.document.getElementById(div_id).objId!="0"){
			if(levelNum!=0){
				document.form_main.hid_levelseq_string.value+=",";
			}
			document.form_main.hid_levelseq_string.value+= chart.document.getElementById(div_id).objId;
			var tempLevelNo = chart.document.getElementById(div_id).level;
			if(tempLevelNo==""){tempLevelNo=1;}
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_level_no"].value=tempLevelNo;

			var tempString = chart.document.getElementById(div_id).firstChild.innerHTML;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_name"].title=tempString;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_comment"].title=tempString;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_table"].title=tempString;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_longname"].title=tempString;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_shortname"].title=tempString;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_sortcol"].title=tempString;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_keycol1"].title=tempString;
			document.form_main.elements["hid_lv" + chart.document.getElementById(div_id).objId + "_where_clause"].title=tempString;

			levelNum++;
		}
	}
	return levelNum;
}





function logout(id){
	if(showConfirm("CFM5")){
		if(id=='tab'){
			document.form_main.action = "../logout.jsp";
		}else if(id=='rmodel'){
			document.form_main.action = "../../../jsp/logout.jsp";
		}else{
			document.form_main.action = "logout.jsp";
		}
		document.form_main.target = "_self";
		document.form_main.submit();
	}
}
