package flashbite.skinnableview;

import flashbite.helpers.HelpersString;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.SkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.ElementContainerType;
import flashbite.skinnableview.view.ElementType;
import flashbite.skinnableview.view.ISkinnableView;
import flashbite.skinnableview.view.ViewBase;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.errors.Error;

/**
 * SkinnableViewCreator class; 
 * init it with data and then construct a screen; 
 * If you want specific classes to be created, just use registerCustomDisplayObject and registerCustomDisplayObjectContainer;
 * 
 * @author Adrian Barbu
 */
@:final
class SkinnableViewCreator implements ISkinnableViewCreator
{
	public static var NUM_ELEMENTS_CREATED:Int = 0;
	
	public var skinnableData(get, null):ISkinnableData;
	@:isVar public var language(get, set):String;
	
	private var _databaseCustomObjs:Map<String, Dynamic> = new Map<String, Dynamic>();
	private var _databaseCustomContainers:Map<String, Dynamic> = new Map<String, Dynamic>();

	private var _screenName:String;

	private var _rootContainer:DisplayObjectContainer;

	private var _mainSkinObj:ISkinObject;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() {}
	
	public function dispose():Void 
	{
		skinnableData = null;
		_databaseCustomContainers = _databaseCustomObjs = null;
		_mainSkinObj = null;
		_rootContainer = null;
	}
	
	// ====================================================================================================================================
	// IResizable
	// ====================================================================================================================================
	
	public function resize(container:DisplayObjectContainer, screenName:String, width:Float, height:Float):Void
	{
		//resize data
		screenName = HelpersString.toLowerCase(screenName);
		var skinObj = skinnableData.getSkinObject(screenName);
		skinObj.resize(width, height);
		
		//redraw views
		recursiveCallRedraw(container);
	}
	
	private function recursiveCallRedraw(container:DisplayObject):Void
	{
		//pre redraw
		if (Std.is(container, ISkinnableView)) {
			var skinnableView:ISkinnableView = cast container;
			skinnableView.redraw();
		}

		if (Std.is(container, DisplayObjectContainer)) {
			var dObjCont:DisplayObjectContainer = cast container;
			//redraw children
			var numChildren:Int = dObjCont.numChildren;
			for (i in 0...numChildren) {
				recursiveCallRedraw(dObjCont.getChildAt(i));
			}
			
			//post redraw
			if (Std.is(dObjCont, ISkinnableView)) {
				var skinnableView:ISkinnableView = cast dObjCont;
				skinnableView.redraw();
			}
		}
	}
	
	// ====================================================================================================================================
	// ISkinnableViewCreator
	// ====================================================================================================================================
	
	public function initialize(styleXml:Xml, textsXml:Xml, textFormatsXml:Xml, language:String, screenWidth:Float, screenHeight:Float):Void
	{
		skinnableData = new SkinnableData();
		skinnableData.initialize(styleXml, textsXml, textFormatsXml, language, screenWidth, screenHeight);
		this.language = language;
	}
	
	public function construct(container:DisplayObjectContainer, screenName:String, screenWidth:Float, screenHeight:Float):Void
	{
		_rootContainer = container;
		_screenName = HelpersString.toLowerCase(screenName);

		//get props
		_mainSkinObj = skinnableData.getSkinObject(_screenName);
		_mainSkinObj.resize(screenWidth, screenHeight);

		//create and add them
		addElementToContainer(container, _mainSkinObj, true);

		_screenName = null;
	}
	
	public function constructChild(container:DisplayObjectContainer, screenName:String, childName:String, containerWidth:Float = -1, containerHeight:Float = -1):DisplayObject
	{
		_screenName = HelpersString.toLowerCase(screenName);
		childName = HelpersString.toLowerCase(childName);

		var found:Bool = false;
		//get props
		var objProps = skinnableData.getSkinObject(_screenName);
		for (child in objProps.children) {
			if (HelpersString.toLowerCase(child.name) == childName) {
				objProps = child;
				found = true;
				break;
			}
		}

		var createdElement:DisplayObject = null;

		if (found) {
			if (containerWidth == -1 || containerHeight == -1) {
				containerWidth = objProps.width;
				containerHeight = objProps.height;
			}
			objProps.resize(containerWidth, containerHeight);
			
			//create and add it
			createdElement = addElementToContainer(container, objProps, false);
		}
		else {
			Logger.error(this, "constructChild, error screen '" + screenName + "' doesn't have a child with name '" + childName + "'");
		}

		_screenName = null;

		return createdElement;
	}
	
	public function destruct(container:DisplayObjectContainer):Void
	{
		//dispose any added skinnableView children
		var skinnableViewChildren:Array<ISkinnableView> = [];
		for (childIndex in 0...container.numChildren) {
			var child = container.getChildAt(childIndex);
			if (Std.is(child, ISkinnableView)) {
				skinnableViewChildren.push(cast child);
			}
		}
		for (child in skinnableViewChildren) {
			child.removeFromParent(true);
		}
	}
	
	public function registerCustomDisplayObject(name:String, clazz:Dynamic, overrideCurrent:Bool = true):Bool
	{
		var write = true;
		name = HelpersString.toLowerCase(name);

		if (_databaseCustomObjs.exists(name) && overrideCurrent == false) {
			write = false;
			Logger.warning(this, "Unable to override display object " + name);
		}

		if (write) {
			_databaseCustomObjs.set(name, clazz);
		}

		return write;
	}
	
	public function registerCustomDisplayObjectContainer(name:String, clazz:Dynamic, overrideCurrent:Bool = true):Bool
	{
		var write = true;
		name = HelpersString.toLowerCase(name);

		if (_databaseCustomContainers.exists(name) && overrideCurrent == false) {
			write = false;
			Logger.warning(this, "Unable to override display object container " + name);
		}

		if (write) {
			_databaseCustomContainers.set(name, clazz);
		}

		return write;
	}
	
	public function updateLanguageOn(container:DisplayObjectContainer):Void
	{
		TextFieldSkinnable.recursiveUpdateLanguageTexts(container);
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	private function addElementToContainer(container:DisplayObject, objProps:ISkinObject, isStartContainer:Bool = false):DisplayObject
	{
		var currentContainer:DisplayObject = null;
		if (isStartContainer) {
			currentContainer = container;
		} else {
			currentContainer = createElement(container, objProps);
		}

		var objPropsChildren = objProps.children;
		if (objPropsChildren.length != 0) {
			for (childObj in objPropsChildren) {
				childObj.resize(objProps.width, objProps.height);
				addElementToContainer(currentContainer, childObj, false);
			}
		}

		return currentContainer;
	}

	private function createElement(parentContainer:DisplayObject, objProps:ISkinObject):DisplayObject
	{
		var newElement = elementConstruct(objProps);

		if (newElement != null) {
			elementSetProps(newElement, objProps, parentContainer);
		}

		return newElement;
	}

	private function elementConstruct(objProps:ISkinObject):DisplayObject
	{
		var newElement:DisplayObject = null;
		
		var type = HelpersString.toLowerCase(objProps.type);
		
		if (type == HelpersString.toLowerCase(ElementType.CONTAINER)) {
			var containerType = HelpersString.toLowerCase(objProps.containerType);
			if (containerType == "") {
				newElement = new ContainerBase(objProps, skinnableData);
			} else if (ElementContainerType.isKnown(containerType)) {
				var clazz = ElementContainerType.getClass(containerType);
				try {
					newElement = Type.createInstance(clazz, [objProps, skinnableData]);
				}
				catch (e:Dynamic) {
					Logger.error(this, "Unable to create container with containerType " + containerType + " and class " + clazz + ", err : " + e);
				}
			} else {
				if (_databaseCustomContainers.exists(containerType)) {
					var clazz = _databaseCustomContainers.get(containerType);
					try {
						newElement = Type.createInstance(clazz, [objProps, skinnableData]);
					}
					catch (e:Dynamic) {
						Logger.error(this, "Unable to create container with containerType " + containerType + " and class " + clazz + ", err : " + e);
					}
					
					var isCorrectViewContainer:Bool = Std.is(newElement, ContainerBase);
					if (newElement != null && isCorrectViewContainer == false) {
						newElement = null;
						throw new Error("element with objProps.type == ElementType.CONTAINER and containerType = '" + containerType + "' must extend flashbite.skinnableview.view.ContainerBase");
					}
				}
				else {
					throw new Error("Please registerCustomDisplayObjectContainer with objProps.containerType = '" + containerType + "' !!!");
				}
			}
		} else {
			if (ElementType.isKnown(type)) {
				var clazz = ElementType.getClass(type);
				try {
					newElement = Type.createInstance(clazz, [objProps, skinnableData]);
				}
				catch (e:Dynamic) {
					Logger.error(this, "Unable to create element of type " + type + " and class " + clazz + ", err : " + e);
				}
			} else {
				if (_databaseCustomObjs.exists(type)) {
					var clazz = _databaseCustomObjs.get(type);
					try {
						newElement = Type.createInstance(clazz, [objProps, skinnableData]);
					}
					catch (e:Dynamic) {
						Logger.error(this, "Unable to create element with type " + type + " and class " + clazz + ", err : " + e);
						newElement = null;
						throw new Error("Registered CustomDisplayObject with objProps.type = '" + type + "' and class " + clazz + " can't be created");
					}
					
					var isCorrectView:Bool = Std.is(newElement, ViewBase) || Std.is(newElement, ISkinnableView);
					if (newElement != null && isCorrectView == false) {
						newElement = null;
						throw new Error("element with objProps.type == " + type + "' must extend flashbite.skinnableview.view.ViewBase or must be an ISkinnableView");
					}
				}
				else {
					throw new Error("Please registerCustomDisplayObject with objProps.type = '" + type + "' !!!");
				}
			}
		}

		if (newElement != null) {
			NUM_ELEMENTS_CREATED++;
		}
		
		return newElement;
	}

	private function elementSetProps(newElement:DisplayObject, objProps:ISkinObject, parentContainer:DisplayObject):Void
	{
		newElement.name = objProps.name;
		newElement.alpha = objProps.alpha;
		
		if (parentContainer != null && Std.is(parentContainer, DisplayObjectContainer)) {
			(cast (parentContainer, DisplayObjectContainer)).addChild(newElement);
		}
		else {
			//nothing
		}
	}
	
	// ====================================================================================================================================
	// GETTERS, SETTERS
	// ====================================================================================================================================
	
	function get_skinnableData():ISkinnableData { return skinnableData; }
	
	function get_language():String { return skinnableData.language; }
	function set_language(value:String):String { return skinnableData.language = value; }
}