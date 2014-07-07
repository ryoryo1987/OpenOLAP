/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：DimensionMemberDAO.java
 *  説明：ディメンションメンバーオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.dao;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.Dimension;
import openolap.viewer.DimensionMember;
import openolap.viewer.Report;

/**
 *  インターフェース：DimensionMemberDAO<br>
 *  説明：ディメンションメンバーオブジェクトの永続化を管理するインターフェースです。
 */
public interface DimensionMemberDAO {

	/**
	 * レポートが持つ全軸のメンバ情報を軸IDの昇順で出力
	 * @param report レポートオブジェクト
	 * @return StringBufferオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public StringBuffer getDimensionMemberXML(Report report) throws SQLException, IOException;

	/**
	 * 指定された軸のメンバ情報を出力
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param selectFLG 軸のメンバーが絞り込まれているかどうかをあらわすフラグ
	 * @exception SQLException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public StringBuffer getDimensionMemberXML(Report report, Axis axis, boolean selectFLG) throws SQLException, IOException;

	/**
	 * 指定されたディメンションのメンバーオブジェクトのリストを求める。
	 * @param dim ディメンションオブジェクト
	 * @param shortNameCondition ショートネームによる取得条件
	 * @param longNameCondition ロングネームによる取得条件
	 * @param levelCondition レベルによる取得条件
	 * @param selectedKeyString 取得対象とするメンバーキーのリストをあらわす文字列
	 * @return ディメンションメンバーオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<AxisMember> selectDimensionMembers(Dimension dim, String shortNameCondition, String longNameCondition, String levelCondition, String selectedKeyString) throws SQLException;

	/**
	 * ディメンションオブジェクトのメンバー名表示タイプを、XMLのタグ名に変換。
	 * @param modelString メンバー名表示タイプをあらわす文字列
	 * @return XMLのタグ名
	 */
	public String transferMemberDisplayTypeFromModelToXML(String string);

	/**
	 * 与えられたディメンションが持つ総メンバー数を求める。
	 * @param dim ディメンションオブジェクト
	 * @return メンバー数
	 * @exception SQLException 処理中に例外が発生した
	 */
	public int getDimensionMemberNumber(Dimension dim) throws SQLException;

	/**
	 * 指定されたディメンションのメンバーオブジェクトリストの先頭のメンバーオブジェクトを求める。
	 * @param dim ディメンションオブジェクト
	 * @return ディメンションメンバーオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public DimensionMember getFirstMember(Dimension dim) throws SQLException;
}
