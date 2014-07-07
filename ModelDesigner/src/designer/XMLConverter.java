package designer;

import javax.xml.parsers.*;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.io.*;

import org.xml.sax.*;

//for selectSingleNode J2SE1.5 2005.04.01
//import org.apache.xpath.*;
import javax.xml.xpath.*;

import org.w3c.dom.traversal.*;

import javax.xml.transform.*;
import javax.xml.transform.stream.*;
import javax.xml.transform.dom.*;

public class XMLConverter {
	DocumentBuilderFactory dbfactory;
	DocumentBuilder builder;

	public XMLConverter() throws ParserConfigurationException {
		// ドキュメントビルダーファクトリを生成
		dbfactory = DocumentBuilderFactory.newInstance();
		// ドキュメントビルダーを生成
		builder = dbfactory.newDocumentBuilder();
	}

	public Node selectSingleNode(Document doc,String xpath) throws TransformerException, XPathExpressionException {

//for selectSingleNode J2SE1.5 2005.04.01
		XPath oXpath = XPathFactory.newInstance().newXPath();
		Node returnNode = (Node) oXpath.evaluate(xpath, doc, XPathConstants.NODE);
		return returnNode;

//		NodeIterator nl = XPathAPI.selectNodeIterator(doc,xpath);
//		return nl.nextNode();
	}
	public Node selectSingleNode(Node node,String xpath) throws TransformerException, XPathExpressionException {

//for selectSingleNode J2SE1.5 2005.04.01

		XPath oXpath = XPathFactory.newInstance().newXPath();
		Node returnNode = (Node) oXpath.evaluate(xpath, node, XPathConstants.NODE);

		return returnNode;

//		Node returnNode = XPathAPI.selectSingleNode(node,xpath);
//		return returnNode;
	}
	public NodeList selectNodes(Node node,String xpath) throws TransformerException, XPathExpressionException {

//for selectSingleNode J2SE1.5 2005.04.01

		XPath oXpath = XPathFactory.newInstance().newXPath();
		NodeList nodeList = (NodeList) oXpath.evaluate(xpath, node, XPathConstants.NODESET);

		return nodeList;

//		NodeList nl = XPathAPI.selectNodeList(node,xpath);
//		return nl;

	}

	public String toXMLText(Document doc) throws TransformerException {
		TransformerFactory transFactory = TransformerFactory.newInstance();
		Transformer transformer = transFactory.newTransformer();
		transformer.setOutputProperty("encoding","Shift_JIS");//Shift_JISで出力
		DOMSource source = new DOMSource(doc);
		StringWriter writer = new StringWriter();
		StreamResult result = new StreamResult(writer); 
		transformer.transform(source, result);
		return writer.toString();
	}

	public String toXMLText(Element ele) throws TransformerException {
		TransformerFactory transFactory = TransformerFactory.newInstance();
		Transformer transformer = transFactory.newTransformer();
		transformer.setOutputProperty("encoding","Shift_JIS");//Shift_JISで出力
		DOMSource source = new DOMSource(ele);
		StringWriter writer = new StringWriter();
		StreamResult result = new StreamResult(writer); 
		transformer.transform(source, result);
		return writer.toString();
	}

	public String toXMLText(Node node) throws TransformerException {
		TransformerFactory transFactory = TransformerFactory.newInstance();
		Transformer transformer = transFactory.newTransformer();
		transformer.setOutputProperty("encoding","Shift_JIS");//Shift_JISで出力
		DOMSource source = new DOMSource(node);
		StringWriter writer = new StringWriter();
		StreamResult result = new StreamResult(writer); 
		transformer.transform(source, result);
		return writer.toString();
	}

	public Document toXMLDocument(String XMLString) throws SAXException, IOException {
		//先頭の空白を取り除く
		String XMLStr=XMLString.substring(XMLString.indexOf("<"));

		InputSource input = new InputSource(new StringReader(XMLString));
		Document doc = builder.parse(input);
		return doc;
	}

	public Document readFile(String filepath) throws SAXException, IOException {
		File a = new File(filepath);
		FileInputStream b = new FileInputStream(a);
		BufferedInputStream input = new BufferedInputStream(b);
		Document doc = builder.parse(input);
		return doc;
	}

	public boolean saveFile(String filepath,Document doc) throws FileNotFoundException, TransformerException {
		TransformerFactory transFactory = TransformerFactory.newInstance();
		Transformer transformer = transFactory.newTransformer();
		transformer.setOutputProperty("encoding","Shift_JIS");//Shift_JISで出力

		DOMSource source = new DOMSource(doc);
		File file = new File(filepath); 
		FileOutputStream out = new FileOutputStream(file); 
		StreamResult result = new StreamResult(out); 
		transformer.transform(source, result);

		return true;
	}

	public String transformDocument(String xslFilepath,Document xmlDoc) throws TransformerException {
		TransformerFactory transFactory = TransformerFactory.newInstance();
		Transformer transformer = transFactory.newTransformer(new StreamSource(xslFilepath));

//以下の形にすると、XSLTのVersionやHeaderが消えてしまう。
//Transformer transformer = transFactory.newTransformer(xsltDocS);

		transformer.setOutputProperty("encoding","Shift_JIS");//Shift_JISで出力

		StringWriter writer = new StringWriter();
		StreamResult result = new StreamResult(writer); 

		DOMSource xmlDocS = new DOMSource(xmlDoc);
		transformer.transform(xmlDocS, result);

		return writer.toString();

	}
}
