/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：GetReportInfoCommand.java
 *  説明：レポート情報をXML形式で出力するクラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import openolap.viewer.Axis;
import openolap.viewer.AxisLevel;
import openolap.viewer.Dimension;
import openolap.viewer.Edge;
import openolap.viewer.Measure;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.Security;
import openolap.viewer.User;
import openolap.viewer.chart.ChartXMLCreator;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.CommonUtils;
import openolap.viewer.common.StringUtil;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;
import openolap.viewer.dao.ReportDAO;

/**
 *  クラス：GetReportInfoCommand<br>
 *  説明：レポート情報をXML形式で出力するクラスです。
 */
public class GetReportInfoCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(GetReportInfoCommand.class.getName());

	// ********** メソッド **********

	/**
	 * レポート情報をXML形式で出力します。<br>
	 * JSPへdispatchを行わずに直接XMLを出力するため、nullを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return null
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings) 
		throws IOException {

			this.requestHelper = helper;
			HttpServletRequest request = this.requestHelper.getRequest();
			HttpSession session = this.requestHelper.getRequest().getSession();

			Report report = (Report) session.getAttribute("report");
			User user = (User) session.getAttribute("user");

			Connection conn = null;

			try {
				DAOFactory daoFactory = DAOFactory.getDAOFactory();
				conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
												(String)helper.getRequest().getSession().getAttribute("searchPathName"));
				// XMLを出力
				this.outputXML(helper, report, user, conn);

			} catch (SQLException e) {
				this.outputErrorXML(helper, e);
			} catch (ParserConfigurationException e) {
				this.outputErrorXML(helper, e);
			} catch (SAXException e) {
				this.outputErrorXML(helper, e);
			} catch (IOException e) {
				this.outputErrorXML(helper, e);
			} catch (Exception e) {
				this.outputErrorXML(helper, e);
			} finally {
				if(conn != null){
					try {
						conn.close();
					} catch (SQLException e) {
						this.outputErrorXML(helper, e);
					}
				}
			}

			return null;

	}

	// ********** private メソッド **********

	/**
	 * デフォルトメンバーキーがnullの場合、"NA"に変換する。
	 * @param defaultMemKey デフォルトメンバーキー
	 * @return デフォルトメンバーキー
	 */
	private String changeDefaultMemberKey(String defaultMemKey) {
		if(defaultMemKey == null) { 
			return "NA";
		} else {
			return defaultMemKey;
		}
	}

	/**
	 * レポート情報をXML形式で出力します。
	 * @param helper RequestHelperオブジェクト
	 * @param report レポートオブジェクト
	 * @param user ユーザーオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception IOException 処理中に例外が発生した
	 * @exception SQLException レポート情報取得時に例外が発生した
	 * @exception TransformerException
	 * @exception ParserConfigurationException
	 * @exception SAXException
	 */
	private void outputXML(RequestHelper helper, Report report, User user, Connection conn) throws SQLException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {

		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		DimensionMemberDAO dimMemberDAO = daoFactory.getDimensionMemberDAO(conn);
		ReportDAO reportDAO = daoFactory.getReportDAO(conn);


		StringBuilder reportInfoXML = new StringBuilder(2048);	// Report情報XML格納用

		// Report情報XML生成開始
		reportInfoXML.append("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
		reportInfoXML.append("<root>");
			reportInfoXML.append("<OlapInfo>");
				reportInfoXML.append("<ReportInfo>");
					reportInfoXML.append("<Report>");
						reportInfoXML.append("<ReportID>");
							reportInfoXML.append(report.getReportID());
						reportInfoXML.append("</ReportID>");
						reportInfoXML.append("<ReportName>");
							reportInfoXML.append(report.getReportName());
						reportInfoXML.append("</ReportName>");
						reportInfoXML.append("<isNewReport>");
							reportInfoXML.append(CommonUtils.boolToFLG(report.isNewReport()));
						reportInfoXML.append("</isNewReport>");
						reportInfoXML.append("<displayScreenType>");		// 画面分割スタイル
							reportInfoXML.append(report.getDisplayScreenType());	// (0:全画面表示（表）、1:全画面表示（グラフ）、2:縦分割（表、グラフ))
						reportInfoXML.append("</displayScreenType>");
						reportInfoXML.append("<currentChartID>");		// 表示中のグラフID
							ChartXMLCreator chartXMLCreator = new ChartXMLCreator();
							String chartID = null;
							if("NA".equals(report.getCurrentChart())){
								chartID = report.getCurrentChart();
							} else {
								chartID = chartXMLCreator.chartNameToId(ChartXMLCreator.getChartXMLFilePath(helper), report.getCurrentChart());
							}
							reportInfoXML.append(chartID);
						reportInfoXML.append("</currentChartID>");
						reportInfoXML.append("<colorType>");		// 色設定のタイプ（1：塗りつぶし、2：ハイライト）
							reportInfoXML.append(report.getColorType());
						reportInfoXML.append("</colorType>");
						reportInfoXML.append("<DrillThrowInfo>");
							reportInfoXML.append("<TargetReports>");
							HashMap<String, String> drillTargetMap = reportDAO.getDrillThrowInfo(report.getReportID());
								Iterator<String> it = drillTargetMap.keySet().iterator();
								while (it.hasNext()) {
									String targetRepID   = it.next();
									String targetRepName = drillTargetMap.get(targetRepID);
									reportInfoXML.append("<TargetReport>");
										reportInfoXML.append("<TargetRepID>");
											reportInfoXML.append(targetRepID);
										reportInfoXML.append("</TargetRepID>");
										reportInfoXML.append("<TargetRepName>");
											reportInfoXML.append(targetRepName);
										reportInfoXML.append("</TargetRepName>");
									reportInfoXML.append("</TargetReport>");
								}
					
							reportInfoXML.append("</TargetReports>");
						reportInfoXML.append("</DrillThrowInfo>");
					reportInfoXML.append("</Report>");
				reportInfoXML.append("</ReportInfo>");
				reportInfoXML.append("<CubeInfo>");
					reportInfoXML.append("<Cube>");
						reportInfoXML.append("<CubeName>");
							reportInfoXML.append(report.getCube().getCubeName());
						reportInfoXML.append("</CubeName>");
						reportInfoXML.append("<CubeSeq>");
							reportInfoXML.append(report.getCube().getCubeSeq());
						reportInfoXML.append("</CubeSeq>");
					reportInfoXML.append("</Cube>");
				reportInfoXML.append("</CubeInfo>");

			reportInfoXML.append("<AxesInfo>");


			// 軸の配置場所を生成
			Iterator<Edge> edgeIt = report.getEdgeList().iterator();
			while (edgeIt.hasNext()) {
				Edge edge = edgeIt.next();
				Iterator<Axis> axisIt = edge.getAxisList().iterator();
				reportInfoXML.append(StringUtil.addStartTAGMark(edge.getPosition()));
				while (axisIt.hasNext()) {
					Axis axis = axisIt.next();
					reportInfoXML.append("<HierarchyID>" + axis.getId()  + "</HierarchyID>");
				}
				reportInfoXML.append(StringUtil.addEndTAGMark(edge.getPosition()));
			}

			// 軸情報をAxisIDの昇順で生成
			ArrayList<Axis> axisList = report.getAxisOrderByID();
			Iterator<Axis> axisIt = axisList.iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				reportInfoXML.append("<HierarchyInfo name=\"" + axis.getName() + "\" id=\""+ axis.getId() +"\">");
				reportInfoXML.append("<DefaultMemberKey>"+ changeDefaultMemberKey(axis.getDefaultMemberKey()) +"</DefaultMemberKey>");
				reportInfoXML.append("<Comment>" + StringUtil.changeNullToEmpty(axis.getComment()) + "</Comment>");

				// メンバーの表示名タイプを生成
				String displayMemberNameType = null;
				if(axis instanceof Dimension) {
					displayMemberNameType = dimMemberDAO.transferMemberDisplayTypeFromModelToXML(((Dimension)axis).getDispMemberNameType());
				} else {
					displayMemberNameType = dimMemberDAO.transferMemberDisplayTypeFromModelToXML(Dimension.DISP_SHORT_NAME);
				}
				reportInfoXML.append("<DisplayMemberType>" + displayMemberNameType + "</DisplayMemberType>");
					
				Iterator<AxisLevel> levelIt = axis.getAxisLevelList().iterator();
				while (levelIt.hasNext()) {
					AxisLevel axisLevel = levelIt.next();
					reportInfoXML.append("<Level>");
						reportInfoXML.append("<LNum>");
							reportInfoXML.append(axisLevel.getLevelNumber());
						reportInfoXML.append("</LNum>");
						reportInfoXML.append("<LName>");
							reportInfoXML.append(axisLevel.getName());
						reportInfoXML.append("</LName>");
						reportInfoXML.append("<Comment>");
							reportInfoXML.append(StringUtil.changeNullToEmpty(axisLevel.getComment()));
						reportInfoXML.append("</Comment>");
					reportInfoXML.append("</Level>");
				}
				reportInfoXML.append("</HierarchyInfo>");

			}

			reportInfoXML.append("</AxesInfo>");
		reportInfoXML.append("</OlapInfo>");

		// ユーザ情報出力
		reportInfoXML.append("<UserInfo>");
			reportInfoXML.append("<UserName>");
				reportInfoXML.append(user.getName());
			reportInfoXML.append("</UserName>");
			reportInfoXML.append("<isAdmin>");
				reportInfoXML.append(CommonUtils.boolToFLG(user.isAdmin()));
			reportInfoXML.append("</isAdmin>");
			reportInfoXML.append("<isPersonalReportSavable>");
				reportInfoXML.append(CommonUtils.boolToFLG(user.isPersonalReportSavable()));
			reportInfoXML.append("</isPersonalReportSavable>");
			reportInfoXML.append("<isThisReportExportable>");
					Security security = (Security)helper.getRequest().getSession().getAttribute("security");
					reportInfoXML.append(CommonUtils.boolToFLG(security.isReportExportable()));
			reportInfoXML.append("</isThisReportExportable>");
			reportInfoXML.append("<exportType>");
				reportInfoXML.append(user.getExportFileType());
			reportInfoXML.append("</exportType>");
		reportInfoXML.append("</UserInfo>");

		// 軸メンバ情報生成
		reportInfoXML.append("<Axes>");

			// ディメンションメンバ情報を取得し、生成。
			reportInfoXML.append(dimMemberDAO.getDimensionMemberXML(report));

			// メジャー情報を生成
			Measure measure = report.getMeasure();
			Iterator meaMemIt = measure.getAxisMemberList().iterator();
			reportInfoXML.append("<Members name=\"" + measure.getName() + "\" id=\"" + measure.getId() +  "\">");

			while (meaMemIt.hasNext()) {
				MeasureMember measureMember = (MeasureMember) meaMemIt.next();

				if(!measureMember.isSelected()) {	// セレクタで表示対象外とされているメンバ情報は出力しない
					continue;
				}

				reportInfoXML.append("<Member id=\"" + measureMember.getId() + "\" measureSeq=\"" + measureMember.getMeasureSeq() + "\" >");
				reportInfoXML.append("    <UName>" + measureMember.getUniqueName() + "</UName>");
				reportInfoXML.append("    <Code>" + measureMember.getMeasureName() + "</Code>");
				reportInfoXML.append("    <Caption>" + measureMember.getMeasureName() + "</Caption>");
				reportInfoXML.append("    <Caption2>" + measureMember.getMeasureName() + "</Caption2>");
				reportInfoXML.append("    <LNum>1</LNum>");
				reportInfoXML.append("    <isDrilled>false</isDrilled>");
				reportInfoXML.append("    <isLeaf>true</isLeaf>");
				reportInfoXML.append("</Member>");

			}
			reportInfoXML.append("</Members>");

		reportInfoXML.append("</Axes>");
		reportInfoXML.append("</root>");


		// XML出力準備
		this.requestHelper.getResponse().setContentType("text/xml; charset=Shift_JIS");
		PrintWriter out = this.requestHelper.getResponse().getWriter();


		// XMLの出力
		out.print(reportInfoXML.toString());
			if(log.isInfoEnabled()) {	// ログ出力
				log.info("XML(report info)：\n" + reportInfoXML.toString());
			}

	}

	/**
	 * レポート情報XML生成時にエラーが発生したことをあらわすXML要素を出力します。
	 * @param helper RequestHelperオブジェクト
	 * @param e レポート情報XML生成時に発生したExceptionオブジェクト
	 * @exception IOException 処理中に例外が発生した
	 */
	private void outputErrorXML(RequestHelper helper, Exception e) throws IOException {

		// 標準出力への出力
		e.printStackTrace();

	
		// エラーを表す要素を追加
		//   既出力のXMLが整形である場合：rootの外にisError要素を追加して、XMLを非整形とする。
		//   既出力のXMLが整形でない場合：isError要素を追加しても、XMLは非整形のまま。
		// ※ 非整形とすることで、MSXSLのloadでエラーを発生させ、エラー処理を行なわせる。
		PrintWriter out = this.requestHelper.getResponse().getWriter();
		out.println("<isError>1</isError>");

		// ロギング
		log.error("レポート情報XML生成時にエラーが発生。：", e);
		
	}

}
