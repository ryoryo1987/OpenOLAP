<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*"%>
<%@ include file="../../connect.jsp" %>



<html>

<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/common.css">
	<link type="text/css" rel="stylesheet" href="../css/tree.css"/>

	<script language="JavaScript">

		var openerFrame = window.dialogArguments;


		function startDrag(arg){
			// get what is being dragged:
			srcObj = window.event.srcElement;

			// store the source of the object into a string acting as a dummy object so we don't ruin the original object:
			dummyObj = srcObj.outerHTML;

			// post the data for Windows:
			var dragData = window.event.dataTransfer;

			// set the type of data for the clipboard:
			dragData.setData('Text', arg);

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


		function outputName(arg){
			document.form_main.are_filter.value+=arg;
		}


		function clickButton(arg){
			document.form_main.are_filter.value+=arg;
		}




		var openerWhereClauseObj;
		if(openerFrame.document.form_main.txt_where_clause!=undefined){//ディメンション
			openerWhereClauseObj=openerFrame.document.form_main.txt_where_clause;
		}else if(openerFrame.document.form_main.txt_where_clause==undefined){//メジャー
			openerWhereClauseObj=openerFrame.document.form_main.txt_fact_where_clause;
		}

		function ok(){
			openerWhereClauseObj.value=document.form_main.are_filter.value;
			parent.window.close();
		}

		function load(){

			var XMLData = new ActiveXObject("MSXML2.DOMDocument");
			var objXSL = new ActiveXObject("MSXML2.DOMDocument");

			XMLData.async = false;
			objXSL.async = false;

			var strXML="";
<%
			String tableName = request.getParameter("tableName");

			String Sql="";
			Sql += " SELECT";
			Sql += " oo_fun_columnList('" + tableName + "','" + session.getValue("strUserName") + "') AS columnlist";
			rs = stmt.executeQuery(Sql);
			out.println("strXML+='<Cube>"+tableName+"';");
			while(rs.next()){
				StringTokenizer st = new StringTokenizer(rs.getString("columnlist"),",");
				while(st.hasMoreTokens()) {
					String columnText = st.nextToken();
					StringTokenizer st2 = new StringTokenizer(columnText," ");
					String columnName = st2.nextToken();
					out.println("strXML+='<Measure TABLE=\\'" + tableName + "\\' ID=\\'" + columnName + "\\'>" + columnName + "</Measure>';");
				}
			}
			rs.close();
			out.println("strXML+='</Cube>';");
%>

			XMLData.loadXML(strXML);
			var xsltLoadResult = objXSL.load("filter_tree.xsl");
//	alert(XMLData.transformNode(objXSL));
			document.all.div_column_list.innerHTML=XMLData.transformNode(objXSL);








			document.form_main.are_filter.value=openerWhereClauseObj.value;
		}

	</script>
</head>

<body onload="load()">

<form name="form_main" id="form_main" method="post" action="">
	<!-- レイアウト用 -->
	<div class="main" id="dv_main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left"></td>
			<td class="main" style="text-align:left">
			
 				<!-- コンテンツ -->
				<!-- **************************  MAIN TABLE <1>***************************** -->
				<table>
					<tr>
						<td valign="top" width="200" style="padding-left:5px;background-color:white;" >
							<div id="div_column_list"></div>
<!--
							<iframe src="filter_tree.jsp?tableName=<%=request.getParameter("tableName")%>" width="200" height="100%">aaaa</iframe>
-->


						</td>
						<td height="100%">条件式<br>
							<textarea name="are_filter" cols="90" rows="20" mON="条件式"></textarea>
							<table>
								<tr>
									<td>
										<img src="../../images/button/con_equal.gif" ondragstart='startDrag("=")' onclick='clickButton("=")' alt="="/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_not.gif" ondragstart='startDrag("<>")' onclick='clickButton("<>")' alt="<>"/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_lessthan.gif" ondragstart='startDrag("<")' onclick='clickButton("<")' alt="<"/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_greater_than.gif" ondragstart='startDrag(">")' onclick='clickButton(">")' alt=">"/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_lessthanequal.gif" ondragstart='startDrag("<=")' onclick='clickButton("<=")' alt="<="/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_greaterthanequal.gif" ondragstart='startDrag(">=")' onclick='clickButton(">=")' alt=">="/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_plus.gif" ondragstart='startDrag("+")' onclick='clickButton("+")' alt="+"/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_minus.gif" ondragstart='startDrag("-")' onclick='clickButton("-")' alt="-"/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_asterisk.gif" ondragstart='startDrag("*")' onclick='clickButton("*")' alt="*"/>
										&nbsp;&nbsp;
										<img src="../../images/button/con_slash.gif" ondragstart='startDrag("/")' onclick='clickButton("/")' alt="/"/>
										&nbsp;&nbsp;
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>



				<div class="command">
				<!-- **************************  更新 ボタン ***************************** -->
					<input type="button" name="ok_btn" value="" onClick="ok()" class="normal_ok" onMouseOver="className='over_ok'" onMouseDown="className='down_ok'" onMouseUp="className='up_ok'" onMouseOut="className='out_ok'">
					<input type="button" name="cancel_btn" value="" onClick="javascript:parent.window.close()" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
				</div>

			</td>
			<td class="right"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="bottom"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
	</div>



</form>

</body>
</html>


