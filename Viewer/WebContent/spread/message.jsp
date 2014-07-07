<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.ArrayList,java.util.Iterator,openolap.viewer.Report,openolap.viewer.Dimension"
%>
<%
	String message = (String) request.getAttribute("message");
%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<TITLE><%=(String)session.getValue("aplName")%></TITLE>
	<link rel="stylesheet" type="text/css" href="./css/common.css">
</HEAD>
<BODY style="text-align:center">
<table style="margin-top:80">
	<tr>
		<td style="background:url('images/msg_window.jpg') no-repeat;width:400;height:277">
			<div style="margin-left:45;color:black">
				<%= message %>
			</div>
		</td>
	</tr>
</table>

<div class="command">
	<input type="button" name="bk_btn" value="" onClick="window.open('login.jsp','_top')" class="normal_back" onMouseOver="className='over_back'" onMouseDown="className='down_back'" onMouseUp="className='up_back'" onMouseOut="className='out_back'">
</div>


</BODY>

</HTML>