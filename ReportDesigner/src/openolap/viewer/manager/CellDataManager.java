/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.manager
 *  �t�@�C���FCellDataManager.java
 *  �����F�f�[�^�e�[�u���̃Z���̒l���擾����N���X�ł��B
 *
 *  �쐬��: 2004/02/02
 */
package openolap.viewer.manager;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import openolap.viewer.CellData;
import openolap.viewer.EdgeCoordinates;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.CellDataSQL;
import openolap.viewer.dao.DAOFactory;

/**
 *  �N���X�FCellDataManager<br>
 *  �����F�f�[�^�e�[�u���̃Z���̒l���擾����N���X�ł��B
 */
public class CellDataManager {

	// ********** static ���\�b�h **********

	/**
	 * Session�ɓo�^���ꂽ�Z���f�[�^�擾���������ɃZ���f�[�^�����߂�B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @param formatValue �l�Ƀ��W���[�����o�[���ɐݒ肳�ꂽMeasureMemberType�̏�����K�p����Ȃ�true�A�P�ʂ݂̂����낦�鏑����K�p����Ȃ��false
	 * @param SQLType ���s����SQL�^�C�v��\��������BCellDataDAO�Q�ƁB
	 * @return �Z���f�[�^�I�u�W�F�N�g�̃��X�g
	 */
	public static ArrayList<CellData> selectCellDatas(RequestHelper helper, Connection conn, boolean formatValue, String SQLType) throws SQLException {

		HttpServletRequest request = helper.getRequest();
		HttpSession session = request.getSession();
		Report report =  (Report) session.getAttribute("report");

		int i;

//		   ===== ��w�b�_�E�s�w�b�_�E�y�[�W�G�b�W��� =====
//		   ��A�s�A�y�[�W�G�b�W�̎���ID/���W���[���X�g
//		   (�y�[�W�G�b�W�́A����ID/���W���[�ƑI�����ꂽ�l���y�A�Ŋi�[�B)
		Object[] items = new Object[3];		// 0:��G�b�W�A1:�s�G�b�W�A2:�y�[�W�G�b�W
			String colItemLists;			// ��G�b�W
			String rowItemLists;			// �s�G�b�W
			String pageItemValuePairs;		// �y�[�W�G�b�W

			String colItems[];				// colItemLists���A�e���ڂ��i�[�����z��
			String rowItems[];				// rowItemLists���A�e���ڂ��i�[�����z��
			String pageItemValues[];		// pageItemValuePairs���A�e���ڂ��i�[�����z��
											//�i�z��̊e�v�f�̏����@�u����ID�FKEY�v�j

			colItemLists       = (String) session.getAttribute("colEdgeIDList_hidden");
			rowItemLists       = (String) session.getAttribute("rowEdgeIDList_hidden");
			pageItemValuePairs = (String) session.getAttribute("pageEdgeIDValueList_hidden");
//System.out.println("colItemLists:" + colItemLists);
//System.out.println("rowItemLists:" + rowItemLists);


			ArrayList<String> colAxisList = StringUtil.splitString(colItemLists, ",");
			ArrayList<String> rowAxisList = StringUtil.splitString(rowItemLists, ",");
			ArrayList<String> pageItemValuePairList = StringUtil.splitString(pageItemValuePairs, ",");
			colItems       = (String[]) colAxisList.toArray(new String[colAxisList.size()]);
			rowItems       = (String[]) rowAxisList.toArray(new String[rowAxisList.size()]);
			pageItemValues = (String[]) pageItemValuePairList.toArray(new String[pageItemValuePairList.size()]);

		items[0] = colItems;
		items[1] = rowItems;
		items[2] = pageItemValues;

//		  ��E�s�y�[�W�G�b�W�ɐݒ肳�ꂽ����/���W���[��
		int[] hieNums = new int[3];				// 0:��G�b�W�A1:�s�G�b�W�A2:�y�[�W�G�b�W
			hieNums[0] = colItems.length;		// ��G�b�W
			hieNums[1] = rowItems.length;		// �s�G�b�W
			hieNums[2] = pageItemValues.length;	// �y�[�W�G�b�W

//		   �f�[�^�擾�ΏۂƂȂ��E�s�w�b�_��Key�������X�g
		Object[] selectKeys = new Object[2];	// 0:��G�b�W�A1:�s�G�b�W
			String selectColKeys[] = new String[hieNums[0]];	// ��w�b�_
			String selectRowKeys[] = new String[hieNums[1]];	// �s�w�b�_
			for ( i = 0; i < hieNums[0]; i++ ) {
				selectColKeys[i] = (String)session.getAttribute("viewCol" + i + "KeyList_hidden");
			}
			for ( i = 0; i < hieNums[1]; i++ ) {
				selectRowKeys[i] = (String)session.getAttribute("viewRow" + i + "KeyList_hidden");
			}

			selectKeys[0] = selectColKeys;
			selectKeys[1] = selectRowKeys;

//		   �f�[�^�擾�ΏۂƂȂ��E�s�w�b�_��Index,Key�������X�g
			ArrayList<EdgeCoordinates> colCoordinatesList = EdgeCoordinates.createCoordinates((String)session.getAttribute("viewColIndexKey_hidden"), colItems);	// ���EdgeCoordinates �̏W�����i�[����
			ArrayList<EdgeCoordinates> rowCoordinatesList = EdgeCoordinates.createCoordinates((String)session.getAttribute("viewRowIndexKey_hidden"), rowItems);	// ���EdgeCoordinates �̏W�����i�[����
				// <viewColIndexKey_hidden,viewRowIndexKey_hidden����>
				//	<SpreadIndex>:<0�Ԗڂ̒i����/���W���[�v�f��key>;
				//	<1�Ԗڂ̒i����/���W���[�v�f��key>;
				//	<2�Ԗڂ̒i����/���W���[�v�f��key>

		// �l���擾����SQL������킷�I�u�W�F�N�g���쐬����
  		CommonSettings commonSettings = (CommonSettings) helper.getConfig().getServletContext().getAttribute("apCommonSettings");
		CellDataSQL cellDataSQL = CellDataSQL.getSelectReportDataSQL(report, conn, items, selectKeys, formatValue, commonSettings );

		//�Z�����W�A�l���i�[����CellData�I�u�W�F�N�g�̃��X�g���쐬
		CellDataDAO cellDataDAO = DAOFactory.getDAOFactory().getCellDataDAO(conn);
		ArrayList<CellData> cellDataList = cellDataDAO.selectCellDatas( cellDataSQL,			// �Z���̒l���擾����SQL��\���I�u�W�F�N�g
															  items,				// ��ID�̃��X�g�i��ƍs���Ɂj
															  request,				// ���N�G�X�g�I�u�W�F�N�g
															  report,				// ���|�[�g�I�u�W�F�N�g
															  colCoordinatesList,	// �N���C�A���g����擾�����p�����[�^�����ɍ쐬��������W���X�g
															  rowCoordinatesList,	// �N���C�A���g����擾�����p�����[�^�����ɍ쐬�����s���W���X�g
															  SQLType);				// SQL�^�C�v

		cellDataSQL = null;

		return cellDataList;

	}


	/**
	 * �ȉ��Ɏ����Z���f�[�^�擾�p���^�������N�G�X�g����擾���A�Z�b�V�����ɉ��ۑ�����B
	 *   �|colEdgeIDList_hidden ��ɔz�u���ꂽ��ID�̃��X�g
	 *   �|rowEdgeIDList_hidden �s�ɔz�u���ꂽ��ID�̃��X�g
	 *   �|pageEdgeIDValueList_hidden �y�[�W�ɔz�u���ꂽ��ID�Ƃ��̃f�t�H���g�����o�[�L�[�̃��X�g
	 *   �|viewCol<0,1,2>KeyList_hidden �l���擾�����̊e�i�̃����o�[�L�[�̃��X�g
	 *   �|viewRow<0,1,2>KeyList_hidden �l���擾����s�̊e�i�̃����o�[�L�[�̃��X�g
	 *   �|viewColIndexKey_hidden �l���擾������SpreadIndex�Ɗe�i�̃����o�[�L�[�̑g�ݍ��킹�̃��X�g
	 *   �|viewRowIndexKey_hidden �l���擾����s��SpreadIndex�Ɗe�i�̃����o�[�L�[�̑g�ݍ��킹�̃��X�g
	 * @param helper RequestHelper�I�u�W�F�N�g
	 */
	public static void saveRequestParamsToSession(RequestHelper helper) {
		HttpServletRequest request = helper.getRequest();
		HttpSession session = helper.getRequest().getSession();

		// Session�ɓo�^
		session.setAttribute("colEdgeIDList_hidden", request.getParameter("colEdgeIDList_hidden"));
		session.setAttribute("rowEdgeIDList_hidden", request.getParameter("rowEdgeIDList_hidden"));
		session.setAttribute("pageEdgeIDValueList_hidden", request.getParameter("pageEdgeIDValueList_hidden"));

		String colIdList = (String)request.getParameter("colEdgeIDList_hidden");
		String rowIdList = (String)request.getParameter("rowEdgeIDList_hidden");

		int colSize = StringUtil.splitString(colIdList,",").size();
		int rowSize = StringUtil.splitString(rowIdList,",").size();

		int i = 0;
		for ( i = 0; i < colSize; i++ ) {
			session.setAttribute("viewCol" + i + "KeyList_hidden", request.getParameter("viewCol" + i + "KeyList_hidden"));
		}
		for ( i = 0; i < rowSize; i++ ) {
			session.setAttribute("viewRow" + i + "KeyList_hidden", request.getParameter("viewRow" + i + "KeyList_hidden"));
		}

		session.setAttribute("viewColIndexKey_hidden", request.getParameter("viewColIndexKey_hidden"));
		session.setAttribute("viewRowIndexKey_hidden", request.getParameter("viewRowIndexKey_hidden"));
		
	}


	/**
	 * �Z�b�V��������A�Z���f�[�^�擾�p�̃��^�����폜����B
	 * �폜����̂�saveRequestParamsToSession�œo�^�����p�����[�^�ł���B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 */

	public static void clearRequestParamForGetDataInfo(RequestHelper helper) {
		HttpServletRequest request = helper.getRequest();
		HttpSession session = helper.getRequest().getSession();

		String colIdList = (String)session.getAttribute("colEdgeIDList_hidden");
		String rowIdList = (String)session.getAttribute("rowEdgeIDList_hidden");
		
		session.removeAttribute("colEdgeIDList_hidden");
		session.removeAttribute("rowEdgeIDList_hidden");
		session.removeAttribute("pageEdgeIDValueList_hidden");

		int colSize = StringUtil.splitString(colIdList,",").size();
		int rowSize = StringUtil.splitString(rowIdList,",").size();

		int i = 0;
		for ( i = 0; i < colSize; i++ ) {
			session.removeAttribute("viewCol" + i + "KeyList_hidden");
		}
		for ( i = 0; i < rowSize; i++ ) {
			session.removeAttribute("viewRow" + i + "KeyList_hidden");
		}
		session.removeAttribute("viewColIndexKey_hidden");
		session.removeAttribute("viewRowIndexKey_hidden");
	}


	/**
	 * �Z���̒l���X�g��TreeMap�̃e�[�u���\���i�񎟌��l�����j�Ɋi�[���Ȃ����Ė߂��B
	 * �sIndex, ��Index�̏��Ƀ\�[�g�����B
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param cellDataList �Z���f�[�^�I�u�W�F�N�g�̔z��
	 * @return TreeMap�̃e�[�u���\��
	 */
	public static TreeMap<Integer, TreeMap<Integer, CellData>> getCellDataTable(Report report, ArrayList<CellData> cellDataList) {

//		ArrayList colAxesList = report.getEdgeByType(Constants.Col).getAxisList();
//		ArrayList rowAxesList = report.getEdgeByType(Constants.Row).getAxisList();

		int colAxisMemberComboNum = report.getAxisMeberComboNum(Constants.Col);
		int rowAxisMemberComboNum = report.getAxisMeberComboNum(Constants.Row);

		TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap = new TreeMap<Integer, TreeMap<Integer, CellData>>();
		
		// �s��SpreadIndex�̏��ɕ��ׂĂ����B
		// �s��SpreadIndex�������l�����v�f�W���ɑ΂��A���SpreadIndex���Ƀ\�[�g����
		// ��SpreadIndex�͕K�������ʔԂɂ͂Ȃ�Ȃ����Ƃɒ��ӁB�i�e��drill���ꂸ�ɔ�\���ł����E�s�̕��������j

		Iterator<CellData> it = cellDataList.iterator();
		while (it.hasNext()) {
			CellData cellData = it.next();
			
			if(dataRowMap.containsKey(cellData.getRowCoordinates().getIndex())) { // ���łɍs���o�^�ς݂̏ꍇ�A�s�ɃZ����ǉ�
				TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(cellData.getRowCoordinates().getIndex());
				dataCellMap.put(cellData.getColCoordinates().getIndex(), cellData);
			} else {	// �s�����o�^�̏ꍇ�A�s��ǉ�
				TreeMap<Integer, CellData> dataCellMap = new TreeMap<Integer, CellData>();
				dataCellMap.put(cellData.getColCoordinates().getIndex(), cellData);
				dataRowMap.put(cellData.getRowCoordinates().getIndex(), dataCellMap);
			}
		}

		return dataRowMap;
	}

}
