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

	/** ���M���O�I�u�W�F�N�g */
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
			log.error("exception in getTableSQL()�F\n", e);
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
			log.error("exception in getSQL()�F\n", e);
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
			log.error("exception in getScreenSQL()�F\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public Document readFile(String filepath) {
		try {
			xmlDoc = xmlCon.readFile(filepath);
			return xmlDoc;
		} catch (Exception e) {
			log.error("exception in readFile()�F\n", e);
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
				//Sort�������Ȃ��̂ŁA�ԍ������Ă��鑮�����w�肵�āASelectSingleNode����B
				if(kind.equals("all")){
					tempNode = nodelist.item(i);
				}else if(kind.equals("use_flg")){
					tempNode = xmlCon.selectSingleNode(xmlDoc,"//db_table/logical_model/select_clause/logical_column[@use_order='"+i+"' and @dispflg='true' and @use_flg='1']");
				}
//System.out.println(tempNode);
				if(tempNode!=null){//�������O���d�Ȃ�ꍇ��Null�ƂȂ�B
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
			log.error("exception in getSelectStr()�F\n", e);
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
			log.error("exception in getFromStr()�F\n", e);
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

			//�������P���Ȃ�������AWhere���폜���āAReturn
			if (nodelist.getLength()==0){
				return whereStr;
			}

			//@�������Ă���ꍇ�́A�T���v��SQL�ł́A�R�����g�ɂ���B
			//���ۂɔ��s����ꍇ�́A������u�������ď���������B
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
			//�S��@�������Ă���ꍇ�́AWhere���R�����g�ɂ���B
//			if (whereCnt==0){
//				strWhere = "-- " + strWhere;
//			}

			return strWhere;
		} catch (Exception e) {
			log.error("exception in getWhereStr()�F\n", e);
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

			for(int i=0;i<nodelist.getLength();i++){//����Table�p�̃��[�v
//				xmlCon.selectSingleNode(nodelist.item(i),"//table1");
				if(i==0){
					strJoin += "    and " + getJoinTableStr(nodelist.item(i))+"\n";
				}else{
					strJoin += "    and " + getJoinTableStr(nodelist.item(i))+"\n";
				}
			}
			return strJoin;
		} catch (Exception e) {
			log.error("exception in getJoinStr()�F\n", e);
			e.printStackTrace();
		}
		return null;
	}

	public String getJoinTableStr(Node node) {
		try {
			//�����J����Join�p��Loop
			String strJoin = "";
			String tableName1 = "";
			String tableName2 = "";

			Node tableNode1 = xmlCon.selectSingleNode(node,".//table1");
			tableName1 =((Element)tableNode1).getAttribute("tablename");
			Node tableNode2 = xmlCon.selectSingleNode(node,".//table2");
			tableName2 =((Element)tableNode2).getAttribute("tablename");

			NodeList columList1 = xmlCon.selectNodes(tableNode1,".//join_column");
			NodeList columList2 = xmlCon.selectNodes(tableNode2,".//join_column");

			for(int i=0;i<columList1.getLength();i++){//����Table�p�̃��[�v
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
			log.error("exception in getJoinTableStr()�F\n", e);
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

			//Select�ɑ�������̂��܂Ƃ߂Ď擾�i�i�荞�݂́A����Sort���������ŁB�j
			if(kind.equals("all")){
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@groupbyflg='true']");//
			}else if(kind.equals("use_flg")){
				//�C��
//				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@use_flg='1']");//@groupbyflg='true' and 
				nodelist = xmlCon.selectNodes(xmlNode,"//db_table/logical_model/select_clause/logical_column[@groupbyflg='true' and @use_flg='1']");//
			}
//System.out.println(nodelist.getLength());

			if(nodelist.getLength()==0){//�����ꍇ�́A�����Ԃ��Ȃ��iFactTable�p�j
				return "";
			}

			boolean first_flg=true;
			int plusNum=0;//Sort�ԍ�����я��ɂȂ�ꍇ�B
//System.out.println(nodelist.getLength());
			for(int i=0;i<nodelist.getLength();i++){
//System.out.println(xmlCon.toXMLText(nodelist.item(i)));
				//Sort�������Ȃ��̂ŁA�ԍ������Ă��鑮�����w�肵�āASelectSingleNode����B
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
//System.out.println("��Null"+i);
//System.out.println("��Plus"+plusNum);
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
			log.error("exception in getOrderByStr()�F\n", e);
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

			if(nodelist.getLength()==0){//�����ꍇ�́A�����Ԃ��Ȃ��iFactTable�p�j
				return "";
			}

			boolean first_flg=true;
			int plusNum=0;//Sort�ԍ�����я��ɂȂ�ꍇ�B
			for(int i=0;i<nodelist.getLength();i++){
				if(kind.equals("all")){
					tempNode = nodelist.item(i);
				//Sort�������Ȃ��̂ŁA�ԍ������Ă��鑮�����w�肵�āASelectSingleNode����B
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
			log.error("exception in getLimitStr()�F\n", e);
			e.printStackTrace();
		}
		return null;
	}


}
