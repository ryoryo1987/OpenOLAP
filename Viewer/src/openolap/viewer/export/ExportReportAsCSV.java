/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.export
 *  �t�@�C���FExportReportAsCSV.java
 *  �����FCSV�`���Ń��|�[�g���G�N�X�|�[�g����N���X�ł��B
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
import java.util.Iterator;
import java.util.TreeMap;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.CellData;
import openolap.viewer.Col;
import openolap.viewer.Report;
import openolap.viewer.Row;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.Constants;
import openolap.viewer.common.Messages;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  �N���X�FExportReportAsCSV<br>
 *  �����FCSV�`���Ń��|�[�g���G�N�X�|�[�g����N���X�ł��B
 */
public class ExportReportAsCSV extends ExportReport {


	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(ExportReportAsCSV.class.getName());


	// ********** ���\�b�h **********


	/**
	 * �G�N�X�|�[�g���������s���A�_�E�����[�h�y�[�W�̃p�X��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 * @exception FileNotFoundException �������ɗ�O����������
	 * @exception UnsupportedEncodingException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������UnsupportedEncodingException
	 */
	public String exportReport(RequestHelper helper) throws SQLException, NamingException, IOException {

		HttpServletRequest request = helper.getRequest();
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		if (report==null) {
			throw new IllegalStateException();
		}

		// �t�@�C���p�X�A�t�@�C��URL��ݒ�
		String dirPath = helper.getConfig().getServletContext().getRealPath("/") + "export";
		String fileName = "report" + request.getSession().getId() + ".csv";
		String filePath = dirPath + "/" + fileName;
		String fileURL = request.getContextPath() + "/" + Messages.getString("ExportReportAsCSV.exportTmpDir") + "/" + fileName; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
		CommonUtils.loggingMessage(helper, log, "Export File URL(CSV)", fileURL);

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

			// �Z���f�[�^(�l�̓t�H�[�}�b�g�t)���擾
			ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(helper, conn, true, CellDataDAO.normalSQLTypeString);
			// �Z���f�[�^���e�[�u���`���Ƀ\�[�g������������
			TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap = CellDataManager.getCellDataTable(report, cellDataList);

			// �G�b�W
			Col col = (Col) report.getEdgeByType(Constants.Col);
			Row row = (Row) report.getEdgeByType(Constants.Row);
			
			// �G�b�W�̎������X�g
			ArrayList<Axis> colAxesList = col.getAxisList();
			ArrayList<Axis> rowAxesList = row.getAxisList();
			ArrayList<Axis> pageAxesList = report.getEdgeByType(Constants.Page).getAxisList();


			String colIndexKeysString = (String)request.getSession().getAttribute("viewColIndexKey_hidden");
			String rowIndexKeysString = (String)request.getSession().getAttribute("viewRowIndexKey_hidden");

			// =============== CSV�t�@�C�����������J�n ===============
			fs = new FileOutputStream(filePath, false);	//�����̃t�@�C��������ꍇ�A�㏑������
			osw = new OutputStreamWriter(fs,"Shift_JIS");
			out = new PrintWriter(new BufferedWriter(osw));


			// =============== CSV�o�͊J�n ===============

			// ���|�[�g�^�C�g��
			out.println(report.getReportName());

			// �y�[�W�G�b�W����, �y�[�W�G�b�W�f�t�H���g�����o�[��
			String pageAxisName = ",";
			String memberName = "�I�������o�[,";
			Iterator<Axis> pageIt = pageAxesList.iterator();
			int i = 0;
			int j = 0;
			int k = 0;
			while (pageIt.hasNext()) {
				if(i>0){
					pageAxisName += ",";
					memberName += ",";
				}
				Axis axis = pageIt.next();
				pageAxisName += axis.getName();
				memberName += axis.getDefaultMemberName(conn);
				i++;
			}
			out.println(pageAxisName);
			out.println(memberName);

			out.println();	// ��s

			// ��w�b�_�̎������X�g
			String colAxisName = null;
				colAxisName = StringUtil.addString("","first",rowAxesList.size(),",");
			Iterator<Axis> colIt = colAxesList.iterator();
			i = 0;
			while (colIt.hasNext()) {
				if (i>0) {
					colAxisName += ",";
				}
				Axis axis = colIt.next();
				colAxisName += axis.getName();
				i++;
			}
			out.println(colAxisName);

			// �N���X�w�b�_���A��w�b�_���o��

			// �s�w�b�_�̎������X�g����
			String rowAxisName = "";
			Iterator<Axis> rowIt = rowAxesList.iterator();
			i = 0;
			while (rowIt.hasNext()) {
				if (i>0) {
					rowAxisName += ",";
				}
				Axis axis = rowIt.next();
				rowAxisName += axis.getName();
				i++;
			}

			colIt = colAxesList.iterator();
			i = 0;
			while (colIt.hasNext()) {
				Axis colAxis = (Axis) colIt.next();
				int colMergeNum = getCellMergeNum(col, colAxis)+1;	// �Z����������Z���̐�

				// ===== �N���X�w�b�_�� =====
				if (i == (colAxesList.size()-1)) {	// �ŏI�i�̏ꍇ�A���^�C�g����\��
						out.print(rowAxisName);
				} else {
					out.print(StringUtil.addString("", "first", rowAxesList.size()-1, ","));
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
//System.out.println(i + "," + j + "," + colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis) + mergeNum);

							out.print(",");
							out.print("\"" + colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis) + "\"");
							out.print(StringUtil.addString("", "first", mergeNum, ",")); // �Z���̕��̕�����","���o��

						}

						beforeKey = key;
						beforeKeys = keys;
						mergeNum = 0;
					}

					j++;
				}

				// �Ō�̗v�f��\������
				if (j > 0) { // ��w�b�_�̗v�f����ȏ㑶�݂���
					out.print(",");
				}

				out.print("\"" + colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis) + "\"");
				out.print(StringUtil.addString("", "first", mergeNum, ",")); // �Z���̕��̕�����","���o��

				// �s�o�͂̏I���^�O
				out.println();
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

				// �s�w�b�_�[�o��
				for (i = 0; i < rowAxesList.size(); i++ ){

					if (!this.isJoinMember(beforeKeys, keys, i)) { 
						Axis rowAxis = rowAxesList.get(i);
						String key   = keyList.get(i);
						AxisMember axisMember = (AxisMember) rowAxis.getAxisMemberByUniqueName(key);

						out.print("\"" + axisMember.getSpecifiedDisplayName((Axis)rowAxesList.get(i)) + "\"");
						out.print(","); // ���̃Z���Ƃ̋�؂�i���i�̍s�w�b�_�����o�[�Z���������̓f�[�^�e�[�u���Z���j
					} else {
						out.print(","); // ���̃Z���͌����ΏۂƂȂ�Z���ł���A���͕̂\�����Ȃ����A��؂蕶���͏o�͂���
					}
				}

				// �f�[�^�e�[�u�����o��
				this.printDataRow(dataRowMap, rowIndex, out);

				beforeKeys = keys;
				rowIndex++;
			}

			out.println(); // ���s

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

	// ********** private���\�b�h **********

	/**
	 * �f�[�^�e�[�u��������s�o�͂���
	 * @param dataRowMap �f�[�^�s������킷Map�I�u�W�F�N�g
	 * @param newRowIndex �o�͂����̃C���f�b�N�X
	 * @param out PrintWriter������킷�I�u�W�F�N�g
	 */
	private void printDataRow(TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap, int newRowIndex, PrintWriter out) {

		// �擾�ΏۂƂȂ�s�̃N���C�A���g���ł�SpreadIndex�̒l�ƁA�擾�ΏۂƂȂ�s�ɑ΂��āA�ʔԂŐU����Index��ϊ�����
		ArrayList<Integer> oldRowIndex = new ArrayList<Integer>(dataRowMap.keySet());
		TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(oldRowIndex.get(newRowIndex));
		Iterator<Integer> dataCellIt = dataCellMap.keySet().iterator();
		int i = 0;
		while (dataCellIt.hasNext()) {
			Integer colIndex = dataCellIt.next();
			String value = "\"" + ( dataCellMap.get(colIndex) ).getValue() + "\"";

			if (i>0) {
				out.print(",");
			}
			out.print(value);
			i++;
		}
		// ���s
		out.println();
	}

}
