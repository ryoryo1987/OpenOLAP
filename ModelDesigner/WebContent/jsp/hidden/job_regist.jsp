<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "designer.*"%>

<%@ page errorPage="ErrorPage.jsp"%>


<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int exeCount=0;

String strJobName="";
String objSeq = request.getParameter("objSeq");
String strCubeSeq = request.getParameter("lst_cube");
String strProcess = request.getParameter("hid_process");





	if(!"0".equals(objSeq)){
		Sql = "SELECT cube_seq,process FROM oo_job WHERE job_seq = " + objSeq;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			strCubeSeq = rs.getString("cube_seq");
			strProcess = rs.getString("process");
		}
		rs.close();
	}


	//SEQUENCE 取得
	Sql = "SELECT nextval('oo_job_seq') as seq_no";

	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		objSeq = rs.getString("seq_no");
	}
	rs.close();




	//新規登録
	Sql = "INSERT INTO oo_job (";
	Sql = Sql + "job_seq";
	Sql = Sql + ",cube_seq";
	Sql = Sql + ",process";
	Sql = Sql + ",session_id";
	Sql = Sql + ",time";
	Sql = Sql + ",status";
	Sql = Sql + ",stop_flg";
	Sql = Sql + ")VALUES(";
	Sql = Sql + "" + objSeq;
	Sql = Sql + ",'" + strCubeSeq + "'";
	Sql = Sql + ",'" + strProcess + "'";
	Sql = Sql + ",'" + session.getValue("session_getId") + "'";
	Sql = Sql + ",'NOW'";
	Sql = Sql + ",'9'";
	Sql = Sql + ",'0'";
	Sql = Sql + ")";
//	out.println(Sql);
	exeCount = stmt.executeUpdate(Sql);


	Sql = "SELECT * ";
	Sql = Sql + " FROM oo_job";
	Sql = Sql + " WHERE status='1'";
	Sql = Sql + " AND session_id='" + session.getValue("session_getId") + "'";
	rs = stmt.executeQuery(Sql);
	if(!rs.next()){
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


		//ジョブの実行
		String tempClass = "";
		String tempPWD="";
		if("".equals((String)session.getValue("loginPassword"))){
			tempPWD="null";//PWDがNULLだとジョブ起動時にエラーとなるので、NULLの場合は便宜的に「NULL」テキスト挿入
		}else{
			tempPWD=(String)session.getValue("loginPassword");
		}
	//	String tempArg = session.getValue("loginName") + " " + tempPWD + " " + session.getValue("loginSchema") + " " + session.getValue("loginDsn") + " " + session.getValue("session_getId") + " " + strPath;
		String tempArg = "-metaname " + session.getValue("loginName") + " -metapwd " + tempPWD + " -metaschema " + session.getValue("loginSchema") + " -dsn " + session.getValue("loginDsn") + " -innerargument " + session.getValue("session_getId");
		if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
			tempArg += " -log \"" + strPath + ",1\"";
		}else{
			tempArg += " -log " + strPath + ",1";
		}

		String strExeText = "";
		if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
			tempClass = "-classpath \"" + session.getValue("DESIGNER_CLASSES_PATH") + ";" + session.getValue("JDBC_DRIVER") + ";.\"";//セミコロン
			strExeText = "cmd /c java " + tempClass + " designer.ExecuteJob " + tempArg;
		}else{
			tempClass = "-classpath " + session.getValue("DESIGNER_CLASSES_PATH") + ":" + session.getValue("JDBC_DRIVER") + ":.";//コロン
			strExeText = "java " + tempClass + " designer.ExecuteJob " + tempArg;
		}

		out.println(strExeText);
	//	Process process = Runtime.getRuntime().exec(strExeText);
		String[] strArray = strExeText.split(" ");
		new CubeCreateJob().execute(strArray);


	}
	rs.close();


	Sql = "SELECT ";
	Sql = Sql + " c.cube_seq||':'||c.name||' (プロセス '||j.process||')' AS name";
	Sql = Sql + " FROM oo_job j";
	Sql = Sql + " ,oo_cube c";
	Sql = Sql + " WHERE j.cube_seq=c.cube_seq";
	Sql = Sql + " AND j.job_seq=" + objSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strJobName=rs.getString("name");
	}
	rs.close();


%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">
	function load(){

		parent.frm_main.document.form_main.action = "../hidden/jobstatus_status.jsp?tp=first";
		parent.frm_main.document.form_main.target = "frm_hidden2";
		parent.frm_main.document.form_main.submit();

		var myNewRow = parent.frm_main.document.getElementById("tbl_status").insertRow();
		myNewRow.id="<%=objSeq%>";
		myNewRow.insertCell([0]);
		myNewRow.insertCell([1]);
		myNewRow.insertCell([2]);
		myNewRow.cells[0].innerHTML='<img src="../../images/CreateCube.gif" style="vertical-align:middle;margin-right:10px;"><%=strJobName%>';
		myNewRow.cells[1].innerHTML='待機';
		myNewRow.cells[2].innerHTML='<input type="button" value="削除" onclick="delJob(<%=objSeq%>)">';
		myNewRow.cells[0].className='standard';
		myNewRow.cells[1].className='standard';
		myNewRow.cells[2].className='standard_center';



		for(i=0;i<parent.frm_main.document.form_main.lst_job.length;i++){
			if(parent.frm_main.document.form_main.lst_job.options[i].text=="<%=strJobName%>"){
				parent.frm_main.document.form_main.lst_job.removeChild(parent.frm_main.document.form_main.lst_job.options[i]);
				break;
			}
		}

		//Jobリストに追加
		var jobList = parent.frm_main.document.getElementById("lst_job");
		var addOption = parent.frm_main.document.createElement("OPTION");
		addOption.value = "<%=objSeq%>";
		addOption.text = "<%=strJobName%>";
		jobList.options.add(addOption,1);


		showMsg("JRG3");

	//	location.replace("blank.jsp");

	}
	</script>
</head>
<body onload="load()">
</body>
</html>

