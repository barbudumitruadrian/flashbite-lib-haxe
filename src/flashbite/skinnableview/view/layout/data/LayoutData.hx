package flashbite.skinnableview.view.layout.data;

import flashbite.align.HorizontalAlign;
import flashbite.align.VerticalAlign;
import flashbite.helpers.HelpersGlobal;

/**
 * Data of a layout
 * 
 * @author Adrian Barbu
 */
@:final
class LayoutData implements ILayoutData
{
	@:isVar public var padding(get, set):Float = 0;
	@:isVar public var verticalAlign(get, set):String = VerticalAlign.CENTER;
	@:isVar public var horizontalAlign(get, set):String = HorizontalAlign.CENTER;
	@:isVar public var autoSizePadding(get, set):Bool = true;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() {}
	
	// ====================================================================================================================================
	// PUBLIC
	// ====================================================================================================================================
	
	public function readFromObject(object:Dynamic):Void
	{
		padding = Std.parseFloat(HelpersGlobal.getCaseInsensitivePropValue(object, "padding", Std.string(padding)));
		verticalAlign = HelpersGlobal.getCaseInsensitivePropValue(object, "verticalAlign", verticalAlign, VerticalAlign.getAll());
		horizontalAlign = HelpersGlobal.getCaseInsensitivePropValue(object, "horizontalAlign", horizontalAlign, HorizontalAlign.getAll());
		autoSizePadding = HelpersGlobal.translateToBoolean(HelpersGlobal.getCaseInsensitivePropValue(object, "autoSizePadding", Std.string(autoSizePadding)));
	}
	
	// ====================================================================================================================================
	// GETTERS, SETTERS
	// ====================================================================================================================================
	
	function get_padding():Float { return padding; }
	function set_padding(value:Float):Float
	{
		if (padding != value && value > 0) {
			padding = value;
		}
		
		return padding;
	}
	
	function get_verticalAlign():String { return verticalAlign;}
	function set_verticalAlign(value:String):String
	{
		if (verticalAlign != value) {
			if (VerticalAlign.isKnown(value)) {
				verticalAlign = value;
			}
		}
		
		return verticalAlign;
	}
	
	function get_horizontalAlign():String { return horizontalAlign; }
	function set_horizontalAlign(value:String):String
	{
		if (horizontalAlign != value) {
			if (HorizontalAlign.isKnown(value)) {
				horizontalAlign = value;
			}
		}
		
		return horizontalAlign;
	}
	
	function get_autoSizePadding():Bool { return autoSizePadding; }
	function set_autoSizePadding(value:Bool):Bool { return autoSizePadding = value; }
}