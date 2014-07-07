/*
 * �쐬��: 2004/08/05
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
 * JFreeChart�p��XML�h�L�������g�𐶐�����N���X
 */
public class ChartXMLCreator {

	// ********** �C���X�^���X�ϐ� **********

	private Connection conn = null;

	/** true �̏ꍇ�A�����V���[�Y�������W���[���쐬���ł��邱�Ƃ������BXML�o�͏����̍Ō�Ƀ��W���[�z�u�ʒu�̕��A���K�v�ł���B */
	private boolean creatingMultiSiriesChart = false;

	/** ChartType */
	private String chartType = null;

	/** ���|�[�g�̃��W���[�z�u�ꏊ
	 *�@ ���W���[�z�u�ʒu�̉��ړ����́AReport������Ƃ��Ƃ̏ꏊ���擾�ł��Ȃ��̂ŁA�����ɂ��炩���߉��ێ����� */
	String originalMeasureEdgePosition = null;

	// ********** static ���\�b�h **********
	/**
	 * �^����ꂽ�`���[�g�^�C�v�������`���[�g�iSeries�𕡐����`���[�g�j�ł���ꍇ�A
	 * true��Ԃ��A����ȊO�̏ꍇ��false��Ԃ�
	 * @param chartType �`���[�g�^�C�v
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
	 * �`���[�gXML�̃t�@�C���p�X��߂��B
	 * @param helper RequestHelper
	 * @return �`���[�gXML�̃t�@�C���p�X
	 */
	static public String getChartXMLFilePath(RequestHelper helper) {

		// �`���[�g�^�C�v�����擾
		String dirPath = helper.getRequest().getSession().getServletContext().getRealPath("/");
		String fileName = "spread/chart_kind.xml";
	
		return dirPath + "/" + fileName;

	}

	// ********** ���\�b�h **********

	/**
	 * �`���[�gID�ɑΉ�����`���[�g��(XML�^�O��)���擾����
	 * �`���[�gID�Ƃ���NA���n���ꂽ�ꍇ�́A�`���[�gXML�Ńf�t�H���g������true�ł���`���[�g�v�f�̖��̂�߂��B
	 * @param chartXMLFile �`���[�g�����i�[����XML�t�@�C���̃p�X
	 * @param chartID
	 * @return �`���[�g��
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
	 * �`���[�g��(XML�^�O��)�ɑΉ�����`���[�gID(id����)���擾����
	 * @param chartXMLFile �`���[�g�����i�[����XML�t�@�C���̃p�X
	 * @param chartName
	 * @return �`���[�gID
	 */
	public String chartNameToId(String chartXMLFile, String chartName) throws ParserConfigurationException, SAXException, IOException {

		String chartID = null;

		XMLConverter xmlConverter = new XMLConverter();
		Document doc = xmlConverter.readFile(chartXMLFile);
		Node chartNode = doc.getElementsByTagName(chartName).item(0);			

		if (chartNode == null) {
			throw new IllegalStateException("���|�[�g�ɐݒ肳��Ă���`���[�g�� " + chartName + " �ɑΉ�����m�[�h��chart_kind.xml�ɑ��݂��܂���B");
		}
		chartID = chartNode.getAttributes().getNamedItem("id").getNodeValue();

		return chartID;

	}


	/**
	 * JFreeChart�p��XML�h�L�������g����
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public Document createXML(RequestHelper helper, CommonSettings commonSettings) throws SQLException, NamingException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {
		
		// Connection �̎擾
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		this.conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
											  (String)helper.getRequest().getSession().getAttribute("searchPathName"));


		// �s�E��ɔz�u���ꂽ�SDimension�I�u�W�F�N�g��DimensionMember�I�u�W�F�N�g���Z�b�g
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");
		try {
			report.setSelectedCOLROWDimensionMembers(helper,report,this.conn);
		} catch (SQLException e) {
			throw e;
		}

		// �`���[�g�^�C�v���Z�b�g
		this.setChartTypeFromRequest(helper);


		// Report���O����
		// �E����Series�ADataSet�̍쐬�Ώۂ��H �i �� creatingMultiSiriesChart���X�V�j
		// �E���|�[�g�̎��z�u�ύX���K�v���H
		//   ���W���[����ɔz�u����Ă��镡���`���[�g(������Series�����`���[�g)�̏ꍇ
		//   ���W���[���s�ɔz�u����Ă����Ԃɒu��������XML�����������s�Ȃ�
		// �E�~�O���t�̏ꍇ�A�ŏ��̍s�݂̂�\���ΏۂƂ���
		Measure measure = report.getMeasure(); 								// ���W���[
		this.originalMeasureEdgePosition = report.getThisAxisPosition(measure);	// ���W���[�̔z�u����Ă���G�b�W�|�W�V����
		int measureHieIndex = 0;											// ���W���[�̃��W���[�����G�b�W���ł�Index
		if ((originalMeasureEdgePosition.equals(Constants.Col)) || (originalMeasureEdgePosition.equals(Constants.Row))) { 

			if (ChartXMLCreator.checkIsMultiChart(this.chartType)) { // �����`���[�g

				if (originalMeasureEdgePosition.equals(Constants.Col)) { // ���W���[����ɔz�u����Ă���
					this.creatingMultiSiriesChart = true;
					measureHieIndex  = report.getHieIndex(measure);
					report.deleteAxis(Constants.MeasureID);								// ���W���[���G�b�W���牼�폜
					report.getEdgeByType(Constants.Row).getAxisList().add(measure);		// ���W���[���s�G�b�W�̖����ɉ��ǉ�
				}
			}			
		}
		// �~�O���t�̏ꍇ�A�ŏ��̍s�݂̂�\���ΏۂƂ���
		if ( (this.chartType == "Pie") || (this.chartType == "Pie_3D") ) {
			setFirstRowOnly(helper);
		}

		// XML
		DocumentBuilderFactory docbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docbFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();
//		Document doc = new XmlDocument();

			// XML�����iChartInfo(Series�m�[�h����сA���̔z���̃m�[�h�ȊO)���Z�b�g�j
			this.addChartInfo(helper, commonSettings, doc);

			try {

				// XML�����iSeries �m�[�h����сA���̔z���̃m�[�h�����Z�b�g�j
				this.addSeriesList(helper, commonSettings, doc);

				// XML�����iDataSet�m�[�h����сA���̔z���̃m�[�h�����Z�b�g�j
				this.addDataSetList(helper, commonSettings, doc);

				// �쐬����XML�o�͗p�̈ꎞ�I����
				Logger log = Logger.getLogger(ChartXMLCreator.class.getName());
				if(log.isInfoEnabled()) {
					XMLConverter xmlConverter = new XMLConverter();
					String xmlString = xmlConverter.toXMLText(doc);
					log.info("XML(chart)�F\n" + xmlString);
				}

			} catch (SQLException e) {
				throw e;
			} finally {
				// Connection �̊J��
				if(this.conn != null){
					try {
						this.conn.close();
					} catch (SQLException e) {
						throw e;
					}
				}
			}

		// Report���㏈��
		// �E���|�[�g�̎��z�u�ύX���s�Ȃ�ꂽ�ꍇ�A���̔z�u�ɖ߂�
		if (this.creatingMultiSiriesChart) {

				report.deleteAxis(Constants.MeasureID);															// ���W���[���s�G�b�W����폜
				report.getEdgeByType(originalMeasureEdgePosition).getAxisList().add(measureHieIndex, measure);	// ���W���[���G�b�W�ɒǉ�
		}

		return doc;

	}

	// ********** private���\�b�h **********

	/**
	 *  �`���[�g�^�C�v��ݒ肷��
	 * @param helper
	 */
	private void setChartTypeFromRequest(RequestHelper helper) throws ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {

		// �N���C�A���g����v�����ꂽ�`���[�g��ID
		String chartID = helper.getRequest().getParameter("chartID");

		// �`���[�gID���A�`���[�g�^�C�v�����擾
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
	 *  XML�����iChartInfo(Series�m�[�h����сA���̔z���̃m�[�h�ȊO)���Z�b�g�j
	 * @param helper
	 * @param commonSettings
	 * @param doc JFreeChart�p��XML����
	 */
	private void addChartInfo(RequestHelper helper, CommonSettings commonSettings, Document doc) {

		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		Element element = null;
		Node node = null;
		Text text = null;

		// XML�����i���[�g(Chart)�m�[�h�����j
		element = doc.createElement("Chart");
		Node root = doc.appendChild(element);
		
		// XML�����iChartInfo�m�[�h�����j
		element = doc.createElement("ChartInfo");
		Node chartInfo = root.appendChild(element);

			// XML�����iTitle�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("Title");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(report.getReportName());
			node.appendChild(text);
	
			// XML�����iTitleColor�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("TitleColor");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartTitleColor")); //$NON-NLS-1$
			node.appendChild(text);
			
			// XML�����iType�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("Type");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(this.chartType);
			node.appendChild(text);

			// XML�����iFont�m�[�h�����j
			element = doc.createElement("Font");
			Node font = chartInfo.appendChild(element);
				
				// XML�����iFontName�m�[�h����ђl�iText�m�[�h�j�����j
				element = doc.createElement("FontName");
				node = font.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartFontName")); //$NON-NLS-1$
				node.appendChild(text);
		
				// XML�����iFontStyle�m�[�h����ђl�iText�m�[�h�j�����j
				element = doc.createElement("FontStyle");
				node = font.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartFontStyle")); //$NON-NLS-1$
				node.appendChild(text);

				// XML�����iFontSize�m�[�h����ђl�iText�m�[�h�j�����j
				element = doc.createElement("FontSize");
				node = font.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartFontSize")); //$NON-NLS-1$
				node.appendChild(text);

			// XML�����iChartSize�m�[�h�����j
			element = doc.createElement("ChartSize");
			Node chartSize = chartInfo.appendChild(element);
			
				// XML�����iChartHeight�m�[�h����ђl�iText�m�[�h�j�����j
				element = doc.createElement("ChartHeight");
				node = chartSize.appendChild(element);
				String chartHeight = helper.getRequest().getParameter("chartHeight");
				text = doc.createTextNode(chartHeight);
				node.appendChild(text);
	
				// XML�����iChartWidth�m�[�h����ђl�iText�m�[�h�j�����j
				element = doc.createElement("ChartWidth");
				node = chartSize.appendChild(element);
				String chartWidth = helper.getRequest().getParameter("chartWidth");
				text = doc.createTextNode(chartWidth);
				node.appendChild(text);

			// XML�����iChartBGColor�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("ChartBGColor");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartBGColor")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML�����iPlotBGColor�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("PlotBGColor");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartPlotBGColor")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML�����imultiPiePlotBGColor�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("MultiPiePlotBGColor"); //$NON-NLS-1$
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartMultiPiePlotBGColor")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML�����iLegendPosition�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("LegendPosition");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartLegendPosition")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML�����ihasToolTip�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("hasToolTip");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartHasToolTip")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML�����ihasPieLabel�m�[�h����ђl�iText�m�[�h�j�����j
			element = doc.createElement("hasPieLabel");
			node = chartInfo.appendChild(element);
			text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartHasPieLabel")); //$NON-NLS-1$
			node.appendChild(text);
	
			// XML�����iCategory�m�[�h�����j
			element = doc.createElement("Category");
			Node category = chartInfo.appendChild(element);

				// XML�����iLabel�̒l���擾�j
				String labelName = "";
				ArrayList<Axis> colAxisList = report.getEdgeByType(Constants.Col).getAxisList();

				//   Col���̐��������[�v
				Iterator<Axis> it = colAxisList.iterator();
				int i = 0;
				while (it.hasNext()) {
					if (i > 0) {
						labelName += "_";
					}
					labelName += (it.next()).getName();
					i++;
				}

				
				// XML�����iLabel�m�[�h����ђl�iText�m�[�h�j�����j
				element = doc.createElement("Label");
				node = category.appendChild(element);
				text = doc.createTextNode(labelName);
				node.appendChild(text);

				// XML�����iLabelColor�m�[�h����ђl�iText�m�[�h�j�����j
				element = doc.createElement("LabelColor");
				node = category.appendChild(element);
				text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartCategoryLabelColor")); //$NON-NLS-1$
				node.appendChild(text);

	}


	/**
	 * JFreeChart�p��XML�h�L�������g��DataSet�m�[�h����сA���̔z���̃m�[�h�����Z�b�g����
	 */
	private void addSeriesList(RequestHelper helper, CommonSettings commonSettings, Document doc) throws SQLException {
		
		int i = 0;

		// �m�[�h���쏈���p �����ݒ�
		Element element = null;
		Element root = doc.getDocumentElement();
		Node chartInfo = root.getElementsByTagName("ChartInfo").item(0);
		
		Node node = null;
		Text text = null;

		// ���|�[�g�I�u�W�F�N�g�擾
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");		
		
		// XML�����iSeriesList�m�[�h�����j
		element = doc.createElement("SeriesList");
		Node seriesList = chartInfo.appendChild(element);

			
			ArrayList<AxisMember> measureMemberList = null;
			// ���W���[���s�܂��͗�ɂ���A�������`���[�g(������Series�����`���[�g)�ł���ꍇ�A���W���[�����o�[������Series�𐶐�����
			if ( (ChartXMLCreator.checkIsMultiChart(this.chartType)) && 
			      ( (this.originalMeasureEdgePosition.equals(Constants.Col)) || ((this.originalMeasureEdgePosition.equals(Constants.Row))) )) {

					measureMemberList = report.getMeasure().getAxisMemberList();

			// ����ȊO�̏ꍇ�́ASeries�̓f�t�H���g�őI������Ă��郁�W���[�����o�[�̈������������
			} else {
				measureMemberList = new ArrayList<AxisMember>();
				measureMemberList.add(report.getMeasure().getDefaultMember(this.conn));

			}

			Iterator<AxisMember> it = measureMemberList.iterator();
			while (it.hasNext()) {
				
				// XML�����iSeries�m�[�h�����j
				element = doc.createElement("Series");
				Node series = seriesList.appendChild(element);
					
					String measureName = ((MeasureMember)it.next()).getMeasureName();
					
					// XML�����iLabel�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("Label");
					node = series.appendChild(element);
					text = doc.createTextNode(measureName);
					node.appendChild(text);
	
					// XML�����iLabelColor�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("LabelColor");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartSeriesLabelColor")); //$NON-NLS-1$
					node.appendChild(text);

					// XML�����iisAutoRangeEnable�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("isAutoRangeEnable");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartIsAutoRangeEnable")); //$NON-NLS-1$
					node.appendChild(text);


					// XML�����iMaxRange�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("MaxRange");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartMaxRange")); //$NON-NLS-1$
					node.appendChild(text);
		
					// XML�����iMinRange�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("MinRange");
					node = series.appendChild(element);
					text = doc.createTextNode(ChartMessages.getString("ChartXMLCreator.ChartMinRange")); //$NON-NLS-1$
					node.appendChild(text);
				
			}
		
	}

	/**
	 * JFreeChart�p��XML�h�L�������g��DataSet�m�[�h����сA���̔z���̃m�[�h�����Z�b�g����
	 */
	private void addDataSetList(RequestHelper helper, CommonSettings commonSettings, Document doc) throws SQLException {

		int i = 0;

		// �m�[�h���쏈���p �����ݒ�
		Element element = null;
		Element root = doc.getDocumentElement();
		
		Node node = null;
		Text text = null;

		// ���|�[�g�I�u�W�F�N�g�擾
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");

		// �G�b�W
		Col col = (Col) report.getEdgeByType(Constants.Col);
		Row row = (Row) report.getEdgeByType(Constants.Row);
			
		// �G�b�W�̎������X�g
		ArrayList<Axis> colAxesList = col.getAxisList();
		ArrayList<Axis> rowAxesList = row.getAxisList();
		ArrayList<Axis> pageAxesList = report.getEdgeByType(Constants.Page).getAxisList();		

		// �Z���f�[�^���擾
		// �i�l�̃t�H�[�}�b�g�Ƃ��ĒP�ʂ݂̂����낦�鏑�����g�p�A�s�E��E�y�[�W�Ń\�[�g����SQL�^�C�v���w��B�j
		ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(helper, this.conn, false, CellDataDAO.sortedSQLTypeString);


		// XML�����iDataSetList�m�[�h�����j
		element = doc.createElement("DataSetList");
		Node dataSetList = root.appendChild(element);

		Measure measure = report.getMeasure();
		ArrayList<AxisMember> targetMeasures = null;
		
		// ���W���[���s�܂��͗�ɂ���A�����`���[�g(������Series�����`���[�g)�ł���ꍇ�A���W���[�����o�[������DataSet�𐶐�����
		if ( (ChartXMLCreator.checkIsMultiChart(this.chartType)) && 
			  ( (this.originalMeasureEdgePosition.equals(Constants.Col)) || ((this.originalMeasureEdgePosition.equals(Constants.Row))) )) {
			targetMeasures = new ArrayList<AxisMember>();
			targetMeasures.addAll(measure.getAxisMemberList());
		// ����ȊO�̏ꍇ�́ADataSet�͈������������
		} else {
			targetMeasures = new ArrayList<AxisMember>();
			targetMeasures.add(measure.getDefaultMember(this.conn));
		}

		// ��ŕ\�����̃����o�̐������߂�B
//		String viewColIndexKeyString = helper.getRequest().getParameter("viewColIndexKey_hidden");
//		ArrayList viewColIndexKeyList = StringUtil.splitString(viewColIndexKeyString,",");
//		int viewColNumber = viewColIndexKeyList.size();
		

		// ���W���[�����o�P�ʂ�DataSet�v�f���쐬
		Iterator<AxisMember> meaIt = targetMeasures.iterator();
		while (meaIt.hasNext()) {
			MeasureMember measureMember = (MeasureMember)meaIt.next();
	
			// XML�����iDataSet�m�[�h�����j
			element = doc.createElement("DataSet");
			Node dataSet = dataSetList.appendChild(element);
	
	
			// Spread�\�̃Z���P�ʂŁAData�v�f��DataSet�ɒǉ�
			// �Ȃ��A�قȂ郁�W���[�����o�̏ꍇ�͒ǉ����Ȃ��B
			// �i��Fsales���W���[�����o�ɑΉ�����DataSet���쐬���̏ꍇ�Aseles�̃Z���͒ǉ����邪�Acost�̃Z���͊܂߂Ȃ��B�j
			Iterator<CellData> it = cellDataList.iterator();

			while (it.hasNext()) {

				CellData cellData = it.next();
				
				// �����W���[���s�܂��͗�ɂ���A�����`���[�g(������Series�����`���[�g)�ł���ꍇ��
				// DataSet�̓��W���[���ɍ쐬���邪�AcellData���쐬���̃��W���[�ȊO�̃f�[�^�ł������ꍇ�́A�o�͂��Ȃ�
				if ( (ChartXMLCreator.checkIsMultiChart(this.chartType)) && 
					  ( (this.originalMeasureEdgePosition.equals(Constants.Col)) || ((this.originalMeasureEdgePosition.equals(Constants.Row))) )) {

					if (!measureMember.getUniqueName().equals(cellData.getMeasureMemberUniqueName()) ) {
						continue;
					}
				}			
				
				// XML�����iData�m�[�h�����j
				element = doc.createElement("Data");
				Node data = dataSet.appendChild(element);
	
					// �Z���ɑΉ�����e���̃����o�[��ID����і��̂̑g�ݍ��킹���擾
					LinkedHashMap<Integer, String> colRowAxisIDMemKeys = new LinkedHashMap<Integer, String>();
					colRowAxisIDMemKeys.putAll(cellData.getColCoordinates().getAxisIdMemKeyMap());
					colRowAxisIDMemKeys.putAll(cellData.getRowCoordinates().getAxisIdMemKeyMap());

					// �Z���ɑΉ�����e�񎲂̃����o�[��ID����і��̂̑g�ݍ��킹���擾
					// �i�����i�̏ꍇ�́A�e�i��ID����і��̂�g�ݍ��킹��B�j
					String axisMemberIDs = "";
					String axisMemberNames = "";
					for (i = 0; i < colAxesList.size(); i++) {
						Axis axis = (Axis) colAxesList.get(i);
	
						if (i != 0) {
							axisMemberIDs += "_";
							axisMemberNames += "_";
						}

						// �����o�[ID���擾
						String memberKey = (String)colRowAxisIDMemKeys.get(Integer.valueOf(axis.getId()));
						axisMemberIDs += memberKey;

						// �����o�[���̂��擾(���Ԏ��̏ꍇ�F�����O�l�[���A����ȊO�̏ꍇ�̓V���[�g�l�[���������O�l�[���̂ǂ��炩�w�肳��Ă����)
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
					
	
					// XML�����iCategoryAxisCode�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("CategoryAxisCode");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberIDs);
					node.appendChild(text);
				
					// XML�����iCategoryAxisName�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("CategoryAxisName");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberNames);
					node.appendChild(text);
	
					// �Z���ɑΉ�����e�s���̃����o�[��ID����і��̂��擾����
					// �i�����i�̏ꍇ�́A�e�i��ID����і��̂�g�ݍ��킹��B�j
					axisMemberIDs = "";
					axisMemberNames = "";
					for (i = 0; i < rowAxesList.size(); i++) {
						Axis axis = (Axis) rowAxesList.get(i);
	
						if (i != 0) {
							axisMemberIDs   += "_";
							axisMemberNames += "_";
						}

						// �����o�[ID���擾
						String memberKey = (String)colRowAxisIDMemKeys.get(Integer.valueOf(axis.getId()));
						axisMemberIDs += memberKey;

						// �����o�[���̂��擾(���Ԏ��̏ꍇ�F�����O�l�[���A����ȊO�̏ꍇ�̓V���[�g�l�[���������O�l�[���̂ǂ��炩�w�肳��Ă����)
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
	
					// XML�����iValueAxisCode�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("ValueAxisCode");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberIDs);
					node.appendChild(text);
	
					// XML�����iValueAxisName�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("ValueAxisName");
					node = data.appendChild(element);
					text = doc.createTextNode(axisMemberNames);
					node.appendChild(text);
					
					// XML�����iValue�m�[�h����ђl�iText�m�[�h�j�����j
					element = doc.createElement("Value");
					node = data.appendChild(element);
					text = doc.createTextNode(cellData.getValue());
					node.appendChild(text);				

			}

		}

	}


	/**
	 * �~�O���t�̏ꍇ�A�ŏ��̍s�݂̂�\���ΏۂƂ���
	 * �i�Z�b�V������viewRowXKeyList_hidden�AviewRowIndexKey_hidden���A�ŏ��̍s��Index,Key���݂̂Ƃ���j
	 */
	private void setFirstRowOnly(RequestHelper helper) {
		
		String viewRowIndexKeyList = (String)helper.getRequest().getSession().getAttribute("viewRowIndexKey_hidden");
		ArrayList<String> viewRowIndexKeyString  = StringUtil.splitString(viewRowIndexKeyList, ","); // viewRowIndexKeyString�F������̔z��(ex:�u0:0;;�v)	
		
		ArrayList<String> viewRow0IndexKey = StringUtil.splitString((String)viewRowIndexKeyString.get(0),":");
		String viewRow0Index       = viewRow0IndexKey.get(0); // �ŏ��̍s�̃C���f�b�N�X
		String viewRow0KeysString  = viewRow0IndexKey.get(1); // �ŏ��̍s�̃����o�[�L�[�̃��X�g������iex:�u0;;�v�j
		
		ArrayList<String> viewRow0KeysList = StringUtil.splitString(viewRow0KeysString,";"); // �ŏ��̍s�̃����o�[�L�[�̔z��

		// viewRowIndexKey_hidden ���ŏ��̍s�݂̂̏��ōX�V
		helper.getRequest().getSession().setAttribute("viewRowIndexKey_hidden", viewRowIndexKeyString.get(0));
		
		// viewRowXKeyList_hidden ���ŏ��̍s�݂̂̏��ōX�V
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
