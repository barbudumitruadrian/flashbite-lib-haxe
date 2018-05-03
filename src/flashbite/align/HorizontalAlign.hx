package flashbite.align;

/**
 * Constants for horizontal alignment of items.
 * 
 * @author Adrian Barbu
 */
@:final
class HorizontalAlign
{
	private function new() {}
	
	
	public static inline var LEFT	:String = "left";
	public static inline var RIGHT	:String = "right";
	public static inline var CENTER	:String = "center";
	
	private static var _all:Array<String> = [LEFT, RIGHT, CENTER];
	
	public static function getAll():Array<String> { return _all.copy(); }
	public static function getDefault():String { return LEFT; }
	public static function isKnown(value:String):Bool { return _all.indexOf(value) != -1; }
}