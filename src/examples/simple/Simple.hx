package examples.simple;

import examples.ExampleBase;
import flashbite.logger.Logger;

/**
 * Simple example
 * 
 * @author Adrian Barbu
 */
@:final
class Simple extends ExampleBase
{
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() { super(ExampleNames.SIMPLE); }
	
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
		_textsXml = _textFormatsXml = null;
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