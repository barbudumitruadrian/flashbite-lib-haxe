package tests.flashbite.skinnableview.view.movieclip;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.SkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import flashbite.skinnableview.view.movieclip.MovieClipSkinnable;
import haxe.unit.TestCase;

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
		var skinXmlString:String = '<MovieClip width="100" height="5" filePrefix="image_" frameRate="30" numFrames="10"/>';
		var skinnableDataXmlString:String = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style/>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 100, 100, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 100, 100);
		var movieclip = new MovieClipSkinnable(skinObj, skinnableData);
		
		assertEquals(0, movieclip.currentFrame);
		
		movieclip.currentFrame = 10;
		assertEquals(9, movieclip.currentFrame);
		
		movieclip.currentFrame = 7;
		assertEquals(7, movieclip.currentFrame);
		
		movieclip.currentFrame = 100000;
		assertEquals(9, movieclip.currentFrame); //last frame
		
		movieclip.currentFrame = -1;
		assertEquals(0, movieclip.currentFrame); //first frame
	}
}