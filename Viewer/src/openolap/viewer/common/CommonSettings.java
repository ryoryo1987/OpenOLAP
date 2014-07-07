/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.common
 *  ファイル：CommonSettings.java
 *  説明：アプリケーションの共通設定をあらわすクラスです。
 *
 *  作成日: 2004/01/12
 */
package openolap.viewer.common;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;

import openolap.viewer.MeasureMemberType;

/**
 *  クラス：CommonSettings<br>
 *  説明：アプリケーションの共通設定をあらわすクラスです。
 */
public class CommonSettings implements Serializable {

	// ********** インスタンス変数 **********

	/** 自分自身のオブジェクト */
	static final CommonSettings commonSettings = new CommonSettings(CommonUtils.FLGTobool(Messages.getString("InitializeStatus.valueXmlContainsAxesInfoFLG")));

	/** メジャーメンバータイプオブジェクトのリスト */
	final private ArrayList<MeasureMemberType> measureMemberTypeList = new ArrayList<MeasureMemberType>();

	/** 値XMLに軸情報（軸IDおよびメンバーキーの組み合わせ）を含めるか */
	final private boolean valueXmlContainsAxesInfo;
	
	// ********** コンストラクタ **********

	/**
	 * アプリケーションの共通設定をあらわすオブジェクトを生成します。
	 * オブジェクトは一つのみ生成されることが必要。
	 */
	private CommonSettings (boolean valueXmlContainsAxesInfo) {
		this.valueXmlContainsAxesInfo = valueXmlContainsAxesInfo;
	}

	// ********** staticメソッド **********

	/**
	 * アプリケーションの共通設定をあらわすオブジェクトを取得します。
	 * @return このクラスのオブジェクト
	 */
	public static CommonSettings getCommonSettings() {
		return commonSettings;
	}

	// ********** メソッド **********

	/**
	 * メジャーメンバータイプオブジェクトをセットする。
	 * @param measureMemberType メジャーメンバータイプオブジェクト
	 */
	public void addMeasureMemberTypeList(MeasureMemberType measureMemberType) {
		this.measureMemberTypeList.add(measureMemberType);
	}

	/**
	 * メジャーメンバータイプオブジェクトのリストをセットする。
	 * @param measureMemberTypeList メジャーメンバータイプオブジェクトのリスト
	 */
	public void addMeasureMemberTypeList(ArrayList<MeasureMemberType> measureMemberTypeList) {
		if(measureMemberTypeList == null) { throw new IllegalArgumentException(); }

		Iterator it = measureMemberTypeList.iterator();
		while (it.hasNext()) {
			MeasureMemberType measureMemberType = null;
			Object obj = (Object) it.next();
			if (obj instanceof MeasureMemberType) {
				measureMemberType = (MeasureMemberType) obj;
			} else {
				throw new IllegalArgumentException();
			}
			this.measureMemberTypeList.add(measureMemberType);
		}
	}

	/**
	 * 与えたメジャーメンバタイプIDよりメジャーメンバタイプオブジェクトを求める。
	 * @param typeId メジャーメンバタイプID
	 * @return メジャーメンバタイプオブジェクト
	 */
	public MeasureMemberType getMeasureMemberTypeByID(String typeId) {
		Iterator<MeasureMemberType> it = this.measureMemberTypeList.iterator();
		while (it.hasNext()){
			MeasureMemberType measureMemberType = it.next();
			if(typeId.equals(measureMemberType.getId())) {
				return measureMemberType;
			}
		}
		return null;
	}

	/**
	 * メジャーメンバタイプオブジェクトリストの先頭のオブジェクトを求める。
	 * @return メジャーメンバタイプオブジェクト
	 */
	public MeasureMemberType getFirstMeasureMemberType() {
		return (MeasureMemberType)measureMemberTypeList.get(0);
	}

	// ********** Getter メソッド **********

	/**
	 * メジャーメンバタイプオブジェクトリストを求める。
	 * @return メジャーメンバタイプオブジェクトのリスト
	 */
	public ArrayList<MeasureMemberType> getMeasureMemberTypeList() {
		return measureMemberTypeList;
	}

	/**
	 * 値XMLに軸情報を含める場合はtrue、含めない場合はfalseを戻す。
	 * （軸情報：軸IDおよびメンバーキーの組み合わせ）
	 * @return 値XMLに軸情報）を含めるか
	 */
	public boolean getValueXmlContainsAxesInfo() {
		return valueXmlContainsAxesInfo;
	}


}
