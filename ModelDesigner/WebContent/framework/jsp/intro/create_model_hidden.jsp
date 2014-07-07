<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../../connect.jsp" %>

<%
String Sql="";
String strOutput="";

if("create_model_1.jsp".equals((String)request.getParameter("fileName"))){
	session.putValue("name",(String)request.getParameter("txt_name"));
	session.putValue("schema",(String)request.getParameter("lst_schema"));
	session.putValue("model_type",(String)request.getParameter("flag"));
}else if("create_model_copy.jsp".equals((String)request.getParameter("fileName"))){
	session.putValue("ref_model",(String)request.getParameter("rdo_model"));
	session.putValue("ref_model_name",(String)request.getParameter("model_name"));

}else if("create_model_measure.jsp".equals((String)request.getParameter("fileName"))){
	session.putValue("ref_measures",(String)request.getParameter("measures"));
	strOutput="";
	if(!"".equals((String)session.getValue("ref_measures"))){
		Sql = "select distinct fact_table as table_name from oo_measure where measure_seq in (" + (String)session.getValue("ref_measures") + ")";
		Sql += " union ";
		Sql += "select d.table_name as table_name from oo_level d,oo_measure_link m where d.dimension_seq=m.dimension_seq and m.measure_seq in (" + (String)session.getValue("ref_measures") + ")";
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			if(!"".equals(strOutput)){strOutput+=", ";}
			strOutput+=rs.getString("table_name");
		}
		rs.close();
	}
	out.println("<script>");
	out.println("parent.frm_main.document.all.span_tables.innerHTML='" + strOutput + "';");
	out.println("</script>");
}else if("create_model_dimension.jsp".equals((String)request.getParameter("fileName"))){
	session.putValue("ref_dimensions",(String)request.getParameter("dimensions"));
	strOutput="";
	if(!"".equals((String)session.getValue("ref_dimensions"))){
		Sql = "select distinct table_name as table_name from oo_dimension d,oo_level l where d.dimension_seq=l.dimension_seq and d.dimension_seq in (" + (String)session.getValue("ref_dimensions") + ")";
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			if(!"".equals(strOutput)){strOutput+=", ";}
			strOutput+=rs.getString("table_name");
		}
		rs.close();
	}
	out.println("<script>");
	out.println("parent.frm_main.document.all.span_tables.innerHTML='" + strOutput + "';");
	out.println("</script>");
}

%>
<BR>fileName:<%=(String)request.getParameter("fileName")%>
<BR>name:<%=(String)session.getValue("name")%>
<BR>schema:<%=(String)session.getValue("schema")%>
<BR>ref_model:<%=(String)session.getValue("ref_model")%>
<BR>ref_model_name:<%=(String)session.getValue("ref_model_name")%>
<BR>ref_measures:<%=(String)session.getValue("ref_measures")%>
<BR>ref_dimensions:<%=(String)session.getValue("ref_dimensions")%>
<BR>Sql:<%=Sql%>