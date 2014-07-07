<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "designer.XMLConverter"%>
<%@ include file="../../../connect.jsp" %>
<%
String Sql="";
String strOutput="";


%>
<html>
<head>
<title>ROLAPモデル新規作成ウィザード</title>
<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css">
<script language="JavaScript" src="../js/common.js"></script>
<script language="JavaScript">
function regist(){
//	document.form_main.action="create_model_regist.jsp?tp=0";
	document.form_main.action="create_model_regist.jsp";
	document.form_main.target="frm_hidden2";
	document.form_main.submit();
//	parent.opener.location.reload();
//	parent.self.window.close();
}

</script>
</head>
<body>
<form name="form_main" id="form_main" method="post" action="">

	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">
				ROLAPモデル新規作成（確認）
			</td>
		</tr>
	</table>
	<div style="margin:10;height:250">
		<div style="margin-left:3;margin-top:5;margin-bottom:5">以下のモデルを作成します。</div>
			<table class="standard" style="width:100%">
				<tr>
					<th class="standard">名前</th>
					<td class="standard"><%=session.getValue("name")%></td>
				</tr>
				<tr>
					<th class="standard">コネクトソースとユーザー</th>
					<td class="standard"><%=(String)session.getValue("RModelDsn")%>, <%=(String)session.getValue("RModelUserName")%></td>
				</tr>
				<tr>
					<th class="standard">スキーマ</th>
					<td class="standard"><%=session.getValue("schema")%></td>
				</tr>
		<%if("create_model_copy.jsp".equals((String)request.getParameter("fileName"))){%>
				<tr>
					<th class="standard">使用モデル</th>
					<td class="standard"><%=session.getValue("ref_model_name")%></td>
				</tr>
		<%}%>
		<%if("create_model_dimension.jsp".equals((String)request.getParameter("fileName"))){%>
				<tr>
					<th class="standard">使用メジャー</th>
					<td class="standard">
		<%

			if(!"".equals((String)session.getValue("ref_measures"))){
				Sql = "select name from oo_measure where measure_seq in (" + session.getValue("ref_measures") + ") order by measure_seq";
				rs = stmt.executeQuery(Sql);
				while (rs.next()) {
					if(!"".equals(strOutput)){strOutput+=",";}
					strOutput+=rs.getString("name");
				}
				rs.close();
				if("".equals(strOutput)){
					strOutput="　";
				}
			}else{
				strOutput="　";
			}
			out.println(strOutput);
		%>
					</td>
				</tr>
				<tr>
					<th class="standard">使用ディメンション</th>
					<td class="standard">
		<%
			strOutput="";
			if(!"".equals((String)session.getValue("ref_dimensions"))){
				Sql = "select name from oo_dimension where dimension_seq in (" + session.getValue("ref_dimensions") + ") order by dimension_seq";
				rs = stmt.executeQuery(Sql);
				while (rs.next()) {
					if(!"".equals(strOutput)){strOutput+=",";}
					strOutput+=rs.getString("name");
				}
				rs.close();
				if("".equals(strOutput)){
					strOutput="　";
				}
			}else{
				strOutput="　";
			}
			out.println(strOutput);
		%>
					</td>
				</tr>
		<%}%>
				<tr>
					<td colspan="2" style="height:15">　</td>
				</tr>
				<tr>
					<th class="standard" colspan="2">使用テーブル</th>
				</tr>
				<tr>
					<td class="standard" colspan="2">
		<%
			strOutput="";
			if("create_model_1.jsp".equals((String)request.getParameter("fileName"))){
				strOutput="　";
			}else{
				if("create_model_copy.jsp".equals((String)request.getParameter("fileName"))){
					Sql = "select model_xml from oo_r_model where model_seq = " + session.getValue("ref_model");
					rs = stmt.executeQuery(Sql);
					if (rs.next()) {
						String tempXML=rs.getString("model_xml");
						XMLConverter xmlCon = new XMLConverter();
						Document doc = xmlCon.toXMLDocument(tempXML);
						Element root = doc.getDocumentElement();
						NodeList list = root.getElementsByTagName("db_table");
						if(list.getLength()==0){
							strOutput="--";
						}
						for(int i=0;i<list.getLength();i++){
							Element rowElement = (Element)list.item(i);
							if(!"".equals(strOutput)){strOutput+=", ";}
							strOutput+=rowElement.getAttribute("name");
						}
					}
					rs.close();
				}else if("create_model_dimension.jsp".equals((String)request.getParameter("fileName"))){
					Sql = "";
					if(!"".equals((String)session.getValue("ref_dimensions"))){
						Sql += "select table_name as table_name from oo_dimension d,oo_level l where d.dimension_seq=l.dimension_seq and d.dimension_seq in (" + session.getValue("ref_dimensions") + ")";
					}
					if((!"".equals((String)session.getValue("ref_measures")))&&(!"".equals((String)session.getValue("ref_dimensions")))){
						Sql += " union ";
					}
					if(!"".equals((String)session.getValue("ref_measures"))){
						Sql += "select fact_table as table_name from oo_measure where measure_seq in (" + session.getValue("ref_measures") + ")";
						Sql += " union ";
						Sql += "select d.table_name as table_name from oo_level d,oo_measure_link m where d.dimension_seq=m.dimension_seq and m.measure_seq in (" + session.getValue("ref_measures") + ")";
					}
					rs = stmt.executeQuery(Sql);
					while (rs.next()) {
						if(!"".equals(strOutput)){strOutput+=",";}
						strOutput+=rs.getString("table_name");
					}
					rs.close();
				}
			}
		//	session.putValue("ref_tables",strOutput);
			out.println(strOutput);
		%>
					</td>
				</tr>



			</table>

		</div>

		<div style="text-align:right;padding-right:20px;padding-top:8px;margin-top:15px;border-top:1 solid #CCCCCC">
			<input type="button" value="" onclick="parent.window.close();" class="normal_cancel_mini" onMouseOver="className='over_cancel_mini'" onMouseDown="className='down_cancel_mini'" onMouseUp="className='up_cancel_mini'" onMouseOut="className='out_cancel_mini'">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" value="" onclick="movePage('<%=request.getParameter("fileName")%>');" class="normal_back_mini" onMouseOver="className='over_back_mini'" onMouseDown="className='down_back_mini'" onMouseUp="className='up_back_mini'" onMouseOut="className='out_back_mini'">
			<input type="button" value="" onclick="regist()" class="normal_finish" onMouseOver="className='over_finish'" onMouseDown="className='down_finish'" onMouseUp="className='up_finish'" onMouseOut="className='out_finish'">
		</div>

		<input type="hidden" name="tp" value="0">


</form>
</body>
</html>