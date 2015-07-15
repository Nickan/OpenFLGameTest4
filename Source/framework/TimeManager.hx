package framework;
import openfl.Lib;

/**
 * ...
 * @author Nickan
 */
class TimeManager
{
	static var _instance :TimeManager;
	
	public var delta(default, null) :Float = 0;
	public var pause(default, set) :Bool = false;

	var _lastTime :Float = 0;
	var _savedDelta :Float = 0;
	
	function new() { }
	
	/**
	 * Should be called every frame
	 */
	public function update() 
	{
		if (pause) {
			delta = 0;
			return;
		}
			
		delta = (Lib.getTimer() - _lastTime) * 0.001;
		_lastTime = Lib.getTimer();
	}
	
	function set_pause(value :Bool) 
	{
		if (pause) {
			if (!value) {
				_lastTime = Lib.getTimer() - _savedDelta;
			}
		} else {
			if (value) {
				_savedDelta = delta;
			}
		}
		pause = value;
		return pause;
	}
	
	public static function getInstance()
	{
		if (_instance == null)
			_instance = new TimeManager();
		return _instance;
	}
	
}