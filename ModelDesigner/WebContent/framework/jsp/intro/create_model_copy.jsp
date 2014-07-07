<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "designer.XMLConverter"%>
<%@ include file="../../../connect.jsp" %>

<html>
<head>
<title>ROLAPモデル新規作成ウィザード</title>
<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css"><script language="JavaScript" src="../js/common.js"></script>
<script language="JavaScript">

	function load(){
		if(document.form_main.rdo_model==undefined){
			document.form_main.btn_next.style.display="none";
		}
	}


	function clickRdo(obj){
		document.form_main.model_name.value=obj.modelname;
		document.form_main.action="create_model_hidden.jsp";
		document.form_main.target="frm_hidden2";
		document.form_main.submit();
	}
	

	function modelCheck(){
		var radio_flg=false;

		if(document.form_main.rdo_model.length==undefined){
			if(document.form_main.rdo_model.checked){
				radio_flg=true;
			}
		}else{
			for(i=0;i<document.form_main.rdo_model.length;i++){
				if(document.form_main.rdo_model[i].checked){
					radio_flg=true;
					document.form_main.modelSeq.value=document.form_main.rdo_model[i].id.replace("rdo_model_","");
				}
			}
		}
		return radio_flg;
	}


	function next(){
		var radio_flg=false;
		for(i=0;i<document.form_main.rdo_model.length;i++){
			if(document.form_main.rdo_model[i].checked){
				radio_flg=true;
			}
		}
		if(!modelCheck()){
			alert("コピー元となる既存モデルを選択してください。 ");
			return;
		}
		movePage('create_model_confirm.jsp');
	}


</script>
</head>
<body onload="load()">
<form name="form_main" id="form_main" method="post" action="">

	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">
				ROLAPモデル新規作成（既存モデルのコピー）
			</td>
		</tr>
	</table>

	<div style="margin:10;height:250">
		<div style="margin-left:3;margin-top:5;margin-bottom:5">コピー元となる既存モデルを選択してください。</div>
		<table class="standard" style="width:100%">
		<tr>
			<th class="standard" style="width:30">選択</td>
			<th class="standard">名前</td>
			<th class="standard">スキーマ</td>
			<th class="standard">使用テーブル</td>
		</tr>
	<%
		String Sql;

		boolean modelExistFlg=false;

			Sql = "select model_seq,name,schema,model_xml,last_update from oo_r_model where schema = '" + (String)session.getValue("schema") + "' order by model_seq";
			rs = stmt.executeQuery(Sql);
			while (rs.next()) {
				modelExistFlg=true;

				String strTables="";
				String tempXML=rs.getString("model_xml");
				XMLConverter xmlCon = new XMLConverter();
				Document doc = xmlCon.toXMLDocument(tempXML);
				Element root = doc.getDocumentElement();
				NodeList list = root.getElementsByTagName("db_table");
				if(list.getLength()==0){
					strTables="モデル未設定";
				}
				for(int i=0;i<list.getLength();i++){
					Element rowElement = (Element)list.item(i);
					if(!"".equals(strTables)){strTables+=", ";}
					strTables+=rowElement.getAttribute("name");
				}

				out.println("<tr>");
				String tempStr="";
				if(rs.getString("model_seq").equals((String)session.getValue("ref_model"))){tempStr="checked";}
				out.println("<td class='standard' align='center'><input type='radio' name='rdo_model' value='" + rs.getString("model_seq") + "' onclick='clickRdo(this)' modelname='" + rs.getString("name") + "' " + tempStr + "></td>");
				out.println("<td class='standard' style='white-space:normal'>" + rs.getString("name") + "</td>");
				out.println("<td class='standard'>" + rs.getString("schema") + "</td>");
		//		out.println("<td class='standard'>" + rs.getString("ref_tables") + "</td>");
				out.println("<td class='standard' style='white-space:normal'>" + strTables + "</td>");
				out.println("</tr>");
			}
			rs.close();


		%>

		</table>

		</div>

		<div style="text-align:right;padding-right:20px;padding-top:8px;margin-top:15px;border-top:1 solid #CCCCCC">
			<input type="button" value="" onclick="parent.window.close();" class="normal_cancel_mini" onMouseOver="className='over_cancel_mini'" onMouseDown="className='down_cancel_mini'" onMouseUp="className='up_cancel_mini'" onMouseOut="className='out_cancel_mini'">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" value="" onclick="movePage('create_model_1.jsp')" class="normal_back_mini" onMouseOver="className='over_back_mini'" onMouseDown="className='down_back_mini'" onMouseUp="className='up_back_mini'" onMouseOut="className='out_back_mini'">
			<input type="button" name="btn_next" value="" onclick="next()" class="normal_next" onMouseOver="className='over_next'" onMouseDown="className='down_next'" onMouseUp="className='up_next'" onMouseOut="className='out_next'">
		</div>

		<input type="hidden" id="fileName" name="fileName" value="create_model_copy.jsp">
		<input type="hidden" id="model_name" name="model_name" value="">
		<input type="hidden" name="modelSeq" value="">

</form>
</body>
</html>