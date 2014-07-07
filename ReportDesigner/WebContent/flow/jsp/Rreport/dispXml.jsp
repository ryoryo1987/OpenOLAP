<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="openolap.viewer.ood"%><%@ include file="../../connect.jsp"%><%

//request.getParameter("kind") session or db
//request.getParameter("rId") kind=db reportId
//request.getParameter("sessName") kind=session session_name
//request.getParameter("colName") kind=db column_name  all=report_id,report_name,screen_id,screen_name,style_id,style_name,model_seq,sql_text

	String kind=request.getParameter("kind");
	String rId=request.getParameter("rId");
	String sessName=request.getParameter("sessName");
	String colName=request.getParameter("colName");
	String dispXml="";

	if(kind.equals("session")){
		dispXml = (String)request.getSession().getAttribute(sessName);
		dispXml=dispXml.substring(dispXml.indexOf("?>")+2);//最初の<?xml version="1.0"?>を取り除く（先頭に空白等が入っているため）
		out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
		out.println(dispXml);
	}else if(kind.equals("db")){
		String SQL = "select * from oo_v_report where report_id="+rId;
		rs = stmt.executeQuery(SQL);
	String sqlText = "";
		if(colName.equals("all")){
			if(rs.next()){
				dispXml = "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>";
				dispXml += "<report";
				dispXml += " report_id='"+rs.getString("report_id")+"'";
				dispXml += " report_name='"+rs.getString("report_name")+"'";
				dispXml += " screen_id='"+rs.getString("screen_id")+"'";
				dispXml += " screen_name='"+rs.getString("screen_name")+"'";
				dispXml += " style_id='"+rs.getString("style_id")+"'";
				dispXml += " style_name='"+rs.getString("style_name")+"'";
				dispXml += " model_seq='"+rs.getString("model_seq")+"'";
				dispXml += " sql_customized_flg='"+rs.getString("customized_flg")+"'";

				//2005-10-18 miyamo
				sqlText=ood.replace(rs.getString("sql_text"),"'","&apos;");
				sqlText=ood.replace(sqlText,"<","&lt;");
				sqlText=ood.replace(sqlText,">","&gt;");
				dispXml += " sql_text='"+sqlText+"'";
//				dispXml += " sql_text='"+ood.replace(rs.getString("sql_text"),"'","&apos;")+"'";

				dispXml += "/>";
				out.println(dispXml);
			}
			rs.close();
		}else{
			if(rs.next()){
				dispXml = (String)rs.getString(colName);
				dispXml=dispXml.substring(dispXml.indexOf("?>")+2);//最初の<?xml version="1.0"?>を取り除く（先頭に空白等が入っているため）
//				dispXml=dispXml.substring(dispXml.indexOf("?>")+2);//最初の<?xml version="1.0"?>を取り除く（先頭に空白等が入っているため）
				out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
				out.println(dispXml);
			}
			rs.close();
		}

	}

%>
<%@ include file="../../connect_close.jsp" %>

