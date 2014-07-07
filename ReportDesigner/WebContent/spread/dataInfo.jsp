<%@ page language="java"
	contentType="text/xml;charset=Shift_JIS"
	import="java.util.*,openolap.viewer.Report,openolap.viewer.CellData,openolap.viewer.EdgeCoordinates,openolap.viewer.common.CommonSettings,org.apache.log4j.Logger;"
%><%!
// ********************************************************
// Function
// ********************************************************

%><%

	/** ロギングオブジェクト */
	Logger log = Logger.getLogger(dataInfo_jsp.class.getName());

//	Date startDate = new Date();
//	long startMills = startDate.getTime();

	Report report = (Report)session.getAttribute("report");
	ArrayList cellDataList = (ArrayList)request.getAttribute("cellDataList");

if(cellDataList == null ) {
	throw new IllegalStateException("セッションにcellDataListが存在しない。in dataInfo.jsp");
}

	// CellValueデータ格納XMLに、軸のIDとKeyの情報を含めるかの設定を取得
	CommonSettings commonSettings = (CommonSettings)getServletConfig().getServletContext().getAttribute("apCommonSettings");
	boolean valueXmlContainsAxesInfo = commonSettings.getValueXmlContainsAxesInfo();


	StringBuffer outString = new StringBuffer(1024);
	outString.append("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
	outString.append("<CellDataInfo>");

	Iterator it = cellDataList.iterator();

	while (it.hasNext()) {
		CellData cellData = (CellData) it.next();
		EdgeCoordinates colCordinates = cellData.getColCoordinates();
		LinkedHashMap   colIdKeyMap   = colCordinates.getAxisIdMemKeyMap();
		EdgeCoordinates rowCordinates = cellData.getRowCoordinates();
		LinkedHashMap   rowIdKeyMap   = rowCordinates.getAxisIdMemKeyMap();

		outString.append("<Cell>");
			outString.append("<Col>");
				outString.append("<Index>");
					outString.append(colCordinates.getIndex());
				outString.append("</Index>");

				if(valueXmlContainsAxesInfo) {
					outString.append("<Axes>");
						Iterator colIt = colIdKeyMap.keySet().iterator();
						while (colIt.hasNext()) {
							Integer key = (Integer) colIt.next();
							outString.append("<Axis id='" + key  + "'>");
								outString.append("<Key>" + (String)colIdKeyMap.get(key) + "</Key>");
							outString.append("</Axis>");
						}
					outString.append("</Axes>");
				}

			outString.append("</Col>");
			outString.append("<Row>");
				outString.append("<Index>");
					outString.append(rowCordinates.getIndex());
				outString.append("</Index>");

				if(valueXmlContainsAxesInfo) {
					outString.append("<Axes>");
						Iterator rowIt = rowIdKeyMap.keySet().iterator();
						while (rowIt.hasNext()) {
							Integer key = (Integer) rowIt.next();
							outString.append("<Axis id='" + key  + "'>");
								outString.append("<Key>" + (String)rowIdKeyMap.get(key) + "</Key>");
							outString.append("</Axis>");
						}
					outString.append("</Axes>");
				}

			outString.append("</Row>");
			outString.append("<Data>");
				outString.append("<Measure>");
					outString.append(cellData.getMeasureMemberUniqueName());
				outString.append("</Measure>");
				outString.append("<MeasureSeq>");
					outString.append(cellData.getMeasureSeq());
				outString.append("</MeasureSeq>");
				outString.append("<Value>");
					outString.append(cellData.getValue());
				outString.append("</Value>");
				outString.append("<Value2>");
					outString.append(cellData.getValue2());
				outString.append("</Value2>");
			outString.append("</Data>");
		outString.append("</Cell>");
	}

	outString.append("</CellDataInfo>");

	// XML出力
	out.println(outString.toString());
	if(log.isInfoEnabled()) {
		log.info("XML(cell data)：\n" + outString.toString());
	}


	// 初期化
	outString = null;
%>


