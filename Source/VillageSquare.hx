package;

import openfl.display.Sprite;

class VillageSquare
{
	public var sqSprite:Sprite;
	public var startX:Float;
	public var startY:Float;
	public var endX:Float;
	public var endY:Float;
	public var ax:Float;
	public var bx:Float;
	public var cx:Float;
	public var ay:Float;
	public var by:Float;
	public var cy:Float;
	
	public var explosiveness:Float = 2;//how explosive the square creation is
	
	public var finalTime:Int;
	public function new(squareX:Float, squareY:Float, endX:Float, endY:Float, squareWidth:Float, squareHeight:Float, finalTime:Int, colour:Int, velRange:Float)
	{
		sqSprite = new Sprite();
		sqSprite.graphics.beginFill(colour, .5);
		sqSprite.graphics.drawRect(0, 0, squareWidth, squareHeight);
		startX = squareX;
		startY = squareY;
		this.endX = endX;
		this.endY = endY;
		this.finalTime = finalTime;
		cx = startX;
		cy = startY;
		bx = explosiveness*(-velRange+2*velRange*Math.random());//square explosion is fine
		by = explosiveness*(-velRange+2*velRange*Math.random());
		ax = 2*(endX-startX-bx*finalTime)/(Math.pow(finalTime,2));
		ay = 2*(endY-startY-by*finalTime)/(Math.pow(finalTime,2));
	}
	public function move(time:Int)
	{
		if(time < finalTime)
		{
			sqSprite.x = .5*ax*Math.pow(time,2)+bx*time+cx;
			sqSprite.y = .5*ay*Math.pow(time,2)+by*time+cy;
		}
		else
		VillageAnimation.isMoving = false;
	}
}
