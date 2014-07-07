/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.export
 *  ファイル：ExportReport.java
 *  説明：レポートのエクスポート処理を行う抽象クラスです。
 *
 *  作成日: 2004/01/31
 */
package openolap.viewer.export;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;


import openolap.viewer.Axis;
import openolap.viewer.Edge;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;

/**
 *  抽象クラス：ExportReport<br>
 *  説明：レポートのエクスポート処理を行う抽象クラスです。
 */
public abstract class ExportReport {

	// ********** メソッド **********

	/**
	 * エクスポート処理を実行する
	 * @param helper RequestHelperオブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 * @exception FileNotFoundException 処理中に例外が発生した
	 * @exception UnsupportedEncodingException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生したUnsupportedEncodingException
	 */
	public abstract String exportReport(RequestHelper helper) throws SQLException, NamingException, FileNotFoundException, UnsupportedEncodingException, IOException, ParserConfigurationException, SAXException, TransformerException, XPathExpressionException;


	// ********** protectedメソッド **********

	/**
	 * @param edge
	 * @param axis
	 * @param rowIndex
	 * @return 出力する個所か
	 */
	protected boolean isPrintPoint(Edge edge, Axis axis, int rowIndex) {
		Integer nextComboNums = edge.getNextAxesMembersComboNums(axis);
		
		if (nextComboNums == null) {// 最終段の場合、常に表示対象
			return true;
		} else { // 最終段以外の場合
			if ( (rowIndex % nextComboNums.intValue() == 0)) {//結合セルの先頭のIndex
				return true;
			} else {
				return false;
			}
		}
	}

	/**
	 * 行・列メンバのセル結合数を求める。
	 * @param edge エッジをあらわすオブジェクト
	 * @param axis 軸をあらわすオブジェクト
	 * @return セル結合が必要な数
	 */
	protected int getCellMergeNum(Edge edge, Axis axis) {

		Integer cellMergeNumber = edge.getNextAxesMembersComboNums(axis);
		int mergeNum;
		if (cellMergeNumber != null) {
			mergeNum = cellMergeNumber.intValue()-1;
		} else {
			mergeNum = 0;
		}
		
		return mergeNum;
	}

	/**
	 * 次メンバーのSpreadIndexを求める。
	 * @param edge エッジをあらわすオブジェクト
	 * @param axis 軸をあらわすオブジェクト
	 * @param x 始点となるSpreadIndex
	 * @return セル結合が必要な数
	 */
	protected int getNextSpreadIndex(Edge edge, Axis axis, int x) {

		Integer cellMergeNumber = edge.getNextAxesMembersComboNums(axis);
		int mergeNum;
		if (cellMergeNumber != null) {
			mergeNum = cellMergeNumber.intValue();
		} else {
			mergeNum = 1;
		}
		return ( x + mergeNum );
	}

	/**
	 * 与えられた軸より以前の段の組み合わせ数を求める。
	 * @param edge エッジをあらわすオブジェクト
	 * @param axis 軸をあらわすオブジェクト
	 * @return セル結合が必要な数
	 */
	protected int getBeforeComboNum(Edge edge, Axis axis) {

		Integer axisMemRepeatNumber = edge.getBeforeAxesMembersComboNums(axis);

		int axisMemRepeatNum;
		if (axisMemRepeatNumber != null) {
			axisMemRepeatNum = axisMemRepeatNumber.intValue();
		} else {
			axisMemRepeatNum = 1;	// 0段の場合、一度だけ繰り返す
		}
		return axisMemRepeatNum;
	}

	/**
	 * 指定された段の軸メンバが結合される対象（表示対象外）かどうかを確認する。<br>
	 * 一つ前の行/列に配置された軸メンバのKeyの組み合わせと自分のKeyの組み合わせを比較し、
	 * 指定された段およびそれより上位の段のKeyが異なる場合は表示対象、等しい場合は表示対象外とする
	 * @param beforeKeys 以前のメンバーキーの組み合わせ
	 * @param keys メンバーキーの組み合わせ
	 * @param hieIndex エッジの段インデックス
	 * @return 結合対象であればtrue、なければfalseを戻す
	 */
	protected boolean isJoinMember(String beforeKeys, String keys, int hieIndex) {

		if (beforeKeys == null) {
			return false;
		}

		ArrayList<String> keyList = StringUtil.splitString(keys, ";");
		ArrayList<String> beforeKeyList = StringUtil.splitString(beforeKeys, ";");

		for (int i = 0; i < hieIndex+1; i++) {	// 指定された段およびその上段のKeyは同じかを確認
			String key = keyList.get(i);
			String beforeKey = beforeKeyList.get(i);
			if (!key.equals(beforeKey)){
				return false;
			}
		}
		return true;
	}


}
