/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FPostgresAxisLevelDAO.java
 *  �����F�����x���I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/08
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.AxisLevel;
import openolap.viewer.Dimension;
import openolap.viewer.Measure;
import openolap.viewer.common.TimeDimensionInfo;

/**
 *  �N���X�FPostgresAxisLevelDAO<br>
 *  �����F�����x���I�u�W�F�N�g�̉i�������Ǘ�����N���X�ł��B
 */
public class PostgresAxisLevelDAO implements AxisLevelDAO {

	// ********** �C���X�^���X�ϐ� **********

	/** Connection�I�u�W�F�N�g */
	Connection conn = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(PostgresAxisLevelDAO.class.getName());

	// ********** �R���X�g���N�^ **********

	/**
	 * �����x���I�u�W�F�N�g�̉i�������Ǘ�����I�u�W�F�N�g�𐶐����܂��B
	 */
	PostgresAxisLevelDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** ���\�b�h **********

	/**
	 * �^����ꂽ���̎����x���I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param axis ���I�u�W�F�N�g
	 * @return �����x���I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<AxisLevel> selectAxisLevels(String cubeSeq, Axis axis) throws SQLException {
		if(axis == null) { throw new IllegalArgumentException(); }

		ArrayList<AxisLevel> axisLevelList = new ArrayList<AxisLevel>();
		
		if(axis instanceof Measure){				// Measure
			// �������Ȃ��i���W���[�̏ꍇ�������Ƃ��낦�邽�߂ɁA���x������XML�ŏo�͂���ꍇ�ɂ��Ȃ��āB�j
		} else if(axis instanceof Dimension){	// Dimension

			Dimension dim = (Dimension) axis;
			int level = 0;	// ���x���ԍ�


			// ���v�l�̒ǉ�
			if ( dim.hasTotal() ) {
				AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	//���x���ԍ��i���v�l�͏��"1"�j
													 "���v�l",	//���x����
													 "���v�l");	//�R�����g
				level++;
				axisLevelList.add(axisLevel);
			}
		
			// ���x���i���v�l�ȊO�j���̒ǉ�
			Statement stmt = null;
			ResultSet rs = null;
			String SQL = "";


			try {

				stmt = conn.createStatement();

				if(!dim.isTimeDimension()){					// Dimension(���ԈȊO)
	
					SQL =   "";
					SQL +=	"select ";
					SQL +=	"  distinct ";
					SQL +=	"    l.level_no, ";
					SQL +=	"    l.name, ";
					SQL +=	"    l.comment ";
					SQL +=	"from  ";
					SQL +=	"  oo_level l,oo_info_dim d ";
					SQL +=	"where  ";
					SQL +=	"  d.cube_seq=" + cubeSeq + " and  ";
					SQL +=	"  d.dimension_seq=" + dim.getDimensionSeq() + " and  ";
					SQL +=	"  l.dimension_seq=d.dimension_seq ";
					SQL +=	"order by l.level_no ";

					if(log.isInfoEnabled()) {
						log.info("SQL(select axis Level(not Time Dimension))�F\n" + SQL);
					}
					rs = stmt.executeQuery(SQL);
					while ( rs.next() ) {
						AxisLevel axisLevel = new AxisLevel( Integer.toString(level + rs.getInt("level_no")),	// ���v�l������ꍇ�́A�{1����
															 rs.getString("name"),
															 rs.getString("comment"));
						if(log.isDebugEnabled()){
							log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
						}
						axisLevelList.add(axisLevel);
					}
	
				} else {									// Dimension(����)
	
					SQL =   "";
					SQL +=	"select ";
					SQL +=	"  distinct ";
					SQL +=	"    t.year_flg, ";
					SQL +=	"    t.half_flg, ";
					SQL +=	"    t.quarter_flg, ";
					SQL +=	"    t.month_flg, ";
					SQL +=	"    t.week_flg, ";
					SQL +=	"    t.day_flg ";
					SQL +=	"from  ";
					SQL +=	"    oo_time t, oo_info_dim d ";
					SQL +=	"where  ";
					SQL +=	"    d.cube_seq=" + cubeSeq + " and ";
					SQL +=	"    t.time_seq = d.dimension_seq ";

					if(log.isInfoEnabled()) {
						log.info("SQL(select axis Level(Time Dimension))�F\n" + SQL);
					}
					rs = stmt.executeQuery(SQL);
					TimeDimensionInfo timeDimInfo = new TimeDimensionInfo();
					while ( rs.next() ) {

						if ( rs.getString("year_flg").equals("1") ) {
							AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	// levelNo
																 timeDimInfo.getTimeLevelDisplayString("year"),	// name
																 null);				// comment
							level++;
							if(log.isDebugEnabled()){
								log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
							}
							axisLevelList.add(axisLevel);
						}
						if ( rs.getString("half_flg").equals("1") ) {
							AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	// levelNo
																 timeDimInfo.getTimeLevelDisplayString("half"),	// name
																 null);				// comment
							level++;
							if(log.isDebugEnabled()){
								log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
							}
							axisLevelList.add(axisLevel);
						}
						if ( rs.getString("quarter_flg").equals("1") ) {
							AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	// levelNo
																 timeDimInfo.getTimeLevelDisplayString("quarter"),	// name
																 null);				// comment
							level++;
							if(log.isDebugEnabled()){
								log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
							}
							axisLevelList.add(axisLevel);
						}
						if ( rs.getString("month_flg").equals("1") ) {
							AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	// levelNo
																 timeDimInfo.getTimeLevelDisplayString("month"),	// name
																 null);				// comment
							level++;
							if(log.isDebugEnabled()){
								log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
							}
							axisLevelList.add(axisLevel);
						}
						if ( rs.getString("week_flg").equals("1") ) {
							AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	// levelNo
																 timeDimInfo.getTimeLevelDisplayString("week"),	// name
																 null);				// comment
							level++;
							if(log.isDebugEnabled()){
								log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
							}
							axisLevelList.add(axisLevel);
						}
						if ( rs.getString("day_flg").equals("1") ) {
							AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	// levelNo
																 timeDimInfo.getTimeLevelDisplayString("day"),	// name
																 null);				// comment
							level++;
							if(log.isDebugEnabled()){
								log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
							}
							axisLevelList.add(axisLevel);
						}
					}
				}

			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException e) {
					throw e;
				} finally {
					try {
						if (stmt != null) {
							stmt.close();
						}
					} catch (SQLException e) {
						throw e;
					}
				}
			}

		}

		return axisLevelList;
	}
}
