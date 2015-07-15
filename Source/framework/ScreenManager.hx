package framework;
import framework.Screen;
import haxe.Timer;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class ScreenManager extends Sprite
{
	var DURATION :Float = 0.75;
	static var _instance :ScreenManager;
	
	var _readyToShowScreen :Bool = false;
	var _previousScreen :Screen;
	var _currentScreen :Screen;
	var _topScreen :Screen;
	
	function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.ENTER_FRAME, onUpdate);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		_readyToShowScreen = true;
	}
	
	public function showOnScreen(screen :Screen) {
		if (!_readyToShowScreen) {
			trace("Add the ScreenManager to the Main sprite first!");
			return;
		}
		
		
		if (_currentScreen != null) {
			_previousScreen = _currentScreen;
			
			playAlphaToTransparent(_previousScreen, DURATION, onScreenFullyTransparent);
			Timer.delay(onShowCurrentScreen, Std.int(DURATION * 1000));
		} else {
			addChild(screen);
			playAlphaToOpaque(screen, DURATION, onScreenFullyOpaque);
		}
		_currentScreen = screen;
	}
	
	public function showOnTop(screen :Screen) {
		_topScreen = screen;
		addChild(screen);
	}
	
	public function removeTopScreen() {
		if (_topScreen != null) {
			removeChild(_topScreen);
			_topScreen = null;
		}
	}
	
	
	function onShowCurrentScreen() 
	{
		addChild(_currentScreen);
		playAlphaToOpaque(_currentScreen, DURATION, onScreenFullyOpaque);
	}
	
	function playAlphaToOpaque(screen :Screen, duration :Float, functionToAfter :Screen->Void) 
	{
		screen.alpha = 0;
		Actuate.tween(screen, duration, { alpha :1 } ).onComplete(functionToAfter, [screen]);
	}
	
	function playAlphaToTransparent(screen :Screen, duration :Float, functionToAfter :Screen->Void) 
	{
		screen.alpha = 1;
		Actuate.tween(screen, duration, { alpha :0 } ).onComplete(functionToAfter, [screen]);
	}
	
	
	
	function onScreenFullyTransparent(screen :Screen) 
	{
		removeChild(_previousScreen);
		_previousScreen = null;
		//...
		//trace("Transparent");
	}
	
	function onScreenFullyOpaque(screen :Screen) 
	{
		//...
		//trace("Opaque");
	}
	
	
	private function onUpdate(e:Event):Void 
	{
		TimeManager.getInstance().update();
		if (_topScreen != null) {
			_topScreen.onUpdate(e);
			return;
		}
		
		if (_currentScreen != null)
			_currentScreen.onUpdate(e);
	}
	
	
	private function onRemoved(e:Event):Void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		removeEventListener(Event.ENTER_FRAME, onUpdate);
	}
	
	public static function getInstance() {
		if (_instance == null)
			_instance = new ScreenManager();
		return _instance;
	}
	
}