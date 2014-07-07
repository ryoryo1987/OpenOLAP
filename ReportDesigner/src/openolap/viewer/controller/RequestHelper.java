/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：RequestHelper.java
 *  説明：クライアントからのリクエストと処理を紐付けるクラスです。
 *
 *  作成日: 2004/01/05
 */

package openolap.viewer.controller;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *  クラス：RegistSelecterInfoCommand
 *  説明：クライアントからのリクエストと処理を紐付けるクラスです。
 */
public class RequestHelper {

	// ********** インスタンス変数 **********

	/** HttpServletRequestオブジェクト */
	HttpServletRequest request = null;

	/** HttpServletResponseオブジェクト */
	HttpServletResponse response = null;

	/** ServletConfigオブジェクト */
	ServletConfig config = null;

	// ********** コンストラクタ **********

	/**
	 * クライアントからのリクエストと処理を紐付けるオブジェクトを生成します。
	 */
	public RequestHelper (HttpServletRequest request, HttpServletResponse response, ServletConfig config) {
		this.request = request;
		this.response = response;
		this.config = config;
	}

	// ********** メソッド **********

	/**
	 * 設定の登録完了を意味し、Spreadの再表示を行うページを戻す。
	 * @return リクエストに対応する処理を実行するオブジェクト。
	 */
	public Command getCommand() {

		Command command = null;
		String action = this.request.getParameter("action");

		// ログイン済みかをチェック
		if ( request.getSession().getAttribute("user") == null) {
			if (!action.equals("login")) {
				return new InvalidateSessionCommand();
			}
		}


		if (action != null){

			// レポート初期表示
			if (action.equals("displayNewReport")) {		//レポート初期表示
				command = new DisplayNewReportCommand();
			} else if (action.equals("getReportHeader")) {	//レポートオブジェクト生成およびヘッダ部生成
				command = new GetReportHeaderCommand();
			} else if(action.equals("loadClientInitAct")){	//レポート情報取得コマンドを取得
															// レポート情報（XML）の再作成からSpread表示処理を行なう
															// ターゲットフレームは、info_area
				command = new LoadClientInitActCommand();
			} else if (action.equals("getReportInfo")){	//レポート情報(レポート、軸、軸メンバ)
				command = new GetReportInfoCommand();
			} else if (action.equals("renewHtmlAct")) {	//クライアントが持っているレポート情報（XML）をもとに、
															//HTML生成処理からSpread表示処理を行なう

				command = new RenewHtmlActCommand();

			// 色設定
			} else if (action.equals("loadColorAct")){		//色設定コマンドを取得
				command = new LoadColorActCommand();
			} else if (action.equals("getColorInfo")){		//色設定情報を取得
				command = new GetColorInfoCommand(); 

			// ハイライト
			} else if (action.equals("displayHighLight")){	
				command = new DisplayHighLightCommand();
			} else if (action.equals("displayHighLightHeader")){	
				command = new DisplayHighLightHeaderCommand();
			} else if (action.equals("displayHighLightBody")){	
				command = new DisplayHighLightBodyCommand();

			// 色設定をセッションへ登録
			} else if (action.equals("registColorOnly")) {
				command = new RegistColorOnlyCommand();	

			// レポートへのデータ表示
			} else if (action.equals("loadDataAct")) {		//レポートへのデータ挿入コマンドを取得
															//(初期表示、スライス、ドリルダウン)
				command = new LoadDataActCommand();
			} else if (action.equals("getDataInfo")) {		//レポートのデータの集合を取得
				command = new GetDataInfoCommand();

			// セレクタ
			} else if (action.equals("displaySelecter")) {			//セレクター フレームを表示
				command = new DisplaySelecterCommand();
			} else if (action.equals("displaySelecterHeader")){	//セレクター ヘッダー部を表示
				command = new DisplaySelecterHeaderCommand();
			} else if (action.equals("displaySelecterBody")){		//セレクター ボディー部を表示
				command = new DisplaySelecterBodyCommand();
			} else if (action.equals("getAxisMemberInfoByAxisID")) {// 軸メンバ情報XMLを取得
				command = new GetAxisMemberInfoByAxisIDCommand();				
			} else if (action.equals("registClientReportStatus")){	//クライアント側のレポート情報をサーバー側のモデルに反映（永続化はしない）
				command = new RegistSelecterInfoCommand();
			} else if (action.equals("searchDimensionMember")){	//次元メンバ検索(セレクタ)
				command = new SearchDimensionMemberCommand();

			// レポート保存
			} else if (action.equals("saveClientReportStatus")){	//クライアント側のレポート情報を永続化
				command = new SaveClientReportStatusCommand();

			// ログイン
			} else if (action.equals("login")) {
				command = new LoginCommand();
			
			// ログアウト
			} else if (action.equals("logout")) {	// ログアウト処理を実行
				command = new LogoutCommand();

			// エクスポート
			} else if (action.equals("exportReport")) {
				command = new ExportReportCommand();
			
			// グラフ表示（XML生成＋グラフ表示）
			} else if (action.equals("getChartInfo")) {
				command = new GetChartInfoCommand();
			
			// グラフ表示（クライアントより送信されたXMLに基づく）
			} else if (action.equals("dispChartFromXML")) {
				command = new GetChartFromXMLCommand();			
			
			
			// SQLによる検索結果を、結果出力テンプレート（XML）に埋め込んで戻す
			} else if (action.equals("getResultXML")) {
				command = new GetResultXML();
			
			// レポート表示権限不足メッセージ画面	
			} else if (action.equals("getCannotDispReportMSG")) {
				command = new GetCannotDispReportMSGCommand();
			}

		}
		
		return command;

	}


	/**
	 * クライアントから送信されたリクエストをあらわすオブジェクトを求める。
	 * @return リクエストをあらわすオブジェクト
	 */
	public HttpServletRequest getRequest() {
		return request;
	}

	/**
	 * クライアントへ返信するリクエストをあらわすオブジェクトを求める。
	 * @return レスポンスをあらわすオブジェクト。
	 */
	public HttpServletResponse getResponse() {
		return response;
	}

	/**
	 * Servletの設定をあらわすオブジェクトを戻す。
	 * @return Servletの設定をあらわすオブジェクト
	 */
	public ServletConfig getConfig() {
		return config;
	}

}

