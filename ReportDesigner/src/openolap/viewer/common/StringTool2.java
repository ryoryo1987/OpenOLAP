/*
 * çÏê¨ì˙: 2004/11/25
 */
package openolap.viewer.common;

/**
 *
 */
public class StringTool2 {

	final public static String dataMarkStartStr = "<data>";
	final public static String dataMarkEndStr = "</data>";


//	String[] divXMLStr=null;
//	String[] divSQLStr=null;
	private String XMLString = null;
	private String beforeDataNodeString   = null;
	private String innerDataNodeString   = null;
	private String afterDataNodeString = null;
	
//	int strCount=0;

//	String repeatMarkStr = "--";


	public StringTool2(String XMLStr) {
//		divXMLStr=new String[100];
//		divSQLStr=new String[100];
//		for (int i=0;i<100;i++){divXMLStr[i] = "";}
//		for (int i=0;i<100;i++){divSQLStr[i] = "";}

		XMLString = XMLStr;
//		XMLString=removeRepeatMark(XMLString);//Ç®ÇªÇÁÇ≠égópÇµÇ»Ç¢
		divStr(XMLString);
	}

//********************************************************************************
//	public String removeRepeatMark(String XMLString) {
//		String tmpStr="";
//		String retStr=XMLString;
//		int strXMLLength=0;
//
//		strXMLLength = retStr.indexOf(repeatMarkStr);
////System.out.println(strXMLLength);
//
//		while(strXMLLength!=-1){
//			tmpStr=retStr.substring(0,strXMLLength);
////System.out.println(tmpStr);
//			tmpStr+=retStr.substring(retStr.indexOf(repeatMarkStr,strXMLLength+2)+2);
////System.out.println(tmpStr);
//
//			retStr = tmpStr;
//			strXMLLength = retStr.indexOf(repeatMarkStr);
////System.out.println(strXMLLength);
//		}
//		return retStr;
//	}
//********************************************************************************
	public void divStr(String XMLString) {

		int markStartPosition = XMLString.indexOf(dataMarkStartStr);
		int markEndPosition   = XMLString.indexOf(dataMarkEndStr, markStartPosition);
		int XMLStringLength   = XMLString.length();

//System.out.println(XMLString.length() - markEndPosition);
		
		String tmpBeforeString = XMLString.substring(0, markStartPosition);
		String tmpInnerString  = XMLString.substring(markStartPosition + dataMarkStartStr.length(), markEndPosition);
		String tmpAfterString  = XMLString.substring(markEndPosition + dataMarkEndStr.length());

		beforeDataNodeString   = trimStringOutsideTag(tmpBeforeString);
		innerDataNodeString    = trimStringOutsideTag(tmpInnerString);
		afterDataNodeString    = trimStringOutsideTag(tmpAfterString);

//System.out.println("markStartPosition:" + markStartPosition);
//System.out.println("markEndPosition:" + markEndPosition);
//System.out.println("beforeDataNodeString:" + beforeDataNodeString);
//System.out.println("innerDataNodeString:" + innerDataNodeString);
//System.out.println("afterDataNodeString:" + afterDataNodeString);
		

//		String tmpStr="";
//		int strXMLLength=0;
//		int strSQLLength=0;
//		int divStrLength=2;//[%%]
//		tmpStr=XMLString;
//		for(int i=0;i<100;i++){
//			strXMLLength = tmpStr.indexOf(dataMarkStr);
////System.out.println(strXMLLength);
//			strSQLLength = tmpStr.indexOf(dataMarkStr,strXMLLength+divStrLength);
////System.out.println(strSQLLength);
//
//			if(strXMLLength!=-1){
//				divXMLStr[i]=tmpStr.substring(0,strXMLLength);
////System.out.println(divXMLStr[i]);
//			}else{
//				divXMLStr[i]=tmpStr;
//				strCount=i;
//				return;
//			}
//			if(strSQLLength!=-1){
//				divSQLStr[i]=tmpStr.substring(strXMLLength+divStrLength,strSQLLength);
////System.out.println(divSQLStr[i]);
//			}
//
//			tmpStr=tmpStr.substring(strSQLLength+divStrLength);
////System.out.println(tmpStr);
//
//		}
	}
//********************************************************************************
	public String getBeforeDataNodeString() {
		return beforeDataNodeString;
	}

	public String getInnerDataNodeString() {
		return innerDataNodeString;
	}

	public String getAfterDataNodeString() {
		return afterDataNodeString;
	}

//	********************************************************************************
	private String trimStringOutsideTag(String str) {

		String result = str;
		result = result.substring(result.indexOf("<"));

		int lastIndex = result.lastIndexOf(">")+1;
		result = result.substring(0, lastIndex);
				
		return result;
	}


//********************************************************************************
//	public String[] getXMLString() {
//		return divXMLStr;
//	}
//	public String[] getSQLString() {
//		return divSQLStr;
//	}
//	public int getdivCount() {
//		return strCount;
//	}
//********************************************************************************
//
//	public String dispStr(){
//		String tmpStr="";
//		for(int i=0;i<100;i++){
//			tmpStr+=divXMLStr[i];
//			tmpStr+=divSQLStr[i];
//		}
//		return tmpStr;
//	}

}
