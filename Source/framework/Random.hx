package framework;

/**
 * ...
 * @author Nickan
 */
class Random
{
	
	function new() { }
	
	/**
	 * 
	 * @param	min
	 * @param	max
	 * @return 	Number that is between min and max
	 */
	public static function int(min :Int, max :Int) :Int
	{
		var rand = Math.random();
		var diff = max - min;
		return Std.int(Random.float(min, max));
	}
	
	/**
	 * 
	 * @param	min
	 * @param	max
	 * @return 	Number that is between min and max
	 */
	public static function float(min :Float, max :Float) :Float
	{
		var rand = Math.random();
		var diff = max - min;
		return (min) + (rand * diff);
	}
	
	
}