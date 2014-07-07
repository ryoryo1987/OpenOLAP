/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FRequestHelper.java
 *  �����F�N���C�A���g����̃��N�G�X�g�Ə�����R�t����N���X�ł��B
 *
 *  �쐬��: 2004/01/05
 */

package openolap.viewer.controller;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *  �N���X�FRegistSelecterInfoCommand
 *  �����F�N���C�A���g����̃��N�G�X�g�Ə�����R�t����N���X�ł��B
 */
public class RequestHelper {

	// ********** �C���X�^���X�ϐ� **********

	/** HttpServletRequest�I�u�W�F�N�g */
	HttpServletRequest request = null;

	/** HttpServletResponse�I�u�W�F�N�g */
	HttpServletResponse response = null;

	/** ServletConfig�I�u�W�F�N�g */
	ServletConfig config = null;

	// ********** �R���X�g���N�^ **********

	/**
	 * �N���C�A���g����̃��N�G�X�g�Ə�����R�t����I�u�W�F�N�g�𐶐����܂��B
	 */
	public RequestHelper (HttpServletRequest request, HttpServletResponse response, ServletConfig config) {
		this.request = request;
		this.response = response;
		this.config = config;
	}

	// ********** ���\�b�h **********

	/**
	 * �ݒ�̓o�^�������Ӗ����ASpread�̍ĕ\�����s���y�[�W��߂��B
	 * @return ���N�G�X�g�ɑΉ����鏈�������s����I�u�W�F�N�g�B
	 */
	public Command getCommand() {

		Command command = null;
		String action = this.request.getParameter("action");

		// ���O�C���ς݂����`�F�b�N
		if ( request.getSession().getAttribute("user") == null) {
			if (!action.equals("login")) {
				return new InvalidateSessionCommand();
			}
		}


		if (action != null){

			// ���|�[�g�����\��
			if (action.equals("displayNewReport")) {		//���|�[�g�����\��
				command = new DisplayNewReportCommand();
			} else if (action.equals("getReportHeader")) {	//���|�[�g�I�u�W�F�N�g��������уw�b�_������
				command = new GetReportHeaderCommand();
			} else if(action.equals("loadClientInitAct")){	//���|�[�g���擾�R�}���h���擾
															// ���|�[�g���iXML�j�̍č쐬����Spread�\���������s�Ȃ�
															// �^�[�Q�b�g�t���[���́Ainfo_area
				command = new LoadClientInitActCommand();
			} else if (action.equals("getReportInfo")){	//���|�[�g���(���|�[�g�A���A�������o)
				command = new GetReportInfoCommand();
			} else if (action.equals("renewHtmlAct")) {	//�N���C�A���g�������Ă��郌�|�[�g���iXML�j�����ƂɁA
															//HTML������������Spread�\���������s�Ȃ�

				command = new RenewHtmlActCommand();

			// �F�ݒ�
			} else if (action.equals("loadColorAct")){		//�F�ݒ�R�}���h���擾
				command = new LoadColorActCommand();
			} else if (action.equals("getColorInfo")){		//�F�ݒ�����擾
				command = new GetColorInfoCommand(); 

			// �n�C���C�g
			} else if (action.equals("displayHighLight")){	
				command = new DisplayHighLightCommand();
			} else if (action.equals("displayHighLightHeader")){	
				command = new DisplayHighLightHeaderCommand();
			} else if (action.equals("displayHighLightBody")){	
				command = new DisplayHighLightBodyCommand();

			// �F�ݒ���Z�b�V�����֓o�^
			} else if (action.equals("registColorOnly")) {
				command = new RegistColorOnlyCommand();	

			// ���|�[�g�ւ̃f�[�^�\��
			} else if (action.equals("loadDataAct")) {		//���|�[�g�ւ̃f�[�^�}���R�}���h���擾
															//(�����\���A�X���C�X�A�h�����_�E��)
				command = new LoadDataActCommand();
			} else if (action.equals("getDataInfo")) {		//���|�[�g�̃f�[�^�̏W�����擾
				command = new GetDataInfoCommand();

			// �Z���N�^
			} else if (action.equals("displaySelecter")) {			//�Z���N�^�[ �t���[����\��
				command = new DisplaySelecterCommand();
			} else if (action.equals("displaySelecterHeader")){	//�Z���N�^�[ �w�b�_�[����\��
				command = new DisplaySelecterHeaderCommand();
			} else if (action.equals("displaySelecterBody")){		//�Z���N�^�[ �{�f�B�[����\��
				command = new DisplaySelecterBodyCommand();
			} else if (action.equals("getAxisMemberInfoByAxisID")) {// �������o���XML���擾
				command = new GetAxisMemberInfoByAxisIDCommand();				
			} else if (action.equals("registClientReportStatus")){	//�N���C�A���g���̃��|�[�g�����T�[�o�[���̃��f���ɔ��f�i�i�����͂��Ȃ��j
				command = new RegistSelecterInfoCommand();
			} else if (action.equals("searchDimensionMember")){	//���������o����(�Z���N�^)
				command = new SearchDimensionMemberCommand();

			// ���|�[�g�ۑ�
			} else if (action.equals("saveClientReportStatus")){	//�N���C�A���g���̃��|�[�g�����i����
				command = new SaveClientReportStatusCommand();

			// ���O�C��
			} else if (action.equals("login")) {
				command = new LoginCommand();
			
			// ���O�A�E�g
			} else if (action.equals("logout")) {	// ���O�A�E�g���������s
				command = new LogoutCommand();

			// �G�N�X�|�[�g
			} else if (action.equals("exportReport")) {
				command = new ExportReportCommand();
			
			// �O���t�\���iXML�����{�O���t�\���j
			} else if (action.equals("getChartInfo")) {
				command = new GetChartInfoCommand();
			
			// �O���t�\���i�N���C�A���g��著�M���ꂽXML�Ɋ�Â��j
			} else if (action.equals("dispChartFromXML")) {
				command = new GetChartFromXMLCommand();			
			
			
			// SQL�ɂ�錟�����ʂ��A���ʏo�̓e���v���[�g�iXML�j�ɖ��ߍ���Ŗ߂�
			} else if (action.equals("getResultXML")) {
				command = new GetResultXML();
			
			// ���|�[�g�\�������s�����b�Z�[�W���	
			} else if (action.equals("getCannotDispReportMSG")) {
				command = new GetCannotDispReportMSGCommand();
			}

		}
		
		return command;

	}


	/**
	 * �N���C�A���g���瑗�M���ꂽ���N�G�X�g������킷�I�u�W�F�N�g�����߂�B
	 * @return ���N�G�X�g������킷�I�u�W�F�N�g
	 */
	public HttpServletRequest getRequest() {
		return request;
	}

	/**
	 * �N���C�A���g�֕ԐM���郊�N�G�X�g������킷�I�u�W�F�N�g�����߂�B
	 * @return ���X�|���X������킷�I�u�W�F�N�g�B
	 */
	public HttpServletResponse getResponse() {
		return response;
	}

	/**
	 * Servlet�̐ݒ������킷�I�u�W�F�N�g��߂��B
	 * @return Servlet�̐ݒ������킷�I�u�W�F�N�g
	 */
	public ServletConfig getConfig() {
		return config;
	}

}

