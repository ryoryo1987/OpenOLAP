/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.jspHelper
 *  ファイル：DisplaySelecter.java
 *  説明：セレクタ表示を補佐するクラスです。
 *
 *  作成日: 2004/01/12
 */
package openolap.viewer.jspHelper;

import java.io.IOException;
import java.util.Iterator;

import javax.servlet.jsp.JspWriter;

import openolap.viewer.Axis;
import openolap.viewer.AxisLevel;
import openolap.viewer.Report;

/**
 *  クラス：DisplaySelecter<br>
 *  説明：セレクタ表示を補佐するクラスです。
 */
public class DisplaySelecter {

	// ********** メソッド **********

	/**
	 * 与えられた軸のレベル名称を<option>タグに埋め込まれた形式で出力する。
	 * @param report レポートオブジェクト
	 * @param targetAxisID 軸ID
	 * @param out JspWriterオブジェクト
	 * @exception IOException 処理で例外が発生した
	 */
	 public void outLevelName( Report report, String targetAxisID, JspWriter out ) throws IOException {

		 Axis axis = report.getAxisByID(targetAxisID);
		 Iterator<AxisLevel> it = axis.getAxisLevelList().iterator();
		 while (it.hasNext()) {
			 AxisLevel axisLevel = it.next();
			 out.println("<option value='" + axisLevel.getLevelNumber() + "'>");
				 out.println(axisLevel.getName());
			 out.println("</option>");
		 }
	 }

}
