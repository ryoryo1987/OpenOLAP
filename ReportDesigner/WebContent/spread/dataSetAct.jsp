<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.*,openolap.viewer.Report,openolap.viewer.Measure,openolap.viewer.MeasureMember"
%>
<%!
	/**
	*文字列を置換します。
	*@param strTarget 対象文字列
	*@param strOldStr 置換対象文字列
	*@param strOldNew 置き換える文字列
	*@return strResult 置換された文字列
	*/
	private static String replace(String strTarget, String strOldStr, String strOldNew){
	    String strSplit[];
	    String strResult;

	    strSplit = split(strTarget, strOldStr);
	    strResult = strSplit[0];
	    for (int i = 1; i < strSplit.length; i ++){
	        strResult += strOldNew + strSplit[i];
	    }

	    return strResult;
	}

	/**
	*replaceメソッドで内部的に使用
	*/
	private static String[] split(String strTarget, String strDelimiter){
	    String strResult[];
	    Vector objResult;
	    int intDelimiterLen;
	    int intStart;
	    int intEnd;

	    objResult = new java.util.Vector();
	    strTarget += strDelimiter;
	    intDelimiterLen = strDelimiter.length();
	    intStart = 0;
	    while ((intEnd = strTarget.indexOf(strDelimiter, intStart)) >= 0){
	        objResult.addElement(strTarget.substring(intStart, intEnd));
	        intStart = intEnd + intDelimiterLen;
	    }

	    strResult = new String[objResult.size()];
	    objResult.copyInto(strResult);
	    return strResult;
	}

%>

	<HTML>
		<HEAD>
			<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
			<title><%=(String)session.getValue("aplName")%></title>
			<script type="text/javascript" src="./spread/js/spreadFunc.js"></script>
		</HEAD>
		<BODY onLoad="initialize();" style="background-color:#EFECE7;margin:0;padding:0;">
			<FORM name='form_main' method="post">
			</FORM>
		</BODY>
	</HTML>

	<script language="JavaScript">


var defaultBColor = "white";
var defaultTColor = "black";


var highLightXml = new ActiveXObject("MSXML2.DOMDocument");
highLightXml.async = false;
var strXml="";

<%

	Report report = (Report)session.getAttribute("report");
	String highLightXML = report.getHighLightXML();

	if((highLightXML==null)||("null".equals(highLightXML))){

		String defaultHighLightXML="";


		Measure measure = report.getMeasure();
		Iterator nextAxisMemIt = measure.getAxisMemberList().iterator();
		nextAxisMemIt = measure.getAxisMemberList().iterator();
		defaultHighLightXML+="<ColorConfig>";
//		defaultHighLightXML+="<ColorType>1</ColorType>";
		defaultHighLightXML+="<Measures>";
		while (nextAxisMemIt.hasNext()) {
			MeasureMember measureMember = (MeasureMember) nextAxisMemIt.next();
			defaultHighLightXML+="<Measure id=\"" + measureMember.getMeasureSeq() + "\" name=\"" + measureMember.getMeasureName() + "\">";
			defaultHighLightXML+="<Mode>None</Mode>";
			defaultHighLightXML+="<HighLight>";
			defaultHighLightXML+="<DefaultHighLightBackColor>#ccffff</DefaultHighLightBackColor>";
			defaultHighLightXML+="<DefaultHighLightTextColor>#000000</DefaultHighLightTextColor>";
			defaultHighLightXML+="<Condition1From></Condition1From>";
			defaultHighLightXML+="<Condition1To></Condition1To>";
			defaultHighLightXML+="<Condition1BackColor></Condition1BackColor>";
			defaultHighLightXML+="<Condition1TextColor></Condition1TextColor>";
			defaultHighLightXML+="<Condition2From></Condition2From>";
			defaultHighLightXML+="<Condition2To></Condition2To>";
			defaultHighLightXML+="<Condition2BackColor></Condition2BackColor>";
			defaultHighLightXML+="<Condition2TextColor></Condition2TextColor>";
			defaultHighLightXML+="<Condition3From></Condition3From>";
			defaultHighLightXML+="<Condition3To></Condition3To>";
			defaultHighLightXML+="<Condition3BackColor></Condition3BackColor>";
			defaultHighLightXML+="<Condition3TextColor></Condition3TextColor>";
			defaultHighLightXML+="<Condition4From></Condition4From>";
			defaultHighLightXML+="<Condition4To></Condition4To>";
			defaultHighLightXML+="<Condition4BackColor></Condition4BackColor>";
			defaultHighLightXML+="<Condition4TextColor></Condition4TextColor>";
			defaultHighLightXML+="<Condition5From></Condition5From>";
			defaultHighLightXML+="<Condition5To></Condition5To>";
			defaultHighLightXML+="<Condition5BackColor></Condition5BackColor>";
			defaultHighLightXML+="<Condition5TextColor></Condition5TextColor>";
			defaultHighLightXML+="</HighLight>";
			defaultHighLightXML+="<Panel>";
			defaultHighLightXML+="<DefaultPanelBackColor>#ff0000</DefaultPanelBackColor>";
			defaultHighLightXML+="<DefaultPanelTextColor>#000000</DefaultPanelTextColor>";
			defaultHighLightXML+="<DefaultPanelOtherBackColor>#808080</DefaultPanelOtherBackColor>";
			defaultHighLightXML+="<DefaultPanelOtherTextColor>#000000</DefaultPanelOtherTextColor>";
			defaultHighLightXML+="<PanelGradeCount>10</PanelGradeCount>";
			defaultHighLightXML+="<PanelBackColor></PanelBackColor>";
			defaultHighLightXML+="<PanelTextColor></PanelTextColor>";
			defaultHighLightXML+="<PanelOtherBackColor></PanelOtherBackColor>";
			defaultHighLightXML+="<PanelOtherTextColor></PanelOtherTextColor>";
			defaultHighLightXML+="<PanelGradeColors></PanelGradeColors>";
			defaultHighLightXML+="<PanelMinValue></PanelMinValue>";
			defaultHighLightXML+="<PanelMaxValue></PanelMaxValue>";
			defaultHighLightXML+="<PanelOrder>Asc</PanelOrder>";
			defaultHighLightXML+="</Panel>";
			defaultHighLightXML+="</Measure>";
		}
		defaultHighLightXML+="</Measures>";
		defaultHighLightXML+="</ColorConfig>";


		report.setHighLightXML(defaultHighLightXML);
		highLightXML=defaultHighLightXML;

	}


	out.println("highLightXml.loadXML('" + replace(replace(highLightXML,"\n",""),"\r","") + "');");

	if("2".equals((String)report.getColorType())){//ハイライトモード
		out.println("var highLightFlg=true;");
	}else if("1".equals((String)report.getColorType())){//塗りつぶしモード
		out.println("var highLightFlg=false;");
//	}else{//塗りつぶしモード
//		out.println("var highLightFlg=false;");
	}

%>





	var measures = highLightXml.selectSingleNode("//Measures");

	var arrMesCondition1From = new Array();
	var arrMesCondition1To = new Array();
	var arrMesCondition1BackColor = new Array();
	var arrMesCondition1TextColor = new Array();
	var arrMesCondition2From = new Array();
	var arrMesCondition2To = new Array();
	var arrMesCondition2BackColor = new Array();
	var arrMesCondition2TextColor = new Array();
	var arrMesCondition3From = new Array();
	var arrMesCondition3To = new Array();
	var arrMesCondition3BackColor = new Array();
	var arrMesCondition3TextColor = new Array();
	var arrMesCondition4From = new Array();
	var arrMesCondition4To = new Array();
	var arrMesCondition4BackColor = new Array();
	var arrMesCondition4TextColor = new Array();
	var arrMesCondition5From = new Array();
	var arrMesCondition5To = new Array();
	var arrMesCondition5BackColor = new Array();
	var arrMesCondition5TextColor = new Array();

	var arrMesMinValue = new Array();
	var arrMesMaxValue = new Array();
	var arrMesPanelGradeCount = new Array();
	var arrMesGradeValue = new Array();
	var arrMesGradeColor = new Array();
	var arrMesOtherColor = new Array();
	var arrMesGradeTextColor = new Array();
	var arrMesOtherTextColor = new Array();

	for(m=0;m<measures.childNodes.length;m++){
		var tempMesSeq = measures.childNodes[m].getAttribute("id");

		arrMesCondition1From[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition1From").text);
		arrMesCondition1To[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition1To").text);
		arrMesCondition1BackColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition1BackColor").text;
		arrMesCondition1TextColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition1TextColor").text;
		arrMesCondition2From[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition2From").text);
		arrMesCondition2To[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition2To").text);
		arrMesCondition2BackColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition2BackColor").text;
		arrMesCondition2TextColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition2TextColor").text;
		arrMesCondition3From[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition3From").text);
		arrMesCondition3To[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition3To").text);
		arrMesCondition3BackColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition3BackColor").text;
		arrMesCondition3TextColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition3TextColor").text;
		arrMesCondition4From[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition4From").text);
		arrMesCondition4To[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition4To").text);
		arrMesCondition4BackColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition4BackColor").text;
		arrMesCondition4TextColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition4TextColor").text;
		arrMesCondition5From[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition5From").text);
		arrMesCondition5To[tempMesSeq] = parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition5To").text);
		arrMesCondition5BackColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition5BackColor").text;
		arrMesCondition5TextColor[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition5TextColor").text;

		arrMesMinValue[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMinValue").text;
		arrMesMaxValue[tempMesSeq] = highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMaxValue").text;
		arrMesPanelGradeCount[tempMesSeq] = parseInt(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelGradeCount").text);
		arrMesGradeValue[tempMesSeq] = new Array();
		for(j=0;j<arrMesPanelGradeCount[tempMesSeq];j++){
			arrMesGradeValue[tempMesSeq][j]=parseFloat(arrMesMinValue[tempMesSeq])+(((parseFloat(arrMesMaxValue[tempMesSeq])-parseFloat(arrMesMinValue[tempMesSeq]))/parseFloat(arrMesPanelGradeCount[tempMesSeq]))*j);
		}
		arrMesGradeValue[tempMesSeq][arrMesPanelGradeCount[tempMesSeq]]=arrMesMaxValue[tempMesSeq];
		arrMesGradeColor[tempMesSeq] = new Array();
		arrMesGradeColor[tempMesSeq]=(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelGradeColors").text).split(","); 
		arrMesGradeTextColor[tempMesSeq]=highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelTextColor").text;
		arrMesOtherColor[tempMesSeq]=highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelOtherBackColor").text;
		arrMesOtherTextColor[tempMesSeq]=highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelOtherTextColor").text;
	}


//	alert(highLightXml.xml);
		var valueXMLData = null;	// セルの値情報




		// 色設定を実行
		function initialize() {

			// データ情報XMLのパス
			var loadXMLPath = "Controller?action=getDataInfo";

			// 色設定を取得
			valueXMLData = new ActiveXObject("MSXML2.DOMDocument");
			valueXMLData.async = false;
			valueXMLData.setProperty("SelectionLanguage", "XPath");

			// セルデータ情報（XML）のロード
			var valueXMLResult = valueXMLData.load(loadXMLPath);

			// XML文書のロードに失敗
			if (!valueXMLResult) {

				// エラーメッセージを表示後、エラー画面を表示。
				showMessage("14", loadXMLPath);

				if(top.right_frm!=null) {
					top.right_frm.location.href="spread/error.jsp";
				} else {
					top.location.href="spread/error.jsp";
				}
		
			}


			// セルデータよりCellノードを取得
			var cellNodes = valueXMLData.selectNodes("/CellDataInfo/Cell");

			// レポートのデータテーブル
			var dataTable = parent.parent.display_area.dataTable;






			var cell = null;
			var colIndex = -1;
			var rowIndex = -1;
			for ( var i = 0; i < cellNodes.length; i++ ) {

				// 挿入対象セルの座標を取得
				cell = cellNodes[i];
				colIndex = parseInt(cell.selectSingleNode("Col/Index").text);
				rowIndex = parseInt(cell.selectSingleNode("Row/Index").text);

				// 挿入対象セルに値を挿入
				dataTable.rows[rowIndex].cells[colIndex].innerText = cell.selectSingleNode("Data/Value").text;

				//セルの色を初期化する
			//	dataTable.rows[rowIndex].cells[colIndex].style.backgroundColor="white";
			//	dataTable.rows[rowIndex].cells[colIndex].style.color="black";

				var cellMesSeq = cell.selectSingleNode("Data/MeasureSeq").text;
				var cellValue = parseFloat(cell.selectSingleNode("Data/Value2").text);


				if(highLightFlg){
					if(highLightXml.selectSingleNode("//Measure[@id='" + cellMesSeq + "']/Mode").text=="HighLight"){

						var backColor="";
						var textColor="";

						if((cellValue>=arrMesCondition1From[cellMesSeq])&&(cellValue<=arrMesCondition1To[cellMesSeq])){
							backColor = arrMesCondition1BackColor[cellMesSeq];
							textColor = arrMesCondition1TextColor[cellMesSeq];
						}else if((cellValue>=arrMesCondition2From[cellMesSeq])&&(cellValue<=arrMesCondition2To[cellMesSeq])){
							backColor = arrMesCondition2BackColor[cellMesSeq];
							textColor = arrMesCondition2TextColor[cellMesSeq];
						}else if((cellValue>=arrMesCondition3From[cellMesSeq])&&(cellValue<=arrMesCondition3To[cellMesSeq])){
							backColor = arrMesCondition3BackColor[cellMesSeq];
							textColor = arrMesCondition3TextColor[cellMesSeq];
						}else if((cellValue>=arrMesCondition4From[cellMesSeq])&&(cellValue<=arrMesCondition4To[cellMesSeq])){
							backColor = arrMesCondition4BackColor[cellMesSeq];
							textColor = arrMesCondition4TextColor[cellMesSeq];
						}else if((cellValue>=arrMesCondition5From[cellMesSeq])&&(cellValue<=arrMesCondition5To[cellMesSeq])){
							backColor = arrMesCondition5BackColor[cellMesSeq];
							textColor = arrMesCondition5TextColor[cellMesSeq];
						}else{
							if(dataTable.rows[rowIndex].cells[colIndex].orgBColor!=""){
								backColor = dataTable.rows[rowIndex].cells[colIndex].orgBColor;
							}else{
								backColor = defaultBColor;//デフォルトカラー
							}
							if(dataTable.rows[rowIndex].cells[colIndex].textColor!=""){
								textColor = dataTable.rows[rowIndex].cells[colIndex].textColor;
							}else{
								textColor = defaultTColor;//デフォルトカラー
							}

						}

						if(backColor!=""){
							dataTable.rows[rowIndex].cells[colIndex].style.backgroundColor=backColor;
							dataTable.rows[rowIndex].cells[colIndex].style.color=textColor;
						}


					}else if(highLightXml.selectSingleNode("//Measure[@id='" + cellMesSeq + "']/Mode").text=="Panel"){
						var arrColor=getColor(cellMesSeq,cellValue).split(","); 
				//	alert(arrColor[0]+","+arrColor[1]);
						dataTable.rows[rowIndex].cells[colIndex].style.backgroundColor=arrColor[0];
						dataTable.rows[rowIndex].cells[colIndex].style.color=arrColor[1];


					}else{

						dataTable.rows[rowIndex].cells[colIndex].style.backgroundColor=dataTable.rows[rowIndex].cells[colIndex].orgBColor;
						dataTable.rows[rowIndex].cells[colIndex].style.color=dataTable.rows[rowIndex].cells[colIndex].orgTColor;

					}

				}


			} // end for (全対象セルへの値の挿入処理完了)


			// =================================================================

			// グラフを更新
			var node = parent.parent.info_area.axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
			if ( (node.text == "1") || (node.text == "2") ) { // 1:全画面表示（グラフ）、2:縦分割（表、グラフ))
				parent.parent.display_area.reloadChart();
			}

			// ドリル終了処理
			parent.parent.display_area.finalyzeDrill();

			// Spreadテーブル部を表示する
			if ( parent.parent.display_area.spreadTable.style.visibility == 'hidden' ) {
				parent.parent.display_area.spreadTable.style.visibility='visible';
			}


			// ===== Spread表示完了状態を通知(イメージを停止)  =====
//			parent.parent.display_area.setLoadingStatus(false);


		}


		function getColor(mesSeq,cellValue){
			for(j=0;j<arrMesPanelGradeCount[mesSeq];j++){
				if((parseFloat(cellValue)>=parseFloat(arrMesGradeValue[mesSeq][j]))&&(parseFloat(cellValue)<=parseFloat(arrMesGradeValue[mesSeq][j+1]))){
					return arrMesGradeColor[mesSeq][j] + "," + arrMesGradeTextColor[mesSeq];
				}
				if(j==(arrMesPanelGradeCount[mesSeq]-1)){
					return arrMesOtherColor[mesSeq] + "," + arrMesOtherTextColor[mesSeq];
				}
			}
		}




	</script>

