package examples.flashbite.vertical_layout;

import flashbite.logger.Logger;

/**
 * VerticalLayout example
 * 
 * @author Adrian Barbu
 */
@:final
class VerticalLayoutExample extends ExampleBase
{
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() { super(ExampleNames.VERTICAL_LAYOUT); }
	
	// ====================================================================================================================================
	// PRIVATE (PROTECTED)
	// ====================================================================================================================================
	
	override function registerCustoms():Void
	{
		//nothing
	}
	override function createProperties():Void
	{
		_styleXml = getDefaultStyleXml();
		_textsXml = getDefaultTextsXml();
		_textFormatsXml = getDefaultTextFormatsXml();
		
		_language = "en";
		_width = _height = 100;
	}
	
	override function internalInitialize():Void
	{
		//nothing
	}
	override function internalStart():Void
	{
		//nothing
		
		Logger.debug(this, "internalStart");
	}
}