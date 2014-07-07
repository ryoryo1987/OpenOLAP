<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%//@ include file="../../connect.jsp" %>
<%//@ include file="../connect.jsp" %>
<%
request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない


%>


<HTML>
<HEAD>
<title>OpenOLAP Model Designer</title>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<link rel="stylesheet" type="text/css" href="../css/spreadStyle.css">
<link rel="stylesheet" type="text/css" href="../css/dimList.css">
<link rel="stylesheet" type="text/css" href="../css/rightclick.css"/>
<link rel="stylesheet" type="text/css" href="../css/tree.css"/>
<script type="text/javascript" src="../js/spread.js"></script>
<script type="text/javascript" src="../js/colRange.js"></script>
<%
String objSeq = (String)session.getValue("objSeq");
if(!(("1".equals(session.getValue("dimType")))&&("1".equals(objSeq)))){
%>
<script type="text/javascript" src="../js/tableRightclick.js"></script>
</HEAD>
<BODY id="SpreadBody" onload="loadSpread();createMenu();" onselectstart="return false" onresize="resizeArea()" onContextmenu="return false" ondrop="return false" ondragenter="return false" ondragover="return false" topmargin="0" leftmargin="0">
<%}else{%>
</HEAD>
<BODY id="SpreadBody" onload="loadSpread();" onselectstart="return false" onresize="resizeArea()" onContextmenu="return false" ondrop="return false" ondragenter="return false" ondragover="return false" topmargin="0" leftmargin="0">
<%}%>

<FORM name="SpreadForm" method="post" action="">
<SPAN onmousedown="mouseDown();" onmouseup="mouseUp();">
<TABLE id="SpreadTable" class="SpreadTable">
<TR>
<TD>
<SPAN id="ColumnHeaderArea" onmousemove="mouseMove();">
<TABLE class="ColumnHeaderTable" cellspacing="0" cellpadding="2">
<COLGROUP id="CH_CG">
<COL id="CH_CG0" style="width:150;">
<COL id="CH_CG1" style="width:30;">
<COL id="CH_CG2" style="width:50;">
<COL id="CH_CG3" style="width:150;">
<%if("2".equals(session.getValue("dimType"))){%>
<%if("1".equals(session.getValue("strSegDataType"))){%>
<COL id="CH_CG4" style="width:100;">
<COL id="CH_CG5" style="width:100;">
<%}else if("2".equals(session.getValue("strSegDataType"))){%>
<COL id="CH_CG4" style="width:100;">
<%}%>
<%}%>
<COL width="80">
</COLGROUP>
<TR ID="CH_R0" Spread="ColumnHeaderRow">
<TD id="CH_R0C0">ショートネーム</TD>
<TD id="CH_R0C1">キー</TD>
<TD id="CH_R0C2">コード</TD>
<TD id="CH_R0C3">ロングネーム</TD>
<%if("2".equals(session.getValue("dimType"))){%>
<%if("1".equals(session.getValue("strSegDataType"))){%>
<TD id="CH_R0C4">最小値</TD>
<TD id="CH_R0C5">最大値</TD>
<%}else if("2".equals(session.getValue("strSegDataType"))){%>
<TD id="CH_R0C4">LIKE</TD>
<%}%>
<%}%>
<TD style="border:none;" class="adjustCell"></TD>
</TR>
</TABLE></SPAN></TD>
</TR>
<TR>
<TD>
<DIV id="DataTableArea">
<TABLE id="DataTable" cellspacing="0" cellpadding="2">
<COLGROUP>
<COL id="DT_CG0" style="width:150;">
<COL id="DT_CG1" style="width:30;">
<COL id="DT_CG2" style="width:50;">
<COL id="DT_CG3" style="width:150;">
<%if("2".equals(session.getValue("dimType"))){%>
<%if("1".equals(session.getValue("strSegDataType"))){%>
<COL id="DT_CG4" style="width:100;">
<COL id="DT_CG5" style="width:100;">
<%}else if("2".equals(session.getValue("strSegDataType"))){%>
<COL id="DT_CG4" style="width:100;">
<%}%>
<%}%>
</COLGROUP>


<%
Connection connMeta = null;
Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
ResultSet rs = null;
ResultSet rs2 = null;
ResultSet rs3 = null;
connMeta = (Connection)session.getValue(session.getId()+"Conn");
stmt     = (Statement) session.getValue(session.getId()+"Stmt");
stmt2     = (Statement) session.getValue(session.getId()+"Stmt2");
stmt3     = (Statement) session.getValue(session.getId()+"Stmt3");
String dimSeq = (String)session.getValue("dimSeq");


	String keyStr = request.getParameter("id");
	String SQL ="";

	int maxLevel=0;
	SQL = "SELECT max(level_no) as maxLevel FROM oo_level WHERE dimension_seq = " + dimSeq;
	rs = stmt.executeQuery(SQL);
	if(rs.next()) {
		maxLevel=rs.getInt("maxLevel");
	}
	rs.close();

	String sortType="1";
	String sortOrder="1";
	String strSort="";
	SQL = "SELECT sort_type,sort_order FROM oo_dimension WHERE dimension_seq = " + dimSeq;
	rs = stmt.executeQuery(SQL);
	if(rs.next()) {
		sortType=rs.getString("sort_type");
		sortOrder=rs.getString("sort_order");
	}
	rs.close();

	if(sortType.equals("1")){
		strSort="sort_col";
	}else if(sortType.equals("2")){
		strSort="to_number(sort_col,'S999999999999999999999999999999.9999999999')";
	}
	if(sortOrder.equals("1")){
		strSort+=" asc";
	}else if(sortOrder.equals("2")){
		strSort+=" desc";
	}


	SQL = 		" select ";
	SQL = SQL + " replace(replace(replace(key,'&','&amp;'),'<','&lt;'),'>','&gt;') AS key,replace(replace(replace(code,'&','&amp;'),'<','&lt;'),'>','&gt;') AS code,replace(replace(replace(short_name,'&','&amp;'),'<','&lt;'),'>','&gt;') AS short_name,replace(replace(replace(long_name,'&','&amp;'),'<','&lt;'),'>','&gt;') AS long_name,replace(min_val,'.00','') AS min_val,replace(max_val,'.00','') AS max_val,calc_text,org_level,CASE WHEN org_level = " + maxLevel + " THEN 'F' WHEN org_level = 0 THEN 'V' ELSE 'D' END AS kind";
	SQL = SQL + " from " + session.getValue("CustomTableName") + "";

	if (keyStr.equals("root")) {
		SQL = SQL + " where par_key is null ";
	} else {
		SQL = SQL + " where par_key= " + keyStr;
	}
//	SQL = SQL + " order by sort_col";
//	SQL = SQL + " ORDER BY CASE WHEN org_level = " + maxLevel + " THEN 3 WHEN org_level = 0 THEN 2 ELSE 1 END,sort_col";
	SQL = SQL + " ORDER BY CASE WHEN org_level = " + maxLevel + " THEN 3 WHEN org_level = 0 THEN 2 ELSE 1 END,"+strSort;
	rs = stmt.executeQuery(SQL);
//	out.println("<TABLE border='1'>");
//		out.println("<TR onmouseover='onColumnHeaderCellVLine()'><TH><NOBR>キー</NOBR></TH><TH><NOBR>コード</NOBR></TH><TH><NOBR>ロングネーム</NOBR></TH><TH><NOBR>ショートネーム</NOBR></TH></TR>");
//finvert.style.filter="Invert";



	//クローンバーチャルフォルダ
	out.println("<TR id='clone' kind='V' selectflg='0' style='display:none;'>");
	out.println("<TD><nobr><IMG SRC='../../images/VirtualFolder2.gif'/><A href='javascript:return false;' onclick='objClick(this);return false;' ondragstart='JavaScript:startDrag()' ondragend='JavaScript:endDrag();' ondrop='JavaScript:drop();'  ondragover='JavaScript:overDrag();' ondragleave='JavaScript:leaveDrag();' ondragenter='JavaScript:enterDrag();' ondblclick='JavaScript:dblclickClickNode(this);'></A></nobr></TD>");
	out.println("<TD><nobr></nobr></TD>");
	out.println("<TD><nobr></nobr></TD>");
	out.println("<TD><nobr></nobr></TD>");
	if("2".equals(session.getValue("dimType"))){
		if("1".equals(session.getValue("strSegDataType"))){
			out.println("<TD><nobr></nobr></TD>");
			out.println("<TD><nobr></nobr></TD>");
		}else if("2".equals(session.getValue("strSegDataType"))){
			out.println("<TD><nobr></nobr></TD>");
		}
	}
	out.println("</TR>");

	while(rs.next()) {

		if(!(("2".equals(session.getValue("dimType")))&&(!("V".equals(rs.getString("kind")))))){

			String imgKind="";
			if ((rs.getString("kind")).equals("F")) {
				imgKind = "../../images/file.gif";
			} else if ((rs.getString("kind")).equals("V")) {
				imgKind = "../../images/VirtualFolder2.gif";
			} else {
				imgKind = "../../images/foldericon2.gif";
			}

		//	out.println("<BR>"+rs.getString("code") + "," + rs.getString("short_name") + "," + rs.getString("long_name"));
			out.println("<TR id='"+rs.getString("key")+"' kind='"+rs.getString("kind")+"' selectflg='0'>");
	//		out.println("<TD selectflg='0' onclick='objClick(this)' ondragstart='JavaScript:startDrag()' ondragend='JavaScript:endDrag();' ondrop='JavaScript:drop();'  ondragover='JavaScript:overDrag();' ondragleave='JavaScript:leaveDrag();' ondragenter='JavaScript:enterDrag();' ondblclick='JavaScript:dblclickClickNode(this);'><IMG SRC='" + imgKind + "' onmouseover='this.style.cursor=\"hand\"'/> "+rs.getString("short_name")+"</nobr></TD>");

			if(("1".equals(session.getValue("dimType")))&&("1".equals(objSeq))){
				out.println("<TD><nobr><IMG SRC='" + imgKind + "'/><A href='javascript:return false;' onclick='objClick(this);return false;' ondblclick='JavaScript:dblclickClickNode(this);'>"+rs.getString("short_name")+"</A></nobr></TD>");
			}else{
				out.println("<TD><nobr><IMG SRC='" + imgKind + "'/><A href='javascript:return false;' onclick='objClick(this);return false;' ondragstart='JavaScript:startDrag()' ondragend='JavaScript:endDrag();' ondrop='JavaScript:drop();'  ondragover='JavaScript:overDrag();' ondragleave='JavaScript:leaveDrag();' ondragenter='JavaScript:enterDrag();' ondblclick='JavaScript:dblclickClickNode(this);'>"+rs.getString("short_name")+"</A></nobr></TD>");
			}
			out.println("<TD><nobr>"+rs.getString("key")+"</nobr></TD>");
			out.println("<TD><nobr>"+rs.getString("code")+"</nobr></TD>");
			out.println("<TD><nobr>"+rs.getString("long_name")+"</nobr></TD>");
			if("2".equals(session.getValue("dimType"))){
				if("1".equals(session.getValue("strSegDataType"))){
					out.println("<TD><nobr>"+rs.getString("min_val")+"</nobr></TD>");
					out.println("<TD><nobr>"+rs.getString("max_val")+"</nobr></TD>");
				}else if("2".equals(session.getValue("strSegDataType"))){
					out.println("<TD><nobr>"+rs.getString("calc_text")+"</nobr></TD>");
				}

			}

			out.println("</TR>");

		}

	}
	rs.close();
//	out.println("</TABLE>");


%>

</TABLE>
</DIV>
</TD>
</TR>
</TABLE></SPAN>

<input type="hidden" name="hid_par_key" value="<%=keyStr%>"/>
<input type="hidden" name="hid_delete_key" value="<%=keyStr%>"/>
</FORM>
</BODY>
</HTML>

<script language="JavaScript">



function dblclickClickNode(obj){

	var DataTable = document.getElementById("DataTable");
	var nodeId = DataTable.rows[obj.parentNode.parentNode.parentNode.rowIndex].id;

//	if (th.att=="F"){//Fileだったら、何もしない。
//		return;
//	}

	var preClickObj;
	var preClickAhref;
	preClickObj=parent.navi_frm.getpreClickObj();

	if (preClickObj.lastChild.style.display=='none'){
		parent.navi_frm.reversePreNextImage(preClickObj);
		parent.navi_frm.reversePM(preClickObj);
		parent.navi_frm.reverseDisplay(preClickObj);
	}
	for(i=0;i<preClickObj.lastChild.childNodes.length;i++){
		if(preClickObj.lastChild.childNodes[i].id==nodeId){
			parent.navi_frm.Toggle('f',preClickObj.lastChild.childNodes[i].lastChild.previousSibling.previousSibling,'cust_dim_tree_table.jsp?id='+nodeId);
			return;
		}
	}
}


var srcObj = new Object;

// string to hold source of object being dragged:
var dummyObj;
var dragData;

function startDrag(){
//alert(	window.event.srcElement.tagName);
	window.event.srcElement.parentNode.parentNode.parentNode.selectflg="1";
	window.event.srcElement.style.backgroundColor="#33CC00";
	window.event.srcElement.style.color="white";

	parent.navi_frm.strDragStart = "TABLE_FRAME";


	var strSelectedKey="";

	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			if(strSelectedKey!=""){
				strSelectedKey+=",";
			}
			strSelectedKey+=DataTable.rows[i].id;
		}
	}
//alert(strSelectedKey);
    // get what is being dragged:
//    srcObj = window.event.srcElement;

    // store the source of the object into a string acting as a dummy object so we don't ruin the original object:
//    dummyObj = srcObj.outerHTML;

    // post the data for Windows:
    dragData = window.event.dataTransfer;


    // set the type of data for the clipboard:
    dragData.setData('Text', strSelectedKey);

    // allow only dragging that involves moving the object:
    dragData.effectAllowed = 'linkMove';

    // use the special 'move' cursor when dragging:
    dragData.dropEffect = 'move';
}



function enterDrag() {
    window.event.dataTransfer.getData('Text');
}

function endDrag() {
    window.event.dataTransfer.clearData();
}

function overDrag() {
}
function leaveDrag() {
}
function drop() {
}






var lastSelectRow;
function objClick(obj){
	if(!window.event.ctrlKey){
		resetRow();
	}
	if(window.event.shiftKey){
		var DataTable = document.getElementById("DataTable");
		for(i=lastSelectRow;i<=obj.parentNode.parentNode.parentNode.rowIndex;i++){
			DataTable.rows[i].selectflg="1";
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.backgroundColor="#33CC00";
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.color="white";
		}
		for(i=obj.parentNode.parentNode.parentNode.rowIndex;i<=lastSelectRow;i++){
			DataTable.rows[i].selectflg="1";
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.backgroundColor="#33CC00";
			DataTable.rows[i].cells[0].firstChild.childNodes[1].style.color="white";
		}
	}else{
		obj.parentNode.parentNode.parentNode.selectflg="1";
		obj.style.backgroundColor="#33CC00";
		obj.style.color="white";
	}
	lastSelectRow=obj.parentNode.parentNode.parentNode.rowIndex;

}


function resetRow(){
	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		DataTable.rows[i].selectflg="0";
		DataTable.rows[i].cells[0].firstChild.childNodes[1].style.backgroundColor="white";
		DataTable.rows[i].cells[0].firstChild.childNodes[1].style.color="black";
	}
}
</script>
