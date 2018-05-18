package editor.flashbite.preview.event;

import openfl.events.Event;

/**
 * Event for Preview
 * 
 * @author Adrian Barbu
 */
@:final
class PreviewEvent extends Event
{
	public static inline var RENDER		 :String = "PreviewEvent__RENDER";
	public static inline var RENDER_ERROR:String = "PreviewEvent__RENDER_ERROR";
	
	
	private static var _all:Array<String> = [ RENDER, RENDER_ERROR ];
	public static function getAll():Array<String> { return _all.copy(); }
	
	
	public var styleXml(get, null):Xml;
	public var message(get, null):String = "";
	
	
	public function new(type:String, styleXml:Xml = null, message:String = "")
	{
		super(type, false, false);
		
		this.styleXml = styleXml;
		this.message = message;
	}
	
	private function get_styleXml():Xml { return styleXml; }
	private function get_message():String { return message; }
}