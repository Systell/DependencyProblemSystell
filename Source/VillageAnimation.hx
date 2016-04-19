package;

import openfl.geom.*;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.*;

class VillageAnimation
{
	public static var squares:Array<Array<VillageSquare>>;
	//public static var neitherSquares:Array<VillageSquare> = [];
	//public static var garySquares:Array<VillageSquare> = [];
	public static var squaresTime:Int = 1000;
	//public static var neitherSquaresTime:Int = 0;
	//public static var garySquaresTime:Int = 0;
	public static var squaresSprite:Sprite;
	public static var s:Stage;
	
	public static var isMoving:Bool;
	public static var currentType:Int;
	public function new()
	{
	}
	public static function setup(s:Stage)
	{
		 squaresSprite = new Sprite();
		 squares = [];
		 isMoving = false;
		 currentType = 0;
		 VillageAnimation.s = s;
	}
	public static function beginMove(?e:Event)
	{
		for(i in 0...squares[currentType].length)
		{
			squaresSprite.addChild(squares[currentType][i].sqSprite);
		}
		squaresTime = Lib.getTimer();
		isMoving = true;
		move();
	}
	public static function defaultSquareMake(startRect:Rectangle, endRect:Rectangle, time:Int, colour:Int, type:Int)
	{
		var numWidth = 2;
		var sWidth = startRect.width/numWidth;
		var numHeight = Math.floor(startRect.height/(sWidth));
		var sHeight = startRect.height/numHeight;
		var squareX:Array<Float> = [];
		var squareY:Array<Float> = [];
		var squareWidth:Array<Float> = [];
		var squareHeight:Array<Float> = [];
		for(i in 0...numWidth)
		{
			for(j in 0...numHeight)
			{
				squareWidth.push(sWidth);
				squareHeight.push(sHeight);
				squareX.push(startRect.x+i*sWidth);
				squareY.push(startRect.y+j*sHeight);
			}
		}
		var endX:Array<Float> = [];
		var endY:Array<Float> = [];
		var tempEndX:Array<Float> = [];
		var tempEndY:Array<Float> = [];
		for(i in 0...numWidth)
		{
			for(j in 0...numHeight)
			{
				tempEndX.push(endRect.x+i*sWidth);
				tempEndY.push(endRect.y+j*sHeight);
				//endX.push(endRect.x+i*sWidth);
				//endY.push(endRect.y+j*sHeight);
			}
		}
		while(tempEndX.length>0)
		{
			var pos = Math.floor(tempEndX.length*Math.random());
			endX.push(tempEndX[pos]);
			endY.push(tempEndY[pos]);
			tempEndX[pos] = tempEndX[tempEndX.length-1];
			tempEndY[pos] = tempEndY[tempEndY.length-1];
			tempEndX.pop();
			tempEndY.pop();
		}
		var velRange:Float = Math.sqrt(Math.pow(startRect.x-endRect.x,2)+Math.pow(startRect.y-endRect.y,2))/(time);
		initializeSquares(squareX, squareY, endX, endY, squareWidth, squareHeight, time, colour, velRange, type);
	}
	public static function initializeSquares(squareX:Array<Float>, squareY:Array<Float>, endX:Array<Float>, endY:Array<Float>, squareWidth:Array<Float>, squareHeight:Array<Float>, time:Int, colour:Int, velRange:Float, type:Int)
	{
		while(squares.length-1 < type)
		{
			squares.push([]);
		}
		for(i in 0...squareX.length)
		{
			squares[type].push(new VillageSquare(squareX[i], squareY[i], endX[i], endY[i], squareWidth[i], squareHeight[i], time, colour, velRange));
		}
	}
	public static function removeSquares()
	{
		squaresSprite.removeChildren();
	}
	public static function move()
	{
		for(i in 0...squares[currentType].length)
		{
			squares[currentType][i].move(Lib.getTimer()-squaresTime);
		}
	}
}
