/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.export
 *  �t�@�C���FExportReportAsXMLSpreadsheetSchema.java
 *  �����FXML Spreadsheet Schema�`���Ń��|�[�g���G�N�X�|�[�g����N���X�ł��B
 *
 *  �쐬��: 2004/01/31
 */
package openolap.viewer.export;

import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.Hashtable;
import java.util.Set;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.apache.log4j.Logger;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;


import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.CellData;
import openolap.viewer.Col;
import openolap.viewer.Measure;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.Row;
import openolap.viewer.XMLConverter;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.Constants;
import openolap.viewer.common.Messages;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  �N���X�FExportReportAsXMLSpreadsheetSchema<br>
 *  �����FXML Spreadsheet Schema�`���Ń��|�[�g���G�N�X�|�[�g����N���X�ł��B
 */
public class ExportReportAsXMLSpreadsheetSchema extends ExportReport {

	// ********** �C���X�^���X�ϐ� **********

	/** xIndex�ϊ��p�e�[�u��
	 *  (�N���C�A���g��SpreadIndex�˃G�N�X�|�[�g����郌�|�[�g�\�������ƂɐV���ɐU��Ȃ�����Index) 
     */
	private Hashtable<Integer, Integer> xIndexChangeTable = null;

	/** yIndex�ϊ��p�e�[�u�� 
	 *  (�N���C�A���g��SpreadIndex�˃G�N�X�|�[�g����郌�|�[�g�\�������ƂɐV���ɐU��Ȃ�����Index) 
	 */
	private Hashtable<Integer, Integer> yIndexChangeTable = null;


	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(ExportReportAsXMLSpreadsheetSchema.class.getName());


	// ********** ���\�b�h **********

	/**
	 * �G�N�X�|�[�g���������s���A�_�E�����[�h�y�[�W�̃p�X��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public String exportReport(RequestHelper helper) throws SQLException, NamingException, IOException, DOMException, ParserConfigurationException, SAXException, TransformerException, XPathExpressionException {

		int i = 0;
		int j = 0;
		int k = 0;

		HttpServletRequest request = helper.getRequest();
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		if (report==null) {
			throw new IllegalStateException();
		}

		// �t�@�C���p�X�A�t�@�C��URL��ݒ�
		String dirPath = helper.getConfig().getServletContext().getRealPath("/") + "export";
		String fileName = "xmlSpreadsheet" + request.getSession().getId() + ".xml";
		String filePath = dirPath + "/" + fileName;

		String fileURL = request.getContextPath() + "/" + Messages.getString("ExportReportAsCSV.exportTmpDir") + "/" + fileName;
		CommonUtils.loggingMessage(helper, log, "Export File URL(XMLSpreadSheet)", fileURL);

		helper.getRequest().setAttribute("downloadURL", fileURL);

		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		Connection conn = null;
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));


		FileOutputStream fs = null;
		OutputStreamWriter osw = null;
		PrintWriter out = null;
		try {

			// =============== ���ʏ����擾 ===============

			// �s�E��ɔz�u���ꂽ�SDimension�I�u�W�F�N�g��DimensionMember�I�u�W�F�N�g���Z�b�g
			report.setSelectedCOLROWDimensionMembers(helper, report, conn);

			// �Z���f�[�^(�l�͒P�ʃt�H�[�}�b�g�̂�)���擾
			ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(helper, conn, false, CellDataDAO.normalSQLTypeString);
			TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap = CellDataManager.getCellDataTable(report, cellDataList);	// �Z���f�[�^���e�[�u���`���Ƀ\�[�g������������

			// Index�ϊ��e�[�u��(Key:oldSpreadIndex, value:newSpreadIndex)
			xIndexChangeTable = getSpreadIndexChangeTable(dataRowMap,"x");
			yIndexChangeTable = getSpreadIndexChangeTable(dataRowMap,"y");

			// �G�b�W
			Col col = (Col) report.getEdgeByType(Constants.Col);
			Row row = (Row) report.getEdgeByType(Constants.Row);
			
			// �G�b�W�̎������X�g			
			ArrayList<Axis> colAxesList = col.getAxisList();
			ArrayList<Axis> rowAxesList = row.getAxisList();
			ArrayList<Axis> pageAxesList = report.getEdgeByType(Constants.Page).getAxisList();

			// �F���
			TreeMap<Integer, TreeMap<Integer, String>> colColorMap = this.getColorMap(helper, Constants.Col);
			TreeMap<Integer, TreeMap<Integer, String>> rowColorMap = this.getColorMap(helper, Constants.Row);
			TreeMap<Integer, TreeMap<Integer, String>> dataColorMap = this.getColorMap(helper, Constants.Data);

			// �F�ƃX�^�C��ID�̑Ή��\���쐬
			Hashtable<String, String> colColorStyleTable = getColorStyleList("s" + Constants.Col, colColorMap);	
			Hashtable<String, String> rowColorStyleTable = getColorStyleList("s" + Constants.Row, rowColorMap);
			Hashtable<String, String> dataColorStyleTable = getColorStyleList("s" + Constants.Data, dataColorMap);

			// �F�����I�u�W�F�N�g�ɕۑ�
			TableColorInfo colTableColorInfo = new TableColorInfo(("s" + Constants.Col), colColorMap, colColorStyleTable);
			TableColorInfo rowTableColorInfo = new TableColorInfo(("s" + Constants.Row), rowColorMap, rowColorStyleTable);
			TableColorInfo dataTableColorInfo = new TableColorInfo(("s" + Constants.Data), dataColorMap, dataColorStyleTable);


			String colIndexKeysString = (String)request.getSession().getAttribute("viewColIndexKey_hidden");
			String rowIndexKeysString = (String)request.getSession().getAttribute("viewRowIndexKey_hidden");

			// =============== XML Spreadsheet �t�@�C�����������J�n ===============

			fs = new FileOutputStream(filePath, false);	//�����̃t�@�C��������ꍇ�A�㏑������
			osw = new OutputStreamWriter(fs,"UTF-8");
			out = new PrintWriter(new BufferedWriter(osw));

			// =============== XML Spreadsheet �o�͊J�n ===============
			out.println("<?xml version=\"1.0\"?>");
			out.println("<?mso-application progid=\"Excel.Sheet\"?>");
			out.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
			out.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
			out.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
			out.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
			out.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");


			// ===== �X�^�C�� =====

			out.println("<Styles>");

				// �X�^�C�����̏o��
				out.println("<Style ss:ID=\"border\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"header\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
					out.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"sCOL\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
					out.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"sROW\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
					out.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"sDATA\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
				out.println("</Style>");

				// === �h��Ԃ����[�h�̐F�Â��ݒ�����ƂɃZ���̃X�^�C�����o�� ===
				// 		�P�D�s�E��̃Z���X�^�C�����o��
				// 		�����i�F�ݒ�̖����Z���j�FsCOL<colorIndex>
				// 		�����i�F�ݒ�̂���Z���j�FsROW<colorIndex>
				this.printColorStyle(colColorStyleTable, out);
				this.printColorStyle(rowColorStyleTable, out);

				// 		�Q�D�f�[�^�e�[�u�����̃Z���̃X�^�C�����o�́B
				// 		�߂�l�F���W���[�����o�[�^�C�v��groupName��Key�Ɏ����A�d������groupName��r�����V����0����U��Ȃ������C���f�b�N�X(memberTypeIndex)��Value�Ɏ���HashMap
				// 			    index�̓X�^�C��ID�̈ꕔ
				// 		�����i�F�ݒ�̖����Z��)�FsDATA_<memberTypeIndex>)
				// 		�����i�F�ݒ�̂���Z��)�FsDATA<colorIndex>_<memberTypeIndex>)
				HashMap<String, Integer> measureMemberTypeStyleIndexMap = this.printColorAndFormatStyle(dataColorStyleTable, report, out);


				// === �n�C���C�g���[�h�i�p�l�����[�h�͑ΏۊO�j�̐F�Â��ݒ�����ƂɃf�[�^�Z���̃X�^�C�����o�� ===
				this.printHighLightColorStyle(report, out);


			out.println("</Styles>");


			// ===== ���[�N�V�[�g =====
			out.println("<Worksheet ss:Name=\"Sheet1\">");
			out.println("<Table>");

			// ���|�[�g�^�C�g��
			this.printlnRowStartTag(out);
			this.printlnCell(report.getReportName(), "border", 0, 0, 0, "String", out);
			this.printlnRowEndTag(out);

			// �y�[�W�G�b�W����
			this.printlnRowStartTag(out);
			this.printlnCell("", "", 0, 0, 0, "String", out);

			Iterator<Axis> pageIt = pageAxesList.iterator();
			while (pageIt.hasNext()) {
				Axis axis = pageIt.next();
				this.printlnCell(axis.getName(), "border", 0, 0, 0, "String", out);
			}
			this.printlnRowEndTag(out);

			// �y�[�W�G�b�W�f�t�H���g�����o�[��
			this.printlnRowStartTag(out);
			this.printlnCell("�I�������o�[", "border", 0, 0, 0, "String", out);

			pageIt = pageAxesList.iterator();
			while (pageIt.hasNext()) {
				Axis axis = pageIt.next();
				this.printlnCell(axis.getDefaultMemberName(conn), "border", 0, 0, 0, "String", out);
			}
			this.printlnRowEndTag(out);

			// �󔒍s���o��
			this.printlnRowStartTag(out);
			this.printlnCell("", "", 0, 0, 0, "String", out);
			this.printlnRowEndTag(out);

			// ��w�b�_�̎������X�g
			this.printlnRowStartTag(out);
			for (i = 0; i < rowAxesList.size(); i++) {
				this.printlnCell("","", 0, 0, 0, "String", out);
			}
			Iterator<Axis> colIt = colAxesList.iterator();
			while (colIt.hasNext()) {
				Axis axis = colIt.next();
				this.printlnCell(axis.getName(),"header", 0, 0, 0, "String", out);
			}
			this.printlnRowEndTag(out);

			// ===== �N���X�w�b�_���A��w�b�_���o�� =====
			colIt = colAxesList.iterator();
			i = 0;
			while (colIt.hasNext()) {

				// �s�o�͂̊J�n�^�O
				this.printlnRowStartTag(out);
				Axis colAxis = colIt.next();

				// ===== �N���X�w�b�_�� =====
				if (i == (colAxesList.size()-1)) {	// �ŏI�i�̏ꍇ�A���^�C�g����\��

					// �s�w�b�_�̎������X�g
					Iterator<Axis> rowIt = rowAxesList.iterator();
					while (rowIt.hasNext()) {
						Axis rowAxis = rowIt.next();
						this.printlnCell(rowAxis.getName(),"header", 0, 0, 0, "String", out);
					}

				} else {

					// ��w�b�_�\���ʒu�𐮂��邽�߁A�󔒃Z�����o��
					for (j = 0; j < rowAxesList.size(); j++) {
						this.printlnCell("","header", 0, 0, 0, "String", out);
					}

				}

				// ===== ��w�b�_��(�����o�[�����o��) =====

				// SpreadIndex�̏��Ń\�[�g
				TreeMap<Integer, String> colIndexKeyMap = new TreeMap<Integer, String>();
				ArrayList<String> colIndexKeyList = StringUtil.splitString(colIndexKeysString, ",");
				Iterator<String> colIndexKeyIt = colIndexKeyList.iterator();

				while (colIndexKeyIt.hasNext()) {
					String colIndexKey = colIndexKeyIt.next();
					ArrayList<String> colIndexKeys = StringUtil.splitString(colIndexKey, ":");
					String index = colIndexKeys.get(0);
					Integer ind  = Integer.decode(index);
					String keys  = colIndexKeys.get(1);
					colIndexKeyMap.put(ind, keys);
				}

				Iterator<Integer> colIndexKeyMapIt = colIndexKeyMap.keySet().iterator();

				String beforeKey = null;
				String beforeKeys = null;
				int mergeNum = 0;
				int beforeJ  = 0;
				j = 0;
				while (colIndexKeyMapIt.hasNext()) {

					Integer index = colIndexKeyMapIt.next();
					String keys   = colIndexKeyMap.get(index);

					ArrayList<String> keyList = StringUtil.splitString(keys, ";");
					String key = keyList.get(i);

					if (isJoinMember(beforeKeys, keys, i)) {
						mergeNum++;
					} else {

						if ( j != 0 ) {
							String styleID = getCellStyle(colTableColorInfo, beforeJ, i);
							this.printlnCell(colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis), styleID, 0, mergeNum, 0, "String", out);
						}

						beforeJ = j;
						beforeKey = key;
						beforeKeys = keys;
						mergeNum = 0;
					}

					j++;
				}

				// �Ō�̗v�f��\������
				String styleID = getCellStyle(colTableColorInfo, beforeJ, i);
				this.printlnCell(colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis), styleID, 0, mergeNum, 0, "String", out);

				// �s�o�͂̏I���^�O
				this.printlnRowEndTag(out);
				i++;
		  	}
	
		
			// ===== �s�w�b�_��(�����o�[��)�A�f�[�^�Z����(�l)�o�� =====

			// SpreadIndex�̏��Ń\�[�g
			TreeMap<Integer, String> rowIndexKeyMap = new TreeMap<Integer, String>();
			ArrayList<String> rowIndexKeyList = StringUtil.splitString(rowIndexKeysString, ",");
			Iterator<String> rowIndexKeyIt = rowIndexKeyList.iterator();

			while (rowIndexKeyIt.hasNext()) {
				String rowIndexKey = rowIndexKeyIt.next();
				ArrayList<String> rowIndexKeys = StringUtil.splitString(rowIndexKey, ":");
				String index = rowIndexKeys.get(0);
				Integer ind  = Integer.decode(index);
				String keys  = rowIndexKeys.get(1);
				rowIndexKeyMap.put(ind, rowIndexKey);
			}

			// ArrayList�Ɏ�������
			Iterator<Integer> rowIndexKeyMapIt = rowIndexKeyMap.keySet().iterator();
			ArrayList<String> sortedIndexKeyList = new ArrayList<String>();
			while (rowIndexKeyMapIt.hasNext()) {
				Integer ind = rowIndexKeyMapIt.next();
				sortedIndexKeyList.add( rowIndexKeyMap.get(ind));
			}


			Iterator<String> rowIndexIt = sortedIndexKeyList.iterator();
			String beforeKeys = null;
			int rowIndex = 0;
			while (rowIndexIt.hasNext()) {
				String rowIndexKey = rowIndexIt.next();
				ArrayList<String> rowIndexKeys = StringUtil.splitString(rowIndexKey, ":");
				String index = rowIndexKeys.get(0);
				Integer ind  = Integer.decode(index);
				String keys  = rowIndexKeys.get(1);
				ArrayList<String> keyList = StringUtil.splitString(keys, ";");

				this.printlnRowStartTag(out);


				// �s�w�b�_�[�o��
				for (i = 0; i < rowAxesList.size(); i++ ){

					if (!this.isJoinMember(beforeKeys, keys, i)) { 
						Axis rowAxis = rowAxesList.get(i);
						String key   = keyList.get(i);
						AxisMember axisMember = (AxisMember) rowAxis.getAxisMemberByUniqueName(key);

						int rowCellMergeNum = this.getFollowingSameKeyNums(rowIndex, i, sortedIndexKeyList);

						String styleID = getCellStyle(rowTableColorInfo, i, rowIndex);
						this.printlnCell(axisMember.getSpecifiedDisplayName(rowAxesList.get(i)), styleID, (i+1), 0, rowCellMergeNum, "String", out);

					}

				}

				// �f�[�^�e�[�u�����o��
				this.printDataRow(report, dataRowMap, dataTableColorInfo, report.getMeasure(), measureMemberTypeStyleIndexMap, rowIndex, out);
				this.printlnRowEndTag(out);

				beforeKeys = keys;
				rowIndex++;
			}

			out.println("</Table>");

			// �E�C���h�E�g�Œ�
			// �f�[�^�e�[�u���̃Z��(0�s0��)�̍��W���Z�����̃C���f�b�N�X�ɕϊ�
			String horizontal = Integer.toString(5+report.getEdgeByType(Constants.Col).getAxisList().size());	// 
			String vertical = Integer.toString(0+report.getEdgeByType(Constants.Row).getAxisList().size());		// 
			out.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
				out.println("<FrozenNoSplit/>");
				out.println("<SplitHorizontal>" + horizontal + "</SplitHorizontal>");
				out.println("<TopRowBottomPane>" + horizontal + "</TopRowBottomPane>");
				out.println("<SplitVertical>" + vertical + "</SplitVertical>");
				out.println("<LeftColumnRightPane>"+ vertical + "</LeftColumnRightPane>");
				out.println("<ActivePane>0</ActivePane>");
			out.println("</WorksheetOptions>");


			out.println("</Worksheet>");
			out.println("</Workbook>");

			out.flush();
			osw.flush();

		} catch (FileNotFoundException e) {
			throw e;
		} catch (UnsupportedEncodingException e) {
			throw e;
		} catch (IOException e) {
			throw e;
		} catch (SQLException e) {
			throw e;
		} finally {

			if (fs != null) {
				try {
					fs.close();
				} catch (IOException e1) {
					throw e1;
				}
			}

			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e1) {
					throw e1;
				}
			}

		}

		// �ꎞ�ۑ������f�B�����V���������o�[�����폜����
		report.clearDimensionMembers();

		return "/spread/downloadAct.jsp";

	}


	// ********** private���\�b�h **************************************************


	// ********** private���\�b�h(style�֘A) **************************************************

	/**
	 * �Z���ɑ΂��ēK�p����X�^�C����ID�����߂�
	 * @param colorInfo �F�����i�[����I�u�W�F�N�g
	 * @param x ��w�b�_�A�s�w�b�_�A�f�[�^�e�[�u�����ł�X���W
	 * @param y ��w�b�_�A�s�w�b�_�A�f�[�^�e�[�u�����ł�Y���W
	 * @return �X�^�C��ID
	 */
	private String getCellStyle(TableColorInfo colorInfo, int x, int y) {

		String target = colorInfo.getTarget();
		TreeMap<Integer, TreeMap<Integer, String>> targetMap = colorInfo.getTargetmap();
		Hashtable<String, String> colorStyleTable = colorInfo.getColorStyletable();

		if (targetMap.containsKey(new Integer(y))) {
			TreeMap<Integer, String> colMap = targetMap.get(new Integer(y));
			if (colMap.containsKey(new Integer(x))) {
				String color = colMap.get(new Integer(x));
				if (colorStyleTable.containsKey(color)){
					String styleID = colorStyleTable.get(color);
					return styleID;
				} else {
					throw new IllegalStateException();
				}
			} else {
				return target;
			}
		} else { 
			return target;
		}
	}

	/**
	 * �Z���̃X�^�C���i�F�E�t�H�[�}�b�g�j���o��
	 * @param colorTable �F�ƃX�^�C��ID�̑Ή��\
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private HashMap<String, Integer> printColorAndFormatStyle(Hashtable<String, String> colorTable, Report report, PrintWriter out) {

		HashMap<String, Integer> measureMemberTypeStyleIndexMap = new HashMap<String, Integer>();
		Measure measure = report.getMeasure();
		ArrayList<AxisMember> targetMeasureMembers = null;
		if (report.isInPage(measure)) {
			targetMeasureMembers = new ArrayList<AxisMember>();
			MeasureMember measureMember = null;
			String defaultMemberKey = measure.getDefaultMemberKey();
			if (defaultMemberKey == null) {
				measureMember = (MeasureMember) measure.getAxisMemberList().get(0);
			} else {
				measureMember = (MeasureMember)measure.getAxisMemberByUniqueName(defaultMemberKey);
			}
			targetMeasureMembers.add(measureMember);
		} else { // ���W���[���s����ɂ���
			targetMeasureMembers = measure.getAxisMemberList();
		}


		// �F�ݒ�̖����Z���̃X�^�C�����o��
		int i = 0;
		Iterator<AxisMember> meaMemIte = targetMeasureMembers.iterator();
		while (meaMemIte.hasNext()) {
			MeasureMember measureMember = (MeasureMember)meaMemIte.next();
			if (measureMemberTypeStyleIndexMap.containsKey(measureMember.getMeasureMemberType().getGroupName()) ) {
				continue;
			} else {
				measureMemberTypeStyleIndexMap.put(measureMember.getMeasureMemberType().getGroupName(), new Integer(i));
				this.outStyle(null, null, true, measureMember, Integer.toString(i), out);
				i++;
			}
		}

		// �F�ݒ�̂���Ă���Z���̃X�^�C�����o��
		Iterator<String> colorIt = colorTable.keySet().iterator();
		if (colorTable.size()>0) {
			while (colorIt.hasNext()) {
				String color        = colorIt.next();
				String styleColorID = colorTable.get(color);

				HashMap<String, Integer> tmpMap = new HashMap<String, Integer>(); // ���W���[�����o�[�^�C�v�Ŋ��Ɏg�p���ꂽ�O���[�v�͏��O���邽�߂Ɏg�p����
				Iterator<AxisMember> ite = targetMeasureMembers.iterator();
				i = 0;
				while (ite.hasNext()) {

					MeasureMember measureMember = (MeasureMember)ite.next();
					if (tmpMap.containsKey(measureMember.getMeasureMemberType().getGroupName()) ) {
						continue;
					} else {
						tmpMap.put(measureMember.getMeasureMemberType().getGroupName(), new Integer(i));
						this.outStyle(styleColorID, color, true, measureMember, Integer.toString(i), out);
						i++;
					}
				}
			}
		}

		return measureMemberTypeStyleIndexMap;
	}


	/**
	 * �X�^�C���i�F�E�t�H�[�}�b�g�j���o��
	 * @param styleColorID �F�ƃX�^�C��ID�̑Ή��\
	 * @param color �Z���̐F������킷������
	 * @param isDataCell �f�[�^�e�[�u���̃Z���ł����true�A����ȊO�ł����false
	 * @param measureMember ���W���[�����o�[�̃I�u�W�F�N�g
	 * @param dataID ���W���[�̃����o�[�^�C�v����d����r�����AIndex��U��������
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private void outStyle(String styleColorID, String color, boolean isDataCell, MeasureMember measureMember, String dataID, PrintWriter out) {
		
		// �X�^�C��ID
		String styleID = null;
		if (isDataCell) { // �f�[�^�Z���̃X�^�C��
			if (styleColorID != null ) {
				styleID = styleColorID + "_" + dataID;

			} else {
				styleID = "sDATA" + "_" + dataID;
			}
		} else { // �f�[�^�Z���ȊO(�s�w�b�_�A��w�b�_)�̃X�^�C��
			styleID = styleColorID;
		}

		// �Z���̐��l�̃t�H�[�}�b�g
		String numberFormat = null;
		if ( isDataCell ) {
			numberFormat = measureMember.getMeasureMemberType().getXMLSpreadsheetFormat();
		}

		this.outputStyle(styleID, color, null, numberFormat, out);

	}



	/**
	 * �X�^�C���i�Z���g�A�����F�A�w�i�F�A���l�t�H�[�}�b�g�j���o��
	 * @param styleID �X�^�C��ID
	 * @param backColor �Z���̔w�i�F������킷������
	 *                   �inull�̏ꍇ�͐ݒ肵�Ȃ��j
	 * @param fontColor �Z���̕����F������킷������
	 *                   �inull�̏ꍇ�͐ݒ肵�Ȃ��j
	 * @param numberFormat �Z���̐��l�̃t�H�[�}�b�g������킷������
	 *                   �inull�̏ꍇ�͐ݒ肵�Ȃ��j
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private void outputStyle(String styleID, String backColor, String fontColor, String numberFormat, PrintWriter out) {
		
		// �X�^�C�����o�͊J�n
		out.println("<Style ss:ID=\"" + styleID + "\">");

			// �Z���g
			out.println("<Borders>");
			out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("</Borders>");

			// �Z�������F
			if (fontColor != null) {
				out.println("<Font ss:Color=\"" + fontColor + "\"/>");
			}

			// �Z���w�i�F
			if (backColor != null) {
				out.println("<Interior ss:Color=\"" + backColor + "\" ss:Pattern=\"Solid\"/>");
			}

			// �Z���̐��l�̃t�H�[�}�b�g
			if (numberFormat != null) {
				out.println("<NumberFormat ss:Format=\"" + numberFormat +  "\"/>");
			}

		out.println("</Style>");
		
	}


	/**
	 * �s�w�b�_�A��w�b�_�̃X�^�C�����o��
	 * @param colorTable �F���e�[�u��
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private void printColorStyle(Hashtable<String, String> colorTable, PrintWriter out) {

		Iterator<String> colorIt = colorTable.keySet().iterator();

		while (colorIt.hasNext()) {
			String color        = colorIt.next();
			String styleColorID = colorTable.get(color);

			this.outStyle(styleColorID,color,false, null,null,out);
		}
		
	}

	/**
	 * �n�C���C�g���[�h�̐ݒ�����ƂɃf�[�^�Z���̃X�^�C�����o�́i�p�l�����[�h�͑ΏۊO�j
	 * @param report ���|�[�g�e�[�u��
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private void printHighLightColorStyle(Report report, PrintWriter out) throws ParserConfigurationException, SAXException, IOException, DOMException, TransformerException, XPathExpressionException {

		// �n�C���C�g or �p�l�����[�h��
		if("2".equals((String)report.getColorType())){
			
			String highLightXML = report.getHighLightXML();
			if ( (highLightXML == null) || ("".equals(highLightXML)) ) {
				return;
			}

			XMLConverter xmlConverter = new XMLConverter();
			Document highLightXml = xmlConverter.toXMLDocument(highLightXML);

			// ���W���[���Ƀn�C���C�g���[�h���𔻒f����
			ArrayList<AxisMember> axisMemList = report.getMeasure().getAxisMemberList();
			Iterator<AxisMember> it = axisMemList.iterator();
			while (it.hasNext()) {
				AxisMember axisMember = it.next();
				if (axisMember instanceof MeasureMember) {
					MeasureMember measureMember = (MeasureMember) axisMember;

					String highLightPanelType = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/Mode").getFirstChild().getNodeValue();
					if("HighLight".equals(highLightPanelType)) { // �n�C���C�g���[�h
						
						// �n�C���C�g����
						for (int i=0; i<5; i++) {

							// styleID �̏����FhData[���W���[�����o�[��ID��]_[�n�C���C�g�����ԍ�(1�`5)]
							// �����W���[�����o�[��ID�F1����̒ʔԂŁAViewer�ō̔Ԃ������́B
							String styleID = "hData" + measureMember.getId() + "_" + (i+1);

							// �w�i�F
							String backColor = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "BackColor").getFirstChild().getNodeValue();

							// �����F
							String fontColor = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "TextColor").getFirstChild().getNodeValue();
							
							// �Z���̐��l�̃t�H�[�}�b�g������킷������
							String numberFormat = measureMember.getMeasureMemberType().getXMLSpreadsheetFormat();

							// �X�^�C�����o��
							this.outputStyle(styleID, backColor, fontColor, numberFormat, out);

						}

					}

				} else {
					// ���W���[�����o�[�̃��X�g�����擾�ł��Ȃ����߁A�G�N�Z�v�V����
					throw new IllegalStateException();
				}

			}
		}

	}


	/**
	 * �F�ƃX�^�C��ID�̑Ή��\�����߂�
	 * @param target ��w�b�_���A�s�w�b�_���A�f�[�^�e�[�u����������킷
	 * @param rowColorMap ��w�b�_�A�s�w�b�_�A�f�[�^�e�[�u���̍s������킷�I�u�W�F�N�g
	 * @return �F�ƃX�^�C��ID�̑Ή��\
	 */
	private Hashtable<String, String> getColorStyleList(String target, TreeMap<Integer, TreeMap<Integer, String>> rowColorMap) {
		
		Hashtable<String, String> colorStyleIDTable = new Hashtable<String, String>();
		
		Iterator<Integer> rowIte = rowColorMap.keySet().iterator();
		int i=0;
		while (rowIte.hasNext()) {
			Integer y = rowIte.next();
			TreeMap<Integer, String> colColorMap = rowColorMap.get(y);
			Iterator<Integer> colIte = colColorMap.keySet().iterator();
			while (colIte.hasNext()) {
				Integer    x = colIte.next();
				String color = colColorMap.get(x);

				if (!colorStyleIDTable.containsKey(color)) {
					colorStyleIDTable.put(color, (target + Integer.toString(i)));
					i++;
				}
			}
		}		
		
		return colorStyleIDTable;
	}

	// ********** private���\�b�h(�F���֘A) **************************************************


	/**
	 * �N���C�A���g����̃��N�G�X�g���F�����i�[����TreeMap�I�u�W�F�N�g�����߂�
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param target ��w�b�_���A�s�w�b�_���A�f�[�^�e�[�u����������킷
	 * @return �F�����i�[����TreeMap�I�u�W�F�N�g
	 */
	private TreeMap<Integer, TreeMap<Integer, String>> getColorMap(RequestHelper helper, String target) {

		String indexColorInfo = "";
		if (Constants.Col.equals(target)) {
			indexColorInfo = helper.getRequest().getParameter("colHdrColor");
		} else if (Constants.Row.equals(target)) {
			indexColorInfo = helper.getRequest().getParameter("rowHdrColor");
		} else if (Constants.Data.equals(target)) {
			indexColorInfo = helper.getRequest().getParameter("dataHdrColor");
		}
		
		TreeMap<Integer, TreeMap<Integer, String>> rowTreeMap = new TreeMap<Integer, TreeMap<Integer, String>>();// �s�w�b�_�A��w�b�_�A�f�[�^���̐F�����i�[����

		ArrayList<String> colorInfoList = StringUtil.splitString(indexColorInfo, ",");
		Iterator<String> colorInfoIt = colorInfoList.iterator();
		while (colorInfoIt.hasNext()) {
			String indexColorString = colorInfoIt.next();
			ArrayList<String> IndexColor = StringUtil.splitString(indexColorString, ";");
			String indexes  = IndexColor.get(0);
			String webColor = IndexColor.get(1); 

			// Web�J���[��\���X�^�C���������ƂɃZ���̐F�����߂�
			String xmlSpreadColor = null;
			if (Constants.Data.equals(target)) { // �f�[�^�e�[�u���̏ꍇ
				xmlSpreadColor = Messages.getString("ExportReportAsXMLSpreadsheetSchema.XMLSpreadsheetData" + webColor);
			} else { // �s�E��w�b�_�̏ꍇ
				xmlSpreadColor = Messages.getString("ExportReportAsXMLSpreadsheetSchema.XMLSpreadsheetHdr" + webColor);
			}
			ArrayList<String> indexList = StringUtil.splitString(indexes, ":");

			Integer x = null;
			Integer y = null;
			Integer oldX = Integer.decode((String)indexList.get(0));
			Integer oldY = Integer.decode((String)indexList.get(1));

			// �\���Z����SpreadIndex�����߂�
			// �EIndex��\���ΏۂƂȂ郁���o�[(�e���h�������Ŕ�\���ł��郁���o�[)�݂̂ŐU��Ȃ���
			// �E�F�Â��Ă���Z�����X�g�ɂ͕\���ΏۂƂȂ�Ȃ������o�[�i�e���h�������Ŕ�\���ł��郁���o�[�j���܂ނ��A���̏ꍇ�̓X�L�b�v����
			if (Constants.Col.equals(target)) {
				if (xIndexChangeTable.containsKey(oldX)) {
					x = (Integer)xIndexChangeTable.get(oldX);
					y = oldY;// ��G�b�W�ɂ�����iIndex
				} else {
					continue;
				}

			} else if (Constants.Row.equals(target)) {
				if (yIndexChangeTable.containsKey(oldY)) {
					x = oldX;// �s�G�b�W�ɂ�����iIndex
					y = (Integer)yIndexChangeTable.get(oldY);
				} else {
					continue;
				}
			} else { // �f�[�^�e�[�u���̃Z��
				if (!xIndexChangeTable.containsKey(oldX)) {
					continue;
				}
				if (!yIndexChangeTable.containsKey(oldY)) {
					continue;
				}
				x = (Integer)xIndexChangeTable.get(oldX);
				y = (Integer)yIndexChangeTable.get(oldY);	
			}

			TreeMap<Integer, String> cellMap = null;
			if (rowTreeMap.containsKey(y)) {
				cellMap = rowTreeMap.get(y);
				cellMap.put(x, xmlSpreadColor);
			} else {
				cellMap = new TreeMap<Integer, String>();
				cellMap.put(x, xmlSpreadColor);
				rowTreeMap.put(y, cellMap);	
			}
			
		}

		return rowTreeMap;
	}


	// ********** private���\�b�h(�Z���o�͊֘A) **************************************************

	/**
	 * �f�[�^�Z��������s�o�͂���
	 * @param report
	 * @param dataRowMap
	 * @param dataTableColorInfo
	 * @param measure
	 * @param measureMemberTypeStyleIndexMap
	 * @param newRowIndex
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private void printDataRow(Report report, TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap, TableColorInfo dataTableColorInfo, Measure measure, HashMap<String, Integer> measureMemberTypeStyleIndexMap, int newRowIndex, PrintWriter out) throws DOMException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {
//System.out.println("measureMemberTypeStyleIndexMap:" + measureMemberTypeStyleIndexMap);

		// �擾�ΏۂƂȂ�s�̃N���C�A���g���ł�SpreadIndex�̒l�ƁA�擾�ΏۂƂȂ�s�ɑ΂��āA�ʔԂŐU����Index��ϊ�����
		ArrayList<Integer> oldRowIndex = new ArrayList<Integer>(dataRowMap.keySet());
		TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(oldRowIndex.get(newRowIndex));
		Iterator<Integer> dataCellIt = dataCellMap.keySet().iterator();
		int x = 0;
		while (dataCellIt.hasNext()) {
			Integer colIndex  = dataCellIt.next();
			CellData cellData = dataCellMap.get(colIndex);
			MeasureMember measureMember = (MeasureMember)measure.getAxisMemberByUniqueName(cellData.getMeasureMemberUniqueName());
			String groupName = measureMember.getMeasureMemberType().getGroupName();
			String value = cellData.getValue();

			String styleID = null;
			String highlightID = this.getValidHighlightID(report, measureMember, cellData);
			if (highlightID != null) {
				styleID = "hData" + measureMember.getId() + "_" + highlightID;
			} else {
				styleID = getCellStyle(dataTableColorInfo, x, newRowIndex) + "_" + measureMemberTypeStyleIndexMap.get(groupName);
			}

			this.printlnCell(value, styleID, 0, 0, 0, "Number", out);
			x++;
		}
	}


	/**
	 * �s�J�n�^�O���o�͂���
	 */
	private void printlnRowStartTag(PrintWriter out) {
		out.println("<Row>");
	}

	/**
	 * �s�I���^�O���o�͂���
	 */
	private void printlnRowEndTag(PrintWriter out) {
		out.println("</Row>");
	}

	/**
	 * �Z�����o�͂���
	 * @param value �l
	 * @param cellStyle �X�^�C��ID
	 * @param cellIndex �Z���̗�C���f�b�N�X
	 * @param mergeAcross �Z�����E�����Ɍ������鐔
	 * @param mergeDown �Z�����������Ɍ������鐔
	 * @param dataType �Z���̃f�[�^�^�C�v�iString,Number���j
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private void printlnCell(String value, String cellStyle, int cellIndex, int mergeAcross, int mergeDown, String dataType, PrintWriter out) {

		String styleString = "";
		String dataString  = "";
			if ( cellStyle != "" ) {
				styleString = " ss:StyleID=\"" + cellStyle + "\"";
			}
			if ( dataType != "" ) {
				dataString = " ss:Type=\"" + dataType + "\"";
			} else {
				dataString = " ss:Type=\"String\"";
			}

		String cellMergeIndexString = "";
			if (cellIndex>0){
				cellMergeIndexString = " ss:Index=\"" + Integer.toString(cellIndex) + "\"";
			}

		String mergeAcrossString = "";
			if (mergeAcross > 0) {
				mergeAcrossString = " ss:MergeAcross=\"" + Integer.toString(mergeAcross) + "\"";
			}

		String mergeDownString = "";
			if (mergeDown > 0) {
				mergeDownString = " ss:MergeDown=\"" + Integer.toString(mergeDown) + "\"";
			}

		out.println("<Cell" + cellMergeIndexString + mergeAcrossString + mergeDownString + styleString + ">");
		out.print("<Data" + dataString + ">");
		out.print(value);
		out.println("</Data>");
		out.println("</Cell>");
		
	}

	// ********** private���\�b�h(���̑�) **************************************************

	/**
	 * �N���C�A���g����SpreadIndex��Key�Ƃ��A���\�����Ă���s�E��ɑ΂��ĐV���ɐU��Ȃ�����SpreadIndex��Value�ɂ���Index�ϊ��e�[�u����Ԃ��B
	 * @param dataRowMap TreeMap�I�u�W�F�N�g
	 * @param targetCoordinates ���W
	 * @return Index�ϊ��e�[�u��
	 */
	private Hashtable<Integer, Integer> getSpreadIndexChangeTable(TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap, String targetCoordinates) {
		if ((dataRowMap == null) || (targetCoordinates == null) ) { throw new IllegalArgumentException(); }
		if (targetCoordinates.equals("x") && (targetCoordinates.equals("y"))) { throw new IllegalArgumentException(); }

		Hashtable<Integer, Integer> targetChangeTable = new Hashtable<Integer, Integer>();
		
		Iterator<Integer> oldRowIndexIt = dataRowMap.keySet().iterator();
		int i = 0;
		while (oldRowIndexIt.hasNext()) {
			Integer oldRowIndex = oldRowIndexIt.next();

			if (targetCoordinates.equals("y")){
				targetChangeTable.put(oldRowIndex, new Integer(i));
			} else if (targetCoordinates.equals("x")) {
				TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(oldRowIndex);
				Iterator<Integer> oldColIndexIt = dataCellMap.keySet().iterator();
				int j = 0;
				while (oldColIndexIt.hasNext()) {
					Integer oldColIndex = oldColIndexIt.next();
					targetChangeTable.put(oldColIndex, new Integer(j));
					j++;
				}
				break;
			}
			i++;
		}

//System.out.println("targetChangeTable" + targetCoordinates + (new HashMap(targetChangeTable)));

		return targetChangeTable;
	
	}

	/**
	 * 0�i����w�肳�ꂽ�i�܂ł̃L�[�̑g�ݍ��킹�����������ł��邩�����߂�B
	 * @param spreadIndex Spread��Index
	 * @param hieIndex �iIndex
	 * @param indexKeyList indexKey�̃��X�g
	 * @return �����L�[�̑g�ݍ��킹��������
	 */
	private int getFollowingSameKeyNums(int spreadIndex, int hieIndex, ArrayList<String> indexKeyList) {

		String indexKey = indexKeyList.get(spreadIndex);
		ArrayList<String> indexKeyArray = StringUtil.splitString(indexKey, ":");
		String keys = indexKeyArray.get(1);
		ArrayList<String> keyList = StringUtil.splitString(keys, ";");

		int count = 0;
		for (int i = 0; i < (indexKeyList.size()-spreadIndex-1); i++ ){

			String nextIndexKey = indexKeyList.get(spreadIndex + (i+1));
			ArrayList<String> nextIndexKeys = StringUtil.splitString(nextIndexKey, ":");
			String nextkeys = nextIndexKeys.get(1);
			ArrayList<String> nextkeyList = StringUtil.splitString(nextkeys, ";");

			for (int j = 0; j < hieIndex+1; j++) {
				String key     = keyList.get(j);
				String nextKey = nextkeyList.get(j);

				if (!key.equals(nextKey)) { // �Z����������̈悩��o��
					return count;
				}
			}
			count++;
		}
		return count;
	}


	/**
	 * �n�C���C�g���[�h���ǂ����𔻒f�i�p�l�����[�h�����O�j���A�n�C���C�g���[�h�ł���ꍇ��
	 * �^����ꂽcellData�̒l���������n�C���C�g������ID�����߂�B
	 * �n�C���C�g���[�h�łȂ��A�������͊Y������������Ȃ��ꍇ�́Anull��߂��B
	 * @param value �l
	 * @param cellStyle �X�^�C��ID
	 * @param cellIndex �Z���̗�C���f�b�N�X
	 * @param mergeAcross �Z�����E�����Ɍ������鐔
	 * @param mergeDown �Z�����������Ɍ������鐔
	 * @param dataType �Z���̃f�[�^�^�C�v�iString,Number���j
	 * @param out PrintWriter�I�u�W�F�N�g
	 */
	private String getValidHighlightID(Report report, MeasureMember measureMember, CellData cellData) throws ParserConfigurationException, SAXException, IOException, DOMException, TransformerException, XPathExpressionException {
		
		String highLightID = null;
		
		// �n�C���C�g or �p�l�����[�h��
		if("2".equals((String)report.getColorType())){
			
			String highLightXML = report.getHighLightXML();
			if ( (highLightXML == null) || ("".equals(highLightXML)) ) {
				return null;
			}

			XMLConverter xmlConverter = new XMLConverter();
			Document highLightXml = xmlConverter.toXMLDocument(highLightXML);

			// ���[�h�擾
			String highLightPanelType = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/Mode").getFirstChild().getNodeValue();
			if("HighLight".equals(highLightPanelType)) { // �n�C���C�g���[�h

				// �Z���̒l�����߂�
				String cellValue = cellData.getValue2();
	
				// �擾�����l���܂ރn�C���C�g�̏��������邩��T��
				for (int i = 0; i < 5; i++) {

					Node fromNodeValue = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "From").getFirstChild();
					Node toNodeValue   =  xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "To").getFirstChild();

					// �n�C���C�g���[�h�͈̔͂����ݒ�ł���΁A�������X�L�b�v����B
					if ((fromNodeValue == null) || (toNodeValue == null)) {
						continue;
					}

					String fromValue = fromNodeValue.getNodeValue();
					String toValue   = toNodeValue.getNodeValue();

					double cellValueNum = Double.valueOf(cellValue).doubleValue();
						// [�����̏ꍇ��]�n�C���C�g�����͈̔͂�100�����̒l������킷���߁A����ɂ��낦�邽�߂�100���悷��B
						if ("percent".equals(measureMember.getMeasureMemberType().getGroupName())) {
							cellValueNum = cellValueNum * 100;
						}
					double fromValueNum = Double.valueOf(fromValue).doubleValue();
					double toValueNum   = Double.valueOf(toValue).doubleValue();

					if ((cellValueNum >= fromValueNum) && (cellValueNum <= toValueNum) ) {
						return String.valueOf(i+1);
					}

				}
			}
		
		}
		
		return highLightID;
	}


	// ********** inner�N���X **********

	/**
	 *  Inner�N���X�FTableColorInfo
	 *  �����F�F�����i�[����N���X�ł��B
	 */
	class TableColorInfo {

		String target   = "";
		TreeMap<Integer, TreeMap<Integer, String>> targetMap = null;
		Hashtable<String, String> colorStyleTable = null;
	
		public TableColorInfo(String target, TreeMap<Integer, TreeMap<Integer, String>> targetMap, Hashtable<String, String> colorStyleTable) {
			this.target = target;
			this.targetMap = targetMap;
			this.colorStyleTable = colorStyleTable;			
		}
	
		Hashtable<String, String> getColorStyletable() {
			return colorStyleTable;
		}
		String getTarget() {
			return target;
		}
		TreeMap<Integer, TreeMap<Integer, String>> getTargetmap() {
			return targetMap;
		}

		void setColorStyletable(Hashtable<String, String> hashtable) {
			colorStyleTable = hashtable;
		}
		void setTarget(String string) {
			target = string;
		}
		void setTargetmap(TreeMap<Integer, TreeMap<Integer, String>> map) {
			targetMap = map;
		}

	}

}
