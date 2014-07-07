/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Cube.java
 *  説明：キューブをあらわすクラスです。
 *
 *  作成日: 2004/01/08
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  クラス：Cube<br>
 *  説明：キューブをあらわすクラスです。
 */
public class Cube implements Serializable {

	// ********** インスタンス変数 **********

	/** キューブのシーケンス番号 */
	final private String cubeSeq;

	/** キューブ名 */
	final private String cubeName;

	// ********** コンストラクタ **********

	/**
	 * キューブオブジェクトを生成します。
	 */
	public Cube(String cubeSeq, String cubeName){
		this.cubeSeq = cubeSeq;
		this.cubeName = cubeName;
	}



	// ********** メソッド **********

	/**
	 * このインスタンスの文字列表現を求める。
	 * @return Stringオブジェクト
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "cubeSeq:" + this.cubeSeq + sep;
		stringInfo += "cubeName:" + this.cubeName + sep;

		return stringInfo;

	}

	// ********** Getter メソッド **********

	/**
	 * キューブのシーケンス番号を求める。
	 * @return キューブのシーケンス番号
	 */
	public String getCubeSeq() {
		return cubeSeq;
	}

	/**
	 * キューブ名を求める。
	 * @return キューブ名
	 */
	public String getCubeName() {
		return cubeName;
	}


}
