<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%
request.setCharacterEncoding("Shift_JIS");
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title>OpenOLAP Model Designer</title>
<link rel='stylesheet' type='text/css' href='./jsp/css/common.css'>
</head>
<body bgcolor="red">
<div align="center">
<table style="width:500px;margin:50 0 0 0;border-collapse:collapse;border-style:none">
	<tr>
		<td style="width:27px;height:20px;background:url('images/err_title_l.gif') no-repeat #0D33BE;padding:0"></td>
	<td style="background:url('images/err_title_m.gif') repeat-x #0D33BE;font-weight:bold;color:white;padding:0">
			<%="ログイン失敗"%>
		</td>
		<td style="width:6px;height:20px;background:url('images/err_title_r.gif') no-repeat #0D33BE;padding:0"></td>
	</tr>
</table>
<table style="width:500px;margin:0 0 50 0;border-collapse:collapse">
	<tr>
		<td style="padding:50 20 50 20;border:#000099 1px solid">
			<%
				String errMsg="";
				errMsg = request.getParameter("errMsg");
				if("1".equals(request.getParameter("errNum"))){
					errMsg+="スキーマは存在しません";
				}else if("2".equals(request.getParameter("errNum"))){
					errMsg+="はOpenOLAPのメタスキーマではありません";
				}else if("3".equals(request.getParameter("errNum"))){
					errMsg+="はOpenOLAPのメタユーザーではありません";
				}
				out.print(errMsg);
			%>

		</td>
	</tr>
</table>


<div class="command">
	<input type="button" name="bk_btn" value="" onClick="window.open('login.jsp','_self')" class="normal_back" onMouseOver="className='over_back'" onMouseDown="className='down_back'" onMouseUp="className='up_back'" onMouseOut="className='out_back'">
</div>
</div>
</body>
<html>

