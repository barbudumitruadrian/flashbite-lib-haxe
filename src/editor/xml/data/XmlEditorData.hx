package editor.xml.data;

import flashbite.helpers.HelpersXml;
import flashbite.interfaces.IDisposable;
import haxe.xml.Parser.XmlParserException;

/**
 * Data for XmlEditor
 * 
 * @author Adrian Barbu
 */
@:final
class XmlEditorData implements IDisposable 
{
	public var xml(get, null):Xml;
	public var string(get, null):String;
	
	public var lastError(get, null):XmlParserException;
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new() {}
	
	public function dispose():Void
	{
		xml = null;
		string = null;
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	public function setNewString(string:String):Bool
	{
		lastError = null;
		
		try {
			var xml = Xml.parse(string).firstElement();
			if (xml == null) {
				throw new XmlParserException("Null xml", string, 0);
			}
			var textsXmlList = HelpersXml.getChildrenWithNodeName(xml, "texts");
			if (textsXmlList == null || textsXmlList.length == 0) {
				throw new XmlParserException("no texts xml node", string, 0);
			}
			var textFormatsXmlList = HelpersXml.getChildrenWithNodeName(xml, "textFormats");
			if (textFormatsXmlList == null || textFormatsXmlList.length == 0) {
				throw new XmlParserException("no textFormats xml node", string, 0);
			}
			
			this.xml = xml;
			this.string = string;
			
			return true;
		} catch (e:XmlParserException) {
			lastError = e;
			return false;
		}
	}
	
	// =====================================================================================================================================
	// GETTERS, SETTERS
	// =====================================================================================================================================
	
	private function get_xml():Xml { return xml; }
	private function get_string():String { return string; }
	
	private function get_lastError():XmlParserException { return lastError; }
}