/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresDimensionMemberDAO.java
 *  �����F�f�B�����V���������o�[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.Dimension;
import openolap.viewer.DimensionMember;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.StringUtil;

/**
 *  �N���X�FPostgresDimensionMemberDAO<br>
 *  �����F�f�B�����V���������o�[�I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresDimensionMemberDAO extends PostgresAxisMemberDAO implements DimensionMemberDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	private Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresDimensionMemberDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 *  �f�B�����V���������o�[�I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresDimensionMemberDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * ���|�[�g�����S�f�B�����V��������т��̃����o���XML���擾����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @return StringBuffer�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public StringBuffer getDimensionMemberXML(Report report) throws SQLException, IOException {

		// ���|�[�g�̑S�f�B�����V��������т��̃����o���XML�i�[�p
		StringBuffer membersInfo = new StringBuffer(1024);

		ArrayList<Axis> axisList = report.getAxisOrderByID();
		Iterator<Axis> axisIt = axisList.iterator();

		while (axisIt.hasNext()) {
			Axis axis = axisIt.next();
			membersInfo.append(getDimensionMemberXML(report, axis, true)); // ���̃����o�����o��

		}

		return membersInfo;
	}


	/**
	 * �w�肳�ꂽ�f�B�����V��������сA���̃����o���XML���擾����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis �擾�ΏۂƂ���f�B�����V�����̎��I�u�W�F�N�g
	 * @param selectFLG ���̃����o�[���i�荞�܂�Ă��邩�ǂ���������킷�t���O
	 * @return StringBuffer�I�u�W�F�N�g�i�w�肳�ꂽ������сA�����o���XML�j
	 * @exception SQLException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public StringBuffer getDimensionMemberXML(Report report, Axis axis, boolean selectFLG) throws SQLException, IOException {

		// ���Ƃ��̃����o�[���iXML�j������i�[�p
		StringBuffer membersInfo = new StringBuffer(512);

		if (axis instanceof Dimension) {
			Dimension dim = (Dimension) axis;
			membersInfo.append("<Members name=\"" + dim.getName() + "\" id=\"" + dim.getId() +  "\" dimensionSeq=\""+ dim.getDimensionSeq() + "\">");

			// �Z���N�^�ɂ��i���݁A�h�����ݒ�𔽉f
			HashMap<String, String> memKeyDrill = null;
			String  selectedKeyString = null;
			if (selectFLG) {
				if (dim.getSelectedMemberDrillStat().size() > 0) { // �h������񂪑��݂���Ȃ�΁A�擾
					memKeyDrill = dim.getSelectedMemberDrillStat();
				}

				// �f�B�����V���������o���X�g��SQL�Ŏ擾����ۂ̃Z���N�^�ɂ��i���ݏ��������擾
				if(axis.isUsedSelecter()) {
					Iterator<String> it = memKeyDrill.keySet().iterator();
					int i = 0;
					selectedKeyString = "',";
					while (it.hasNext()) {
						String key = it.next();
						if(i > 0) {
							selectedKeyString += ",";
						}
						selectedKeyString += key;
						i++;
					}
					selectedKeyString += ",'";
				}
			}

			Statement stmt = null;
			ResultSet rs   = null;
			try {
				stmt = conn.createStatement();
				String SQL = this.makeSQL(dim, selectedKeyString);
				if(log.isInfoEnabled()) {
					log.info("SQL(select axis member)�F\n" + SQL);
				}
				rs   = stmt.executeQuery(SQL);

				membersInfo.append(getDimensionMemberXML(rs, memKeyDrill));

			} catch (SQLException e) {
				throw e;
			} catch (IOException e) {
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
			membersInfo.append("</Members>");
		}
		
		return membersInfo;
	}

	/**
	 * �w�肳�ꂽ�f�B�����V�����̃����o�[�I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @param shortNameCondition �V���[�g�l�[���ɂ��擾����
	 * @param longNameCondition �����O�l�[���ɂ��擾����
	 * @param levelCondition ���x���ɂ��擾����
	 * @param selectedKeyString �擾�ΏۂƂ��郁���o�[�L�[�̃��X�g������킷������
	 * @return �f�B�����V���������o�[�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<AxisMember> selectDimensionMembers(Dimension dim, String shortNameCondition, String longNameCondition, String levelCondition, String selectedKeyString) throws SQLException {
		ArrayList<AxisMember> dimensionMemberList = new ArrayList<AxisMember>();

		DimensionMember dimensionMember = null;
		
		Statement stmt = null;
		ResultSet rs   = null;
		try {

			String SQL = this.makeSQL(dim,selectedKeyString,shortNameCondition,longNameCondition,levelCondition);
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axis members)�F\n" + SQL);
			}
			rs   = stmt.executeQuery(SQL);
			int i = 0;
			while (rs.next()) {

				boolean leafFLG = false;
				if ( rs.getString("leaf_flg") != null ) {
					if ( rs.getString("leaf_flg").equals("1") ) {
						leafFLG = true;
					} else {
						leafFLG = false;
					}
				} else {
					leafFLG = false;
				}

				dimensionMember = new DimensionMember( Integer.toString(i),				// id
														Integer.toString(rs.getInt("key")),	// uniqueName
														rs.getString("code"),				// code
														rs.getString("short_name"),			// short_name
														rs.getString("long_name"),			// long_name
														rs.getString("indented_short_name"),// indented_short_name
														rs.getString("indented_long_name"), // indented_long_name
														rs.getInt("level"),					// level
														leafFLG								// isLeaf
														);	

				dimensionMemberList.add(dimensionMember);
				i++;
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
		
		return dimensionMemberList;
	}


	/**
	 * �w�肳�ꂽ�f�B�����V�����̃����o�[�I�u�W�F�N�g���X�g�̐擪�̃����o�[�I�u�W�F�N�g�����߂�B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @return �f�B�����V���������o�[�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public DimensionMember getFirstMember(Dimension dim) throws SQLException {

		DimensionMember dimensionMember = null;
		
		Statement stmt = null;
		ResultSet rs   = null;
		try {
			String SQL = this.makeSQL(dim,null) + " offset 0 limit 1 ";
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axis members)�F\n" + SQL);
			}
			rs   = stmt.executeQuery(SQL);
			int i = 0;
			while (rs.next()) {

				boolean leafFLG = false;
				if ( rs.getString("leaf_flg") != null ) {
					if ( rs.getString("leaf_flg").equals("1") ) {
						leafFLG = true;
					} else {
						leafFLG = false;
					}
				} else {
					leafFLG = false;
				}

				dimensionMember = new DimensionMember( Integer.toString(i),				// id
														Integer.toString(rs.getInt("key")),	// uniqueName
														rs.getString("code"),				// code
														rs.getString("short_name"),			// short_name
														rs.getString("long_name"),			// long_name
														rs.getString("indented_short_name"),// indented_short_name
														rs.getString("indented_long_name"), // indented_long_name
														rs.getInt("level"),					// level
														leafFLG								// isLeaf
														);	

				i++;
			}
			if (i != 1) {	// �擾���ʂ�0���ȊO�̏ꍇ�A�G���[
				throw new IllegalStateException();
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

		return dimensionMember;

	}



	/**
	 * �f�B�����V�����I�u�W�F�N�g�̃����o�[���\���^�C�v���AXML�̃^�O���ɕϊ��B
	 * @param modelString �����o�[���\���^�C�v������킷������
	 * @return XML�̃^�O��
	 */
	public String transferMemberDisplayTypeFromModelToXML(String modelString){
		if (Dimension.DISP_SHORT_NAME.equals(modelString)){
			return "Caption";
		} else if (Dimension.DISP_LONG_NAME.equals(modelString)) {
			return "Caption2";
		} else {
			throw new IllegalArgumentException();
		}
	}

	/**
	 * �f�B�����V���������o�[�����f�[�^�\�[�X�̏������Ƃɐ������A�f�B�����V�����I�u�W�F�N�g��"selectedMemberDrillStat"�ɐݒ肷��B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void applyAxis(Report report, Axis axis, CommonSettings commonSettings) throws SQLException {

		String SQL = null;
		ResultSet rs = null;
		Statement stmt = null;
		try {
			SQL = DAOFactory.getDAOFactory().getAxisMemberDAO(null,axis).selectSaveDataSQL(report, axis);
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select dimension members)�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			Dimension dim = (Dimension) axis;


// �f�B�����V�����̓f�B�����V���������o�I�u�W�F�N�g��ێ����Ȃ�����(Session�ɕێ�����I�u�W�F�N�g���̐ߖ�̂���)�R�����g��
//
//
//			String selectedKeyString = "',";
//			ArrayList drilledFLGList = new ArrayList();
			HashMap<String, String> selectedMemKeyDrillStat = new HashMap<String, String>();
//			int i = 0;
			while ( rs.next() ) {
//				if(i>0) {
//					selectedKeyString += ",";
//				}
//				selectedKeyString += rs.getString("member_key");
//				drilledFLGList.add(rs.getString("drilledFLG"));
				selectedMemKeyDrillStat.put(rs.getString("member_key"),rs.getString("drilledFLG"));
//				i++;			
			}
//			selectedKeyString += ",'";

			// �f�B�����V���������o���擾
//			ArrayList dimensionMemList = selectDimensionMembers(dim,				// �f�B�����V����
//																null,				// ��������(short_name)
//																null,				// ��������(long_name)
//																null,				// ��������(level)
//																selectedKeyString);	// ��������(�����Ώۃ����o�̃L�[���X�g)


			// �h��������␳
//			Iterator it = dimensionMemList.iterator();
//			int j = 0;
//			while (it.hasNext()) {
//				DimensionMember dimensionMember = (DimensionMember) it.next();
//				dimensionMember.setDrilled(CommonUtils.FLGTobool((String)drilledFLGList.get(j)));
//				j++;
//			}

			// �f�B�����V���������o���f�B�����V�����ɓo�^
			if(selectedMemKeyDrillStat.size()>0){
				dim.setSelectedMemberDrillStat(selectedMemKeyDrillStat);
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

	}

	/**
	 * �^����ꂽ���̃f�B�����V���������o�[���i��������B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�Ŏ������o�[����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�Ŏ������o�[����ۑ�����B
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connecion�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException {

		// ���|�[�gID��ݒ�
		String reportIDValue = null;
		if (reportID == null) {
			reportIDValue = report.getReportID();
		} else {
			reportIDValue = reportID;
		}

		Dimension dim = null;
		if (axis instanceof Dimension) {
			dim = (Dimension) axis;
		} else {
			throw new IllegalArgumentException();
		}

		// �f�B�����V�����ɑ΂��Z���N�^�ōi���݂��s��ꂽ�ꍇ�A�I�����ꂽ�����o���݂̂�ێ����邽�߁A
		// delete�Ainsert���s��

		// delete
		this.deleteAxisMember(reportIDValue, axis.getId(), conn);

		HashMap<String, String> selectedMemberDrillStat = dim.getSelectedMemberDrillStat();
			if ( selectedMemberDrillStat.size() == 0 ) {	// �������ʂ�0��
				return;
			}
		Iterator<String> keyIt = selectedMemberDrillStat.keySet().iterator();

		// insert
		String SQL = "";
		Statement stmt = conn.createStatement();
		try {
			while (keyIt.hasNext()) {
				String uName = keyIt.next();
				
				SQL = "";
				SQL += "INSERT INTO ";
				SQL += "    oo_v_axis_member ";
				SQL += "       (report_id, axis_id, dimension_seq, member_key, selectedflg, drilledflg, measure_member_type_id) ";
				SQL += "values ( ";
				SQL +=                reportIDValue + ", ";					// report_id
				SQL +=                axis.getId() + ", ";					// axis_id
				SQL +=                dim.getDimensionSeq() + ", ";			// dimension_seq
				SQL +=                uName + ", ";							// member_key
				SQL +=                "'1', ";								// selectedFLG �Z���N�^�őI�����ꂽ�����o�݂̂�HashMap�Ɏ����߁A���1(true)
				SQL +=          "'" + (String)selectedMemberDrillStat.get(uName)+ "', ";	// drilledFLG
				SQL +=                "null ";								// measure_member_type_id ���W���[�p�̐ݒ�̂��߁Anull�B
				SQL +=         ")";

				if(log.isInfoEnabled()) {
					log.info("SQL(save dimension member )�F\n" + SQL);
				}
				int insertCount = stmt.executeUpdate(SQL);
				if (insertCount != 1) {
					throw new IllegalStateException();
				}
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

	/**
	 * �^����ꂽ�f�B�����V���������������o�[�������߂�B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @return �����o�[��
	 * @exception SQLException �������ɗ�O����������
	 */
	public int getDimensionMemberNumber(Dimension dim) throws SQLException {
		
		DimensionDAO dimensionDAO = DAOFactory.getDAOFactory().getDimensionDAO(null);

		String SQL = null;
		SQL =   "";
		SQL +=	"SELECT ";
		SQL +=	"    count(*) as dimNumber ";
		SQL +=	"FROM ";
		SQL +=	"    oo_dim_tree('" + dimensionDAO.getDimensionTableName(dim.getDimensionSeq(),dim.getPartSeq()) + "',null,null) ";
		SQL +=  "WHERE leaf_flg != '9' ";	// ��������(���[���A�b�v)�ł̂ݎg�p���郁���o�Ɂu9�v���U���Ă���		

		Statement stmt = null;
		ResultSet rs = null;

		int dimNumber = 0;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(count dimension members )�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while ( rs.next() ) {
				dimNumber = rs.getInt("dimNumber");	
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

		return dimNumber;
	}

	// ********** private ���\�b�h **********

	/**
	 * ���������o�擾SQL�i�����������j��Ԃ��B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @param selectedKeyString �擾�ΏۂƂ��郁���o�[�L�[�̃��X�g������킷������
	 * @return SQL����킷������
	 */
	private String makeSQL(Dimension dim, String selectedKeyString) {

		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		DimensionDAO dimensionDAO = daoFactory.getDimensionDAO(null);

		String SQL = null;
		SQL =   "";
		SQL +=	"SELECT ";
		SQL +=	"    key as key, ";
		SQL +=	"    level, ";
		SQL +=	"    leaf_flg, ";
		SQL +=	"    code, ";
		SQL +=	"    short_name, ";
		SQL +=	"    long_name, ";
		SQL +=	"    lpad('',level,'�@') || short_name as indented_short_name, ";
		SQL +=	"    lpad('',level,'�@') || long_name as indented_long_name ";
		SQL +=	"FROM ";
		SQL +=	"    oo_dim_tree('" + dimensionDAO.getDimensionTableName(dim.getDimensionSeq(),dim.getPartSeq()) + "',null," + selectedKeyString +") ";
		SQL +=  "WHERE leaf_flg != '9' ";	// ��������(���[���A�b�v)�ł̂ݎg�p���郁���o�Ɂu9�v���U���Ă���

		return SQL;
	}


	/**
	 * ���������o�擾SQL�i�����������j��Ԃ��B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @param selectedKeyString �擾�ΏۂƂ��郁���o�[�L�[�̃��X�g������킷������
	 * @param shortNameCondition �f�B�����V���������o��short_name
	 * @param longNameCondition �f�B�����V���������o��long_name
	 * @param level �f�B�����V�����̃��x��
	 * @return SQL����킷������
	 */
	private String makeSQL(Dimension dim, String selectedKeyString, String shortNameCondition, String longNameCondition, String levelCondition) {
		String SQL = makeSQL(dim,selectedKeyString);
		if( (shortNameCondition != null) && (!shortNameCondition.equals("")) ) {
			SQL += "    and short_name like '" + StringUtil.changeKomeToPercent(shortNameCondition) + "'";
		}
		if( (longNameCondition != null) && (!longNameCondition.equals("")) ) {
			SQL += "    and long_name like '" + StringUtil.changeKomeToPercent(longNameCondition) + "'";
		}
		if( (levelCondition != null) && (!levelCondition.equals("")) ) {
			SQL += "    and level like '" + StringUtil.changeKomeToPercent(levelCondition) + "'";
		}

		return SQL;
	}

	/**
	 * �f�B�����V���������o�[�m�[�h���iXML�j���擾����B
	 * @param rs �f�B�����V���������o�[�̌�������
	 * @param memKeyDrill �h�������
	 * @return StringBuffer�I�u�W�F�N�g
	 */
	private StringBuffer getDimensionMemberXML(ResultSet rs, HashMap<String, String> memKeyDrill) 
											 throws SQLException, IOException {

		StringBuffer dimMemberNodeInfo = new StringBuffer(512);

		int    beforeLevel     = -1;       	// �O�̃��R�[�h
		String isDrilledString  = "false";  	// ���̃��R�[�h��Drill�̒l

		int currentLevel = -1;  // ���̃��R�[�h�̃��x��
		int j = 0;              // while���[�v�̃J�E���^
		int k = 0;              // �J�E���^

//System.out.println("memKeyDrill:" + memKeyDrill);

		while (rs.next()) {

			currentLevel = rs.getInt("level");

			// �h�����t���O�̐ݒ�
			if ( memKeyDrill == null ) {
				// �����\���̏ꍇ�i�Z�b�V�����ɖ��o�^�j�A�f�t�H���g�̓W�J��Ԃ�K�p
				if ( rs.getString("leaf_flg") != null ) {
					if ( ( currentLevel == 1 ) && ( rs.getString("leaf_flg").equals("0") ) ) {
						isDrilledString = "true";
					} else {
						isDrilledString = "false";
					}
				} else {
					isDrilledString = "false";
				}
			} else {
				// DB�ɕۑ����ꂽ�f�B�����V���������o�̓W�J��Ԃ�K�p
				String tmpMemKey = Integer.toString(rs.getInt("key"));
				String drillStat = (String)memKeyDrill.get(tmpMemKey);

// System.out.println("tmpMemKey,drillStat" + tmpMemKey + "," + drillStat);

				if ( drillStat == null ) {				// ���|�[�g�ۑ����ɂ͑��݂��Ȃ����������o
					isDrilledString = "false";					
				} else if ( drillStat.equals("1") ) {
					isDrilledString = "true";
				} else {
					isDrilledString = "false";
				}

			}

			// �O�̃��[�v�̗v�f�����^�O�𐶐�
			if ( j != 0 ) {
				if ( beforeLevel < currentLevel ) {			// �O�̗v�f���[��
					// ���^�O�͐������Ȃ�
				} else if ( beforeLevel > currentLevel ) {	// �O�̗v�f����
					// ���^�O�𐶐�
					for ( k=0; k < (beforeLevel - currentLevel + 1); k++ ) {
						dimMemberNodeInfo.append("</Member>");
					}
				} else if ( beforeLevel == currentLevel ) {	// �O�̗v�f�Ɠ���
					// ���^�O�𐶐�
					dimMemberNodeInfo.append("</Member>");
				}
			}

			String leafString = "";
			if ( rs.getString("leaf_flg") != null ) {
				if ( rs.getString("leaf_flg").equals("1") ) {
					leafString = "true";
				} else {
					leafString = "false";
				}
			} else {
				leafString = "false";
			}

			dimMemberNodeInfo.append( "<Member id=\"" + j + "\">" );
			dimMemberNodeInfo.append( "    <UName>" + rs.getInt("key") + "</UName>" );
			dimMemberNodeInfo.append( "    <Code>" + rs.getString("code") + "</Code>");
			dimMemberNodeInfo.append( "    <Caption>" + rs.getString("short_name") + "</Caption>" );
			dimMemberNodeInfo.append( "    <Caption2>" + rs.getString("long_name") + "</Caption2>" );
			dimMemberNodeInfo.append( "    <LNum>" + rs.getInt("level") + "</LNum>" );
			dimMemberNodeInfo.append( "    <isDrilled>" + isDrilledString + "</isDrilled>" );
			dimMemberNodeInfo.append( "    <isLeaf>" + leafString + "</isLeaf>" );

			j++;
			beforeLevel = currentLevel;
		}

		// �Ō�̃����o�̕��^�O�𐶐�
		for ( k=0; k < beforeLevel; k++ ) {
			dimMemberNodeInfo.append("</Member>");
		}

		return dimMemberNodeInfo;

	}

}
