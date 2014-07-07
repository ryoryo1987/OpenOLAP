<%@ page language="java"
	contentType="text/xml;charset=Shift_JIS"
	import="java.util.*,java.io.*,openolap.viewer.Report,openolap.viewer.Color,org.apache.log4j.Logger;"
%><%!

// ********************************************************
// Function
// ********************************************************
	private StringBuffer setColorInfo( ArrayList colorList) throws IOException {

		StringBuffer outTempString = new StringBuffer(512);
		Iterator colorIt = colorList.iterator();

		while (colorIt.hasNext()) {
			Color color = (Color) colorIt.next();
			outTempString.append("<Color>");

				TreeMap indexTree = color.getAxisIDAndMemberKeyMap();
				Iterator indexIt = indexTree.keySet().iterator();
				outTempString.append("<Coordinates>");
				while (indexIt.hasNext()) {
					Integer axisId = (Integer) indexIt.next();
					outTempString.append("<Axis id='" + axisId + "'>");
						outTempString.append("<Key>" + (String)indexTree.get(axisId) + "</Key>");
					outTempString.append("</Axis>");
				}
				outTempString.append("</Coordinates>");

				// HTMLColor
				outTempString.append("<HTMLColor>");
					outTempString.append(color.getHtmlColor());
				outTempString.append("</HTMLColor>");
			outTempString.append("</Color>");
		}

		return outTempString;
	
	}

%><%

	// ColorXML������̊i�[�p�I�u�W�F�N�g
	StringBuffer outString = new StringBuffer(512);

	/** ���M���O�I�u�W�F�N�g */
	Logger log = Logger.getLogger(colorInfo_jsp.class.getName());

	Report report = (Report)session.getAttribute("report");
	ArrayList headerColorList = report.getHeaderColorList();
	ArrayList spreadColorList = report.getSpreadColorList();

	outString.append("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
	outString.append("<ColorInfo>");
		outString.append("<HeaderColor>");
			outString.append(setColorInfo(headerColorList));
		outString.append("</HeaderColor>");

		outString.append("<SpreadColor>");
			outString.append(setColorInfo(spreadColorList));
		outString.append("</SpreadColor>");

	outString.append("</ColorInfo>");

	// XML�o��
	out.println(outString.toString());
	if(log.isInfoEnabled()) { // ���O�o��
		log.info("XML(cell color)�F\n" + outString.toString());
	}

	// �I������
	outString = null;
%>
