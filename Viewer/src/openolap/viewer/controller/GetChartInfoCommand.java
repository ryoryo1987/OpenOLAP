/* OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：GetChartInfoCommand.java
 *  説明：JFreeChart用のXMLドキュメントを生成するクラスです。
 *  作成日: 2004/08/05
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import org.w3c.dom.Document;

import openolap.viewer.Report;
import openolap.viewer.chart.ChartCreator;
import openolap.viewer.chart.ChartXMLCreator;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.manager.CellDataManager;

/**
 *  クラス：GetChartInfoCommand<br>
 *  説明：JFreeChart用のXMLドキュメントを生成するクラスです。
 */
public class GetChartInfoCommand implements Command {

	/*
	 * セッションのReportオブジェクトが持つ、チャート情報画面タイプ・デフォルトチャートタイプ名を更新後、
	 * JFreeChart用のXMLドキュメントを生成する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

		// Session中のReportオブジェクトを更新
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");

		// チャート情報画面タイプを更新
		String dispScreenType = (String)helper.getRequest().getParameter("displayScreenType");
		report.setDisplayScreenType(dispScreenType);

		// デフォルトチャートタイプ名を更新
		String chartID = (String)helper.getRequest().getParameter("chartID");
		String chartName = (new ChartXMLCreator()).chartIdToName(ChartXMLCreator.getChartXMLFilePath(helper), chartID);
		report.setCurrentChart(chartName);

		// 画面タイプが、全画面（表）であれば、これ以降のチャート生成処理は行なわない
		// （ただし、ここまでの処理で、セッション情報は更新できた。）
		if ("0".equals(dispScreenType)) {
			return "/spread/blank.html";
		}
		

		// ディメンションメンバ、セルデータ取得条件をSessionに一時保存
		// （セルデータ取得処理をレポートの値取得処理と共通化するため）
		CellDataManager.saveRequestParamsToSession(helper);

		// Chart生成用XMLドキュメントを生成、取得
		Document chartXMLDoc = (new ChartXMLCreator()).createXML(helper, commonSettings);

		// ChartCreatorを使用し、XMLドキュメントよりチャートを設定
		ChartCreator chartCreator = new ChartCreator();
		chartCreator.createChart(chartXMLDoc);

		// ChartCreatorオブジェクトを、request オブジェクトに保存
		helper.getRequest().setAttribute("chartCreator", chartCreator);

		// Sessionから、データ取得用のメタ情報を削除
//		CellDataManager.clearRequestParamForGetDataInfo(helper); 

		return "/spread/chartInfo.jsp";
	}

}
