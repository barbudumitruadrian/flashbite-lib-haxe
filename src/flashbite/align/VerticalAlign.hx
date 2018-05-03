package flashbite.align;

/**
 * Constants for vertical alignment of items.
 * 
 * @author Adrian Barbu
 */
@:final
class VerticalAlign
{
	private function new() {}
	
	
	public static inline var TOP	:String = "top";
	public static inline var BOTTOM	:String = "bottom";
	public static inline var CENTER	:String = "center";
	
	private static var _all:Array<String> = [TOP, BOTTOM, CENTER];
	
	public static function getAll():Array<String> { return _all.copy(); }
	public static function getDefault():String { return TOP; }
	public static function isKnown(value:String):Bool { return _all.indexOf(value) != -1; }
}