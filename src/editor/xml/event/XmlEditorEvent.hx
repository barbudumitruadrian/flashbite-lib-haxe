package editor.xml.event;

import openfl.events.Event;

/**
 * Event for XmlEditor
 * 
 * @author Adrian Barbu
 */
@:final
class XmlEditorEvent extends Event
{
	public static inline var PARSE_OK	:String = "XmlEditorEvent__PARSE_OK";
	public static inline var PARSE_NOK	:String = "XmlEditorEvent__PARSE_NOK";
	
	
	private static var _all:Array<String> = [ PARSE_OK, PARSE_NOK ];
	public static function getAll():Array<String> { return _all.copy(); }
	
	
	public var message(get, null):String = "";
	public var xml(get, null):Xml;
	
	
	public function new(type:String, message:String = "", xml:Xml = null)
	{
		super(type, false, false);
		
		this.message = message;
		this.xml = xml;
	}
	
	private function get_message():String { return message; }
	private function get_xml():Xml { return xml; }
}