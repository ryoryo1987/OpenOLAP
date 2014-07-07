/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：EdgeCoordinates.java
 *  説明：列または行ヘッダの座標を表すオブジェクトです。
 *
 *  作成日: 2004/01/19
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;

import openolap.viewer.common.StringUtil;

/**
 *  クラス：EdgeCoordinates<br>
 *  説明：列または行ヘッダの座標を表すオブジェクトです。
 */
public class EdgeCoordinates implements Serializable {

	// ********** インスタンス変数 **********

	/** 列または行のインデックス(列または行に対して一意になる0startの通番) */
	final private Integer index;

	/** 列または行の各段の軸IDをKEYとし、軸メンバーのキーをVALUEに持つMapオブジェクト */
	final private LinkedHashMap<Integer, String> axisIdMemKeyMap;


	// ********** コンストラクタ **********

	/**
	 * 列または行ヘッダの座標を表すオブジェクトを生成します。
	 */
	public EdgeCoordinates(Integer index, LinkedHashMap<Integer, String> axisIdMemKeyMap) {
		this.index = index;
		this.axisIdMemKeyMap = axisIdMemKeyMap;
	}

	// ********** Static メソッド **********

	/**
	 * 列または行ヘッダの座標を表すオブジェクトのリストを求める
	 * @param indexKey 列または行で一意に定まるSpreadIndexと、各段のメンバーキーの組み合わせのリスト<br>
	 *        書式：<index>:<1段目のkey>;<2段目のkey>;<3段目のkey>,<index>:<1段目のkey>;<2段目のkey>;<3段目のkey>,･･･<br>
	 *        ※行または列が３段未満の場合該当するkeyの箇所は空文字
	 * @param axisIdList 行または列に配置された軸IDの配列（並び順はエッジ内の配置順）
	 * @return 列または行ヘッダの座標を表すオブジェクトのリスト
	 */
	public static ArrayList<EdgeCoordinates> createCoordinates(String indexKey, String[] axisIdList) {

		ArrayList<EdgeCoordinates> axisCoordinatesList = new ArrayList<EdgeCoordinates>();	// 軸座標リスト
		EdgeCoordinates axisCoordinates = null;				// 軸座標

		Iterator<String> axisIt = StringUtil.splitString(indexKey,",").iterator();
		while (axisIt.hasNext()) {
			LinkedHashMap<Integer, String> axisIdKeyMap = new LinkedHashMap<Integer, String>();

			String indexKeysString = axisIt.next();
			ArrayList<String> indexKeysList = StringUtil.splitString(indexKeysString,":");
			Integer axisIndex = Integer.decode(indexKeysList.get(0));	// 列のインデックス
			String colKeys    = indexKeysList.get(1);							// 列のキーの組み合わせ(文字列)
			ArrayList<String> axisKeyList = StringUtil.splitString(colKeys,";");			// 列のキーの組み合わせ(配列)

			Iterator<String> keyListIte = axisKeyList.iterator();
			int j = 0;
			while (keyListIte.hasNext()){
				String key = keyListIte.next();
				axisIdKeyMap.put(Integer.decode(axisIdList[j]), key);
				j++;
			}
			axisCoordinatesList.add(new EdgeCoordinates(axisIndex, axisIdKeyMap));
		}

		return axisCoordinatesList;
	}

	// ********** Getter メソッド **********

	/**
	 * 列または行のインデックスを求める。
	 * (列または行に対して一意になる0startの通番) 
	 * @return 列または行のインデックス
	 */
	public Integer getIndex() {
		return index;
	}

	/**
	 * 列または行の各段の軸IDをKEYとし、軸メンバーのキーをVALUEに持つMapオブジェクトを求める。
	 * @return 列または行の各段の軸IDをKEYとし、軸メンバーのキーをVALUEに持つMapオブジェクト
	 */
	public LinkedHashMap<Integer, String> getAxisIdMemKeyMap() {
		return axisIdMemKeyMap;
	}
}
