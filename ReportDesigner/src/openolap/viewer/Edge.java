/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Edge.java
 *  説明：エッジをあらわす抽象クラスです。
 *
 *  作成日: 2004/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;

import openolap.viewer.common.Constants;

/**
 *  クラス：Edge<br>
 *  説明：エッジをあらわす抽象クラスです。
 */
public abstract class Edge implements Serializable {

	// ********** インスタンス変数 **********	

	/** 軸オブジェクトのリスト */
	final private ArrayList<Axis> axisList;

	// ********** コンストラクタ **********

	/**
	 * エッジオブジェクトを生成します。
	 */
	public Edge(ArrayList<Axis> axisList){
		this.axisList = axisList;
	}

	/**
	 * エッジオブジェクトを生成します。
	 */
	public Edge(Axis axis) {
		this.axisList = new ArrayList<Axis>();
		this.axisList.add(axis);
	}


	// ********** abstract メソッド **********

	/**
	 * エッジの名称を求める。
	 * @return エッジの名称
	 */
	public abstract String getPosition();

	// ********** 静的メソッド **********

	/**
	 * エッジを求める。
	 * @param position 列、行、ページをあらわす名称（COL,ROW,PAGE）
	 * @param edgeList エッジリスト
	 * @return エッジ
	 */
	public static Edge getTheEdge(String position, ArrayList<Edge> edgeList) {
		if ((position == null) || (edgeList == null)) { throw new IllegalArgumentException();}
		if (edgeList.size() < 2) { throw new IllegalStateException();}

		if (position.equals(Constants.Col)) {
			return edgeList.get(0);
		} else if (position.equals(Constants.Row)) {
			return edgeList.get(1);
		} else if (position.equals(Constants.Page)) {
			return edgeList.get(2);
		} else {
			throw new IllegalStateException();
		}
	}


	// ********** メソッド **********

	/**
	 * 与えられた軸を持つ場合true、持たない場合falseを戻す。
	 * @param oAxis 軸をあらわすオブジェクト
	 * @return 軸を持つかどうか
	 */
	public boolean hasThisAxis(Axis oAxis){
		if (oAxis == null){ return false; }
		Iterator<Axis> it = this.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(oAxis.getId())) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 与えられた軸を持つ場合true、持たない場合falseを戻す。
	 * @param oAxis 軸ID
	 * @return 軸を持つかどうか
	 */
	public boolean hasThisAxis(String axisId) {
		if (axisList == null){ return false; }
		Iterator<Axis> it = this.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(axisId)) {
				return true;
			}
		}
		return false;
	}


	/**
	 * 与えられた軸のエッジ内における次段に配置された軸のメンバー数を求める。
	 * (セレクタで除外されているものは含まない)
	 * ディメンションの持つメンバーリストは一時的に使用される情報であることに注意。
	 * @param axis 軸をあらわすオブジェクト
	 * @return メンバー数
	 */
	public Integer getNextAxisMemberNums(Axis axis) {
		if (axis == null) { throw new IllegalArgumentException(); }
		if (this.hasThisAxis(axis) == false) { throw new IllegalArgumentException(); }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis tmpAxis = it.next();
			if (axis.getId().equals(tmpAxis.getId())) {
				if(i == (this.getAxisList().size()-1)) { // 最終段が指定された場合
					return null;
				} else {

					Axis nextAxis = it.next();
//System.out.println("nextAxis:" + nextAxis.getName());
					Integer nextAxisMemberNums = null;
					if (nextAxis.isUsedSelecter()) {// セレクタによる絞込み中
						Iterator<AxisMember> nextAxisMemIt = nextAxis.getAxisMemberList().iterator();
						int count = 0;
						while (nextAxisMemIt.hasNext()) {
							AxisMember axisMember = nextAxisMemIt.next();
							if (axisMember.isSelected()){
								count++;
							}
						}
						nextAxisMemberNums = new Integer(count);
					} else { // セレクタによる絞込み中ではない

						nextAxisMemberNums = new Integer( nextAxis.getAxisMemberList().size());
					}

					return nextAxisMemberNums;
				}
			}
			i++;
		}
		return null;
	}


	/**
	 * 与えられた軸のエッジ内における次段以降に配置された軸のメンバー数の積を求める。
	 * (セレクタで除外されているものは含まない)
	 * ディメンションの持つメンバーリストは一時的に使用される情報であることに注意。
	 * @param axis 軸をあらわすオブジェクト
	 * @return メンバー数
	 */
	public Integer getNextAxesMembersComboNums(Axis axis) {
		if (axis == null) { throw new IllegalArgumentException(); }
		if (this.hasThisAxis(axis) == false) { throw new IllegalArgumentException(); }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis tmpAxis = it.next();
			if (axis.getId().equals(tmpAxis.getId())) {
				if(i == (this.getAxisList().size()-1)) { // 最終段が指定された場合
					return null;
				} else {

//System.out.println("nextAxis:" + nextAxis.getName());
					int nextAxesComboNums = 1;
					while (it.hasNext()) {
						Axis nextAxis = (Axis)it.next();

						if (nextAxis.isUsedSelecter()) {// セレクタによる絞込み中
							Iterator<AxisMember> nextAxisMemIt = nextAxis.getAxisMemberList().iterator();
							int count = 0;
							while (nextAxisMemIt.hasNext()) {
								AxisMember axisMember = nextAxisMemIt.next();
								if (axisMember.isSelected()){
									count++;
								}
							}
							nextAxesComboNums = nextAxesComboNums * count;
						} else { // セレクタによる絞込み中ではない
	
							nextAxesComboNums = nextAxesComboNums * nextAxis.getAxisMemberList().size();
						}
					}

					return new Integer(nextAxesComboNums);
				}
			}
			i++;
		}
		return null;
	}

	/**
	 * エッジ内の与えられた軸より前に配置された軸のメンバー数の積を求める。
	 * (セレクタで除外されているものは含まない)
	 * ディメンションの持つメンバリストは一時的に使用される情報であることに注意。
	 * @param axis 軸をあらわすオブジェクト
	 * @return メンバー数
	 */
	public Integer getBeforeAxesMembersComboNums(Axis axis) {
		if (axis == null) { throw new IllegalArgumentException(); }
		if (this.hasThisAxis(axis) == false) { throw new IllegalArgumentException(); }
		Iterator<Axis> it = this.getAxisList().iterator();
		ArrayList<Axis> beforeAxisList = new ArrayList<Axis>();
		while (it.hasNext()) {
			Axis tmpAxis = it.next();
			if (axis.getId().equals(tmpAxis.getId())) {
				if (beforeAxisList.size() == 0) {// 0段目が指定された場合
					return null;
				} else {
					int beforeAxesComboNums = 1;

					Iterator<Axis> beforeAxisIt = beforeAxisList.iterator();
					while (beforeAxisIt.hasNext()) {
						Axis beforeAxis = beforeAxisIt.next();
						if(beforeAxis.isUsedSelecter()) { // セレクタによる絞込み中
							Iterator<AxisMember> beforeAxisMemIt = beforeAxis.getAxisMemberList().iterator();
							int count = 0;
							while (beforeAxisMemIt.hasNext()) {
								AxisMember axisMember = beforeAxisMemIt.next();
								if (axisMember.isSelected()) {
									count++;
								}
							}
							beforeAxesComboNums = beforeAxesComboNums * count;

						} else {// セレクタによる絞込み中ではない
							beforeAxesComboNums = beforeAxesComboNums * beforeAxis.getAxisMemberList().size();
						}
					}
					return new Integer(beforeAxesComboNums);
				}
			}
			beforeAxisList.add(tmpAxis);
		}
		return null;
	}


	/**
	 * 与えられた軸のエッジにおけるインデックスを求める。
	 * 与えられた軸がエッジにない場合は、-1を戻す。
	 * @param oAxis 軸をあらわすオブジェクト
	 * @return 軸のエッジにおけるインデックス
	 */
	public int getAxisIndexInEdge(Axis oAxis) {
		if (oAxis == null){ return -1; }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(oAxis.getId())) {
				return i;
			}
			i++;
		}
		return -1;
	}

	/**
	 * 与えられた軸のエッジにおけるインデックスを求める。
	 * 与えられた軸がエッジにない場合は、-1を戻す。
	 * @param axisId 軸ID
	 * @return 軸のエッジにおけるインデックス
	 */
	public int getAxisIndexInEdge(String axisId) {
		if (axisId == null) { return -1; }
		Iterator<Axis> it = this.getAxisList().iterator();
		int i = 0;
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis.getId().equals(axisId)) {
				return i;
			}
			i++;
		}
		return -1;
	}

	/**
	 * 時間軸を持つ場合true、持たない場合falseを戻す。
	 * @return 時間軸を持つか
	 */
	public boolean investigateTimeDimension() {
		Iterator<Axis> it = this.axisList.iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if(!axis.isMeasure()) {
				Dimension dim = (Dimension)axis;
				if(dim.isTimeDimension()){
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * メジャーを求める。
	 * メジャーを持たない場合は、nullを戻す。
	 * @return メジャーオブジェクト
	 */
	public Measure getMeasure() {
		Iterator<Axis> it = this.axisList.iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if(axis.isMeasure()) {
				return (Measure)axis;
			}
		}
		return null;
	}

	/**
	 * エッジに軸を追加する。
	 * @param axis 軸をあらわすオブジェクト
	 */
	public void addAxis(Axis axis) {
		if (axis == null){ throw new IllegalArgumentException(); }

		this.axisList.add(axis);
	}

	/**
	 * エッジの持つ軸をクリアする。
	 */
	public void clearAxis() {
		this.axisList.clear();
	}

	// ********** Getter メソッド **********

	/**
	 * エッジの持つ軸リストを求める。
	 * @return 軸オブジェクトのリスト
	 */
	public ArrayList<Axis> getAxisList() {
		return axisList;
	}

}
