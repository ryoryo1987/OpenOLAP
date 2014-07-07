/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.export
 *  ファイル：ExportReportAsXMLSpreadsheetSchema.java
 *  説明：XML Spreadsheet Schema形式でレポートをエクスポートするクラスです。
 *
 *  作成日: 2004/01/31
 */
package openolap.viewer.export;

import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.Hashtable;
import java.util.Set;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.apache.log4j.Logger;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;


import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.CellData;
import openolap.viewer.Col;
import openolap.viewer.Measure;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.Row;
import openolap.viewer.XMLConverter;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.Constants;
import openolap.viewer.common.Messages;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  クラス：ExportReportAsXMLSpreadsheetSchema<br>
 *  説明：XML Spreadsheet Schema形式でレポートをエクスポートするクラスです。
 */
public class ExportReportAsXMLSpreadsheetSchema extends ExportReport {

	// ********** インスタンス変数 **********

	/** xIndex変換用テーブル
	 *  (クライアントのSpreadIndex⇒エクスポートされるレポート構造をもとに新たに振りなおしたIndex) 
     */
	private Hashtable<Integer, Integer> xIndexChangeTable = null;

	/** yIndex変換用テーブル 
	 *  (クライアントのSpreadIndex⇒エクスポートされるレポート構造をもとに新たに振りなおしたIndex) 
	 */
	private Hashtable<Integer, Integer> yIndexChangeTable = null;


	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(ExportReportAsXMLSpreadsheetSchema.class.getName());


	// ********** メソッド **********

	/**
	 * エクスポート処理を実行し、ダウンロードページのパスを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public String exportReport(RequestHelper helper) throws SQLException, NamingException, IOException, DOMException, ParserConfigurationException, SAXException, TransformerException, XPathExpressionException {

		int i = 0;
		int j = 0;
		int k = 0;

		HttpServletRequest request = helper.getRequest();
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		if (report==null) {
			throw new IllegalStateException();
		}

		// ファイルパス、ファイルURLを設定
		String dirPath = helper.getConfig().getServletContext().getRealPath("/") + "export";
		String fileName = "xmlSpreadsheet" + request.getSession().getId() + ".xml";
		String filePath = dirPath + "/" + fileName;

		String fileURL = request.getContextPath() + "/" + Messages.getString("ExportReportAsCSV.exportTmpDir") + "/" + fileName;
		CommonUtils.loggingMessage(helper, log, "Export File URL(XMLSpreadSheet)", fileURL);

		helper.getRequest().setAttribute("downloadURL", fileURL);

		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		Connection conn = null;
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));


		FileOutputStream fs = null;
		OutputStreamWriter osw = null;
		PrintWriter out = null;
		try {

			// =============== 共通情報を取得 ===============

			// 行・列に配置された全DimensionオブジェクトにDimensionMemberオブジェクトをセット
			report.setSelectedCOLROWDimensionMembers(helper, report, conn);

			// セルデータ(値は単位フォーマットのみ)を取得
			ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(helper, conn, false, CellDataDAO.normalSQLTypeString);
			TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap = CellDataManager.getCellDataTable(report, cellDataList);	// セルデータをテーブル形式にソートし直したもの

			// Index変換テーブル(Key:oldSpreadIndex, value:newSpreadIndex)
			xIndexChangeTable = getSpreadIndexChangeTable(dataRowMap,"x");
			yIndexChangeTable = getSpreadIndexChangeTable(dataRowMap,"y");

			// エッジ
			Col col = (Col) report.getEdgeByType(Constants.Col);
			Row row = (Row) report.getEdgeByType(Constants.Row);
			
			// エッジの持つ軸リスト			
			ArrayList<Axis> colAxesList = col.getAxisList();
			ArrayList<Axis> rowAxesList = row.getAxisList();
			ArrayList<Axis> pageAxesList = report.getEdgeByType(Constants.Page).getAxisList();

			// 色情報
			TreeMap<Integer, TreeMap<Integer, String>> colColorMap = this.getColorMap(helper, Constants.Col);
			TreeMap<Integer, TreeMap<Integer, String>> rowColorMap = this.getColorMap(helper, Constants.Row);
			TreeMap<Integer, TreeMap<Integer, String>> dataColorMap = this.getColorMap(helper, Constants.Data);

			// 色とスタイルIDの対応表を作成
			Hashtable<String, String> colColorStyleTable = getColorStyleList("s" + Constants.Col, colColorMap);	
			Hashtable<String, String> rowColorStyleTable = getColorStyleList("s" + Constants.Row, rowColorMap);
			Hashtable<String, String> dataColorStyleTable = getColorStyleList("s" + Constants.Data, dataColorMap);

			// 色情報をオブジェクトに保存
			TableColorInfo colTableColorInfo = new TableColorInfo(("s" + Constants.Col), colColorMap, colColorStyleTable);
			TableColorInfo rowTableColorInfo = new TableColorInfo(("s" + Constants.Row), rowColorMap, rowColorStyleTable);
			TableColorInfo dataTableColorInfo = new TableColorInfo(("s" + Constants.Data), dataColorMap, dataColorStyleTable);


			String colIndexKeysString = (String)request.getSession().getAttribute("viewColIndexKey_hidden");
			String rowIndexKeysString = (String)request.getSession().getAttribute("viewRowIndexKey_hidden");

			// =============== XML Spreadsheet ファイル生成処理開始 ===============

			fs = new FileOutputStream(filePath, false);	//既存のファイルがある場合、上書きする
			osw = new OutputStreamWriter(fs,"UTF-8");
			out = new PrintWriter(new BufferedWriter(osw));

			// =============== XML Spreadsheet 出力開始 ===============
			out.println("<?xml version=\"1.0\"?>");
			out.println("<?mso-application progid=\"Excel.Sheet\"?>");
			out.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
			out.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
			out.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
			out.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
			out.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");


			// ===== スタイル =====

			out.println("<Styles>");

				// スタイル情報の出力
				out.println("<Style ss:ID=\"border\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"header\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
					out.println("<Interior ss:Color=\"#CCFFFF\" ss:Pattern=\"Solid\"/>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"sCOL\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
					out.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"sROW\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
					out.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
				out.println("</Style>");
				out.println("<Style ss:ID=\"sDATA\">");
					out.println("<Borders>");
					out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
					out.println("</Borders>");
				out.println("</Style>");

				// === 塗りつぶしモードの色づけ設定をもとにセルのスタイルを出力 ===
				// 		１．行・列のセルスタイルを出力
				// 		書式（色設定の無いセル）：sCOL<colorIndex>
				// 		書式（色設定のあるセル）：sROW<colorIndex>
				this.printColorStyle(colColorStyleTable, out);
				this.printColorStyle(rowColorStyleTable, out);

				// 		２．データテーブル部のセルのスタイルを出力。
				// 		戻り値：メジャーメンバータイプのgroupNameをKeyに持ち、重複するgroupNameを排除し新たに0から振りなおしたインデックス(memberTypeIndex)をValueに持つHashMap
				// 			    indexはスタイルIDの一部
				// 		書式（色設定の無いセル)：sDATA_<memberTypeIndex>)
				// 		書式（色設定のあるセル)：sDATA<colorIndex>_<memberTypeIndex>)
				HashMap<String, Integer> measureMemberTypeStyleIndexMap = this.printColorAndFormatStyle(dataColorStyleTable, report, out);


				// === ハイライトモード（パネルモードは対象外）の色づけ設定をもとにデータセルのスタイルを出力 ===
				this.printHighLightColorStyle(report, out);


			out.println("</Styles>");


			// ===== ワークシート =====
			out.println("<Worksheet ss:Name=\"Sheet1\">");
			out.println("<Table>");

			// レポートタイトル
			this.printlnRowStartTag(out);
			this.printlnCell(report.getReportName(), "border", 0, 0, 0, "String", out);
			this.printlnRowEndTag(out);

			// ページエッジ軸名
			this.printlnRowStartTag(out);
			this.printlnCell("", "", 0, 0, 0, "String", out);

			Iterator<Axis> pageIt = pageAxesList.iterator();
			while (pageIt.hasNext()) {
				Axis axis = pageIt.next();
				this.printlnCell(axis.getName(), "border", 0, 0, 0, "String", out);
			}
			this.printlnRowEndTag(out);

			// ページエッジデフォルトメンバー名
			this.printlnRowStartTag(out);
			this.printlnCell("選択メンバー", "border", 0, 0, 0, "String", out);

			pageIt = pageAxesList.iterator();
			while (pageIt.hasNext()) {
				Axis axis = pageIt.next();
				this.printlnCell(axis.getDefaultMemberName(conn), "border", 0, 0, 0, "String", out);
			}
			this.printlnRowEndTag(out);

			// 空白行を出力
			this.printlnRowStartTag(out);
			this.printlnCell("", "", 0, 0, 0, "String", out);
			this.printlnRowEndTag(out);

			// 列ヘッダの軸名リスト
			this.printlnRowStartTag(out);
			for (i = 0; i < rowAxesList.size(); i++) {
				this.printlnCell("","", 0, 0, 0, "String", out);
			}
			Iterator<Axis> colIt = colAxesList.iterator();
			while (colIt.hasNext()) {
				Axis axis = colIt.next();
				this.printlnCell(axis.getName(),"header", 0, 0, 0, "String", out);
			}
			this.printlnRowEndTag(out);

			// ===== クロスヘッダ部、列ヘッダ部出力 =====
			colIt = colAxesList.iterator();
			i = 0;
			while (colIt.hasNext()) {

				// 行出力の開始タグ
				this.printlnRowStartTag(out);
				Axis colAxis = colIt.next();

				// ===== クロスヘッダ部 =====
				if (i == (colAxesList.size()-1)) {	// 最終段の場合、軸タイトルを表示

					// 行ヘッダの軸名リスト
					Iterator<Axis> rowIt = rowAxesList.iterator();
					while (rowIt.hasNext()) {
						Axis rowAxis = rowIt.next();
						this.printlnCell(rowAxis.getName(),"header", 0, 0, 0, "String", out);
					}

				} else {

					// 列ヘッダ表示位置を整えるため、空白セルを出力
					for (j = 0; j < rowAxesList.size(); j++) {
						this.printlnCell("","header", 0, 0, 0, "String", out);
					}

				}

				// ===== 列ヘッダ部(メンバー名を出力) =====

				// SpreadIndexの順でソート
				TreeMap<Integer, String> colIndexKeyMap = new TreeMap<Integer, String>();
				ArrayList<String> colIndexKeyList = StringUtil.splitString(colIndexKeysString, ",");
				Iterator<String> colIndexKeyIt = colIndexKeyList.iterator();

				while (colIndexKeyIt.hasNext()) {
					String colIndexKey = colIndexKeyIt.next();
					ArrayList<String> colIndexKeys = StringUtil.splitString(colIndexKey, ":");
					String index = colIndexKeys.get(0);
					Integer ind  = Integer.decode(index);
					String keys  = colIndexKeys.get(1);
					colIndexKeyMap.put(ind, keys);
				}

				Iterator<Integer> colIndexKeyMapIt = colIndexKeyMap.keySet().iterator();

				String beforeKey = null;
				String beforeKeys = null;
				int mergeNum = 0;
				int beforeJ  = 0;
				j = 0;
				while (colIndexKeyMapIt.hasNext()) {

					Integer index = colIndexKeyMapIt.next();
					String keys   = colIndexKeyMap.get(index);

					ArrayList<String> keyList = StringUtil.splitString(keys, ";");
					String key = keyList.get(i);

					if (isJoinMember(beforeKeys, keys, i)) {
						mergeNum++;
					} else {

						if ( j != 0 ) {
							String styleID = getCellStyle(colTableColorInfo, beforeJ, i);
							this.printlnCell(colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis), styleID, 0, mergeNum, 0, "String", out);
						}

						beforeJ = j;
						beforeKey = key;
						beforeKeys = keys;
						mergeNum = 0;
					}

					j++;
				}

				// 最後の要素を表示する
				String styleID = getCellStyle(colTableColorInfo, beforeJ, i);
				this.printlnCell(colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis), styleID, 0, mergeNum, 0, "String", out);

				// 行出力の終了タグ
				this.printlnRowEndTag(out);
				i++;
		  	}
	
		
			// ===== 行ヘッダ部(メンバー名)、データセル部(値)出力 =====

			// SpreadIndexの順でソート
			TreeMap<Integer, String> rowIndexKeyMap = new TreeMap<Integer, String>();
			ArrayList<String> rowIndexKeyList = StringUtil.splitString(rowIndexKeysString, ",");
			Iterator<String> rowIndexKeyIt = rowIndexKeyList.iterator();

			while (rowIndexKeyIt.hasNext()) {
				String rowIndexKey = rowIndexKeyIt.next();
				ArrayList<String> rowIndexKeys = StringUtil.splitString(rowIndexKey, ":");
				String index = rowIndexKeys.get(0);
				Integer ind  = Integer.decode(index);
				String keys  = rowIndexKeys.get(1);
				rowIndexKeyMap.put(ind, rowIndexKey);
			}

			// ArrayListに持ち直し
			Iterator<Integer> rowIndexKeyMapIt = rowIndexKeyMap.keySet().iterator();
			ArrayList<String> sortedIndexKeyList = new ArrayList<String>();
			while (rowIndexKeyMapIt.hasNext()) {
				Integer ind = rowIndexKeyMapIt.next();
				sortedIndexKeyList.add( rowIndexKeyMap.get(ind));
			}


			Iterator<String> rowIndexIt = sortedIndexKeyList.iterator();
			String beforeKeys = null;
			int rowIndex = 0;
			while (rowIndexIt.hasNext()) {
				String rowIndexKey = rowIndexIt.next();
				ArrayList<String> rowIndexKeys = StringUtil.splitString(rowIndexKey, ":");
				String index = rowIndexKeys.get(0);
				Integer ind  = Integer.decode(index);
				String keys  = rowIndexKeys.get(1);
				ArrayList<String> keyList = StringUtil.splitString(keys, ";");

				this.printlnRowStartTag(out);


				// 行ヘッダー出力
				for (i = 0; i < rowAxesList.size(); i++ ){

					if (!this.isJoinMember(beforeKeys, keys, i)) { 
						Axis rowAxis = rowAxesList.get(i);
						String key   = keyList.get(i);
						AxisMember axisMember = (AxisMember) rowAxis.getAxisMemberByUniqueName(key);

						int rowCellMergeNum = this.getFollowingSameKeyNums(rowIndex, i, sortedIndexKeyList);

						String styleID = getCellStyle(rowTableColorInfo, i, rowIndex);
						this.printlnCell(axisMember.getSpecifiedDisplayName(rowAxesList.get(i)), styleID, (i+1), 0, rowCellMergeNum, "String", out);

					}

				}

				// データテーブル部出力
				this.printDataRow(report, dataRowMap, dataTableColorInfo, report.getMeasure(), measureMemberTypeStyleIndexMap, rowIndex, out);
				this.printlnRowEndTag(out);

				beforeKeys = keys;
				rowIndex++;
			}

			out.println("</Table>");

			// ウインドウ枠固定
			// データテーブルのセル(0行0列)の座標をセル内のインデックスに変換
			String horizontal = Integer.toString(5+report.getEdgeByType(Constants.Col).getAxisList().size());	// 
			String vertical = Integer.toString(0+report.getEdgeByType(Constants.Row).getAxisList().size());		// 
			out.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
				out.println("<FrozenNoSplit/>");
				out.println("<SplitHorizontal>" + horizontal + "</SplitHorizontal>");
				out.println("<TopRowBottomPane>" + horizontal + "</TopRowBottomPane>");
				out.println("<SplitVertical>" + vertical + "</SplitVertical>");
				out.println("<LeftColumnRightPane>"+ vertical + "</LeftColumnRightPane>");
				out.println("<ActivePane>0</ActivePane>");
			out.println("</WorksheetOptions>");


			out.println("</Worksheet>");
			out.println("</Workbook>");

			out.flush();
			osw.flush();

		} catch (FileNotFoundException e) {
			throw e;
		} catch (UnsupportedEncodingException e) {
			throw e;
		} catch (IOException e) {
			throw e;
		} catch (SQLException e) {
			throw e;
		} finally {

			if (fs != null) {
				try {
					fs.close();
				} catch (IOException e1) {
					throw e1;
				}
			}

			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e1) {
					throw e1;
				}
			}

		}

		// 一時保存したディメンションメンバー情報を削除する
		report.clearDimensionMembers();

		return "/spread/downloadAct.jsp";

	}


	// ********** privateメソッド **************************************************


	// ********** privateメソッド(style関連) **************************************************

	/**
	 * セルに対して適用するスタイルのIDを求める
	 * @param colorInfo 色情報を格納するオブジェクト
	 * @param x 列ヘッダ、行ヘッダ、データテーブル内でのX座標
	 * @param y 列ヘッダ、行ヘッダ、データテーブル内でのY座標
	 * @return スタイルID
	 */
	private String getCellStyle(TableColorInfo colorInfo, int x, int y) {

		String target = colorInfo.getTarget();
		TreeMap<Integer, TreeMap<Integer, String>> targetMap = colorInfo.getTargetmap();
		Hashtable<String, String> colorStyleTable = colorInfo.getColorStyletable();

		if (targetMap.containsKey(new Integer(y))) {
			TreeMap<Integer, String> colMap = targetMap.get(new Integer(y));
			if (colMap.containsKey(new Integer(x))) {
				String color = colMap.get(new Integer(x));
				if (colorStyleTable.containsKey(color)){
					String styleID = colorStyleTable.get(color);
					return styleID;
				} else {
					throw new IllegalStateException();
				}
			} else {
				return target;
			}
		} else { 
			return target;
		}
	}

	/**
	 * セルのスタイル（色・フォーマット）を出力
	 * @param colorTable 色とスタイルIDの対応表
	 * @param report レポートオブジェクト
	 * @param out PrintWriterオブジェクト
	 */
	private HashMap<String, Integer> printColorAndFormatStyle(Hashtable<String, String> colorTable, Report report, PrintWriter out) {

		HashMap<String, Integer> measureMemberTypeStyleIndexMap = new HashMap<String, Integer>();
		Measure measure = report.getMeasure();
		ArrayList<AxisMember> targetMeasureMembers = null;
		if (report.isInPage(measure)) {
			targetMeasureMembers = new ArrayList<AxisMember>();
			MeasureMember measureMember = null;
			String defaultMemberKey = measure.getDefaultMemberKey();
			if (defaultMemberKey == null) {
				measureMember = (MeasureMember) measure.getAxisMemberList().get(0);
			} else {
				measureMember = (MeasureMember)measure.getAxisMemberByUniqueName(defaultMemberKey);
			}
			targetMeasureMembers.add(measureMember);
		} else { // メジャーが行か列にある
			targetMeasureMembers = measure.getAxisMemberList();
		}


		// 色設定の無いセルのスタイルを出力
		int i = 0;
		Iterator<AxisMember> meaMemIte = targetMeasureMembers.iterator();
		while (meaMemIte.hasNext()) {
			MeasureMember measureMember = (MeasureMember)meaMemIte.next();
			if (measureMemberTypeStyleIndexMap.containsKey(measureMember.getMeasureMemberType().getGroupName()) ) {
				continue;
			} else {
				measureMemberTypeStyleIndexMap.put(measureMember.getMeasureMemberType().getGroupName(), new Integer(i));
				this.outStyle(null, null, true, measureMember, Integer.toString(i), out);
				i++;
			}
		}

		// 色設定のされているセルのスタイルを出力
		Iterator<String> colorIt = colorTable.keySet().iterator();
		if (colorTable.size()>0) {
			while (colorIt.hasNext()) {
				String color        = colorIt.next();
				String styleColorID = colorTable.get(color);

				HashMap<String, Integer> tmpMap = new HashMap<String, Integer>(); // メジャーメンバータイプで既に使用されたグループは除外するために使用する
				Iterator<AxisMember> ite = targetMeasureMembers.iterator();
				i = 0;
				while (ite.hasNext()) {

					MeasureMember measureMember = (MeasureMember)ite.next();
					if (tmpMap.containsKey(measureMember.getMeasureMemberType().getGroupName()) ) {
						continue;
					} else {
						tmpMap.put(measureMember.getMeasureMemberType().getGroupName(), new Integer(i));
						this.outStyle(styleColorID, color, true, measureMember, Integer.toString(i), out);
						i++;
					}
				}
			}
		}

		return measureMemberTypeStyleIndexMap;
	}


	/**
	 * スタイル（色・フォーマット）を出力
	 * @param styleColorID 色とスタイルIDの対応表
	 * @param color セルの色をあらわす文字列
	 * @param isDataCell データテーブルのセルであればtrue、それ以外であればfalse
	 * @param measureMember メジャーメンバーのオブジェクト
	 * @param dataID メジャーのメンバータイプから重複を排除し、Indexを振ったもの
	 * @param out PrintWriterオブジェクト
	 */
	private void outStyle(String styleColorID, String color, boolean isDataCell, MeasureMember measureMember, String dataID, PrintWriter out) {
		
		// スタイルID
		String styleID = null;
		if (isDataCell) { // データセルのスタイル
			if (styleColorID != null ) {
				styleID = styleColorID + "_" + dataID;

			} else {
				styleID = "sDATA" + "_" + dataID;
			}
		} else { // データセル以外(行ヘッダ、列ヘッダ)のスタイル
			styleID = styleColorID;
		}

		// セルの数値のフォーマット
		String numberFormat = null;
		if ( isDataCell ) {
			numberFormat = measureMember.getMeasureMemberType().getXMLSpreadsheetFormat();
		}

		this.outputStyle(styleID, color, null, numberFormat, out);

	}



	/**
	 * スタイル（セル枠、文字色、背景色、数値フォーマット）を出力
	 * @param styleID スタイルID
	 * @param backColor セルの背景色をあらわす文字列
	 *                   （nullの場合は設定しない）
	 * @param fontColor セルの文字色をあらわす文字列
	 *                   （nullの場合は設定しない）
	 * @param numberFormat セルの数値のフォーマットをあらわす文字列
	 *                   （nullの場合は設定しない）
	 * @param out PrintWriterオブジェクト
	 */
	private void outputStyle(String styleID, String backColor, String fontColor, String numberFormat, PrintWriter out) {
		
		// スタイル情報出力開始
		out.println("<Style ss:ID=\"" + styleID + "\">");

			// セル枠
			out.println("<Borders>");
			out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
			out.println("</Borders>");

			// セル文字色
			if (fontColor != null) {
				out.println("<Font ss:Color=\"" + fontColor + "\"/>");
			}

			// セル背景色
			if (backColor != null) {
				out.println("<Interior ss:Color=\"" + backColor + "\" ss:Pattern=\"Solid\"/>");
			}

			// セルの数値のフォーマット
			if (numberFormat != null) {
				out.println("<NumberFormat ss:Format=\"" + numberFormat +  "\"/>");
			}

		out.println("</Style>");
		
	}


	/**
	 * 行ヘッダ、列ヘッダのスタイルを出力
	 * @param colorTable 色情報テーブル
	 * @param out PrintWriterオブジェクト
	 */
	private void printColorStyle(Hashtable<String, String> colorTable, PrintWriter out) {

		Iterator<String> colorIt = colorTable.keySet().iterator();

		while (colorIt.hasNext()) {
			String color        = colorIt.next();
			String styleColorID = colorTable.get(color);

			this.outStyle(styleColorID,color,false, null,null,out);
		}
		
	}

	/**
	 * ハイライトモードの設定をもとにデータセルのスタイルを出力（パネルモードは対象外）
	 * @param report レポートテーブル
	 * @param out PrintWriterオブジェクト
	 */
	private void printHighLightColorStyle(Report report, PrintWriter out) throws ParserConfigurationException, SAXException, IOException, DOMException, TransformerException, XPathExpressionException {

		// ハイライト or パネルモードか
		if("2".equals((String)report.getColorType())){
			
			String highLightXML = report.getHighLightXML();
			if ( (highLightXML == null) || ("".equals(highLightXML)) ) {
				return;
			}

			XMLConverter xmlConverter = new XMLConverter();
			Document highLightXml = xmlConverter.toXMLDocument(highLightXML);

			// メジャー毎にハイライトモードかを判断する
			ArrayList<AxisMember> axisMemList = report.getMeasure().getAxisMemberList();
			Iterator<AxisMember> it = axisMemList.iterator();
			while (it.hasNext()) {
				AxisMember axisMember = it.next();
				if (axisMember instanceof MeasureMember) {
					MeasureMember measureMember = (MeasureMember) axisMember;

					String highLightPanelType = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/Mode").getFirstChild().getNodeValue();
					if("HighLight".equals(highLightPanelType)) { // ハイライトモード
						
						// ハイライト条件
						for (int i=0; i<5; i++) {

							// styleID の書式：hData[メジャーメンバーのID※]_[ハイライト条件番号(1～5)]
							// ※メジャーメンバーのID：1からの通番で、Viewerで採番されるもの。
							String styleID = "hData" + measureMember.getId() + "_" + (i+1);

							// 背景色
							String backColor = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "BackColor").getFirstChild().getNodeValue();

							// 文字色
							String fontColor = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "TextColor").getFirstChild().getNodeValue();
							
							// セルの数値のフォーマットをあらわす文字列
							String numberFormat = measureMember.getMeasureMemberType().getXMLSpreadsheetFormat();

							// スタイル情報出力
							this.outputStyle(styleID, backColor, fontColor, numberFormat, out);

						}

					}

				} else {
					// メジャーメンバーのリストしか取得できないため、エクセプション
					throw new IllegalStateException();
				}

			}
		}

	}


	/**
	 * 色とスタイルIDの対応表を求める
	 * @param target 列ヘッダか、行ヘッダか、データテーブルかをあらわす
	 * @param rowColorMap 列ヘッダ、行ヘッダ、データテーブルの行をあらわすオブジェクト
	 * @return 色とスタイルIDの対応表
	 */
	private Hashtable<String, String> getColorStyleList(String target, TreeMap<Integer, TreeMap<Integer, String>> rowColorMap) {
		
		Hashtable<String, String> colorStyleIDTable = new Hashtable<String, String>();
		
		Iterator<Integer> rowIte = rowColorMap.keySet().iterator();
		int i=0;
		while (rowIte.hasNext()) {
			Integer y = rowIte.next();
			TreeMap<Integer, String> colColorMap = rowColorMap.get(y);
			Iterator<Integer> colIte = colColorMap.keySet().iterator();
			while (colIte.hasNext()) {
				Integer    x = colIte.next();
				String color = colColorMap.get(x);

				if (!colorStyleIDTable.containsKey(color)) {
					colorStyleIDTable.put(color, (target + Integer.toString(i)));
					i++;
				}
			}
		}		
		
		return colorStyleIDTable;
	}

	// ********** privateメソッド(色情報関連) **************************************************


	/**
	 * クライアントからのリクエストより色情報を格納したTreeMapオブジェクトを求める
	 * @param helper RequestHelperオブジェクト
	 * @param target 列ヘッダか、行ヘッダか、データテーブルかをあらわす
	 * @return 色情報を格納したTreeMapオブジェクト
	 */
	private TreeMap<Integer, TreeMap<Integer, String>> getColorMap(RequestHelper helper, String target) {

		String indexColorInfo = "";
		if (Constants.Col.equals(target)) {
			indexColorInfo = helper.getRequest().getParameter("colHdrColor");
		} else if (Constants.Row.equals(target)) {
			indexColorInfo = helper.getRequest().getParameter("rowHdrColor");
		} else if (Constants.Data.equals(target)) {
			indexColorInfo = helper.getRequest().getParameter("dataHdrColor");
		}
		
		TreeMap<Integer, TreeMap<Integer, String>> rowTreeMap = new TreeMap<Integer, TreeMap<Integer, String>>();// 行ヘッダ、列ヘッダ、データ部の色情報を格納する

		ArrayList<String> colorInfoList = StringUtil.splitString(indexColorInfo, ",");
		Iterator<String> colorInfoIt = colorInfoList.iterator();
		while (colorInfoIt.hasNext()) {
			String indexColorString = colorInfoIt.next();
			ArrayList<String> IndexColor = StringUtil.splitString(indexColorString, ";");
			String indexes  = IndexColor.get(0);
			String webColor = IndexColor.get(1); 

			// Webカラーを表すスタイル名をもとにセルの色を求める
			String xmlSpreadColor = null;
			if (Constants.Data.equals(target)) { // データテーブルの場合
				xmlSpreadColor = Messages.getString("ExportReportAsXMLSpreadsheetSchema.XMLSpreadsheetData" + webColor);
			} else { // 行・列ヘッダの場合
				xmlSpreadColor = Messages.getString("ExportReportAsXMLSpreadsheetSchema.XMLSpreadsheetHdr" + webColor);
			}
			ArrayList<String> indexList = StringUtil.splitString(indexes, ":");

			Integer x = null;
			Integer y = null;
			Integer oldX = Integer.decode((String)indexList.get(0));
			Integer oldY = Integer.decode((String)indexList.get(1));

			// 表示セルのSpreadIndexを求める
			// ・Indexを表示対象となるメンバー(親がドリル未で非表示であるメンバー)のみで振りなおす
			// ・色づいているセルリストには表示対象とならないメンバー（親がドリル未で非表示であるメンバー）も含むが、その場合はスキップする
			if (Constants.Col.equals(target)) {
				if (xIndexChangeTable.containsKey(oldX)) {
					x = (Integer)xIndexChangeTable.get(oldX);
					y = oldY;// 列エッジにおける段Index
				} else {
					continue;
				}

			} else if (Constants.Row.equals(target)) {
				if (yIndexChangeTable.containsKey(oldY)) {
					x = oldX;// 行エッジにおける段Index
					y = (Integer)yIndexChangeTable.get(oldY);
				} else {
					continue;
				}
			} else { // データテーブルのセル
				if (!xIndexChangeTable.containsKey(oldX)) {
					continue;
				}
				if (!yIndexChangeTable.containsKey(oldY)) {
					continue;
				}
				x = (Integer)xIndexChangeTable.get(oldX);
				y = (Integer)yIndexChangeTable.get(oldY);	
			}

			TreeMap<Integer, String> cellMap = null;
			if (rowTreeMap.containsKey(y)) {
				cellMap = rowTreeMap.get(y);
				cellMap.put(x, xmlSpreadColor);
			} else {
				cellMap = new TreeMap<Integer, String>();
				cellMap.put(x, xmlSpreadColor);
				rowTreeMap.put(y, cellMap);	
			}
			
		}

		return rowTreeMap;
	}


	// ********** privateメソッド(セル出力関連) **************************************************

	/**
	 * データセル部を一行出力する
	 * @param report
	 * @param dataRowMap
	 * @param dataTableColorInfo
	 * @param measure
	 * @param measureMemberTypeStyleIndexMap
	 * @param newRowIndex
	 * @param out PrintWriterオブジェクト
	 */
	private void printDataRow(Report report, TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap, TableColorInfo dataTableColorInfo, Measure measure, HashMap<String, Integer> measureMemberTypeStyleIndexMap, int newRowIndex, PrintWriter out) throws DOMException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {
//System.out.println("measureMemberTypeStyleIndexMap:" + measureMemberTypeStyleIndexMap);

		// 取得対象となる行のクライアント側でのSpreadIndexの値と、取得対象となる行に対して、通番で振られるIndexを変換する
		ArrayList<Integer> oldRowIndex = new ArrayList<Integer>(dataRowMap.keySet());
		TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(oldRowIndex.get(newRowIndex));
		Iterator<Integer> dataCellIt = dataCellMap.keySet().iterator();
		int x = 0;
		while (dataCellIt.hasNext()) {
			Integer colIndex  = dataCellIt.next();
			CellData cellData = dataCellMap.get(colIndex);
			MeasureMember measureMember = (MeasureMember)measure.getAxisMemberByUniqueName(cellData.getMeasureMemberUniqueName());
			String groupName = measureMember.getMeasureMemberType().getGroupName();
			String value = cellData.getValue();

			String styleID = null;
			String highlightID = this.getValidHighlightID(report, measureMember, cellData);
			if (highlightID != null) {
				styleID = "hData" + measureMember.getId() + "_" + highlightID;
			} else {
				styleID = getCellStyle(dataTableColorInfo, x, newRowIndex) + "_" + measureMemberTypeStyleIndexMap.get(groupName);
			}

			this.printlnCell(value, styleID, 0, 0, 0, "Number", out);
			x++;
		}
	}


	/**
	 * 行開始タグを出力する
	 */
	private void printlnRowStartTag(PrintWriter out) {
		out.println("<Row>");
	}

	/**
	 * 行終了タグを出力する
	 */
	private void printlnRowEndTag(PrintWriter out) {
		out.println("</Row>");
	}

	/**
	 * セルを出力する
	 * @param value 値
	 * @param cellStyle スタイルID
	 * @param cellIndex セルの列インデックス
	 * @param mergeAcross セルを右方向に結合する数
	 * @param mergeDown セルを下方向に結合する数
	 * @param dataType セルのデータタイプ（String,Number等）
	 * @param out PrintWriterオブジェクト
	 */
	private void printlnCell(String value, String cellStyle, int cellIndex, int mergeAcross, int mergeDown, String dataType, PrintWriter out) {

		String styleString = "";
		String dataString  = "";
			if ( cellStyle != "" ) {
				styleString = " ss:StyleID=\"" + cellStyle + "\"";
			}
			if ( dataType != "" ) {
				dataString = " ss:Type=\"" + dataType + "\"";
			} else {
				dataString = " ss:Type=\"String\"";
			}

		String cellMergeIndexString = "";
			if (cellIndex>0){
				cellMergeIndexString = " ss:Index=\"" + Integer.toString(cellIndex) + "\"";
			}

		String mergeAcrossString = "";
			if (mergeAcross > 0) {
				mergeAcrossString = " ss:MergeAcross=\"" + Integer.toString(mergeAcross) + "\"";
			}

		String mergeDownString = "";
			if (mergeDown > 0) {
				mergeDownString = " ss:MergeDown=\"" + Integer.toString(mergeDown) + "\"";
			}

		out.println("<Cell" + cellMergeIndexString + mergeAcrossString + mergeDownString + styleString + ">");
		out.print("<Data" + dataString + ">");
		out.print(value);
		out.println("</Data>");
		out.println("</Cell>");
		
	}

	// ********** privateメソッド(その他) **************************************************

	/**
	 * クライアント側のSpreadIndexをKeyとし、今表示している行・列に対して新たに振りなおしたSpreadIndexをValueにもつIndex変換テーブルを返す。
	 * @param dataRowMap TreeMapオブジェクト
	 * @param targetCoordinates 座標
	 * @return Index変換テーブル
	 */
	private Hashtable<Integer, Integer> getSpreadIndexChangeTable(TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap, String targetCoordinates) {
		if ((dataRowMap == null) || (targetCoordinates == null) ) { throw new IllegalArgumentException(); }
		if (targetCoordinates.equals("x") && (targetCoordinates.equals("y"))) { throw new IllegalArgumentException(); }

		Hashtable<Integer, Integer> targetChangeTable = new Hashtable<Integer, Integer>();
		
		Iterator<Integer> oldRowIndexIt = dataRowMap.keySet().iterator();
		int i = 0;
		while (oldRowIndexIt.hasNext()) {
			Integer oldRowIndex = oldRowIndexIt.next();

			if (targetCoordinates.equals("y")){
				targetChangeTable.put(oldRowIndex, new Integer(i));
			} else if (targetCoordinates.equals("x")) {
				TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(oldRowIndex);
				Iterator<Integer> oldColIndexIt = dataCellMap.keySet().iterator();
				int j = 0;
				while (oldColIndexIt.hasNext()) {
					Integer oldColIndex = oldColIndexIt.next();
					targetChangeTable.put(oldColIndex, new Integer(j));
					j++;
				}
				break;
			}
			i++;
		}

//System.out.println("targetChangeTable" + targetCoordinates + (new HashMap(targetChangeTable)));

		return targetChangeTable;
	
	}

	/**
	 * 0段から指定された段までのキーの組み合わせがいくつ同じであるかを求める。
	 * @param spreadIndex SpreadのIndex
	 * @param hieIndex 段Index
	 * @param indexKeyList indexKeyのリスト
	 * @return 同じキーの組み合わせが続く数
	 */
	private int getFollowingSameKeyNums(int spreadIndex, int hieIndex, ArrayList<String> indexKeyList) {

		String indexKey = indexKeyList.get(spreadIndex);
		ArrayList<String> indexKeyArray = StringUtil.splitString(indexKey, ":");
		String keys = indexKeyArray.get(1);
		ArrayList<String> keyList = StringUtil.splitString(keys, ";");

		int count = 0;
		for (int i = 0; i < (indexKeyList.size()-spreadIndex-1); i++ ){

			String nextIndexKey = indexKeyList.get(spreadIndex + (i+1));
			ArrayList<String> nextIndexKeys = StringUtil.splitString(nextIndexKey, ":");
			String nextkeys = nextIndexKeys.get(1);
			ArrayList<String> nextkeyList = StringUtil.splitString(nextkeys, ";");

			for (int j = 0; j < hieIndex+1; j++) {
				String key     = keyList.get(j);
				String nextKey = nextkeyList.get(j);

				if (!key.equals(nextKey)) { // セル結合する領域から出た
					return count;
				}
			}
			count++;
		}
		return count;
	}


	/**
	 * ハイライトモードかどうかを判断（パネルモードも除外）し、ハイライトモードである場合は
	 * 与えられたcellDataの値が満たすハイライト条件のIDを求める。
	 * ハイライトモードでない、もしくは該当する条件がない場合は、nullを戻す。
	 * @param value 値
	 * @param cellStyle スタイルID
	 * @param cellIndex セルの列インデックス
	 * @param mergeAcross セルを右方向に結合する数
	 * @param mergeDown セルを下方向に結合する数
	 * @param dataType セルのデータタイプ（String,Number等）
	 * @param out PrintWriterオブジェクト
	 */
	private String getValidHighlightID(Report report, MeasureMember measureMember, CellData cellData) throws ParserConfigurationException, SAXException, IOException, DOMException, TransformerException, XPathExpressionException {
		
		String highLightID = null;
		
		// ハイライト or パネルモードか
		if("2".equals((String)report.getColorType())){
			
			String highLightXML = report.getHighLightXML();
			if ( (highLightXML == null) || ("".equals(highLightXML)) ) {
				return null;
			}

			XMLConverter xmlConverter = new XMLConverter();
			Document highLightXml = xmlConverter.toXMLDocument(highLightXML);

			// モード取得
			String highLightPanelType = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/Mode").getFirstChild().getNodeValue();
			if("HighLight".equals(highLightPanelType)) { // ハイライトモード

				// セルの値を求める
				String cellValue = cellData.getValue2();
	
				// 取得した値を含むハイライトの条件があるかを探す
				for (int i = 0; i < 5; i++) {

					Node fromNodeValue = xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "From").getFirstChild();
					Node toNodeValue   =  xmlConverter.selectSingleNode(highLightXml, "//Measure[@id='" + measureMember.getMeasureSeq() + "']/HighLight/Condition" + String.valueOf(i+1) + "To").getFirstChild();

					// ハイライトモードの範囲が未設定であれば、処理をスキップする。
					if ((fromNodeValue == null) || (toNodeValue == null)) {
						continue;
					}

					String fromValue = fromNodeValue.getNodeValue();
					String toValue   = toNodeValue.getNodeValue();

					double cellValueNum = Double.valueOf(cellValue).doubleValue();
						// [割合の場合は]ハイライト条件の範囲は100分率の値をあらわすため、それにそろえるために100を乗する。
						if ("percent".equals(measureMember.getMeasureMemberType().getGroupName())) {
							cellValueNum = cellValueNum * 100;
						}
					double fromValueNum = Double.valueOf(fromValue).doubleValue();
					double toValueNum   = Double.valueOf(toValue).doubleValue();

					if ((cellValueNum >= fromValueNum) && (cellValueNum <= toValueNum) ) {
						return String.valueOf(i+1);
					}

				}
			}
		
		}
		
		return highLightID;
	}


	// ********** innerクラス **********

	/**
	 *  Innerクラス：TableColorInfo
	 *  説明：色情報を格納するクラスです。
	 */
	class TableColorInfo {

		String target   = "";
		TreeMap<Integer, TreeMap<Integer, String>> targetMap = null;
		Hashtable<String, String> colorStyleTable = null;
	
		public TableColorInfo(String target, TreeMap<Integer, TreeMap<Integer, String>> targetMap, Hashtable<String, String> colorStyleTable) {
			this.target = target;
			this.targetMap = targetMap;
			this.colorStyleTable = colorStyleTable;			
		}
	
		Hashtable<String, String> getColorStyletable() {
			return colorStyleTable;
		}
		String getTarget() {
			return target;
		}
		TreeMap<Integer, TreeMap<Integer, String>> getTargetmap() {
			return targetMap;
		}

		void setColorStyletable(Hashtable<String, String> hashtable) {
			colorStyleTable = hashtable;
		}
		void setTarget(String string) {
			target = string;
		}
		void setTargetmap(TreeMap<Integer, TreeMap<Integer, String>> map) {
			targetMap = map;
		}

	}

}
