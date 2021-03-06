package examples.flashbite.text_with_color;

import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import flashbite.skinnableview.view.text.TextFieldWithColorSkinnable;
import motion.Actuate;
import motion.actuators.IGenericActuator;


/**
 * This example shows the way the color can be changed on a TextFieldWithColorSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class TextWithColor extends ExampleBase
{
	private var _titleTxt:TextFieldSkinnable;
	
	private var _txt:TextFieldWithColorSkinnable;
	
	private var _delay:IGenericActuator;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() { super(ExampleNames.TEXT_WITH_COLOR); }
	
	override public function dispose():Void 
	{
		_titleTxt = null;
		_txt = null;
		if (_delay != null) {
			Actuate.stop(_delay, null, false, false);
			_delay = null;
		}
		
		super.dispose();
	}
	
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
		_txt = cast HelpersGlobal.getChildByName(this, "center.txt");
		_titleTxt = cast HelpersGlobal.getChildByName(this, "titleTxt");
		
		_delay = Actuate.timer(1).onComplete(updateTxtColor);
		
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
			_titleTxt.setText("Simple example of changing color on a text");
		}
	}
	
	private function updateTxtColor():Void
	{
		if (_txt != null) {
			_txt.color = 0xFF0000;
		}
	}
}