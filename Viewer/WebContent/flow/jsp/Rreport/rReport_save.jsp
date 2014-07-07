<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="openolap.viewer.ood"%>


<%@ include file="../../connect.jsp"%>

<%
//out.println(request.getSession().getAttribute("Rsql"));
	String SQL = "";
	int updateCount = 0;
	String reportId="";
	String reportStatus=(String)request.getParameter("report");

	if(reportStatus.equals("new")){
		SQL = " select nextval('report_id') as cnt";
		rs = stmt.executeQuery(SQL);
		if(rs.next()){
			reportId=rs.getString("cnt");
		}
	}else if(reportStatus.equals("update")){
		reportId=(String)request.getParameter("report_id");
		SQL="delete from oo_v_report where report_id="+reportId;
		updateCount = stmt.executeUpdate(SQL);
	}

	SQL = " insert into  oo_v_report(";
	SQL = SQL + " report_id,par_id,report_name,update_date";
	SQL = SQL + " ,user_id,report_owner_flg,kind_flg,report_type,screen_id,screen_name";
	SQL = SQL + " ,style_id,style_name";
	SQL = SQL + " ,model_seq,screen_xml";
	SQL = SQL + " ,screen_xsl";
	SQL = SQL + " ,screen_xsl2";
	SQL = SQL + " ,screen_xsl3";
	SQL = SQL + " ,screen_xsl4";
	SQL = SQL + " ,screen_xsl5";
	SQL = SQL + " ,screen_xsl6";
	SQL = SQL + " ,customized_flg,sql_xml,sql_text)";

	SQL = SQL + " values(";
	SQL = SQL + " "+reportId+"";
	SQL = SQL + " ,(select case when count(*)=1 then 1 else null end from oo_v_report where report_id=1 )";
	SQL = SQL + " ,'"+request.getParameter("report_name")+"'";//report_name
	SQL = SQL + " ,now()";
	SQL = SQL + " ,0,'1','R','R'";//user_id:0(共通) owner_flg:1(共通) kind:Report,type:ROLAP
	SQL = SQL + " ,'"+request.getParameter("screen_id")+"'";//screen_id
	SQL = SQL + " ,'"+request.getParameter("screen_name")+"'";//screen_name
	SQL = SQL + " ,'"+request.getParameter("style_id")+"'";//style_id
	SQL = SQL + " ,'"+request.getParameter("style_name")+"'";//style_name
	SQL = SQL + " ,'"+request.getParameter("model_seq")+"'";//model_seq
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("RsourceXML"),"'","''")+"'";//screen_xml
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("screenXSL1"),"'","''")+"'";//screen_xsl1
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("screenXSL2"),"'","''")+"'";//screen_xsl2
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("screenXSL3"),"'","''")+"'";//screen_xsl3
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("screenXSL4"),"'","''")+"'";//screen_xsl4
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("screenXSL5"),"'","''")+"'";//screen_xsl5
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("screenXSL6"),"'","''")+"'";//screen_xsl6
	SQL = SQL + " ,'"+request.getParameter("sql_customized_flg")+"'";//customized_flg 0:カスタマイズなし 1:あり
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("sqlXML"),"'","''")+"'";//sql_xml
	SQL = SQL + " ,'"+ood.replace((String)request.getSession().getAttribute("Rsql"),"'","''")+"')";//sql_text
//out.println(SQL);

	updateCount = stmt.executeUpdate(SQL);



%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("<%=request.getParameter("report_name")%>を保存しました。");

			document.form_main.action = "../../../OpenOLAP.jsp";
			document.form_main.target = "_top";
			document.form_main.submit();

		}
	</script>
</head>
<body onload="load()">
<form name="form_main" id="form_main" method="post">

<%//out.println(SQL)%>
<br><br>
<!--updateCount:<%=updateCount%>-->

</form>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
