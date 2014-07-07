<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
//	int userSeq = Integer.parseInt(request.getParameter("userSeq"));

	int i=0;
	String strFromJobSeq="";
	Sql = "SELECT ";
	Sql = Sql + " coalesce(MAX(job_seq+1),0) AS job_seq";
	Sql = Sql + " FROM oo_job";
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strFromJobSeq=rs.getString("job_seq");
	}
	rs.close();


	Sql = "SELECT ";
	Sql = Sql + " coalesce(MAX(job_seq),0) AS job_seq";
	Sql = Sql + " FROM oo_job";
	Sql = Sql + " WHERE status='1'";
	Sql = Sql + " AND session_id='" + session.getValue("session_getId") + "'";
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		if(!"0".equals(rs.getString("job_seq"))){
			strFromJobSeq=rs.getString("job_seq");
		}
	}
	rs.close();

	session.putValue("strFromJobSeq",strFromJobSeq);

%>

<html>

<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript" src="../js/common.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/common.css">

	<script language="JavaScript">


		function load(){
			document.form_main.action = "../hidden/jobstatus_status.jsp?tp=first";
			document.form_main.target = "frm_hidden2";
			document.form_main.submit();

		//	document.form_main.action = "../hidden/jobstatus_log.jsp";
		//	document.form_main.target = "frm_hidden3";
		//	document.form_main.submit();

		}


		function delJob(jobSeq){
			document.form_main.action = "../hidden/jobstatus_regist.jsp?objSeq=" + jobSeq;
			document.form_main.target = "frm_hidden";
			document.form_main.submit();
		}




		function regist(objSeq) {
			if(objSeq=="0"){
				if(document.form_main.lst_cube.value==""){
					showMsg("JRG1");
					document.form_main.lst_cube.focus();
					return;
				}
				for(i=1;i<document.form_main.lst_process.length;i++){
					if((document.form_main.lst_process.options[0].selected==true)&&(document.form_main.lst_process.options[i].selected==true)){
						showMsg("JRG2");
						return;
					}
				}

				document.form_main.hid_process.value="";
				for(i=0;i<document.form_main.lst_process.length;i++){
					if(document.form_main.lst_process.options[i].selected==true){
						if(document.form_main.hid_process.value!=""){document.form_main.hid_process.value+=",";}
						document.form_main.hid_process.value+=document.form_main.lst_process.options[i].value;
					}
				}
			}else{
				if(document.form_main.lst_job.value==""){
					showMsg("JRG7");
					document.form_main.lst_job.focus();
					return;
				}
			}


			document.form_main.action = "../hidden/job_regist.jsp?objSeq=" + objSeq;
			document.form_main.target = "frm_hidden";
			document.form_main.submit();
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
			<td class="main" style="text-align:left;padding-top:5;padding-bottom:0">
 
			<!-- コンテンツ -->
			<table style="margin-left:7">
				<tr>
					<td></td>
					<td>
						<table>
							<tr>
								<!--キューブリストの項目タイトル-->
								<td width="20"></td>
								<td style="width:120;font-weight:bold;text-align:center">キューブ</td>
								<td style="width:50;font-weight:bold;text-align:center">件数</td>
							</tr>
						</table>
					</td>
					</tr>
					<tr>
						<td>
							<table style="table-layout:fixed">
								<tr>
									<th class="standard" style="width:135">キューブ</th>
									<td class="standard" style="width:250">
										<select name="lst_cube" mON="キューブ" >
											<option value="">---------------</option>
											<%
												Sql = "SELECT cube_seq,name";
												Sql = Sql + " FROM oo_cube";
												Sql = Sql + " ORDER BY cube_seq";
												rs = stmt.executeQuery(Sql);
												while(rs.next()){
													out.println("<option value='" + rs.getString("cube_seq") + "'>" + rs.getString("cube_seq") + ":" + rs.getString("name") + "</option>");
												}
												rs.close();
											%>
										</select>
									</td>
									<td class="standard" rowspan="2" style="width:85px;text-align:center;padding:0">
										<input type="button" name="allcrt_btn" value="" onClick="JavaScript:regist(0);" class="normal_go" onMouseOver="className='over_go'" onMouseDown="className='down_go'" onMouseUp="className='up_go'" onMouseOut="className='out_go'">
									</td>
								</tr>
								<tr>
									<th class="standard">プロセス</th>
									<td class="standard">
										<select name="lst_process" size="6" mON="プロセス"  multiple>
											<option value="0" selected>0: 削除＆新規作成</option>
											<option value="9">9: キューブ削除</option>
											<option value="1">1: キューブ定義</option>
											<option value="2">2: データロード</option>
											<option value="3">3: 集計</option>
											<option value="4">4: カスタムメジャー</option>
										</select>
									</td>
								</tr>
								<tr>
									<th class="standard">最近実行されたジョブ</th>
									<td class="standard">
										<select name="lst_job">
											<option value="">---------------</option>
											<%
												Sql = "";
												Sql = Sql + "SELECT job_seq,name FROM (";
												Sql = Sql + "SELECT ";
												Sql = Sql + " MAX(j.job_seq) AS job_seq";
												Sql = Sql + " ,c.cube_seq||':'||c.name||' (プロセス '||j.process||')' AS name";
												Sql = Sql + " FROM oo_job j";
												Sql = Sql + " ,oo_cube c";
												Sql = Sql + " WHERE j.cube_seq=c.cube_seq";
												Sql = Sql + " GROUP BY c.cube_seq||':'||c.name||' (プロセス '||j.process||')'";
												Sql = Sql + ") AS A";
												Sql = Sql + " ORDER BY job_seq DESC";
												Sql = Sql + " LIMIT 10";
												rs = stmt.executeQuery(Sql);
												while(rs.next()){
											%>
											<option value="<%=rs.getString("job_seq")%>"><%=rs.getString("name")%></option>
											<%
												}
												rs.close();
											%>
										</select>
									</td>
									<td class="standard" style="width:85px;text-align:center">
										<input type="button" name="allcrt_btn" value="" onClick="JavaScript:regist(document.form_main.lst_job.value);" class="normal_go" onMouseOver="className='over_go'" onMouseDown="className='down_go'" onMouseUp="className='up_go'" onMouseOut="className='out_go'">
									</td>
								</tr>
							</table>
							<br>

							<div id="div_status" style="display:inline;overflow:auto;height:170">
								<div align="left"><b>実行リスト</b></div>
								<table name="tbl_status" id="tbl_status" class="standard" style="width:475">
									<tr>
										<th class="standard">ジョブ</th>
										<th class="standard>ステータス</th>
										<th class="standard">&nbsp;</th>
									</tr>
								</table>
							</div>
						</td>
						<td valign="top">
							<iframe name="frm_cube" src="jobstatus_cube.jsp" width="220" height="325"></iframe>
						</td>
						</tr>
						</table>

						<table style="border-collapse:collapse;width:705;margin-bottom:0;margin-left:10">
							<tr>
								<th class="standard" colspan="2" >ステータス表示</th>
							</tr>
							<!-- dummy td -->
							<tr><td height = "3" colspan="2"></td></tr>
							<tr>

								<td id="create_cube_img" class="standard" style="border-width:1 0 1 1" style="background-color:white">
								<!--	<img src="../../images/create_cube_stop.gif">-->
								</td>
								<td class="standard" style="border-width:1 1 1 0">
									<textarea name="textarea_status" cols="135" rows="8" readonly>
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
											out.println(br.readLine());
											i++;
										}
										session.putValue("readLineNum",new Integer(i));
										br.close();
										fr.close();
									}catch(Exception e){

									}
									%></textarea>
								</td>
							</tr>
						</table>
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


<!--隠しオブジェクト-->
<div name="div_hid" id="div_hid" style="display:none;"></div>

<input type="hidden" name="hid_process" id="hid_process" value="">
<input type="hidden" name="hid_user_seq" id="hid_user_seq" value="<%//=userSeq%>">
<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">

</form>

</body>
</html>


