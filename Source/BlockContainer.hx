package;
import events.BlockMoveEvent;
import framework.Random;
import haxe.Timer;
import motion.Actuate;
import motion.easing.Linear;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class BlockContainer extends Sprite
{
	public static inline var VERTICAL_MAX_COUNT :Int = 9;
	public static inline var HORIZONTAL_MAX_COUNT :Int = 9;
	public static inline var TOTAL_GEM_TYPES :Int = 6;
	
	public var gemBlocks(default, default) :Array<Array<Block>>;
	public var gameOver(default, set) :Bool = false;
	
	function set_gameOver(value :Bool) 
	{
		gameOver = value;
		if (gameOver) {
			for (block in gemBlocks)
				Actuate.stop(block);
		}
		return gameOver;
	}
	
	
	var _readyForChecking :Bool = true;
	var _functionOnRemovedBlocks :Int->Void;
	var _blockFiller :BlockFiller;
	
	public function new() 
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        addEventListener(Event.ENTER_FRAME, onUpdate);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }
	
    private function onAdded(e:Event):Void 
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupBlockFiller();
		//fillWithBlocks();
    }
	
	function setupBlockFiller() 
	{
		_blockFiller = new BlockFiller(this);
		_blockFiller.fillContainer();
		//_blockFiller.fillContainerWithNoMovesLeftForTesting();
	}
	
    private function onUpdate(e:Event):Void 
    {
		
    }
	
	public function onBlockMoved(e:BlockMoveEvent):Void 
	{
		if (!_readyForChecking)
			return;
			
		_readyForChecking = false;

		var neighborMatches = [];
		switch (e.direction) {
			case UP: swapTo(e.block, 0, -1, function() {
						neighborMatches = getMatchesToRemove();
						if (neighborMatches.length == 0) {
							setReadyForChecking();
							//checkIfThereIsMove();
							swapTo(e.block, 0, 1, checkIfThereIsMove);
							
						}
						else {
							var repositionTimeToBeFinished = removeBlocks(neighborMatches);
							Timer.delay(recursiveCheckForMatches, Std.int(repositionTimeToBeFinished * 1000));
						}
						
					} );
					
			case DOWN: swapTo(e.block, 0, 1, function() {
						neighborMatches = getMatchesToRemove();
						if (neighborMatches.length == 0) {
							setReadyForChecking();
							//checkIfThereIsMove();
							swapTo(e.block, 0, -1, checkIfThereIsMove);
						}
						else {
							var repositionTimeToBeFinished = removeBlocks(neighborMatches);
							Timer.delay(recursiveCheckForMatches, Std.int(repositionTimeToBeFinished * 1000));
						}
						
					} );
						
			case LEFT: swapTo(e.block, -1, 0, function() {
						neighborMatches = getMatchesToRemove();
						if (neighborMatches.length == 0) {
							setReadyForChecking();
							//checkIfThereIsMove();
							swapTo(e.block, 1, 0, checkIfThereIsMove);
							
						}
						else {
							var repositionTimeToBeFinished = removeBlocks(neighborMatches);
							Timer.delay(recursiveCheckForMatches, Std.int(repositionTimeToBeFinished * 1000));
						}
					} );
						
			case RIGHT: swapTo(e.block, 1, 0, function() {
						neighborMatches = getMatchesToRemove();
						if (neighborMatches.length == 0) {
							setReadyForChecking();
							//checkIfThereIsMove();
							swapTo(e.block, -1, 0, checkIfThereIsMove);
							
						}
						else {
							var repositionTimeToBeFinished = removeBlocks(neighborMatches);
							Timer.delay(recursiveCheckForMatches, Std.int(repositionTimeToBeFinished * 1000));
						}
					} );
		}
	}
	
	public function setFunctionWhenRemovedBlocks(onRemovedBlocks :Int->Void) 
	{
		_functionOnRemovedBlocks = onRemovedBlocks;
	}
	
	function recursiveCheckForMatches() 
	{
		if (gameOver)
			return;
		
		var matchesToRemove = getMatchesToRemove();
		if (matchesToRemove.length != 0) {
			var repositionTimeToBeFinished = removeBlocks(matchesToRemove);
			Timer.delay(recursiveCheckForMatches, Std.int(repositionTimeToBeFinished * 1000));
		} else {
			setReadyForChecking();
		}
	}
	
	function getMatchesToRemove() 
	{
		var matchesToRemove = [];
		for (blocks in gemBlocks) {
			for (block in blocks) {
				var neighborMatches = getNeighborMatches(block, getPoint(block));
				addToNeighborMatchesToRemove(matchesToRemove, neighborMatches);
			}
		}
		
		return matchesToRemove;
	}
	
	function addToNeighborMatchesToRemove(blocksToAddWith :Array<Block>, blocksToAdd :Array<Block>) {
		for (index in 0...blocksToAdd.length) {
			var blockToAdd = blocksToAdd.pop();
			if (!isInArray(blocksToAddWith, blockToAdd))
				blocksToAddWith.push(blockToAdd);
		}
	}
	
	function isInArray(blocks:Array<Block>, block:Block) 
	{
		for (tmpBlock in blocks) {
			if (tmpBlock == block)
				return true;
		}
		return false;
	}
	
	function removeBlocks(neighborMatches :Array<Block>) {
		if (gameOver)
			return 0.0;
		
		_functionOnRemovedBlocks(neighborMatches.length);
		
		var removedMatchesPoints = [];
		for (block in neighborMatches) {
			//...
			//trace(block.id);
			var removedBlockPoint = getPoint(block);
			
			//trace("removedBlockPoint: " + removedBlockPoint.x + " " + removedBlockPoint.y);
			if (contains(block)) {
				removedMatchesPoints.push(removedBlockPoint);
				removeChild(block);
				block.removeEventListener(BlockMoveEvent.BLOCK_MOVE, onBlockMoved);
				for (blocks in gemBlocks)
					blocks.remove(block);
			}
			
		}
		
		fillVacantBlockSlots(removedMatchesPoints);
		return repositionBlocksBasedOnTheirBlockArrayAddress();
	}
	
	public function swapTo(fromSwapBlock:Block, relativeX :Int, relativeY :Int, ?functionFinishedSwapping :Void->Void, 
							animateSwapping :Bool = true) :Bool
	{
		//if (gameOver)
			//return;
		
		var SWAP_DURATION : Float = 0.25;
		
		var toSwapBlock :Block = null;
		var blockPoint = getPoint(fromSwapBlock);
		
		if (relativeX != 0) {
			if (blockPoint.x + relativeX < 0 || blockPoint.x + relativeX >= gemBlocks.length)
				return false;
			
			var toTargetX = (blockPoint.x + relativeX) * fromSwapBlock.width;
			if (animateSwapping) {
				Actuate.tween(fromSwapBlock, SWAP_DURATION, { x: toTargetX } );
			} else {
				fromSwapBlock.x = toTargetX;
			}
			
			// The block to switch to
			toSwapBlock = gemBlocks[blockPoint.x + relativeX][blockPoint.y];
			var fromTargetX = (blockPoint.x) * fromSwapBlock.width;
			if (animateSwapping) {
				Actuate.tween(toSwapBlock, SWAP_DURATION, { x:fromTargetX } ).onComplete(functionFinishedSwapping);
			} else {
				toSwapBlock.x = fromTargetX;
			}
			
			gemBlocks[blockPoint.x][blockPoint.y] = toSwapBlock;
			toSwapBlock = gemBlocks[blockPoint.x + relativeX][blockPoint.y] = fromSwapBlock;
			fromSwapBlock = gemBlocks[blockPoint.x][blockPoint.y];
			return true;
		}
		
		if (relativeY != 0) {
			if (blockPoint.y + relativeY < 0 || blockPoint.y + relativeY >= gemBlocks[0].length)
				return false;
			
			var toTargetY = (blockPoint.y + relativeY) * fromSwapBlock.height;
			if (animateSwapping) {
				Actuate.tween(fromSwapBlock, SWAP_DURATION, { y: toTargetY } );
			} else {
				fromSwapBlock.y = toTargetY;
			}
			
			// The block to switch to
			toSwapBlock = gemBlocks[blockPoint.x][blockPoint.y + relativeY];
			var fromTargetY = (blockPoint.y) * fromSwapBlock.height;
			if (animateSwapping) {
				Actuate.tween(toSwapBlock, SWAP_DURATION, { y:fromTargetY } ).onComplete(functionFinishedSwapping);
			} else {
				toSwapBlock.y = fromTargetY;
			}
			
			gemBlocks[blockPoint.x][blockPoint.y] = toSwapBlock;
			toSwapBlock = gemBlocks[blockPoint.x][blockPoint.y + relativeY] = fromSwapBlock;
			fromSwapBlock = gemBlocks[blockPoint.x][blockPoint.y];
			return true;
		}
		return false;
	}
	
	function setReadyForChecking() 
	{
		_readyForChecking = true;
	}
	
	function checkIfThereIsMove() 
	{
		if (_blockFiller.isThereMoveLeft()) {
			trace("There is move left");
		} else {
			trace("No more move left");
			removeAllBlocksEvent();
			removeBlocksFromParent();
			_blockFiller.fillContainer(stage.stageHeight * -0.9);
			_readyForChecking = false;
			var FALL_SPEED = 0.75;
			repositionBlocksBasedOnTheirBlockArrayAddress(0.75);
			Timer.delay(setReadyForChecking, Std.int(FALL_SPEED * 1000));
		}
	}
	
	function repositionBlocksBasedOnTheirBlockArrayAddress(fallSpeed: Float = 0.15) 
	{
		var DEFAULT_FALL_SPEED :Float = stage.stageHeight * fallSpeed;
		var highestDurationBlockFall :Float = 0;
		for (y in 0...gemBlocks.length) {
			var blockArray = gemBlocks[y];
			for (x in 0...blockArray.length) {
				var block = blockArray[x];
				//block.x = x * block.width;
				//block.y = (x) * block.height + ((VERTICAL_MAX_COUNT - 1) - (blockArray.length - 1) ) * block.height;
				var targetPos = (x) * block.height + ((VERTICAL_MAX_COUNT - 1) - (blockArray.length - 1) ) * block.height;
				if (block.y != targetPos) {
					var dist = Math.abs(block.y - targetPos);
					var duration = Math.abs(dist / DEFAULT_FALL_SPEED);
					if (duration > highestDurationBlockFall)
						highestDurationBlockFall = duration;
					Actuate.tween(block, duration, { y: targetPos } );
				}
			}
		}
		return highestDurationBlockFall;
	}
	
	function fillVacantBlockSlots(removedBlockPoints :Array<Point>) 
	{
		for (y in 0...gemBlocks.length) {
			var blockArray = gemBlocks[y];
			
			
			var added :Int = 0;
			while (blockArray.length < VERTICAL_MAX_COUNT) {
				var rand = Random.int(1, TOTAL_GEM_TYPES);
				var block = new Block(rand);
				addChild(block);
				block.x = y * block.width;
				
				block.y = -(added + 1) * block.height;
				
				block.addEventListener(BlockMoveEvent.BLOCK_MOVE, onBlockMoved);
				blockArray.insert(0, block);
				
				//....
				added++;
				//trace("added: " + added);
			}
		}
	}
	
	// ================================================ HELPER ================================================== // 
	public function getNeighborMatches(block :Block, blockPoint :Point) :Array<Block>
	{
		//var blockPoint = getPoint(block);
		var allIdenticalBlocks = [];
		var horizontalIdenticalBlocks = getIdenticalHorizontalBlocks(blockPoint, block.id);
		if (horizontalIdenticalBlocks.length >= 2)
			allIdenticalBlocks = allIdenticalBlocks.concat(horizontalIdenticalBlocks);
		
		var verticalIdenticalBlocks = getIdenticalVerticalBlocks(blockPoint, block.id);
		if (verticalIdenticalBlocks.length >= 2)
			allIdenticalBlocks = allIdenticalBlocks.concat(verticalIdenticalBlocks);
		
		if (horizontalIdenticalBlocks.length >= 2 || verticalIdenticalBlocks.length >= 2) {
			//allIdenticalBlocks.push(block);
			//addNewBlocksToArray(allIdenticalBlocks, [block]);
			allIdenticalBlocks.remove(block);
			allIdenticalBlocks.remove(block);
			allIdenticalBlocks.remove(block);
			allIdenticalBlocks.push(block);
		}
		
		return allIdenticalBlocks;
	}
	
	function getIdenticalHorizontalBlocks(point :Point, id:Int) 
	{
		var horizontalBlocks = [];
		var sameLeftBlocks = getSameLeftBlocks(point, id);
		var sameRightBlocks = getSameRightBlocks(point, id);
		horizontalBlocks = horizontalBlocks.concat(sameLeftBlocks);
		horizontalBlocks = horizontalBlocks.concat(sameRightBlocks);
		return horizontalBlocks;
	}
	
	function getIdenticalVerticalBlocks(point :Point, id:Int) 
	{
		var verticalBlocks = [];
		var sameTopBlocks = getSameTopBlocks(point, id);
		var sameBottomBlocks = getSameBottomBlocks(point, id);
		verticalBlocks = verticalBlocks.concat(sameTopBlocks);
		verticalBlocks = verticalBlocks.concat(sameBottomBlocks);
		return verticalBlocks;
	}
	

	function getSameLeftBlocks(point :Point, id :Int) 
	{
		var leftBlocks = [];
		for (index in 0...5) {
			var x = ((-index) + -1);
			var y = 0;
			if (point.x + x >= 0) {
				var leftBlock = getRelativeBlock(point, id, x, y);
				if (leftBlock != null)
					leftBlocks.push(leftBlock);
				else
					break;
			}
		}
		return leftBlocks;
	}
	
	function getSameRightBlocks(point :Point, id :Int) 
	{
		var rightBlocks = [];
		for (index in 0...5) {
			var x = index + 1;
			var y = 0;
			if (point.x + x <= (gemBlocks.length - 1) ) {
				var rightBlock = getRelativeBlock(point, id, x, y);
				if (rightBlock != null)
					rightBlocks.push(rightBlock);
				else
					break;
			}
		}
		return rightBlocks;
	}
	
	function getSameTopBlocks(point :Point, id :Int) 
	{
		var topBlocks = [];
		for (index in 0...5) {
			var x = 0;
			var y = (( -index) + -1);
			if (point.y + y >= 0) {
				var topBlock = getRelativeBlock(point, id, x, y);
				if (topBlock != null)
					topBlocks.push(topBlock);
				else
					break;
			}
		}
		return topBlocks;
	}
	
	function getSameBottomBlocks(point :Point, id :Int) 
	{
		var bottomBlocks = [];
		for (index in 0...5) {
			var x = 0;
			var y = index + 1;
			if (point.y + y <= (gemBlocks[point.x].length - 1)) {
				var bottomBlock = getRelativeBlock(point, id, x, y);
				if (bottomBlock != null)
					bottomBlocks.push(bottomBlock);
				else
					break;
			}
		}
		return bottomBlocks;
	}
	
	function getRelativeBlock(blockPoint:Point, blockNumber :Int, relativeX :Int, relativeY :Int) 
	{
		var x = blockPoint.x + relativeX;
		var y = blockPoint.y + relativeY;
		var neighborBlock = gemBlocks[x][y];
		if (neighborBlock == null)
			return null;
			
		if (blockNumber == neighborBlock.id)
			return neighborBlock;
			
		return null;
	}
	
	function getPoint(block :Block)
	{
		return new Point(Std.int(block.x / block.width), Std.int(block.y / block.height));
	}
	
	function getBlock(point :Point)
	{
		return gemBlocks[point.x][point.y];
	}
	
	private function onRemoved(e:Event):Void 
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		_functionOnRemovedBlocks = null;
		removeAllBlocksEvent();
    }
	
	function removeAllBlocksEvent() 
	{
		for (blocks in gemBlocks) {
			for (block in blocks) {
				block.removeEventListener(BlockMoveEvent.BLOCK_MOVE, onBlockMoved);
			}
		}
	}
	
	function removeBlocksFromParent()
	{
		for (blocks in gemBlocks) {
			for (block in blocks) {
				removeChild(block);
			}
		}
		gemBlocks = [];
	}
	
}