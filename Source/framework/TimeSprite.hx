package framework;
import events.UpdateEvent;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Nickan
 */
class TimeSprite extends Sprite
{
	
	public var stop(default, default) :Bool = false;
	
	public var timeInSeconds(default, null) :Int = 0;
	var _timer :Float = 0;
	var _minuteTextField :TextField;
	var _secondsTextField :TextField;
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		var mainSprite = parent.parent;
		mainSprite.addEventListener(UpdateEvent.UPDATE, onUpdate);
		
		setupTextFields();
	}
	
	function setupTextFields() 
	{
		var textFormat = new TextFormat("Verdana", 30, 0xFFFFFF);
		
		_minuteTextField = new TextField();
		_minuteTextField.defaultTextFormat = textFormat;
		_minuteTextField.text = "";
		_minuteTextField.autoSize = TextFieldAutoSize.RIGHT;
		_minuteTextField.x = stage.stageWidth * 0.05;
		
		_secondsTextField = new TextField();
		_secondsTextField.defaultTextFormat = textFormat;
		_secondsTextField.text = "";
		_secondsTextField.autoSize = TextFieldAutoSize.LEFT;
		_secondsTextField.x = stage.stageWidth * 0.05;
		
		addChild(_secondsTextField);
		addChild(_minuteTextField);
		updateDisplayedTime();
	}
	
	
	private function onUpdate(e:UpdateEvent):Void 
	{
		if (stop)
			return;
		
		_timer += e.delta;
		if (_timer >= 1) {
			_timer -= 1;
			timeInSeconds++;
			//if (timeInSeconds <= 0)
				//stop = true;
			updateDisplayedTime();
		}
	}
	
	function updateDisplayedTime() 
	{
		var minutes = Std.int(timeInSeconds / 60);
		var seconds = Std.int(timeInSeconds % 60);
		var minStr = "";
		var secStr = "";
		_minuteTextField.text = "" + minutes;
		if (seconds < 10)
			_secondsTextField.text = ":0" + seconds;
		else
			_secondsTextField.text = ":" + seconds;
	}
	
	
	private function onRemoved(e:Event):Void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		var mainSprite = parent.parent;
		mainSprite.removeEventListener(UpdateEvent.UPDATE, onUpdate);
	}
	
	
	public function getTimeString() {
		return _minuteTextField.text;
	}
	
}