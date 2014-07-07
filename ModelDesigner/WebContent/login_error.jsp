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
<body style="text-align:center">
<table style="margin-top:80">
	<tr>
		<td style="background:url('images/msg_window.jpg') no-repeat;width:400;height:277;vertical-align:top">
			<div style="margin-left:25;margin-top:25;color:white;font-weight:bold"><%="ログイン失敗"%></div>
			<div style="margin-left:45;margin-top:90;color:black">
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
			</div>
		</td>
	</tr>
</table>


<div class="command">
	<input type="button" name="bk_btn" value="" onClick="window.open('login.jsp','_self')" class="normal_back" onMouseOver="className='over_back'" onMouseDown="className='down_back'" onMouseUp="className='up_back'" onMouseOut="className='out_back'">
</div>
</body>
<html>

