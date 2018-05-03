package flashbite.helpers;

/**
 * XML helpers
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersXml 
{
	private function new() {}
	
	/** Convert a xml node to an object */
	public static function toObject(xml:Xml):Dynamic
	{
		var returnObj:Dynamic = {};

		for (attributeName in xml.attributes()) {
			Reflect.setField(returnObj, attributeName, xml.get(attributeName).toString());
		}

		return returnObj;
	}
	
	/** get all children */
	public static function getChildren(xml:Xml):Array<Xml>
	{
		var children = new Array<Xml>();
		
		for (childXml in xml) {
			if (childXml.nodeType == Xml.Element && childXml.nodeName != null) {
				children.push(childXml);
			}
		}
		
		return children;
	}
	
	/** get all children with nodeName specified */
	public static function getChildrenWithNodeName(xml:Xml, nodeName:String):Array<Xml>
	{
		var allChildren = getChildren(xml);
		var children = new Array<Xml>();
		
		for (childXml in allChildren) {
			if (childXml.nodeName.toLowerCase() == nodeName.toLowerCase()) {
				children.push(childXml);
			}
		}
		
		return children;
	}
}