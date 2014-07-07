/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresCellDataDAO.java
 *  �����F�Z���f�[�^�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.CellData;
import openolap.viewer.EdgeCoordinates;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.common.Constants;


/**
 *  �N���X�FPostgresCellDataDAO<br>
 *  �����F�Z���f�[�^�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresCellDataDAO implements CellDataDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	private Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresCellDataDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * �Z���f�[�^�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresCellDataDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �Z���f�[�^�I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param cellDataSQL �Z���f�[�^�擾�pSQL������킷�I�u�W�F�N�g
	 * @param items ��A�s�A�y�[�W�G�b�W���̎�ID���X�g
	 *        items[0]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[1]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[2]�F�y�[�W�G�b�W�ɔz�u���ꂽ��ID�Ƃ��̃f�t�H���g�����o�[�L�[�̔z��
	 * @param request HttpServletRequest�I�u�W�F�N�g
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param colCoordinatesList ����W
	 * @param rowCoordinatesList �s���W
	 * @return �Z���f�[�^�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<CellData> selectCellDatas(CellDataSQL cellDataSQL, Object[] items, HttpServletRequest request, Report report, ArrayList<EdgeCoordinates> colCoordinatesList, ArrayList<EdgeCoordinates> rowCoordinatesList, String SQLType) throws SQLException {

		String[] FKColLists = cellDataSQL.getDimsFactKeyColumnList();
		// FKColLists�F�G�b�W�ɔz�u���ꂽ�f�B�����V�����ւ̃t�@�N�g�e�[�u���̃J�������X�g�i�����FDIM_03,DIM_02�j
		//			   ��i���珇�ɕ��ԁB�i�������A���W���[�̏ꍇ�͔�΂��j
		// 	FKColLists[0]:��
		// 	FKColLists[1]:�s

		ArrayList<CellData> cellDataList = new ArrayList<CellData>();	// �����ɂ��擾�����Z���f�[�^�I�u�W�F�N�g�i�[�p

		// �f�[�^����
		Statement stmt = null;
		ResultSet rs   = null;
		try {
			stmt = conn.createStatement();
			
			String SQL = "";
			if (CellDataDAO.normalSQLTypeString.equals(SQLType)) {
				SQL = cellDataSQL.getSQLString();
			} else if (CellDataDAO.sortedSQLTypeString.equals(SQLType)) {
				SQL = cellDataSQL.getSQLStringForSortData();
			} else {
				throw new IllegalArgumentException();
			}

			if(log.isInfoEnabled()) {
				log.info("SQL(select cell data)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			int i;
			StringTokenizer st = null;
			while ( rs.next() ) {

				LinkedHashMap<Integer, String> colIdKeyMap = new LinkedHashMap<Integer, String>();	// ���ID�Ƃ��̃����o�L�[(ResultSet�̊e���R�[�h����擾)
				LinkedHashMap<Integer, String> rowIdKeyMap = new LinkedHashMap<Integer, String>();	// �s��ID�Ƃ��̃����o�L�[(ResultSet�̊e���R�[�h����擾)


				// �f�[�^���R�[�h���s�E��ɔz�u���ꂽ������KEY���擾
				for ( i = 0; i < 2; i++ ) {
					st = new StringTokenizer(FKColLists[i],",");
					String[] edgeItemIDs = (String[]) items[i];	// �� or �s�̎�ID�z��
					int j=0;	// �J�E���^�B���W���[�͔�΂�
					while ( st.hasMoreTokens() ) {	// �� or �s�ɐݒ肳�ꂽ���̐��������s(���W���[������ꍇ�́A���̐�-1)
						if( edgeItemIDs[j].equals(Constants.MeasureID) ) {
							j++;
						}
						String edgeItemID = edgeItemIDs[j];	// ����ID(���W���[�͊܂܂Ȃ�)

						LinkedHashMap<Integer, String> axisIdKeyMap = null;

						if ( i == 0) {			// ��
							axisIdKeyMap = colIdKeyMap;
						} else if ( i == 1 ) {	// �s
							axisIdKeyMap = rowIdKeyMap;
						}
						axisIdKeyMap.put(Integer.decode(edgeItemID), rs.getString(st.nextToken()));
						j++;
					}
				}

				// �f�[�^���R�[�h��胁�W���[���X�g���擾
				if (( this.getTempMeasurePosition(items).equals(Constants.Col)) || this.getTempMeasurePosition(items).equals(Constants.Row)) {
					// �������ʂ̂P���R�[�h���CellData�I�u�W�F�N�g�̏W���𐶐�

					for ( i = 0; i < report.getTotalMeasureMemberNumber(); i++ ) {

						// �Z���N�^�őΏۂ���͂�����Ă��邩���`�F�b�N
						MeasureMember measureMember = (MeasureMember) report.getMeasure().getAxisMemberByUniqueName(Integer.toString(i+1));
						if (!measureMember.isSelected()){
							 continue;
						}


						LinkedHashMap<Integer, String> tmpColIdKeyMap = null;
						LinkedHashMap<Integer, String> tmpRowIdKeyMap = null;

						// ���W���[����ǉ�
						if ( this.getTempMeasurePosition(items).equals(Constants.Col)) {
							tmpColIdKeyMap = addMeasureMemInfo(colIdKeyMap, Integer.toString(i+1), report, items);
							tmpRowIdKeyMap = rowIdKeyMap;
 						} else if (this.getTempMeasurePosition(items).equals(Constants.Row)) {
							tmpColIdKeyMap = colIdKeyMap;
							tmpRowIdKeyMap = addMeasureMemInfo(rowIdKeyMap, Integer.toString(i+1), report, items);
						}

						CellData cellData = this.createCellData( tmpColIdKeyMap, 
																  tmpRowIdKeyMap, 
																  rs.getString("measure_" + (i+1)), // �l
																  colCoordinatesList, 
																  rowCoordinatesList,
																  Integer.toString(i+1),			// ���W���[�����o�[��UName
																  measureMember.getMeasureSeq()		// ���W���[�����o�[�̃��W���[�V�[�P���X
																  );

 						if (cellData != null) {
							cellDataList.add(cellData);	// �Z���f�[�^�I�u�W�F�N�g�̏W���ɒǉ�
 						}
					}

				} else if ( this.getTempMeasurePosition(items).equals(Constants.Page) ) {


					// �������ʂ̂P���R�[�h���P����CellData�I�u�W�F�N�g�𐶐�
					CellData cellData = this.createCellData(colIdKeyMap, 
															 rowIdKeyMap, 
															 rs.getString("measure_" + cellDataSQL.getMeasureDefaultMember()), 	// �l
															 colCoordinatesList, 
															 rowCoordinatesList,
															 cellDataSQL.getMeasureDefaultMember(),		// ���W���[�����o�[��UName
															 cellDataSQL.getMeasureDefaultMeasureSeq()	// ���W���[�����o�[�̃��W���[�V�[�P���X
															 );

					if (cellData != null) {
						cellDataList.add(cellData);	// �Z���f�[�^�I�u�W�F�N�g�̏W���ɒǉ�
					}

				}

			 }
	
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (rs != null){
					rs.close();
				}
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (stmt != null){
						stmt.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}

		return cellDataList;
	}


	// ********** private���\�b�h **********

	/**
	 * �N���C�A���g���瑗�M���ꂽ�������ƂɃ��W���[�̔z�u�G�b�W�����߂�B
	 * @param items ��A�s�A�y�[�W�G�b�W���̎�ID���X�g
	 *        items[0]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[1]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[2]�F�y�[�W�G�b�W�ɔz�u���ꂽ��ID�Ƃ��̃f�t�H���g�����o�[�L�[�̔z��
	 * @return �G�b�W�̎�ނ�����킷������i�uCOL�v�A�uROW�v�A�uPAGE�v�j
	 */
	private String getTempMeasurePosition(Object[] items) {

		int i = 0;

		// ���ID���X�g
		String[] colItemIDs = (String[]) items[0];
		for ( i = 0; i < colItemIDs.length; i++ ) {
			if (colItemIDs[i].equals(Constants.MeasureID) ){
				return Constants.Col;
			}
		}
		
		// �s��ID���X�g
		String[] rowItemIDs = (String[]) items[1];
		for ( i = 0; i < rowItemIDs.length; i++ ) {
			if (rowItemIDs[i].equals(Constants.MeasureID) ){
				return Constants.Row;
			}
		}
		return Constants.Page;
	}


	/**
	 * ���W���[�̃G�b�W���ł̃C���f�b�N�X�i0start�j�����߂�B
	 * @param items ��A�s�A�y�[�W�G�b�W���̎�ID���X�g
	 *        items[0]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[1]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[2]�F�y�[�W�G�b�W�ɔz�u���ꂽ��ID�Ƃ��̃f�t�H���g�����o�[�L�[�̔z��
	 * @return �G�b�W���ł̃C���f�b�N�X
	 */
	private int getTempMeasureHieIndex(Object[] items) {

		int i = 0;

		// ���ID���X�g
		String[] colItemIDs = (String[]) items[0];
		for ( i = 0; i < colItemIDs.length; i++ ) {
			if (colItemIDs[i].equals(Constants.MeasureID) ){
				return i;
			}
		}
		
		// �s��ID���X�g
		String[] rowItemIDs = (String[]) items[1];
		for ( i = 0; i < rowItemIDs.length; i++ ) {
			if (rowItemIDs[i].equals(Constants.MeasureID) ){
				return i;
			}
		}
		return -1;
	}

	/**
	 * ���W���[�����݂���G�b�W�i��or�s)��LinkedHashMap(��ID,�����o�[�L�[)�ɁA���W���[����ǉ�����
	 * @param targetEdgeMap �s�܂��͗��Map�I�u�W�F�N�g
	 * @param measureKey ���W���[�L�[
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param items ��A�s�A�y�[�W�G�b�W���̎�ID���X�g
	 *        items[0]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[1]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[2]�F�y�[�W�G�b�W�ɔz�u���ꂽ��ID�Ƃ��̃f�t�H���g�����o�[�L�[�̔z��
	 * @return ��ID��Key�Ɏ����A�����o�[�L�[��Value�Ɏ���LinkedHashMap�I�u�W�F�N�g
	 */
	private LinkedHashMap<Integer, String> addMeasureMemInfo(LinkedHashMap<Integer, String> targetEdgeMap, String measureKey, Report report,Object[] items) {
		LinkedHashMap<Integer, String> newHashMap = new LinkedHashMap<Integer, String>();

		// ���W���[�̃G�b�W���ł̃C���f�b�N�X(0start)
		int measureHieIndex = this.getTempMeasureHieIndex(items);

		// ���W���[��\������ǉ�
		if ( measureHieIndex == targetEdgeMap.size()) {	// �ŏI�i�����W���[
			newHashMap.putAll(targetEdgeMap);
			newHashMap.put(Integer.decode(Constants.MeasureID), measureKey);
		} else {
			Iterator<Integer> it = targetEdgeMap.keySet().iterator();
			int i = 0;
			while (it.hasNext()) {
				Integer id = it.next();
				String key = targetEdgeMap.get(id);
				
				if ( i == measureHieIndex ) {
					newHashMap.put(Integer.decode(Constants.MeasureID), measureKey);
				} 
				newHashMap.put(id, key);
				i++;
			}
		}

		return newHashMap;
	}

	/**
	 * CellData�I�u�W�F�N�g�����߂�B
	 * �쐬�ł��Ȃ��ꍇ��null��߂��B
	 * @param colIdKeyMap ��̎�ID��Key�ɂ����A�����o�[�L�[��Value�Ɏ���Map�I�u�W�F�N�g
	 * @param rowIdKeyMap �s�̎�ID��Key�ɂ����A�����o�[�L�[��Value�Ɏ���Map�I�u�W�F�N�g
	 * @param value �l
	 * @param colCoordinatesList �s��EdgeCoordinates�I�u�W�F�N�g�̃��X�g
	 * @param rowCoordinatesList ���EdgeCoordinates�I�u�W�F�N�g�̃��X�g
	 * @param measureMemberUName ���W���[�����o�[��UniqueName(Viewer��0����U�����ʔ�)
	 * @param measureSeq ���W���[�����o�[�̃��W���[�V�[�P���X
	 * @return ��ID��Key�Ɏ����A�����o�[�L�[��Value�Ɏ���LinkedHashMap�I�u�W�F�N�g
	 */

	private CellData createCellData(LinkedHashMap<Integer, String> colIdKeyMap, LinkedHashMap<Integer, String> rowIdKeyMap, String value, ArrayList<EdgeCoordinates> colCoordinatesList, ArrayList<EdgeCoordinates> rowCoordinatesList, String measureMemberUName, String measureSeq) {

		// ���EdgeCoordinates�I�u�W�F�N�g���擾
		EdgeCoordinates colCoordinates = null;
			Iterator<EdgeCoordinates> colIt = colCoordinatesList.iterator();
			while (colIt.hasNext()) {
				EdgeCoordinates edgeCoordinates = colIt.next();
				LinkedHashMap<Integer, String> axisIdKeyMap = edgeCoordinates.getAxisIdMemKeyMap();
				if ( mapHasSameKeyAndValue(colIdKeyMap, axisIdKeyMap) ) {
					colCoordinates = edgeCoordinates;
					break;
				}
			}
		
		// �s��EdgeCoordinates�I�u�W�F�N�g���擾
		EdgeCoordinates rowCoordinates = null;
		Iterator<EdgeCoordinates> rowIt = rowCoordinatesList.iterator();
		while (rowIt.hasNext()) {
			EdgeCoordinates edgeCoordinates = rowIt.next();
			LinkedHashMap<Integer, String> axisIdKeyMap = edgeCoordinates.getAxisIdMemKeyMap();
			if ( mapHasSameKeyAndValue(rowIdKeyMap, axisIdKeyMap) ) {
				rowCoordinates = edgeCoordinates;
				break;
			}
		}

		if ( (colCoordinates == null) || (rowCoordinates == null) ) {
		// �����i�̏ꍇ�ɁA�擾�������f�[�^�ɑ΂��ASQL���Ԃ��f�[�^���璷�ł���ꍇ������B
		// ���̏ꍇ�ACellData�I�u�W�F�N�g�͐������Ȃ�
		// ��j0�i�F��ID16�A1�i�F��ID1�̂Ƃ��A��ID16�̃����o(Key=0)�ɑ����鎲ID1�̃����o(Key=1)�Ńh����
		//     DB����̎擾���ʂɂ́A��ID16��Key0�ȊO�̃����o�ɑ����鎲ID1�̃����o(Key=1)�̒l���܂܂��

			return null;
		}

		
		// CellData�I�u�W�F�N�g����
		CellData cellData = new CellData(colCoordinates, rowCoordinates, measureMemberUName, measureSeq);
		cellData.setValue(value);	// �l��ݒ�
		
		return cellData;
	}


	/**
	 * �^����ꂽ�Q��LinkedHashMap������Key��Value�����ꍇtrue�A�����Ȃ��ꍇfalse��߂��B
	 * @param map1 ��̎�ID��Key�ɂ����A�����o�[�L�[��Value�Ɏ���Map�I�u�W�F�N�g
	 * @param map2 �s�̎�ID��Key�ɂ����A�����o�[�L�[��Value�Ɏ���Map�I�u�W�F�N�g
	 * @return ����Key,Value������
	 */
	private boolean mapHasSameKeyAndValue( LinkedHashMap<Integer, String> map1, LinkedHashMap<Integer, String> map2  ) {
		if ( ( map1 == null) || ( map2 == null) ) { return false; }

		// �v�f����r
		if ( map1.size() != map2.size() ) {
			return false;
		}
		
		// �v�f���r�iKey�Avalue�̎��l�����������j
		Iterator<Integer> it1 = map1.keySet().iterator();
		Iterator<Integer> it2 = map2.keySet().iterator();
		while ( it1.hasNext() ) {
			Integer map1Key = it1.next();
			Integer map2Key = it2.next();

			if ( !map1Key.equals(map2Key) ) {
				return false;
			}

			String map1Value = map1.get(map1Key);
			String map2Value = map2.get(map1Key);

			if ( !map1Value.equals(map2Value) ) {
				return false;
			}
		}
		return true;
	}


}
