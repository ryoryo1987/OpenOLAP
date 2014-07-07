/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresMeasureDAO.java
 *  説明：メジャーオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/07
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import openolap.viewer.AxisLevel;
import openolap.viewer.Measure;
import openolap.viewer.MeasureMember;
import openolap.viewer.common.Messages;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;

/**
 *  クラス：PostgresMeasureDAO<br>
 *  説明：メジャーオブジェクトの永続化を管理するクラスです
 */
public class PostgresMeasureDAO implements MeasureDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	// ********** コンストラクタ **********

	/**
	 *  メジャーオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresMeasureDAO() {}	

	/**
	 *  メジャーオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresMeasureDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * メジャーオブジェクトを求める。<br>
	 *   メジャーオブジェクトの状態：<br>
	 *     メジャーメンバーオブジェクト：持たない
	 * @return メジャーオブジェクト
	 */
	public Measure findMeasureWithoutMember() {
	
		final boolean measureFLG = true;
		boolean isUsedSelecterFLG = false;

		Measure measure = new Measure(Constants.MeasureID, 
										Messages.getString("PostgresMeasureDAO.MeasureName"),  //$NON-NLS-1$
										Messages.getString("PostgresMeasureDAO.MeasureComment"),  //$NON-NLS-1$
										new ArrayList<AxisLevel>(),		// axisLevelList
										null, 							// defaultMemberKey
										measureFLG, 					// isMeasure
										isUsedSelecterFLG);				// isUsedSelecter

		return measure;
	}

	/**
	 * メジャーオブジェクトを求める。<br>
	 *   メジャーオブジェクトの状態：<br>
	 *     メジャーメンバーオブジェクト：持つ
	 * @param cubeSeq キューブシーケンス番号
	 * @param commonSettings アプリケーションの共通設定
	 * @return メジャーオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Measure findMeasureWithMember(String cubeSeq, CommonSettings commonSettings) throws SQLException  {

		// Measure オブジェクト取得
		Measure measure = this.findMeasureWithoutMember();

		// Measure オブジェクトに AxisLevel オブジェクトを追加
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		AxisLevelDAO axisLevelDAO = daoFactory.getAxisLevelDAO(this.conn);
		Iterator<AxisLevel> it = axisLevelDAO.selectAxisLevels(cubeSeq,measure).iterator();
		while (it.hasNext()) {
			AxisLevel axisLevel = it.next();
			measure.addAxisLevelList(axisLevel);
		}

		// Measure オブジェクトに MeasureMember オブジェクトを追加

		MeasureMemberDAO measureMemberDAO = daoFactory.getMeasureMemberDAO(this.conn);
		ArrayList<MeasureMember> measureMemberList = measureMemberDAO.selectMeasureMembers(cubeSeq, commonSettings);
		Iterator<MeasureMember> it2 = measureMemberList.iterator();

		while (it2.hasNext()) {
			MeasureMember measureMem = it2.next();
			measure.addAxisMember(measureMem);
		}

		return measure;
	}

}
