package editor.popup.event;

import openfl.events.Event;

/**
 * Event for PopupManager
 * 
 * @author Adrian Barbu
 */
@:final
class PopupManagerEvent extends Event
{
	public static inline var CLOSE	:String = "PopupManagerEvent__CLOSE";
	public static inline var OPEN	:String = "PopupManagerEvent__OPEN";
	
	
	private static var _all:Array<String> = [ CLOSE, OPEN ];
	public static function getAll():Array<String> { return _all.copy(); }
	
	
	public var message(get, null):String = "";
	
	
	public function new(type:String, message:String = "")
	{
		super(type, false, false);
		
		this.message = message;
	}
	
	private function get_message():String { return message; }
}