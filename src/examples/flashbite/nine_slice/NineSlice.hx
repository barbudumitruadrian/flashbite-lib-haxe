package examples.flashbite.nine_slice;

import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.view.image.Image9SliceSkinnable;
import flashbite.skinnableview.view.text.TextFieldSkinnable;

/**
 * 9Slice example with a 9slice image
 * 
 * @author Adrian Barbu
 */
@:final
class NineSlice extends ExampleBase
{
	private var _titleTxt:TextFieldSkinnable;
	
	private var _image:Image9SliceSkinnable;
	private var _changeDimensionByCode:Bool = false;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() { super(ExampleNames.NINE_SLICE); }
	
	// ====================================================================================================================================
	// PRIVATE (PROTECTED)
	// ====================================================================================================================================
	
	override function registerCustoms():Void
	{
		//nothing to register
	}
	override function createProperties():Void
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
		_image = cast HelpersGlobal.getChildByName(this, "image");
		
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
		
		if (_changeDimensionByCode && _image != null) {
			_image.setWidthAndHeight(_titleTxt.width/2, -1);
		}
	}
	
	private function updateTitle():Void
	{
		if (_titleTxt != null) {
			_titleTxt.setText("In order to see how the 9slice works, please change the window size with mouse.");
		}
	}
}