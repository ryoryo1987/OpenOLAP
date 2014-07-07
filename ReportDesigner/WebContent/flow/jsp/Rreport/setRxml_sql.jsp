<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ page import="openolap.viewer.PostgreSqlGenerator" %>
<%
request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない
%>

<%
	PostgreSqlGenerator sqlGene = new PostgreSqlGenerator();
	String strSQL = "";
//out.println(request.getParameter("status"));
	if(request.getParameter("sqlXml")!=null){
		if(("last").equals(request.getParameter("status"))){
			if(("1").equals(request.getParameter("sql_customized_flg"))){
				strSQL = request.getParameter("strSQL");
			}else{
				strSQL = sqlGene.getScreenSQL(request.getParameter("sqlXml"));
			}
		}else{//SQL表示の場合
			strSQL = sqlGene.getScreenSQL(request.getParameter("sqlXml"));
		}
	}

	String screenXML = "";
	if(request.getParameter("screenXML")!=null){
		screenXML = request.getParameter("screenXML");
	}

	String screenXSL1 = "";
	if(request.getParameter("cssXML1")!=null){
		screenXSL1 = request.getParameter("cssXML1");
	}
	String screenXSL2 = "";
	if(request.getParameter("cssXML2")!=null){
		screenXSL2 = request.getParameter("cssXML2");
	}
	String screenXSL3 = "";
	if(request.getParameter("cssXML3")!=null){
		screenXSL3 = request.getParameter("cssXML3");
	}
	String screenXSL4 = "";
	if(request.getParameter("cssXML4")!=null){
		screenXSL4 = request.getParameter("cssXML4");
	}
	String screenXSL5 = "";
	if(request.getParameter("cssXML5")!=null){
		screenXSL5 = request.getParameter("cssXML5");
	}
	String screenXSL6 = "";
	if(request.getParameter("cssXML6")!=null){
		screenXSL6 = request.getParameter("cssXML6");
	}

	request.getSession().setAttribute("Rsql",strSQL);
	request.getSession().setAttribute("RsourceXML",screenXML);

	String sqlXML = request.getParameter("sqlXml");
	request.getSession().setAttribute("sqlXML",sqlXML);

	request.getSession().setAttribute("screenXSL1",screenXSL1);
	request.getSession().setAttribute("screenXSL2",screenXSL2);
	request.getSession().setAttribute("screenXSL3",screenXSL3);
	request.getSession().setAttribute("screenXSL4",screenXSL4);
	request.getSession().setAttribute("screenXSL5",screenXSL5);
	request.getSession().setAttribute("screenXSL6",screenXSL6);

%>


<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS" />
<link rel="stylesheet" type="text/css" href="../../../css/common.css">
<title><%=(String)session.getValue("aplName")%></title>
</head>
<script type="text/JavaScript1.2">
function load(){
<%if(("last").equals(request.getParameter("status"))){%>
	//sample execute
	parent.document.body.rows = "36,*,0";

	document.form_main.target="frm_result_view";
	document.form_main.action="dispFrm.jsp?kind=session"
	document.form_main.submit();
<%}%>
}
</script>
<body>
<form name="form_main" id="form_main" target="navi_frm" method="post" action="">


<div class="explain" style="margin-top:20;text-align:center">
	レポートのサンプルを確認する場合は[サンプル実行]ボタンを押してください。サンプルの確認が必要ない場合は、[OK]ボタンを押してください。
</div>
<div style="margin:20;width:100%;text-align:center">
<input type='button' value='' onclick='load()' class="normal_sample" onClick="javaScript:regist(1);" onMouseOver="className='over_sample'" onMouseDown="className='down_sample'" onMouseUp="className='up_sample'" onMouseOut="className='out_sample'">
</div>

<div style='display:none'>
	<textarea name="sqlXML" id='sqlXML' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("sqlXML"));%>
	</textarea>

	<textarea name="sqlText" id='sqlText' cols="150" rows="20">
	<%out.println(request.getSession().getAttribute("Rsql"));%>
	</textarea>

	<textarea name="screenXML" id='screenXML' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("RsourceXML"));%>
	</textarea>

	<textarea name="screenXSL1" id='screenXSL1' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("screenXSL1"));%>
	</textarea>

	<textarea name="screenXSL2" id='screenXSL2' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("screenXSL2"));%>
	</textarea>

	<textarea name="screenXSL3" id='screenXSL3' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("screenXSL3"));%>
	</textarea>

	<textarea name="screenXSL4" id='screenXSL4' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("screenXSL4"));%>
	</textarea>

	<textarea name="screenXSL5" id='screenXSL5' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("screenXSL5"));%>
	</textarea>

	<textarea name="screenXSL6" id='screenXSL6' cols="150" rows="20">
	<%//out.println(request.getSession().getAttribute("screenXSL6"));%>
	</textarea>
</div>

<input type='hidden' id='sqlhid' name='sqlhid' value=''>

</form>
</body>
</html>

