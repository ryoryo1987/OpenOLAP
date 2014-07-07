<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "designer.XMLConverter"%>
<%@ include file="../../../connect.jsp"%>
<%@ include file="../../../connect_rmodel.jsp"%>

<%!

	public static String replace(String strTarget, String strOldStr, String strOldNew){
	    String strSplit[];
	    String strResult;

	    strSplit = split(strTarget, strOldStr);
	    strResult = strSplit[0];
	    for (int i = 1; i < strSplit.length; i ++){
	        strResult += strOldNew + strSplit[i];
	    }

	    return strResult;
	}
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

<%



String Sql="";
String strModelName="";
String strModelFlg="";
String strModelModelType="";
String strModelSchema="";
String strModelRefMeasures="";
String strModelRefDimensions="";
String strModelXML="";

Sql="";
Sql = Sql + "SELECT";
Sql = Sql + " model_seq";
Sql = Sql + ",name";
Sql = Sql + ",schema";
Sql = Sql + ",model_flg";
//Sql = Sql + ",model_type";
//Sql = Sql + ",ref_model";
//Sql = Sql + ",ref_measures";
//Sql = Sql + ",ref_dimensions";
//Sql = Sql + ",ref_tables";
Sql = Sql + ",model_xml";
Sql = Sql + ",last_update";
Sql = Sql + " FROM oo_r_model";
Sql = Sql + " WHERE model_seq = " + session.getValue("modelSeq");



rs = stmt.executeQuery(Sql);
if(rs.next()){
	strModelName=rs.getString("name");
	strModelSchema=rs.getString("schema");
	strModelFlg=rs.getString("model_flg");
//	strModelModelType=rs.getString("model_type");
//	strModelRefMeasures=rs.getString("ref_measures");
//	strModelRefDimensions=rs.getString("ref_dimensions");
	strModelXML=rs.getString("model_xml");

}
rs.close();


if("0".equals(strModelFlg)){//初期状態内部設定情報の読み込み
	XMLConverter xmlCon = new XMLConverter();
	Document doc = xmlCon.toXMLDocument(strModelXML);
	if(xmlCon.selectSingleNode(doc,"//modelType").hasChildNodes()){
		strModelModelType = xmlCon.selectSingleNode(doc,"//modelType").getFirstChild().getNodeValue();
	}
	if(xmlCon.selectSingleNode(doc,"//refMeasures").hasChildNodes()){
		strModelRefMeasures = xmlCon.selectSingleNode(doc,"//refMeasures").getFirstChild().getNodeValue();
	}
	if(xmlCon.selectSingleNode(doc,"//refDimensions").hasChildNodes()){
		strModelRefDimensions = xmlCon.selectSingleNode(doc,"//refDimensions").getFirstChild().getNodeValue();
	}

}


String strTables="";
String strJoins="";
String preTableName="";
String preKeyCol1="";
String preKeyCol2="";
String preKeyCol3="";
String preKeyCol4="";
String preKeyCol5="";




if("0".equals(strModelFlg)&&(strModelModelType.equals("2"))){//ディメンション・メジャー参照モデル 新規作成の場合
	String tempTableNames="";
//	if(!"".equals(strModelRefDimensions)){
	//ディメンション
	Sql="";
	Sql = Sql + "SELECT";
	Sql = Sql + " l.table_name";
	Sql = Sql + ",l.level_no";
	Sql = Sql + ",l.key_col1";
	Sql = Sql + ",l.key_col2";
	Sql = Sql + ",l.key_col3";
	Sql = Sql + ",l.key_col4";
	Sql = Sql + ",l.key_col5";
	Sql = Sql + ",l.link_col1";
	Sql = Sql + ",l.link_col2";
	Sql = Sql + ",l.link_col3";
	Sql = Sql + ",l.link_col4";
	Sql = Sql + ",l.link_col5";
	Sql = Sql + " FROM oo_dimension d,oo_level l";
	Sql = Sql + " WHERE d.dimension_seq=l.dimension_seq";
	Sql = Sql + " AND (";
	if(!"".equals(strModelRefDimensions)){
		Sql = Sql + " d.dimension_seq in (" + strModelRefDimensions + ")";
	}
	if((!"".equals(strModelRefDimensions))&&(!"".equals(strModelRefMeasures))){
		Sql = Sql + " OR ";
	}
	if(!"".equals(strModelRefMeasures)){
		Sql = Sql + " d.dimension_seq in (select dimension_seq from oo_measure_link where measure_seq in (" + strModelRefMeasures + "))";
	}
	Sql = Sql + " )";
	Sql = Sql + " ORDER BY d.dimension_seq,l.level_no";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){

		if(tempTableNames.indexOf("--"+rs.getString("table_name")+"--")==-1){//同じテーブルは一度しか出さないようにチェック（メジャーに同じテーブル複数存在する場合）

			strTables+="		<db_table name=\"" + rs.getString("table_name") + "\" table_type=\"dim\">";
			strTables+="			<position>";
			strTables+="				<left>0</left>";
			strTables+="				<top>0</top>";
			strTables+="				<height>200</height>";
			strTables+="				<width>170</width>";
			strTables+="			</position>";
			strTables+="			<physical_model>";

			Sql="";
			Sql += " SELECT";
			Sql += " oo_fun_columnList('" + rs.getString("table_name") + "','" + strModelSchema + "') AS columnlist";
			rs2 = stmt2.executeQuery(Sql);
			while(rs2.next()){
				StringTokenizer st = new StringTokenizer(rs2.getString("columnlist"),",");
				while(st.hasMoreTokens()) {
					String columnText = st.nextToken();
					StringTokenizer st2 = new StringTokenizer(columnText," ");
					String columnName = st2.nextToken();

					strTables+="				<column id=\"" + columnName + "\">";
					strTables+="					<name>" + columnName + "</name>";
					strTables+="					<type>" + columnText + "</type>";
					strTables+="				</column>";

				}
			}
			rs2.close();

			strTables+="			</physical_model>";
			strTables+="			<logical_model name=\"" + rs.getString("table_name") + "\">";
			strTables+="				<select_clause id=\"select\">";
			strTables+="				</select_clause>";
			strTables+="				<where_clause id=\"where\">";
			strTables+="				</where_clause>";
			strTables+="			</logical_model>";
			strTables+="		</db_table>";

			if(!rs.getString("level_no").equals("1")){
				strJoins+="		<join id=\"" + preTableName + "," + rs.getString("table_name") + "\">";
				strJoins+="			<table1 tablename=\"" + preTableName + "\" count=\"plural\">";
				if(!"".equals(rs.getString("link_col1"))){
					strJoins+="				<join_column>" + preKeyCol1 + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col2"))){
					strJoins+="				<join_column>" + preKeyCol2 + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col3"))){
					strJoins+="				<join_column>" + preKeyCol3 + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col4"))){
					strJoins+="				<join_column>" + preKeyCol4 + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col5"))){
					strJoins+="				<join_column>" + preKeyCol5 + "</join_column>";
				}
				strJoins+="			</table1>";
				strJoins+="			<table2 tablename=\"" + rs.getString("table_name") + "\" count=\"plural\">";
				if(!"".equals(rs.getString("link_col1"))){
					strJoins+="				<join_column>" + rs.getString("link_col1") + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col2"))){
					strJoins+="				<join_column>" + rs.getString("link_col2") + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col3"))){
					strJoins+="				<join_column>" + rs.getString("link_col3") + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col4"))){
					strJoins+="				<join_column>" + rs.getString("link_col4") + "</join_column>";
				}
				if(!"".equals(rs.getString("link_col5"))){
					strJoins+="				<join_column>" + rs.getString("link_col5") + "</join_column>";
				}
				strJoins+="			</table2>";
				strJoins+="		</join>";
			}
			preTableName=rs.getString("table_name");
			preKeyCol1=rs.getString("key_col1");
			preKeyCol2=rs.getString("key_col2");
			preKeyCol3=rs.getString("key_col3");
			preKeyCol4=rs.getString("key_col4");
			preKeyCol5=rs.getString("key_col5");

		}
		tempTableNames+="--"+rs.getString("table_name")+"--";


	}
	rs.close();

//	}


	//メジャー  
	Sql="";
	Sql = Sql + "SELECT";
	Sql = Sql + " m.measure_seq";
	Sql = Sql + ",m.fact_table as table_name";
	Sql = Sql + " FROM oo_measure m";
	if("".equals(strModelRefMeasures)){
		Sql = Sql + " WHERE 1=2";
	}else{
		Sql = Sql + " WHERE m.measure_seq in (" + strModelRefMeasures + ")";
	}
	Sql = Sql + " ORDER BY 1";



	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		String tempTables="";
		tempTables+="		<db_table name=\"" + rs.getString("table_name") + "\" table_type=\"fact\">";
		tempTables+="			<position>";
		tempTables+="				<left>0</left>";
		tempTables+="				<top>0</top>";
		tempTables+="				<height>200</height>";
		tempTables+="				<width>170</width>";
		tempTables+="			</position>";
		tempTables+="			<physical_model>";

		Sql="";
		Sql += " SELECT";
		Sql += " oo_fun_columnList('" + rs.getString("table_name") + "','" + strModelSchema + "') AS columnlist";
		rs2 = stmt2.executeQuery(Sql);
		while(rs2.next()){
			StringTokenizer st = new StringTokenizer(rs2.getString("columnlist"),",");
			while(st.hasMoreTokens()) {
				String columnText = st.nextToken();
				StringTokenizer st2 = new StringTokenizer(columnText," ");
				String columnName = st2.nextToken();

				tempTables+="				<column id=\"" + columnName + "\">";
				tempTables+="					<name>" + columnName + "</name>";
				tempTables+="					<type>" + columnText + "</type>";
				tempTables+="				</column>";

			}
		}
		rs2.close();

		tempTables+="			</physical_model>";
		tempTables+="			<logical_model name=\"" + rs.getString("table_name") + "\">";
		tempTables+="				<select_clause id=\"select\">";
		tempTables+="				</select_clause>";
		tempTables+="				<where_clause id=\"where\">";
		tempTables+="				</where_clause>";
		tempTables+="			</logical_model>";
		tempTables+="		</db_table>";

		if(strTables.indexOf("<db_table name=\"" + rs.getString("table_name") + "\"")==-1){//既に定義されているテーブルは省く
			strTables+=tempTables;
		}



		//マッピング

		String Sql2 = "(";
		Sql2 += " select l.dimension_seq||'-'||max(l.level_no)";
		Sql2 += " from";
		Sql2 += " oo_measure_link m";
		Sql2 += " ,oo_level l";
		Sql2 += " where m.dimension_seq=l.dimension_seq";
		Sql2 += " and m.measure_seq = " + rs.getString("measure_seq");
		Sql2 += " group by l.dimension_seq";
		Sql2 += ")";

		Sql="";
		Sql += " SELECT";
		Sql += " l.table_name";
		Sql += ",l.key_col1";
		Sql += ",l.key_col2";
		Sql += ",l.key_col3";
		Sql += ",l.key_col4";
		Sql += ",l.key_col5";
		Sql += ",m.fact_link_col1";
		Sql += ",m.fact_link_col2";
		Sql += ",m.fact_link_col3";
		Sql += ",m.fact_link_col4";
		Sql += ",m.fact_link_col5";
		Sql += " FROM oo_measure_link m,oo_level l";
		Sql += " WHERE m.dimension_seq = l.dimension_seq";
		Sql += " AND m.measure_seq = " + rs.getString("measure_seq");
		Sql += " AND l.dimension_seq||'-'||l.level_no in " + Sql2;

		rs2 = stmt2.executeQuery(Sql);
		while(rs2.next()){

			String tempJoins="";


			tempJoins+="		<join id=\"" + rs2.getString("table_name") + "," + rs.getString("table_name") + "\">";
			tempJoins+="			<table1 tablename=\"" + rs2.getString("table_name") + "\" count=\"plural\">";
			if(!"".equals(rs2.getString("fact_link_col1"))){
				tempJoins+="				<join_column>" + rs2.getString("key_col1") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col2"))){
				tempJoins+="				<join_column>" + rs2.getString("key_col2") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col3"))){
				tempJoins+="				<join_column>" + rs2.getString("key_col3") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col4"))){
				tempJoins+="				<join_column>" + rs2.getString("key_col4") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col5"))){
				tempJoins+="				<join_column>" + rs2.getString("key_col5") + "</join_column>";
			}
			tempJoins+="			</table1>";
			tempJoins+="			<table2 tablename=\"" + rs.getString("table_name") + "\" count=\"plural\">";
			if(!"".equals(rs2.getString("fact_link_col1"))){
				tempJoins+="				<join_column>" + rs2.getString("fact_link_col1") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col2"))){
				tempJoins+="				<join_column>" + rs2.getString("fact_link_col2") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col3"))){
				tempJoins+="				<join_column>" + rs2.getString("fact_link_col3") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col4"))){
				tempJoins+="				<join_column>" + rs2.getString("fact_link_col4") + "</join_column>";
			}
			if(!"".equals(rs2.getString("fact_link_col5"))){
				tempJoins+="				<join_column>" + rs2.getString("fact_link_col5") + "</join_column>";
			}
			tempJoins+="			</table2>";
			tempJoins+="		</join>";


			if((strJoins.indexOf("<join id=\"" + rs2.getString("table_name") + "," + rs.getString("table_name") + "\">")==-1)&&(strJoins.indexOf("<join id=\"" + rs.getString("table_name") + "," + rs2.getString("table_name") + "\">")==-1)){//既に定義されているマッピングは省く
				strJoins+=tempJoins;
			}

		}
		rs2.close();




	}
	rs.close();

}
%>



<html xmlns:v="urn:schemas-microsoft-com:vml"> 
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css">
<title>VML</title>
	<style>
	v\:* { behavior: url(#default#VML); }
	* { 
		font-style:Arial 'MS UI Gothic';
		font-size:12px;
	}
	.divObj{
		position:absolute;
	}
	.selectedDivObj{
		position:absolute;
	}

	.rectTitle{
		OVERFLOW: hidden;
		TEXT-OVERFLOW: ellipsis;
		VERTICAL-ALIGN: middle;
		font-size:10px;
		white-space:nowrap;
		cursor:hand;
		width:150;
		height:10;
	}
	.imgTitle{
		position:relative;
		top:2;
		left:2;
		width:10;
		height:10;
	}
	.divContents{
		position:absolute;
		top:20;
		left:-1;
	}

	.imgContents{
/*		background-image:url(co.png);*/
		background-repeat:no-repeat;
		position:relative;
		top:0;
		left:0;
		width:30;
		height:20
	}


	.GamenText{
		position:relative;top:10;left:10;
		overflow:auto;
		font-size:20px;
		width:100;
		height:50;
	}
	</style>

	<style>
		/********************* ディメンションオブジェクト、ファクトオブジェクト *********************/
		.dim_title_left,.fact_title_left
		{
			width:24;
			height:20;
			display:inline;
		}

		.dim_title_left
		{
			background:url('../../images/dim_title_left.gif') no-repeat;
		}

		.fact_title_left
		{
			background:url('../../images/fact_title_left.gif') no-repeat;
		}

		.dim_title_name,.fact_title_name
		{
			height:20;
			display:inline;
			font-weight:bold;
			color:white;
			padding-top:3;
			padding-left:1;
		}

		.dim_title_name
		{
			background:url('../../images/dim_title_name.gif') repeat-x;
		}

		.fact_title_name
		{
			background:url('../../images/fact_title_name.gif') repeat-x;
		}


		.dim_title_right,.fact_title_right
		{
			display:inline;
			width:6;
			height:20;
		}

		.dim_title_right
		{
			background:url('../../images/dim_title_right.gif') no-repeat;
		}

		.fact_title_right
		{
			background:url('../../images/fact_title_right.gif') no-repeat;
		}

		.dim_contents_frame,.fact_contents_frame
		{
			display:inline;
			width:3;
			height:100%;
		}

		.dim_contents_frame
		{
			background:url('../../images/dim_contents_frame.gif') repeat-y;
		}

		.fact_contents_frame
		{
			background:url('../../images/fact_contents_frame.gif') repeat-y;
		}

		.dim_contents_center_bgcolor
		{
			filter:progid:DXImageTransform.Microsoft.Gradient(startColorStr='#ffffff', endColorStr='#A3D6F3', gradientType='0');
		}

		.fact_contents_center_bgcolor
		{
			filter:progid:DXImageTransform.Microsoft.Gradient(startColorStr='#ffffff', endColorStr='#F4A4B1', gradientType='0');
		}

		.dim_contents_center_bgimage
		{
			width:100%;
			background:url('../../images/dim_contents_bg.gif') no-repeat;
			background-position: right bottom

		}

		.fact_contents_center_bgimage
		{
			width:100%;
			background:url('../../images/fact_contents_bg.gif') no-repeat;
			background-position: right bottom
		}

		.dim_contents_center,.fact_contents_center
		{
			overflow:auto;
			display:inline;
			vertical-align:top;
			padding:10;
		}

		.contents_row
		{
			padding-top:2;
		}

		.dim_footer_left,.fact_footer_left
		{
			display:inline;
			width:9;
			height:13;
		}

		.dim_footer_left
		{
			background:url('../../images/dim_footer_left.gif') no-repeat;
		}

		.fact_footer_left
		{
			background:url('../../images/fact_footer_left.gif') no-repeat;
		}

		.dim_footer_center,.fact_footer_center
		{
			display:inline;
			height:13;
		}

		.dim_footer_center
		{
			background:url('../../images/dim_footer_center.gif') repeat-x;
		}

		.fact_footer_center
		{
			background:url('../../images/fact_footer_center.gif') repeat-x;
		}

		.dim_footer_right,.fact_footer_right
		{
			display:inline;
			width:13;
			height:13;
		}

		.dim_footer_right
		{
			background:url('../../images/dim_footer_right.gif') no-repeat;
		}

		.fact_footer_right
		{
			background:url('../../images/fact_footer_right.gif') no-repeat;
		}


	</style>


<script language="JavaScript" src="../js/chart.js"></script>

<script language="JavaScript">




	var XMLDom = new ActiveXObject("MSXML2.DOMDocument");
	XMLDom.setProperty("SelectionLanguage", "XPath");

	XMLDom.async = false;
	var strXml='<?xml version="1.0" encoding="Shift_JIS" ?>';
	strXml+="<RDBModel name='<%=strModelName%>'>";
	strXml+="	<db_tables>";
<%
	if(!"".equals(strTables)){
		out.println("strXml+='" + strTables + "';");
	}
%>	strXml+="	</db_tables>";
	strXml+="	<joins>";
<%
	if(!"".equals(strJoins)){
		out.println("strXml+='" + strJoins + "';");
	}
%>

	strXml+="	</joins>";
	strXml+="";
	strXml+="</RDBModel>";

<%

	if("1".equals(strModelFlg)){//すでにモデリングされている場合（更新およびモデルコピー作成時）
	//	String tempXML=(String)session.getValue("tempChartXML");
		String tempXML=strModelXML;

		XMLConverter xmlCon = new XMLConverter();
		Document doc = xmlCon.toXMLDocument(tempXML);
		
		Element root = doc.getDocumentElement();
		NodeList list = root.getElementsByTagName("Table");

		for(int i=0;i<list.getLength();i++){

			Element rowElement = (Element)list.item(i);
			String tableName = rowElement.getAttribute("name");


			xmlCon.selectSingleNode(doc,"//db_table[@name='" + tableName + "']").removeChild(xmlCon.selectSingleNode(doc,"//db_table[@name='" + tableName + "']/physical_model"));
			Node physicalModelNode = (Node)doc.createElement("physical_model");

			String tempString="<physical_model>";

			String schemaName=(String)session.getValue("RModelSchema");


			Sql="";
			Sql += " SELECT";
			Sql += " oo_fun_columnList('" + tableName + "','" + schemaName + "') AS columnlist";
			rsRModel2 = stmtRModel.executeQuery(Sql);
			while(rsRModel2.next()){
				StringTokenizer st = new StringTokenizer(rsRModel2.getString("columnlist"),",");
				while(st.hasMoreTokens()) {
					String columnText = st.nextToken();
					StringTokenizer st2 = new StringTokenizer(columnText," ");
					String columnName = st2.nextToken();
/*
					tempString+="<column id='" + columnName + "'>";
					tempString+="<name>" + columnName + "</name>";
					tempString+="<type>" + columnText + "</type>";
					tempString+="</column>";
*/

				//	Element element = doc.createElement("column");
				//	element.setAttribute("id", columnName);
				//	Node columnNode = doc.appendChild(element);/////////

					Node columnNode = (Node)doc.createElement("column");

 				//	columnNode.setAttribute("id",columnName);
					Attr att = doc.createAttribute("id");
					att.setNodeValue(columnName);
					columnNode.getAttributes().setNamedItem(att);



					physicalModelNode.appendChild(columnNode);


					Node nameNode = (Node)doc.createElement("name");
					nameNode.appendChild(doc.createTextNode(columnName));
					Node typeNode = (Node)doc.createElement("type");
					typeNode.appendChild(doc.createTextNode(columnText));
					columnNode.appendChild(nameNode);
					columnNode.appendChild(typeNode);



				}
			}
			rsRModel2.close();




			xmlCon.selectSingleNode(doc,"//db_table[@name='" + tableName + "']").insertBefore(physicalModelNode,xmlCon.selectSingleNode(doc,"//db_table[@name='" + tableName + "']/logical_model"));


		}


		tempXML=xmlCon.toXMLText(doc);


		out.println("strXml=\"" + replace(replace(replace(tempXML,"\n",""),"\r",""),"\"","'") + "\";");

	}
%>
	XMLDom.loadXML(strXml);





function load(){
	//db_tableDiv作成
	for(i=0;i<XMLDom.selectSingleNode("//db_tables").childNodes.length;i++){
//	alert(XMLDom.selectSingleNode("//db_tables").childNodes[i].xml);
		var arrColumnName = new Array();
		for(j=0;j<XMLDom.selectSingleNode("//db_tables").childNodes[i].childNodes[1].childNodes.length;j++){
		//	alert(XMLDom.selectSingleNode("//db_tables").childNodes[i].childNodes[1].childNodes[j].firstChild.xml)
			arrColumnName[j]=XMLDom.selectSingleNode("//db_tables").childNodes[i].childNodes[1].childNodes[j].firstChild.xml;
		}
		displayTable(XMLDom.selectSingleNode("//db_tables").childNodes[i].getAttribute("name"),arrColumnName);
	}



	//joinマッピング作成
	for(i=0;i<XMLDom.selectSingleNode("//joins").childNodes.length;i++){
//	alert(document.all.lineSource.childNodes[i].outerHTML);
		var table1name = XMLDom.selectSingleNode("//joins").childNodes[i].childNodes[0].getAttribute("tablename");
		var table2name = XMLDom.selectSingleNode("//joins").childNodes[i].childNodes[1].getAttribute("tablename");
//	alert(table1name + "," + table2name);
		makeLine(getTableDiv(table1name).childNodes[1],getTableDiv(table2name).childNodes[1]);
	}



	mappingCheck();




}


function checkVacantPixel(pixX,pixY){

	if((pixX==0)&&(pixY==0)){
		return false;
	}else{
		for(x=0;x<document.all.allObjDiv.childNodes.length;x++){
			if((document.all.allObjDiv.childNodes[x].style.pixelLeft==pixX)&&(document.all.allObjDiv.childNodes[x].style.pixelTop==pixY)){
				return false;
			}
		}
	}
	return true;
}


function getVacantPixel(){
	var tempX=0;
	var tempY=0;
	while(checkVacantPixel(tempX,tempY)==false){
		tempX+=60;
		tempY+=30;
	}
	return tempX+","+tempY;
}




function getTableDiv(tableName){
	for(t=0;t<document.all.allObjDiv.childNodes.length;t++){
		if(document.all.allObjDiv.childNodes[t].tablename==tableName){
			return document.all.allObjDiv.childNodes[t];
		}
	}
}

function getTableId(tableName){
	for(t=0;t<document.all.allObjDiv.childNodes.length;t++){
		if(document.all.allObjDiv.childNodes[t].tablename==tableName){
			return document.all.allObjDiv.childNodes[t].childNodes[1].id;
		}
	}
}





var divId=0;

function displayTable(tableName,arrColumnName){

	var tableType=XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']").getAttribute("table_type");

	var pix_x=XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/left").text;
	var pix_y=XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/top").text;

	if((pix_x=="0")&&(pix_y=="0")){
		var tempArr = new Array();
		tempArr = getVacantPixel().split(",");
		pix_x=tempArr[0];
		pix_y=tempArr[1];
	}

	var strDiv="";
/*
	strDiv+="<div class='divObj' id='obj" + divId + "' tablename='" + tableName + "' selectedflg='0' style='top:" + pix_y + ";left:" + pix_x + ";'>";
	strDiv+="	<div id='T" + divId + "' kind='title' onDblClick='openTableInfo(this)'>";
	strDiv+="		<div class='dim_title_name'  style='width:" + XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/width").text + ";' >" + tableName + "</div>";
	strDiv+="	</div>";
	strDiv+="	<div class='divContents' id='C" + divId + "' kind='contents'>";
	strDiv+="		<v:rect class='rectContents' onmouseover='mouseOver(this)' onmousedown='resizemousedown(this)' style='width:" + XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/width").text + ";height:" + XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/height").text + ";'>";
	strDiv+="			<v:stroke opacity='0.2' />";
	strDiv+="			<v:fill type='gradient' color='red' color2='white' opacity='0.2' />";
	strDiv+="			<div class='imgContents'></div>";
	strDiv+="			<div class='divContentsText' style='overflow:hidden;width:100%;height:100%;margin-right:20;margin-bottom:10;'>";
	for(k=0;k<arrColumnName.length;k++){
		strDiv+=arrColumnName[k] + "<br>";
	}
	strDiv+="			</div>";
	strDiv+="		</v:rect >";
	strDiv+="	</div>";
	strDiv+="	<div></div>";
	strDiv+="</div>";
*/


	var width=XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/width").text;
	var height=XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/height").text;
	var div_title_name=width-30;
	var div_contents_center=width-6;
	var div_footer_center=width-22;
	var divContents_height=height-33;
	strDiv+="<div class='divObj' id='obj" + divId + "' divId='" + divId + "' tablename='" + tableName + "' selectedflg='0' style='top:" + pix_y + ";left:" + pix_x + ";width:" + width + ";height:" + height + ";'>";
	strDiv+="	<div id='T" + divId + "' kind='title' onDblClick='openTableInfo(this)'>";
	strDiv+="<span class='" + tableType + "_title_left' id='div_title_left" + divId + "'></span>";
	strDiv+="<span class='" + tableType + "_title_name' id='div_title_name" + divId + "' style='cursor:hand;width:" + div_title_name + ";overflow-x:hidden;' >" + tableName + "</span>";
	strDiv+="<span class='" + tableType + "_title_right' id='div_title_right" + divId + "'></span>";
	strDiv+="	</div>";
	strDiv+="	<div class='" + tableType + "_contents_center_bgcolor' id='C" + divId + "' kind='contents' style='cursor:crosshair;width:" + width + ";background-Color:white;'>";
	strDiv+="		<div class='" + tableType + "_contents_center_bgimage' id='div_contents_center_bgimage" + divId + "' kind='contents' objectid='C" + divId + "'>";
	strDiv+="			<div id='divContents" + divId + "' style='width:100%;height:" + divContents_height + ";overflow:hidden;' kind='contents' objectid='C" + divId + "'>";
	strDiv+="				<div class='" + tableType + "_contents_frame' id='div_contents_frame1_" + divId + "' kind='contents' objectid='C" + divId + "'></div>";
	strDiv+="				<div class='" + tableType + "_contents_center' id='div_contents_center" + divId + "' style='width:" + div_contents_center + "' kind='contents' objectid='C" + divId + "'>";

//	strDiv+="					<div class='contents_row'>prod_id（製品コード）</div>";
//	strDiv+="					<div class='contents_row'>long_name（ロングネーム）</div>";
//	strDiv+="					<div class='contents_row'>short_name（ショートネーム）</div>";

//	strDiv+="					<div class='divContentsText' style='overflow:hidden;width:100%;margin-right:20;margin-bottom:10;'>";
//	for(k=0;k<arrColumnName.length;k++){
//		strDiv+=arrColumnName[k] + "<br>";
//	}
//	strDiv+="					</div>";

	for(k=0;k<arrColumnName.length;k++){
		strDiv+="<div class='contents_row' kind='contents' objectid='C" + divId + "'>" + arrColumnName[k] + "</div>";
	}


	strDiv+="				</div>";
	strDiv+="				<div class='" + tableType + "_contents_frame' id='div_contents_frame2_" + divId + "' kind='contents' objectid='C" + divId + "'></div>";
	strDiv+="			</div>";
	strDiv+="			<div>";
	strDiv+="				<div class='" + tableType + "_footer_left' id='div_footer_left" + divId + "'></div>";
	strDiv+="				<div class='" + tableType + "_footer_center' id='div_footer_center" + divId + "' style='width:" + div_footer_center + "'></div>";
	strDiv+="				<div class='" + tableType + "_footer_right' id='div_footer_right" + divId + "' onmouseover='javascript:this.style.cursor=\"nw-resize\";' onmousedown='resizemousedown(this)'></div>";
	strDiv+="			</div>";
	strDiv+="		</div>";
	strDiv+="	</div>";
	strDiv+="	<div></div>";
	strDiv+="</div>";
	strDiv+="";
	strDiv+="";
	strDiv+="";












//	alert(strDiv);
	document.all.allObjDiv.innerHTML+=strDiv;


	document.all("obj" + divId).childNodes[0].style.filter="Alpha(style=0,opacity=50)";
	document.all("obj" + divId).childNodes[1].style.filter="Alpha(style=0,opacity=50)";

//	changeDivColor('fact',document.all("obj" + divId));

	divId++;





}



function changeDivColor(divType,divObj){
	var tempDivId=divObj.divId;
	document.all("div_title_left"+tempDivId).className=divType+"_title_left";
	document.all("div_title_name"+tempDivId).className=divType+"_title_name";
	document.all("div_title_right"+tempDivId).className=divType+"_title_right";
	document.all("C"+tempDivId).className=divType+"_contents_center_bgcolor";
	document.all("div_contents_center_bgimage"+tempDivId).className=divType+"_contents_center_bgimage";
	document.all("div_contents_frame1_"+tempDivId).className=divType+"_contents_frame";
	document.all("div_contents_center"+tempDivId).className=divType+"_contents_center";
	document.all("div_contents_frame2_"+tempDivId).className=divType+"_contents_frame";
	document.all("div_footer_left"+tempDivId).className=divType+"_footer_left";
	document.all("div_footer_center"+tempDivId).className=divType+"_footer_center";
	document.all("div_footer_right"+tempDivId).className=divType+"_footer_right";
}




function addJoinToDom(tableName1,tableName2){
	var tempObj1 = XMLDom.selectSingleNode("//join[@id='" + tableName1 + "," + tableName2 + "']");
	var tempObj2 = XMLDom.selectSingleNode("//join[@id='" + tableName2 + "," + tableName1 + "']");
	if(!((tempObj1==null)&&(tempObj2==null))){
		return;//既にDOMにある場合は処理を行わない
	}

	var strJoin="";
	strJoin+="<join id='" + tableName1 + "," + tableName2 + "'>";
	strJoin+="<table1 tablename='" + tableName1 + "' count='plural'>";
	strJoin+="</table1>";
	strJoin+="<table2 tablename='" + tableName2 + "' count='plural'>";
	strJoin+="</table2>";
	strJoin+="</join>";

	var addXMLDom = new ActiveXObject("MSXML2.DOMDocument");
	addXMLDom.async = false;
	addXMLDom.loadXML(strJoin);
	XMLDom.selectSingleNode("//joins").appendChild(addXMLDom.selectSingleNode("//"));
//	alert(XMLDom.selectSingleNode("//joins").xml);

}


function editMapping(lineObj){

	var arrId=lineObj.id.split(",");
	var tableName1=document.getElementById(arrId[0]).parentNode.tablename;
	var tableName2=document.getElementById(arrId[1]).parentNode.tablename;
//	newWin = window.open("chart_line.jsp?objId=" + lineObj.id + "&tableName1=" + tableName1 + "&tableName2=" + tableName2 ,"_blank","menubar=no,toolbar=no,width=600px,height=400px,resizable");
	window.showModalDialog("chart_line.jsp?objId=" + lineObj.id + "&tableName1=" + tableName1 + "&tableName2=" + tableName2,self,"dialogHeight:450px; dialogWidth:630px;");

}



function mouseOver(obj){

	if(((obj.offsetWidth-event.offsetX)<=10)&&((obj.offsetHeight-event.offsetY)<=10)){
		obj.style.cursor="nw-resize";
	}else{
		obj.style.cursor="crosshair";
	}
}


var resizeObj = null;
var resizeFlg = false;
var resizeSaX = null;
var resizeSaY = null;
//var resizeFromX = null;
//var resizeFromY = null;
function resizemousedown(obj){
//	if(((obj.offsetWidth-event.offsetX)<=10)&&((obj.offsetHeight-event.offsetY)<=10)){
		resizeObj=obj.parentNode.parentNode.parentNode.parentNode;
		resizeFlg=true;
		resizeSaX=(obj.offsetWidth-event.offsetX);
		resizeSaY=(obj.offsetHeight-event.offsetY);
//	}else{
//		resizeFlg=false;
//	}
}


function resizemousemove(){
	if(resizeFlg){




		mydrag=false;





		var tempWidth=event.clientX - (resizeObj.style.pixelLeft + resizeSaX);
		var tempHeight=event.clientY - (resizeObj.style.pixelTop + resizeSaY);


		if((tempWidth<100)||(tempHeight<100)){
			return;
		}


		mydrag=false;


		resizeObj.style.width = tempWidth;
		resizeObj.style.height = tempHeight;

		var tempDivId=resizeObj.divId;
		document.all("obj"+tempDivId).style.width=tempWidth;
		document.all("obj"+tempDivId).style.height=tempHeight;
		document.all("C"+tempDivId).style.width=tempWidth;
		document.all("divContents"+tempDivId).style.height=tempHeight-33;
		document.all("div_title_name"+tempDivId).style.width=tempWidth-30;
		document.all("div_contents_center"+tempDivId).style.width=tempWidth-6;
		document.all("div_footer_center"+tempDivId).style.width=tempWidth-22;

	//	changeWindowSize(resizeObj,(event.clientX - (resizeObj.style.pixelLeft + resizeSaX)),(event.clientY - (resizeObj.style.pixelTop + resizeSaY)))
	}
}

function changeWindowSize(divWindowObj,x,y){
	divWindowObj.style.width = x;
	divWindowObj.style.height = y;
	//	divWindowObj.childNodes[0].childNodes[1].style.width = x-57;//52=左上と右上部分の横幅計
	//	divWindowObj.childNodes[2].childNodes[1].style.width = x-72;//72=左下と右下部分の横幅計
//	divWindowObj.childNodes[0].childNodes[1].style.width = Math.max(x-57,0);//52=左上と右上部分の横幅計
//	divWindowObj.childNodes[2].childNodes[1].style.width = Math.max(x-72,0);//72=左下と右下部分の横幅計
//	divWindowObj.childNodes[1].style.height = Math.max(y-52,0);
}



function resizemouseup(){

	if(resizeFlg){

		setSelectedLine(resizeObj);//線も選択

		//連なる線も移動する。
		if(selectedLineName!=""){
			var moveLineName=selectedLineName.split("-");
			for(var i=0;i<moveLineName.length;i++){
				if(linkPosition[moveLineName[i]]=="from"){
					autoLineChart(linkJibun[moveLineName[i]],linkAite[moveLineName[i]]);
				}else if(linkPosition[moveLineName[i]]=="to"){
					autoLineChart(linkAite[moveLineName[i]],linkJibun[moveLineName[i]]);
				}
				linkLine[moveLineName[i]].from=from_x + "," + from_y;
				linkLine[moveLineName[i]].to=to_x + "," + to_y;
			}
		}

		selectedLineName="";
		allRelease();

	}



	resizeFlg=false;





}




//オブジェクト削除
function del(){
//	alert('del');
	for(var ob=0;ob<document.all.length;ob++){
	var obj=document.all(ob);
	if(obj.selectedflg=='1'){
//	alert(obj.tagName);
//		if(obj.style.filter=="invert()"){
			if(obj.tagName=="line"){
				deleteLine(obj);
			}else if(obj.tagName=="DIV"){//テーブルの削除

				//オブジェクトにひもづく線を削除
				var tempLength=obj.lastChild.childNodes.length;
				for(j=0;j<tempLength;j++){
					if(obj.lastChild.childNodes.length==0){break;}
					var arr = obj.lastChild.childNodes[j].id.split(',');//ひとつづつ子供が消えていくので、常にノード番号は「0」となる
					deleteLine(document.getElementById(arr[1]+","+arr[2]));
					j--;
				}
				//DOMから削除
				var tableName=obj.tablename;
				XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']").parentNode.removeChild(XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']"));
			//	obj.parentNode.removeChild(obj);
			//	alert(XMLDom.xml);
				deleteTable(obj);
			}
//		}
		ob=0;//一度にひもづくオブジェクトがいくつ消えるかわからないので繰り返しチェックするようにしている
	}
	}
}




function deleteTable(delObj){
//	if(delObj!=undefined){
		delObj.parentNode.removeChild(delObj);
//	}
}
function deleteLine(delObj){
	//db_tableにあるライン情報を削除
//	alert("f," + delObj.id);
//	alert(document.getElementById("f," + delObj.id));
//	alert(document.getElementById("f," + delObj.id).parentNode);

	var tableName1=document.getElementById("f," + delObj.id).parentNode.parentNode.tablename;
	var tableName2=document.getElementById("t," + delObj.id).parentNode.parentNode.tablename;

	document.getElementById("f," + delObj.id).parentNode.removeChild(document.getElementById("f," + delObj.id));
	document.getElementById("t," + delObj.id).parentNode.removeChild(document.getElementById("t," + delObj.id));
	//ラインを削除
	delObj.parentNode.removeChild(delObj);

//alert(XMLDom.selectSingleNode("//joins").xml);
	XMLDom.selectSingleNode("//join[@id='" + tableName1 + ","+ tableName2 + "']").parentNode.removeChild(XMLDom.selectSingleNode("//join[@id='" + tableName1 + ","+ tableName2 + "']"));
//alert(XMLDom.selectSingleNode("//joins").xml);

}



function mappingCheck(){
	for(l=0;l<document.all.lineSource.childNodes.length;l++){
		if(document.all.lineSource.childNodes[l].id!="dashline"){
			document.all.lineSource.childNodes[l].firstChild.dashstyle="dash";
		}
	}


	for(m=0;m<XMLDom.selectSingleNode("//joins").childNodes.length;m++){
		var arrTableName=XMLDom.selectSingleNode("//joins").childNodes[m].getAttribute("id").split(",");
		if(XMLDom.selectSingleNode("//joins").childNodes[m].firstChild.childNodes.length!=0){
			var tempLineId;
			tempLineId = getTableId(arrTableName[0]) + "," + getTableId(arrTableName[1]);
			if(document.getElementById(tempLineId)!=undefined){
				document.getElementById(tempLineId).firstChild.dashstyle="solid";
			}
			tempLineId = getTableId(arrTableName[1]) + "," + getTableId(arrTableName[0]);
			if(document.getElementById(tempLineId)!=undefined){
				document.getElementById(tempLineId).firstChild.dashstyle="solid";
			}
		}
	}

}


</script>
</head>


<body onload="load()" kind='body' onselectstart="return false;" onmousemove='resizemousemove();mymousemove();' onmouseup='resizemouseup();mymouseup();' onmousedown='mymousedown()' style="background-color:#F4FCF1">
<div style="position:absolute;top:0;width=7;height:1000;left:0;background-color:white">
</div>


<div id='allObjDiv' style="position:absolute;top:0;left:0">


</div>

<div name='lineSource' id='lineSource' style='position:absolute;top:0;left0;z-index:99;'>
	<v:line name='dashline' id='dashline' style='position:absolute;' from='0,0' to='0,0' strokecolor='blue' strokeweight='1pt'/>
</div>


<div name='selectRectSource' id='selectRectSource' style='position:absolute;top:0;left0;z-index:99;'>
	<v:rect name='selectRect' id='selectRect' style='position:absolute;top:-100;left:-100;width:10;height:10;' strokecolor='blue' strokeweight='1pt' flip='x'>
		<v:fill color="blue" opacity='0.1' />
	</v:rect>
</div>

<form name="form_main" id="form_main" method="post" action="">
</form>



</body>
</html>

