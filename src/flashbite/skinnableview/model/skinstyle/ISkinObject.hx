package flashbite.skinnableview.model.skinstyle;

import flashbite.skinnableview.IResizable;

/**
 * ISkinObject interface; used to hold all global data that a view can have
 * 
 * @author Adrian Barbu
 */
interface ISkinObject extends IResizable
{
	/** represents the type of the view: ex: ImageSkinnable, ShapeSkinnable, ContainerBase, and any other custom view */
	public var type(get, null):String;
	
	/** represents the containerType of the view, if is a ContainerBase: ex: and any other custom view container */
	public var containerType(get, null):String;
	
	/** list of children, available for ContainerBase or any other custom view container */
	public var children(get, null):Array<ISkinObject>;
	
	/** path to image, if this is a ImageSkinnable */
	public var fileName(get, null):String;
	
	/** prefix of images, if this is a MovieClipSkinnable */
	public var filePrefix(get, null):String;
	/** num frames of a MovieClipSkinnable */
	public var numFrames(get, null):Int;
	/** frameRate of a MovieClipSkinnable */
	public var frameRate(get, null):Int;
	
	/** name in displayList hierarchy */
	public var name(get, null):String;
	
	/** x position after all calculations are made in resize() */
	public var x(get, null):Float;
	/** y position after all calculations are made in resize() */
	public var y(get, null):Float;
	/** width after all calculations are made in resize() */
	public var width(get, null):Float;
	/** height after all calculations are made in resize() */
	public var height(get, null):Float;
	
	/** alpha value of view */
	public var alpha(get, null):Float;
	/** color value of view; it is used by ShapeSkinnable and ImageSkinnable */
	public var color(get, null):Int;
	
	/** rotation value */
	public var rotation(get, null):Float;
	
	/** text to put on TextFieldSkinnable if no messageID is provided or no message from ITexts */
	public var content(get, null):String;
	/** id of message from ITexts to put on TextFieldSkinnable */
	public var messageID(get, null):String;
	/** textFormat name of the TextFieldSkinnable */
	public var textFormat(get, null):String;
	/** tells if the text on TextFieldSkinnable should be upperCase  */
	public var isUpperCase(get, null):Bool;
	
	/** marginX used in conjunction with position X(left, right) */
	public var marginX(get, null):Float;
	/** marginX used in conjunction with position Y(top, bottom) */
	public var marginY(get, null):Float;
	
	/** template used to create from TEMPLATE screen */
	public var template(get, null):String;
	
	/** raw representation of data */
	public var rawObject(get, null):IRawObject;
	
	/** update a property */
	public function updateProperty(propertyName:String, propertyValue:String):Void;
}