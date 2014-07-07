<%@ page import = "java.sql.*"%><%@ page import = "java.util.*"%><%@ page import = "openolap.viewer.dao.DAOFactory"%><%!

	public static String replace(String strTarget, String strOldStr, String strOldNew){
	    String strSplit[];
	    String strResult;

	    strSplit = split(strTarget, strOldStr);
	    strResult = strSplit[0];
	    for (int i = 1; i < strSplit.length; i ++){
	        strResult += strOldNew + strSplit[i];
	    }

	    return strResult;
	}

	private static String[] split(String strTarget, String strDelimiter){
	    String strResult[];
	    Vector objResult;
	    int intDelimiterLen;
	    int intStart;
	    int intEnd;

	    objResult = new java.util.Vector();
	    strTarget += strDelimiter;
	    intDelimiterLen = strDelimiter.length();
	    intStart = 0;
	    while ((intEnd = strTarget.indexOf(strDelimiter, intStart)) >= 0){
	        objResult.addElement(strTarget.substring(intStart, intEnd));
	        intStart = intEnd + intDelimiterLen;
	    }

	    strResult = new String[objResult.size()];
	    objResult.copyInto(strResult);
	    return strResult;
	}


%><% 

//Session変数をチェック　セッション切れの場合はログインページへ飛ばす
if(session.getAttribute("user")==null){
//	String strDelete = request.getServletPath().substring(request.getServletPath().indexOf("/",1));
	String strDelete = request.getServletPath();
	String strFullUrl = ""+request.getRequestURL();
	String strLoginUrl=replace(strFullUrl,strDelete,"/timeout.jsp");

			response.sendRedirect(strLoginUrl);
			return;


//	out.println("<script language='JavaScript'>");
//	out.println("window.top.location.href='" + strLoginUrl + "';");
//	out.println("</script>");
}



request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない


Connection conn = null;
Statement stmt = null;
Statement stmt2 = null;

try {

DAOFactory daoFactory = DAOFactory.getDAOFactory();
conn = daoFactory.getConnection((String)request.getSession().getAttribute("connectionPoolName"),(String)request.getSession().getAttribute("searchPathName"));
stmt = conn.createStatement();
stmt2 = conn.createStatement();

ResultSet rs =null;
ResultSet rs2 =null;


%>