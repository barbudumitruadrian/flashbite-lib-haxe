package examples.flashbite.text_center_on_y;

import examples.flashbite.ExampleBase;
import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.view.text.TextFieldSkinnable;

/**
 * This example shows the way the centerOnY on textField items works
 * 
 * @author Adrian Barbu
 */
@:final
class TextCenterOnY extends ExampleBase
{
	private var _titleTxt:TextFieldSkinnable;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() { super(ExampleNames.TEXT_CENTER_ON_Y); }
	
	// ====================================================================================================================================
	// PRIVATE (PROTECTED)
	// ====================================================================================================================================
	
	override function registerCustoms():Void
	{
		//nothing to register
	}
	override private function createProperties():Void
	{
		_styleXml = getDefaultStyleXml();
		_textsXml = getDefaultTextsXml();
		_textFormatsXml = getDefaultTextFormatsXml();
		
		_language = "en";
		_width = _height = 100;
	}
	
	override private function internalInitialize():Void
	{
		_titleTxt = cast HelpersGlobal.getChildByName(this, "titleTxt");
		updateTitle();
	}
	override private function internalStart():Void
	{
		Logger.debug(this, "internalStart");
		
		//nothing
	}
	
	override private function internalOnStageResize():Void
	{
		updateTitle();
	}
	
	private function updateTitle():Void
	{
		if (_titleTxt != null) {
			_titleTxt.setText("The buttons seems to have the same layout, but just change the window height to see the problem on right");
		}
	}
}