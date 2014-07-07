/*
 * �쐬��: 2004/07/26
 */
package openolap.viewer.chart;

import java.awt.Color;
import java.awt.Font;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartRenderingInfo;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.Legend;
import org.jfree.chart.StandardLegend;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.entity.StandardEntityCollection;
import org.jfree.chart.imagemap.StandardToolTipTagFragmentGenerator;
import org.jfree.chart.labels.StandardCategoryToolTipGenerator;
import org.jfree.chart.labels.StandardPieItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.DatasetRenderingOrder;
import org.jfree.chart.plot.MultiplePiePlot;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.Plot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.AreaRenderer;
import org.jfree.chart.renderer.BarRenderer;
import org.jfree.chart.renderer.BarRenderer3D;
import org.jfree.chart.renderer.CategoryItemRenderer;
import org.jfree.chart.renderer.LineAndShapeRenderer;
import org.jfree.chart.renderer.StackedAreaRenderer;
import org.jfree.chart.renderer.StackedBarRenderer;
import org.jfree.chart.renderer.StackedBarRenderer3D;
import org.jfree.chart.servlet.ServletUtilities;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.CategoryDataset;
import org.jfree.data.Dataset;
import org.jfree.data.DefaultCategoryDataset;
import org.jfree.data.DefaultPieDataset;
import org.jfree.data.PieDataset;
import org.jfree.util.TableOrder;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

/**
 * @author Administrator
 *
 */
public class ChartCreator {

	// ********** �C���X�^���X�ϐ� **********

	/** �`���[�g�I�u�W�F�N�g */
	JFreeChart chart = null;

	/** �`���[�g�̃v���b�g*/
	Plot plot = null;

	/** �`���[�g�^�C�v*/
	String chartType = null;

	/** �f�[�^�Z�b�g�̔z��   */
	ArrayList<Dataset> dataSetList = null;

	/** �`���[�g�̕�   */
	int chartWidth   = 0;

	/** �`���[�g�̍��� */
	int chartHeight  = 0;

	// ********** ���\�b�h **********

	// �`���[�g��\��XML�����ƂɃ`���[�g�̐ݒ���s�Ȃ�
	public void createChart( Document doc ) throws IllegalAccessException, NoSuchFieldException {
		
		//�`���[�g��XML���ݒ�
		this.setChartByDoc(doc);
		
		//�`���[�g�^�C�g���̕����F��XML���ݒ�
		this.setChartTitleColorByDoc(doc);

		//�`���[�g�̃t�H���g��ݒ�
		this.setChartTitleFont(doc);
		
		//�`���[�g�w�i�F��XML���ݒ�
		this.setBackgroundColorByDoc(doc);
		
		//�r����XML���ݒ�
		this.setLegendByDoc(doc);
		
		//�v���b�g�G���A�w�i�F�̐ݒ�
		this.setPlotBackgroundColorByDoc(doc);
		
		//�_�E�܂���E�ʃ`���[�g
		if(this.getPlot() instanceof CategoryPlot) {

			//�J�e�S�����̐ݒ�
			this.setCategoryAxisByDoc(doc);

			//Series��ݒ�
			this.setSeriesAxisByDoc(doc);

//			//�h�����_�E���ݒ�
//			enableDrillDown(renderer,(DefaultCategoryDataset)helper.codeDataset);

		//�~�`���[�g
		} else if ((this.getPlot() instanceof PiePlot) ||
					 (this.getPlot() instanceof MultiplePiePlot)){

			//�v���b�g�G���A�w�i�F�ݒ�i�����~�`���[�g�p�j
			this.setMultiPiePlotBGColor(doc);
		
			//�~�`���[�g�p���x���ݒ�
			this.setPieLabel(doc);
			
			//�c�[���`�b�v�̐ݒ�
			this.setToolTipForPie(doc);
			
			//�t�H���g�̐ݒ�
			this.setPieFont(doc);
			
			//�h�����_�E���ݒ�
//			enableDrillDown(piePlot,(DefaultPieDataset)helper.codeDataset);			//�~	
//			enableDrillDown(piePlot,(DefaultCategoryDataset)helper.codeDataset);	//�����~			
			
		}

		
	}


	/**
	 *  �`���[�g���iXML�j�����ƂɁAChart�I�u�W�F�N�g����ѕ��A������ݒ肷��B
	 */
	public void setChartByDoc( Document doc ) {
		
		this.chart = createChartObject(doc);						// JFreeChart�I�u�W�F�N�g��XML�����Ƃɐ���

		this.setPlot(this.chart);							// �v���b�g��ݒ�
		this.setChartWidth(getChartWidthByDoc(doc));		// �`���[�g����XML���擾
		this.setChartHeight(getChartHeightByDoc(doc));		// �`���[�g������XML���擾
	}


	/**
	 *  �`���[�g���iXML�j�����ƂɁA�`���[�g�^�C�g���̕����F��ݒ肷��B
	 */
	public void setChartTitleColorByDoc(Document doc) {

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String titleColor    = chartInfo.getElementsByTagName("TitleColor").item(0).getFirstChild().getNodeValue();

		TextTitle title = this.getChart().getTitle();
		title.setPaint(createColor(titleColor));
		
	}

	/**
	 *  �`���[�g���iXML�j�����ƂɁA�`���[�g�^�C�g���̃t�H���g��ݒ肷��B
	 */
	public void setChartTitleFont(Document doc) throws IllegalAccessException, NoSuchFieldException {

		TextTitle title = this.getChart().getTitle();
		title.setFont(this.getFont(doc));
		
	}
	
	
	/**
	 *  �`���[�g���iXML�j�����ƂɁA�`���[�g�w�i�F��ݒ肷��B
	 */
	public void setBackgroundColorByDoc(Document doc) {
		
		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String chartBGColor  = chartInfo.getElementsByTagName("ChartBGColor").item(0).getFirstChild().getNodeValue();
		
		this.getChart().setBackgroundPaint(createColor(chartBGColor));
		
	}

	/**
	 *  �`���[�g���iXML�j�����ƂɁA�v���b�g�G���A�̔w�i�F��ݒ肷��B
	 */
	public void setPlotBackgroundColorByDoc(Document doc) {

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String plotBGColor  = chartInfo.getElementsByTagName("PlotBGColor").item(0).getFirstChild().getNodeValue();
		
		this.getChart().getPlot().setBackgroundPaint(createColor(plotBGColor));		
		
	}

	/**
	 *  �`���[�g���iXML�j�����ƂɁA�r����ݒ肷��B
	 */
	public void setLegendByDoc(Document doc) throws IllegalAccessException, NoSuchFieldException {
		
		Element root          = doc.getDocumentElement();
		Element chartInfo     = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String legendPosition = chartInfo.getElementsByTagName("LegendPosition").item(0).getFirstChild().getNodeValue();

		// �r������̏ꍇ�A�r�����ꏊ�w�肵�ĕ\��
		if (("North".equals(legendPosition)) || ("South".equals(legendPosition)) || 
		     ("East".equals(legendPosition)) ||  ("West".equals(legendPosition)) ) {
			
			StandardLegend legend = new StandardLegend();
			int legendPositionID = 0;

			if("North".equals(legendPosition)) {
				legendPositionID = Legend.NORTH;
			} else if ("South".equals(legendPosition)) {
				legendPositionID = Legend.SOUTH;
			} else if ("East".equals(legendPosition)) {
				legendPositionID = Legend.EAST;
			} else if ("West".equals(legendPosition)) {
				legendPositionID = Legend.WEST;
			}

			legend.setAnchor(legendPositionID);
			chart.setLegend(legend);
			legend.setItemFont(this.getFont(doc));
			
		// �r���Ȃ�
		} else {
			// �r����ݒ肵�Ȃ��i�\��������Ȃ��j
		}
		
	}



	/**
	 *  �`���[�g��HTML�֏o�͂���i�C���[�W��PNG�`���j
	 */
	public void outPNGChart(HttpServletRequest request, JspWriter out ) throws IOException {

		ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
		String filename = ServletUtilities.saveChartAsPNG(chart, this.chartWidth, this.chartHeight, info, request.getSession());
		String chartURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename;
		String imageMap = ChartUtilities.getImageMap("chart",info,new StandardToolTipTagFragmentGenerator(), new CustomURLTagFragmentGenerator());
		out.println("<IMG SRC=\"" + chartURL + "\" usemap=\"#chart\" />");
		out.println(imageMap);		
	}

	/**
	 *  �`���[�g��HTML�֏o�͂���i�C���[�W��JPEG�`���j
	 */
//	public void outJPEGChart( ) {
//	}


	/**
	 *  �`���[�g�̃C���[�W�𒼐ڏo�͂���i�C���[�W��PNG�`���j
	 */
	public void outDirectPNGChart(HttpServletResponse response) throws IOException {

		OutputStream out = response.getOutputStream();
		response.setContentType("image/png");
		ChartUtilities.writeChartAsPNG(out, chart, chartWidth, chartHeight);
	
	}



	/**
	 *  �J�e�S��(��)����ݒ肷�郁�\�b�h
	 */	
	public void setCategoryAxisByDoc(Document doc) throws IllegalAccessException, NoSuchFieldException {

		Element root              = doc.getDocumentElement();
		Element category          = (Element)root.getElementsByTagName("Category").item(0);
		String categoryLabelColor = category.getElementsByTagName("LabelColor").item(0).getFirstChild().getNodeValue();

		CategoryPlot categoryPlot = (CategoryPlot)this.getPlot();
		CategoryAxis categoryAxis = categoryPlot.getDomainAxis(); //���̎擾
		categoryAxis.setLabelPaint(this.createColor(categoryLabelColor)); //�J�e�S�����x���J���[

		categoryAxis.setLabelFont(this.getFont(doc)); //�t�H���g
		categoryAxis.setTickLabelFont(this.getFont(doc)); //Tick���x���t�H���g
	}

	/**
	 *  �V���[�Y(�c)����ݒ肷�郁�\�b�h
	 */	
	public void setSeriesAxisByDoc(Document doc) throws IllegalAccessException, NoSuchFieldException {

		CategoryPlot categoryPlot = (CategoryPlot)this.getPlot();

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);

		// �f�[�^�Z�b�g���X�g
		ArrayList<Dataset> dataSetList = this.getDataSetList();
		int listSize = dataSetList.size();

		// �f�[�^�Z�b�g�̐��������[�v
		for(int i = 0; i < listSize; i++) {

			//�v���b�g��2�Ԗڈȍ~�̃f�[�^�Z�b�g��ǉ�
			//�i1�Ԗڂ̃f�[�^�Z�b�g�́AChartFactory.create** ���\�b�h�Ń`���[�g�I�u�W�F�N�g�쐬���ɒǉ��ς݁j
			if (i != 0) {
				DefaultCategoryDataset subDataset = (DefaultCategoryDataset)dataSetList.get(i);
				categoryPlot.setDataset(i,subDataset);

				//�f�[�^�Z�b�g���V���[�Y���ɒǉ�
				categoryPlot.mapDatasetToRangeAxis(i,1);
			}


			//�V���[�Y����ValueAxis�I�u�W�F�N�g�����x���w��Ő���
			Element series = (Element)chartInfo.getElementsByTagName("Series").item(i);
			String seriesLabel = series.getElementsByTagName("Label").item(0).getFirstChild().getNodeValue();

			ValueAxis valueAxis = null;
			if (i == 0) {
				valueAxis = categoryPlot.getRangeAxis();
			} else {
				valueAxis = new NumberAxis(seriesLabel); 
			}
			
			//�V���[�Y���̃��x���J���[�A�t�H���g��ݒ�
			String seriesLabelColor   = series.getElementsByTagName("LabelColor").item(0).getFirstChild().getNodeValue();
			valueAxis.setLabelPaint(this.createColor(seriesLabelColor)); //�V���[�Y���x���J���[
			valueAxis.setLabelFont(this.getFont(doc)); //�t�H���g
			valueAxis.setTickLabelFont(this.getFont(doc)); //Tick���x���t�H���g

			String isAutoRangeEnable  = series.getElementsByTagName("isAutoRangeEnable").item(0).getFirstChild().getNodeValue();
			//�V���[�Y�����W�蓮�ݒ�
			if("0".equals(isAutoRangeEnable)) {

				String maxRange           = series.getElementsByTagName("MaxRange").item(0).getFirstChild().getNodeValue();
				String minRange           = series.getElementsByTagName("MinRange").item(0).getFirstChild().getNodeValue();

				//�����W�ő�l
				valueAxis.setUpperBound(Double.parseDouble(maxRange));

				//�����W�ŏ��l
				valueAxis.setLowerBound(Double.parseDouble(minRange));

			}

			//�v���b�g�ɐ��������V���[�Y����ݒ�
			if (i != 0) {
				categoryPlot.setRangeAxis(i, valueAxis);
			}

			//�����_���[���擾			
			CategoryItemRenderer renderer = null;
			if (i == 0) {
				renderer = this.createRenderer("byPlot");
			} else {
				renderer = this.createRenderer("create");
			}

			//�c�[���`�b�v�쐬
			setToolTip(doc, renderer);


//			//�h�����_�E���ݒ�
//			enableDrillDown(LSRenderer,(DefaultCategoryDataset)helper.codeDatasetList.elementAt(i));

			if (i != 0) {
				categoryPlot.setRenderer(i,renderer); //�I���W�i���̃v���b�g�Ƀ����_���[��ǉ�
				categoryPlot.setDatasetRenderingOrder(DatasetRenderingOrder.REVERSE);
			}

		}
		//���[�v�I��
	}


	/**
	 * �~�O���t�p�̃��x���ݒ胁�\�b�h
	 * @param doc XML����(JFreeChart�pXML�h�L�������g)
	 */
	public void setPieLabel(Document doc) {

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String hasPieLabel     = chartInfo.getElementsByTagName("hasPieLabel").item(0).getFirstChild().getNodeValue();
		
		// �~�O���t�p�̃��x�����u��\���v�ɐݒ�
		String falseString = Boolean.FALSE.toString();
		if ("0".equals(hasPieLabel)) {

			PiePlot piePlot = this.getPiePlot();								
			piePlot.setLabelGenerator(null);

		} else {
			// �~�O���t�̃f�t�H���g���x���ݒ�́u�\���v�ł��邽�߁A�������Ȃ��Ă悢
		}
		
	}


	/**
	 *  �_�E�܂���E�ʃ`���[�g�p�c�[���`�b�v�ݒ胁�\�b�h
	 *  @param doc XML����(JFreeChart�pXML�h�L�������g)
	 *  @param renderer �����_���[�I�u�W�F�N�g
	 */	
	public void setToolTip(Document doc, CategoryItemRenderer renderer) {

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String hasToolTip      = chartInfo.getElementsByTagName("hasToolTip").item(0).getFirstChild().getNodeValue();

		// �c�[���`�b�v�L��
		if ("1".equals(hasToolTip)){
			renderer.setToolTipGenerator(new StandardCategoryToolTipGenerator());
		}

		// �c�[���`�b�v����
		else {
			// �������Ȃ��i�c�[���`�b�v�\�����Ȃ��j
		}

	}

	/**
	 *  �~�`���[�g�p�c�[���`�b�v�ݒ胁�\�b�h
	 */	
	public void setToolTipForPie(Document doc) {

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String hasToolTip      = chartInfo.getElementsByTagName("hasToolTip").item(0).getFirstChild().getNodeValue();

		// �c�[���`�b�v�L��
		if ("1".equals(hasToolTip)){
			PiePlot piePlot = this.getPiePlot();
			piePlot.setToolTipGenerator(new StandardPieItemLabelGenerator());
		}

		// �c�[���`�b�v����
		else {
			// �������Ȃ��i�c�[���`�b�v�\�����Ȃ��j
		}

	}


	/**
	 *  �~�`���[�g�p�c�[���`�b�v�ݒ胁�\�b�h
	 */	
	public void setPieFont(Document doc) throws IllegalAccessException, NoSuchFieldException {

		//���x���t�H���g�̐ݒ�
		PiePlot piePlot = this.getPiePlot();
		piePlot.setLabelFont(this.getFont(doc));

		//�T�u�`���[�g�̃^�C�g���t�H���g�̐ݒ�
		if(this.getPlot() instanceof MultiplePiePlot) {	// �����~�`���[�g�̏ꍇ
			JFreeChart subChart = this.getSubPieChart();
			TextTitle subChartTitle = subChart.getTitle();
			subChartTitle.setFont(this.getFont(doc)); //�T�u�`���[�g�̃^�C�g���t�H���g(���W���[��)
		}

	}
	
	/**
	 *  �v���b�g�G���A�w�i�F�ݒ�i�����~�`���[�g�p�j
	 */	
	public void setMultiPiePlotBGColor(Document doc) {
		
		if (this.getPlot() instanceof MultiplePiePlot) {
			PiePlot piePlot = (PiePlot)this.getPiePlot();

			//�v���b�g�G���A�w�i�F�ݒ�
			Element root         = doc.getDocumentElement();
			Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
			String plotBGColor   = chartInfo.getElementsByTagName("MultiPiePlotBGColor").item(0).getFirstChild().getNodeValue();
		
			piePlot.setBackgroundPaint(createColor(plotBGColor)); 

		}
		
	}


	/**
	 *  �����_���[�擾���\�b�h(�_�E�܂���E�ʃ`���[�g�p)
	 *  @param mode �����_���[��V�K�Ő������邩�A�v���b�g���擾���邩
	 * 				 �l�F�ucreate�v �����_���[��V�K����
	 * 				 �l�F�ubyPlot�v �����_���[���v���b�g���擾
	 */	
	public CategoryItemRenderer createRenderer(String mode) {
		if ( (!"create".equals(mode)) && (!"byPlot".equals(mode)) ) {
			throw new IllegalArgumentException();
		}

		CategoryPlot categoryPlot = (CategoryPlot)this.getPlot();
		CategoryItemRenderer renderer = null;

		//�_�`���[�g(Series���Ɋւ��Ȃ�)
		if(this.chartType.equals("VerticalBar") || this.chartType.equals("HorizontalBar") ||
			this.chartType.equals("VerticalMultiBar") || this.chartType.equals("HorizontalMultiBar")) {

			if ("create".equals(mode)) {
				renderer = new BarRenderer();
			} else if ("byPlot".equals(mode)) {
				renderer = (BarRenderer)categoryPlot.getRenderer();
			}
		}

		//3D�_�`���[�g(Series���Ɋւ��Ȃ�)
		else if (this.chartType.equals("Vertical3D_Bar") || this.chartType.equals("Horizontal3D_Bar") ||
				  this.chartType.equals("VerticalMulti3D_Bar") || this.chartType.equals("HorizontalMulti3D_Bar")) {

			if ("create".equals(mode)) {
				renderer = new BarRenderer3D();
			}  else if ("byPlot".equals(mode)) {
				renderer = (BarRenderer3D)categoryPlot.getRenderer();
			}
				
		}

		//�ςݏグ�_�`���[�g(Series���Ɋւ��Ȃ�)
		else if(this.chartType.equals("VerticalStackedBar") || this.chartType.equals("HorizontalStackedBar")) {

			if ("create".equals(mode)) {
				renderer = new StackedBarRenderer();
			} else if ("byPlot".equals(mode)) {
				renderer = (StackedBarRenderer)categoryPlot.getRenderer();
			}
		}

		//3D�ςݏグ�_�`���[�g(Series���Ɋւ��Ȃ�)
		else if(this.chartType.equals("VerticalStacked3D_Bar") || this.chartType.equals("HorizontalStacked3D_Bar")) {

			if ("create".equals(mode)) {
				renderer = new StackedBarRenderer3D();
			} else if ("byPlot".equals(mode)) {
				renderer = (StackedBarRenderer3D)categoryPlot.getRenderer();
			}
		}

		//�܂���`���[�g(Series���Ɋւ��Ȃ�)
		else if((this.chartType.equals("Line")) || (this.chartType.equals("MultiLine"))) {

			//�ړ_��\�����邽�߂̃����_���[
			LineAndShapeRenderer tempRenderer = null;
			if ("create".equals(mode)) {
				tempRenderer = new LineAndShapeRenderer();
			} else if ("byPlot".equals(mode)) {
				tempRenderer = (LineAndShapeRenderer)categoryPlot.getRenderer();
			}

			//�܂����Category�Ƃ̌�_�Ɉ�i�ہA�O�p�A�l�p�Ȃǁj��\������悤�ɐݒ�
			tempRenderer.setDrawShapes(true); 
		
			renderer = tempRenderer;

		}

		//�ʃ`���[�g(Series���Ɋւ��Ȃ�)
		else if((this.chartType.equals("Area")) || (this.chartType.equals("MultiArea"))) {

			if ("create".equals(mode)) {
				renderer = new AreaRenderer();
			} else if ("byPlot".equals(mode)) {
				renderer = (AreaRenderer)categoryPlot.getRenderer();
			}
		}

		//�ςݏグ�ʃ`���[�g(Series���Ɋւ��Ȃ�)
		else if(this.chartType.equals("StackedArea")) {

			if ("create".equals(mode)) {
				renderer = new StackedAreaRenderer();
			} else if ("byPlot".equals(mode)) {
				renderer = (StackedAreaRenderer)categoryPlot.getRenderer();
			}
		}

		return renderer;

	}



	/**
	 *  �F��\����������Ajava.awt.Color�I�u�W�F�N�g���擾����
	 */
	public Color createColor(String selectedColor) {

		Color color = null;

		if(("Black").equals(selectedColor)) {

			color = Color.black;

		}
		else if(("Blue").equals(selectedColor)) {

			color = Color.blue;

		}
		else if(("Cyan").equals(selectedColor)) {

			color = Color.cyan;

		}
		else if(("DarkGray").equals(selectedColor)) {

			color = Color.darkGray;

		}
		else if(("Gray").equals(selectedColor)) {

			color = Color.gray;

		}
		else if(("Green").equals(selectedColor)) {

			color = Color.green;

		}
		else if(("LightGray").equals(selectedColor)) {

			color = Color.lightGray;

		}
		else if(("Orange").equals(selectedColor)) {

			color = Color.orange;

		}
		else if(("Pink").equals(selectedColor)) {

			color = Color.pink;

		}
		else if(("Red").equals(selectedColor)) {

			color = Color.red;

		}
		else if(("Yellow").equals(selectedColor)) {

			color = Color.yellow;

		}
		else if(("White").equals(selectedColor)){

			color = Color.white;

		}
		
		// RGB�F�̏ꍇ
		else {

			StringTokenizer st = new StringTokenizer(selectedColor,",");
			if (st.countTokens() != 3) {
				throw new IllegalArgumentException();
			}

			int rgb[] = new int[3];	// RGB������킷���l�̔z��
			int i = 0;

			while ( st.hasMoreTokens() ) {
				rgb[i] = Integer.parseInt(st.nextToken());
				i++;	
			}

			color = new Color(rgb[0],rgb[1],rgb[2]);
		}

		return color;

	}


	// ********** private���\�b�h **********

	/**
	 *  �^����ꂽXML�h�L�������g�Ŏw�肳�ꂽ�t�H���g������킷 java.awt.Font �I�u�W�F�N�g���擾����
	 */
	private Font getFont( Document doc ) throws IllegalAccessException, NoSuchFieldException {

		Font font = null;

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);

		//�t�H���g�I�u�W�F�N�g�𐶐�
		
		//  �t�H���g��
		String fontName = chartInfo.getElementsByTagName("FontName").item(0).getFirstChild().getNodeValue();

		//  �t�H���g�T�C�Y
		int fontSize = Integer.parseInt(chartInfo.getElementsByTagName("FontSize").item(0).getFirstChild().getNodeValue());

		//  �t�H���g�X�^�C��
		//  XML�ŗ^����ꂽ�t�H���g�X�^�C�����i��F�uBOLD�v�A�uITALIC�v�A�uBOLD,ITALIC�v etc�j
		String fontStyleNames = chartInfo.getElementsByTagName("FontStyle").item(0).getFirstChild().getNodeValue();

		int fontStyle = 0; // (�����l OR �u�l�v) = �u�l�v�ƂȂ鏉���l�́A�u0�v  ���P�Q��
		try {

			//�����̃t�H���g�X�^�C����XML�Ŏw�肳�ꂽ�ꍇ�A�r�b�g���Z�i�_���a�j�ɂ��A�X�^�C���l(int)�����߂�
			StringTokenizer st = new StringTokenizer(fontStyleNames,",");

			//Static�ϐ����擾���邽�߂ɍ쐬����Font�I�u�W�F�N�g
			Font dummyFont = new Font(fontName, Font.PLAIN, fontSize);
			while ( st.hasMoreTokens() ) {

				//���t���N�V�����ɂ��AFont�N���X��static�t�B�[���h�̒l�����߁A�_���a�����߂� ���P
				fontStyle =	fontStyle | Font.class.getField(st.nextToken()).getInt(dummyFont);
			}

			//�t�H���g�I�u�W�F�N�g����
			font = new Font(fontName, fontStyle, fontSize);

		} catch (IllegalArgumentException e) {
			throw e;
		} catch (SecurityException e) {
			throw e;
		} catch (IllegalAccessException e) {
			throw e;
		} catch (NoSuchFieldException e) {
			throw e;
		}

		return font;
	
	}



	/**
	 *  �^����ꂽXML�h�L�������g���A"Dataset"�I�u�W�F�N�g�̔z��(ArrayList)���擾����
	 */
	private ArrayList<Dataset> getDatasetList( Document doc ) {

		ArrayList<Dataset> dataSetList = new ArrayList<Dataset>();

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);

		NodeList dataSetNodeList = root.getElementsByTagName("DataSet");


		Dataset dataset = null;
		// XML��"DataSetList"�v�f���ɂ���"DataSet"�v�f�̐������܂��
		for (int i = 0; i < dataSetNodeList.getLength(); i++){
			Element firstDataSet = (Element)dataSetNodeList.item(i);
			NodeList dataList    = firstDataSet.getElementsByTagName("Data");

			// �f�[�^�Z�b�g�̏������i�~�`���[�g�A�R�c�~�`���[�g�j
			if( (this.chartType.equals("Pie")) || (this.chartType.equals("Pie_3D"))) {

				dataset = new DefaultPieDataset();
	
			// �f�[�^�Z�b�g�̏������i����ȊO�̃`���[�g(���A�_�A�ʁA����ѕ���Series�����~�`���[�g)�j
			} else {

				// �����~�`���[�g�̏ꍇ�́AXML�ɂ��镡����"DataSet"�v�f����"Data"�v�f���A���Java "Dataset"�I�u�W�F�N�g��
				// �i�[���邽�߁Adataset�̐V�K�쐬�������s�Ȃ�Ȃ�
				// �������A�_�A�ʃ`���[�g�̏ꍇ�́AXML��"DataSet"���� Java "Dataset"�I�u�W�F�N�g�����������
				if  ( (!this.chartType.equals("MultiPie")) || ( i == 0)) {
					dataset = new DefaultCategoryDataset();
				}
			}
	
			// XML��"DataSet"�v�f(��O����for���[�v�őI������Ă������)���ɂ���"Data"�v�f�̐������܂��
			for ( int j = 0; j < dataList.getLength(); j++ ) {
	
				Element data = (Element)dataList.item(j);
	
				Number value = new Double(data.getElementsByTagName("Value").item(0).getFirstChild().getNodeValue());
	
				String categoryAxisName = categoryAxisName = data.getElementsByTagName("CategoryAxisName").item(0).getFirstChild().getNodeValue();
				String seriesAxisName   =   null;
	
				// �~�`���[�g�A�R�c�~�`���[�g
				if( (this.chartType.equals("Pie")) || (this.chartType.equals("Pie_3D"))) {
					((DefaultPieDataset)dataset).setValue(categoryAxisName, value);
	
				// ����ȊO�̃`���[�g(���A�_�A�ʃ`���[�g(Series���Ɋւ��Ȃ�)����сA����Series�����~�`���[�g)
				} else {
					if ( data.getElementsByTagName("ValueAxisName").item(0).getFirstChild() != null ) {
						seriesAxisName = data.getElementsByTagName("ValueAxisName").item(0).getFirstChild().getNodeValue();
					}
					((DefaultCategoryDataset)dataset).addValue(value, seriesAxisName, categoryAxisName);
				}
			}
		
			// �����~�`���[�g�̏ꍇ�́AXML�ɂ��镡����"DataSet"�v�f����"Data"�v�f���A���Java "Dataset"�I�u�W�F�N�g��
			// �i�[���邽�߁Adataset��dataSetList�ւ̓o�^�͑S�f�[�^���f�[�^�Z�b�g�ɓo�^��̈�x�̂ݍs�Ȃ��B
			if  ( (!this.chartType.equals("MultiPie")) || ( i == (dataSetNodeList.getLength()-1))) {
				dataSetList.add(dataset);
			}
		
		}
		
		return dataSetList;
		
	}

	/**
	 *  JFreeChart�I�u�W�F�N�g���쐬����
	 */
	private JFreeChart createChartObject( Document doc ) {

		Element root            = doc.getDocumentElement();
		Element chartInfo       = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String chartTitle       = chartInfo.getElementsByTagName("Title").item(0).getFirstChild().getNodeValue();
		this.chartType        = chartInfo.getElementsByTagName("Type").item(0).getFirstChild().getNodeValue();
		String categoryLabel    = ((Element)chartInfo.getElementsByTagName("Category").item(0)).getElementsByTagName("Label").item(0).getFirstChild().getNodeValue();
		
		Element firstSeries     = (Element)((Element)chartInfo.getElementsByTagName("SeriesList").item(0)).getElementsByTagName("Series").item(0);
		String firstSeriesLabel = firstSeries.getElementsByTagName("Label").item(0).getFirstChild().getNodeValue();
		
		// �f�[�^�Z�b�g�̃��X�g���擾
		this.dataSetList = this.getDatasetList(doc);
		
		
		//�_�`���[�g(Series���Ɋւ��Ȃ�)
		if(this.chartType.equals("VerticalBar") || this.chartType.equals("HorizontalBar") ||
			this.chartType.equals("VerticalMultiBar") || this.chartType.equals("HorizontalMultiBar")) {

			chart = ChartFactory.createBarChart(
												chartTitle,
												categoryLabel,
												firstSeriesLabel,
												(CategoryDataset)this.dataSetList.get(0),
												getLayoutFromDoc(doc),
												false,
												false,
												false
												);


		}

		//3D�_�`���[�g(Series���Ɋւ��Ȃ�)
		else if (this.chartType.equals("Vertical3D_Bar") || this.chartType.equals("Horizontal3D_Bar") ||
				  this.chartType.equals("VerticalMulti3D_Bar") || this.chartType.equals("HorizontalMulti3D_Bar")) {
				
			chart = ChartFactory.createBarChart3D(
													chartTitle,
													categoryLabel,
													firstSeriesLabel,
													(CategoryDataset)this.dataSetList.get(0),
													getLayoutFromDoc(doc),
													false,
													false,
													false
												 );
		}

		//�ςݏグ�_�`���[�g
		else if((this.chartType.equals("VerticalStackedBar")) || (this.chartType.equals("HorizontalStackedBar"))) {

				chart = ChartFactory.createStackedBarChart(
														chartTitle,
														categoryLabel,
														firstSeriesLabel,
														(CategoryDataset)this.dataSetList.get(0),
														getLayoutFromDoc(doc),
														false,
														false,
														false
													);

		}

		//3D�ςݏグ�_�`���[�g
		else if((this.chartType.equals("VerticalStacked3D_Bar")) || (this.chartType.equals("HorizontalStacked3D_Bar"))) {

				chart = ChartFactory.createStackedBarChart3D(
														chartTitle,
														categoryLabel,
														firstSeriesLabel,
														(CategoryDataset)this.dataSetList.get(0),
														getLayoutFromDoc(doc),
														false,
														false,
														false
													);

		}

		//�܂���`���[�g(Series���Ɋւ��Ȃ�)
		else if((this.chartType.equals("Line")) || (this.chartType.equals("MultiLine"))) {

				chart = ChartFactory.createLineChart(
														chartTitle,
														categoryLabel,
														firstSeriesLabel,
														(CategoryDataset)this.dataSetList.get(0),
														PlotOrientation.VERTICAL,
														false,
														false,
														false
													);

		}


		//�ʃ`���[�g(Series���Ɋւ��Ȃ�)
		else if((this.chartType.equals("Area")) || (this.chartType.equals("MultiArea"))) {

				chart = ChartFactory.createAreaChart(
														chartTitle,
														categoryLabel,
														firstSeriesLabel,
														(CategoryDataset)this.dataSetList.get(0),
														PlotOrientation.VERTICAL,
														false,
														false,
														false
													);

		}
		
		//�ςݏグ�ʃ`���[�g
		else if(this.chartType.equals("StackedArea")) {

				chart = ChartFactory.createStackedAreaChart(
														chartTitle,
														categoryLabel,
														firstSeriesLabel,
														(CategoryDataset)this.dataSetList.get(0),
														PlotOrientation.VERTICAL,
														false,
														false,
														false
													);

		}

		//�~�`���[�g(Series���Ɋւ��Ȃ�)
		else if(this.chartType.equals("Pie")) {

			chart = ChartFactory.createPieChart(
													chartTitle,
													(PieDataset)this.dataSetList.get(0),
													false,
													false,
													false 
												);


		}

 
		//3D�~�`���[�g(Series���Ɋւ��Ȃ�)
		else if(this.chartType.equals("Pie_3D")) {
  
			chart = ChartFactory.createPieChart3D(
													chartTitle,
													(PieDataset)this.dataSetList.get(0),
													false,
													false,
													false 
												 );


		}


		//�����~�`���[�g(Series�����Q�ȏ�)
		else if(this.chartType.equals("MultiPie")) {

				//�����~�`���[�g
				chart = ChartFactory.createMultiplePieChart(
																chartTitle,
																(CategoryDataset)this.dataSetList.get(0),
																TableOrder.BY_ROW,
																false,
																false,
																false
															);

		}

		return chart;

	}


	/**
	 *  �~�`���[�g�p�̃v���b�g���擾����
	 */	
	private PiePlot getPiePlot() {

		PiePlot piePlot = null;

		// �����~�`���[�g�̏ꍇ
		if(this.getPlot() instanceof MultiplePiePlot) {
				
			//�T�u�`���[�g�̐���
			JFreeChart subChart = this.getSubPieChart();
			piePlot = (PiePlot)subChart.getPlot();
		
		// �~�`���[�g�̏ꍇ	
		} else {
			piePlot = (PiePlot)this.getPlot();
		}
		
		return piePlot;
	}


	/**
	 *  �����~�`���[�g�p�̃T�u�`���[�g���擾����
	 */	
	private JFreeChart getSubPieChart(){
		
		MultiplePiePlot multiplePiePlot = (MultiplePiePlot)this.getPlot();
				
		//�T�u�`���[�g�̐���
		JFreeChart subChart = multiplePiePlot.getPieChart();
		
		return subChart;
		
	}



	/**
	 *  XML���`���[�g�̕����擾����
	 */
	private int getChartWidthByDoc( Document doc ) {

		Element root   = doc.getDocumentElement();
		int chartWidth = Integer.parseInt(root.getElementsByTagName("ChartWidth").item(0).getFirstChild().getNodeValue());

		return chartWidth;
	}

	/**
	 *  XML���`���[�g�̍������擾����
	 */
	private int getChartHeightByDoc( Document doc ) {

		Element root   = doc.getDocumentElement();
		int chartHeight = Integer.parseInt(root.getElementsByTagName("ChartHeight").item(0).getFirstChild().getNodeValue());
		
		return chartHeight;
	}

	/**
	 *  XML���`���[�g���C�A�E�g���擾����
	 */
	private PlotOrientation getLayoutFromDoc( Document doc ) {
		
		// �`���[�g���C�A�E�g���c�^
		if ((this.chartType.equals("VerticalBar")) || 
		     (this.chartType.equals("Vertical3D_Bar")) || 
		     (this.chartType.equals("VerticalMultiBar")) || 
		     (this.chartType.equals("VerticalMulti3D_Bar")) ||
		     (this.chartType.equals("VerticalStackedBar")) ||
		     (this.chartType.equals("VerticalStacked3D_Bar"))) 
		{
			return PlotOrientation.VERTICAL;
					
		// �`���[�g���C�A�E�g�����^
		} else if((this.chartType.equals("HorizontalBar")) || 
		           (this.chartType.equals("Horizontal3D_Bar")) ||
		           (this.chartType.equals("HorizontalMultiBar")) || 
		           (this.chartType.equals("HorizontalMulti3D_Bar")) ||
				   (this.chartType.equals("HorizontalStackedBar")) ||
				   (this.chartType.equals("HorizontalStacked3D_Bar"))) 
		           
		{
			return PlotOrientation.HORIZONTAL;

		// ����ȊO�̏ꍇ�F�G���[
		} else {
			throw new IllegalStateException();
		}
		
	}


	// ********** Setter ���\�b�h **********
	
	/**
	 *  �v���b�g��ݒ肷��
	 */
	private void setPlot(JFreeChart chart) {

		// �~�`���[�g�A�R�c�~�`���[�g
		if((this.chartType.equals("Pie")) || (this.chartType.equals("Pie_3D"))){
			this.plot = (PiePlot)chart.getPlot();

		// �����~�`���[�g�A�����R�c�~�`���[�g
		} else if (this.chartType.equals("MultiPie")) {
			this.plot = (MultiplePiePlot)chart.getPlot();

		// ���̑��`���[�g���ʃv���b�g
		} else {
			this.plot = chart.getCategoryPlot();
		}

	}
	
	
	/**
	 *  �`���[�g�̕���ݒ肷��
	 */
	private void setChartWidth(int chartWidth) {
		this.chartWidth = chartWidth;
	}

	/**
	 *  �`���[�g�̍�����ݒ肷��
	 */	
	private void setChartHeight(int chartHeight) {
		this.chartHeight = chartHeight;
	}
	
	// ********** Getter ���\�b�h **********

	/**
	 *  �`���[�g�I�u�W�F�N�g���擾����
	 */
	public JFreeChart getChart() {
		return this.chart;
	}	

	/**
	 *  �`���[�g�̃v���b�g�I�u�W�F�N�g���擾����
	 */
	public Plot getPlot() {
		return this.plot;
	}	

	/**
	 *  �`���[�g�^�C�v���擾����
	 */
	public String getChartType() {
		return this.chartType;
	}	
	
	/**
	 *  �f�[�^�Z�b�g���X�g���擾����
	 */
	public ArrayList<Dataset> getDataSetList() {
		return this.dataSetList;
	}	

	

	/**
	 *  �`���[�g�̕����擾����
	 */
	public int getChartWidth() {
		return this.chartWidth;
	}

	/**
	 *  �`���[�g�̍������擾����
	 */	
	public int getChartHeight() {
		return this.chartHeight;
	}

}
