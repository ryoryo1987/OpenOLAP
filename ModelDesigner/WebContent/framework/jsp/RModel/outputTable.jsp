<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>


<%@ include file="../../../connect.jsp" %>
<%
	String schemaName=(String)session.getValue("RModelSchema");
	String tableName = request.getParameter("lst_table");





	String arrColumnText[] = new String[1000];
	String arrColumnName[] = new String[1000];
	int i=0;

	String Sql="";
	Sql += " SELECT";
	Sql += " oo_fun_columnList('" + tableName + "','" + schemaName + "') AS columnlist";
	rs = stmt.executeQuery(Sql);
//	out.println("strXML+='<Cube>"+tableName+"';");
	while(rs.next()){
		StringTokenizer st = new StringTokenizer(rs.getString("columnlist"),",");
		while(st.hasMoreTokens()) {
			String columnText = st.nextToken();
			arrColumnText[i]=columnText;
			StringTokenizer st2 = new StringTokenizer(columnText," ");
			String columnName = st2.nextToken();
		//	out.println("strXML+='<Measure TABLE=\\'" + tableName + "\\' ID=\\'" + columnName + "\\'>" + columnName + "</Measure>';");
			arrColumnName[i]=columnName;
			i++;
		}
	}
	rs.close();
	out.println("/*" + Sql + "*/");

%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="javascript">




<%
out.println("var arrColumnName = new Array();");
out.println("var arrColumnText = new Array();");
for(i=0;i<arrColumnName.length;i++){
	if(arrColumnName[i]!=null){
		out.println("arrColumnName[" + i + "]='" + arrColumnName[i] + "';");
		out.println("arrColumnText[" + i + "]='" + arrColumnText[i] + "';");
	}
}
%>





		function load(){






			var addXMLDom = new ActiveXObject("MSXML2.DOMDocument");
			addXMLDom.async = false;
			var strXml="";
			strXml+="	<db_table name=\"<%=tableName%>\" table_type=\"dim\">";
			strXml+="		<position>";
			strXml+="			<left>0</left>";
			strXml+="			<top>0</top>";
			strXml+="			<height>200</height>";
			strXml+="			<width>100</width>";
			strXml+="		</position>";
			strXml+="		<physical_model>";

			for(i=0;i<arrColumnName.length;i++){
				strXml+="<column id='" + arrColumnName[i] + "'>";
				strXml+="<name>" + arrColumnName[i] + "</name>";
				strXml+="<type>" + arrColumnText[i] + "</type>";
				strXml+="</column>";
			}

			strXml+="		</physical_model>";
			strXml+="		<logical_model name='<%=tableName%>'>";
			strXml+="		<select_clause id='select_clause'>";
			strXml+="		</select_clause>";
			strXml+="		<where_clause id='where_clause'>";
			strXml+="		</where_clause>";
			strXml+="		</logical_model>";
			strXml+="	</db_table>";


			addXMLDom.loadXML(strXml);




			parent.frm_main1.XMLDom.selectSingleNode("//db_tables").appendChild(addXMLDom.selectSingleNode("//"));

//	alert(parent.frm_main1.XMLDom.xml);


			parent.frm_main1.displayTable("<%=tableName%>",arrColumnName);


		}

	</script>
</head>
<body onload="load()">
<br><br>
</body>
</html>
