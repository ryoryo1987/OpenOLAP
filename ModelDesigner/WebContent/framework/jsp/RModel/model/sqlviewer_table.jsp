<%@ page language="java" contentType="text/xml;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "designer.XMLConverter"%>
<%@ page import = "org.apache.xpath.*"%>
<%@ page import = "org.w3c.dom.traversal.*"%>
<%@ page import="designer.PostgreSqlGenerator" %>

<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="sqlviewer.xsl" ?>

<%@ include file="../../../../connect.jsp"%>


<rows>

<%

	String XMLString = request.getParameter("hid_xml");
	Document doc = new XMLConverter().toXMLDocument(XMLString);
	Element root = doc.getDocumentElement();
//	NodeList listColumnName = root.getElementsByTagName("name");
//	NodeList listColumnName = XPathAPI.selectNodeList(doc,"/RDBModel/db_tables/db_table[@name='fact_sales']/logical_model/select/logical_column/name");
//	NodeList listColumnName = XPathAPI.selectNodeList(doc,"//logical_model/select_clause/logical_column/name");
	NodeList listDataType = root.getElementsByTagName("att1");


//	for(int i=0;i<listColumnName.getLength();i++){
//		out.println(((Element)listColumnName.item(i)).getFirstChild().getNodeValue());
//		String tempDataType=((Element)listColumnName.item(i)).getFirstChild().getNodeValue();
//		out.println(tempDataType);
//	}



	String strComennt="";

	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
//	String strScript = request.getParameter("ara_script");
//	String strScript = "select * from fact_sales";
	PostgreSqlGenerator sqlGene = new PostgreSqlGenerator();

	String strScript = "";
	String sqlLevel = request.getParameter("sqlLevel");
	if(sqlLevel.equals("AllTables")){
		strScript = sqlGene.getSQL(request.getParameter("hid_xml"));
	}else if(sqlLevel.equals("Table")){
		strScript = sqlGene.getTableSQL(request.getParameter("hid_xml"));
	}



	Sql = "SELECT COUNT(*) AS cnt FROM (" + strScript + ") AS SQL";
	try{
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			recordCount=rs.getInt("cnt");
		}
		rs.close();
	}catch(SQLException e){
		strError=e.toString()+"";
	}

	try{
		rs = stmt.executeQuery(strScript);
		rsmd = rs.getMetaData();
		colCount=rsmd.getColumnCount();
	}catch(SQLException e){
		strError=e.toString()+"";
	}


	strComennt="レコード" + recordCount + "件";
	if(recordCount>100){
		strComennt+="中100件のみ表示";
	}

	if("".equals(strError)){
		out.println("<coldef>");
			for(i=1;i<=colCount;i++){
				out.println("<column>");
				out.println("<heading>"+rsmd.getColumnName(i)+"</heading>");
/*
				String tempColumnName="項目名";
				tempColumnName=((Element)listColumnName.item(i-1)).getFirstChild().getNodeValue();
				out.println("<heading>"+tempColumnName+"</heading>");
*/

//				out.println("<type>Text</type>");
				String tempDataType="Text";
				////////////////////////////////非表示カラムの分をずらす必要あり　要修正　10/18深井
				tempDataType=((Element)listDataType.item(i-1)).getFirstChild().getNodeValue();
				if(tempDataType.equals("Text")){
					out.println("<type>text</type>");
				}else{
					out.println("<type>number</type>");
				}

				out.println("<width>100</width>");
				out.println("</column>");
			}
		out.println("</coldef>");

		int j=1;
		while(rs.next()&&j<=100){
			j++;
			out.println("<row>");
			for(i=1;i<=colCount;i++){
				out.println("<value>"+ood.replace(ood.replace(ood.replace(rs.getString(i),"&","&amp;"),"<","&lt;"),">","&gt;")+"</value>");
			}
			out.println("</row>");
		}
		rs.close();


	}else{
	//	out.println("<error>" + strError + "</error>");
		strComennt="SQLが不正です。"+"   "+strError;
	}


	out.println("<comment>" + strComennt + "</comment>");

%>
</rows>


