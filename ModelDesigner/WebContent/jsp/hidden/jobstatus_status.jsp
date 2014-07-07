<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<%@ page errorPage="ErrorPage.jsp"%>

<%@ include file="../../connect.jsp" %>

<%
String tp = request.getParameter("tp");

String Sql="";
int exeCount=0;
int i=0;


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
<!--
	function load(){
//alert("load");
		var strTable="";
		strTable+='<div align="left"><b>実行リスト</b></div>';
		strTable+='<table name="tbl_status" id="tbl_status" class="standard" style="width:475">';
		strTable+='<tr>';
		strTable+='<th class="standard">ジョブ</th>';
		strTable+='<th class="standard" width="100">ステータス</th>';
		strTable+='<th class="standard" width="50">&nbsp;</th>';
		strTable+='</tr>';
<%
String strSeq = "";
String strName = "";
String strStatus="";
String strButton="";

boolean executingFlg = false;


Sql = "SELECT ";
Sql = Sql + "j.job_seq";
Sql = Sql + ",c.cube_seq||':'||c.name||' (プロセス '||j.process||')' AS name";
Sql = Sql + ",j.status";
Sql = Sql + ",j.stop_flg";
Sql = Sql + " FROM oo_job j";
Sql = Sql + " ,oo_cube c";
Sql = Sql + " WHERE j.cube_seq=c.cube_seq";
Sql = Sql + " AND j.status<>'5'";
Sql = Sql + " AND j.session_id='" + session.getValue("session_getId") + "'";
Sql = Sql + " AND (j.job_seq >= " + (String)session.getValue("strFromJobSeq") + " OR j.status='1')";
//Sql = Sql + " AND j.job_seq > " + (String)session.getValue("strFromJobSeq");
Sql = Sql + " ORDER BY j.job_seq";
rs = stmt.executeQuery(Sql);
while(rs.next()){
		i++;
		strSeq = rs.getString("job_seq");
		strName = rs.getString("name");
		if(("1".equals(rs.getString("status")))&&("1".equals(rs.getString("stop_flg")))){
			strStatus="中断中";
			strButton="&nbsp;";
			executingFlg = true;
		}else if("1".equals(rs.getString("status"))){
			strStatus="実行中";
			strButton="<input type=\"button\" value=\"中止\" onclick=\"delJob(" + strSeq + ")\">";
			executingFlg = true;
		}else if("9".equals(rs.getString("status"))){
			strStatus="待機";
			strButton="<input type=\"button\" value=\"削除\" onclick=\"delJob(" + strSeq + ")\">";
			executingFlg = true;
		}else if("0".equals(rs.getString("status"))){
			strStatus="終了";
			strButton="&nbsp;";
		}

%>
		strTable+='<tr id="<%=strSeq%>">';
		strTable+='<td class="standard" height="25">';
		strTable+='<img src="../../images/CreateCube<%if("1".equals(rs.getString("status"))){out.print("Move");}%>.gif" style="vertical-align:middle;margin-right:10px;"><%=strName%>';
		strTable+='</td>';
		strTable+='<td class="standard"><%=strStatus%></td>';
		strTable+='<td class="standard" align="center"><%=strButton%></td>';
		strTable+='</tr>';
<%
}
rs.close();
%>

		strTable+='</table>';



	//	if(<%=i%>>=(parent.frm_main.document.getElementById("tbl_status").rows.length-1)){
			parent.frm_main.document.all.div_status.innerHTML=strTable;
	//	}



		<%
		//ステータステキストエリア書き込み
		try{

			//ログファイルパスの取得
			String fileName="status" + session.getValue("session_getId") + ".txt";
			String strPath=application.getRealPath(request.getServletPath());
			if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
				strPath=strPath.substring(0,strPath.lastIndexOf("\\") - 1);
				strPath=strPath.substring(0,strPath.lastIndexOf("\\") - 1);
				strPath=strPath.substring(0,strPath.lastIndexOf("\\") + 1)+"log\\"+fileName;
			} else {  
				strPath=strPath.substring(0,strPath.lastIndexOf("/") - 1);
				strPath=strPath.substring(0,strPath.lastIndexOf("/") - 1);
				strPath=strPath.substring(0,strPath.lastIndexOf("/") + 1)+"log/"+fileName;
			}



			FileReader fr=null;
			fr = new FileReader(strPath);
			BufferedReader br = new BufferedReader(fr);
			i=1;
			while(br.ready()){
				String tempRowText=br.readLine();
				if(i>=((Integer)session.getValue("readLineNum")).intValue()){
				%>
					parent.frm_main.document.form_main.textarea_status.value+="<%=ood.replace(tempRowText,"\"","\\\"")%>\n";
					var msgRow = parent.frm_main.document.form_main.textarea_status.createTextRange();
					msgRow.move("character",parent.frm_main.document.form_main.textarea_status.value.length);
					msgRow.select();

					if("<%=ood.replace(tempRowText,"\"","\\\"")%>".indexOf("全処理終了")!=-1){
						document.form_main.action = "../main/jobstatus_cube.jsp";
						document.form_main.target = "frm_cube";
						document.form_main.submit();
					}
				<%
				}
				i++;
			}
			session.putValue("readLineNum",new Integer(i));
			br.close();
			fr.close();
		}catch(Exception e){

		}
		%>


		<%if(executingFlg){%>
		document.form_main.action = "jobstatus_status.jsp?tp=loop";
		document.form_main.target = "frm_hidden2";
		document.form_main.submit();
		<%}%>


	}
// -->
	</script>
</head>
<%if("first".equals(tp)){%>
	<body onload="load()">
<%}else if("loop".equals(tp)){%>
	<body onload="setTimeout('load()',5000);">
<%}%>

<form name="form_main" id="form_main" method="post" action="">
</form>
</body>
</html>