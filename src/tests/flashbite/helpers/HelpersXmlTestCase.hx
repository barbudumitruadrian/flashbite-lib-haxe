package tests.flashbite.helpers;

import flashbite.helpers.HelpersXml;
import haxe.unit.TestCase;

/**
 * TestCase for HelpersXml
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersXmlTestCase extends TestCase
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
	
	public function test_toObject():Void
	{
		var xmlString = '<node x="0" y="0" width="100" height="100"/>';
		
		var xml = Xml.parse(xmlString).firstElement();
		var obj = {x:0, y:0, width:100, height:100};
		var objCreated = HelpersXml.toObject(xml);
		
		for (key in Reflect.fields(obj)) {
			assertTrue(Reflect.hasField(objCreated, key));
			assertEquals(Reflect.getProperty(obj, key), Reflect.getProperty(objCreated, key));
		}
	}
	
	public function test_getChildren():Void
	{
		var xmlString = 
		'<nodes>' +
			'\n' + 
			'<node_a/>' + 
			'<node_b/>' + 
			'<node_c/>' + 
			'<node_d/>' + 
			'\n' + 
		'</nodes>';
		
		var xml = Xml.parse(xmlString).firstElement();
		var children = HelpersXml.getChildren(xml);
		
		assertEquals(4, children.length);
	}
	
	public function test_getChildrenWithNodeName():Void
	{
		var xmlString = 
		'<nodes>' +
			'<node/>' + 
			'<node/>' + 
			'<node/>' + 
		'</nodes>';
		
		var xml = Xml.parse(xmlString).firstElement();
		var children = HelpersXml.getChildrenWithNodeName(xml, "node");
		
		assertEquals(3, children.length);
	}
}