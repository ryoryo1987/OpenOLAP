/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FGetReportInfoCommand.java
 *  �����F���|�[�g����XML�`���ŏo�͂���N���X�ł��B
 *
 *  �쐬��: 2004/01/09
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
 *  �N���X�FGetReportInfoCommand<br>
 *  �����F���|�[�g����XML�`���ŏo�͂���N���X�ł��B
 */
public class GetReportInfoCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(GetReportInfoCommand.class.getName());

	// ********** ���\�b�h **********

	/**
	 * ���|�[�g����XML�`���ŏo�͂��܂��B<br>
	 * JSP��dispatch���s�킸�ɒ���XML���o�͂��邽�߁Anull��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return null
	 * @exception IOException �������ɗ�O����������
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
				// XML���o��
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

	// ********** private ���\�b�h **********

	/**
	 * �f�t�H���g�����o�[�L�[��null�̏ꍇ�A"NA"�ɕϊ�����B
	 * @param defaultMemKey �f�t�H���g�����o�[�L�[
	 * @return �f�t�H���g�����o�[�L�[
	 */
	private String changeDefaultMemberKey(String defaultMemKey) {
		if(defaultMemKey == null) { 
			return "NA";
		} else {
			return defaultMemKey;
		}
	}

	/**
	 * ���|�[�g����XML�`���ŏo�͂��܂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param user ���[�U�[�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception IOException �������ɗ�O����������
	 * @exception SQLException ���|�[�g���擾���ɗ�O����������
	 * @exception TransformerException
	 * @exception ParserConfigurationException
	 * @exception SAXException
	 */
	private void outputXML(RequestHelper helper, Report report, User user, Connection conn) throws SQLException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException {

		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		DimensionMemberDAO dimMemberDAO = daoFactory.getDimensionMemberDAO(conn);
		ReportDAO reportDAO = daoFactory.getReportDAO(conn);


		StringBuilder reportInfoXML = new StringBuilder(2048);	// Report���XML�i�[�p

		// Report���XML�����J�n
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
						reportInfoXML.append("<displayScreenType>");		// ��ʕ����X�^�C��
							reportInfoXML.append(report.getDisplayScreenType());	// (0:�S��ʕ\���i�\�j�A1:�S��ʕ\���i�O���t�j�A2:�c�����i�\�A�O���t))
						reportInfoXML.append("</displayScreenType>");
						reportInfoXML.append("<currentChartID>");		// �\�����̃O���tID
							ChartXMLCreator chartXMLCreator = new ChartXMLCreator();
							String chartID = null;
							if("NA".equals(report.getCurrentChart())){
								chartID = report.getCurrentChart();
							} else {
								chartID = chartXMLCreator.chartNameToId(ChartXMLCreator.getChartXMLFilePath(helper), report.getCurrentChart());
							}
							reportInfoXML.append(chartID);
						reportInfoXML.append("</currentChartID>");
						reportInfoXML.append("<colorType>");		// �F�ݒ�̃^�C�v�i1�F�h��Ԃ��A2�F�n�C���C�g�j
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


			// ���̔z�u�ꏊ�𐶐�
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

			// ������AxisID�̏����Ő���
			ArrayList<Axis> axisList = report.getAxisOrderByID();
			Iterator<Axis> axisIt = axisList.iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				reportInfoXML.append("<HierarchyInfo name=\"" + axis.getName() + "\" id=\""+ axis.getId() +"\">");
				reportInfoXML.append("<DefaultMemberKey>"+ changeDefaultMemberKey(axis.getDefaultMemberKey()) +"</DefaultMemberKey>");
				reportInfoXML.append("<Comment>" + StringUtil.changeNullToEmpty(axis.getComment()) + "</Comment>");

				// �����o�[�̕\�����^�C�v�𐶐�
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

		// ���[�U���o��
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

		// �������o��񐶐�
		reportInfoXML.append("<Axes>");

			// �f�B�����V���������o�����擾���A�����B
			reportInfoXML.append(dimMemberDAO.getDimensionMemberXML(report));

			// ���W���[���𐶐�
			Measure measure = report.getMeasure();
			Iterator meaMemIt = measure.getAxisMemberList().iterator();
			reportInfoXML.append("<Members name=\"" + measure.getName() + "\" id=\"" + measure.getId() +  "\">");

			while (meaMemIt.hasNext()) {
				MeasureMember measureMember = (MeasureMember) meaMemIt.next();

				if(!measureMember.isSelected()) {	// �Z���N�^�ŕ\���ΏۊO�Ƃ���Ă��郁���o���͏o�͂��Ȃ�
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


		// XML�o�͏���
		this.requestHelper.getResponse().setContentType("text/xml; charset=Shift_JIS");
		PrintWriter out = this.requestHelper.getResponse().getWriter();


		// XML�̏o��
		out.print(reportInfoXML.toString());
			if(log.isInfoEnabled()) {	// ���O�o��
				log.info("XML(report info)�F\n" + reportInfoXML.toString());
			}

	}

	/**
	 * ���|�[�g���XML�������ɃG���[�������������Ƃ�����킷XML�v�f���o�͂��܂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param e ���|�[�g���XML�������ɔ�������Exception�I�u�W�F�N�g
	 * @exception IOException �������ɗ�O����������
	 */
	private void outputErrorXML(RequestHelper helper, Exception e) throws IOException {

		// �W���o�͂ւ̏o��
		e.printStackTrace();

	
		// �G���[��\���v�f��ǉ�
		//   ���o�͂�XML�����`�ł���ꍇ�Froot�̊O��isError�v�f��ǉ����āAXML��񐮌`�Ƃ���B
		//   ���o�͂�XML�����`�łȂ��ꍇ�FisError�v�f��ǉ����Ă��AXML�͔񐮌`�̂܂܁B
		// �� �񐮌`�Ƃ��邱�ƂŁAMSXSL��load�ŃG���[�𔭐������A�G���[�������s�Ȃ킹��B
		PrintWriter out = this.requestHelper.getResponse().getWriter();
		out.println("<isError>1</isError>");

		// ���M���O
		log.error("���|�[�g���XML�������ɃG���[�������B�F", e);
		
	}

}
