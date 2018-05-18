package editor.flashbite;

/**
 * Consts class for editor view names
 * 
 * @author Adrian Barbu
 */
@:final
class EditorComponentViewNames
{
	public static inline var XML	:String = "xml";
	public static inline var PREVIEW:String = "preview";
	public static inline var POPUP	:String = "popup";
	
	
	private static var _all:Array<String> = [ XML, PREVIEW, POPUP ];
	public static function getAll():Array<String> { return _all.copy(); }
	
	private function new() {}
}