/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Axis.java
 *  説明：レポートのエッジに配置される軸をあらわすabstractクラスです。
 *
 *  作成日: 2003/12/28
 */
package openolap.viewer;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;


/**
 *  抽象クラス：Axis<br>
 *  説明：レポートのエッジに配置される軸をあらわす抽象クラスです。
 */
public abstract class Axis implements Serializable {

	// ********** インスタンス変数 **********

	/** 軸のID */
	final private String id;

	/** 軸の名称 */
	final private String name;

	/** 軸のコメント */
	final private String comment;

	/** 軸の持つ全レベル情報 */
	final private ArrayList<AxisLevel> axisLevelList;

	/** 軸のデフォルトメンバーのKey(uniqueName) */
	protected String defaultMemberKey = null;

	/** この軸がメジャーか(true:メジャー,false:次元) */
	final private boolean isMeasure;

	/** この軸がセレクタによるメンバの絞込みを行われているか？ */
	private boolean isUsedSelecter = false;

	/** この軸が持つ軸メンバーのリスト */
	protected ArrayList<AxisMember> axisMemberList = new ArrayList<AxisMember>();

	// ********** コンストラクタ **********

	/**
	 *  レポートのエッジに配置される軸をあらわすオブジェクトを生成します。
	 */
	public Axis(String id, String name, String comment, ArrayList<AxisLevel> axisLevelList, String defaultMemberKey, boolean isMeasure, boolean isUsedSelecter) {
		this.id = id;
		this.name = name;
		this.comment = comment;
		this.axisLevelList = axisLevelList;
		this.isMeasure = isMeasure;
		this.isUsedSelecter = isUsedSelecter;
	}



	// ********** メソッド **********

	/**
	 *  軸のレベルリストにレベル情報（AxisLevelオブジェクト）を登録する。
	 */
	public void addAxisLevelList(AxisLevel axisLevel) {
		this.axisLevelList.add(axisLevel);
	}

	/**
	 *  軸メンバーリストに軸メンバーを登録する。
	 * @param axisMem 軸メンバーをあらわすAxisMemberオブジェクト
	 */
	public void addAxisMember(AxisMember axisMem) {
		this.axisMemberList.add(axisMem);
	}

	/**
	 *  軸メンバーリストに軸メンバーの集合を登録する。
	 * @param axisMemberList 軸メンバーをあらわすAxisMemberオブジェクトの集合（ArrayList）
	 */	
	public void addAllAxisMember(ArrayList<AxisMember> axisMemberList) {
		this.axisMemberList.addAll(axisMemberList);
	}

	/**
	 *  軸メンバーリストをクリアする。
	 */
	public void clearAxisMember() {
		this.axisMemberList.clear();
	}

	/**
	 *  軸の持つ軸メンバーリストより、指定されたIDを持つ軸メンバーを求める。
	 * @param id 軸メンバーのID
	 * @return 軸メンバーが見つかればAxisMemberオブジェクト、見つからなければnull
	 */	
	public AxisMember getAxisMemberById(String id) {
		Iterator<AxisMember> it = this.axisMemberList.iterator();
		while (it.hasNext()) {
			AxisMember axisMember = it.next();
			if(axisMember.getId().equals(id)){
				return axisMember;
			}
		}
		return null;
	}

	/**
	 *  軸の持つ軸メンバーリストより、指定されたuniqueNameを持つ軸メンバーを求める。
	 * @param uName 軸メンバーのuniqueName
	 * @return 軸メンバーが見つかればAxisMemberオブジェクト、見つからなければnull
	 */	
	public AxisMember getAxisMemberByUniqueName(String uName) {
		Iterator<AxisMember> it = this.axisMemberList.iterator();

		while (it.hasNext()) {
			AxisMember axisMember = it.next();
			if(axisMember.getUniqueName().equals(uName)){
				return axisMember;
			}
		}
		return null;
	}


	/**
	 * 軸のデフォルトメンバーである軸メンバーを求める。<br>
	 * 軸のデフォルトメンバーが未定である場合は、軸の持つメンバーリストのうち、先頭の軸メンバーを戻す。<br>
	 * 軸がもつメンバリストにデフォルトメンバである軸メンバが含まれていない場合は、DBより情報を取得する。
	 * @param conn Connectionオブジェクト
	 * @return 軸メンバー名、connがnullの場合または軸が該当するメンバーをもたない場合、null
	 * @exception SQLException DBからの軸メンバ取得処理で例外が発生した
	 */
	public AxisMember getDefaultMember(Connection conn) throws SQLException {

		String defaultMemberKey = this.getDefaultMemberKey();		
		if (defaultMemberKey == null) { // デフォルトメンバーが未定

			if (this instanceof Dimension) {
				Dimension dim = (Dimension) this;
				DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
				DimensionMember firstMember = dimMemDAO.getFirstMember(dim);
				return firstMember;

			} else {
				Measure measure = (Measure) this;
				MeasureMember firstMember = (MeasureMember) measure.getAxisMemberList().get(0);
				return firstMember;
			}

		} else { // デフォルトメンバーが決定している

			AxisMember axisMember = this.getAxisMemberByUniqueName(defaultMemberKey);
			if ( axisMember == null ) {	// 軸がメンバを持っていない場合(次元の場合のみ)、DBから検索
				Dimension dim = null;
				if (this instanceof Dimension) {
					dim = (Dimension) this;
				} else {
					throw new IllegalStateException();
				}
				
				if (conn == null) {
					return null; 
				} else {
					DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
					
					ArrayList<AxisMember> dimMemberList = dimMemDAO.selectDimensionMembers(dim, null,null,null,"'," + defaultMemberKey + ",'");
					if (dimMemberList.size() > 1) {
						throw new IllegalStateException();
					}
					
					return (DimensionMember) dimMemberList.get(0);
				}
			} else {
				return axisMember;
			}
		}
	}

	/**
	 * 軸のデフォルトメンバーである軸メンバーの名称を求める。<br>
	 * メジャーの場合、名称はメジャー名となるが、ディメンションの場合はDimensionのインスタンス変数dispMemberNameTypeで<br>
	 * 設定された名称（ロングネームかショートネームのいづれか）となる。 
	 * 軸のデフォルトメンバーが未定である場合は、軸の持つメンバーリストのうち、先頭の軸メンバーの名称を戻す。<br>
	 * 軸がもつメンバリストにデフォルトメンバである軸メンバが含まれていない場合は、DBより情報を取得する。
	 * @param conn Connectionオブジェクト
	 * @return 軸メンバー名、connがnullの場合または軸が該当するメンバーをもたない場合、null
	 * @exception SQLException DBからの軸メンバ取得処理で例外が発生した
	 */
	public String getDefaultMemberName(Connection conn) throws SQLException {

		String defaultMemberKey = this.getDefaultMemberKey();		
		if (defaultMemberKey == null) { // デフォルトメンバーが未定

			if (this instanceof Dimension) {
				Dimension dim = (Dimension) this;
				DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
				DimensionMember firstMember = dimMemDAO.getFirstMember(dim);
				return firstMember.getSpecifiedDisplayName(dim);

			} else {
				Measure measure = (Measure) this;
				MeasureMember firstMember = (MeasureMember) measure.getAxisMemberList().get(0);
				return firstMember.getMeasureName();
			}

		} else { // デフォルトメンバーが決定している

			AxisMember axisMember = this.getAxisMemberByUniqueName(defaultMemberKey);
			if ( axisMember == null ) {	// 軸がメンバを持っていない場合(次元の場合のみ)、DBから検索
				Dimension dim = null;
				if (this instanceof Dimension) {
					dim = (Dimension) this;
				} else {
					throw new IllegalStateException();
				}
				
				if (conn == null) {
					return null; 
				} else {
					DimensionMemberDAO dimMemDAO = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn);
					
					ArrayList<AxisMember> dimMemberList = dimMemDAO.selectDimensionMembers(dim, null,null,null,"'," + defaultMemberKey + ",'");
					if (dimMemberList.size() > 1) {
						throw new IllegalStateException();
					}
					
					return ((DimensionMember) dimMemberList.get(0)).getSpecifiedDisplayName(dim);
				}
			} else {
				return axisMember.getSpecifiedDisplayName(this);
			}
		}
	}

	/**
	 * デフォルトメンバーが与えられたMapオブジェクトに含まれない場合は、デフォルトメンバー情報を初期化(null)する。
	 * @param memberNameDrillMap 新たに軸メンバとして選択されたメンバーの名称とドリル状態のMapオブジェクト
	 */
	public void modifyDefaultMember(HashMap<String, String> memberNameDrillMap) {
		if(!memberNameDrillMap.containsKey(this.getDefaultMemberKey())) {
			this.setDefaultMemberKey(null);
		}
	}


	/**
	 * このインスタンスの文字列表現を求める。
	 * @return Stringオブジェクト
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "Axis.id:" + this.id + sep;
		stringInfo += "Axis.name:" + this.name + sep;
		stringInfo += "Axis.comment:" + this.comment + sep;
		stringInfo += "Axis.defaultMemberKey:" + this.defaultMemberKey + sep;

		stringInfo += "Axis.isMeasure:" + String.valueOf(this.isMeasure) + sep;
		stringInfo += "Axis.isUsedSelecter:" + String.valueOf(this.isUsedSelecter) + sep;

		//axisLevelList		// 軸の持つ全レベル情報 
		//axisMemberList	// この軸が持つ軸メンバーのリスト

		return stringInfo;

	}


	// ********** Setter メソッド **********

	/**
	 * デフォルトメンバーのキーをセットする。
	 * @param memberKey 軸メンバーのキー(uniqueName)
	 */
	public void setDefaultMemberKey(String memberKey) {
		this.defaultMemberKey = memberKey;
	}
	/**
	 * 軸メンバーリストをセットする。
	 * @param axisMemberList 軸メンバーの集合
	 */
	public void setAxisMemberList(ArrayList<AxisMember> axisMemberList) {
		this.axisMemberList = axisMemberList;
	}
	/**
	 * 軸のセレクタが使用されてメンバが絞り込まれているかどうかをセットする。
	 * @param b 軸のメンバがセレクタにより絞り込まれているか
	 */
	public void setUsedSelecter(boolean b) {
		isUsedSelecter = b;
	}

	// ********** Getter メソッド **********

	/**
	 * 軸IDを求める。
	 * @return 軸ID
	 */
	public String getId() {
		return id;
	}
	/**
	 * 軸名称を求める。
	 * @return 軸名称
	 */
	public String getName() {
		return name;
	}
	/**
	 * 軸のコメントを求める。
	 * @return 軸コメント
	 */
	public String getComment() {
		return comment;
	}
	/**
	 * 軸のレベル情報リストを求める。
	 * @return 軸のレベル情報リスト
	 */	
	public ArrayList<AxisLevel> getAxisLevelList() {
		return axisLevelList;
	}
	/**
	 * 軸のデフォルトメンバーである軸メンバーのKey(uniqueName)を求める。
	 * @return 軸メンバーのKey(uniqueName)
	 */
	public String getDefaultMemberKey() {
		return defaultMemberKey;
	}
	/**
	 * 軸がメジャーかどうかを求める。
	 * @return 軸がメジャーである場合true、メジャーではない場合（＝ディメンション）false
	 */
	public boolean isMeasure() {
		return isMeasure;
	}
	/**
	 * 軸のセレクタが使用されてメンバが絞り込まれているかどうかを求める。
	 * @return セレクタによりメンバが絞り込まれている場合true、絞り込まれていない場合false
	 */
	public boolean isUsedSelecter() {
		return isUsedSelecter;
	}
	/**
	 * 軸メンバーリストを求める。<br>
	 * ディメンションの場合は、DBなどから求められた軸メンバーリストの一時保存用として使用され、<br>常に全ての軸メンバーを保持するわけではないことに注意する。
	 * @return 軸メンバーのリスト
	 */
	public ArrayList<AxisMember> getAxisMemberList() {
		return axisMemberList;
	}

}
