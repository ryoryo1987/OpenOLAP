<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.*,java.lang.*,java.io.*,java.sql.*,openolap.viewer.Report,openolap.viewer.Axis,openolap.viewer.AxisMember"
 %>
<%

	String targetAxisID = request.getParameter("dimNumber");
	Report report = (Report)session.getAttribute("report");

	//軸は検索で見つかったメンバのみを持つ
	Axis axis = report.getAxisByID(targetAxisID);
	Iterator axisMemIt = axis.getAxisMemberList().iterator();

	String selectedMemberIDList = "";
	int i = 0;
	while ( axisMemIt.hasNext() ) {
		if (i > 0) {
			selectedMemberIDList += ",";
		}
		AxisMember axisMember = (AxisMember) axisMemIt.next();
		selectedMemberIDList += axisMember.getUniqueName();
		i++;
	}
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
		<title><%=(String)session.getValue("aplName")%></title>
	</head>
	<body onload="init();">
	</body>
</html>

<script>
	var selectedMemberIDList = '<%= selectedMemberIDList %>';

	function init() {

		// 「選択可能なメンバー欄」に検索されたメンバを表示
		var selectedMemberIDArray = null;
		if (selectedMemberIDList == "") {
			selectedMemberIDArray = new Array();
		} else {
			selectedMemberIDArray = selectedMemberIDList.split(",");
		}
		parent.frm_body.memberFocus(selectedMemberIDArray);

	}

</script>