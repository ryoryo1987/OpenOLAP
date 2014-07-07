/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：RequestHelper.java
 *  説明：クライアントからのリクエストと処理を紐付けるクラスです。
 *
 *  作成日: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import openolap.viewer.XMLConverter;
import openolap.viewer.chart.ChartCreator;
import openolap.viewer.common.CommonSettings;

/**
 *  クラス：GetChartFromXMLCommand<br>
 *  説明：クライアントより送信されてきたJFreeChart用のXMLドキュメントよりグラフを生成するクラスです。
 *        <必要なRequestパラメータ>
 * 	      strCode:       Chart生成用XMLドキュメントの文字コード
 *        chartXML:      Chart生成用XMLドキュメント
 *        chartDispMode: チャート表示モード 
 *                         値 = xml   ： XML を出力し、イメージファイル表示用JSPを呼び出すモード
 *                         値 = image ： イメージファイルを直接出力するモード
 */
public class GetChartFromXMLCommand implements Command {

	final private String outXMLMode   = "xml";		// XML を出力し、イメージファイル表示用JSPを呼び出すモード
	final private String outImageMode = "image";		// イメージファイルを直接出力するモード
	final private String outJSPPage   = "/spread/chartInfo.jsp";	// イメージファイル表示用JSP

	// ********** メソッド **********

	/*
	 * JFreeChartを表示する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 *         XMLのvalueが数値ではないなどの理由で、NumberFormatExceptionが発生した場合は、
	 *         ブランクページを戻す
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

			// Chart生成用XMLドキュメントの文字コードを取得
			String sourceStrCode = helper.getRequest().getParameter("strCode");

			// Chart生成用XMLドキュメントを生成、取得
			String tmpChartXML = helper.getRequest().getParameter("chartXML");
//			String chartXML = new String(tmpChartXML.getBytes(sourceStrCode), "Shift_JIS");
			String chartXML = URLDecoder.decode(tmpChartXML , "UTF-8");

			XMLConverter xmlConverter = new XMLConverter();
			Document chartXMLDoc = xmlConverter.toXMLDocument(chartXML);

			// XMLのValue要素より、フォーマット文字（カンマ（,）、半角通貨記号（\）、全角通貨記号（￥）、割合（%））を削除
			NodeList values =  xmlConverter.selectNodes(chartXMLDoc, "//Value");
			for (int i=0; i<values.getLength(); i++) {
				Node node = values.item(i);
				String value = node.getFirstChild().getNodeValue();
				String numberValue = value.replaceAll(",", "");
				numberValue = numberValue.replaceAll("\\\\", "");
				numberValue = numberValue.replaceAll("￥", "");
				numberValue = numberValue.replaceAll("%", "");
				node.getFirstChild().setNodeValue(numberValue);	
			}


			// ChartCreatorを使用し、XMLドキュメントよりチャートを設定
			ChartCreator chartCreator = new ChartCreator();
			try {
				chartCreator.createChart(chartXMLDoc);
			} catch (NumberFormatException e) {
				// XMLのValueが文字列でなかった場合には、ブランクページを戻す。
				return "/spread/blank.html";
			}
			

			// モードを選択
			// 1. Chartイメージファイル表示用JSPを呼び出し、HTML内でイメージを表示する方法
			// 2. Chartイメージファイルを直接出力する方法
			String chartDispMode = helper.getRequest().getParameter("chartDispMode");
			if(outXMLMode.equals(chartDispMode)) {
				// ChartCreatorオブジェクトを、request オブジェクトに保存
				helper.getRequest().setAttribute("chartCreator", chartCreator);
				return outJSPPage;				
			} else if (outImageMode.equals(chartDispMode)) {
				// イメージを直接出力
				chartCreator.outDirectPNGChart(helper.getResponse());
				return null;	
			} else {
				throw new IllegalArgumentException();
			}

	}
}
