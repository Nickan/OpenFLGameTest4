package screen_sprite;
import framework.Screen;
import framework.ScreenManager;
import framework.TextButton;
import framework.TextSprite;
import framework.TimeManager;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.text.TextFieldAutoSize;

/**
 * ...
 * @author Nickan
 */
class GameScreen extends Screen
{
	var _blockContainer :BlockContainer;
	var _pauseButton :TextButton;
	
	var _scoreTextSprite :TextSprite;
	var _timeTextSprite :TextSprite;
	var _score :Int = 0;
	var _time :Int = 60;
	var _timer :Float = 0;
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}
	
	private function onAddedToStage(e :Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		setupBackground();
		setupBlockContainer();
		setupPauseButton();
		setupScoreSprite();
		setupTimeSprite();
	}
	
	function setupBackground() 
	{
		var bg = new Bitmap(Assets.getBitmapData("assets/asset_bg.png"));
		addChild(bg);
	}
	
	function setupBlockContainer() 
	{
		_blockContainer = new BlockContainer();
		_blockContainer.x = stage.stageWidth * 0.17;
		_blockContainer.y = stage.stageHeight * 0.18;
		addChild(_blockContainer);
		
		_blockContainer.setFunctionWhenRemovedBlocks(onRemovedBlocks);
	}
	
	function onRemovedBlocks(blockCount :Int) 
	{
		var GEM_SCORE = 100;
		var score = blockCount * GEM_SCORE;
		if (blockCount == 4)
			score *= 2;
		else if (blockCount >= 5)
			score *= 3;
			
		_score += score;
		_scoreTextSprite.showText("" + _score);
	}
	
	function setupPauseButton() 
	{
		_pauseButton = new TextButton("", new Bitmap(Assets.getBitmapData("assets/asset_pause_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_pause_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_pause_down.png")), null, onPause);
		addChild(_pauseButton);
		_pauseButton.x = stage.stageWidth * 0.825 - (_pauseButton.width * 0.5);
		_pauseButton.y = (stage.stageHeight * 0.02);
	}
	
	function setupScoreSprite() 
	{
		var scoreSprite = new TextSprite(15);
		addChild(scoreSprite);
		scoreSprite.x = stage.stageWidth * 0.155;
		scoreSprite.y = stage.stageHeight * 0.0425;
		scoreSprite.showText("Score: ");
		
		_scoreTextSprite = new TextSprite(15);
		addChild(_scoreTextSprite);
		_scoreTextSprite.x = (scoreSprite.x + scoreSprite.getBounds(this).width * 0.5) + stage.stageWidth * 0.0;
		#if html5
			_scoreTextSprite.x = (scoreSprite.x + scoreSprite.getBounds(this).width * 1) + stage.stageWidth * 0.0;
		#end
		_scoreTextSprite.y = stage.stageHeight * 0.0425;
		_scoreTextSprite.setTextFieldAutoSize(TextFieldAutoSize.RIGHT);
		_scoreTextSprite.showText("" + _score);
	}
	
	function setupTimeSprite() 
	{
		var timeSprite = new TextSprite(15);
		addChild(timeSprite);
		timeSprite.x = stage.stageWidth * 0.5;
		timeSprite.y = stage.stageHeight * 0.0425;
		timeSprite.showText("Time: ");
		
		_timeTextSprite = new TextSprite(15);
		addChild(_timeTextSprite);
		_timeTextSprite.x = stage.stageWidth * 0.5;
		#if html5
			_timeTextSprite.x = (timeSprite.x + timeSprite.getBounds(this).width * 1.45) + stage.stageWidth * 0.0;
		#end
		_timeTextSprite.y = stage.stageHeight * 0.0425;
		_timeTextSprite.setTextFieldAutoSize(TextFieldAutoSize.RIGHT);
		_timeTextSprite.showText("" + _time);
	}
	
	
	
	function onPause() 
	{
		ScreenManager.getInstance().showOnTop(new PauseScreen());
		
	}
	
	
	override public function onUpdate(e :Event) {
		if (_time <= 0)
			return;
		
		_timer += TimeManager.getInstance().delta;
		if (_timer >= 1) {
			_timer -= 1;
			_timeTextSprite.showText("" + --_time);
			
			if (_time <= 0)
				onGameOver();
		}
	}
	
	function onGameOver() 
	{
		ScreenManager.getInstance().showOnTop(new GameOverScreen(_score));
		_blockContainer.gameOver = true;
	}
	
	
	
	private function onRemoved(e :Event):Void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		
	}
	
}