/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.manager
 *  ファイル：CellDataManager.java
 *  説明：データテーブルのセルの値を取得するクラスです。
 *
 *  作成日: 2004/02/02
 */
package openolap.viewer.manager;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import openolap.viewer.CellData;
import openolap.viewer.EdgeCoordinates;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.StringUtil;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.CellDataDAO;
import openolap.viewer.dao.CellDataSQL;
import openolap.viewer.dao.DAOFactory;

/**
 *  クラス：CellDataManager<br>
 *  説明：データテーブルのセルの値を取得するクラスです。
 */
public class CellDataManager {

	// ********** static メソッド **********

	/**
	 * Sessionに登録されたセルデータ取得条件を元にセルデータを求める。
	 * @param helper RequestHelperオブジェクト
	 * @param conn Connectionオブジェクト
	 * @param formatValue 値にメジャーメンバー毎に設定されたMeasureMemberTypeの書式を適用するならtrue、単位のみをそろえる書式を適用するならばfalse
	 * @param SQLType 実行するSQLタイプを表す文字列。CellDataDAO参照。
	 * @return セルデータオブジェクトのリスト
	 */
	public static ArrayList<CellData> selectCellDatas(RequestHelper helper, Connection conn, boolean formatValue, String SQLType) throws SQLException {

		HttpServletRequest request = helper.getRequest();
		HttpSession session = request.getSession();
		Report report =  (Report) session.getAttribute("report");

		int i;

//		   ===== 列ヘッダ・行ヘッダ・ページエッジ情報 =====
//		   列、行、ページエッジの次元ID/メジャーリスト
//		   (ページエッジは、次元ID/メジャーと選択された値をペアで格納。)
		Object[] items = new Object[3];		// 0:列エッジ、1:行エッジ、2:ページエッジ
			String colItemLists;			// 列エッジ
			String rowItemLists;			// 行エッジ
			String pageItemValuePairs;		// ページエッジ

			String colItems[];				// colItemListsより、各項目を格納した配列
			String rowItems[];				// rowItemListsより、各項目を格納した配列
			String pageItemValues[];		// pageItemValuePairsより、各項目を格納した配列
											//（配列の各要素の書式　「次元ID：KEY」）

			colItemLists       = (String) session.getAttribute("colEdgeIDList_hidden");
			rowItemLists       = (String) session.getAttribute("rowEdgeIDList_hidden");
			pageItemValuePairs = (String) session.getAttribute("pageEdgeIDValueList_hidden");
//System.out.println("colItemLists:" + colItemLists);
//System.out.println("rowItemLists:" + rowItemLists);


			ArrayList<String> colAxisList = StringUtil.splitString(colItemLists, ",");
			ArrayList<String> rowAxisList = StringUtil.splitString(rowItemLists, ",");
			ArrayList<String> pageItemValuePairList = StringUtil.splitString(pageItemValuePairs, ",");
			colItems       = (String[]) colAxisList.toArray(new String[colAxisList.size()]);
			rowItems       = (String[]) rowAxisList.toArray(new String[rowAxisList.size()]);
			pageItemValues = (String[]) pageItemValuePairList.toArray(new String[pageItemValuePairList.size()]);

		items[0] = colItems;
		items[1] = rowItems;
		items[2] = pageItemValues;

//		  列・行ページエッジに設定された次元/メジャー数
		int[] hieNums = new int[3];				// 0:列エッジ、1:行エッジ、2:ページエッジ
			hieNums[0] = colItems.length;		// 列エッジ
			hieNums[1] = rowItems.length;		// 行エッジ
			hieNums[2] = pageItemValues.length;	// ページエッジ

//		   データ取得対象となる列・行ヘッダのKey属性リスト
		Object[] selectKeys = new Object[2];	// 0:列エッジ、1:行エッジ
			String selectColKeys[] = new String[hieNums[0]];	// 列ヘッダ
			String selectRowKeys[] = new String[hieNums[1]];	// 行ヘッダ
			for ( i = 0; i < hieNums[0]; i++ ) {
				selectColKeys[i] = (String)session.getAttribute("viewCol" + i + "KeyList_hidden");
			}
			for ( i = 0; i < hieNums[1]; i++ ) {
				selectRowKeys[i] = (String)session.getAttribute("viewRow" + i + "KeyList_hidden");
			}

			selectKeys[0] = selectColKeys;
			selectKeys[1] = selectRowKeys;

//		   データ取得対象となる列・行ヘッダのIndex,Key属性リスト
			ArrayList<EdgeCoordinates> colCoordinatesList = EdgeCoordinates.createCoordinates((String)session.getAttribute("viewColIndexKey_hidden"), colItems);	// 列のEdgeCoordinates の集合を格納する
			ArrayList<EdgeCoordinates> rowCoordinatesList = EdgeCoordinates.createCoordinates((String)session.getAttribute("viewRowIndexKey_hidden"), rowItems);	// 列のEdgeCoordinates の集合を格納する
				// <viewColIndexKey_hidden,viewRowIndexKey_hidden書式>
				//	<SpreadIndex>:<0番目の段次元/メジャー要素のkey>;
				//	<1番目の段次元/メジャー要素のkey>;
				//	<2番目の段次元/メジャー要素のkey>

		// 値を取得するSQLをあらわすオブジェクトを作成する
  		CommonSettings commonSettings = (CommonSettings) helper.getConfig().getServletContext().getAttribute("apCommonSettings");
		CellDataSQL cellDataSQL = CellDataSQL.getSelectReportDataSQL(report, conn, items, selectKeys, formatValue, commonSettings );

		//セル座標、値を格納するCellDataオブジェクトのリストを作成
		CellDataDAO cellDataDAO = DAOFactory.getDAOFactory().getCellDataDAO(conn);
		ArrayList<CellData> cellDataList = cellDataDAO.selectCellDatas( cellDataSQL,			// セルの値を取得するSQLを表すオブジェクト
															  items,				// 軸IDのリスト（列と行毎に）
															  request,				// リクエストオブジェクト
															  report,				// レポートオブジェクト
															  colCoordinatesList,	// クライアントから取得したパラメータを元に作成した列座標リスト
															  rowCoordinatesList,	// クライアントから取得したパラメータを元に作成した行座標リスト
															  SQLType);				// SQLタイプ

		cellDataSQL = null;

		return cellDataList;

	}


	/**
	 * 以下に示すセルデータ取得用メタ情報をリクエストから取得し、セッションに仮保存する。
	 *   －colEdgeIDList_hidden 列に配置された軸IDのリスト
	 *   －rowEdgeIDList_hidden 行に配置された軸IDのリスト
	 *   －pageEdgeIDValueList_hidden ページに配置された軸IDとそのデフォルトメンバーキーのリスト
	 *   －viewCol<0,1,2>KeyList_hidden 値を取得する列の各段のメンバーキーのリスト
	 *   －viewRow<0,1,2>KeyList_hidden 値を取得する行の各段のメンバーキーのリスト
	 *   －viewColIndexKey_hidden 値を取得する列のSpreadIndexと各段のメンバーキーの組み合わせのリスト
	 *   －viewRowIndexKey_hidden 値を取得する行のSpreadIndexと各段のメンバーキーの組み合わせのリスト
	 * @param helper RequestHelperオブジェクト
	 */
	public static void saveRequestParamsToSession(RequestHelper helper) {
		HttpServletRequest request = helper.getRequest();
		HttpSession session = helper.getRequest().getSession();

		// Sessionに登録
		session.setAttribute("colEdgeIDList_hidden", request.getParameter("colEdgeIDList_hidden"));
		session.setAttribute("rowEdgeIDList_hidden", request.getParameter("rowEdgeIDList_hidden"));
		session.setAttribute("pageEdgeIDValueList_hidden", request.getParameter("pageEdgeIDValueList_hidden"));

		String colIdList = (String)request.getParameter("colEdgeIDList_hidden");
		String rowIdList = (String)request.getParameter("rowEdgeIDList_hidden");

		int colSize = StringUtil.splitString(colIdList,",").size();
		int rowSize = StringUtil.splitString(rowIdList,",").size();

		int i = 0;
		for ( i = 0; i < colSize; i++ ) {
			session.setAttribute("viewCol" + i + "KeyList_hidden", request.getParameter("viewCol" + i + "KeyList_hidden"));
		}
		for ( i = 0; i < rowSize; i++ ) {
			session.setAttribute("viewRow" + i + "KeyList_hidden", request.getParameter("viewRow" + i + "KeyList_hidden"));
		}

		session.setAttribute("viewColIndexKey_hidden", request.getParameter("viewColIndexKey_hidden"));
		session.setAttribute("viewRowIndexKey_hidden", request.getParameter("viewRowIndexKey_hidden"));
		
	}


	/**
	 * セッションから、セルデータ取得用のメタ情報を削除する。
	 * 削除するのはsaveRequestParamsToSessionで登録したパラメータである。
	 * @param helper RequestHelperオブジェクト
	 */

	public static void clearRequestParamForGetDataInfo(RequestHelper helper) {
		HttpServletRequest request = helper.getRequest();
		HttpSession session = helper.getRequest().getSession();

		String colIdList = (String)session.getAttribute("colEdgeIDList_hidden");
		String rowIdList = (String)session.getAttribute("rowEdgeIDList_hidden");
		
		session.removeAttribute("colEdgeIDList_hidden");
		session.removeAttribute("rowEdgeIDList_hidden");
		session.removeAttribute("pageEdgeIDValueList_hidden");

		int colSize = StringUtil.splitString(colIdList,",").size();
		int rowSize = StringUtil.splitString(rowIdList,",").size();

		int i = 0;
		for ( i = 0; i < colSize; i++ ) {
			session.removeAttribute("viewCol" + i + "KeyList_hidden");
		}
		for ( i = 0; i < rowSize; i++ ) {
			session.removeAttribute("viewRow" + i + "KeyList_hidden");
		}
		session.removeAttribute("viewColIndexKey_hidden");
		session.removeAttribute("viewRowIndexKey_hidden");
	}


	/**
	 * セルの値リストをTreeMapのテーブル構造（二次元Ｍａｐ）に格納しなおして戻す。
	 * 行Index, 列Indexの順にソートされる。
	 * @param report レポートをあらわすオブジェクト
	 * @param cellDataList セルデータオブジェクトの配列
	 * @return TreeMapのテーブル構造
	 */
	public static TreeMap<Integer, TreeMap<Integer, CellData>> getCellDataTable(Report report, ArrayList<CellData> cellDataList) {

//		ArrayList colAxesList = report.getEdgeByType(Constants.Col).getAxisList();
//		ArrayList rowAxesList = report.getEdgeByType(Constants.Row).getAxisList();

		int colAxisMemberComboNum = report.getAxisMeberComboNum(Constants.Col);
		int rowAxisMemberComboNum = report.getAxisMeberComboNum(Constants.Row);

		TreeMap<Integer, TreeMap<Integer, CellData>> dataRowMap = new TreeMap<Integer, TreeMap<Integer, CellData>>();
		
		// 行のSpreadIndexの順に並べていく。
		// 行のSpreadIndexが同じ値を持つ要素集合に対し、列のSpreadIndex順にソートする
		// ※SpreadIndexは必ずしも通番にはならないことに注意。（親がdrillされずに非表示である列・行の分が無い）

		Iterator<CellData> it = cellDataList.iterator();
		while (it.hasNext()) {
			CellData cellData = it.next();
			
			if(dataRowMap.containsKey(cellData.getRowCoordinates().getIndex())) { // すでに行が登録済みの場合、行にセルを追加
				TreeMap<Integer, CellData> dataCellMap = dataRowMap.get(cellData.getRowCoordinates().getIndex());
				dataCellMap.put(cellData.getColCoordinates().getIndex(), cellData);
			} else {	// 行が未登録の場合、行を追加
				TreeMap<Integer, CellData> dataCellMap = new TreeMap<Integer, CellData>();
				dataCellMap.put(cellData.getColCoordinates().getIndex(), cellData);
				dataRowMap.put(cellData.getRowCoordinates().getIndex(), dataCellMap);
			}
		}

		return dataRowMap;
	}

}
