/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresDimensionDAO.java
 *  説明：ディメンションオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/06
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
 *  クラス：PostgresDimensionDAO<br>
 *  説明：ディメンションオブジェクトの永続化を管理するクラスです。
 */
public class PostgresDimensionDAO implements DimensionDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresDimensionDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * ディメンションオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresDimensionDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * データソースのディメンションの物理テーブル名を求める。
	 * @param dimSeq ディメンションシーケンス番号
	 * @param partSeq ディメンションのパーツ番号
	 * @return DBの物理テーブル名
	 */
	public String getDimensionTableName(String dimSeq, String partSeq) throws IllegalArgumentException {
		if ((dimSeq == null) || (partSeq == null) ) { throw new IllegalArgumentException();}
		if (("".equals(dimSeq)) || ( "".equals(partSeq)) ) { throw new IllegalArgumentException();}

		return "oo_dim_" + dimSeq + "_" + partSeq;
	}

	/**
	 * ディメンションオブジェクトのリストを求める。
	 * @param cubeSeq キューブシーケンス番号
	 * @return ディメンションオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
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
				log.info("SQL(select dimensions )：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			int i=0;
			while ( rs.next() ) {

				// 時間次元かどうか、合計値を持つかを設定
				boolean timeDimFLG = false; // 時間次元かどうか
				boolean hasTotalFLG = false;// 合計値を持つか
				if ( rs.getString("time_dim_flg").equals("1") ) {		// 時間ディメンション
					if ( i != 0 ){ throw new IllegalStateException();} //(時間次元は必ず一番最初になる)
					timeDimFLG = true;
					hasTotalFLG = hasTimeDimhaveTotal(cubeSeq, rs.getString("DIMENSION_SEQ"));
				} else {												// 時間ディメンション以外のディメンション

					if ( rs.getString("total_flg").equals("1") ) {		// 合計値を持つ
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

				// Dimension オブジェクトに AxisLevel オブジェクトを追加
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
	 * ディメンションのメンバー名の表示タイプ情報を更新する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
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

			String dimID = dimIDDispTypeList.get(0);			// 軸ID
			String dispMemberType = dimIDDispTypeList.get(1);	// メンバー表示名称タイプ

			if( (!Dimension.DISP_LONG_NAME.equals(dispMemberType)) && 		// 取得した値が正しい値かどうかを確認
			     (!Dimension.DISP_SHORT_NAME.equals(dispMemberType) )) {
				throw new IllegalArgumentException();
			}

			Dimension dim = (Dimension) report.getAxisByID(dimID);
			dim.setDispMemberNameType(dispMemberType);

		}

	}

	// ********** privateメソッド **********

	/**
	 * 時間ディメンションが合計値を持つか？
	 * @param cubeSeq キューブシーケンス番号
	 * @param dimensionSeq キューブシーケンス番号
	 * @return 時間ディメンションが合計値を持つ場合true、持たない場合falseを戻す
	 * @exception SQLException 処理中に例外が発生した
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
				log.info("SQL(select timeDim has total flg )：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while ( rs.next() ) {

				// 合計値を持つか
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
			log.debug("time dimension hasTotalFlg?：\n" + hasTotalFLG);
		}

		return hasTotalFLG;
	}

}
