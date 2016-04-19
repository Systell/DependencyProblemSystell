package;

import openfl.events.*;
import openfl.display.*;
import openfl.geom.*;
import openfl.Lib;

class FindPreferenceAnimation
{
	public var pg:PreferenceGraph;
	
	public var animationSprite:Sprite;
	public var sourceBarLine:Sprite;
	public var pointerLine:Sprite;
	public var movingRect:Sprite;
	public var crunchingRect:Sprite;
	public var stationaryRects:Array<Sprite> = [];
	public var stationaryRect:Sprite;
	
	public var stepSetNum:Int = 0;
	public var stepNum:Int = 0;
	
	public var sourceGraphNum:Int = 1;
	public var sourceBarNum:Int = 0;
	public var destinationBarNum:Int = 0;
	public var bigBarNum:Int = 0;
	
	public var startTime:Int = 0;
	public var lineTotTime:Array<Int> = [1000,500,500,500,500,500,  500,500,500,500,500,500];
	public var rectTotTime:Array<Int> = [1000,2000,1000,1000,1000,1000,  1000,1000,1000,1000,1000,1000];
	//public var lineTotTime:Array<Int> = [100,50,50,50,50,50,  500,500,500,500,500,500];
	//public var rectTotTime:Array<Int> = [100,200,100,200,100,100,  1000,1000,1000,1000,1000,1000];
	public var crunchTotTime:Array<Int> = [2000,1000,1000,1000];
	
	public var destinationRects:Array<Rectangle> = [];
	public var crunchRects:Array<Rectangle> = [];
	public function new()
	{
		
	}
	public function setup(pg:PreferenceGraph)
	{
		this.pg = pg;
		animationSprite = new Sprite();
		stationaryRect = new Sprite();
		
		stationaryRects = [];
		destinationRects = [];
		crunchRects = [];
		
		stepSetNum = 0;
		stepNum = 0;
		
		sourceGraphNum = 1;
		sourceBarNum = 0;
		destinationBarNum = 0;
		bigBarNum = 0;
		
		startTime = 0;
		
		animationSprite.addChild(stationaryRect);
	}
	public function animateBar(?e:Event)
	{
		switch(stepSetNum)
		{
			case 0:
			switch(stepNum)
			{
				case 0:
				sourceGraphNum = 1;
				sourceBarNum = destinationBarNum%pg.factionColours.length;
				imposeFactionSizeSetup();
				stepNum++;
				startTime = Lib.getTimer();
				case 1:
				if(Lib.getTimer()<startTime+lineTotTime[destinationBarNum])
				{
					moveLine();
				}
				else
				{
					startTime = Lib.getTimer();
					stepNum++;
				}
				case 2:
				if(Lib.getTimer()<startTime+rectTotTime[destinationBarNum])
				{
					moveRect();
				}
				else
				stepNum++;
				case 3:
				stepSetNum++;
				animationSprite.removeChild(sourceBarLine);
				animationSprite.removeChild(pointerLine);
				moveRect();
				stationaryRect.addChild(movingRect);
				stationaryRects.push(movingRect);
				animationSprite.removeChild(movingRect);
				stepNum = 0;
				startTime = Lib.getTimer();
			}
			case 1:
			switch(stepNum)
			{
				case 0:
				sourceGraphNum = 0;
				sourceBarNum = destinationBarNum;
				imposeFactionPreferenceSetup();
				stepNum++;
				startTime = Lib.getTimer();
				case 1:
				if(Lib.getTimer()<startTime+lineTotTime[destinationBarNum])
				{
					moveLine();
				}
				else
				{
					startTime = Lib.getTimer();
					stepNum++;
				}
				case 2:
				if(Lib.getTimer()<startTime+rectTotTime[destinationBarNum])
				{
					moveRect();
				}
				else
				stepNum++;
				case 3:
				animationSprite.removeChild(sourceBarLine);
				animationSprite.removeChild(pointerLine);
				moveRect();
				stationaryRect.addChild(movingRect);
				animationSprite.removeChild(movingRect);
				stepNum = 0;
				startTime = Lib.getTimer();
				destinationBarNum++;
				if(destinationBarNum%pg.factionColours.length == 0)
				{
					stepSetNum++;
					stepNum = 0;
					animationSprite.removeChild(stationaryRect);
				}
				else
				{
					stepSetNum = 0;
					stepNum = 0;
				}
			}
			case 2:
			switch(stepNum)
			{
				case 0:
				crunchSetup();
				stepNum++;
				startTime = Lib.getTimer();
				case 1:
				if(Lib.getTimer()<startTime+crunchTotTime[bigBarNum])
				{
					animationSprite.removeChild(crunchingRect);
					crunchingRect = new Sprite();
					var currentTime = Lib.getTimer();
					for(i in 0...pg.factionColours.length)
					{
						crunchRect(i, currentTime);
					}
					animationSprite.addChild(crunchingRect);
				}
				else
				{
					startTime = Lib.getTimer();
					stepNum++;
				}
				case 2:
				animationSprite.removeChild(crunchingRect);
				pg.addTotPrefBar(bigBarNum);
				bigBarNum++;
				stepSetNum = 0;
				stepNum = 0;
				animationSprite.addChild(stationaryRect);
				stationaryRect.removeChildren();
				if(bigBarNum >= pg.factionPrefRatios.length)
				{
					stepSetNum = -1;
				}
			}
		}
	}
	/*list animation chunks that correspond to needing new data, then for each chunk list all the sub steps. Double loops through chunks/steps for each bar.
	Chunk one (imposeFactionsize):
	step one:
	fade out first two graphs except for faction size bar in question.
	step two:
	draw verticle line size of faction size bar in question
	step three:
	per frame: draw line that extends every frame to the middle of where the target of the bar is. The target of the bar can be found using totPrefBar with factionSize instead of factionSize*factionPref
	step four:
	move transparent rect along line.
	step five:
	pause for given time
	step six:
	remove lines
	Chunk two(imposeFactionPreference):
	Same as chunk one except faction preference for step one and two, and step three is now factionSize*factionPref, with height based on Hunk one step three's bars
	also impose see through bar on source bar that is the size of the graph
	Chunk three(collapse):
	step one:
	every frame: the height of the faction size bars in the third graph is now (currentTime-startTime)/totTime, set y of preference bar to faction size bar y + height
	step two:
	when totTime is reached, tell pg to impose preference bar
	*/
	public function imposeFactionSizeSetup()
	{
		imposeBarSetup(1);
		destinationRects = [];
		var dNum = Math.round(Math.floor(destinationBarNum/pg.factionColours.length)*pg.factionColours.length);
		var drx = pg.barRects[2][dNum].x;
		var drw = pg.barRects[2][dNum].width;
		var dry = pg.barRects[2][dNum].y+pg.barRects[2][dNum].height-pg.barRects[1][0].height;
		var drh = pg.barRects[1][0].height;
		destinationRects.push(new Rectangle(drx,dry,drw,drh));
		for(i in 1...pg.factionColours.length)
		{
			drh = pg.barRects[1][i].height;
			dry-= drh;
			destinationRects.push(new Rectangle(drx,dry,drw,drh));
		}
	}
	public function crunchSetup()
	{
		pg.fadeBars(0,-2);
		pg.fadeBars(1,-2);
		crunchRects = [];
		for(i in 0...pg.factionColours.length)
		{
			var drx = pg.barRects[2][i+pg.factionColours.length*bigBarNum].x;
			var dry = pg.barRects[2][i+pg.factionColours.length*bigBarNum].y;
			var drw = pg.barRects[2][i+pg.factionColours.length*bigBarNum].width;
			var drh = pg.barRects[2][i+pg.factionColours.length*bigBarNum].height;
			crunchRects.push(new Rectangle(drx,dry,drw,drh));
		}
	}
	public function imposeFactionPreferenceSetup()
	{
		imposeBarSetup(0);
	}
	public function imposeBarSetup(sourceGraphNum:Int)
	{
		pg.fadeBars(sourceGraphNum,sourceBarNum);
		if(sourceGraphNum != 0)
		pg.fadeBars(0,-2);
		else
		pg.fadeBars(1,-2);
		sourceBarLine = new Sprite();
		sourceBarLine.graphics.lineStyle(1, 0x000000);
		var rect:Rectangle = pg.barRects[sourceGraphNum][sourceBarNum];
		sourceBarLine.graphics.moveTo(rect.x+rect.width*1.05,rect.y);
		sourceBarLine.graphics.lineTo(rect.x+rect.width*1.05,rect.y+rect.height);
		startTime = Lib.getTimer();
		animationSprite.addChild(sourceBarLine);
	}
	public function moveLine()
	{
		animationSprite.removeChild(pointerLine);
		pointerLine = new Sprite();
		pointerLine.graphics.lineStyle(1, 0x000000);
		var rect:Rectangle = pg.barRects[sourceGraphNum][sourceBarNum];
		var bx:Float = rect.x+rect.width*1.05;
		var by:Float = rect.y+.5*rect.height;
		var rect:Rectangle = destinationRects[sourceBarNum%pg.factionColours.length];
		var ex:Float = rect.x/*-rect.width*.05*/;
		var ey:Float = rect.y+.5*rect.height;
		var timeRatio:Float = (Lib.getTimer()-startTime)/lineTotTime[destinationBarNum];
		var currentTime = Lib.getTimer();
		pointerLine.graphics.moveTo(bx,by);
		pointerLine.graphics.lineTo(bx+(ex-bx)*timeRatio,by+(ey-by)*timeRatio);
		animationSprite.addChild(pointerLine);
	}
	public function moveRect()
	{
		animationSprite.removeChild(movingRect);
		movingRect = new Sprite();
		var rect:Rectangle = pg.barRects[sourceGraphNum][sourceBarNum];
		var bx:Float = rect.x;
		var by:Float = rect.y+.5*rect.height;
		var bw:Float = rect.width;
		var bh:Float = rect.height;
		var rect:Rectangle = destinationRects[sourceBarNum%pg.factionColours.length];
		var ex:Float = rect.x;
		var ey:Float = rect.y+.5*rect.height;
		var ew:Float = rect.width;
		var eh:Float = rect.height;
		var timeRatio:Float = (Lib.getTimer()-startTime)/rectTotTime[destinationBarNum];
		if(timeRatio > 1)
		timeRatio = 1;
		var cx = bx+(ex-bx)*timeRatio;
		var cw = bw+(ew-bw)*timeRatio;
		var ch = bh+(eh-bh)*timeRatio;
		var cy = by+(ey-by)*timeRatio-ch*.5;
		if(sourceGraphNum==1)
		{
			movingRect.graphics.lineStyle(1, pg.factionColours[destinationBarNum%pg.factionColours.length]);
			movingRect.graphics.beginFill(0x000000,0);
			movingRect.x = cx;
			movingRect.y = cy;
			movingRect.graphics.drawRect(0, 0, cw, ch);
		}
		else if(sourceGraphNum==0)
		{
			var bh2:Float = pg.graphHeight;
			var by2:Float = pg.graphY+.5*bh2;
			var ch2:Float = bh2+(eh-bh2)*timeRatio;
			var cy2:Float = by2+(ey-by2)*timeRatio-ch2*.5;
			movingRect.graphics.lineStyle(1, pg.factionColours[destinationBarNum%pg.factionColours.length]);
			movingRect.graphics.beginFill(0x000000,0);
			movingRect.x = cx;
			movingRect.y = cy2;
			movingRect.graphics.drawRect(0, 0, cw, ch2);
			movingRect.graphics.beginFill(pg.factionColours[destinationBarNum%pg.factionColours.length]);
			var eh2 = eh*(bh/bh2);
			ch = bh+(eh2-bh)*timeRatio;
			movingRect.graphics.drawRect(0, ch2-ch, cw, ch);
		}
		animationSprite.addChild(movingRect);
	}
	public function crunchRect(rectNum:Int, currentTime:Int)
	{
		var rect:Rectangle = destinationRects[rectNum];
		//var asd = new Sprite();
		//var i = rectNum;
		//asd.graphics.lineStyle(1,0x000000);
		//if(i==0)
		//asd.graphics.beginFill(0xFFFF00);
		//if(i==1)
		//asd.graphics.beginFill(0xFF0000);
		//if(i==2)
		//asd.graphics.beginFill(0x00FF00);
		//asd.graphics.drawRect(destinationRects[i].x ,destinationRects[i].y, destinationRects[i].width, destinationRects[i].height);
		//animationSprite.addChild(asd);
		var bx:Float = rect.x;
		var by:Float = rect.y;
		var bw:Float = rect.width;
		var bh:Float = rect.height;
		var rect:Rectangle = crunchRects[rectNum];
		var ey:Float = rect.y;
		var eh:Float = rect.height;
		var timeRatio:Float = (currentTime-startTime)/crunchTotTime[bigBarNum];
		if(timeRatio > 1)
		timeRatio = 1;
		var cx = bx;
		var cw = bw;
		var ch = bh+(eh-bh)*timeRatio;
		var cy = by+(ey-by)*timeRatio;
		
		crunchingRect.graphics.lineStyle(1, pg.factionColours[rectNum]);
		crunchingRect.graphics.beginFill(0x000000,0);
		//crunchingRect.x = cx;
		//crunchingRect.y = cy;
		crunchingRect.graphics.drawRect(cx, cy, cw, ch);
		crunchingRect.graphics.beginFill(pg.factionColours[rectNum]);
		//var eh2 = eh*(bh/bh2);
		//ch = bh+(eh2-bh)*timeRatio;
		crunchingRect.graphics.drawRect(cx, cy+ch-eh, cw, eh);
		
	}
}
