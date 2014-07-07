<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>
<% 
	String errorMessage = request.getParameter("errorMessage");
	String backButtonDisableFLG = request.getParameter("backButtonDisableFLG");

%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<TITLE><%=(String)session.getValue("aplName")%></TITLE>
	<link rel="stylesheet" type="text/css" href="../css/common.css">
</HEAD>
<BODY style="text-align:center">
<table style="margin-top:80">
	<tr>
		<td style="background:url('../images/msg_window.jpg') no-repeat;width:400;height:277;vertical-align:top">
			<div style="margin-left:25;margin-top:25;color:white;font-weight:bold">内部エラーが発生しました</div>
			<div style="margin-left:45;margin-top:90;color:black">
				<%
					if ( (errorMessage != null) && (errorMessage != "") ) {
				%>
						<DIV align="left" style="margin: 10px; padding: 10px; "><%= errorMessage %></DIV>
				<%
					}
				%>
			</div>
		</td>
	</tr>
</table>

<div class="command">
	<%
		if (!"1".equals(backButtonDisableFLG) ) {
	%>
		<input type="button" name="bk_btn" value="" onClick="window.open('../login.jsp','_top')" class="normal_back" onMouseOver="className='over_back'" onMouseDown="className='down_back'" onMouseUp="className='up_back'" onMouseOut="className='out_back'">
	<%
		}
	%>
</div>

</BODY>

</HTML>