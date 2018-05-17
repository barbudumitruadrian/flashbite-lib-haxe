package editor.preview.event;

import openfl.events.Event;

/**
 * Event for Preview
 * 
 * @author Adrian Barbu
 */
@:final
class PreviewEvent extends Event
{
	public static inline var RENDER:String = "PreviewEvent__RENDER";
	
	
	private static var _all:Array<String> = [ RENDER ];
	public static function getAll():Array<String> { return _all.copy(); }
	
	
	public var styleXml(get, null):Xml;
	
	
	public function new(type:String, styleXml:Xml)
	{
		super(type, false, false);
		
		this.styleXml = styleXml;
	}
	
	private function get_styleXml():Xml { return styleXml; }
}