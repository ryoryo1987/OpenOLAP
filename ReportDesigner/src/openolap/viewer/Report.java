/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Report.java
 *  説明：レポートをあらわすクラスです。
 *
 *  作成日: 2003/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

import openolap.viewer.common.Constants;
import openolap.viewer.common.Messages;
import openolap.viewer.controller.RequestHelper;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;
import openolap.viewer.dao.ReportDAO;

/**
 *  クラス：Report
 *  説明：レポートをあらわすクラスです。
 */
public class Report implements Serializable {

	// ********** 静的変数 **********

	/** 基本レポート ユーザＩＤ */
	static public String basicReportUserID = "0";

	/** 基本レポート 参照元レポートＩＤ */
	static public String basicReportReferenceReportID = null;

	/** 基本レポート レポートの種類 */
	static public String basicReportOwnerFLG = "1";

	/** 個人レポート レポートの種類 */
	static public String personalReportOwnerFLG = "2";

	/** 個人レポート 個人レポートの名称につける接尾辞 */
	static public String personalReportNameSuffix = "（個人レポート）";

	// ********** インスタンス変数 **********

	/** レポートID */
	final private String reportID;

	/** レポート名 */
	private String reportName = null;

	/** 親ID(レポートを格納するフォルダのID) */
	private String parentID;

	/** 個人レポートを作成したユーザのID */
	protected String userID = null;

	/** 個人レポートが参照している基本レポートのID */
	protected String referenceReportID = null;

	/** レポートの種類(基本レポート、個人レポートの各場合でとる値は、basicReportOwnerFLG,personalReportOwnerFLG参照。) */
	private String reportOwnerFLG = null;

	/** 画面タイプ（0:全画面表示（表）、1:全画面表示（グラフ）、2:縦分割（表、グラフ)） **/
	private String displayScreenType = "0";
	
	/** デフォルトで表示するチャートの名称 **/
	private String currentChart = "NA";

	/** キューブ */
	final private Cube cube;

	/** エッジをあらわすオブジェクトリスト */
	final private ArrayList<Edge> edgeList;

	/** ハイライト情報を格納するXML文字列 */
	private String highLightXML;

	/** 色設定のタイプ（1：塗りつぶし、2：ハイライト） */
	private String colorType = "1";

	/** 色をあらわすオブジェクトのリスト */
	final private ArrayList<Color> colorList;

	/** 時間次元を持つか */
	final private boolean hasTimeDim;

	/** 新規作成中で未保存のレポート(true)か、既存レポート(false)か */
	private boolean isNewReport = false;

	// ********** コンストラクタ **********

	/**
	 * レポートオブジェクトを生成します。
	 */
	public Report(String reportID, String reportName, String userID, String referenceReportID, String reportOwnerFLG, Cube cube, ArrayList<Edge> edgeList, ArrayList<Color> colorList, boolean hasTimeDim){
		this.reportID = reportID;
		this.reportName = reportName;
		this.parentID = null;
		this.userID = userID;
		this.referenceReportID = referenceReportID;
		this.reportOwnerFLG = reportOwnerFLG;
		this.cube = cube;
		this.edgeList = edgeList;
		this.highLightXML = null;
		this.colorList = colorList;
		this.hasTimeDim = hasTimeDim;
	}


	// ********** 静的メソッド **********

	/**
	 * 時間軸を持つ場合true、持たない場合falseを戻す。
	 * @param edgeList 軸リスト
	 */
	public static boolean investigateTimeDimension(ArrayList<Edge> edgeList) {
		Edge col = Edge.getTheEdge("COL",edgeList);
		Edge row = Edge.getTheEdge("ROW",edgeList);
		Edge page = Edge.getTheEdge("PAGE",edgeList);

		return (col.investigateTimeDimension() || row.investigateTimeDimension() || page.investigateTimeDimension());
	}

	/**
	 * 与えられたディメンションリスト、メジャーリストを配置したエッジをあらわすオブジェクトのリストを戻す。
	 * @param dimList ディメンションをあらわすオブジェクトのリスト
	 * @param measure メジャーをあらわすオブジェクト
	 * @return エッジをあらわすオブジェクトのリスト
	 */
	public static ArrayList<Edge> initializeEdge(ArrayList<Dimension> dimList, Measure measure) {
		if ( (dimList == null) || (measure == null) ) { throw new IllegalArgumentException(); }
		if (dimList.size() < 1) { throw new IllegalArgumentException(); }

		ArrayList<Axis> sourceAxisList = new ArrayList<Axis>();
		Iterator<Dimension> dimIt = dimList.iterator();
		while (dimIt.hasNext()) {
			sourceAxisList.add((Axis)dimIt.next());
		}
		sourceAxisList.add((Axis)measure);


		Col col = null;
		Row row = null;
		Page page = null;
		ArrayList<Axis> pageAxisList = new ArrayList<Axis>();


		col = new Col((Axis)sourceAxisList.get(0));
		row = new Row((Axis)sourceAxisList.get(1));

		if ( sourceAxisList.size()-2 > 0 ) { // ディメンションをふたつ以上持つ（ページエッジが軸を持つ）場合
			for(int i=0; i<(sourceAxisList.size()-2); i++){
				pageAxisList.add(sourceAxisList.get(i+2));
				page = new Page(pageAxisList);
			}
		} else {	// ページエッジに軸が存在しない場合、空のArrayListを持たせる
			page = new Page(new ArrayList<Axis>());
		}

		ArrayList<Edge> edgeList = new ArrayList<Edge>();
		edgeList.add(col);
		edgeList.add(row);
		edgeList.add(page);

		return edgeList;
	}

	public static String getInitialReportName() {
		return Messages.getString("Report.tempInitialReportName"); //$NON-NLS-1$
	}

	// ********** メソッド **********

	/**
	 * Reportオブジェクトの行、列エッジに配置されたディメンションに、軸メンバーオブジェクトをセットする
	 * @param helper RequestHelperをあらわすオブジェクトのリスト
	 * @param report レポートをあらわすオブジェクト
	 * @param conn コネクションをあらわすオブジェクト
	 */
	public void setSelectedCOLROWDimensionMembers(RequestHelper helper, Report report, Connection conn) throws SQLException {

		DimensionMemberDAO dimMemberDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);

		Iterator<Edge> it = report.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> it2 = edge.getAxisList().iterator();

			if (edge.getPosition().equals(Constants.Page)) {
				continue;
			}

			int i = 0;
			while (it2.hasNext()) {
				Axis axis = it2.next();
				Dimension dim = null;
				if(axis instanceof Dimension) {
					dim = (Dimension) axis;
				} else {
					i++;
					continue;
				}

				String selectedMemberList = "";
				if (edge.getPosition().equals(Constants.Col)) {
					selectedMemberList = "'," + helper.getRequest().getSession().getAttribute("viewCol" + i + "KeyList_hidden") + ",'";
				} else if (edge.getPosition().equals(Constants.Row)) {
					selectedMemberList = "'," + helper.getRequest().getSession().getAttribute("viewRow" + i + "KeyList_hidden") + ",'";
				}

				ArrayList<AxisMember> dimMemberList = dimMemberDAO.selectDimensionMembers(dim, null, null, null, selectedMemberList);
				dim.clearAxisMember();
				dim.addAllAxisMember(dimMemberList);

				i++;
			}
		}
	}


	/**
	 * レポートのディメンションオブジェクトが持つメンバーを削除する
	 */
	public void clearDimensionMembers() {

		Iterator<Edge> it = edgeList.iterator();
		while (it.hasNext()) {
			Edge edge =  it.next();
			Iterator<Axis> it2 = edge.getAxisList().iterator();
			while (it2.hasNext()) {
				Axis axis = it2.next();
				if(!axis.isMeasure()){
					axis.clearAxisMember();
				}
			}
		}
	}


	/**
	 * レポートの持つ総ディメンション数を求める。
	 * @return 総ディメンション数
	 */
	public int getTotalDimensionNumber(){

		Iterator<Edge> it = edgeList.iterator();
		int dimCounter = 0;
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> it2 = edge.getAxisList().iterator();
			while (it2.hasNext()) {
				Axis axis = it2.next();
				if(!axis.isMeasure()){
					dimCounter++;
				}
			}
		}

		return dimCounter;
	}

	/**
	 * レポートの持つ総メジャーメンバー数を求める。
	 * @return 総メジャーメンバー数
	 */
	public int getTotalMeasureMemberNumber(){
		ArrayList<AxisMember> measureMemberList = this.getMeasure().getAxisMemberList();
		return measureMemberList.size();
	}

	/**
	 * 与えられた名称のエッジオブジェクトを求める。
	 * @param edgeType エッジをあらわす名称（COL,ROW,PAGE）
	 * @return エッジオブジェクト
	 */
	public Edge getEdgeByType(String edgeType) {
		Iterator<Edge> it = edgeList.iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.getPosition().equals(edgeType)){
				return edge;
			}
		}
		return null;
	}

	/**
	 * メジャーオブジェクトを求める。
	 * @return メジャーオブジェクト
	 */
	public Measure getMeasure() {
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if(edge.getMeasure() != null) {
				return edge.getMeasure();
			}
		}
		throw new IllegalStateException();
	}

	/**
	 * 与えられたIDの軸オブジェクトを求める。
	 * 軸オブジェクトが存在しない場合はnullを戻す。
	 * @return 軸オブジェクト
	 */
	public Axis getAxisByID(String sourceID) {
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();

			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				if(axis.getId().equals(sourceID)) {
					return axis;
				}
			}
		}
		return null;
	}


	/**
	 * レポートが持つ全ての軸オブジェクトを指定されたエッジの順で取得する。
	 * 各エッジ内に複数の軸が存在する場合は、段Indexの順とする。
	 * @param firstEdgePosition  ORDER BY句で一番目に指定されるエッジタイプ(Constants.Col or Constants.Row or Constants.Page)
	 * @param secondEdgePosition ORDER BY句で二番目に指定されるエッジタイプ(Constants.Col or Constants.Row or Constants.Page)
	 * @param thirdEdgePosition  ORDER BY句で三番目に指定されるエッジタイプ(Constants.Col or Constants.Row or Constants.Page)
	 * @param includeMeasure   メジャーを含めるかどうか？
	 * @return 軸オブジェクトのリスト
	 */
	public ArrayList<Axis> getAxisOrderByEdgePosition(String firstEdgePosition, String secondEdgePosition, String thirdEdgePosition, boolean includeMeasure) {
		if((!Constants.Col.equals(firstEdgePosition)) && (!Constants.Col.equals(secondEdgePosition)) && (Constants.Col.equals(thirdEdgePosition)) ) {
			throw new IllegalArgumentException();
		}
		if((!Constants.Row.equals(firstEdgePosition)) && (!Constants.Row.equals(secondEdgePosition)) && (Constants.Row.equals(thirdEdgePosition)) ) {
			throw new IllegalArgumentException();
		}
		if((!Constants.Page.equals(firstEdgePosition)) && (!Constants.Page.equals(secondEdgePosition)) && (Constants.Page.equals(thirdEdgePosition)) ) {
			throw new IllegalArgumentException();
		}
		if((firstEdgePosition.equals(secondEdgePosition)) || (firstEdgePosition.equals(thirdEdgePosition)) || (secondEdgePosition.equals(thirdEdgePosition))) {
			throw new IllegalArgumentException();
		}

		ArrayList<Axis> axisList = new ArrayList<Axis>();

		// first
			Edge edge = this.getEdgeByType(firstEdgePosition);
			Iterator<Axis> it = edge.getAxisList().iterator();
			while (it.hasNext()) {
				Axis axis = it.next();
				if ((!includeMeasure) && axis instanceof Measure) {
					continue;
				} else {
					axisList.add(axis);
				}
			}

		// second
			edge = this.getEdgeByType(secondEdgePosition);
			it = edge.getAxisList().iterator();
			while (it.hasNext()) {
				Axis axis = (Axis) it.next();
				if ((!includeMeasure) && axis instanceof Measure) {
					continue;
				} else {
					axisList.add(axis);
				}
			}

		// third
			edge = this.getEdgeByType(thirdEdgePosition);
			it = edge.getAxisList().iterator();
			while (it.hasNext()) {
				Axis axis = (Axis) it.next();
				if ((!includeMeasure) && axis instanceof Measure) {
					continue;
				} else {
					axisList.add(axis);
				}
			}

		return axisList;
	}

	/**
	 * レポートが持つ全ての軸オブジェクトをAxisId の昇順で取得する。
	 * @return 軸オブジェクトのリスト
	 */
	public ArrayList<Axis> getAxisOrderByID() {
		ArrayList<Axis> axisList = new ArrayList<Axis>();

		TreeMap<Integer, Axis> axisIdObjMap = new TreeMap<Integer, Axis>();
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();

			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();
				axisIdObjMap.put(Integer.decode(axis.getId()), axis);
			}
		}

		Iterator<Integer> axisIt = axisIdObjMap.keySet().iterator();
		while (axisIt.hasNext()) {
			Integer axisID = axisIt.next();
			Axis axis = axisIdObjMap.get(axisID) ;
			axisList.add(axis);
		}

		return axisList;
	}

	/**
	 * 与えられた軸が配置されているエッジの名称を求める。
	 * 軸オブジェクトが存在しない場合はnullを戻す。
	 * @param oAxis 軸をあらわすオブジェクト
	 * @return エッジの名称
	 */
	public String getThisAxisPosition(Axis oAxis) {
		if (oAxis == null){ return null; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.hasThisAxis(oAxis)){
				return edge.getPosition();
			}
		}
		return null;
	}

	/**
	 * 与えられた軸が配置されているエッジの名称を求める。
	 * 軸オブジェクトが存在しない場合はnullを戻す。
	 * @param id 軸ID
	 * @return エッジの名称
	 */
	public String getThisAxisPosition(String id) {
		if (id == null){ return null; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.hasThisAxis(id)){
				return edge.getPosition();
			}
		}
		return null;
	}

	/**
	 * 与えられた軸IDの軸オブジェクトをエッジから削除する
	 * @param id 軸ID
	 */
	public void deleteAxis(String axisID) {

		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();

			int i = 0;
			while (axisIt.hasNext()) {
				Axis axis =  axisIt.next();
				if(axis.getId().equals(axisID)) {
					// エッジが持つ軸リストより、から与えられた軸を削除
					edge.getAxisList().remove(i);					
					break;
				}
				i++;
			}
		}
	}



	/**
	 * 与えられた軸が列エッジに配置されている場合はtrue、配置されていない場合はfalseを戻す。
	 * @param oAxis 軸オブジェクト
	 * @return 列エッジに配置されているか
	 */
	public boolean isInCol(Axis oAxis) {
		if (oAxis == null){ return false; }
		if (this.getThisAxisPosition(oAxis).equals(Constants.Col)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 与えられた軸が列エッジに配置されている場合はtrue、配置されていない場合はfalseを戻す。
	 * @param axisId 軸ID
	 * @return 列エッジに配置されているか
	 */
	public boolean isInCol(String axisId) {
		if (axisId == null){ return false; }
		if (this.getThisAxisPosition(axisId).equals(Constants.Col)) {
			return true;
		} else {
			return false;
		}
	}


	/**
	 * 与えられた軸が行エッジに配置されている場合はtrue、配置されていない場合はfalseを戻す。
	 * @param oAxis 軸オブジェクト
	 * @return 行エッジに配置されているか
	 */
	public boolean isInRow(Axis oAxis) {
		if (oAxis == null){ return false; }
		if (this.getThisAxisPosition(oAxis).equals(Constants.Row)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 与えられた軸が行エッジに配置されている場合はtrue、配置されていない場合はfalseを戻す。
	 * @param axisId 軸ID
	 * @return 行エッジに配置されているか
	 */
	public boolean isInRow(String axisId) {
		if (axisId == null){ return false; }
		if (this.getThisAxisPosition(axisId).equals(Constants.Row)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 与えられた軸がページエッジに配置されている場合はtrue、配置されていない場合はfalseを戻す。
	 * @param oAxis 軸オブジェクト
	 * @return ページエッジに配置されているか
	 */
	public boolean isInPage(Axis oAxis) {
		if (oAxis == null){ return false; }
		if (this.getThisAxisPosition(oAxis).equals(Constants.Page)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 与えられた軸がページエッジに配置されている場合はtrue、配置されていない場合はfalseを戻す。
	 * @param axisId 軸ID
	 * @return ページエッジに配置されているか
	 */
	public boolean isInPage(String axisId) {
		if (axisId == null){ return false; }
		if (this.getThisAxisPosition(axisId).equals(Constants.Page)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 与えられた軸が配置されているエッジ内での段インデックスを求める。
	 * インデックスは「0」startの値である。
	 * 引数としてnullが渡ってきた場合は「-1」を戻す。
	 * 与えられた軸が存在しない場合は「0」を戻す。
	 * @param oAxis 軸オブジェクト
	 * @return エッジ内での段インデックス
	 */
	public int getHieIndex(Axis oAxis) {
		if (oAxis == null){ return -1; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.getAxisIndexInEdge(oAxis) != -1) {
				return edge.getAxisIndexInEdge(oAxis);
			}
		}
		return 0;
	}

	/**
	 * 与えられた軸が配置されているエッジ内での段インデックスを求める。
	 * インデックスは「0」startの値である。
	 * 引数としてnullが渡ってきた場合は「-1」を戻す。
	 * 与えられた軸が存在しない場合は「-1」を戻す。
	 * @param axisID 軸ID
	 * @return エッジ内での段インデックス
	 */
	public int getHieIndex(String axisID) {
		if (axisID == null){ return -1; }
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();
			if (edge.getAxisIndexInEdge(axisID) != -1) {
				return edge.getAxisIndexInEdge(axisID);
			}
		}
		return -1;
	}

	/**
	 * 指定されたエッジに配置された軸メンバーの組み合わせ数を求める。
	 * @param edgeName 軸名称
	 * @return メンバーの組み合わせ数
	 */
	public int getAxisMeberComboNum(String edgeName) {
		if ( (!Constants.Col.equals(edgeName)) && (!Constants.Row.equals(edgeName)) && (!Constants.Page.equals(edgeName)) ) {
			throw new IllegalStateException();
		}

		int totalNumber = 1;
		ArrayList<Axis> edgeAxesList = this.getEdgeByType(Constants.Col).getAxisList();
		Iterator<Axis> iter = edgeAxesList.iterator();
		while (iter.hasNext()) {
			Axis axis = iter.next();
			totalNumber = totalNumber * (axis.getAxisMemberList().size());
		} 

		return totalNumber;
	}

	/**
	 * 色を表すオブジェクトをレポートに追加する。
	 * @param color 色をあらわすオブジェクト
	 */
	public void addColor(Color color) {
		if(color == null) { throw new IllegalArgumentException(); }
		this.colorList.add(color);
	}

	/**
	 * 色を表すオブジェクトのリストをレポートに追加する。
	 * @param color 色をあらわすオブジェクト
	 */
	public void addColor(ArrayList<Color> colorList) {
		if(colorList == null) { throw new IllegalArgumentException(); }

		Iterator<Color> it = colorList.iterator();
		while (it.hasNext()) {
			Color color = it.next();
			this.colorList.add(color);
		}
	}

	/**
	 * 色を表すオブジェクトのリストをクリアする。
	 */
	public void clearColorList() {
		this.colorList.clear();
		
	}

	/**
	 * ヘッダーの色を表すオブジェクトのリストを求める。
	 * @return color 色をあらわすオブジェクト
	 */
	public ArrayList<Color> getHeaderColorList() {
		ArrayList<Color> headerColorList = new ArrayList<Color>();
		Iterator<Color> it = this.colorList.iterator();
		while (it.hasNext()) {
			Color color = it.next();
			if(color.isHeader()){
				headerColorList.add(color);
			}
		}
		return headerColorList;
	}

	/**
	 * データテーブルの色を表すオブジェクトのリストを求める。
	 * @return color 色をあらわすオブジェクト
	 */
	public ArrayList<Color> getSpreadColorList() {
		ArrayList<Color> spreadColorList = new ArrayList<Color>();
		Iterator<Color> it = this.colorList.iterator();
		while (it.hasNext()) {
			Color color = it.next();
			if(!color.isHeader()){
				spreadColorList.add(color);
			}
		}
		return spreadColorList;
	}

	/**
	 * レポートを保存する。
	 * @param conn コネクションをあらわすオブジェクト
	 * @exception SQLException DBへのレポート保存処理で例外が発生した
	 */
	public void saveReport(Connection conn) throws SQLException {
		DAOFactory daoFactory = DAOFactory.getDAOFactory();

		ReportDAO reportDAO = daoFactory.getReportDAO(conn);
		reportDAO.saveReport(this, conn);
	}

	/**
	 * 新規個人レポートを保存する。
	 * @param conn コネクションをあらわすオブジェクト
	 * @exception SQLException DBへのレポート保存処理で例外が発生した
	 */
	public void saveNewPersonalReport(String newReportName, String userID, Connection conn) throws SQLException {
		DAOFactory daoFactory = DAOFactory.getDAOFactory();

		ReportDAO reportDAO = daoFactory.getReportDAO(conn);
		reportDAO.saveNewPersonalReport(this, newReportName, userID, conn);
	}



	/**
	 * このインスタンスの文字列表現を求める。
	 * @return Stringオブジェクト
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "Report.reportID:" + this.reportID + sep;
		stringInfo += "Report.reportName:" + this.reportName + sep;
		stringInfo += "Report.parentID:" + this.parentID + sep;
		stringInfo += "Report.userID:" + this.userID + sep;
		stringInfo += "Report.referenceReportID:" + this.referenceReportID + sep;
		stringInfo += "Report.reportOwnerFLG:" + this.reportOwnerFLG + sep;
		stringInfo += "Report.displayScreenType:" + this.displayScreenType + sep;
		stringInfo += "Report.currentChart:" + this.currentChart + sep;
		stringInfo += "Report.highLightXML:" + this.highLightXML + sep;
		stringInfo += "Report.colorType:" + this.colorType + sep;
		stringInfo += "Report.hasTimeDim:" + String.valueOf(this.hasTimeDim) + sep;
		stringInfo += "Report.isNewReport:" + String.valueOf(this.isNewReport) + sep;

		stringInfo += "--- cube info ---" + sep;
		stringInfo += this.cube.toString();

		stringInfo += "--- edge info ---" + sep;		
		Iterator<Edge> it = this.getEdgeList().iterator();
		while (it.hasNext()) {
			Edge edge = it.next();

			stringInfo += "edge position:" + edge.getPosition() + " -- start " + sep;

			Iterator<Axis> axisIt = edge.getAxisList().iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				stringInfo += "-- axis -- " + sep;
				stringInfo += axis.toString();
			}

			stringInfo += "edge position:" + edge.getPosition() + " -- end  " + sep;

		}		
		
//		stringInfo += "--- color info ---" + sep;

		return stringInfo;

	}

	// ********** Setter メソッド **********

	/**
	 * ユーザIDをセットする。
	 * @param ユーザID
	 */
	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * 参照元レポートIDをセットする。
	 * @param 参照元レポートID
	 */
	public void setReferenceReportID(String referenceReportID) {
		this.referenceReportID = referenceReportID;
	}

	/**
	 * レポートの種類をセットする。
	 * @param レポートの種類
	 */
	public void setScopeKindFLG(String reportOwnerFLG) {
		this.reportOwnerFLG = reportOwnerFLG;
	}

	/**
	 * レポート名をセットする。
	 * @param string レポート名
	 */
	public void setReportName(String string) {
		reportName = string;
	}

	/**
	 * レポートIDをセットする。
	 * @param string レポートID
	 */
	public void setParentID(String string) {
		parentID = string;
	}

	public void setHighLightXML(String string) {
		highLightXML = string;
	}


	public void setColorType(String string) {
		colorType = string;
	}

	/**
	 * 新規レポートフラグをセットする。
	 * @param string レポートID
	 */
	public void setNewReport(boolean b) {
		isNewReport = b;
	}

	/**
	 * 画面タイプをセットする。
	 * @param screenType 画面タイプ
	 */
	public void setDisplayScreenType(String screenType) {
		this.displayScreenType = screenType;
	}


	/**
	 * デフォルトチャートの名称をセットする。
	 * @param currentChart チャートの名称
	 */
	public void setCurrentChart(String currentChart) {
		this.currentChart = currentChart;
	}



	// ********** Getter メソッド **********

	/**
	 * レポート名を求める。
	 * @return レポート名
	 */
	public String getReportName() {
		return reportName;
	}

	/**
	 * レポートIDを求める。
	 * @return レポートID
	 */
	public String getReportID() {
		return reportID;
	}

	/**
	 * レポートの親ID（レポート格納するフォルダのID）を求める。
	 * @return レポートID
	 */
	public String getParentID() {
		return parentID;
	}

	public String getHighLightXML() {
		return highLightXML;
	}

	public String getColorType() {
		return colorType;
	}

	/**
	 * ユーザIDを求める。
	 * @return ユーザID
	 */
	public String getUserID() {
		return userID;
	}
	
	/**
	 * 参照元レポートIDを求める。
	 * @return 参照元レポートID
	 */
	public String getReferenceReportID() {
		return referenceReportID;
	}
	
	/**
	 * レポートの種類を求める。
	 * @return レポートの種類
	 *            基本レポート(=Report.basicReportOwnerFLG)
	 *            個人レポート(=Report.personalReportOwnerFLG)
	 */
	public String getReportOwnerFLG() {
		return reportOwnerFLG;
	}

	/**
	 * 画面タイプを求める。
	 * @return screenType 画面タイプ
	 */
	public String getDisplayScreenType() {
		return displayScreenType;
	}


	/**
	 * デフォルトチャートの名称を求める。
	 * @return currentChart チャートの名称
	 */
	public String getCurrentChart() {
		return currentChart;
	}

	/**
	 * キューブを求める。
	 * @return レポートID
	 */
	public Cube getCube() {
		return cube;
	}

	/**
	 * 軸オブジェクトのリストを求める。
	 * @return 軸オブジェクトのリスト
	 */
	public ArrayList<Edge> getEdgeList() {
		return edgeList;
	}

	/**
	 * 色オブジェクトのリストを求める。
	 * @return 色オブジェクトのリスト
	 */
	public ArrayList<Color> getColorList() {
		return colorList;
	}

	/**
	 * 時間軸を持てばtrue、持たなければfalseを戻す。
	 * @return 軸オブジェクトのリスト
	 */
	public boolean hasTimeDim() {
		return hasTimeDim;
	}

	/**
	 * 新規作成中で未保存のレポートであればtrue、既存レポートであればfalseを戻す。
	 * @return 新規レポートか
	 */
	public boolean isNewReport() {
		return isNewReport;
	}

}
