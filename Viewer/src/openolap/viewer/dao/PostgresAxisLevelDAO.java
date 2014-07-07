/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresAxisLevelDAO.java
 *  説明：軸レベルオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/08
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
 *  クラス：PostgresAxisLevelDAO<br>
 *  説明：軸レベルオブジェクトの永続化を管理するクラスです。
 */
public class PostgresAxisLevelDAO implements AxisLevelDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresAxisLevelDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * 軸レベルオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresAxisLevelDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * 与えられた軸の軸レベルオブジェクトのリストを求める。
	 * @param cubeSeq キューブシーケンス番号
	 * @param axis 軸オブジェクト
	 * @return 軸レベルオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<AxisLevel> selectAxisLevels(String cubeSeq, Axis axis) throws SQLException {
		if(axis == null) { throw new IllegalArgumentException(); }

		ArrayList<AxisLevel> axisLevelList = new ArrayList<AxisLevel>();
		
		if(axis instanceof Measure){				// Measure
			// 何もしない（メジャーの場合も次元とそろえるために、レベル情報をXMLで出力する場合にそなえて。）
		} else if(axis instanceof Dimension){	// Dimension

			Dimension dim = (Dimension) axis;
			int level = 0;	// レベル番号


			// 合計値の追加
			if ( dim.hasTotal() ) {
				AxisLevel axisLevel = new AxisLevel(Integer.toString(level+1),	//レベル番号（合計値は常に"1"）
													 "合計値",	//レベル名
													 "合計値");	//コメント
				level++;
				axisLevelList.add(axisLevel);
			}
		
			// レベル（合計値以外）情報の追加
			Statement stmt = null;
			ResultSet rs = null;
			String SQL = "";


			try {

				stmt = conn.createStatement();

				if(!dim.isTimeDimension()){					// Dimension(時間以外)
	
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
						log.info("SQL(select axis Level(not Time Dimension))：\n" + SQL);
					}
					rs = stmt.executeQuery(SQL);
					while ( rs.next() ) {
						AxisLevel axisLevel = new AxisLevel( Integer.toString(level + rs.getInt("level_no")),	// 合計値がある場合は、＋1する
															 rs.getString("name"),
															 rs.getString("comment"));
						if(log.isDebugEnabled()){
							log.debug("axisLevel Object Information(level_no,name,comment):\n :" + axisLevel.getLevelNumber() + axisLevel.getName() + axisLevel.getComment());	
						}
						axisLevelList.add(axisLevel);
					}
	
				} else {									// Dimension(時間)
	
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
						log.info("SQL(select axis Level(Time Dimension))：\n" + SQL);
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
