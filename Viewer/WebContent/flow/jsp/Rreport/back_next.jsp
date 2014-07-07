<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>

<html lang='ja'>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
		<title><%=(String)session.getValue("aplName")%></title>
		<link rel="stylesheet" type="text/css" href="../../../css/common.css">
		<script type="text/javascript" src="../js/registration.js"></script>
		<script language="JavaScript">
			var gamenId = 1;//1,2,3,4
			function pushBack(){
				if (gamenId==2){
					parent.document.body.firstChild.cols = "*,0,0,0";
				}else if(gamenId==3){
					parent.document.body.firstChild.cols = "0,*,0,0";
				}else if(gamenId==4){
					parent.document.body.firstChild.cols = "0,0,*,0";
					parent.frm_result.document.body.rows = "36,0,*";
				}
				dispButton(gamenId=gamenId-1-0);
			}

			function pushNext() {
				if (gamenId==1){

					//	//共通エラーチェックを先に行う
					//	if(!checkData()){return;}

					var obj=parent.frm_start.document.getElementById("reportName");

					errNum = IsNullChar(obj);//未入力チェック
					if(errNum==0){errNum = IsIllegalChar(obj,1);}//不正文字(& ' < >)チェック

					//エラー処理
					if(errNum!=0){
						showMsg("ERR"+errNum,obj.mON,obj.title);
						obj.focus();
						obj.select();
						return;
					}

					getReportName();//画面の名前を取得
					SetUpdateReport()//画面の情報をDBから取得。
					parent.document.body.firstChild.cols = "0,*,0,0";
					if(document.form_main.maxGamenId.value<2){
						document.form_main.maxGamenId.value=2;
					}


					parent.frm_screen.frm_title.document.all.HeaderTitleCenter.innerHTML="ROLAPレポート作成　-　レポート設定(1)　(2/4)";


				}else if(gamenId==2){

					var screenObj = parent.frm_screen.frm_property.document.getElementById("screenType");
					var cssObj = parent.frm_screen.frm_property.document.getElementById("styleType");
					var modelObj = parent.frm_screen.frm_property.document.getElementById("modelType");

//					if(document.form_main.screen_id.value==""){
					if(screenObj.seq==""){
						alert("テンプレートが未選択です。");//fukai
						return;
					}
//					if(document.form_main.style_id.value==""){
					if(cssObj.seq==""){
						alert("スタイルが未選択です。");//fukai
						return;
					}

//					if(document.form_main.model_seq.value==""){
					if(modelObj.seq==""){
						alert("論理モデルが未選択です。");//fukai
						return;
					}

					setScreenXML();//画面のXMLを取得

					parent.document.body.firstChild.cols = "0,0,*,0";
					if(document.form_main.maxGamenId.value<3){
						document.form_main.maxGamenId.value=3;
					}
					mappingScreenLoad();//MappingTree画面を表示
					mappingScreenDisplay();//画面表示
					mappingModelLoad();//ModelTreeを表示

				//	var tempStr=parent.frm_mapping.frm_mapping_db.getDbXML().xml;
				//	document.all.div_textarea.innerText=tempStr;


					parent.frm_mapping.frm_title.document.all.HeaderTitleCenter.innerHTML="ROLAPレポート作成　-　レポート設定(2)　(3/4)";


				}else if(gamenId==3){
					if(parent.frm_mapping.frm_mapping_property.checkScreenProperty()==false){
						return;
					}

					setDbXML("last");


					if(sqlXML==undefined){
						alert("表示項目・条件項目が未設定です。");//fukai
						return;
					}


					document.form_main.target = "frm_result_view";
					document.form_main.action = "waiting.jsp";
					document.form_main.submit();

					parent.document.body.firstChild.cols = "0,0,0,*";
					if(document.form_main.maxGamenId.value<4){
						document.form_main.maxGamenId.value=4;
					}



					parent.frm_result.frm_title.document.all.HeaderTitleCenter.innerHTML="ROLAPレポート作成　-　サンプル確認(4/4)";

				}
				dispButton(gamenId=gamenId+1-0);

			}
			function dispButton(newGamenId){
				gamenId=newGamenId;
				var go=document.getElementById("go");
				var back=document.getElementById("back");
				var save=document.getElementById("save");
				if(gamenId==1){
					go.style.display='inline';
					back.style.display='none';
					save.style.display='none';
				}else if(gamenId==2){
					go.style.display='inline';
					back.style.display='inline';
					save.style.display='none';
				}else if(gamenId==3){
					go.style.display='inline';
					back.style.display='inline';
					save.style.display='none';
				}else if(gamenId==4){
					go.style.display='none';
					back.style.display='inline';
					save.style.display='inline';
				}
			}
//**************        共通XML        ***************
	var dispXML= new ActiveXObject("MSXML2.DOMDocument");
		dispXML.async = false;
	var sqlXML= new ActiveXObject("MSXML2.DOMDocument");
		sqlXML.async = false;

	//変換前XSL(____--____がついた状態)
	var dispXSL1= new ActiveXObject("MSXML2.DOMDocument");
		dispXSL1.async = false;
	var dispXSL2= new ActiveXObject("MSXML2.DOMDocument");
		dispXSL2.async = false;
	var dispXSL3= new ActiveXObject("MSXML2.DOMDocument");
		dispXSL3.async = false;
	var dispXSL4= new ActiveXObject("MSXML2.DOMDocument");
		dispXSL4.async = false;
	var dispXSL5= new ActiveXObject("MSXML2.DOMDocument");
		dispXSL5.async = false;
	var dispXSL6= new ActiveXObject("MSXML2.DOMDocument");
		dispXSL6.async = false;

	//変換後XSL後（実際に表示するXSL）
	var displayXSL1= new ActiveXObject("MSXML2.DOMDocument");
		displayXSL1.async = false;
	var displayXSL2= new ActiveXObject("MSXML2.DOMDocument");
		displayXSL2.async = false;
	var displayXSL3= new ActiveXObject("MSXML2.DOMDocument");
		displayXSL3.async = false;
	var displayXSL4= new ActiveXObject("MSXML2.DOMDocument");
		displayXSL4.async = false;
	var displayXSL5= new ActiveXObject("MSXML2.DOMDocument");
		displayXSL5.async = false;
	var displayXSL6= new ActiveXObject("MSXML2.DOMDocument");
		displayXSL6.async = false;

	var modelId=null;
	var reload_flg=false;
//**************      共通XML End      ***************


//**************** 1 to 2 Screen**********************
	function getReportName(){
		document.form_main.report_name.value=parent.frm_start.document.getElementById("reportName").value;

		//最初の１回目。Report_idのRadioが配列にならない場合。必ず新規作成
		if(parent.frm_start.document.form_main.report_id.length==undefined){
			document.form_main.report_id.value='0';
			document.form_main.report.value='new';
			return;
		}

		for(var i=0;i<parent.frm_start.document.form_main.report_id.length;i++){
			if(parent.frm_start.document.form_main.report_id[i].checked==true){
				var reportObj = parent.frm_start.document.form_main.report_id[i].value.split(":");
				document.form_main.report_id.value=reportObj[0];
				document.form_main.report.value=reportObj[1];
				break;
			}
		}
	}

	function SetUpdateReport(){
		var reportId=document.form_main.report_id.value;

		if(reportId!='0'){
			//Data取得
			var reportXML = new ActiveXObject("MSXML2.DOMDocument");
			reportXML.async = false;

//	alert("dispXml.jsp?kind=db&rId="+reportId+"&colName=all");
//	alert(reportXML.xml);

			reportXML.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=all");
			var node=reportXML.selectSingleNode("//report");

			//項目の選択
			var screenKindObj = parent.frm_screen.frm_screen.document.getElementById(node.getAttribute("screen_id"));
			screenKindObj.lastChild.previousSibling.onclick();
			screenKindObj.lastChild.previousSibling.setActive();

			var styleKindObj = parent.frm_screen.frm_css.document.getElementById(node.getAttribute("style_id"));
			styleKindObj.lastChild.previousSibling.onclick();
			styleKindObj.lastChild.previousSibling.setActive();

			var modelKindObj = parent.frm_screen.frm_model.document.getElementById(node.getAttribute("model_seq"));
			modelKindObj.lastChild.previousSibling.onclick();
			modelKindObj.lastChild.previousSibling.setActive();


			//Hidden項目にデータをセット
			document.form_main.report_id.value=node.getAttribute("report_id");
//すでに名前をとっているので、いらない。
//			document.form_main.report_name.value=node.getAttribute("report_name");
			document.form_main.screen_id.value=node.getAttribute("screen_id");
			document.form_main.screen_name.value=node.getAttribute("screen_name");
			document.form_main.style_id.value=node.getAttribute("style_id");
			document.form_main.style_name.value=node.getAttribute("style_name");
			document.form_main.model_seq.value=node.getAttribute("model_seq");
			document.form_main.strSQL.value=node.getAttribute("sql_text");
			document.form_main.sql_customized_flg.value=node.getAttribute("sql_customized_flg");

			dispXML.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=screen_xml");
			sqlXML.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=sql_xml");
			document.form_main.sqlXml.value=sqlXML.xml;

			displayXSL1.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=screen_xsl");
			document.form_main.cssXML1.value=displayXSL1.xml;
			displayXSL2.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=screen_xsl2");
			document.form_main.cssXML2.value=displayXSL2.xml;
			displayXSL3.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=screen_xsl3");
			document.form_main.cssXML3.value=displayXSL3.xml;
			displayXSL4.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=screen_xsl4");
			document.form_main.cssXML4.value=displayXSL4.xml;
			displayXSL5.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=screen_xsl5");
			document.form_main.cssXML5.value=displayXSL5.xml;
			displayXSL6.load("dispXml.jsp?kind=db&rId="+reportId+"&colName=screen_xsl6");
			document.form_main.cssXML6.value=displayXSL6.xml;

		}
	}
//**************** 1 to 2 Screen end *****************


//**************** 2 to 3 Screen**********************
			function setScreenXML(){
				var screenObj = parent.frm_screen.frm_property.document.getElementById("screenType");
				var cssObj = parent.frm_screen.frm_property.document.getElementById("styleType");
				var modelObj = parent.frm_screen.frm_property.document.getElementById("modelType");
				modelId=modelObj.seq;
				if(document.form_main.maxGamenId.value<3){//Mappingしていない
//alert(document.form_main.maxGamenId.value);
//alert(document.form_main.report_id.value);
					if(document.form_main.report_id.value=='0'){//新規作成（全部読み込み）
						dispXML = parent.frm_screen.frm_css.getScreenXML();
						dispXSL1 = parent.frm_screen.frm_css.getScreenXSL(1);
						dispXSL2 = parent.frm_screen.frm_css.getScreenXSL(2);
						dispXSL3 = parent.frm_screen.frm_css.getScreenXSL(3);
						dispXSL4 = parent.frm_screen.frm_css.getScreenXSL(4);
						dispXSL5 = parent.frm_screen.frm_css.getScreenXSL(5);
						dispXSL6 = parent.frm_screen.frm_css.getScreenXSL(6);

						document.form_main.screen_id.value=screenObj.seq;
						document.form_main.screen_name.value=screenObj.outerText;
						document.form_main.style_id.value=cssObj.seq;
						document.form_main.style_name.value=cssObj.outerText;
						document.form_main.model_seq.value=modelObj.seq;

					}else{//編集（何もしない）
						//編集でいきなり変更された場合は読み込む必要あり。
						reloadScreenXML(screenObj,cssObj,modelObj);
//alert(dispXML.xml);
					}
				}else{//3画面まで行っている。
//alert(document.form_main.screen_id.value+"  "+screenObj.seq);
//alert(document.form_main.model_seq.value+"  "+modelObj.seq);
					reloadScreenXML(screenObj,cssObj,modelObj);
				}
			}
			function reloadScreenXML(screenObj,cssObj,modelObj){
				//画面ID、DBのModelSeqが変わった時は、全取っ替え。
				if(document.form_main.screen_id.value!=screenObj.seq || document.form_main.model_seq.value!=modelObj.seq){
//alert("違う");
					dispXML = parent.frm_screen.frm_css.getScreenXML();
					dispXSL1 = parent.frm_screen.frm_css.getScreenXSL(1);
//alert(dispXSL1.xml);
					dispXSL2 = parent.frm_screen.frm_css.getScreenXSL(2);
					dispXSL3 = parent.frm_screen.frm_css.getScreenXSL(3);
					dispXSL4 = parent.frm_screen.frm_css.getScreenXSL(4);
					dispXSL5 = parent.frm_screen.frm_css.getScreenXSL(5);
					dispXSL6 = parent.frm_screen.frm_css.getScreenXSL(6);

					document.form_main.screen_id.value=screenObj.seq;
					document.form_main.screen_name.value=screenObj.outerText;
					document.form_main.style_id.value=cssObj.seq;
					document.form_main.style_name.value=cssObj.outerText;
					document.form_main.model_seq.value=modelObj.seq;

					displayXSL1.loadXML("");
					reload_flg=true;

					var styleNode;
					if(dispXSL1.xml==''){
						styleNode = displayXSL1.selectSingleNode("//*[@id='stylefile']");
					}else{
						styleNode = dispXSL1.selectSingleNode("//*[@id='stylefile']");
					}
					var screenKindXML = parent.frm_screen.frm_screen.getScreenKindXML();
					screenKindXML = screenKindXML.selectSingleNode("//*[@id="+cssObj.seq+"]");
					styleNode.setAttribute("href",""+screenKindXML.getAttribute("fileName"));
				}else{
//alert("同じ");
					//画面ID、DBのModelSeqが同じでスタイルが変わった時
					if(document.form_main.style_id.value!=cssObj.seq){
//alert("スタイル変更");
						document.form_main.style_id.value=cssObj.seq;
						document.form_main.style_name.value=cssObj.outerText;
						var styleNode;
						if(dispXSL1.xml==''){
							styleNode = displayXSL1.selectSingleNode("//*[@id='stylefile']");
						}else{
							styleNode = dispXSL1.selectSingleNode("//*[@id='stylefile']");
						}
						var screenKindXML = parent.frm_screen.frm_screen.getScreenKindXML();
						screenKindXML = screenKindXML.selectSingleNode("//*[@id="+cssObj.seq+"]");
						styleNode.setAttribute("href",""+screenKindXML.getAttribute("fileName"));
					}
				}
			}
//**************** 2 to 3 Screen end**********************

//**************** 3 Screen**********************
			function getModelId(){
				return modelId;
			}
			function getScreenXML(){
				return dispXML;
			}
			function getScreenXSL(num){
				if(num==1){
					return dispXSL1;
				}else if(num==2){
					return dispXSL2;
				}else if(num==3){
					return dispXSL3;
				}else if(num==4){
					return dispXSL4;
				}else if(num==5){
					return dispXSL5;
				}else if(num==6){
					return dispXSL6;
				}
			}

			function mappingModelLoad(){
				parent.frm_mapping.frm_mapping_db.loadDbXML(modelId);
			}

			function mappingScreenLoad(){
				parent.frm_mapping.frm_mapping_xmllist.loadCssXML(dispXML);

				parent.frm_mapping.frm_mapping_property.displayScreenProperty();//Property画面の表示
			}

			function mappingScreenDisplay(){
				var strResult;
				if(document.form_main.report_id.value=='0' || reload_flg==true){//新規
//				if(displayXSL1.xml==''){//新規
					tempXMLStr=replaceTemplateXML(dispXSL1.xml,dispXML);
					displayXSL1.loadXML(tempXMLStr);
					tempXMLStr=replaceTemplateXML(dispXSL2.xml,dispXML);
					displayXSL2.loadXML(tempXMLStr);
					tempXMLStr=replaceTemplateXML(dispXSL3.xml,dispXML);
					displayXSL3.loadXML(tempXMLStr);
					tempXMLStr=replaceTemplateXML(dispXSL4.xml,dispXML);
					displayXSL4.loadXML(tempXMLStr);
					tempXMLStr=replaceTemplateXML(dispXSL5.xml,dispXML);
					displayXSL5.loadXML(tempXMLStr);
				}

try{//未選択の時XMLを表示できない場合がある。
				var tempXML= new ActiveXObject("MSXML2.DOMDocument");
				tempXML.async = false;
				if(displayXSL5.xml!=''){
					strResult = dispXML.transformNode(displayXSL5);
					tempXML.loadXML(strResult);
				}
				if(displayXSL4.xml!=''){
					if(tempXML.xml!=''){
						strResult = tempXML.transformNode(displayXSL4);
					}else{
						strResult = dispXML.transformNode(displayXSL4);
					}
					tempXML.loadXML(strResult);
				}
				if(displayXSL3.xml!=''){
					if(tempXML.xml!=''){
						strResult = tempXML.transformNode(displayXSL3);
					}else{
						strResult = dispXML.transformNode(displayXSL3);
					}
					tempXML.loadXML(strResult);
				}
				if(displayXSL2.xml!=''){
					if(tempXML.xml!=''){
						strResult = tempXML.transformNode(displayXSL2);
					}else{
						strResult = dispXML.transformNode(displayXSL2);
					}
					tempXML.loadXML(strResult);
				}
				if(displayXSL1.xml!=''){
					if(tempXML.xml!=''){
						strResult = tempXML.transformNode(displayXSL1);
					}else{
						strResult = dispXML.transformNode(displayXSL1);
					}
					tempXML.loadXML(strResult);
				}
}catch(e){
}

//strResult=strResult.replace(/\n/g,'');
//strResult=strResult.replace(/\r/g,'');
//alert(dispXSL1.xml);
//alert(strResult);
//<META http-equiv="Content-Type" content="text/html; charset=UTF-16">
				parent.frm_mapping.frm_view.document.open();
				parent.frm_mapping.frm_view.document.write(strResult);
			}

//**************** 3 Screen end**********************
	function replaceTemplateXML(strXML,dataXML){
//alert(strXML);
	var x=0;
		var tmpStr="";
		var retStr=strXML;
		var strXMLLength=0;
		var strMark="___";
		var nodeStr;
		var nodeAndAtt;
		strXMLLength = retStr.indexOf(strMark);
		while(strXMLLength!=-1){
			tmpStr=retStr.substring(0,strXMLLength);
			nodeStr=retStr.substring(strXMLLength+3,retStr.indexOf(strMark,strXMLLength+3));//
			nodeAndAtt=nodeStr.split("--");
//alert(dataXML.xml);
//alert("//"+nodeAndAtt[0]+":"+nodeAndAtt[1]);
			nodeStr=dataXML.selectSingleNode("//"+nodeAndAtt[0]).getAttribute(nodeAndAtt[1]);
			if(nodeStr=='0'){
				nodeStr='NoNode'
			}
			tmpStr+=nodeStr;
			tmpStr+=retStr.substring(retStr.indexOf(strMark,strXMLLength+3)+3);//
			retStr = tmpStr;
			strXMLLength = retStr.indexOf(strMark);
		}
		retStr=removeTemplateXML(retStr,dataXML);//不要なコードを取り除く
		return retStr;
	}

	function removeTemplateXML(strXML,dataXML){
		var tmpStr="";
		var retStr=strXML;
		var strXMLLength=0;
		var strMark="NoNode";
		var nodeStr;
		var nodeAndAtt;
		strXMLLength = retStr.indexOf(strMark);
		while(strXMLLength!=-1){
				tmpStr=retStr.substring(0,strXMLLength);//最初の%%までの文字
			if((tmpStr.lastIndexOf("\n")>tmpStr.lastIndexOf("NoRemove")) || (tmpStr.lastIndexOf("NoRemove")==-1)){
				tmpStr=tmpStr.substring(0,tmpStr.lastIndexOf("\n"));

				nodeStr=retStr.substring(strXMLLength);//
				nodeStr=nodeStr.substring(nodeStr.indexOf("\n"));//

				retStr = tmpStr+nodeStr;
			}else{
				nodeStr= "disp"+retStr.substring(strXMLLength+2);//
				retStr = tmpStr+nodeStr;
			}
			strXMLLength = retStr.indexOf(strMark);
		}
		return retStr;
	}
//**************** 4 Screen**********************
//	var dbXML=null;
	function setDbXML(status){
		sqlXML = parent.frm_mapping.frm_mapping_db.getDbXML();
		sqlXML=setUseFlgToSqlXML(sqlXML,dispXML);

		if(sqlXML==undefined){//fukai
			return;
		}

		document.form_main.sqlXml.value=sqlXML.xml;
		document.form_main.screenXML.value=dispXML.xml;
		document.form_main.cssXML1.value=displayXSL1.xml
		document.form_main.cssXML2.value=displayXSL2.xml;
		document.form_main.cssXML3.value=displayXSL3.xml
		document.form_main.cssXML4.value=displayXSL4.xml
		document.form_main.cssXML5.value=displayXSL5.xml
		document.form_main.cssXML6.value=displayXSL6.xml

		document.form_main.target = "frm_hidden";
		document.form_main.action = "setRxml_sql.jsp?status="+status;
		document.form_main.submit();

	}

	function setUseFlgToSqlXML(sqlXML,dispXML){
		var selectListNode;
		var setNode;
		var strXPath="";

		//初期化
		selectListNode = sqlXML.selectNodes("//*[@use_flg='1']");
		for(i=0;i<selectListNode.length;i++){
			selectListNode.item(i).setAttribute("use_flg","0");
		}


		selectListNode = dispXML.selectNodes("//sql/sqlcol");
		var cnt=0;
		for(i=0;i<selectListNode.length;i++){
			strXPath = "//*[@id='"+selectListNode.item(i).getAttribute("dbId")+"']"
			setNode=sqlXML.selectSingleNode(strXPath);


			if(setNode==null){
				return;
			}



			if(setNode.getAttribute("use_flg")=="1"){//名前が重なっている場合は設定済みなので何もしない。
			}else{
				setNode.setAttribute("use_flg","1");
				setNode.setAttribute("use_order",cnt);
				cnt=cnt+1;
			}
		}

		selectListNode = dispXML.selectNodes("//screenSql/where_clause");
		for(i=0;i<selectListNode.length;i++){
			strXPath = "//*[@id='"+selectListNode.item(i).getAttribute("dbId")+"']"
			setNode=sqlXML.selectSingleNode(strXPath);
			setNode.setAttribute("use_flg","1");
			setNode.setAttribute("use_order",i);
		}
		return sqlXML;
	}

	function setSQL(argSQL){
		var sqlStr = document.getElementById("getDataSQL");
		sqlStr.value=argSQL;
		var screenXMLStr = document.getElementById("templateXML");
		screenXMLStr.value=dispXML.xml;

		document.form_main.target = "frm_result_view";
		document.form_main.action = "../../../Controller?action=getResultXML";
		document.form_main.submit();

	}

	function saveDb(){


		if((dispXML.xml=="")||(sqlXML.xml=="")){
			alert("未設定の項目があります。設定を確認してください。");
			return;
		}

		if(confirm(document.form_main.report_name.value+"を保存します。よろしいですか？")){
			document.form_main.target = "frm_hidden";
			document.form_main.action = "rReport_save.jsp";
			document.form_main.submit();
		}
	}

//**************** 4 Screen end**********************

		</script>
	</head>
	<body>
		<form name="form_main" id="form_main" method="post" action="">
			<div class="WizardButtonArea">
				<input id="back" type="button" value="" onclick="pushBack();" class="normal_back" onMouseOver="className='over_back'" onMouseDown="className='down_back'" onMouseUp="className='up_back'" onMouseOut="className='out_back'" style='display:none;'>
				<input id="go" type="button" value="" onclick="pushNext();" class="normal_next" onMouseOver="className='over_next'" onMouseDown="className='down_next'" onMouseUp="className='up_next'" onMouseOut="className='out_next'">
				<input id="save" type="button" value="" onclick="saveDb();" class="normal_ok" onMouseOver="className='over_ok'" onMouseDown="className='down_ok'" onMouseUp="className='up_ok'" onMouseOut="className='out_ok'" style='display:none;'>
			</div>
			<input type='hidden' name='sqlXml' id='sqlXml' value=''/><!--SQL作成用XML-->
			<input type='hidden' name='strSQL' id='strSQL' value=''/><!--SQL文-->
			<input type='hidden' name='screenXML' id='screenXML' value=''/><!--R画面TemplateXML-->
			<input type='hidden' name='cssXML1' id='cssXML1' value=''/><!--R画面CSS1-->
			<input type='hidden' name='cssXML2' id='cssXML2' value=''/><!--R画面CSS2-->
			<input type='hidden' name='cssXML3' id='cssXML3' value=''/><!--R画面CSS3-->
			<input type='hidden' name='cssXML4' id='cssXML4' value=''/><!--R画面CSS4-->
			<input type='hidden' name='cssXML5' id='cssXML5' value=''/><!--R画面CSS5-->
			<input type='hidden' name='cssXML6' id='cssXML6' value=''/><!--R画面CSS6-->

			<input type='hidden' name='report'    id='report' value=''/>
			<input type='hidden' name='report_id' id='report_id' value=''/>
			<input type='hidden' name='report_name' id='report_name' value=''/>
			<input type='hidden' name='screen_id' id='screen_id' value=''/>
			<input type='hidden' name='screen_name' id='screen_name' value=''/>
			<input type='hidden' name='style_id' id='style_id' value=''/>
			<input type='hidden' name='style_name' id='style_name' value=''/>
			<input type='hidden' name='model_seq' id='model_seq' value=''/>
			<input type='hidden' name='sql_customized_flg' id='sql_customized_flg' value='0'/>

			<input type='hidden' name='maxGamenId' id='maxGamenId' value='1'/>



		</form>
	<body>
</html>