package flashbite.skinnableview.view.text;

import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import openfl.text.TextFormat;

/**
 * TextFieldWithValueSkinnable class; extended TextFieldSkinnable and adds posibility to add a value
 * ex: text = "{value} data"; tf.setValue("10") => tf.text = "10 data"
 * also, it can format differently the value
 * Make sure to call setText(value) instead of tf.text = value
 * Also, for value change, use setValue.
 * 
 * @author Adrian Barbu
 */
@:final
class TextFieldWithValueSkinnable extends TextFieldSkinnable
{
	private var _valueReplacement:String = "{value}";
	private var _valueTextFormat:TextFormat;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super(skinObj, skinnableData);
		
		_valueReplacement = skinObj.rawObject.getPropertyValue("valueReplacement", true, _valueReplacement);
		if (skinObj.rawObject.hasProperty("valueTextFormat")) {
			//in order to make sure we will render correctly, we need to have approximately the same font, but different color
			_valueTextFormat = _skinnableData.getTextFormat(skinObj.rawObject.getPropertyValue("valueTextFormat"), true);
			//just to be sure, set same font type
			_valueTextFormat.font = _initialTextFormat.font;
		} else {
			_valueTextFormat = _skinnableData.getTextFormat(skinObj.textFormat, true);
		}
	}
	
	override public function dispose():Void
	{
		_valueReplacement = null;
		_valueTextFormat = null;
		
		super.dispose();
	}
	
	// ====================================================================================================================================
	// PUBLIC
	// ====================================================================================================================================
	
	public function setValue(value:String, newText:String = null):Void
	{
		var textUsedNow:String = (newText != null && newText.indexOf(_valueReplacement) != -1) ? newText : this.getInitialText();
		if (this.text != textUsedNow) {
			this.setText(textUsedNow);
		}
		
		if (textUsedNow.indexOf(_valueReplacement) != -1) {
			
			var textSplit:Array<String> = textUsedNow.split(_valueReplacement);
			var textReplaced:String = textSplit.join(value);
			this.setText(textReplaced);
			
			//update textFormat
			if (_valueTextFormat != null && _valueTextFormat.color != _initialTextFormat.color && value != "") {
				//set the values from _initialTextFormat
				_valueTextFormat.size = _initialTextFormat.size;
				_valueTextFormat.font = _initialTextFormat.font;
				
				var leftPart:String = textSplit[0];
				var beginIndex = Std.int(Math.min(this.text.length - 1, leftPart.length));
				var endIndex = Std.int(Math.min(this.text.length, leftPart.length + value.length));
				this.setTextFormat(_valueTextFormat, beginIndex, endIndex);
			}
		} else {
			Logger.warning(this, "No value to replace!!!");
		}
	}
}