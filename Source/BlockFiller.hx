package;
import events.BlockMoveEvent;
import framework.Random;
import openfl.display.Sprite;

/**
 * ...
 * @author Nickan
 */
class BlockFiller
{
	var _blockContainer :BlockContainer;
	
	public function new(container :BlockContainer) 
	{
		_blockContainer = container;
	}
	
	public function fillContainer(startingY :Float = 0) {
		_blockContainer.gemBlocks = [];
		var gemBlocks = _blockContainer.gemBlocks;
		for (x in 0...BlockContainer.HORIZONTAL_MAX_COUNT) {
			gemBlocks.push([]);
			for (y in 0...BlockContainer.VERTICAL_MAX_COUNT) {
				
				var rand = Random.int(1, BlockContainer.TOTAL_GEM_TYPES);
				var block = new Block(rand);
				gemBlocks[x].push(block);
				while (isThereMatches()) {
					rand = Random.int(1, BlockContainer.TOTAL_GEM_TYPES);
					gemBlocks[x].pop();
					block.dispose();
					block = null;
					block = new Block(rand);
					gemBlocks[x].push(block);
				}
				
				_blockContainer.addChild(block);
				block.x = x * block.width;
				block.y = startingY + (y * block.height);
				
				block.addEventListener(BlockMoveEvent.BLOCK_MOVE, _blockContainer.onBlockMoved);
			}
		}

	}
	
	function isThereMatches()
	{
		var gemBlocks = _blockContainer.gemBlocks;
		for (x in 0...gemBlocks.length) {
			for (y in 0...gemBlocks[x].length) {
				var matches = _blockContainer.getNeighborMatches(gemBlocks[x][y], new Point(x, y));
				if (matches.length > 2) {
					return true;
				}
			}
		}
		return false;
	}
	
	public function isThereMoveLeft()
	{
		var gemBlocks = _blockContainer.gemBlocks;
		for (x in 0...gemBlocks.length) {
			for (y in 0...gemBlocks[x].length) {
				// Check swapping to lower block
				if (_blockContainer.swapTo(gemBlocks[x][y], 0, 1, null, false)) {
					if (isThereMatches()) {
						_blockContainer.swapTo(gemBlocks[x][y + 1], 0, -1, null, false);
						return true;
					}
					_blockContainer.swapTo(gemBlocks[x][y + 1], 0, -1, null, false);
				}
				
				
				// Check swapping to upper block
				if (_blockContainer.swapTo(gemBlocks[x][y], 0, -1, null, false)) {
					if (isThereMatches()) {
						_blockContainer.swapTo(gemBlocks[x][y - 1], 0, 1, null, false);
						return true;
					}
					_blockContainer.swapTo(gemBlocks[x][y - 1], 0, 1, null, false);
				}
				
				// Check swapping to right block
				if (_blockContainer.swapTo(gemBlocks[x][y], 1, 0, null, false)) {
					if (isThereMatches()) {
						_blockContainer.swapTo(gemBlocks[x + 1][y], -1, 0, null, false);
						return true;
					}
					_blockContainer.swapTo(gemBlocks[x + 1][y], -1, 0, null, false);
				}
				
				// Check swapping to left block
				if (_blockContainer.swapTo(gemBlocks[x][y], -1, 0, null, false)) {
					if (isThereMatches()) {
						_blockContainer.swapTo(gemBlocks[x - 1][y], 1, 0, null, false);
						return true;
					}
					_blockContainer.swapTo(gemBlocks[x - 1][y], 1, 0, null, false);
				}
				
			}
		}
		return false;
	}
	
	public function fillContainerWithNoMovesLeftForTesting() 
	{
		_blockContainer.gemBlocks = [];
		var gemBlocks = _blockContainer.gemBlocks;
		
		var gemCount :Int = 0;
		for (x in 0...BlockContainer.HORIZONTAL_MAX_COUNT) {
			gemBlocks.push([]);
			for (y in 0...BlockContainer.VERTICAL_MAX_COUNT) {
				
				var rand = (gemCount % BlockContainer.TOTAL_GEM_TYPES) + 1;
				gemCount++;
				var block = new Block(rand);
				gemBlocks[x].push(block);
				
				_blockContainer.addChild(block);
				block.x = x * block.width;
				block.y = y * block.height;
				
				block.addEventListener(BlockMoveEvent.BLOCK_MOVE, _blockContainer.onBlockMoved);
			}
		}
	}
	
}