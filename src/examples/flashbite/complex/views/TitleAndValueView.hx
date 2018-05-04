package examples.flashbite.complex.views;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.text.TextFieldSkinnable;

/**
 * TitleAndTimeView is the view that will show a simple tab (title + time(seconds or time value))
 * 
 * @author Adrian Barbu
 */
@:final
class TitleAndValueView extends ContainerBase 
{
	public static inline var NAME:String = "TitleAndValueView";
	
	private var _titleTxt:TextFieldSkinnable;
	private var _valueTxt:TextFieldSkinnable;
	
	private var _titleMessageID:String;
	private var _value:String;
	
	private var _isInitialized:Bool = false;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) 
	{
		super(skinObj, skinnableData);
		
		_titleMessageID = skinObj.rawObject.getPropertyValue("titleMessageID", true, "");
	}
	
	override public function dispose():Void 
	{
		_titleTxt = _valueTxt = null;
		_titleMessageID = null;
		
		super.dispose();
	}
	
	// ====================================================================================================================================
	// PUBLIC
	// ====================================================================================================================================
	
	public function initialize(value:String):Void
	{
		_titleTxt = cast HelpersGlobal.getChildByName(this, "titleTxt");
		_valueTxt = cast HelpersGlobal.getChildByName(this, "valueTxt");
		
		_isInitialized = true;
		_value = value;
		
		updateTitleText();
		updateValueText();
	}
	
	override public function redraw():Void
	{
		super.redraw();
		
		if (_isInitialized) {
			updateTitleText();
			updateValueText();
		}
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	private function updateTitleText():Void
	{
		_titleTxt.setText(_skinnableData.getTextByID(_titleMessageID));
	}
	
	private function updateValueText():Void
	{
		_valueTxt.setText(_value);
	}
}