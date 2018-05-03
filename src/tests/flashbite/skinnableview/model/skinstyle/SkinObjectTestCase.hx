package tests.flashbite.skinnableview.model.skinstyle;

import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import haxe.unit.TestCase;

/**
 * TestCase for SkinObject
 * 
 * @author Adrian Barbu
 */
@:final
class SkinObjectTestCase extends TestCase
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
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// Shape
	public function test_normalProperties_Shape():Void
	{
		var xmlStringShape = '<Shape width="100" height="100" color="0xFFFFFF" name="shape" x="0" y="0" alpha="1" rotation="20"/>';
		var xmlShape = Xml.parse(xmlStringShape).firstElement();
		var skinObjShape:ISkinObject = new SkinObject(xmlShape, 100, 100);
		
		assertTrue(skinObjShape.rawObject != null);
		assertEquals("Shape", skinObjShape.type);
		assertEquals("", skinObjShape.containerType);
		assertTrue(skinObjShape.children != null);
		assertEquals(0, skinObjShape.children.length);
		assertEquals("", skinObjShape.fileName);
		assertEquals("shape", skinObjShape.name);
		
		assertEquals(Std.parseFloat("0"), skinObjShape.x); //specified y
		assertEquals(Std.parseFloat("0"), skinObjShape.y); //specified y
		assertEquals(Std.parseFloat("100"), skinObjShape.width); //specified width
		assertEquals(Std.parseFloat("100"), skinObjShape.height); //specified height
		assertEquals(Std.parseFloat("1"), skinObjShape.alpha);
		assertEquals(Std.parseInt("0xFFFFFF"), skinObjShape.color);
		assertEquals(Std.parseFloat("20"), skinObjShape.rotation);
		
		assertEquals("", skinObjShape.content);
		assertEquals("", skinObjShape.messageID);
		assertEquals("", skinObjShape.textFormat);
		assertEquals(false, skinObjShape.isUpperCase);
	}
	
	public function test_properties_x_y_width_height__SPECIFIED__Shape():Void
	{
		var xmlStringShape = '<Shape width="100" height="100" color="0xFFFFFF" name="shape" x="0" y="0" alpha="1"/>';
		var xmlShape = Xml.parse(xmlStringShape).firstElement();
		var skinObjShape:ISkinObject = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("0"), skinObjShape.x); //specified y
		assertEquals(Std.parseFloat("0"), skinObjShape.y); //specified y
		assertEquals(Std.parseFloat("100"), skinObjShape.width); //specified width
		assertEquals(Std.parseFloat("100"), skinObjShape.height); //specified height
		
		//now we resize... data should not change because is set to specified x, y, width, height
		skinObjShape.resize(1000, 1000);
		
		assertEquals(Std.parseFloat("0"), skinObjShape.x); //specified y
		assertEquals(Std.parseFloat("0"), skinObjShape.y); //specified y
		assertEquals(Std.parseFloat("100"), skinObjShape.width); //specified width
		assertEquals(Std.parseFloat("100"), skinObjShape.height); //specified height
	}
	
	public function test_properties_x_y_width_height__PERCENT__Shape():Void
	{
		var xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="10%" y="10%" alpha="1"/>';
		var xmlShape = Xml.parse(xmlStringShape).firstElement();
		var skinObjShape:ISkinObject = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("10"), skinObjShape.x);
		assertEquals(Std.parseFloat("10"), skinObjShape.y);
		assertEquals(Std.parseFloat("50"), skinObjShape.width);
		assertEquals(Std.parseFloat("50"), skinObjShape.height);
		
		//now we resize
		skinObjShape.resize(1000, 1000);
		
		assertEquals(Std.parseFloat("100"), skinObjShape.x);
		assertEquals(Std.parseFloat("100"), skinObjShape.y);
		assertEquals(Std.parseFloat("500"), skinObjShape.width);
		assertEquals(Std.parseFloat("500"), skinObjShape.height);
	}
	public function test_properties_x_y__X_is_AlignString__Shape():Void
	{
		//left-top
		var xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="left" y="top" alpha="1"/>';
		var xmlShape = Xml.parse(xmlStringShape).firstElement();
		var skinObjShape:ISkinObject = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("0"), skinObjShape.x); //left
		assertEquals(Std.parseFloat("0"), skinObjShape.y); //top
		assertEquals(Std.parseFloat("50"), skinObjShape.width);
		assertEquals(Std.parseFloat("50"), skinObjShape.height);
		
		//left-bottom
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="left" y="bottom" alpha="1"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("0"), skinObjShape.x); //left
		assertEquals(Std.parseFloat("50"), skinObjShape.y); //bottom (100 - 50)
		
		//right-bottom
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="right" y="bottom" alpha="1"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("50"), skinObjShape.x); //right (100 - 50)
		assertEquals(Std.parseFloat("50"), skinObjShape.y); //bottom (100 - 50)
		
		//right-up
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="right" y="top" alpha="1"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("50"), skinObjShape.x); //right (100 - 50)
		assertEquals(Std.parseFloat("0"), skinObjShape.y); //up
		
		//center-center
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="center" y="center" alpha="1"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("25"), skinObjShape.x); //center (100 - 50) / 2
		assertEquals(Std.parseFloat("25"), skinObjShape.y); //up (100 - 50) / 2
		
		//wrong x, wrong y
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="top" y="left" alpha="1"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("0"), skinObjShape.x); //x doesn't know top (only left, right, center), it should fallback to 0
		assertEquals(Std.parseFloat("0"), skinObjShape.y); //y doesn't know left (only top, bottom, center), it should fallback to 0
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// Image
	public function test_normalProperties_Image():Void
	{
		var xmlStringImage = '<Image fileName="image.png" width="100%" height="100%" x="0" y="0" nativeWidth="10" nativeHeight="10" color="0xFFFFFF" alpha="1" name="image"/>';
		var xmlImage = Xml.parse(xmlStringImage).firstElement();
		var skinObjImage:ISkinObject = new SkinObject(xmlImage, 100, 100);
		
		assertEquals("Image", skinObjImage.type);
		assertEquals("", skinObjImage.containerType);
		assertTrue(skinObjImage.children != null);
		assertEquals(0, skinObjImage.children.length);
		assertEquals("image.png", skinObjImage.fileName);
		assertEquals("image", skinObjImage.name);
		assertEquals(Std.parseFloat("1"), skinObjImage.alpha);
		assertEquals(Std.parseInt("0xFFFFFF"), skinObjImage.color);
	}
	
	public function test_nativeWidthAndHeight_Image():Void
	{
		//same aspect ratio
		var xmlStringImage = '<Image width="100%" height="100%" x="0" y="0" nativeWidth="10" nativeHeight="10"/>';
		var xmlImage = Xml.parse(xmlStringImage).firstElement();
		var skinObjImage:ISkinObject = new SkinObject(xmlImage, 100, 100);
		
		assertEquals(Std.parseFloat("0"), skinObjImage.x);
		assertEquals(Std.parseFloat("0"), skinObjImage.y);
		assertEquals(Std.parseFloat("100"), skinObjImage.width);
		assertEquals(Std.parseFloat("100"), skinObjImage.height);
		
		//0,0
		var xmlStringImage = '<Image width="100%" height="100%" x="0" y="0" nativeWidth="100" nativeHeight="50"/>';
		var xmlImage = Xml.parse(xmlStringImage).firstElement();
		var skinObjImage:ISkinObject = new SkinObject(xmlImage, 100, 100);
		
		assertEquals(Std.parseFloat("0"), skinObjImage.x);
		assertEquals(Std.parseFloat("0"), skinObjImage.y);
		assertEquals(Std.parseFloat("100"), skinObjImage.width);
		assertEquals(Std.parseFloat("50"), skinObjImage.height); //image should preserve proportions
		
		//left-center
		xmlStringImage = '<Image width="100%" height="100%" x="left" y="center" nativeWidth="10" nativeHeight="5"/>';
		xmlImage = Xml.parse(xmlStringImage).firstElement();
		skinObjImage = new SkinObject(xmlImage, 100, 100);
		
		assertEquals(Std.parseFloat("0"), skinObjImage.x);
		assertEquals(Std.parseFloat("25"), skinObjImage.y); //(100 - 50) / 2
		assertEquals(Std.parseFloat("100"), skinObjImage.width);
		assertEquals(Std.parseFloat("50"), skinObjImage.height); //image should preserve proportions
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// MovieClip
	public function test_normalProperties_MovieClip():Void
	{
		var xmlStringMovieClip = '<MovieClip filePrefix="image_" frameRate="120" width="100%" height="100%" x="0" y="0" color="0xFFFFFF" alpha="1" name="animation"/>';
		var xmlMovieClip = Xml.parse(xmlStringMovieClip).firstElement();
		var skinObjMovieClip:ISkinObject = new SkinObject(xmlMovieClip, 100, 100);
		
		assertEquals("MovieClip", skinObjMovieClip.type);
		assertEquals("", skinObjMovieClip.containerType);
		assertTrue(skinObjMovieClip.children != null);
		assertEquals(0, skinObjMovieClip.children.length);
		assertEquals("image_", skinObjMovieClip.filePrefix);
		assertEquals(120, skinObjMovieClip.frameRate);
		assertEquals("animation", skinObjMovieClip.name);
		assertEquals(Std.parseFloat("1"), skinObjMovieClip.alpha);
		assertEquals(Std.parseInt("0xFFFFFF"), skinObjMovieClip.color);
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// margin
	public function test_marginXY():Void
	{
		//left-top
		var xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="left" y="top" alpha="1" marginX="10" marginY="10"/>';
		var xmlShape = Xml.parse(xmlStringShape).firstElement();
		var skinObjShape:ISkinObject = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("10"), skinObjShape.x);
		assertEquals(Std.parseFloat("10"), skinObjShape.y);
		assertEquals(Std.parseFloat("50"), skinObjShape.width);
		assertEquals(Std.parseFloat("50"), skinObjShape.height);
		
		//left-bottom
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="left" y="bottom" alpha="1" marginX="10" marginY="10"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("10"), skinObjShape.x);
		assertEquals(Std.parseFloat("40"), skinObjShape.y);
		
		//right-bottom
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="right" y="bottom" alpha="1" marginX="10" marginY="10"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("40"), skinObjShape.x);
		assertEquals(Std.parseFloat("40"), skinObjShape.y);
		
		//right-up
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="right" y="top" alpha="1" marginX="10" marginY="10"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("40"), skinObjShape.x);
		assertEquals(Std.parseFloat("10"), skinObjShape.y);
		
		//center-center
		xmlStringShape = '<Shape width="50%" height="50%" color="0xFFFFFF" name="shape" x="center" y="center" alpha="1" marginX="10" marginY="10"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("25"), skinObjShape.x);
		assertEquals(Std.parseFloat("25"), skinObjShape.y);
		
		
		//center-center (FULL)
		xmlStringShape = '<Shape width="100%" height="100%" color="0xFFFFFF" name="shape" x="center" y="center" alpha="1" marginX="10" marginY="10"/>';
		xmlShape = Xml.parse(xmlStringShape).firstElement();
		skinObjShape = new SkinObject(xmlShape, 100, 100);
		
		assertEquals(Std.parseFloat("10"), skinObjShape.x);
		assertEquals(Std.parseFloat("10"), skinObjShape.y);
		assertEquals(Std.parseFloat("80"), skinObjShape.width);
		assertEquals(Std.parseFloat("80"), skinObjShape.height);
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
}