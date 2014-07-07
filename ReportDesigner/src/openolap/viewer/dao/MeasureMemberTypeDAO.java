/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：MeasureMemberTypeDAO.java
 *  説明：メジャーメンバータイプの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/12
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import openolap.viewer.MeasureMemberType;

/**
 *  インターフェース：MeasureMemberTypeDAO<br>
 *  説明：メジャーメンバータイプの永続化を管理するインターフェースです。
 */
public interface MeasureMemberTypeDAO {

	/**
	 * データソースに登録されているメジャーメンバータイプのリストを求める<br>
	 * @return メジャーメンバータイプオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<MeasureMemberType> getMeasureMemberTypeList() throws SQLException;


}
