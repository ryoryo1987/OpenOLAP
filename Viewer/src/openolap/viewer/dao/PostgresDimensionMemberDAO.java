/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresDimensionMemberDAO.java
 *  説明：ディメンションメンバーオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.Dimension;
import openolap.viewer.DimensionMember;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.StringUtil;

/**
 *  クラス：PostgresDimensionMemberDAO<br>
 *  説明：ディメンションメンバーオブジェクトの永続化を管理するクラスです。
 */
public class PostgresDimensionMemberDAO extends PostgresAxisMemberDAO implements DimensionMemberDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	private Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresDimensionMemberDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 *  ディメンションメンバーオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresDimensionMemberDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * レポートが持つ全ディメンションおよびそのメンバ情報XMLを取得する。
	 * @param report レポートオブジェクト
	 * @return StringBufferオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public StringBuffer getDimensionMemberXML(Report report) throws SQLException, IOException {

		// レポートの全ディメンションおよびそのメンバ情報XML格納用
		StringBuffer membersInfo = new StringBuffer(1024);

		ArrayList<Axis> axisList = report.getAxisOrderByID();
		Iterator<Axis> axisIt = axisList.iterator();

		while (axisIt.hasNext()) {
			Axis axis = axisIt.next();
			membersInfo.append(getDimensionMemberXML(report, axis, true)); // 軸のメンバ情報を出力

		}

		return membersInfo;
	}


	/**
	 * 指定されたディメンションおよび、そのメンバ情報XMLを取得する。
	 * @param report レポートオブジェクト
	 * @param axis 取得対象とするディメンションの軸オブジェクト
	 * @param selectFLG 軸のメンバーが絞り込まれているかどうかをあらわすフラグ
	 * @return StringBufferオブジェクト（指定された軸および、メンバ情報XML）
	 * @exception SQLException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public StringBuffer getDimensionMemberXML(Report report, Axis axis, boolean selectFLG) throws SQLException, IOException {

		// 軸とそのメンバー情報（XML）文字列格納用
		StringBuffer membersInfo = new StringBuffer(512);

		if (axis instanceof Dimension) {
			Dimension dim = (Dimension) axis;
			membersInfo.append("<Members name=\"" + dim.getName() + "\" id=\"" + dim.getId() +  "\" dimensionSeq=\""+ dim.getDimensionSeq() + "\">");

			// セレクタによる絞込み、ドリル設定を反映
			HashMap<String, String> memKeyDrill = null;
			String  selectedKeyString = null;
			if (selectFLG) {
				if (dim.getSelectedMemberDrillStat().size() > 0) { // ドリル情報が存在するならば、取得
					memKeyDrill = dim.getSelectedMemberDrillStat();
				}

				// ディメンションメンバリストをSQLで取得する際のセレクタによる絞込み条件文を取得
				if(axis.isUsedSelecter()) {
					Iterator<String> it = memKeyDrill.keySet().iterator();
					int i = 0;
					selectedKeyString = "',";
					while (it.hasNext()) {
						String key = it.next();
						if(i > 0) {
							selectedKeyString += ",";
						}
						selectedKeyString += key;
						i++;
					}
					selectedKeyString += ",'";
				}
			}

			Statement stmt = null;
			ResultSet rs   = null;
			try {
				stmt = conn.createStatement();
				String SQL = this.makeSQL(dim, selectedKeyString);
				if(log.isInfoEnabled()) {
					log.info("SQL(select axis member)：\n" + SQL);
				}
				rs   = stmt.executeQuery(SQL);

				membersInfo.append(getDimensionMemberXML(rs, memKeyDrill));

			} catch (SQLException e) {
				throw e;
			} catch (IOException e) {
				throw e;
			} finally {
				try {
					if (rs != null){
						rs.close();
					}
				} catch (SQLException e) {
					throw e;
				} finally {
					try {
						if (stmt != null){
							stmt.close();
						}
					} catch (SQLException e) {
						throw e;
					}
				}
			}
			membersInfo.append("</Members>");
		}
		
		return membersInfo;
	}

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
	public ArrayList<AxisMember> selectDimensionMembers(Dimension dim, String shortNameCondition, String longNameCondition, String levelCondition, String selectedKeyString) throws SQLException {
		ArrayList<AxisMember> dimensionMemberList = new ArrayList<AxisMember>();

		DimensionMember dimensionMember = null;
		
		Statement stmt = null;
		ResultSet rs   = null;
		try {

			String SQL = this.makeSQL(dim,selectedKeyString,shortNameCondition,longNameCondition,levelCondition);
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axis members)：\n" + SQL);
			}
			rs   = stmt.executeQuery(SQL);
			int i = 0;
			while (rs.next()) {

				boolean leafFLG = false;
				if ( rs.getString("leaf_flg") != null ) {
					if ( rs.getString("leaf_flg").equals("1") ) {
						leafFLG = true;
					} else {
						leafFLG = false;
					}
				} else {
					leafFLG = false;
				}

				dimensionMember = new DimensionMember( Integer.toString(i),				// id
														Integer.toString(rs.getInt("key")),	// uniqueName
														rs.getString("code"),				// code
														rs.getString("short_name"),			// short_name
														rs.getString("long_name"),			// long_name
														rs.getString("indented_short_name"),// indented_short_name
														rs.getString("indented_long_name"), // indented_long_name
														rs.getInt("level"),					// level
														leafFLG								// isLeaf
														);	

				dimensionMemberList.add(dimensionMember);
				i++;
			}

		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (rs != null){
					rs.close();
				}
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (stmt != null){
						stmt.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}
		
		return dimensionMemberList;
	}


	/**
	 * 指定されたディメンションのメンバーオブジェクトリストの先頭のメンバーオブジェクトを求める。
	 * @param dim ディメンションオブジェクト
	 * @return ディメンションメンバーオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public DimensionMember getFirstMember(Dimension dim) throws SQLException {

		DimensionMember dimensionMember = null;
		
		Statement stmt = null;
		ResultSet rs   = null;
		try {
			String SQL = this.makeSQL(dim,null) + " offset 0 limit 1 ";
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axis members)：\n" + SQL);
			}
			rs   = stmt.executeQuery(SQL);
			int i = 0;
			while (rs.next()) {

				boolean leafFLG = false;
				if ( rs.getString("leaf_flg") != null ) {
					if ( rs.getString("leaf_flg").equals("1") ) {
						leafFLG = true;
					} else {
						leafFLG = false;
					}
				} else {
					leafFLG = false;
				}

				dimensionMember = new DimensionMember( Integer.toString(i),				// id
														Integer.toString(rs.getInt("key")),	// uniqueName
														rs.getString("code"),				// code
														rs.getString("short_name"),			// short_name
														rs.getString("long_name"),			// long_name
														rs.getString("indented_short_name"),// indented_short_name
														rs.getString("indented_long_name"), // indented_long_name
														rs.getInt("level"),					// level
														leafFLG								// isLeaf
														);	

				i++;
			}
			if (i != 1) {	// 取得結果が0件以外の場合、エラー
				throw new IllegalStateException();
			}

		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (rs != null){
					rs.close();
				}
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (stmt != null){
						stmt.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}

		return dimensionMember;

	}



	/**
	 * ディメンションオブジェクトのメンバー名表示タイプを、XMLのタグ名に変換。
	 * @param modelString メンバー名表示タイプをあらわす文字列
	 * @return XMLのタグ名
	 */
	public String transferMemberDisplayTypeFromModelToXML(String modelString){
		if (Dimension.DISP_SHORT_NAME.equals(modelString)){
			return "Caption";
		} else if (Dimension.DISP_LONG_NAME.equals(modelString)) {
			return "Caption2";
		} else {
			throw new IllegalArgumentException();
		}
	}

	/**
	 * ディメンションメンバー情報をデータソースの情報をもとに生成し、ディメンションオブジェクトの"selectedMemberDrillStat"に設定する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void applyAxis(Report report, Axis axis, CommonSettings commonSettings) throws SQLException {

		String SQL = null;
		ResultSet rs = null;
		Statement stmt = null;
		try {
			SQL = DAOFactory.getDAOFactory().getAxisMemberDAO(null,axis).selectSaveDataSQL(report, axis);
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select dimension members)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			Dimension dim = (Dimension) axis;


// ディメンションはディメンションメンバオブジェクトを保持しないため(Sessionに保持するオブジェクト数の節約のため)コメント化
//
//
//			String selectedKeyString = "',";
//			ArrayList drilledFLGList = new ArrayList();
			HashMap<String, String> selectedMemKeyDrillStat = new HashMap<String, String>();
//			int i = 0;
			while ( rs.next() ) {
//				if(i>0) {
//					selectedKeyString += ",";
//				}
//				selectedKeyString += rs.getString("member_key");
//				drilledFLGList.add(rs.getString("drilledFLG"));
				selectedMemKeyDrillStat.put(rs.getString("member_key"),rs.getString("drilledFLG"));
//				i++;			
			}
//			selectedKeyString += ",'";

			// ディメンションメンバを取得
//			ArrayList dimensionMemList = selectDimensionMembers(dim,				// ディメンション
//																null,				// 検索条件(short_name)
//																null,				// 検索条件(long_name)
//																null,				// 検索条件(level)
//																selectedKeyString);	// 検索条件(検索対象メンバのキーリスト)


			// ドリル情報を補正
//			Iterator it = dimensionMemList.iterator();
//			int j = 0;
//			while (it.hasNext()) {
//				DimensionMember dimensionMember = (DimensionMember) it.next();
//				dimensionMember.setDrilled(CommonUtils.FLGTobool((String)drilledFLGList.get(j)));
//				j++;
//			}

			// ディメンションメンバをディメンションに登録
			if(selectedMemKeyDrillStat.size()>0){
				dim.setSelectedMemberDrillStat(selectedMemKeyDrillStat);
			}


		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (rs != null){
					rs.close();
				}
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (stmt != null){
						stmt.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}

	}

	/**
	 * 与えられた軸のディメンションメンバーを永続化する。
	 * @param report レポートオブジェクト
	 * @param reportID レポートID
	 *                ※このパラメータがNULLの場合、Reportオブジェクトが持つレポートIDで軸メンバー情報を保存する。
	 *                  NULLではない場合は、reportIDパラメータの値で軸メンバー情報を保存する。
	 * @param axis 軸オブジェクト
	 * @param conn Connecionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException {

		// レポートIDを設定
		String reportIDValue = null;
		if (reportID == null) {
			reportIDValue = report.getReportID();
		} else {
			reportIDValue = reportID;
		}

		Dimension dim = null;
		if (axis instanceof Dimension) {
			dim = (Dimension) axis;
		} else {
			throw new IllegalArgumentException();
		}

		// ディメンションに対しセレクタで絞込みが行われた場合、選択されたメンバ情報のみを保持するため、
		// delete、insertを行う

		// delete
		this.deleteAxisMember(reportIDValue, axis.getId(), conn);

		HashMap<String, String> selectedMemberDrillStat = dim.getSelectedMemberDrillStat();
			if ( selectedMemberDrillStat.size() == 0 ) {	// 検索結果が0件
				return;
			}
		Iterator<String> keyIt = selectedMemberDrillStat.keySet().iterator();

		// insert
		String SQL = "";
		Statement stmt = conn.createStatement();
		try {
			while (keyIt.hasNext()) {
				String uName = keyIt.next();
				
				SQL = "";
				SQL += "INSERT INTO ";
				SQL += "    oo_v_axis_member ";
				SQL += "       (report_id, axis_id, dimension_seq, member_key, selectedflg, drilledflg, measure_member_type_id) ";
				SQL += "values ( ";
				SQL +=                reportIDValue + ", ";					// report_id
				SQL +=                axis.getId() + ", ";					// axis_id
				SQL +=                dim.getDimensionSeq() + ", ";			// dimension_seq
				SQL +=                uName + ", ";							// member_key
				SQL +=                "'1', ";								// selectedFLG セレクタで選択されたメンバのみをHashMapに持つため、常に1(true)
				SQL +=          "'" + (String)selectedMemberDrillStat.get(uName)+ "', ";	// drilledFLG
				SQL +=                "null ";								// measure_member_type_id メジャー用の設定のため、null。
				SQL +=         ")";

				if(log.isInfoEnabled()) {
					log.info("SQL(save dimension member )：\n" + SQL);
				}
				int insertCount = stmt.executeUpdate(SQL);
				if (insertCount != 1) {
					throw new IllegalStateException();
				}
			}
		} catch (IllegalStateException e) {
			throw e;	
		} catch (SQLException e) {
			throw e;
		} finally {
			if (stmt != null) {
				stmt.close();
			}
		}
	}

	/**
	 * 与えられたディメンションが持つ総メンバー数を求める。
	 * @param dim ディメンションオブジェクト
	 * @return メンバー数
	 * @exception SQLException 処理中に例外が発生した
	 */
	public int getDimensionMemberNumber(Dimension dim) throws SQLException {
		
		DimensionDAO dimensionDAO = DAOFactory.getDAOFactory().getDimensionDAO(null);

		String SQL = null;
		SQL =   "";
		SQL +=	"SELECT ";
		SQL +=	"    count(*) as dimNumber ";
		SQL +=	"FROM ";
		SQL +=	"    oo_dim_tree('" + dimensionDAO.getDimensionTableName(dim.getDimensionSeq(),dim.getPartSeq()) + "',null,null) ";
		SQL +=  "WHERE leaf_flg != '9' ";	// 内部処理(ロールアップ)でのみ使用するメンバに「9」が振られている		

		Statement stmt = null;
		ResultSet rs = null;

		int dimNumber = 0;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(count dimension members )：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);
			while ( rs.next() ) {
				dimNumber = rs.getInt("dimNumber");	
			}

		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (rs != null){
					rs.close();
				}
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (stmt != null){
						stmt.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}

		return dimNumber;
	}

	// ********** private メソッド **********

	/**
	 * 次元メンバ取得SQL（検索条件つき）を返す。
	 * @param dim ディメンションオブジェクト
	 * @param selectedKeyString 取得対象とするメンバーキーのリストをあらわす文字列
	 * @return SQLあらわす文字列
	 */
	private String makeSQL(Dimension dim, String selectedKeyString) {

		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		DimensionDAO dimensionDAO = daoFactory.getDimensionDAO(null);

		String SQL = null;
		SQL =   "";
		SQL +=	"SELECT ";
		SQL +=	"    key as key, ";
		SQL +=	"    level, ";
		SQL +=	"    leaf_flg, ";
		SQL +=	"    code, ";
		SQL +=	"    short_name, ";
		SQL +=	"    long_name, ";
		SQL +=	"    lpad('',level,'　') || short_name as indented_short_name, ";
		SQL +=	"    lpad('',level,'　') || long_name as indented_long_name ";
		SQL +=	"FROM ";
		SQL +=	"    oo_dim_tree('" + dimensionDAO.getDimensionTableName(dim.getDimensionSeq(),dim.getPartSeq()) + "',null," + selectedKeyString +") ";
		SQL +=  "WHERE leaf_flg != '9' ";	// 内部処理(ロールアップ)でのみ使用するメンバに「9」が振られている

		return SQL;
	}


	/**
	 * 次元メンバ取得SQL（検索条件つき）を返す。
	 * @param dim ディメンションオブジェクト
	 * @param selectedKeyString 取得対象とするメンバーキーのリストをあらわす文字列
	 * @param shortNameCondition ディメンションメンバのshort_name
	 * @param longNameCondition ディメンションメンバのlong_name
	 * @param level ディメンションのレベル
	 * @return SQLあらわす文字列
	 */
	private String makeSQL(Dimension dim, String selectedKeyString, String shortNameCondition, String longNameCondition, String levelCondition) {
		String SQL = makeSQL(dim,selectedKeyString);
		if( (shortNameCondition != null) && (!shortNameCondition.equals("")) ) {
			SQL += "    and short_name like '" + StringUtil.changeKomeToPercent(shortNameCondition) + "'";
		}
		if( (longNameCondition != null) && (!longNameCondition.equals("")) ) {
			SQL += "    and long_name like '" + StringUtil.changeKomeToPercent(longNameCondition) + "'";
		}
		if( (levelCondition != null) && (!levelCondition.equals("")) ) {
			SQL += "    and level like '" + StringUtil.changeKomeToPercent(levelCondition) + "'";
		}

		return SQL;
	}

	/**
	 * ディメンションメンバーノード情報（XML）を取得する。
	 * @param rs ディメンションメンバーの検索結果
	 * @param memKeyDrill ドリル情報
	 * @return StringBufferオブジェクト
	 */
	private StringBuffer getDimensionMemberXML(ResultSet rs, HashMap<String, String> memKeyDrill) 
											 throws SQLException, IOException {

		StringBuffer dimMemberNodeInfo = new StringBuffer(512);

		int    beforeLevel     = -1;       	// 前のレコード
		String isDrilledString  = "false";  	// 今のレコードのDrillの値

		int currentLevel = -1;  // 今のレコードのレベル
		int j = 0;              // whileループのカウンタ
		int k = 0;              // カウンタ

//System.out.println("memKeyDrill:" + memKeyDrill);

		while (rs.next()) {

			currentLevel = rs.getInt("level");

			// ドリルフラグの設定
			if ( memKeyDrill == null ) {
				// 初期表示の場合（セッションに未登録）、デフォルトの展開状態を適用
				if ( rs.getString("leaf_flg") != null ) {
					if ( ( currentLevel == 1 ) && ( rs.getString("leaf_flg").equals("0") ) ) {
						isDrilledString = "true";
					} else {
						isDrilledString = "false";
					}
				} else {
					isDrilledString = "false";
				}
			} else {
				// DBに保存されたディメンションメンバの展開状態を適用
				String tmpMemKey = Integer.toString(rs.getInt("key"));
				String drillStat = (String)memKeyDrill.get(tmpMemKey);

// System.out.println("tmpMemKey,drillStat" + tmpMemKey + "," + drillStat);

				if ( drillStat == null ) {				// レポート保存時には存在しなかったメンバ
					isDrilledString = "false";					
				} else if ( drillStat.equals("1") ) {
					isDrilledString = "true";
				} else {
					isDrilledString = "false";
				}

			}

			// 前のループの要素を閉じるタグを生成
			if ( j != 0 ) {
				if ( beforeLevel < currentLevel ) {			// 前の要素より深い
					// 閉じタグは生成しない
				} else if ( beforeLevel > currentLevel ) {	// 前の要素より浅い
					// 閉じタグを生成
					for ( k=0; k < (beforeLevel - currentLevel + 1); k++ ) {
						dimMemberNodeInfo.append("</Member>");
					}
				} else if ( beforeLevel == currentLevel ) {	// 前の要素と同じ
					// 閉じタグを生成
					dimMemberNodeInfo.append("</Member>");
				}
			}

			String leafString = "";
			if ( rs.getString("leaf_flg") != null ) {
				if ( rs.getString("leaf_flg").equals("1") ) {
					leafString = "true";
				} else {
					leafString = "false";
				}
			} else {
				leafString = "false";
			}

			dimMemberNodeInfo.append( "<Member id=\"" + j + "\">" );
			dimMemberNodeInfo.append( "    <UName>" + rs.getInt("key") + "</UName>" );
			dimMemberNodeInfo.append( "    <Code>" + rs.getString("code") + "</Code>");
			dimMemberNodeInfo.append( "    <Caption>" + rs.getString("short_name") + "</Caption>" );
			dimMemberNodeInfo.append( "    <Caption2>" + rs.getString("long_name") + "</Caption2>" );
			dimMemberNodeInfo.append( "    <LNum>" + rs.getInt("level") + "</LNum>" );
			dimMemberNodeInfo.append( "    <isDrilled>" + isDrilledString + "</isDrilled>" );
			dimMemberNodeInfo.append( "    <isLeaf>" + leafString + "</isLeaf>" );

			j++;
			beforeLevel = currentLevel;
		}

		// 最後のメンバの閉じタグを生成
		for ( k=0; k < beforeLevel; k++ ) {
			dimMemberNodeInfo.append("</Member>");
		}

		return dimMemberNodeInfo;

	}

}
