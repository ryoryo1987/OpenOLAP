<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.*"%>
<%@ page import = "java.io.*"%>
<%!
	public static java.util.Date getNowTime() {
		Calendar cal = Calendar.getInstance();
		java.util.Date dt = cal.getTime();
		return dt;
	}
%>

<%
request.setCharacterEncoding("Shift_JIS");
%>

<%

session.putValue("METAConnect_Session",null);



String loginName = request.getParameter("txt_name");
String loginPassword = request.getParameter("txt_pwd");
String loginSchema = request.getParameter("txt_schema");
String loginDsn = request.getParameter("txt_dsn");



session.putValue("loginName",loginName);
session.putValue("loginPassword",loginPassword);
session.putValue("loginSchema",loginSchema);
session.putValue("loginDsn",loginDsn);

DateFormat df=new SimpleDateFormat("yyyyMMddHHmmss");
session.putValue("session_getId",df.format(getNowTime())+"-"+session.getId());



%>

<%
String connDsn,connName,connPassword;
Connection connMeta = null;
Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
Statement stmt4 = null;
Statement stmt5 = null;

DriverManager.registerDriver(new org.postgresql.Driver());

//Dsn loginName loginPassword
connDsn = (String)session.getValue("loginDsn");
connName = (String)session.getValue("loginName");
connPassword = (String)session.getValue("loginPassword");






connMeta = (Connection)session.getValue("METAConnect");
stmt = (Statement)session.getValue("METAStatement");
stmt2 = (Statement)session.getValue("METAStatement2");
stmt3 = (Statement)session.getValue("METAStatement3");
stmt4 = (Statement)session.getValue("METAStatement4");
stmt5 = (Statement)session.getValue("METAStatement5");



try {//�R�l�N�g
	connMeta = DriverManager.getConnection(connDsn ,connName ,connPassword);
} catch(SQLException ex){//�R�l�N�g���s
	response.sendRedirect( "login_error.jsp?errMsg=" + ex.toString() + "&errNum=0");
	return;
}


stmt = connMeta.createStatement();
stmt2 = connMeta.createStatement();
stmt3 = connMeta.createStatement();
stmt4 = connMeta.createStatement();
stmt5 = connMeta.createStatement();
session.putValue("METAConnect",connMeta);
session.putValue("METAStatement",stmt);
session.putValue("METAStatement2",stmt2);
session.putValue("METAStatement3",stmt3);
session.putValue("METAStatement4",stmt4);
session.putValue("METAStatement5",stmt5);

ResultSet rs =null; // stmt
ResultSet rs2=null; // stmt2
ResultSet rs3=null; // stmt3
ResultSet rs4=null; // stmt4
ResultSet rs5=null; // stmt5


String Sql="";
%>



<%
	/////////////////////�����ݒ�
	//�e�I�u�W�F�N�g�̍ő吔��ݒ�
	session.putValue("strMaxLevel","6");
	session.putValue("strMaxDimension","29");
	session.putValue("strMaxMeasure","50");


	session.putValue("modelSeq","");









	//////////////////////////////////���O�C��
	int exist_flg=0;
	Sql="";
	Sql = Sql + " SELECT * FROM pg_namespace";
	Sql = Sql + " WHERE nspname = '" + loginSchema + "'";
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		exist_flg=1;
	}
	rs.close();
	if(exist_flg==0){
		response.sendRedirect( "login_error.jsp?errMsg=" + loginSchema + "&errNum=1" );
		return;
	}else if(exist_flg==1){
	//	response.sendRedirect("OpenOLAP.html");
	}

	exist_flg=0;
	Sql="";
	Sql = Sql + " SELECT * FROM pg_tables";
	Sql = Sql + " WHERE tablename = 'oo_meta_info' AND schemaname = '" + loginSchema + "'";
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		exist_flg=1;
	}
	rs.close();
	if(exist_flg==0){
		response.sendRedirect( "login_error.jsp?errMsg=" + loginSchema + "&errNum=2" );
		return;
	}else if(exist_flg==1){
	//	response.sendRedirect("OpenOLAP.html");
	}


	exist_flg=0;
	Sql="";
	Sql = Sql + " SELECT * FROM pg_tables";
	Sql = Sql + " WHERE tableowner = '" + loginName + "' AND tablename = 'oo_meta_info'";
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		exist_flg=1;
	}
	rs.close();
	if(exist_flg==0){
		response.sendRedirect( "login_error.jsp?errMsg=" + loginName + "&errNum=3" );
	}else if(exist_flg==1){
		//�X�L�[�}�����p�X�̐ݒ�
		Sql = "SET search_path TO " + loginSchema + "";
		int exeCount = stmt.executeUpdate(Sql);



		/////////////////////���O�t�@�C���Ǘ�
		//�K�v�łȂ����O�t�@�C���̍폜
		try{
			String fileName="log";
			String strPath=application.getRealPath(request.getServletPath());
			if(System.getProperty("os.name").substring(0,4).equals("Wind")) {
				strPath=strPath.substring(0,strPath.lastIndexOf("\\") + 1)+fileName;
			} else {  
				strPath=strPath.substring(0,strPath.lastIndexOf("/") + 1)+fileName;
			}

			//���O�f�B���N�g��
			File logFolder=new File(strPath);

			//�������30���O�̓��tString���擾
			Calendar cal = Calendar.getInstance();
			cal.setTime(cal.getTime());
			cal.add(Calendar.DATE,-30);
			DateFormat df2=new SimpleDateFormat("yyyyMMdd");
			String sevenDaysBefore=df2.format(cal.getTime());

			//���O�f�B���N�g�����̃��O�t�@�C�����̓��t������30���ȏ�O�̏ꍇ�̓��O�t�@�C�����폜
			String[] fileList=logFolder.list();
			for (int i=0;i< fileList.length;i++) {
				if((Integer.parseInt(sevenDaysBefore)>Integer.parseInt(fileList[i].substring(6,14)))){
					File tempfile = new File(strPath, fileList[i]);
					tempfile.delete();
				}
			}
		}catch(Exception e){
		} 

		//DB����30���ȏ�O��JOB���폜
		Sql = "delete from oo_job where time<current_date-30";
		exeCount = stmt.executeUpdate(Sql);



		if(request.getParameter("lst_apl").equals("1")){
			response.sendRedirect("OpenOLAP.html");
		}else if(request.getParameter("lst_apl").equals("2")){
			response.sendRedirect("framework/jsp/intro/frm_menu.jsp");
		}

	}


%>



