/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresMeasureMemberTypeDAO.java
 *  説明：メジャーメンバータイプの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/12
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import openolap.viewer.MeasureMemberType;

/**
 *  クラス：PostgresMeasureMemberTypeDAO<br>
 *  説明：メジャーメンバータイプの永続化を管理するクラスです。
 */
public class PostgresMeasureMemberTypeDAO implements MeasureMemberTypeDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresMeasureMemberTypeDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 *  メジャーメンバータイプの永続化を管理するオブジェクトを生成します。
	 */
	PostgresMeasureMemberTypeDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * データソースに登録されているメジャーメンバータイプのリストを求める<br>
	 * @return メジャーメンバータイプオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<MeasureMemberType> getMeasureMemberTypeList() throws SQLException {
		
		ArrayList<MeasureMemberType> measureMemberTypeList = new ArrayList<MeasureMemberType>();
		
		String SQL = "";
		SQL += "select ";
		SQL += "    measure_member_type_id, ";
		SQL += "    name, ";
		SQL += "    comment, ";
		SQL += "    group_name, ";
		SQL += "    image_url, ";
		SQL += "    xml_spreadsheet_format, ";
		SQL += "    function_name, ";
		SQL += "    unit_function_id ";
		SQL += "from ";
		SQL += "    oo_v_measure_member_type ";
		SQL += "order by measure_member_type_id ";

		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select measure member types )：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				MeasureMemberType measureMemberType = new MeasureMemberType(rs.getString("measure_member_type_id"),
																			 rs.getString("name"),
																			 rs.getString("comment"),
																			 rs.getString("group_name"),
																			 rs.getString("image_url"),
																			 rs.getString("xml_spreadsheet_format"),
																			 rs.getString("function_name"),
																			 rs.getString("unit_function_id"));

				measureMemberTypeList.add(measureMemberType);
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

		return measureMemberTypeList;
	}

}
