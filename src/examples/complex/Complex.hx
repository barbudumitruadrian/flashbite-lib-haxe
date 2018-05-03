package examples.complex;

import examples.ExampleBase;
import examples.complex.views.TitleAndValueView;
import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import motion.Actuate;
import motion.actuators.IGenericActuator;

/**
 * Complex example with template and language changing
 * 
 * @author Adrian Barbu
 */
@:final
class Complex extends ExampleBase
{
	private var _item1:TitleAndValueView;
	private var _item2:TitleAndValueView;
	
	private var _titleTxt:TextFieldSkinnable;
	
	private var _delay:IGenericActuator;
	
	public function new() { super(ExampleNames.COMPLEX); }
	
	override public function dispose():Void 
	{
		_item1 = _item2 = null;
		_titleTxt = null;
		if (_delay != null) {
			Actuate.stop(_delay, null, false, false);
			_delay = null;
		}
		
		super.dispose();
	}
	
	override function registerCustoms():Void
	{
		_skinnableViewCreator.registerCustomDisplayObjectContainer(TitleAndValueView.NAME, TitleAndValueView);
	}
	override function createProperties():Void
	{
		_styleXml = getDefaultStyleXml();
		_textsXml = getDefaultTextsXml();
		_textFormatsXml = getDefaultTextFormatsXml();
		
		_language = "en";
		_width = _height = 100;
	}
	
	override function internalInitialize():Void
	{
		_titleTxt = cast HelpersGlobal.getChildByName(this, "container.up.titleTxt");
		
		_item1 = cast HelpersGlobal.getChildByName(this, "container.items.item1");
		_item2 = cast HelpersGlobal.getChildByName(this, "container.items.item2");
		
		_item1.initialize("300");
		_item2.initialize("500");
	}
	override function internalStart():Void
	{
		Logger.debug(this, "internalStart");
		
		_delay = Actuate.timer(1).onComplete(changeLanguageTo, ["fr"]);
	}
	
	private function changeLanguageTo(newLanguage:String):Void
	{
		Logger.debug(this, "changeLanguageTo(" + newLanguage + ")");
		
		_skinnableViewCreator.language = newLanguage;
		_skinnableViewCreator.updateLanguageOn(this);
		
		//we must call manually the redraw on sub-components to re-apply custom text
		_item1.redraw();
		_item2.redraw();
	}
}