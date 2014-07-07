/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：MeasureMemberDAO.java
 *  説明：メジャーメンバーオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/07
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.MeasureMember;
import openolap.viewer.controller.RequestHelper;

/**
 *  インターフェース：MeasureMemberDAO<br>
 *  説明：メジャーメンバーオブジェクトの永続化を管理するインターフェースです。
 */
public interface MeasureMemberDAO {

	/**
	 * メジャーメンバーをあらわすオブジェクトの集合をデータソースより求める。
	 * @param cubeSeq キューブシーケンス番号
	 * @param commonSettings アプリケーションの共通設定
	 * @return メジャーメンバーオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<MeasureMember> selectMeasureMembers(String cubeSeq, CommonSettings commonSettings) throws SQLException;

	/**
	 * メジャーメンバーのメジャーメンバータイプをクライアントから与えられた情報をもとに更新する。
	 * クライアントから与えられた情報："measureMemberTypes"パラメータ
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings 軸をあらわすオブジェクト
	 */
	public void registMeasureMemberType(RequestHelper helper, CommonSettings commonSettings);

}
