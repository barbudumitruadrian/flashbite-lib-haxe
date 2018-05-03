package flashbite.skinnableview.view;

import flashbite.helpers.HelpersString;
import flashbite.skinnableview.view.image.ImageSkinnable;
import flashbite.skinnableview.view.movieclip.MovieClipSkinnable;
import flashbite.skinnableview.view.shape.ShapeSkinnable;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import flashbite.skinnableview.view.text.TextFieldWithValueSkinnable;

/**
 * Holds all elements that ISkinnableViewCreator can create in his initial state
 * 
 * @author Adrian Barbu
 */
@:final
class ElementType
{
	private function new() {}
	
	
	public static inline var CONTAINER		:String = "Container";

	public static inline var SHAPE			:String = "Shape";
	public static inline var IMAGE			:String = "Image";
	public static inline var MOVIECLIP		:String = "MovieClip";
	public static inline var TEXT			:String = "Text";
	public static inline var TEXT_WITH_VALUE:String = "TextWithValue";
	
	
	private static var _all:Array<String> =         [CONTAINER,     SHAPE,          IMAGE,          MOVIECLIP, 			TEXT, 				TEXT_WITH_VALUE];
	private static var _allClasses:Array<Dynamic> = [ContainerBase, ShapeSkinnable, ImageSkinnable, MovieClipSkinnable, TextFieldSkinnable, TextFieldWithValueSkinnable];
	
	public static function getAll():Array<String> { return _all.copy(); }
	public static function isKnown(type:String, caseInsensitive:Bool = true):Bool
	{
		return getIndexOf(type, caseInsensitive) != -1;
	}
	
	public static function getClass(type:String):Dynamic
	{
		if (isKnown(type, true)) {
			return _allClasses[getIndexOf(type, true)];
		}
		return null;
	}
	
	private static function getIndexOf(type:String, caseInsensitive:Bool = true):Int
	{
		if (caseInsensitive) {
			type = HelpersString.toLowerCase(type);
			for (i in 0..._all.length) {
				if (HelpersString.toLowerCase(_all[i]) == type) {
					return i;
				}
			}
			return -1;
		} else {
			return _all.indexOf(type);
		}
	}
}