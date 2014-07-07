/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.export
 *  ファイル：ExportReportAsCSV.java
 *  説明：CSV形式でレポートをエクスポートするクラスです。
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
import java.util.Iterator;
import java.util.TreeMap;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.CellData;
import openolap.viewer.Col;
import openolap.viewer.Report;
import openolap.viewer.Row;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.Constants;
import openolap.viewer.common.Messages;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  クラス：ExportReportAsCSV<br>
 *  説明：CSV形式でレポートをエクスポートするクラスです。
 */
public class ExportReportAsCSV extends ExportReport {


	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(ExportReportAsCSV.class.getName());


	// ********** メソッド **********


	/**
	 * エクスポート処理を実行し、ダウンロードページのパスを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 * @exception FileNotFoundException 処理中に例外が発生した
	 * @exception UnsupportedEncodingException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生したUnsupportedEncodingException
	 */
	public String exportReport(RequestHelper helper) throws SQLException, NamingException, IOException {

		HttpServletRequest request = helper.getRequest();
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		if (report==null) {
			throw new IllegalStateException();
		}

		// ファイルパス、ファイルURLを設定
		String dirPath = helper.getConfig().getServletContext().getRealPath("/") + "export";
		String fileName = "report" + request.getSession().getId() + ".csv";
		String filePath = dirPath + "/" + fileName;
		String fileURL = request.getContextPath() + "/" + Messages.getString("ExportReportAsCSV.exportTmpDir") + "/" + fileName; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
		CommonUtils.loggingMessage(helper, log, "Export File URL(CSV)", fileURL);

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

			// セルデータ(値はフォーマット付)を取得
			ArrayList<CellData> cellDataList = CellDataManager.selectCellDatas(helper, conn, true, CellDataDAO.normalSQLTypeString);
			// セルデータをテーブル形式にソートし直したもの
			TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap = CellDataManager.getCellDataTable(report, cellDataList);

			// エッジ
			Col col = (Col) report.getEdgeByType(Constants.Col);
			Row row = (Row) report.getEdgeByType(Constants.Row);
			
			// エッジの持つ軸リスト
			ArrayList<Axis> colAxesList = col.getAxisList();
			ArrayList<Axis> rowAxesList = row.getAxisList();
			ArrayList<Axis> pageAxesList = report.getEdgeByType(Constants.Page).getAxisList();


			String colIndexKeysString = (String)request.getSession().getAttribute("viewColIndexKey_hidden");
			String rowIndexKeysString = (String)request.getSession().getAttribute("viewRowIndexKey_hidden");

			// =============== CSVファイル生成処理開始 ===============
			fs = new FileOutputStream(filePath, false);	//既存のファイルがある場合、上書きする
			osw = new OutputStreamWriter(fs,"Shift_JIS");
			out = new PrintWriter(new BufferedWriter(osw));


			// =============== CSV出力開始 ===============

			// レポートタイトル
			out.println(report.getReportName());

			// ページエッジ軸名, ページエッジデフォルトメンバー名
			String pageAxisName = ",";
			String memberName = "選択メンバー,";
			Iterator<Axis> pageIt = pageAxesList.iterator();
			int i = 0;
			int j = 0;
			int k = 0;
			while (pageIt.hasNext()) {
				if(i>0){
					pageAxisName += ",";
					memberName += ",";
				}
				Axis axis = pageIt.next();
				pageAxisName += axis.getName();
				memberName += axis.getDefaultMemberName(conn);
				i++;
			}
			out.println(pageAxisName);
			out.println(memberName);

			out.println();	// 空行

			// 列ヘッダの軸名リスト
			String colAxisName = null;
				colAxisName = StringUtil.addString("","first",rowAxesList.size(),",");
			Iterator<Axis> colIt = colAxesList.iterator();
			i = 0;
			while (colIt.hasNext()) {
				if (i>0) {
					colAxisName += ",";
				}
				Axis axis = colIt.next();
				colAxisName += axis.getName();
				i++;
			}
			out.println(colAxisName);

			// クロスヘッダ部、列ヘッダ部出力

			// 行ヘッダの軸名リスト生成
			String rowAxisName = "";
			Iterator<Axis> rowIt = rowAxesList.iterator();
			i = 0;
			while (rowIt.hasNext()) {
				if (i>0) {
					rowAxisName += ",";
				}
				Axis axis = rowIt.next();
				rowAxisName += axis.getName();
				i++;
			}

			colIt = colAxesList.iterator();
			i = 0;
			while (colIt.hasNext()) {
				Axis colAxis = (Axis) colIt.next();
				int colMergeNum = getCellMergeNum(col, colAxis)+1;	// セル結合するセルの数

				// ===== クロスヘッダ部 =====
				if (i == (colAxesList.size()-1)) {	// 最終段の場合、軸タイトルを表示
						out.print(rowAxisName);
				} else {
					out.print(StringUtil.addString("", "first", rowAxesList.size()-1, ","));
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
//System.out.println(i + "," + j + "," + colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis) + mergeNum);

							out.print(",");
							out.print("\"" + colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis) + "\"");
							out.print(StringUtil.addString("", "first", mergeNum, ",")); // セルの幅の分だけ","を出力

						}

						beforeKey = key;
						beforeKeys = keys;
						mergeNum = 0;
					}

					j++;
				}

				// 最後の要素を表示する
				if (j > 0) { // 列ヘッダの要素が一つ以上存在した
					out.print(",");
				}

				out.print("\"" + colAxis.getAxisMemberByUniqueName(beforeKey).getSpecifiedDisplayName(colAxis) + "\"");
				out.print(StringUtil.addString("", "first", mergeNum, ",")); // セルの幅の分だけ","を出力

				// 行出力の終了タグ
				out.println();
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

				// 行ヘッダー出力
				for (i = 0; i < rowAxesList.size(); i++ ){

					if (!this.isJoinMember(beforeKeys, keys, i)) { 
						Axis rowAxis = rowAxesList.get(i);
						String key   = keyList.get(i);
						AxisMember axisMember = (AxisMember) rowAxis.getAxisMemberByUniqueName(key);

						out.print("\"" + axisMember.getSpecifiedDisplayName((Axis)rowAxesList.get(i)) + "\"");
						out.print(","); // 次のセルとの区切り（次段の行ヘッダメンバーセルもしくはデータテーブルセル）
					} else {
						out.print(","); // このセルは結合対象となるセルであり、名称は表示しないが、区切り文字は出力する
					}
				}

				// データテーブル部出力
				this.printDataRow(dataRowMap, rowIndex, out);

				beforeKeys = keys;
				rowIndex++;
			}

			out.println(); // 改行

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

	// ********** privateメソッド **********

	/**
	 * データテーブル部を一行出力する
	 * @param dataRowMap データ行をあらわすMapオブジェクト
	 * @param newRowIndex 出力する列のインデックス
	 * @param out PrintWriterをあらわすオブジェクト
	 */
	private void printDataRow(TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap, int newRowIndex, PrintWriter out) {

		// 取得対象となる行のクライアント側でのSpreadIndexの値と、取得対象となる行に対して、通番で振られるIndexを変換する
		ArrayList<Integer> oldRowIndex = new ArrayList<Integer>(dataRowMap.keySet());
		TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(oldRowIndex.get(newRowIndex));
		Iterator<Integer> dataCellIt = dataCellMap.keySet().iterator();
		int i = 0;
		while (dataCellIt.hasNext()) {
			Integer colIndex = dataCellIt.next();
			String value = "\"" + ( dataCellMap.get(colIndex) ).getValue() + "\"";

			if (i>0) {
				out.print(",");
			}
			out.print(value);
			i++;
		}
		// 改行
		out.println();
	}

}
