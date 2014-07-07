/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresDimensionDAO.java
 *  �����F�f�B�����V�����I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/06
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.AxisLevel;
import openolap.viewer.Dimension;
import openolap.viewer.Report;
import openolap.viewer.common.Messages;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;

/**
 *  �N���X�FPostgresDimensionDAO<br>
 *  �����F�f�B�����V�����I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresDimensionDAO implements DimensionDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresDimensionDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * �f�B�����V�����I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresDimensionDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �f�[�^�\�[�X�̃f�B�����V�����̕����e�[�u���������߂�B
	 * @param dimSeq �f�B�����V�����V�[�P���X�ԍ�
	 * @param partSeq �f�B�����V�����̃p�[�c�ԍ�
	 * @return DB�̕����e�[�u����
	 */
	public String getDimensionTableName(String dimSeq, String partSeq) throws IllegalArgumentException {
		if ((dimSeq == null) || (partSeq == null) ) { throw new IllegalArgumentException();}
		if (("".equals(dimSeq)) || ( "".equals(partSeq)) ) { throw new IllegalArgumentException();}

		return "oo_dim_" + dimSeq + "_" + partSeq;
	}

	/**
	 * �f�B�����V�����I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @return �f�B�����V�����I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<Dimension> selectDimensions(String cubeSeq) throws SQLException {

		ArrayList<Dimension> dimensionList = new ArrayList<Dimension>();
		Dimension dim = null;
		String SQL = "";
		Statement stmt = null;
		ResultSet rs = null;

		String timeDimDispName = Messages.getString("PostgresDimensionDAO.timeDimDispName"); //$NON-NLS-1$
		SQL =   "";
		SQL +=	" select ";
		SQL +=	"    distinct coalesce(d.name,'" + timeDimDispName + "') as name, ";
		SQL +=	"    c.time_dim_flg, ";
		SQL +=	"    d.total_flg, ";
		SQL +=	"    c.DIMENSION_SEQ, ";
		SQL +=	"    CASE WHEN c.PART_SEQ=0 THEN 1 ";
		SQL +=	"         ELSE c.PART_SEQ ";
		SQL +=	"    END, ";
		SQL +=	"    coalesce(d.COMMENT,'') as COMMENT, ";
		SQL +=	"    c.DIM_NO ";
		SQL +=	" from ";
		SQL +=	"    oo_info_dim c left outer join ";
		SQL +=  "    (select dimension_seq,name,total_flg,comment from oo_dimension union select time_seq,name,total_flg,comment from oo_time) d ";
		SQL +=  "    on (c.dimension_seq=d.dimension_seq) ";
		SQL +=	" where c.cube_seq=" + cubeSeq;
		SQL +=	" order by DIM_NO";

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select dimensions )�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			int i=0;
			while ( rs.next() ) {

				// ���Ԏ������ǂ����A���v�l��������ݒ�
				boolean timeDimFLG = false; // ���Ԏ������ǂ���
				boolean hasTotalFLG = false;// ���v�l������
				if ( rs.getString("time_dim_flg").equals("1") ) {		// ���ԃf�B�����V����
					if ( i != 0 ){ throw new IllegalStateException();} //(���Ԏ����͕K����ԍŏ��ɂȂ�)
					timeDimFLG = true;
					hasTotalFLG = hasTimeDimhaveTotal(cubeSeq, rs.getString("DIMENSION_SEQ"));
				} else {												// ���ԃf�B�����V�����ȊO�̃f�B�����V����

					if ( rs.getString("total_flg").equals("1") ) {		// ���v�l������
						hasTotalFLG = true;	
					}
				}

				dim = new Dimension(Integer.toString(i+1),							// ID
										rs.getString("name"), 						// name
										rs.getString("COMMENT"), 					// comment
										new ArrayList<AxisLevel>(),					// levelList
										null, 										// defaultMemberKey
										false, 										// isMeasure
										false, 										// isUsedSelecter
										timeDimFLG,									// isTimeDim
										hasTotalFLG, 								// hasTotal
										rs.getString("DIMENSION_SEQ"), 				// dimensionSeq
										rs.getString("PART_SEQ"));					// partSeq

//System.out.println(rs.getString("name") + "," + rs.getString("time_dim_flg") + "," + rs.getString("COMMENT"));
//System.out.println(timeDimFLG + "," + hasTotalFLG);
//System.out.println(rs.getString("DIMENSION_SEQ") + "," + rs.getString("PART_SEQ"));

				// Dimension �I�u�W�F�N�g�� AxisLevel �I�u�W�F�N�g��ǉ�
				DAOFactory daoFactory = DAOFactory.getDAOFactory();
				AxisLevelDAO axisLevelDAO = daoFactory.getAxisLevelDAO(this.conn);		
				Iterator<AxisLevel> it = axisLevelDAO.selectAxisLevels(cubeSeq,dim).iterator();
				while (it.hasNext()) {
					AxisLevel axisLevel = it.next();
					dim.addAxisLevelList(axisLevel);
				}

				dimensionList.add(dim);
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

		return dimensionList;
	}

	/**
	 * �f�B�����V�����̃����o�[���̕\���^�C�v�����X�V����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 */
	public void registDimensionMemberDispType(RequestHelper helper, CommonSettings commonSettings) {
		
		HttpServletRequest request = helper.getRequest();
		String dimMemDispTypes = (String)request.getParameter("dimMemDispTypes");		
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		ArrayList<String> dimIDDispTypePairList = StringUtil.splitString(dimMemDispTypes,",");
		Iterator<String> it = dimIDDispTypePairList.iterator();
		while (it.hasNext()) {
			String dimIDDispTypePair = it.next();
			ArrayList<String> dimIDDispTypeList = StringUtil.splitString(dimIDDispTypePair,":");

			String dimID = dimIDDispTypeList.get(0);			// ��ID
			String dispMemberType = dimIDDispTypeList.get(1);	// �����o�[�\�����̃^�C�v

			if( (!Dimension.DISP_LONG_NAME.equals(dispMemberType)) && 		// �擾�����l���������l���ǂ������m�F
			     (!Dimension.DISP_SHORT_NAME.equals(dispMemberType) )) {
				throw new IllegalArgumentException();
			}

			Dimension dim = (Dimension) report.getAxisByID(dimID);
			dim.setDispMemberNameType(dispMemberType);

		}

	}

	// ********** private���\�b�h **********

	/**
	 * ���ԃf�B�����V���������v�l�������H
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param dimensionSeq �L���[�u�V�[�P���X�ԍ�
	 * @return ���ԃf�B�����V���������v�l�����ꍇtrue�A�����Ȃ��ꍇfalse��߂�
	 * @exception SQLException �������ɗ�O����������
	 */
	private boolean hasTimeDimhaveTotal(String cubeSeq, String dimensionSeq) throws SQLException {
		boolean hasTotalFLG = false;

		Statement stmt = null;
		ResultSet rs = null;
		String SQL = "";
		SQL =   "";
		SQL +=	"select ";
		SQL +=	"  distinct total_flg ";
		SQL +=	"from ";
		SQL +=	"  oo_time ";
		SQL +=	"where ";
		SQL +=	"  time_seq=" + dimensionSeq;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select timeDim has total flg )�F\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while ( rs.next() ) {

				// ���v�l������
				if ( rs.getString("total_flg") != null ) {
					if ( rs.getString("total_flg").equals("1") ) {
						hasTotalFLG = true;
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

		if(log.isDebugEnabled()) {
			log.debug("time dimension hasTotalFlg?�F\n" + hasTotalFLG);
		}

		return hasTotalFLG;
	}

}
