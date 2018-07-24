package flashbite.skinnableview.view.text;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;

/**
 * TextFieldWithColorSkinnable class; extended TextFieldSkinnable and adds posibility to change his color;
 * use the color setter for this behavior
 * 
 * @author Adrian Barbu
 */
class TextFieldWithColorSkinnable extends TextFieldSkinnable
{
	@:isVar public var color(get, set):Int = -1;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super(skinObj, skinnableData);
		
		color = _initialTextFormat.color;
	}
	
	// ====================================================================================================================================
	// GETTERS, SETTERS
	// ====================================================================================================================================
	
	function get_color():Int { return color; }
	function set_color(value:Int):Int
	{
		if (color != value && value >= 0) {
			_initialTextFormat.color = value;
			setText(this.text);
			color = value;
		}
		
		return color;
	}
}