/*
 * çÏê¨ì˙: 2004/11/25
 */
package openolap.viewer.common;

/**
 *
 */
public class StringTool {
	String[] divXMLStr=null;
	String[] divSQLStr=null;
	String XMLString;
	int strCount=0;

	String dataMarkStr = "%%";
	String repeatMarkStr = "--";


	public StringTool(String XMLStr) {
		divXMLStr=new String[100];
		divSQLStr=new String[100];
		for (int i=0;i<100;i++){divXMLStr[i] = "";}
		for (int i=0;i<100;i++){divSQLStr[i] = "";}

		XMLString = XMLStr;
//		XMLString=removeRepeatMark(XMLString);//Ç®ÇªÇÁÇ≠égópÇµÇ»Ç¢
		divStr(XMLString);
	}

//********************************************************************************
	public String removeRepeatMark(String XMLString) {
		String tmpStr="";
		String retStr=XMLString;
		int strXMLLength=0;

		strXMLLength = retStr.indexOf(repeatMarkStr);
//System.out.println(strXMLLength);

		while(strXMLLength!=-1){
			tmpStr=retStr.substring(0,strXMLLength);
//System.out.println(tmpStr);
			tmpStr+=retStr.substring(retStr.indexOf(repeatMarkStr,strXMLLength+2)+2);
//System.out.println(tmpStr);

			retStr = tmpStr;
			strXMLLength = retStr.indexOf(repeatMarkStr);
//System.out.println(strXMLLength);
		}
		return retStr;
	}
//********************************************************************************
	public void divStr(String XMLString) {
		String tmpStr="";
		int strXMLLength=0;
		int strSQLLength=0;
		int divStrLength=2;//[%%]
		tmpStr=XMLString;
		for(int i=0;i<100;i++){
			strXMLLength = tmpStr.indexOf(dataMarkStr);
//System.out.println(strXMLLength);
			strSQLLength = tmpStr.indexOf(dataMarkStr,strXMLLength+divStrLength);
//System.out.println(strSQLLength);

			if(strXMLLength!=-1){
				divXMLStr[i]=tmpStr.substring(0,strXMLLength);
//System.out.println(divXMLStr[i]);
			}else{
				divXMLStr[i]=tmpStr;
				strCount=i;
				return;
			}
			if(strSQLLength!=-1){
				divSQLStr[i]=tmpStr.substring(strXMLLength+divStrLength,strSQLLength);
//System.out.println(divSQLStr[i]);
			}

			tmpStr=tmpStr.substring(strSQLLength+divStrLength);
//System.out.println(tmpStr);

		}
	}
//********************************************************************************

//********************************************************************************
	public String[] getXMLString() {
		return divXMLStr;
	}
	public String[] getSQLString() {
		return divSQLStr;
	}
	public int getdivCount() {
		return strCount;
	}
//********************************************************************************

	public String dispStr(){
		String tmpStr="";
		for(int i=0;i<100;i++){
			tmpStr+=divXMLStr[i];
			tmpStr+=divSQLStr[i];
		}
		return tmpStr;
	}

}
