package examples;

import examples.complex.Complex;
import examples.simple.Simple;
import flashbite.logger.Logger;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Adrian Barbu
 */
@:final
class ExamplesExplorer extends Sprite
{
	private var _allExamples:Array<ExampleClassToNameMap> = [
		new ExampleClassToNameMap(ExampleNames.SIMPLE, Simple),
		new ExampleClassToNameMap(ExampleNames.COMPLEX, Complex)
	];
	private var _currentExample:ExampleClassToNameMap;
	
	public function new()
	{
		super();
	}
	
	public function initializeAndStart():Void
	{
		replaceView(0);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
	}
	
	private function onKeyDown(e:KeyboardEvent):Void
	{
		switch (e.keyCode) {
			case Keyboard.RIGHT:
				navigate(1);
			case Keyboard.LEFT:
				navigate(-1);
		}
	}
	
	private function navigate(direction:Int):Void
	{
		Logger.debug(this, "navigate(direction= " + direction + ")");
		
		//calculate next index (circular way)
		var currentIndex = _allExamples.indexOf(_currentExample);
		var nextIndex:Int = currentIndex;
		if (currentIndex + direction < 0) {
			nextIndex = _allExamples.length - 1;
		} else if (currentIndex + direction > _allExamples.length - 1) {
			nextIndex = 0;
		} else {
			nextIndex = currentIndex + direction;
		}
		
		if (nextIndex != currentIndex) {
			replaceView(nextIndex);
		}
	}
	private function replaceView(index:Int):Void
	{
		Logger.debug(this, "replaceView(index= " + index + ")");
		
		disposeCurrentView();
		createAndAddView(index);
		
	}
	private function disposeCurrentView():Void
	{
		if (_currentExample != null) {
			_currentExample.view.dispose();
			this.removeChild(_currentExample.view);
			_currentExample.view = null;
		}
	}
	private function createAndAddView(index:Int):Void
	{
		_currentExample = _allExamples[index];
		_currentExample.view = Type.createInstance(_currentExample.clazz, []);
		this.addChild(_currentExample.view);
		_currentExample.view.initAndStart();
	}
}

@final
class ExampleClassToNameMap
{
	public var clazz:Dynamic;
	public var name:String;
	
	public var view:ExampleBase;
	
	public function new(name:String, clazz:Dynamic)
	{
		this.name = name;
		this.clazz = clazz;
	}
}