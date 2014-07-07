/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresColorDAO.java
 *  �����F�F�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/15
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.Color;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;

/**
 *  �N���X�FPostgresColorDAO<br>
 *  �����F�F�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresColorDAO implements ColorDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresColorDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * �F�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresColorDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �f�[�^�\�[�X���F�ݒ�����߁A���|�[�g�I�u�W�F�N�g�ɓo�^����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void applyColor(Report report, Connection conn) throws SQLException {

		ArrayList<Color> colorList = new ArrayList<Color>();

		// SQL����
		String SQL = "";
		SQL += "select ";
		SQL += "    edge_id_combo, ";
		SQL += "    edge_mem_key1, ";
		SQL += "    edge_mem_key2, ";
		SQL += "    edge_mem_key3, ";
		SQL += "    edge_mem_key4, ";
		SQL += "    edge_mem_key5, ";
		SQL += "    edge_mem_key6, ";
		SQL += "    headerFLG, ";
		SQL += "    html_color ";
		SQL += "from ";
		SQL += "    oo_v_color ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID() + " ";
		SQL += "order by ";
		SQL += "    edge_id_combo";
		
		// SQL���s
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select header and data cell color)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {

				// �F�Â����ꂽ�Z���̍��W��\��TreeMap���쐬
				ArrayList<String> axisIdList = StringUtil.splitString(rs.getString("edge_id_combo"),",");
				TreeMap<Integer, String> axisIDAndMemberKeyMap = new TreeMap<Integer, String>();

				Iterator<String> axisIdIt = axisIdList.iterator();
				int i = 0;
				while (axisIdIt.hasNext()) {
					String axisId = axisIdIt.next();											// ��ID
					String axisMemberKey = rs.getString("edge_mem_key"+Integer.toString(i+1));	// ��L�����̃����o�[Key
					axisIDAndMemberKeyMap.put(Integer.decode(axisId),axisMemberKey);
					i++;
				}

				// Color�I�u�W�F�N�g�𐶐�
				Color color = new Color( axisIDAndMemberKeyMap, 		// axisIDAndMemberKeyMap 
										  CommonUtils.FLGTobool(rs.getString("headerFLG")), // isHeader
										  rs.getString("html_color"));	// HTMLColor

				// �쐬����Color�I�u�W�F�N�g��ArrayList�ɒǉ�
				colorList.add(color);

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
		
		// ���|�[�g�I�u�W�F�N�g��Color�I�u�W�F�N�g�̏W����o�^
		report.addColor(colorList);

	}

	/**
	 * �N���C�A���g�����瑗���Ă����F�����T�[�o�[���̃��f���ɔ��f����B<br>
	 * �N���C�A���g�����M�������F<br>
	 *   �EdtColorInfo  �F �f�[�^�e�[�u�����̐F���
	 *   �EhdrColorInfo �F �w�b�_�[���̐F���
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 */
	public void registColor(RequestHelper helper, CommonSettings commonSettings) {

		// �N���C�A���g�����M���������擾
		HttpServletRequest request = helper.getRequest();
		String dtColorInfoListString = (String)request.getParameter("dtColorInfo");
		String hdrColorInfoListString = (String)request.getParameter("hdrColorInfo");

	  	Report report = (Report)request.getSession().getAttribute("report");

		// �F�����N���A
		report.clearColorList();

		// �f�[�^�e�[�u���̐F����Report�I�u�W�F�N�g�ɒǉ�
		ArrayList<Color> dtColorInfoList = changeColorList(dtColorInfoListString, false);
		report.addColor(dtColorInfoList);

		// �w�b�_�̐F����Report�I�u�W�F�N�g�ɒǉ�
		ArrayList<Color> hdrColorInfoList = changeColorList(hdrColorInfoListString, true);
		report.addColor(hdrColorInfoList);

	}


	/**
	 * �F�����i��������B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�ŐF����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�ŐF����ۑ�����B
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveColor(Report report, String reportID, Connection conn) throws SQLException {

		// �ۑ��ΏۂƂȂ郌�|�[�gID�����߂�
		String reportIDValue = null;
		if (reportID == null) {
			reportIDValue = report.getReportID();
		} else {
			reportIDValue = reportID;
		}

		// �����̐F�ݒ�͑S�č폜���Ă���insert
		// delete
		this.deleteColor(reportIDValue, conn);

		Iterator<Color> it = report.getColorList().iterator();
		while (it.hasNext()) {
			Color color = it.next();
			String edgeIdCombo = "";
			String[] edgeMemKey = new String[6];

			TreeMap<Integer, String> axisIDAndMemberKeyTree = color.getAxisIDAndMemberKeyMap();
			Iterator<Integer> keyIt = axisIDAndMemberKeyTree.keySet().iterator();
			int i = 0;
			while (keyIt.hasNext()) {
				if(i>0){
					edgeIdCombo += ",";
				}
				Integer key = keyIt.next();
				edgeIdCombo += key.toString();
				edgeMemKey[i] = axisIDAndMemberKeyTree.get(key);
				i++;
			}

			Statement stmt = conn.createStatement();
			try {
				// insert
				String SQL = "";
				SQL =  "";
				SQL += "INSERT INTO oo_v_color ";
				SQL += "       (report_id, edge_id_combo,";
				for (int j = 0; j < edgeMemKey.length; j++) {
					SQL +=            "edge_mem_key" + (j+1) +",";
				}
				SQL += "       headerflg, html_color) ";
				SQL += "values ( ";
				SQL +=                reportIDValue + ", ";
				SQL +=          "'" + edgeIdCombo + "', ";
				
				for (int j = 0; j < edgeMemKey.length; j++) {
					SQL +=            edgeMemKey[j] + ", ";
				}

				SQL +=          "'" + CommonUtils.boolToFLG(color.isHeader()) + "', ";
				SQL +=          "'" + color.getHtmlColor() + "'"; 
	            SQL +=        ")";

				if(log.isInfoEnabled()) {
					log.info("SQL(insert header and data cell color)�F\n" + SQL);
				}
				int insertCount = stmt.executeUpdate(SQL);
				if (insertCount != 1) {
					throw new IllegalStateException();
				}

			} catch (IllegalStateException e) {
				throw e;
			} catch (SQLException e) {
				throw e;
			} finally {
				if (stmt != null) {
					stmt.close();
				}
			} 
		}
	}


	/**
	 * ��������ꂽ���|�[�g�̐F�����f�[�^�\�[�X����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteColor(Report report, Connection conn) throws SQLException {

		deleteColor(report.getReportID(), conn);

	}


	/**
	 * ��������ꂽ���|�[�g�̐F�����f�[�^�\�[�X����폜����B
	 * @param reportID ���|�[�gID
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteColor(String reportID, Connection conn) throws SQLException {

		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_color ";
		SQL += "where ";
		SQL += "    report_id=" + reportID;

		Statement stmt = conn.createStatement();
		try {
			if(log.isInfoEnabled()) {
				log.info("SQL(delete header and data cell color)�F\n" + SQL);
			}
			stmt.executeUpdate(SQL);
		} catch (SQLException e) {
			throw e;
		} finally {
			if (stmt != null) {
				stmt.close();
			}
		} 
	}



	// ********** private���\�b�h **********

	/**
	 * �J���[��񕶎�����J���[�I�u�W�F�N�g�̃��X�g�𐶐�����B
	 * @param sourceString �J���[��񕶎���
	 * @param isHeader �s�E��w�b�_�[���̐F�ł����true�A�����łȂ��Ȃ��false
	 * @return �J���[�I�u�W�F�N�g�̃��X�g
	 */

	private ArrayList<Color> changeColorList(String sourceString, boolean isHeader) {

		ArrayList<Color> colorList = new ArrayList<Color>();	// Color�I�u�W�F�N�g�̃��X�g
		Color color = null;

		// �f�[�^�e�[�u���Z���̐F�ݒ��ǉ�
		ArrayList<String> colorInfoList = StringUtil.splitString(sourceString, ",");	// �uID.Key:�E�E�E:ID.Key;color�v���X�g
		Iterator<String> colorInfoIt = colorInfoList.iterator();


		int i = 0;
		while (colorInfoIt.hasNext()) {
			TreeMap<Integer, String> idKeyList = new TreeMap<Integer, String>();	// ��ID(Key)�Ǝ������oKey(Value)

			String colorInfo = colorInfoIt.next();						// �uID.Key:�E�E�E:ID.Key;color�v������
			ArrayList<String> comboKeyColorList = StringUtil.splitString(colorInfo,";");	// �uID.Key:�E�E�E:ID.Key�v,�ucolor�v���X�g

			String comboKeyListString = comboKeyColorList.get(0);	// �uID.Key:�E�E�E:ID.Key�v������
			String colorString = comboKeyColorList.get(1);			// �ucolor�v������

			ArrayList<String> comboKeyList = StringUtil.splitString(comboKeyListString, ":");	// �uID.Key�v�̃��X�g
			Iterator<String> comboKeyIte = comboKeyList.iterator();

			while (comboKeyIte.hasNext()) {
				String comboKeyString = comboKeyIte.next();

				ArrayList<String> axisIDAndKey = StringUtil.splitString(comboKeyString, ".");

				idKeyList.put(Integer.decode(axisIDAndKey.get(0)), axisIDAndKey.get(1));	// ��ID,�����o�[�L�[

			}

			color = new Color( idKeyList, 			// axisIDAndMemberKeyMap 
							    isHeader, 			// isHeader
							    colorString);		// HTMLColor

			colorList.add(color);
			i++;
		}

		return colorList;

	}

}
