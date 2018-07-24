package tests.flashbite.skinnableview.view.movieclip;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.movieclip.MovieClipSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for TextFieldSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class MovieClipSkinnableTestCase extends TestCase
{
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	public function test_data():Void
	{
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<MovieClip width="100" height="5" filePrefix="image_" frameRate="30" numFrames="10" name="mc"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var movieclip:MovieClipSkinnable = cast HelpersGlobal.getChildByName(container, "mc");
		
		assertEquals(0, movieclip.currentFrame);
		
		movieclip.currentFrame = 10;
		assertEquals(9, movieclip.currentFrame);
		
		movieclip.currentFrame = 7;
		assertEquals(7, movieclip.currentFrame);
		
		movieclip.currentFrame = 100000;
		assertEquals(9, movieclip.currentFrame); //last frame
		
		movieclip.currentFrame = -1;
		assertEquals(0, movieclip.currentFrame); //first frame
		
		//color
		movieclip.color = 0x666666;
		assertEquals(Std.parseInt("0x666666"), movieclip.transform.colorTransform.color);
		assertEquals(0x666666, movieclip.color);
		
		//wrong value on color, it should not change
		movieclip.color = -1;
		assertEquals(0x666666, movieclip.color);
	}
}