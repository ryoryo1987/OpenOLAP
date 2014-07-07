/*
 * 作成日: 2004/08/05
 *
 */
package openolap.viewer.chart;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;

import javax.naming.NamingException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.xpath.XPathExpressionException;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.CellData;
import openolap.viewer.Col;
import openolap.viewer.Dimension;
import openolap.viewer.DimensionMember;
import openolap.viewer.Measure;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.Row;
import openolap.viewer.XMLConverter;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.ChartMessages;
import openolap.viewer.common.StringUtil;
import openolap.viewer.common.TimeDimensionInfo;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

//import org.apache.crimson.tree.XmlDocument;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

/**
 * JFreeChart用のXMLドキュメントを生成するクラス
 */
public class ChartXMLCreator {

	// ********** インスタンス変数 **********

	private Connection conn = null;

	/** true の場合、複数シリーズを持つメジャーを作成中であることを示す。XML出力処理の最後にメジャー配置位置の復帰が必要である。 */
	private boolean creatingMultiSiriesChart = false;

	/** ChartType */
	private String chartType = null;

	/** レポートのメジャー配置場所
	 *　 メジャー配置位置の仮移動中は、Reportからもともとの場所が取得できないので、ここにあらかじめ仮保持する */
	String originalMeasureEdgePosition = null;

	// ********** static メソッド **********
	/**
	 * 与えられたチャートタイプが複数チャート（Seriesを複数持つチャート）である場合、
	 * trueを返し、それ以外の場合はfalseを返す
	 * @param chartType チャートタイプ
	 */
	static public boolean checkIsMultiChart(String chartType) {
		
		if (("VerticalMultiBar".equals(chartType)) ||
			 ("HorizontalMultiBar".equals(chartType)) ||
			 ("VerticalMulti3D_Bar".equals(chartType)) ||
			 ("HorizontalMulti3D_Bar".equals(chartType)) ||
			 ("MultiLine".equals(chartType)) ||
			 ("MultiArea".equals(chartType)) ||
			 ("MultiPie".equals(chartType)) ) {
			
			return true;		
		 } else {
			return false;
		 }
	}

	/**
	 * チャートXMLのファイルパスを戻す。
	 * @param helper RequestHelper
	 * @return チャートXMLのファイルパス
	 */
	static public String getChartXMLFilePath(RequestHelper helper) {

		// チャートタイプ名を取得
		String dirPath = helper.getRequest().getSession().getServletContext().getRealPath("/");
		String fileName = "spread/chart_kind.xml";
	
		return dirPath + "/" + fileName;

	}

	// ********** メソッド **********

	/**
	 * チャートIDに対応するチャート名(XMLタグ名)を取得する
	 * チャートIDとしてNAが渡された場合は、チャートXMLでデフォルト属性がtrueであるチャート要素の名称を戻す。
	 * @param chartXMLFile チャート情報を格納したXMLファイルのパス
	 * @param chartID
	 * @return チャート名
	 */
	public String chartIdToName(String chartXMLFile, String chartID) throws ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {

		XMLConverter xmlConverter = new XMLConverter();
		Document doc = xmlConverter.readFile(chartXMLFile);

		Node chartNode = null;
		if ("NA".equals(chartID)) {
			chartNode = xmlConverter.selectSingleNode(doc, "//*[@default='true']");			
		} else {
			chartNode = xmlConverter.selectSingleNode(doc, "//*[@id=" + chartID + "]");			
		}

		return chartNode.getNodeName();

	}
	
	/**
	 * チャート名(XMLタグ名)に対応するチャートID(id属性)を取得する
	 * @param chartXMLFile チャート情報を格納したXMLファイルのパス
	 * @param chartName
	 * @return チャートID
	 */
	public String chartNameToId(String chartXMLFile, String chartName) throws ParserConfigurationException, SAXException, IOException {

		String chartID = null;

		XMLConverter xmlConverter = new XMLConverter();
		Document doc = xmlConverter.readFile(chartXMLFile);
		Node chartNode = doc.getElementsByTagName(chartName).item(0);			

		if (chartNode == null) {
			throw new IllegalStateException("レポートに設定されているチャート名 " + chartName + " に対応するノードがchart_kind.xmlに存在しません。");
		}
		chartID = chartNode.getAttributes().getNamedItem("id").getNodeValue();

		return chartID;

	}


	/**
	 * JFreeChart用のXMLドキュメント生成
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public Document createXML(RequestHelper helper, CommonSettings commonSettings) throws SQLException, NamingException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {
		
		// Connection の取得
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		this.conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
											  (String)helper.getRequest().getSession().getAttribute("searchPathName"));


		// 行・列に配置された全DimensionオブジェクトにDimensionMemberオブジェクトをセット
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");
		try {
			report.setSelectedCOLROWDimensionMembers(helper,report,this.conn);
		} catch (SQLException e) {
			throw e;
		}

		// チャートタイプをセット
		this.setChartTypeFromRequest(helper);


		// Report事前処理
		// ・複数Series、DataSetの作成対象か？ （ ⇒ creatingMultiSiriesChartを更新）
		// ・レポートの軸配置変更が必要か？
		//   メジャーが列に配置されている複数チャート(複数のSeriesを持つチャート)の場合
		//   メジャーが行に配置されている状態に置き換えてXML生成処理を行なう
		// ・円グラフの場合、最初の行のみを表示対象とする
		Measure measure = report.getMeasure(); 								// メジャー
		this.originalMeasureEdgePosition = report.getThisAxisPosition(measure);	// メジャーの配置されているエッジポジション
		int measureHieIndex = 0;											// メジャーのメジャーを持つエッジ内でのIndex
		if ((originalMeasureEdgePosition.equals(Constants.Col)) || (originalMeasureEdgePosition.equals(Constants.Row))) { 

			if (ChartXMLCreator.checkIsMultiChart(this.chartType)) { // 複数チャート

				if (originalMeasureEdgePosition.equals(Constants.Col)) { // メジャーが列に配置されている
					this.creatingMultiSiriesChart = true;
					measureHieIndex  = report.getHieIndex(measure);
					report.deleteAxis(Constants.MeasureID);								// メジャーを列エッジから仮削除
					report.getEdgeByType(Constants.Row).getAxisList().add(measure);		// メジャーを行エッジの末尾に仮追加
				}
			}			
		}
		// 円グラフの場合、最初の行のみを表示対象とする
		if ( (this.chartType == "Pie") || (this.chartType == "Pie_3D") ) {
			setFirstRowOnly(helper);
		}

		// XML
		DocumentBuilderFactory docbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docbFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();
//		Document doc = new XmlDocument();

			// XML生成（ChartInfo(Seriesノードおよび、その配下のノード以外)をセット）
			this.addChartInfo(helper, commonSettings, doc);

			try {

				// XML生成（Series ノードおよび、その配下のノード情報をセット）
				this.addSeriesList(helper, commonSettings, doc);

				// XML生成（DataSetノードおよび、その配下のノード情報をセット）
				this.addDataSetList(helper, commonSettings, doc);

				// 作成中のXML出力用の一時的処理
				Logger log = Logger.getLogger(ChartXMLCreator.class.getName());
				if(log.isInfoEnabled()) {
					XMLConverter xmlConverter = new XMLConverter();
					String xmlString = xmlConverter.toXMLText(doc);
					log.info("XML(chart)：\n" + xmlString);
				}

			} catch (SQLException e) {
				throw e;
			} finally {
				// Connection の開放
				if(this.conn != null){
					try {
						this.conn.close();
					} catch (SQLException e) {
						throw e;
					}
				}
			}

		// Report事後処理
		// ・レポートの軸配置変更が行なわれた場合、元の配置に戻す
		if (this.creatingMultiSiriesChart) {

				report.deleteAxis(Constants.MeasureID);															// メジャーを行エッジから削除
				report.getEdgeByType(originalMeasureEdgePosition).getAxisList().add(measureHieIndex, measure);	// メジャーを列エッジに追加
		}

		return doc;

	}

	// ********** privateメソッド **********

	/**
	 *  チャートタイプを設定する
	 * @param helper
	 */
	private void setChartTypeFromRequest(RequestHelper helper) throws ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {

		// クライアントから要求されたチャートのID
		String chartID = helper.getRequest().getParameter("chartID");

		// チャートIDより、チャートタイプ名を取得
		String dirPath = helper.getRequest().getSession().getServletContext().getRealPath("/");
		String fileName = "spread/chart_kind.xml";

		XMLConverter xmlConverter = new XMLConverter();
		Document doc = xmlConverter.readFile(dirPath + "/" + fileName);

		Node chartNode = null;
		if ("NA".equals(chartID)) {
			chartNode = xmlConverter.selectSingleNode(doc, "//*[@default='true']");			
		} else {
			chartNode = xmlConverter.selectSingleNode(doc, "//*[@id=" + chartID + "]");			
		}

		
		this.setChartType(chartNode.getNodeName());
		
	}


	/**
	 *  XML生成（ChartInfo(Seriesノードおよび、その配下のノード以外)をセット）
	 * @param helper
	 * @param commonSettings
	 * @param doc JFreeChart用のXML文書
	 */
	private void addChartInfo(RequestHelper helper, CommonSettings commonSettings, Document doc) {

		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		Element element = null;
		Node node = null;
		Text text = null;

		// XML生成（ルート(Chart)ノード生成）
		element = doc.createElement("Chart");
		Node root = doc.appendChild(element);
		
		// XML生成（ChartInfoノード生成）
		element = doc.createElement("ChartInfo");
		Node chartInfo = root.appendChild(element);

			// XML生成（Titleノードおよび値（Textノード）生成）
			element = doc.createElement("Title");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(report.getReportName());
			node.appendChild(text);
	
			// XML生成（TitleColorノードおよび値（Textノード）生成）
			element = doc.createElement("TitleColor");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartTitleColor")); //$NON-NLS-1$
			node.appendChild(text);
			
			// XML生成（Typeノードおよび値（Textノード）生成）
			element = doc.createElement("Type");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(this.chartType);
			node.appendChild(text);

			// XML生成（Fontノード生成）
			element = doc.createElement("Font");
			Node font = chartInfo.appendChild(element);
				
				// XML生成（FontNameノードおよび値（Textノード）生成）
				element = doc.createElement("FontName");
				node = font.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartFontName")); //$NON-NLS-1$
				node.appendChild(text);
		
				// XML生成（FontStyleノードおよび値（Textノード）生成）
				element = doc.createElement("FontStyle");
				node = font.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartFontStyle")); //$NON-NLS-1$
				node.appendChild(text);

				// XML生成（FontSizeノードおよび値（Textノード）生成）
				element = doc.createElement("FontSize");
				node = font.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartFontSize")); //$NON-NLS-1$
				node.appendChild(text);

			// XML生成（ChartSizeノード生成）
			element = doc.createElement("ChartSize");
			Node chartSize = chartInfo.appendChild(element);
			
				// XML生成（ChartHeightノードおよび値（Textノード）生成）
				element = doc.createElement("ChartHeight");
				node = chartSize.appendChild(element);
				String chartHeight = helper.getRequest().getParameter("chartHeight");
				text = doc.createTextNode(chartHeight);
				node.appendChild(text);
	
				// XML生成（ChartWidthノードおよび値（Textノード）生成）
				element = doc.createElement("ChartWidth");
				node = chartSize.appendChild(element);
				String chartWidth = helper.getRequest().getParameter("chartWidth");
				text = doc.createTextNode(chartWidth);
				node.appendChild(text);

			// XML生成（ChartBGColorノードおよび値（Textノード）生成）
			element = doc.createElement("ChartBGColor");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartBGColor")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML生成（PlotBGColorノードおよび値（Textノード）生成）
			element = doc.createElement("PlotBGColor");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartPlotBGColor")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML生成（multiPiePlotBGColorノードおよび値（Textノード）生成）
			element = doc.createElement("MultiPiePlotBGColor"); //$NON-NLS-1$
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartMultiPiePlotBGColor")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML生成（LegendPositionノードおよび値（Textノード）生成）
			element = doc.createElement("LegendPosition");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartLegendPosition")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML生成（hasToolTipノードおよび値（Textノード）生成）
			element = doc.createElement("hasToolTip");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartHasToolTip")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML生成（hasPieLabelノードおよび値（Textノード）生成）
			element = doc.createElement("hasPieLabel");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartHasPieLabel")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML生成（Categoryノード生成）
			element = doc.createElement("Category");
			Node category = chartInfo.appendChild(element);

				// XML生成（Labelの値を取得）
				String labelName = "";
				ArrayList<Axis> colAxisList = report.getEdgeByType(Constants.Col).getAxisList();

				//   Col軸の数だけループ
				Iterator<Axis> it = colAxisList.iterator();
				int i = 0;
				while (it.hasNext()) {
					if (i > 0) {
						labelName += "_";
					}
					labelName += (it.next()).getName();
					i++;
				}

				
				// XML生成（Labelノードおよび値（Textノード）生成）
				element = doc.createElement("Label");
				node = category.appendChild(element);
				text = doc.createTextNode(labelName);
				node.appendChild(text);

				// XML生成（LabelColorノードおよび値（Textノード）生成）
				element = doc.createElement("LabelColor");
				node = category.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartCategoryLabelColor")); //$NON-NLS-1$
				node.appendChild(text);

	}


	/**
	 * JFreeChart用のXMLドキュメントのDataSetノードおよび、その配下のノード情報をセットする
	 */
	private void addSeriesList(RequestHelper helper, CommonSettings commonSettings, Document doc) throws SQLException {
		
		int i = 0;

		// ノード操作処理用 初期設定
		Element element = null;
		Element root = doc.getDocumentElement();
		Node chartInfo = root.getElementsByTagName("ChartInfo").item(0);
		
		Node node = null;
		Text text = null;

		// レポートオブジェクト取得
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");		
		
		// XML生成（SeriesListノード生成）
		element = doc.createElement("SeriesList");
		Node seriesList = chartInfo.appendChild(element);

			
			ArrayList<AxisMember> measureMemberList = null;
			// メジャーが行または列にあり、かつ複数チャート(複数のSeriesを持つチャート)である場合、メジャーメンバー数だけSeriesを生成する
			if ( (ChartXMLCreator.checkIsMultiChart(this.chartType)) && 
			      ( (this.originalMeasureEdgePosition.equals(Constants.Col)) || ((this.originalMeasureEdgePosition.equals(Constants.Row))) )) {

					measureMemberList = report.getMeasure().getAxisMemberList();

			// それ以外の場合は、Seriesはデフォルトで選択されているメジャーメンバーの一つだけ生成する
			} else {
				measureMemberList = new ArrayList<AxisMember>();
				measureMemberList.add(report.getMeasure().getDefaultMember(this.conn));

			}

			Iterator<AxisMember> it = measureMemberList.iterator();
			while (it.hasNext()) {
				
				// XML生成（Seriesノード生成）
				element = doc.createElement("Series");
				Node series = seriesList.appendChild(element);
					
					String measureName = ((MeasureMember)it.next()).getMeasureName();
					
					// XML生成（Labelノードおよび値（Textノード）生成）
					element = doc.createElement("Label");
					node = series.appendChild(element);
					text = doc.createTextNode(measureName);
					node.appendChild(text);
	
					// XML生成（LabelColorノードおよび値（Textノード）生成）
					element = doc.createElement("LabelColor");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartSeriesLabelColor")); //$NON-NLS-1$
					node.appendChild(text);

					// XML生成（isAutoRangeEnableノードおよび値（Textノード）生成）
					element = doc.createElement("isAutoRangeEnable");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartIsAutoRangeEnable")); //$NON-NLS-1$
					node.appendChild(text);


					// XML生成（MaxRangeノードおよび値（Textノード）生成）
					element = doc.createElement("MaxRange");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartMaxRange")); //$NON-NLS-1$
					node.appendChild(text);
		
					// XML生成（MinRangeノードおよび値（Textノード）生成）
					element = doc.createElement("MinRange");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartMinRange")); //$NON-NLS-1$
					node.appendChild(text);
				
			}
		
	}

	/**
	 * JFreeChart用のXMLドキュメントのDataSetノードおよび、その配下のノード情報をセットする
	 */
	private void addDataSetList(RequestHelper helper, CommonSettings commonSettings, Document doc) throws SQLException {

		int i = 0;

		// ノード操作処理用 初期設定
		Element element = null;
		Element root = doc.getDocumentElement();
		
		Node node = null;
		Text text = null;

		// レポートオブジェクト取得
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");

		// エッジ
		Col col = (Col) report.getEdgeByType(Constants.Col);
		Row row = (Row) report.getEdgeByType(Constants.Row);
			
		// エッジの持つ軸リスト
		ArrayList<Axis> colAxesList = col.getAxisList();
		ArrayList<Axis> rowAxesList = row.getAxisList();
		ArrayList<Axis> pageAxesList = report.getEdgeByType(Constants.Page).getAxisList();		

		// セルデータを取得
		// （値のフォーマットとして単位のみをそろえる書式を使用、行・列・ページでソートするSQLタイプを指定。）
		ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(helper, this.conn, false, CellDataDAO.sortedSQLTypeString);


		// XML生成（DataSetListノード生成）
		element = doc.createElement("DataSetList");
		Node dataSetList = root.appendChild(element);

		Measure measure = report.getMeasure();
		ArrayList<AxisMember> targetMeasures = null;
		
		// メジャーが行または列にあり、複数チャート(複数のSeriesを持つチャート)である場合、メジャーメンバー数だけDataSetを生成する
		if ( (ChartXMLCreator.checkIsMultiChart(this.chartType)) && 
			  ( (this.originalMeasureEdgePosition.equals(Constants.Col)) || ((this.originalMeasureEdgePosition.equals(Constants.Row))) )) {
			targetMeasures = new ArrayList<AxisMember>();
			targetMeasures.addAll(measure.getAxisMemberList());
		// それ以外の場合は、DataSetは一つだけ生成する
		} else {
			targetMeasures = new ArrayList<AxisMember>();
			targetMeasures.add(measure.getDefaultMember(this.conn));
		}

		// 列で表示中のメンバの数を求める。
//		String viewColIndexKeyString = helper.getRequest().getParameter("viewColIndexKey_hidden");
//		ArrayList viewColIndexKeyList = StringUtil.splitString(viewColIndexKeyString,",");
//		int viewColNumber = viewColIndexKeyList.size();
		

		// メジャーメンバ単位でDataSet要素を作成
		Iterator<AxisMember> meaIt = targetMeasures.iterator();
		while (meaIt.hasNext()) {
			MeasureMember measureMember = (MeasureMember)meaIt.next();
	
			// XML生成（DataSetノード生成）
			element = doc.createElement("DataSet");
			Node dataSet = dataSetList.appendChild(element);
	
	
			// Spread表のセル単位で、Data要素をDataSetに追加
			// なお、異なるメジャーメンバの場合は追加しない。
			// （例：salesメジャーメンバに対応するDataSetを作成中の場合、selesのセルは追加するが、costのセルは含めない。）
			Iterator<CellData> it = cellDataList.iterator();

			while (it.hasNext()) {

				CellData cellData = it.next();
				
				// ＜メジャーが行または列にあり、複数チャート(複数のSeriesを持つチャート)である場合＞
				// DataSetはメジャー毎に作成するが、cellDataが作成中のメジャー以外のデータであった場合は、出力しない
				if ( (ChartXMLCreator.checkIsMultiChart(this.chartType)) && 
					  ( (this.originalMeasureEdgePosition.equals(Constants.Col)) || ((this.originalMeasureEdgePosition.equals(Constants.Row))) )) {

					if (!measureMember.getUniqueName().equals(cellData.getMeasureMemberUniqueName()) ) {
						continue;
					}
				}			
				
				// XML生成（Dataノード生成）
				element = doc.createElement("Data");
				Node data = dataSet.appendChild(element);
	
					// セルに対応する各軸のメンバーのIDおよび名称の組み合わせを取得
					LinkedHashMap<Integer, String> colRowAxisIDMemKeys = new LinkedHashMap<Integer, String>();
					colRowAxisIDMemKeys.putAll(cellData.getColCoordinates().getAxisIdMemKeyMap());
					colRowAxisIDMemKeys.putAll(cellData.getRowCoordinates().getAxisIdMemKeyMap());

					// セルに対応する各列軸のメンバーのIDおよび名称の組み合わせを取得
					// （複数段の場合は、各段のIDおよび名称を組み合わせる。）
					String axisMemberIDs = "";
					String axisMemberNames = "";
					for (i = 0; i < colAxesList.size(); i++) {
						Axis axis = (Axis) colAxesList.get(i);
	
						if (i != 0) {
							axisMemberIDs += "_";
							axisMemberNames += "_";
						}

						// メンバーIDを取得
						String memberKey = (String)colRowAxisIDMemKeys.get(Integer.valueOf(axis.getId()));
						axisMemberIDs += memberKey;

						// メンバー名称を取得(時間軸の場合：ロングネーム、それ以外の場合はショートネームかロングネームのどちらか指定されている方)
						AxisMember axisMember = axis.getAxisMemberByUniqueName(memberKey);
						String axisMemberName = axisMember.getSpecifiedDisplayName(axis);
						if (axis instanceof Dimension) {
							if (((Dimension)axis).isTimeDimension()) {
								if("selectedName".equals(ChartMessages.getString("ChartXMLCreator.ChartTimeDimMemberNameType"))) {
									axisMemberName = ((DimensionMember)axisMember).getSpecifiedDisplayName(axis);
								} else if ("UniqueName".equals(ChartMessages.getString("ChartXMLCreator.ChartTimeDimMemberNameType"))) {
									axisMemberName = TimeDimensionInfo.timekeyToName(axisMember.getUniqueName());										
								}
							}
						}
						axisMemberNames += axisMemberName;

					}
					
	
					// XML生成（CategoryAxisCodeノードおよび値（Textノード）生成）
					element = doc.createElement("CategoryAxisCode");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberIDs);
					node.appendChild(text);
				
					// XML生成（CategoryAxisNameノードおよび値（Textノード）生成）
					element = doc.createElement("CategoryAxisName");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberNames);
					node.appendChild(text);
	
					// セルに対応する各行軸のメンバーのIDおよび名称を取得する
					// （複数段の場合は、各段のIDおよび名称を組み合わせる。）
					axisMemberIDs = "";
					axisMemberNames = "";
					for (i = 0; i < rowAxesList.size(); i++) {
						Axis axis = (Axis) rowAxesList.get(i);
	
						if (i != 0) {
							axisMemberIDs   += "_";
							axisMemberNames += "_";
						}

						// メンバーIDを取得
						String memberKey = (String)colRowAxisIDMemKeys.get(Integer.valueOf(axis.getId()));
						axisMemberIDs += memberKey;

						// メンバー名称を取得(時間軸の場合：ロングネーム、それ以外の場合はショートネームかロングネームのどちらか指定されている方)
						AxisMember axisMember = axis.getAxisMemberByUniqueName(memberKey);
						String axisMemberName = axisMember.getSpecifiedDisplayName(axis);
						if (axis instanceof Dimension) {
							if (((Dimension)axis).isTimeDimension()) {
								if("selectedName".equals(ChartMessages.getString("ChartXMLCreator.ChartTimeDimMemberNameType"))) {
									axisMemberName = ((DimensionMember)axisMember).getSpecifiedDisplayName(axis);
								} else if ("UniqueName".equals(ChartMessages.getString("ChartXMLCreator.ChartTimeDimMemberNameType"))) {
									axisMemberName = TimeDimensionInfo.timekeyToName(axisMember.getUniqueName());										
								}
							} 
						}
						axisMemberNames += axisMemberName;

					}
	
					// XML生成（ValueAxisCodeノードおよび値（Textノード）生成）
					element = doc.createElement("ValueAxisCode");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberIDs);
					node.appendChild(text);
	
					// XML生成（ValueAxisNameノードおよび値（Textノード）生成）
					element = doc.createElement("ValueAxisName");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberNames);
					node.appendChild(text);
					
					// XML生成（Valueノードおよび値（Textノード）生成）
					element = doc.createElement("Value");
					node = data.appendChild(element);
					text = doc.createTextNode(cellData.getValue());
					node.appendChild(text);				

			}

		}

	}


	/**
	 * 円グラフの場合、最初の行のみを表示対象とする
	 * （セッションのviewRowXKeyList_hidden、viewRowIndexKey_hiddenを、最初の行のIndex,Key情報のみとする）
	 */
	private void setFirstRowOnly(RequestHelper helper) {
		
		String viewRowIndexKeyList = (String)helper.getRequest().getSession().getAttribute("viewRowIndexKey_hidden");
		ArrayList<String> viewRowIndexKeyString  = StringUtil.splitString(viewRowIndexKeyList, ","); // viewRowIndexKeyString：文字列の配列(ex:「0:0;;」)	
		
		ArrayList<String> viewRow0IndexKey = StringUtil.splitString((String)viewRowIndexKeyString.get(0),":");
		String viewRow0Index       = viewRow0IndexKey.get(0); // 最初の行のインデックス
		String viewRow0KeysString  = viewRow0IndexKey.get(1); // 最初の行のメンバーキーのリスト文字列（ex:「0;;」）
		
		ArrayList<String> viewRow0KeysList = StringUtil.splitString(viewRow0KeysString,";"); // 最初の行のメンバーキーの配列

		// viewRowIndexKey_hidden を最初の行のみの情報で更新
		helper.getRequest().getSession().setAttribute("viewRowIndexKey_hidden", viewRowIndexKeyString.get(0));
		
		// viewRowXKeyList_hidden を最初の行のみの情報で更新
		for(int i=0; i<viewRow0KeysList.size(); i++) {
			helper.getRequest().getSession().setAttribute("viewRow"+i+"KeyList_hidden", viewRow0KeysList.get(i));
		}
		
	}


	// *** setter ***
	
	private void setChartType(String chartType) {
		this.chartType = chartType;
	}

	// *** getter ***
	private String getChartType() {
		return this.chartType;
	}


}
