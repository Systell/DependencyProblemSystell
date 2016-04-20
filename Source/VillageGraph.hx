package;

import openfl.display.*;
import openfl.geom.*;
import openfl.text.*;
import openfl.events.*;

class VillageGraph
{
	public var graphSprite:Sprite;
	public var totalWidth:Int;
	public var graphHeight:Int;
	public var gapPercent = .1;
	public var graphAxis:Sprite;
	public var s:Stage;
	public var firstGraphX:Float;
	public var firstGraphWidth:Float;
	public var secondGraphX:Float;
	public var secondGraphXWRTFirst:Float;
	public var secondGraphWidth:Float;
	public var graphY:Float;
	
	public var combinedBars:Sprite;
	public var combinedBarWidth:Float;
	public var combinedRatios:Array<Float> = [.48, .46, .06];
	
	public var voteBars:Array<Sprite> = [];
	public var voteBarMainSprite:Sprite;
	public var voteBarWidth:Float;
	public var voteBarSet:Int = 0;
	
	
	public var factionSprite:Sprite;
	public var voteSprite:Sprite;
	public var yAxisSprite:Sprite;
	public var resetSprite:Sprite;
	
	public var voteButton:SimpleButton;
	public var resetButton:SimpleButton;
	
	public var totGraphHeight:Float;
	
	public var origSmallText:Int = 14;
	public var origLargeText:Int = 16;
	public var smallText:Int = 14;
	public var largeText:Int = 16;
	public function new(s:Stage)
	{
		this.s = s;
		setup();
	}
	public function setup(?e:Event)
	{
		if(Main.textSizeRatio > 0)
		{
			smallText=Math.round(origSmallText*Main.textSizeRatio);
			largeText=Math.round(origLargeText*Main.textSizeRatio);
		}
		totalWidth = Math.round(Math.min(Main.calibrationFactor*800, (s.stageWidth-Main.calibrationFactor*40)*.9));
		graphHeight = Math.round(totalWidth*.5);
		graphSprite = new Sprite();
		var testTextFormat = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var testField = new TextField();
		testField.text = "TEST";
		
		testField.defaultTextFormat = testTextFormat;
		totGraphHeight = graphHeight+3*testField.textHeight;
		graphY = graphY = s.stageHeight-graphHeight-3*testField.textHeight;
		firstGraphX = .5*(s.stageWidth-totalWidth);
		firstGraphWidth = totalWidth*.5*(1-.5*gapPercent);
		secondGraphX = firstGraphX+totalWidth*.5*(1+.5*gapPercent);
		secondGraphXWRTFirst = secondGraphX-firstGraphX;
		secondGraphWidth = firstGraphWidth;
		createGraphAxis();
		graphSprite.addChild(graphAxis);
		createBars();
		graphSprite.addChild(combinedBars);
		graphSprite.addChild(voteBarMainSprite);
		createFactionText();
		graphSprite.addChild(factionSprite);
		createYAxisText();
		graphSprite.addChild(yAxisSprite);
		createVoteText();
		graphSprite.addChild(voteSprite);
		createVoteButton();
		graphSprite.addChild(voteButton);
		createResetButton();
	}
	public function createVoteButton()
	{
		var voteButtonSprites:Array<Sprite> = [];
		var voteButtonTextFormat = new TextFormat(Main.simulationFont.fontName, largeText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var colours:Array<Int> = [0x000000, 0x587DA0, 0x2D4052];
		for(i in 0...3)
		{
			voteButtonSprites.push(new Sprite());
			var voteField = new TextField();
			voteField.defaultTextFormat = voteButtonTextFormat;
			voteField.autoSize = TextFieldAutoSize.NONE;
			voteField.text = "Conduct Vote";
			voteField.width = voteField.textWidth*1.2;
			voteField.height = voteField.textHeight*1.2;
			voteField.textColor = colours[i];
			voteField.border = true;
			voteField.borderColor = colours[i];
			voteButtonSprites[i].addChild(voteField);
		}
		voteButton = new SimpleButton(voteButtonSprites[0], voteButtonSprites[1], voteButtonSprites[2], voteButtonSprites[1]);
		voteButton.x = secondGraphX;//totalWidth*.5-voteButton.width*.5;
		voteButton.y = graphY;
		voteButton.addEventListener(MouseEvent.CLICK, doVote);
	}
	public function createResetButton()
	{
		var resetButtonSprites:Array<Sprite> = [];
		var resetButtonTextFormat = new TextFormat(Main.simulationFont.fontName, largeText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var colours:Array<Int> = [0x000000, 0x587DA0, 0x2D4052];
		for(i in 0...3)
		{
			resetButtonSprites.push(new Sprite());
			var resetField = new TextField();
			resetField.defaultTextFormat = resetButtonTextFormat;
			resetField.autoSize = TextFieldAutoSize.NONE;
			resetField.text = "Reset";
			resetField.width = resetField.textWidth*1.2;
			resetField.height = resetField.textHeight*1.2;
			resetField.textColor = colours[i];
			resetField.border = true;
			resetField.borderColor = colours[i];
			resetButtonSprites[i].addChild(resetField);
		}
		resetButton = new SimpleButton(resetButtonSprites[0], resetButtonSprites[1], resetButtonSprites[2], resetButtonSprites[1]);
		resetButton.x = secondGraphX;//totalWidth*.5-resetButton.width*.5;
		resetButton.y = graphY;
	}
	public function doVote(?e:Event)
	{
		VillageAnimation.beginMove();
		graphSprite.addEventListener(Event.ENTER_FRAME, Village.barAnimation);
		graphSprite.removeChild(voteButton);
		graphSprite.addChild(resetButton);
		resetButton.addEventListener(MouseEvent.CLICK, Village.reset);
	}
	public function createFactionText()
	{
		factionSprite = new Sprite();
		var factionField:Array<TextField> = [];
		var factionTextFormat = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		for(i in 0...3)
		{
			factionField.push(new TextField());
			factionField[i].defaultTextFormat = factionTextFormat;
			factionField[i].autoSize = TextFieldAutoSize.NONE;
			factionField[i].textColor = 0x000000;
		}
		factionField[0].text = "Do\nBoth";
		factionField[1].text = "Do\nNeither";
		factionField[2].text = "Gary";
		for(i in 0...factionField.length)
		{
			factionField[i].width = Math.max(.33*firstGraphWidth,factionField[i].textWidth*1.1);
			factionField[i].x = (i/3)*firstGraphWidth;
			factionSprite.addChild(factionField[i]);
		}
		factionSprite.y=graphY+graphHeight;
		factionSprite.x=firstGraphX;
	}
	public function createYAxisText()
	{
		yAxisSprite = new Sprite();
		var yAxisField:Array<TextField> = [];
		var yAxisTextFormat = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		for(i in 0...2)
		{
			yAxisField.push(new TextField());
			yAxisField[i].defaultTextFormat = yAxisTextFormat;
			yAxisField[i].autoSize = TextFieldAutoSize.NONE;
			yAxisField[i].textColor = 0x000000;
		}
		yAxisField[0].text = "Faction Support";
		yAxisField[0].rotation = 270;
		yAxisField[0].width = yAxisField[0].textWidth*1.1;
		yAxisField[0].x = -yAxisField[0].textHeight*1.2;
		yAxisField[0].y = .5*(graphHeight+yAxisField[0].width);
		yAxisField[1].text = "Vote Total";
		yAxisField[1].width = yAxisField[1].textWidth*1.1;
		yAxisField[1].rotation = 90;
		yAxisField[1].x = secondGraphXWRTFirst+secondGraphWidth+yAxisField[0].textHeight*1.2;
		yAxisField[1].y = .5*(graphHeight-yAxisField[1].width);
		for(i in 0...yAxisField.length)
		{
			yAxisSprite.addChild(yAxisField[i]);
		}
		yAxisSprite.y=graphY;
		yAxisSprite.x=firstGraphX;
	}
	public function createVoteText()
	{
		voteSprite = new Sprite();
		var voteField:Array<TextField> = [];
		var voteTextFormatLeft = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.LEFT);
		var voteTextFormatRight = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.RIGHT);
		var voteTextFormatCenter = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var voteTextFormatBig = new TextFormat(Main.simulationFont.fontName, largeText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		for(i in 0...6)
		{
			voteField.push(new TextField());
			voteField[i].autoSize = TextFieldAutoSize.NONE;
			voteField[i].textColor = 0x000000;
			//voteField[i].width = .33*firstGraphWidth;
			//voteField[i].x = (i/3)*firstGraphWidth;
		}
		voteField[0].text = "Yes";
		voteField[0].defaultTextFormat = voteTextFormatRight;
		voteField[0].x = secondGraphXWRTFirst+secondGraphWidth*.33-voteField[0].width-1;
		voteField[1].text = "No";
		voteField[1].defaultTextFormat = voteTextFormatLeft;
		voteField[1].x = secondGraphXWRTFirst+secondGraphWidth*.33+1;
		voteField[2].text = "Yes";
		voteField[2].defaultTextFormat = voteTextFormatRight;
		voteField[2].x = secondGraphXWRTFirst+secondGraphWidth*.66-voteField[2].width-1;
		voteField[3].text = "No";
		voteField[3].defaultTextFormat = voteTextFormatLeft;
		voteField[3].x = secondGraphXWRTFirst+secondGraphWidth*.66+1;
		voteField[4].text = "Build Bridge";
		voteField[4].defaultTextFormat = voteTextFormatRight;
		voteField[4].x = voteField[1].x+voteField[1].textWidth-voteField[4].width;
		voteField[4].y = voteField[4].textHeight*1.1;
		voteField[5].text = "Send Army";
		voteField[5].defaultTextFormat = voteTextFormatLeft;
		voteField[5].x = secondGraphXWRTFirst+secondGraphWidth*.66-voteField[2].textWidth-1;
		voteField[5].y = voteField[5].textHeight*1.1;
		for(i in 0...voteField.length)
		{
			voteSprite.addChild(voteField[i]);
		}
		voteSprite.y=graphY+graphHeight;
		voteSprite.x=firstGraphX;
	}
	public function createGraphAxis()
	{
		graphAxis = new Sprite();
		graphAxis.graphics.lineStyle(1, 0x000000);
		graphAxis.graphics.moveTo(firstGraphX,graphY);
		graphAxis.graphics.lineTo(firstGraphX,graphY+graphHeight);
		graphAxis.graphics.lineTo(firstGraphX+firstGraphWidth,graphY+graphHeight);
		graphAxis.graphics.moveTo(secondGraphX,graphY+graphHeight);
		graphAxis.graphics.lineTo(secondGraphX+secondGraphWidth,graphY+graphHeight);
		graphAxis.graphics.lineTo(secondGraphX+secondGraphWidth,graphY);
	}
	public function createBars()
	{
		combinedBars = new Sprite();
		combinedBarWidth = .1*firstGraphWidth;
		voteBarWidth = combinedBarWidth;
		voteBarMainSprite = new Sprite();
		var colour:Int;
		var rect:Rectangle;
		var rectEnd:Rectangle;
		
		colour = 0x585799;
		rect = new Rectangle(firstGraphX+.167*firstGraphWidth-combinedBarWidth*.5, graphY+graphHeight*(1-combinedRatios[0]), combinedBarWidth, graphHeight*(combinedRatios[0]));
		combinedBars.graphics.beginFill(colour);
		combinedBars.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);  
		voteBars.push(new Sprite());
		rectEnd = new Rectangle(secondGraphX+.33*secondGraphWidth-rect.width, graphY+graphHeight*(1-combinedRatios[0]), combinedBarWidth, graphHeight*(combinedRatios[0]));
		voteBars[voteBars.length-1].graphics.beginFill(colour);
		voteBars[voteBars.length-1].graphics.drawRect(rectEnd.x,rectEnd.y,rect.width,rect.height); 
		VillageAnimation.defaultSquareMake(rect, new Rectangle(rectEnd.x, rectEnd.y, rectEnd.width, rectEnd.height), 2000, colour, 0);
		voteBars.push(new Sprite());
		rectEnd = new Rectangle(secondGraphX+.66*secondGraphWidth-rect.width, graphY+graphHeight*(1-combinedRatios[0]), combinedBarWidth, graphHeight*(combinedRatios[0]));
		voteBars[voteBars.length-1].graphics.beginFill(colour);
		voteBars[voteBars.length-1].graphics.drawRect(rectEnd.x,rectEnd.y,rect.width,rect.height); 
		VillageAnimation.defaultSquareMake(rect, new Rectangle(rectEnd.x, rectEnd.y, rectEnd.width, rectEnd.height), 1000, colour, 1);
		
		colour = 0x587A52;
		rect = new Rectangle(firstGraphX+.5*firstGraphWidth-combinedBarWidth*.5, graphY+graphHeight*(1-combinedRatios[1]), combinedBarWidth, graphHeight*(combinedRatios[1]));
		combinedBars.graphics.beginFill(colour);
		combinedBars.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
		voteBars.push(new Sprite());
		rectEnd = new Rectangle(secondGraphX+.33*secondGraphWidth, graphY+graphHeight*(1-combinedRatios[1]), combinedBarWidth, graphHeight*(combinedRatios[1]));
		voteBars[voteBars.length-1].graphics.beginFill(colour);
		voteBars[voteBars.length-1].graphics.drawRect(rectEnd.x,rectEnd.y,rect.width,rect.height); 
		VillageAnimation.defaultSquareMake(rect, new Rectangle(rectEnd.x, rectEnd.y, rectEnd.width, rectEnd.height), 1000, colour, 2);
		voteBars.push(new Sprite());
		rectEnd = new Rectangle(secondGraphX+.66*secondGraphWidth, graphY+graphHeight*(1-combinedRatios[1]), combinedBarWidth, graphHeight*(combinedRatios[1]));
		voteBars[voteBars.length-1].graphics.beginFill(colour);
		voteBars[voteBars.length-1].graphics.drawRect(rectEnd.x,rectEnd.y,rect.width,rect.height); 
		VillageAnimation.defaultSquareMake(rect, new Rectangle(rectEnd.x, rectEnd.y, rectEnd.width, rectEnd.height), 1000, colour, 3);
		
		colour = 0x76A09E;
		rect = new Rectangle(firstGraphX+.833*firstGraphWidth-combinedBarWidth*.5, graphY+graphHeight*(1-combinedRatios[2]), combinedBarWidth, graphHeight*(combinedRatios[2]));
		combinedBars.graphics.beginFill(colour);
		combinedBars.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
		voteBars.push(new Sprite());
		rectEnd = new Rectangle(secondGraphX+.33*secondGraphWidth-rect.width, graphY+graphHeight*(1-combinedRatios[2]-combinedRatios[0]), combinedBarWidth, graphHeight*(combinedRatios[2]));
		voteBars[voteBars.length-1].graphics.beginFill(colour);
		voteBars[voteBars.length-1].graphics.drawRect(rectEnd.x,rectEnd.y,rect.width,rect.height); 
		VillageAnimation.defaultSquareMake(rect, new Rectangle(rectEnd.x, rectEnd.y, rectEnd.width, rectEnd.height), 1500, colour, 4);
		voteBars.push(new Sprite());
		rectEnd = new Rectangle(secondGraphX+.66*secondGraphWidth, graphY+graphHeight*(1-combinedRatios[2]-combinedRatios[1]), combinedBarWidth, graphHeight*(combinedRatios[2]));
		voteBars[voteBars.length-1].graphics.beginFill(colour);
		voteBars[voteBars.length-1].graphics.drawRect(rectEnd.x,rectEnd.y,rect.width,rect.height); 
		VillageAnimation.defaultSquareMake(rect, new Rectangle(rectEnd.x, rectEnd.y, rectEnd.width, rectEnd.height), 1500, colour, 5);
	}
	public function transfered()
	{
		VillageAnimation.removeSquares();
		voteBarMainSprite.addChild(voteBars[voteBarSet]);
		voteBarSet++;
		VillageAnimation.currentType++;
		if(voteBarSet>=voteBars.length)
		{
			voteBarSet = 0;
			VillageAnimation.currentType = 0;
		}
		else
		{
			VillageAnimation.beginMove();
		}
	}
	public function reset(?e:Event#if false GET RID OF THIS #end)
	{
		VillageAnimation.isMoving = false;
		voteBarSet = 0;
		VillageAnimation.currentType = 0;
		voteBarMainSprite.removeChildren();
		VillageAnimation.removeSquares();
	}
	public function getSprite():Sprite
	{
		return graphSprite;
	}
}
