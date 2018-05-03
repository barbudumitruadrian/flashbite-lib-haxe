package flashbite.skinnableview.model.skinstyle;

import flashbite.align.HorizontalAlign;
import flashbite.align.VerticalAlign;
import flashbite.helpers.HelpersGlobal;
import flashbite.helpers.HelpersXml;
import flashbite.interfaces.IDisposable;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.skinstyle.IRawObject;
import flashbite.skinnableview.model.skinstyle.ISkinObject;

/**
 * SkinObject class; used to hold all global data that a view can have
 * 
 * xml example1:
 * <Shape width="1000" height="1520" color="0xFFFFFF" name="" x="0" y="0" alpha="1"/>
 * or 
 * <Shape width="100%" height="20%" color="0xFFFFFF" name="" x="20%" y="30%" alpha="1"/>
 * or 
 * <Shape width="100%" height="20%" color="0xFFFFFF" name="" x="center" y="bottom" alpha="1"/>
 * 
 * xml example2:
 * <Text content="" messageID="titleTxt" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" width="780" height="250" name="titleTxt" x="150" y="50" alpha="1"/>
 * 
 * @author Adrian Barbu
 */
class SkinObject implements ISkinObject implements IDisposable
{
	private static var PROPERTIES_STRING:Array<String> = [
		"type", "containerType",
		"fileName", "filePrefix",
		"name",
		"content", "messageID", "textFormat",
		"template"
	];
	private static var PROPERTIES_FLOAT:Array<String> = [
		"alpha", "rotation"
	];
	private static var PROPERTIES_INT:Array<String> = [
		"color", 
		"nativeWidth", "nativeHeight",
		"numFrames", "frameRate"
	];
	private static var PROPERTIES_BOOL:Array<String> = [
		"isUpperCase"
	];
	
	public var type(get, null):String = "";
	
	public var containerType(get, null):String = "";
	
	public var children(get, null):Array<ISkinObject> = [];
	
	public var fileName(get, null):String = "";
	
	public var filePrefix(get, null):String = "";
	public var numFrames(get, null):Int = 1;
	public var frameRate(get, null):Int = 60;
	
	public var name(get, null):String = "";
	
	public var x(get, null):Float = 0;
	public var y(get, null):Float = 0;
	public var width(get, null):Float = 1;
	public var height(get, null):Float = 1;
	
	public var alpha(get, null):Float = 1;
	public var color(get, null):Int = -1;
	
	public var rotation(get, null):Float = 0;
	
	public var content(get, null):String = "";
	public var messageID(get, null):String = "";
	public var textFormat(get, null):String = "";
	public var isUpperCase(get, null):Bool = false;
	
	public var marginX(get, null):Float = 0;
	public var marginY(get, null):Float = 0;
	
	public var template(get, null):String = "";
	
	public var rawObject(get, null):IRawObject = new RawObject();
	
	public var nativeWidth:Int = 0;
	public var nativeHeight:Int = 0;
	
	private var _xml:Xml;
	private var _parentWidth:Float;
	private var _parentHeight:Float;
	
	private var _isRoot:Bool = false;
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new(xml:Xml, parentWidth:Float, parentHeight:Float, isRoot:Bool = false)
	{
		_xml = xml;
		_parentWidth = parentWidth;
		_parentHeight = parentHeight;
		_isRoot = isRoot;
		if (_isRoot) {
			Reflect.setProperty(rawObject, "width", "100%");
			Reflect.setProperty(rawObject, "height", "100%");
			Reflect.setProperty(rawObject, "name", "__ROOT__");
		}
		
		readType();
		readStandardProperties();
		readLayoutProperties();
		readChildren();
	}
	
	private function readType():Void
	{
		this.type = _xml.nodeName;
		//in rawObject also
		Reflect.setProperty(rawObject, "type", this.type);
	}
	private function readStandardProperties():Void
	{
		for (attributeName in _xml.attributes()) {
			var attributeValue = _xml.get(attributeName);
			
			setProperty(attributeName, attributeValue);
			
			//in rawObject also
			Reflect.setProperty(rawObject, attributeName, attributeValue);
		}
	}
	private function setProperty(propertyName:String, propertyValue:String):Void
	{
		if (PROPERTIES_STRING.indexOf(propertyName) != -1) {
			Reflect.setProperty(this, propertyName, propertyValue);
		}
		
		if (PROPERTIES_FLOAT.indexOf(propertyName) != -1) {
			var floatValue = Std.parseFloat(propertyValue);
			if (Math.isFinite(floatValue)) {
				Reflect.setProperty(this, propertyName, floatValue);
			}
		}
		if (PROPERTIES_INT.indexOf(propertyName) != -1) {
			var intValue = Std.parseInt(propertyValue);
			if (intValue != null) {
				Reflect.setProperty(this, propertyName, intValue);
			}
		}
		
		if (PROPERTIES_BOOL.indexOf(propertyName) != -1) {
			Reflect.setProperty(this, propertyName, HelpersGlobal.translateToBoolean(propertyValue));
		}
	}
	private function readLayoutProperties():Void
	{
		//width + height
		this.width = calculate("width", _parentWidth, 1);
		this.height = calculate("height", _parentHeight, 1);
		this.marginX = calculate("marginX", _parentWidth, 0);
		this.marginY = calculate("marginY", _parentHeight, 0);
		
		if (Math.isFinite(nativeWidth) && Math.isFinite(nativeHeight) && nativeWidth != 0 && nativeHeight != 0) {
			var minScale = Math.min(this.width / nativeWidth, this.height / nativeHeight);
			this.width = minScale * nativeWidth;
			this.height = minScale * nativeHeight;
		}
		
		//x + y
		var propertyValueAsStringX:String = rawObject.getPropertyValue("x", true, "0");
		if (HorizontalAlign.isKnown(propertyValueAsStringX)) {
			switch (propertyValueAsStringX) {
				case HorizontalAlign.LEFT:
					this.x = marginX;
				case HorizontalAlign.RIGHT:
					this.x = _parentWidth - this.width - marginX;
				case HorizontalAlign.CENTER:
					if (_parentWidth == this.width) {
						this.width -= marginX * 2;
					}
					this.x = (_parentWidth - this.width) / 2;
			}
		} else {
			this.x = calculate("x", _parentWidth, Math.NEGATIVE_INFINITY + 1);
		}
		var propertyValueAsStringY:String = rawObject.getPropertyValue("y", true, "0");
		if (VerticalAlign.isKnown(propertyValueAsStringY)) {
			switch (propertyValueAsStringY) {
				case VerticalAlign.TOP:
					this.y = 0 + marginY;
				case VerticalAlign.BOTTOM:
					this.y = _parentHeight - this.height - marginY;
				case VerticalAlign.CENTER:
					if (_parentHeight == this.height) {
						this.height -= marginY * 2;
					}
					this.y = (_parentHeight - this.height) / 2;
			}
		} else {
			this.y = calculate("y", _parentHeight, Math.NEGATIVE_INFINITY + 1);
		}
		
		roundToInt();
	}
	private function roundToInt():Void
	{
		this.x = Math.round(this.x);
		this.y = Math.round(this.y);
		this.width = Math.round(this.width);
		this.height = Math.round(this.height);
	}
	
	private function calculate(propertyName:String, baseValue:Float, minValue:Float, defaultValue:String = "0"):Float
	{
		var propertyValueAsString = rawObject.getPropertyValue(propertyName, true, defaultValue);
		//first check percent
		if (propertyValueAsString.indexOf("%") != -1) {
			propertyValueAsString = propertyValueAsString.split("%").join("");
			var percent = Std.parseFloat(propertyValueAsString);
			if (Math.isFinite(percent)) {
				percent = percent / 100;
			} else {
				percent = 0;
			}
			var propertyValueFloat = baseValue * percent;
			propertyValueFloat = Math.max(Math.min(propertyValueFloat, baseValue), minValue);
			return propertyValueFloat;
		} else {
			//parse to int
			var propertyValueInt = Std.parseInt(propertyValueAsString);
			if (propertyValueInt != null) {
				propertyValueInt = Std.int(Math.max(Math.min(propertyValueInt, baseValue), minValue));
				return propertyValueInt;
			}
		}
		
		return 0;
	}
	
	private function readChildren():Void
	{
		var allXmlChildren = HelpersXml.getChildren(_xml);
		for (childXml in allXmlChildren) {
			children.push(new SkinObject(childXml, this.width, this.height));
		}
	}
	
	public function dispose():Void
	{
		rawObject = null;
		for (child in children) {
			(cast (child, IDisposable)).dispose();
		}
		children = null;
		_xml = null;
	}
	
	// =====================================================================================================================================
	// clone
	// =====================================================================================================================================
	
	public function clone():ISkinObject { return new SkinObject(_xml, _parentWidth, _parentHeight); }
	
	// =====================================================================================================================================
	// update with a template
	// =====================================================================================================================================
	
	public function updateWithTemplate(templateRootSkinObj:ISkinObject):Void
	{
		if (template != null && template != "") {
			//get child with name template
			var templateSkinObj = null;
			for (childSkinObj in templateRootSkinObj.children) {
				if (childSkinObj.name == template) {
					templateSkinObj = childSkinObj;
				}
			}
			if (templateSkinObj != null) {
				//copy children from template
				children = [];
				for (child in templateSkinObj.children) {
					children.push((cast (child, SkinObject)).clone());
				}
			} else {
				Logger.warning(this, "Unable to get templateSkinObj with name " + template);
			}
		}
		
		//now children
		for (child in children) {
			(cast (child, SkinObject)).updateWithTemplate(templateRootSkinObj);
		}
	}
	
	// =====================================================================================================================================
	// IResizable
	// =====================================================================================================================================
	
	public function resize(width:Float, height:Float):Void 
	{
		_parentWidth = width;
		_parentHeight = height;
		
		//resize this
		readLayoutProperties();
		
		//resize children with internal width and height (@see this)
		for (child in children) {
			child.resize(this.width, this.height);
		}
	}
	
	// =====================================================================================================================================
	// GETTERS
	// =====================================================================================================================================
	
	function get_type():String { return type; }
	
	function get_containerType():String { return containerType; }
	
	function get_children():Array<ISkinObject> { return children; }
	
	function get_fileName():String { return fileName; }
	
	function get_filePrefix():String { return filePrefix; }
	function get_numFrames():Int { return numFrames; }
	function get_frameRate():Int { return frameRate; }
	
	function get_name():String { return name; }
	
	function get_x():Float { return x; }
	function get_y():Float { return y; }
	function get_width():Float { return width; }
	function get_height():Float { return height; }
	
	function get_alpha():Float { return alpha; }
	function get_color():Int { return color; }
	
	function get_rotation():Float { return rotation; }
	
	function get_content():String { return content; }
	function get_messageID():String { return messageID; }
	function get_textFormat():String { return textFormat; }
	function get_isUpperCase():Bool { return isUpperCase; }
	
	function get_marginX():Float { return marginX; }
	function get_marginY():Float { return marginY; }
	
	function get_template():String { return template; }
	
	function get_rawObject():IRawObject { return rawObject; }
}