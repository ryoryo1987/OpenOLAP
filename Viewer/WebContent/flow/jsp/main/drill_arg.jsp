<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="openolap.viewer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "openolap.viewer.XMLConverter"%>

<%@ include file="../../connect.jsp"%>



<%

	int i=0;
	int j=0;

	String Sql="";

	String loadTime = request.getParameter("load");
	if(loadTime.equals("first")){//もう一度自分自身を呼び出す（新しいWindowオープンとフォームsubmitの同時実現のため）
		out.println("<form name='form_main' method='post'>");
		out.println("<input type='hidden' name='hid_xml' value=''>");
		out.println("</form>");
		out.println("<script language='JavaScript'>");
		out.println("document.form_main.hid_xml.value=opener.document.SpreadForm.argXmlHidden.value;");
//out.println("alert(document.form_main.hid_xml.value)");

		out.println("document.form_main.target='_self';");
		out.println("document.form_main.action='drill_arg.jsp?load=second';");
		out.println("document.form_main.submit();");
		out.println("</script>");

	}else{//SQL作成

		String cellInfoXML=request.getParameter("hid_xml");
		XMLConverter xmlCon = new XMLConverter();
		Document doc = xmlCon.toXMLDocument(cellInfoXML);//セル情報XMLの読み込み



		Node reportNode = xmlCon.selectSingleNode(doc,"//report_info");
		String reportType = ((Element)reportNode).getAttribute("report_type");//レポートタイプ
		String reportId = ((Element)reportNode).getAttribute("report_id");//レポートID
		String cubeSeq = ((Element)reportNode).getAttribute("cube_seq");//キューブID





		String drillInfoXML = "";
		String referenceReportId = "";
		Sql = " select drill_xml,reference_report_id from oo_v_report";
		Sql += " where report_id = " + reportId;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			drillInfoXML=rs.getString("drill_xml"); 
			referenceReportId=rs.getString("reference_report_id"); 
		}
		rs.close();
		if(drillInfoXML==null){//個人レポートの場合は親のドリルスルー設定を参照
			Sql = " select drill_xml  from oo_v_report";
			Sql += " where report_id = " + referenceReportId;
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				drillInfoXML=rs.getString("drill_xml"); 
			}
			rs.close();
		}





		Document doc2 = xmlCon.toXMLDocument(drillInfoXML);//ドリル設定XMLの読み込み


//		String targetReportId=xmlCon.selectSingleNode(doc,"//TargetReportID").getFirstChild().getNodeValue();//ドリル先レポートID
		String targetReportId="";
		if("M".equals(reportType)){
			targetReportId=xmlCon.selectSingleNode(doc,"//TargetReportID").getFirstChild().getNodeValue();//ドリル先レポートID
		}else if("R".equals(reportType)){
			targetReportId=((Element)xmlCon.selectSingleNode(doc2,"//drill")).getAttribute("target_report_id");//ドリル先レポートID
		}







		String strSql = "";
		String strSqlXML = "";
		String strScreenXML = "";
		String strScreenXSL = "";
		String strScreenXSL2 = "";
		String strScreenXSL3 = "";
		String strScreenXSL4 = "";
		String strScreenXSL5 = "";
		String strScreenXSL6 = "";
		Sql = " select sql_xml,sql_text,screen_xml";
		Sql += ",screen_xsl";
		Sql += ",screen_xsl2";
		Sql += ",screen_xsl3";
		Sql += ",screen_xsl4";
		Sql += ",screen_xsl5";
		Sql += ",screen_xsl6";
		Sql += " from oo_v_report";
		Sql += " where report_id = " + targetReportId;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			strSqlXML=rs.getString("sql_xml"); 
			strSql=rs.getString("sql_text"); 
			strScreenXML=rs.getString("screen_xml"); 
			strScreenXSL=rs.getString("screen_xsl"); 
			strScreenXSL2=rs.getString("screen_xsl2"); 
			strScreenXSL3=rs.getString("screen_xsl3"); 
			strScreenXSL4=rs.getString("screen_xsl4"); 
			strScreenXSL5=rs.getString("screen_xsl5"); 
			strScreenXSL6=rs.getString("screen_xsl6"); 
		}
		rs.close();








		Document doc3 = xmlCon.toXMLDocument(strSqlXML);//ドリル先レポートSQL情報XMLの読み込み
		Node dimensionsNode=xmlCon.selectSingleNode(doc2,"//drill[@target_report_id='"+targetReportId+"']");
	//	out.println(xmlCon.toXMLText(dimensionsNode));

		NodeList dimIdList=xmlCon.selectNodes(dimensionsNode,"./dimensions/dimension/dimension_id");
		NodeList logicalConditionList=xmlCon.selectNodes(dimensionsNode,"./dimensions/dimension/logical_condition");


		//ドリル設定ディメンション情報をもとに、ディメンションごとにSQLの引数部分を置換する
		for(i=0;i<dimIdList.getLength();i++){
			//ディメンションID、条件IDの取得
			String dimId = ((Element)dimIdList.item(i)).getFirstChild().getNodeValue();
			String logicalConditionId="";
			if(((Element)logicalConditionList.item(i)).getFirstChild()!=null){
				logicalConditionId = ((Element)logicalConditionList.item(i)).getFirstChild().getNodeValue();
			}

			//ドリル先レポートSQL情報XMLから条件SQLを取得
			Node logicalConditionNode=xmlCon.selectSingleNode(doc3,"//where_clause/logical_condition[@id='"+logicalConditionId+"']/sql");
			String whereClause = "";
			if(((Element)logicalConditionNode)!=null){
				if(((Element)logicalConditionNode).getFirstChild()!=null){
					whereClause = ((Element)logicalConditionNode).getFirstChild().getNodeValue();
				}
			}

			if(whereClause.indexOf("@@")!=-1){//引数部分がある場合のみ

				String strCode="";
				if("M".equals(reportType)){
					//ドリル設定XMLのキー情報をもとに、ディメンションテーブルから該当メンバのコードを取得する
					String partSeq="";
					String timeDimFlg="";
					Node argNode = xmlCon.selectSingleNode(doc,"//arg[@dim_seq='"+dimId+"' and @dim_type='D']");
					String key=((Element)argNode).getAttribute("key");
					Sql = " select part_seq,time_dim_flg from oo_info_dim";
					Sql += " where cube_seq = " + cubeSeq;
					Sql += " and dimension_seq = " + dimId;
					rs = stmt.executeQuery(Sql);
					if(rs.next()){
						partSeq=rs.getString("part_seq"); 
						timeDimFlg=rs.getString("time_dim_flg"); 
					}
					rs.close();
					String reafFlg="";
					String tempColName="";
					if("1".equals(timeDimFlg)){//時間ディメンション
						tempColName="time_date";
					}else if("0".equals(timeDimFlg)){//通常ディメンション
						tempColName="code";
					}

				//	Sql = " select leaf_flg,code from oo_dim_" + dimId + "_" + partSeq;
					Sql = " select leaf_flg," + tempColName + " as code from oo_dim_" + dimId + "_" + partSeq;
					Sql += " where key = " + key;
					rs = stmt.executeQuery(Sql);
					if(rs.next()){
						strCode=rs.getString("code"); 
						reafFlg=rs.getString("leaf_flg"); 
					}
					rs.close();
					//最下層レベルではない場合は、最下層レベルのメンバコードをカンマ区切りでまとめて取得する
					if(reafFlg.equals("0")){
						strCode="";
					//	Sql = " select code from oo_dim_tree('oo_dim_" + dimId + "_" + partSeq + "',"+key+",null) where leaf_flg=1";
						Sql = " select " + tempColName + " as code from oo_dim_tree('oo_dim_" + dimId + "_" + partSeq + "',"+key+",null) where leaf_flg=1";

						rs = stmt.executeQuery(Sql);
						while(rs.next()){
							if(!"".equals(strCode)){strCode+="','";}
							strCode+=rs.getString("code"); 
						}
						rs.close();
					}

				}else if("R".equals(reportType)){
					dimId = ((Element)dimIdList.item(i)).getFirstChild().getNodeValue();


				//	Node argNode = xmlCon.selectSingleNode(doc,"//arg[@colName='"+dimId+"']");
					Node argNode = xmlCon.selectNodes(doc,"//arg").item(i);
					strCode=((Element)argNode).getAttribute("code");

				}




				if(!"".equals(strCode)){
					//条件の先頭にあるコメント「--」の削除
					int startCharInt = strSql.indexOf(whereClause);
					int startLineInt = strSql.lastIndexOf("\n",startCharInt);
					int endLineInt = strSql.indexOf("\n",startCharInt);
					if(strSql.substring(startLineInt+1,startLineInt+3).equals("--")){
					//	out.println("<BR>*"+strSql.substring(startLineInt+1,endLineInt)+"*");
					//	out.println("<BR>*"+"  "+strSql.substring(startLineInt+3,endLineInt)+"*");
						strSql=ood.replace(strSql,strSql.substring(startLineInt+1,endLineInt),"  "+strSql.substring(startLineInt+3,endLineInt));
					}

					//条件の引数部分を上記コードに置換する
					String strAtMarks=whereClause.substring(whereClause.indexOf("@@"),whereClause.lastIndexOf("@@")+2);
					String newWhereClause=ood.replace(whereClause,strAtMarks,strCode);
					strSql=ood.replace(strSql,whereClause,newWhereClause);
				}

			}

		}






		request.getSession().setAttribute("session_report_id",targetReportId);
		request.getSession().setAttribute("Rsql",strSql);
		request.getSession().setAttribute("RsourceXML",strScreenXML);
		request.getSession().setAttribute("screenXSL1",strScreenXSL);
		request.getSession().setAttribute("screenXSL2",strScreenXSL2);
		request.getSession().setAttribute("screenXSL3",strScreenXSL3);
		request.getSession().setAttribute("screenXSL4",strScreenXSL4);
		request.getSession().setAttribute("screenXSL5",strScreenXSL5);
		request.getSession().setAttribute("screenXSL6",strScreenXSL6);





	//	out.println("<BR>"+strSql);//SQL表示

		out.println("<form name='form_main' method='post'>");
		out.println("</form>");
		out.println("<script language='JavaScript'>");
		out.println("document.form_main.target='_self';");
		out.println("document.form_main.action='../Rreport/dispFrm.jsp?kind=session';");
		out.println("document.form_main.submit();");
		out.println("</script>");

	}




%>

<%@ include file="../../connect_close.jsp"%>
