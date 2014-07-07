package openolap.viewer;

import javax.xml.parsers.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import org.apache.log4j.Logger;

public class PostgreSqlGenerator{
	XMLConverter xmlCon;
	Document xmlDoc;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgreSqlGenerator.class.getName());

	public PostgreSqlGenerator() throws ParserConfigurationException {
		try {
			xmlCon = new XMLConverter();
		} catch (ParserConfigurationException e) {
			throw e;
//			e.printStackTrace();
		}
	}

	public String getTableSQL(String xmlString) {
		try {
			xmlDoc = xmlCon.toXMLDocument(xmlString);
			String sqlString = "";
			sqlString += getSelectStr("all");
			sqlString += getFromStr();
			sqlString += getWhereStr("","all");
			sqlString += getGroupByStr("all");
			sqlString += getOrderByStr("all");
			sqlString += getLimitStr();
			return sqlString;
		} catch (Exception e) {
			log.error("exception in getTableSQL()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getSQL(String xmlString) {
		try {
			xmlDoc = xmlCon.toXMLDocument(xmlString);
			String sqlString = "";
			sqlString += getSelectStr("all");
			sqlString += getFromStr();
//			sqlString += getJoinStr();
			sqlString += getWhereStr(getJoinStr(),"all");
			sqlString += getGroupByStr("all");
			sqlString += getOrderByStr("all");
			sqlString += getLimitStr();
			return sqlString;
		} catch (Exception e) {
			log.error("exception in getSQL()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getScreenSQL(String xmlString) {
		try {
			xmlDoc = xmlCon.toXMLDocument(xmlString);
			String sqlString = "";
			sqlString += getSelectStr("use_flg");
			sqlString += getFromStr();
//			sqlString += getJoinStr();
			sqlString += getWhereStr(getJoinStr(),"use_flg");
			sqlString += getGroupByStr("use_flg");
			sqlString += getOrderByStr("use_flg");
			sqlString += getLimitStr();
			return sqlString;
		} catch (Exception e) {
			log.error("exception in getScreenSQL()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public Document readFile(String filepath) {
		try {
			xmlDoc = xmlCon.readFile(filepath);
			return xmlDoc;
		} catch (Exception e) {
			log.error("exception in readFile()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getSelectStr(String kind) {
		try {
			String strSelect = "select "+"\n";
			Node xmlNode = xmlCon.selectSingleNode(xmlDoc,"//db_table");
			NodeList nodelist=null;
			Node tempNode = null;

			if(kind.equals("all")){
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@dispflg='true']");
			}else if(kind.equals("use_flg")){
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@dispflg='true' and @use_flg='1']");
			}
//System.out.println(nodelist.getLength());
			for(int i=0;i<nodelist.getLength();i++){
				//Sortが効かないので、番号がついている属性を指定して、SelectSingleNodeする。
				if(kind.equals("all")){
					tempNode = nodelist.item(i);
				}else if(kind.equals("use_flg")){
					tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+i+"' and @dispflg='true' and @use_flg='1']");
				}
//System.out.println(tempNode);
				if(tempNode!=null){//同じ名前が重なる場合はNullとなる。
					if(strSelect.equals("select "+"\n")){
						strSelect += "     " + xmlCon.selectSingleNode(tempNode,".//sql").getFirstChild().getNodeValue();
						strSelect += " as " + xmlCon.selectSingleNode(tempNode,".//name").getFirstChild().getNodeValue()+"\n";
					}else{
						strSelect += "    ," + xmlCon.selectSingleNode(tempNode,".//sql").getFirstChild().getNodeValue();
						strSelect += " as " + xmlCon.selectSingleNode(tempNode,".//name").getFirstChild().getNodeValue()+"\n";
					}
				}
			}
			return strSelect;
		} catch (Exception e) {
			log.error("exception in getSelectStr()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getFromStr() {
		try {
			String strFrom = "from "+"\n";
			Node xmlNode = xmlCon.selectSingleNode(xmlDoc,"//db_table");
			NodeList nodelist = xmlCon.selectNodes(xmlNode,"//db_table");

			for(int i=0;i<nodelist.getLength();i++){
				if(i==0){
					strFrom += "     " + ((Element)nodelist.item(i)).getAttribute("name")+"\n";
				}else{
					strFrom += "    ," + ((Element)nodelist.item(i)).getAttribute("name")+"\n";
				}
			}
			return strFrom;
		} catch (Exception e) {
			log.error("exception in getFromStr()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getWhereStr(String whereStr,String kind) {
		try {
			String strWhere = "";
			if(whereStr==""){
//				strWhere = "where 'mode'!='viewer' "+"\n";
				strWhere = "where 1=1 "+"\n";
			}else{
				strWhere = whereStr;
			}

			Node xmlNode = xmlCon.selectSingleNode(xmlDoc,"//db_table");
			NodeList nodelist = null;

			if(kind.equals("all")){
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/where_clause/logical_condition");
			}else if(kind.equals("use_flg")){
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/where_clause/logical_condition[@use_flg='1']");
			}

			//条件が１つもなかったら、Whereを削除して、Return
			if (nodelist.getLength()==0){
				return whereStr;
			}

			//@が入っている場合は、サンプルSQLでは、コメントにする。
			//実際に発行する場合は、ここを置き換えて条件を入れる。
			String sqlStr="";
			int whereCnt = 0;
			for(int i=0;i<nodelist.getLength();i++){
				if(i==0){
					if(whereStr==""){
						sqlStr = "    and " + xmlCon.selectSingleNode(nodelist.item(i),".//sql").getFirstChild().getNodeValue()+"\n";
					}else{
						sqlStr = "    and " + xmlCon.selectSingleNode(nodelist.item(i),".//sql").getFirstChild().getNodeValue()+"\n";
					}
					if (sqlStr.indexOf("@")==-1){
						strWhere += sqlStr;
						whereCnt++;
					}else{
						strWhere += "--" + sqlStr;
					}
				}else{
					sqlStr = "    and " + xmlCon.selectSingleNode(nodelist.item(i),".//sql").getFirstChild().getNodeValue()+"\n";
					if (sqlStr.indexOf("@")==-1){
						strWhere += sqlStr;
						whereCnt++;
					}else{
						strWhere += "--" + sqlStr;
					}
				}
			}
			//全部@が入っている場合は、Whereもコメントにする。
//			if (whereCnt==0){
//				strWhere = "-- " + strWhere;
//			}

			return strWhere;
		} catch (Exception e) {
			log.error("exception in getWhereStr()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getJoinStr() {
		try {
//			String strJoin = "where 'mode'!='viewer' "+"\n";
			String strJoin = "where 1=1 "+"\n";
			Node xmlNode = xmlCon.selectSingleNode(xmlDoc,"//RDBModel");
			NodeList nodelist = xmlCon.selectNodes(xmlNode,"//RDBModel/joins/join");

			for(int i=0;i<nodelist.getLength();i++){//複数Table用のループ
//				xmlCon.selectSingleNode(nodelist.item(i),"//table1");
				if(i==0){
					strJoin += "    and " + getJoinTableStr(nodelist.item(i))+"\n";
				}else{
					strJoin += "    and " + getJoinTableStr(nodelist.item(i))+"\n";
				}
			}
			return strJoin;
		} catch (Exception e) {
			log.error("exception in getJoinStr()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getJoinTableStr(Node node) {
		try {
			//複数カラムJoin用のLoop
			String strJoin = "";
			String tableName1 = "";
			String tableName2 = "";

			Node tableNode1 = xmlCon.selectSingleNode(node,".//table1");
			tableName1 =((Element)tableNode1).getAttribute("tablename");
			Node tableNode2 = xmlCon.selectSingleNode(node,".//table2");
			tableName2 =((Element)tableNode2).getAttribute("tablename");

			NodeList columList1 = xmlCon.selectNodes(tableNode1,".//join_column");
			NodeList columList2 = xmlCon.selectNodes(tableNode2,".//join_column");

			for(int i=0;i<columList1.getLength();i++){//複数Table用のループ
				if(i==0){
					strJoin += "";
				}else{
					strJoin += "\n"+"    and ";
				}
				strJoin += tableName1+"."+xmlCon.selectSingleNode(columList1.item(i),".").getFirstChild().getNodeValue();
				strJoin += " = " + tableName2+"."+xmlCon.selectSingleNode(columList2.item(i),".").getFirstChild().getNodeValue();
			}

			return strJoin;
		} catch (Exception e) {
			log.error("exception in getJoinTableStr()：\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getGroupByStr(String kind) {
		try {
			String strGroupBy = "group by "+"\n";
			Node xmlNode = xmlCon.selectSingleNode(xmlDoc,"//db_table");
			NodeList nodelist = null;
			Node tempNode=null;

			//Selectに属するものをまとめて取得（絞り込みは、下のSort処理部分で。）
			if(kind.equals("all")){
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@groupbyflg='true']");//
			}else if(kind.equals("use_flg")){
				//修正
//				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@use_flg='1']");//@groupbyflg='true' and 
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@groupbyflg='true' and @use_flg='1']");//
			}
//System.out.println(nodelist.getLength());

			if(nodelist.getLength()==0){//無い場合は、何も返さない（FactTable用）
				return "";
			}

			boolean first_flg=true;
			int plusNum=0;//Sort番号が飛び順になる場合。
//System.out.println(nodelist.getLength());
			for(int i=0;i<nodelist.getLength();i++){
//System.out.println(xmlCon.toXMLText(nodelist.item(i)));
				//Sortが効かないので、番号がついている属性を指定して、SelectSingleNodeする。
				if(kind.equals("all")){
					tempNode = nodelist.item(i);
				}else if(kind.equals("use_flg")){
//System.out.println("Null"+i);
//System.out.println("Plus"+plusNum);
					tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+(i+plusNum)+"' and @groupbyflg='true' and @use_flg='1']");
					if(tempNode==null){
							plusNum++;
							tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+(i+plusNum)+"' and @groupbyflg='true' and @use_flg='1']");
						for(;plusNum<1000 && tempNode==null;plusNum++){
							tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+(i+plusNum)+"' and @groupbyflg='true' and @use_flg='1']");
						}
					}
//System.out.println(plusNum+i);
//System.out.println(xmlCon.toXMLText(tempNode));
//System.out.println("後Null"+i);
//System.out.println("後Plus"+plusNum);
				}
				if(tempNode!=null){
					if(first_flg==true){
						strGroupBy += "     " + xmlCon.selectSingleNode(tempNode,".//sql").getFirstChild().getNodeValue()+"\n";
						first_flg=false;
					}else{
						strGroupBy += "    ," + xmlCon.selectSingleNode(tempNode,".//sql").getFirstChild().getNodeValue()+"\n";
					}
//System.out.println(strGroupBy);
				}
			}
			return strGroupBy;
		} catch (Exception e) {
			log.error("exception in getOrderByStr()：\n", e);
			e.printStackTrace();
		}
		return null;
	}


	public String getOrderByStr(String kind) {
		try {
			String strOrderBy = "order by "+"\n";
			Node xmlNode = xmlCon.selectSingleNode(xmlDoc,"//db_table");
			NodeList nodelist = null;
			Node tempNode=null;

			if(kind.equals("all")){
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@groupbyflg='true']");//
			}else if(kind.equals("use_flg")){
//				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@use_flg='1']");//@groupbyflg='true' and 
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@groupbyflg='true' and @use_flg='1']");//
			}

			if(nodelist.getLength()==0){//無い場合は、何も返さない（FactTable用）
				return "";
			}

			boolean first_flg=true;
			int plusNum=0;//Sort番号が飛び順になる場合。
			for(int i=0;i<nodelist.getLength();i++){
				if(kind.equals("all")){
					tempNode = nodelist.item(i);
				//Sortが効かないので、番号がついている属性を指定して、SelectSingleNodeする。
				}else if(kind.equals("use_flg")){
					tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+(i+plusNum)+"' and @groupbyflg='true' and @use_flg='1']");
					if(tempNode==null){
							plusNum++;
							tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+(i+plusNum)+"' and @groupbyflg='true' and @use_flg='1']");
						for(;plusNum<1000 && tempNode==null;plusNum++){
							tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+(i+plusNum)+"' and @groupbyflg='true' and @use_flg='1']");
						}
					}

				}
				if(tempNode!=null){
					if(first_flg==true){
						strOrderBy += "     " + xmlCon.selectSingleNode(tempNode,".//sql").getFirstChild().getNodeValue()+"\n";
						first_flg=false;
					}else{
						strOrderBy += "    ," + xmlCon.selectSingleNode(tempNode,".//sql").getFirstChild().getNodeValue()+"\n";
					}
				}
			}
			return strOrderBy;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String getLimitStr() {
		try {
			String strFrom = " limit 10000 "+"\n";
			return strFrom;
		} catch (Exception e) {
			log.error("exception in getLimitStr()：\n", e);
			e.printStackTrace();
		}
		return null;
	}


}
