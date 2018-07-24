package tests.flashbite.skinnableview.view.layout.data;

import flashbite.align.HorizontalAlign;
import flashbite.align.VerticalAlign;
import flashbite.skinnableview.view.layout.data.ILayoutData;
import flashbite.skinnableview.view.layout.data.LayoutData;
import haxe.unit.TestCase;

/**
 * TestCase for LayoutData
 * 
 * @author Adrian Barbu
 */
@:final
class LayoutDataTestCase extends TestCase
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
	
	public function test_readFromObject():Void
	{
		var data:ILayoutData = new LayoutData();
		var obj = {padding:1000, autoSizePadding:true, verticalAlign:VerticalAlign.TOP, horizontalAlign:HorizontalAlign.LEFT};
		(cast (data, LayoutData)).readFromObject(obj);
		
		assertEquals(Std.parseFloat(Std.string(obj.padding)), data.padding);
		assertEquals(obj.autoSizePadding, data.autoSizePadding);
		assertEquals(obj.verticalAlign, data.verticalAlign);
		assertEquals(obj.horizontalAlign, data.horizontalAlign);
	}
	
	public function test_changeProperties():Void
	{
		var data:ILayoutData = new LayoutData();
		
		data.padding = 10;
		assertEquals(Std.parseFloat("10"), data.padding);
		
		data.autoSizePadding = false;
		assertEquals(false, data.autoSizePadding);
		
		data.verticalAlign = VerticalAlign.TOP;
		assertEquals(VerticalAlign.TOP, data.verticalAlign);
		
		data.horizontalAlign = HorizontalAlign.LEFT;
		assertEquals(HorizontalAlign.LEFT, data.horizontalAlign);
	}
	
	public function test_changeProperties_incorrect():Void
	{
		var data:ILayoutData = new LayoutData();
		
		data.padding = 10;
		assertEquals(Std.parseFloat("10"), data.padding);
		
		//it should not change into negative value
		data.padding = -10;
		assertEquals(Std.parseFloat("10"), data.padding);
		
		data.verticalAlign = VerticalAlign.TOP;
		assertEquals(VerticalAlign.TOP, data.verticalAlign);
		data.verticalAlign = "";
		assertEquals(VerticalAlign.TOP, data.verticalAlign);
		
		data.horizontalAlign = HorizontalAlign.LEFT;
		assertEquals(HorizontalAlign.LEFT, data.horizontalAlign);
		data.horizontalAlign = "";
		assertEquals(HorizontalAlign.LEFT, data.horizontalAlign);
	}
}