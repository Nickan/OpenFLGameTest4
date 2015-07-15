package screen_sprite;
import framework.BackgroundSprite;
import framework.Screen;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class GameOverScreen extends Screen
{
	var _gameOverBox :Bitmap;
	var _score :Int;
	
	public function new(score :Int) 
	{
		super();
		_score = score;
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupBackground();
	}
	
	function setupBackground() 
	{
		var bg = new BackgroundSprite(0x000000, stage.stageWidth, stage.stageHeight);
		addChild(bg);
		bg.alpha = 0;
		Actuate.tween(bg, 0.4, { alpha : 0.3 } ).onComplete(showGameOverBox);
	}
	
	function showGameOverBox() 
	{
		var gameOverBox = new GameOverBox(_score);
		addChild(gameOverBox);
		gameOverBox.x = stage.stageWidth * 0.5 - (gameOverBox.width * 0.5);
		gameOverBox.y = gameOverBox.height * -1;
		
		var targetPosY = stage.stageHeight * 0.5 - gameOverBox.height * 0.5;
		Actuate.tween(gameOverBox, 0.4, { y :targetPosY } );
	}
	
}