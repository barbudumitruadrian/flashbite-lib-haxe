package flashbite.skinnableview.view;

import flashbite.interfaces.IDisposable;
import flashbite.skinnableview.model.skinstyle.ISkinObject;

/**
 * Base interface for working with Skinnable views (Button, Image, Text)
 * 
 * @author Adrian Barbu
 */
interface ISkinnableView extends IDisposable
{
	public var skinObj(get, null):ISkinObject;
	
	public function redraw():Void;
	
	public function removeFromParent(disposeIt:Bool = true):Void;
}