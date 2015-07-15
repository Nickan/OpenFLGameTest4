package;
import framework.ScreenManager;
import openfl.display.Sprite;
import openfl.events.Event;
import screen_sprite.TitleScreen;


class Main extends Sprite {
	
	public function new () {
		
		super ();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		var screenManager :ScreenManager = ScreenManager.getInstance();
		addChild(screenManager);
		
		screenManager.showOnScreen(new TitleScreen());
	}
	
	
}