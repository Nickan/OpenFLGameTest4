package framework;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class BackgroundSprite extends Sprite
{
	var _color :Int;
	var _width :Float;
	var _height :Float;
	
	public function new(color :Int = 0xFFFFFF, width :Float, height :Float) 
	{
		super();
		_color = color;
		_width = width;
		_height = height;
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		graphics.beginFill(_color);
		graphics.drawRect(0, 0, _width, _height);
		graphics.endFill();
	}
	
}