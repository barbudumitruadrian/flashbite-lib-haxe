package tests.flashbite.skinnableview;

import flashbite.helpers.HelpersXml;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.image.ImageSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for SkinnableViewCreator, resize zone
 * 
 * @author Adrian Barbu
 */
@:final
class SkinnableViewCreator_RESIZE_TestCase extends TestCase
{
	private var _skinnableViewCreator:ISkinnableViewCreator;
	private var _container:Sprite;
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
		
		_skinnableViewCreator = new SkinnableViewCreator();
		_container = new Sprite();
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
		
		_skinnableViewCreator = null;
		_container = null;
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	private function getMainScreenChildrenXml(styleXml:Xml):Array<Xml>
	{
		var screensXml = HelpersXml.getChildrenWithNodeName(styleXml, "screens")[0];
		var mainScreenXml = screensXml.firstChild(); //main
		var screenStyleXml = HelpersXml.getChildrenWithNodeName(mainScreenXml, "style")[0];
		return HelpersXml.getChildren(screenStyleXml);
	}
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// image
	public function test_resize_image_normal():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Image fileName="bg" width="20%" height="20%" name="bg" x="20" y="30%" alpha="1"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		var mainScreenChildrenXml = getMainScreenChildrenXml(styleXml);
		
		_skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var imageXml = mainScreenChildrenXml[0];
		var imageView:ImageSkinnable = cast _container.getChildByName(imageXml.get("name"));
		
		assertEquals(Std.parseFloat("20"), imageView.width); //100 is base dimension, 20% is the width
		assertEquals(Std.parseFloat("20"), imageView.height); //100 is base dimension, 20% is the height
		assertEquals(Std.parseFloat("20"), imageView.x); //fixed position
		assertEquals(Std.parseFloat("30"), imageView.y); //30% of 100
		
		_skinnableViewCreator.resize(_container, "main", 200, 200);
		
		assertEquals(Std.parseFloat("40"), imageView.width);
		assertEquals(Std.parseFloat("40"), imageView.height);
		assertEquals(Std.parseFloat("20"), imageView.x);
		assertEquals(Std.parseFloat("60"), imageView.y);
	}
	public function test_resize_image_WithNativeWidthAndHeight():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Image fileName="bg" width="100%" height="30%" name="bg" x="right" y="center" alpha="1" nativeWidth="20" nativeHeight="20"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		var mainScreenChildrenXml = getMainScreenChildrenXml(styleXml);
		
		_skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var imageXml = mainScreenChildrenXml[0];
		var imageView:ImageSkinnable = cast _container.getChildByName(imageXml.get("name"));
		
		assertEquals(Std.parseFloat("30"), imageView.width);
		assertEquals(Std.parseFloat("30"), imageView.height);
		assertEquals(Std.parseFloat("70"), imageView.x); //100 - 30
		assertEquals(Std.parseFloat("35"), imageView.y); // (100 - 30) / 2
		
		_skinnableViewCreator.resize(_container, "main", 200, 200);
		
		assertEquals(Std.parseFloat("60"), imageView.width);
		assertEquals(Std.parseFloat("60"), imageView.height);
		assertEquals(Std.parseFloat("140"), imageView.x);
		assertEquals(Std.parseFloat("70"), imageView.y);
	}
	public function test_resize_image_WithNativeWidthAndHeight_WithMargin():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Image fileName="bg" width="100%" height="30%" name="bg" x="right" y="center" alpha="1" nativeWidth="20" nativeHeight="20" marginX="20"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		var mainScreenChildrenXml = getMainScreenChildrenXml(styleXml);
		
		_skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var imageXml = mainScreenChildrenXml[0];
		var imageView:ImageSkinnable = cast _container.getChildByName(imageXml.get("name"));
		
		assertEquals(Std.parseFloat("30"), imageView.width);
		assertEquals(Std.parseFloat("30"), imageView.height);
		assertEquals(Std.parseFloat("50"), imageView.x); //100 - 30 - 20
		assertEquals(Std.parseFloat("35"), imageView.y); // (100 - 30) / 2
		
		_skinnableViewCreator.resize(_container, "main", 200, 200);
		
		assertEquals(Std.parseFloat("60"), imageView.width);
		assertEquals(Std.parseFloat("60"), imageView.height);
		assertEquals(Std.parseFloat("120"), imageView.x); //200 - 60 - 20
		assertEquals(Std.parseFloat("70"), imageView.y);
	}
	public function test_resize_image_WithNativeWidthAndHeight_WithMarginPercent():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Image fileName="bg" width="100%" height="30%" name="bg" x="right" y="center" alpha="1" nativeWidth="20" nativeHeight="20" marginX="10%"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		var mainScreenChildrenXml = getMainScreenChildrenXml(styleXml);
		
		_skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var imageXml = mainScreenChildrenXml[0];
		var imageView:ImageSkinnable = cast _container.getChildByName(imageXml.get("name"));
		
		assertEquals(Std.parseFloat("30"), imageView.width);
		assertEquals(Std.parseFloat("30"), imageView.height);
		assertEquals(Std.parseFloat("60"), imageView.x); //100 - 30 - (10% of 100)
		assertEquals(Std.parseFloat("35"), imageView.y); // (100 - 30) / 2
		
		_skinnableViewCreator.resize(_container, "main", 200, 200);
		
		assertEquals(Std.parseFloat("60"), imageView.width);
		assertEquals(Std.parseFloat("60"), imageView.height);
		assertEquals(Std.parseFloat("120"), imageView.x); //200 - 60 - (10% of 200)
		assertEquals(Std.parseFloat("70"), imageView.y);
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// container
	public function test_resize_container_simple():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container width="20%" height="50%" name="container" x="50" y="bottom">' +
							'<Image fileName="bg" width="20%" height="20%" name="bg" x="5" y="30%" alpha="1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		
		_skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var containerView:ContainerBase = cast _container.getChildByName("container");
		var imageView:ImageSkinnable = cast containerView.getChildByName("bg");
		
		//check sync between skin and visual
		assertEquals(containerView.skinObj.x, containerView.x);
		assertEquals(containerView.skinObj.y, containerView.y);
		assertEquals(imageView.skinObj.width, imageView.width);
		assertEquals(imageView.skinObj.height, imageView.height);
		assertEquals(imageView.skinObj.x, imageView.x);
		assertEquals(imageView.skinObj.y, imageView.y);
		
		//check real/specific dimensions
		assertEquals(Std.parseFloat("20"), containerView.skinObj.width); // 20% of 100
		assertEquals(Std.parseFloat("50"), containerView.skinObj.height); // 50% of 100
		assertEquals(Std.parseFloat("50"), containerView.x); //fixed
		assertEquals(Std.parseFloat("50"), containerView.y); //100 - (50% of 100)
		
		assertEquals(Std.parseFloat("4"), imageView.width); //20% of (20% of 100)
		assertEquals(Std.parseFloat("10"), imageView.height); //20% of (50% of 100)
		assertEquals(Std.parseFloat("5"), imageView.x); //fixed
		assertEquals(Std.parseFloat("15"), imageView.y); // 30% of (50% of 100)
		
		_skinnableViewCreator.resize(_container, "main", 200, 200);
		
		assertEquals(Std.parseFloat("40"), containerView.skinObj.width);
		assertEquals(Std.parseFloat("100"), containerView.skinObj.height);
		assertEquals(Std.parseFloat("50"), containerView.x);
		assertEquals(Std.parseFloat("100"), containerView.y);
		
		assertEquals(Std.parseFloat("8"), imageView.width);
		assertEquals(Std.parseFloat("20"), imageView.height);
		assertEquals(Std.parseFloat("5"), imageView.x);
		assertEquals(Std.parseFloat("30"), imageView.y);
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
}