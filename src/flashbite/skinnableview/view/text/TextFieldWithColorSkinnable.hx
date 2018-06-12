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
	public var color(null, set):Int = -1;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super(skinObj, skinnableData);
		
		color = _initialTextFormat.color;
	}
	
	// ====================================================================================================================================
	// SETTERS
	// ====================================================================================================================================
	
	function set_color(value:Int):Int
	{
		if (color != value && value >= 0) {
			_initialTextFormat.color = value;
			setText(this.text);
		}
		
		return color = value;
	}
}