/*
 * 作成日: 2004/07/26
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

	// ********** インスタンス変数 **********

	/** チャートオブジェクト */
	JFreeChart chart = null;

	/** チャートのプロット*/
	Plot plot = null;

	/** チャートタイプ*/
	String chartType = null;

	/** データセットの配列   */
	ArrayList<Dataset> dataSetList = null;

	/** チャートの幅   */
	int chartWidth   = 0;

	/** チャートの高さ */
	int chartHeight  = 0;

	// ********** メソッド **********

	// チャートを表すXMLをもとにチャートの設定を行なう
	public void createChart( Document doc ) throws IllegalAccessException, NoSuchFieldException {
		
		//チャートをXMLより設定
		this.setChartByDoc(doc);
		
		//チャートタイトルの文字色をXMLより設定
		this.setChartTitleColorByDoc(doc);

		//チャートのフォントを設定
		this.setChartTitleFont(doc);
		
		//チャート背景色をXMLより設定
		this.setBackgroundColorByDoc(doc);
		
		//脚注をXMLより設定
		this.setLegendByDoc(doc);
		
		//プロットエリア背景色の設定
		this.setPlotBackgroundColorByDoc(doc);
		
		//棒・折れ線・面チャート
		if(this.getPlot() instanceof CategoryPlot) {

			//カテゴリ軸の設定
			this.setCategoryAxisByDoc(doc);

			//Seriesを設定
			this.setSeriesAxisByDoc(doc);

//			//ドリルダウン設定
//			enableDrillDown(renderer,(DefaultCategoryDataset)helper.codeDataset);

		//円チャート
		} else if ((this.getPlot() instanceof PiePlot) ||
					 (this.getPlot() instanceof MultiplePiePlot)){

			//プロットエリア背景色設定（複数円チャート用）
			this.setMultiPiePlotBGColor(doc);
		
			//円チャート用ラベル設定
			this.setPieLabel(doc);
			
			//ツールチップの設定
			this.setToolTipForPie(doc);
			
			//フォントの設定
			this.setPieFont(doc);
			
			//ドリルダウン設定
//			enableDrillDown(piePlot,(DefaultPieDataset)helper.codeDataset);			//円	
//			enableDrillDown(piePlot,(DefaultCategoryDataset)helper.codeDataset);	//複数円			
			
		}

		
	}


	/**
	 *  チャート情報（XML）をもとに、Chartオブジェクトおよび幅、高さを設定する。
	 */
	public void setChartByDoc( Document doc ) {
		
		this.chart = createChartObject(doc);						// JFreeChartオブジェクトをXMLをもとに生成

		this.setPlot(this.chart);							// プロットを設定
		this.setChartWidth(getChartWidthByDoc(doc));		// チャート幅をXMLより取得
		this.setChartHeight(getChartHeightByDoc(doc));		// チャート高さをXMLより取得
	}


	/**
	 *  チャート情報（XML）をもとに、チャートタイトルの文字色を設定する。
	 */
	public void setChartTitleColorByDoc(Document doc) {

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String titleColor    = chartInfo.getElementsByTagName("TitleColor").item(0).getFirstChild().getNodeValue();

		TextTitle title = this.getChart().getTitle();
		title.setPaint(createColor(titleColor));
		
	}

	/**
	 *  チャート情報（XML）をもとに、チャートタイトルのフォントを設定する。
	 */
	public void setChartTitleFont(Document doc) throws IllegalAccessException, NoSuchFieldException {

		TextTitle title = this.getChart().getTitle();
		title.setFont(this.getFont(doc));
		
	}
	
	
	/**
	 *  チャート情報（XML）をもとに、チャート背景色を設定する。
	 */
	public void setBackgroundColorByDoc(Document doc) {
		
		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String chartBGColor  = chartInfo.getElementsByTagName("ChartBGColor").item(0).getFirstChild().getNodeValue();
		
		this.getChart().setBackgroundPaint(createColor(chartBGColor));
		
	}

	/**
	 *  チャート情報（XML）をもとに、プロットエリアの背景色を設定する。
	 */
	public void setPlotBackgroundColorByDoc(Document doc) {

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String plotBGColor  = chartInfo.getElementsByTagName("PlotBGColor").item(0).getFirstChild().getNodeValue();
		
		this.getChart().getPlot().setBackgroundPaint(createColor(plotBGColor));		
		
	}

	/**
	 *  チャート情報（XML）をもとに、脚注を設定する。
	 */
	public void setLegendByDoc(Document doc) throws IllegalAccessException, NoSuchFieldException {
		
		Element root          = doc.getDocumentElement();
		Element chartInfo     = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String legendPosition = chartInfo.getElementsByTagName("LegendPosition").item(0).getFirstChild().getNodeValue();

		// 脚注ありの場合、脚注を場所指定して表示
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
			
		// 脚注なし
		} else {
			// 脚注を設定しない（表示もされない）
		}
		
	}



	/**
	 *  チャートをHTMLへ出力する（イメージはPNG形式）
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
	 *  チャートをHTMLへ出力する（イメージはJPEG形式）
	 */
//	public void outJPEGChart( ) {
//	}


	/**
	 *  チャートのイメージを直接出力する（イメージはPNG形式）
	 */
	public void outDirectPNGChart(HttpServletResponse response) throws IOException {

		OutputStream out = response.getOutputStream();
		response.setContentType("image/png");
		ChartUtilities.writeChartAsPNG(out, chart, chartWidth, chartHeight);
	
	}



	/**
	 *  カテゴリ(横)軸を設定するメソッド
	 */	
	public void setCategoryAxisByDoc(Document doc) throws IllegalAccessException, NoSuchFieldException {

		Element root              = doc.getDocumentElement();
		Element category          = (Element)root.getElementsByTagName("Category").item(0);
		String categoryLabelColor = category.getElementsByTagName("LabelColor").item(0).getFirstChild().getNodeValue();

		CategoryPlot categoryPlot = (CategoryPlot)this.getPlot();
		CategoryAxis categoryAxis = categoryPlot.getDomainAxis(); //軸の取得
		categoryAxis.setLabelPaint(this.createColor(categoryLabelColor)); //カテゴリラベルカラー

		categoryAxis.setLabelFont(this.getFont(doc)); //フォント
		categoryAxis.setTickLabelFont(this.getFont(doc)); //Tickラベルフォント
	}

	/**
	 *  シリーズ(縦)軸を設定するメソッド
	 */	
	public void setSeriesAxisByDoc(Document doc) throws IllegalAccessException, NoSuchFieldException {

		CategoryPlot categoryPlot = (CategoryPlot)this.getPlot();

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);

		// データセットリスト
		ArrayList<Dataset> dataSetList = this.getDataSetList();
		int listSize = dataSetList.size();

		// データセットの数だけループ
		for(int i = 0; i < listSize; i++) {

			//プロットに2番目以降のデータセットを追加
			//（1番目のデータセットは、ChartFactory.create** メソッドでチャートオブジェクト作成時に追加済み）
			if (i != 0) {
				DefaultCategoryDataset subDataset = (DefaultCategoryDataset)dataSetList.get(i);
				categoryPlot.setDataset(i,subDataset);

				//データセットをシリーズ軸に追加
				categoryPlot.mapDatasetToRangeAxis(i,1);
			}


			//シリーズ軸のValueAxisオブジェクトをラベル指定で生成
			Element series = (Element)chartInfo.getElementsByTagName("Series").item(i);
			String seriesLabel = series.getElementsByTagName("Label").item(0).getFirstChild().getNodeValue();

			ValueAxis valueAxis = null;
			if (i == 0) {
				valueAxis = categoryPlot.getRangeAxis();
			} else {
				valueAxis = new NumberAxis(seriesLabel); 
			}
			
			//シリーズ軸のラベルカラー、フォントを設定
			String seriesLabelColor   = series.getElementsByTagName("LabelColor").item(0).getFirstChild().getNodeValue();
			valueAxis.setLabelPaint(this.createColor(seriesLabelColor)); //シリーズラベルカラー
			valueAxis.setLabelFont(this.getFont(doc)); //フォント
			valueAxis.setTickLabelFont(this.getFont(doc)); //Tickラベルフォント

			String isAutoRangeEnable  = series.getElementsByTagName("isAutoRangeEnable").item(0).getFirstChild().getNodeValue();
			//シリーズレンジ手動設定
			if("0".equals(isAutoRangeEnable)) {

				String maxRange           = series.getElementsByTagName("MaxRange").item(0).getFirstChild().getNodeValue();
				String minRange           = series.getElementsByTagName("MinRange").item(0).getFirstChild().getNodeValue();

				//レンジ最大値
				valueAxis.setUpperBound(Double.parseDouble(maxRange));

				//レンジ最小値
				valueAxis.setLowerBound(Double.parseDouble(minRange));

			}

			//プロットに生成したシリーズ軸を設定
			if (i != 0) {
				categoryPlot.setRangeAxis(i, valueAxis);
			}

			//レンダラーを取得			
			CategoryItemRenderer renderer = null;
			if (i == 0) {
				renderer = this.createRenderer("byPlot");
			} else {
				renderer = this.createRenderer("create");
			}

			//ツールチップ作成
			setToolTip(doc, renderer);


//			//ドリルダウン設定
//			enableDrillDown(LSRenderer,(DefaultCategoryDataset)helper.codeDatasetList.elementAt(i));

			if (i != 0) {
				categoryPlot.setRenderer(i,renderer); //オリジナルのプロットにレンダラーを追加
				categoryPlot.setDatasetRenderingOrder(DatasetRenderingOrder.REVERSE);
			}

		}
		//ループ終了
	}


	/**
	 * 円グラフ用のラベル設定メソッド
	 * @param doc XML文書(JFreeChart用XMLドキュメント)
	 */
	public void setPieLabel(Document doc) {

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String hasPieLabel     = chartInfo.getElementsByTagName("hasPieLabel").item(0).getFirstChild().getNodeValue();
		
		// 円グラフ用のラベルを「非表示」に設定
		String falseString = Boolean.FALSE.toString();
		if ("0".equals(hasPieLabel)) {

			PiePlot piePlot = this.getPiePlot();								
			piePlot.setLabelGenerator(null);

		} else {
			// 円グラフのデフォルトラベル設定は「表示」であるため、何もしなくてよい
		}
		
	}


	/**
	 *  棒・折れ線・面チャート用ツールチップ設定メソッド
	 *  @param doc XML文書(JFreeChart用XMLドキュメント)
	 *  @param renderer レンダラーオブジェクト
	 */	
	public void setToolTip(Document doc, CategoryItemRenderer renderer) {

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String hasToolTip      = chartInfo.getElementsByTagName("hasToolTip").item(0).getFirstChild().getNodeValue();

		// ツールチップ有り
		if ("1".equals(hasToolTip)){
			renderer.setToolTipGenerator(new StandardCategoryToolTipGenerator());
		}

		// ツールチップ無し
		else {
			// 何もしない（ツールチップ表示しない）
		}

	}

	/**
	 *  円チャート用ツールチップ設定メソッド
	 */	
	public void setToolTipForPie(Document doc) {

		Element root           = doc.getDocumentElement();
		Element chartInfo      = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String hasToolTip      = chartInfo.getElementsByTagName("hasToolTip").item(0).getFirstChild().getNodeValue();

		// ツールチップ有り
		if ("1".equals(hasToolTip)){
			PiePlot piePlot = this.getPiePlot();
			piePlot.setToolTipGenerator(new StandardPieItemLabelGenerator());
		}

		// ツールチップ無し
		else {
			// 何もしない（ツールチップ表示しない）
		}

	}


	/**
	 *  円チャート用ツールチップ設定メソッド
	 */	
	public void setPieFont(Document doc) throws IllegalAccessException, NoSuchFieldException {

		//ラベルフォントの設定
		PiePlot piePlot = this.getPiePlot();
		piePlot.setLabelFont(this.getFont(doc));

		//サブチャートのタイトルフォントの設定
		if(this.getPlot() instanceof MultiplePiePlot) {	// 複数円チャートの場合
			JFreeChart subChart = this.getSubPieChart();
			TextTitle subChartTitle = subChart.getTitle();
			subChartTitle.setFont(this.getFont(doc)); //サブチャートのタイトルフォント(メジャー名)
		}

	}
	
	/**
	 *  プロットエリア背景色設定（複数円チャート用）
	 */	
	public void setMultiPiePlotBGColor(Document doc) {
		
		if (this.getPlot() instanceof MultiplePiePlot) {
			PiePlot piePlot = (PiePlot)this.getPiePlot();

			//プロットエリア背景色設定
			Element root         = doc.getDocumentElement();
			Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);
			String plotBGColor   = chartInfo.getElementsByTagName("MultiPiePlotBGColor").item(0).getFirstChild().getNodeValue();
		
			piePlot.setBackgroundPaint(createColor(plotBGColor)); 

		}
		
	}


	/**
	 *  レンダラー取得メソッド(棒・折れ線・面チャート用)
	 *  @param mode レンダラーを新規で生成するか、プロットより取得するか
	 * 				 値：「create」 レンダラーを新規生成
	 * 				 値：「byPlot」 レンダラーをプロットより取得
	 */	
	public CategoryItemRenderer createRenderer(String mode) {
		if ( (!"create".equals(mode)) && (!"byPlot".equals(mode)) ) {
			throw new IllegalArgumentException();
		}

		CategoryPlot categoryPlot = (CategoryPlot)this.getPlot();
		CategoryItemRenderer renderer = null;

		//棒チャート(Series数に関わらない)
		if(this.chartType.equals("VerticalBar") || this.chartType.equals("HorizontalBar") ||
			this.chartType.equals("VerticalMultiBar") || this.chartType.equals("HorizontalMultiBar")) {

			if ("create".equals(mode)) {
				renderer = new BarRenderer();
			} else if ("byPlot".equals(mode)) {
				renderer = (BarRenderer)categoryPlot.getRenderer();
			}
		}

		//3D棒チャート(Series数に関わらない)
		else if (this.chartType.equals("Vertical3D_Bar") || this.chartType.equals("Horizontal3D_Bar") ||
				  this.chartType.equals("VerticalMulti3D_Bar") || this.chartType.equals("HorizontalMulti3D_Bar")) {

			if ("create".equals(mode)) {
				renderer = new BarRenderer3D();
			}  else if ("byPlot".equals(mode)) {
				renderer = (BarRenderer3D)categoryPlot.getRenderer();
			}
				
		}

		//積み上げ棒チャート(Series数に関わらない)
		else if(this.chartType.equals("VerticalStackedBar") || this.chartType.equals("HorizontalStackedBar")) {

			if ("create".equals(mode)) {
				renderer = new StackedBarRenderer();
			} else if ("byPlot".equals(mode)) {
				renderer = (StackedBarRenderer)categoryPlot.getRenderer();
			}
		}

		//3D積み上げ棒チャート(Series数に関わらない)
		else if(this.chartType.equals("VerticalStacked3D_Bar") || this.chartType.equals("HorizontalStacked3D_Bar")) {

			if ("create".equals(mode)) {
				renderer = new StackedBarRenderer3D();
			} else if ("byPlot".equals(mode)) {
				renderer = (StackedBarRenderer3D)categoryPlot.getRenderer();
			}
		}

		//折れ線チャート(Series数に関わらない)
		else if((this.chartType.equals("Line")) || (this.chartType.equals("MultiLine"))) {

			//接点を表示するためのレンダラー
			LineAndShapeRenderer tempRenderer = null;
			if ("create".equals(mode)) {
				tempRenderer = new LineAndShapeRenderer();
			} else if ("byPlot".equals(mode)) {
				tempRenderer = (LineAndShapeRenderer)categoryPlot.getRenderer();
			}

			//折れ線のCategoryとの交点に印（丸、三角、四角など）を表示するように設定
			tempRenderer.setDrawShapes(true); 
		
			renderer = tempRenderer;

		}

		//面チャート(Series数に関わらない)
		else if((this.chartType.equals("Area")) || (this.chartType.equals("MultiArea"))) {

			if ("create".equals(mode)) {
				renderer = new AreaRenderer();
			} else if ("byPlot".equals(mode)) {
				renderer = (AreaRenderer)categoryPlot.getRenderer();
			}
		}

		//積み上げ面チャート(Series数に関わらない)
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
	 *  色を表す文字列より、java.awt.Colorオブジェクトを取得する
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
		
		// RGB色の場合
		else {

			StringTokenizer st = new StringTokenizer(selectedColor,",");
			if (st.countTokens() != 3) {
				throw new IllegalArgumentException();
			}

			int rgb[] = new int[3];	// RGBをあらわす数値の配列
			int i = 0;

			while ( st.hasMoreTokens() ) {
				rgb[i] = Integer.parseInt(st.nextToken());
				i++;	
			}

			color = new Color(rgb[0],rgb[1],rgb[2]);
		}

		return color;

	}


	// ********** privateメソッド **********

	/**
	 *  与えられたXMLドキュメントで指定されたフォントをあらわす java.awt.Font オブジェクトを取得する
	 */
	private Font getFont( Document doc ) throws IllegalAccessException, NoSuchFieldException {

		Font font = null;

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);

		//フォントオブジェクトを生成
		
		//  フォント名
		String fontName = chartInfo.getElementsByTagName("FontName").item(0).getFirstChild().getNodeValue();

		//  フォントサイズ
		int fontSize = Integer.parseInt(chartInfo.getElementsByTagName("FontSize").item(0).getFirstChild().getNodeValue());

		//  フォントスタイル
		//  XMLで与えられたフォントスタイル名（例：「BOLD」、「ITALIC」、「BOLD,ITALIC」 etc）
		String fontStyleNames = chartInfo.getElementsByTagName("FontStyle").item(0).getFirstChild().getNodeValue();

		int fontStyle = 0; // (初期値 OR 「値」) = 「値」となる初期値は、「0」  ※１参照
		try {

			//複数のフォントスタイルがXMLで指定された場合、ビット演算（論理和）により、スタイル値(int)を求める
			StringTokenizer st = new StringTokenizer(fontStyleNames,",");

			//Static変数を取得するために作成したFontオブジェクト
			Font dummyFont = new Font(fontName, Font.PLAIN, fontSize);
			while ( st.hasMoreTokens() ) {

				//リフレクションにより、Fontクラスのstaticフィールドの値を求め、論理和を求める ※１
				fontStyle =	fontStyle | Font.class.getField(st.nextToken()).getInt(dummyFont);
			}

			//フォントオブジェクト生成
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
	 *  与えられたXMLドキュメントより、"Dataset"オブジェクトの配列(ArrayList)を取得する
	 */
	private ArrayList<Dataset> getDatasetList( Document doc ) {

		ArrayList<Dataset> dataSetList = new ArrayList<Dataset>();

		Element root         = doc.getDocumentElement();
		Element chartInfo    = (Element)root.getElementsByTagName("ChartInfo").item(0);

		NodeList dataSetNodeList = root.getElementsByTagName("DataSet");


		Dataset dataset = null;
		// XMLの"DataSetList"要素内にある"DataSet"要素の数だけまわる
		for (int i = 0; i < dataSetNodeList.getLength(); i++){
			Element firstDataSet = (Element)dataSetNodeList.item(i);
			NodeList dataList    = firstDataSet.getElementsByTagName("Data");

			// データセットの初期化（円チャート、３Ｄ円チャート）
			if( (this.chartType.equals("Pie")) || (this.chartType.equals("Pie_3D"))) {

				dataset = new DefaultPieDataset();
	
			// データセットの初期化（それ以外のチャート(線、棒、面、および複数Seriesを持つ円チャート)）
			} else {

				// 複数円チャートの場合は、XMLにある複数の"DataSet"要素内の"Data"要素を、一つのJava "Dataset"オブジェクトに
				// 格納するため、datasetの新規作成処理を行なわない
				// 複数線、棒、面チャートの場合は、XMLの"DataSet"毎に Java "Dataset"オブジェクトを一つ生成する
				if  ( (!this.chartType.equals("MultiPie")) || ( i == 0)) {
					dataset = new DefaultCategoryDataset();
				}
			}
	
			// XMLの"DataSet"要素(一つ外側のforループで選択されているもの)内にある"Data"要素の数だけまわる
			for ( int j = 0; j < dataList.getLength(); j++ ) {
	
				Element data = (Element)dataList.item(j);
	
				Number value = new Double(data.getElementsByTagName("Value").item(0).getFirstChild().getNodeValue());
	
				String categoryAxisName = categoryAxisName = data.getElementsByTagName("CategoryAxisName").item(0).getFirstChild().getNodeValue();
				String seriesAxisName   =   null;
	
				// 円チャート、３Ｄ円チャート
				if( (this.chartType.equals("Pie")) || (this.chartType.equals("Pie_3D"))) {
					((DefaultPieDataset)dataset).setValue(categoryAxisName, value);
	
				// それ以外のチャート(線、棒、面チャート(Series数に関わらない)および、複数Seriesを持つ円チャート)
				} else {
					if ( data.getElementsByTagName("ValueAxisName").item(0).getFirstChild() != null ) {
						seriesAxisName = data.getElementsByTagName("ValueAxisName").item(0).getFirstChild().getNodeValue();
					}
					((DefaultCategoryDataset)dataset).addValue(value, seriesAxisName, categoryAxisName);
				}
			}
		
			// 複数円チャートの場合は、XMLにある複数の"DataSet"要素内の"Data"要素を、一つのJava "Dataset"オブジェクトに
			// 格納するため、datasetのdataSetListへの登録は全データをデータセットに登録後の一度のみ行なう。
			if  ( (!this.chartType.equals("MultiPie")) || ( i == (dataSetNodeList.getLength()-1))) {
				dataSetList.add(dataset);
			}
		
		}
		
		return dataSetList;
		
	}

	/**
	 *  JFreeChartオブジェクトを作成する
	 */
	private JFreeChart createChartObject( Document doc ) {

		Element root            = doc.getDocumentElement();
		Element chartInfo       = (Element)root.getElementsByTagName("ChartInfo").item(0);
		String chartTitle       = chartInfo.getElementsByTagName("Title").item(0).getFirstChild().getNodeValue();
		this.chartType        = chartInfo.getElementsByTagName("Type").item(0).getFirstChild().getNodeValue();
		String categoryLabel    = ((Element)chartInfo.getElementsByTagName("Category").item(0)).getElementsByTagName("Label").item(0).getFirstChild().getNodeValue();
		
		Element firstSeries     = (Element)((Element)chartInfo.getElementsByTagName("SeriesList").item(0)).getElementsByTagName("Series").item(0);
		String firstSeriesLabel = firstSeries.getElementsByTagName("Label").item(0).getFirstChild().getNodeValue();
		
		// データセットのリストを取得
		this.dataSetList = this.getDatasetList(doc);
		
		
		//棒チャート(Series数に関わらない)
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

		//3D棒チャート(Series数に関わらない)
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

		//積み上げ棒チャート
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

		//3D積み上げ棒チャート
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

		//折れ線チャート(Series数に関わらない)
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


		//面チャート(Series数に関わらない)
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
		
		//積み上げ面チャート
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

		//円チャート(Series数に関わらない)
		else if(this.chartType.equals("Pie")) {

			chart = ChartFactory.createPieChart(
													chartTitle,
													(PieDataset)this.dataSetList.get(0),
													false,
													false,
													false 
												);


		}

 
		//3D円チャート(Series数に関わらない)
		else if(this.chartType.equals("Pie_3D")) {
  
			chart = ChartFactory.createPieChart3D(
													chartTitle,
													(PieDataset)this.dataSetList.get(0),
													false,
													false,
													false 
												 );


		}


		//複数円チャート(Series数が２以上)
		else if(this.chartType.equals("MultiPie")) {

				//複数円チャート
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
	 *  円チャート用のプロットを取得する
	 */	
	private PiePlot getPiePlot() {

		PiePlot piePlot = null;

		// 複数円チャートの場合
		if(this.getPlot() instanceof MultiplePiePlot) {
				
			//サブチャートの生成
			JFreeChart subChart = this.getSubPieChart();
			piePlot = (PiePlot)subChart.getPlot();
		
		// 円チャートの場合	
		} else {
			piePlot = (PiePlot)this.getPlot();
		}
		
		return piePlot;
	}


	/**
	 *  複数円チャート用のサブチャートを取得する
	 */	
	private JFreeChart getSubPieChart(){
		
		MultiplePiePlot multiplePiePlot = (MultiplePiePlot)this.getPlot();
				
		//サブチャートの生成
		JFreeChart subChart = multiplePiePlot.getPieChart();
		
		return subChart;
		
	}



	/**
	 *  XMLよりチャートの幅を取得する
	 */
	private int getChartWidthByDoc( Document doc ) {

		Element root   = doc.getDocumentElement();
		int chartWidth = Integer.parseInt(root.getElementsByTagName("ChartWidth").item(0).getFirstChild().getNodeValue());

		return chartWidth;
	}

	/**
	 *  XMLよりチャートの高さを取得する
	 */
	private int getChartHeightByDoc( Document doc ) {

		Element root   = doc.getDocumentElement();
		int chartHeight = Integer.parseInt(root.getElementsByTagName("ChartHeight").item(0).getFirstChild().getNodeValue());
		
		return chartHeight;
	}

	/**
	 *  XMLよりチャートレイアウトを取得する
	 */
	private PlotOrientation getLayoutFromDoc( Document doc ) {
		
		// チャートレイアウトが縦型
		if ((this.chartType.equals("VerticalBar")) || 
		     (this.chartType.equals("Vertical3D_Bar")) || 
		     (this.chartType.equals("VerticalMultiBar")) || 
		     (this.chartType.equals("VerticalMulti3D_Bar")) ||
		     (this.chartType.equals("VerticalStackedBar")) ||
		     (this.chartType.equals("VerticalStacked3D_Bar"))) 
		{
			return PlotOrientation.VERTICAL;
					
		// チャートレイアウトが横型
		} else if((this.chartType.equals("HorizontalBar")) || 
		           (this.chartType.equals("Horizontal3D_Bar")) ||
		           (this.chartType.equals("HorizontalMultiBar")) || 
		           (this.chartType.equals("HorizontalMulti3D_Bar")) ||
				   (this.chartType.equals("HorizontalStackedBar")) ||
				   (this.chartType.equals("HorizontalStacked3D_Bar"))) 
		           
		{
			return PlotOrientation.HORIZONTAL;

		// それ以外の場合：エラー
		} else {
			throw new IllegalStateException();
		}
		
	}


	// ********** Setter メソッド **********
	
	/**
	 *  プロットを設定する
	 */
	private void setPlot(JFreeChart chart) {

		// 円チャート、３Ｄ円チャート
		if((this.chartType.equals("Pie")) || (this.chartType.equals("Pie_3D"))){
			this.plot = (PiePlot)chart.getPlot();

		// 複数円チャート、複数３Ｄ円チャート
		} else if (this.chartType.equals("MultiPie")) {
			this.plot = (MultiplePiePlot)chart.getPlot();

		// その他チャート共通プロット
		} else {
			this.plot = chart.getCategoryPlot();
		}

	}
	
	
	/**
	 *  チャートの幅を設定する
	 */
	private void setChartWidth(int chartWidth) {
		this.chartWidth = chartWidth;
	}

	/**
	 *  チャートの高さを設定する
	 */	
	private void setChartHeight(int chartHeight) {
		this.chartHeight = chartHeight;
	}
	
	// ********** Getter メソッド **********

	/**
	 *  チャートオブジェクトを取得する
	 */
	public JFreeChart getChart() {
		return this.chart;
	}	

	/**
	 *  チャートのプロットオブジェクトを取得する
	 */
	public Plot getPlot() {
		return this.plot;
	}	

	/**
	 *  チャートタイプを取得する
	 */
	public String getChartType() {
		return this.chartType;
	}	
	
	/**
	 *  データセットリストを取得する
	 */
	public ArrayList<Dataset> getDataSetList() {
		return this.dataSetList;
	}	

	

	/**
	 *  チャートの幅を取得する
	 */
	public int getChartWidth() {
		return this.chartWidth;
	}

	/**
	 *  チャートの高さを取得する
	 */	
	public int getChartHeight() {
		return this.chartHeight;
	}

}
