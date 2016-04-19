package;
import openfl.display.*;
import openfl.geom.*;
import openfl.text.*;
import openfl.events.*;

class CombinedVoteGraph
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
	public var secondGraphWidth:Float;
	public var thirdGraphX:Float;
	public var thirdGraphWidth:Float;
	public var graphY:Float;
	
	public var totGraphHeight:Float;
	
	public var barRects:Array<Array<Rectangle>> = [[],[],[]];
	
	public var factionPrefBars:Sprite;
	public var factionPrefBarWidth:Float;
	public var factionPrefRatios:Array<Array<Float>> = [[1, .5, .01], [.5, 1, .01], [.01, .01, .01], [0.01, 0.01, 1]];
	
	public var factionSizeBars:Sprite;
	public var factionSizeBarWidth:Float;
	public var factionSizeRatios:Array<Float> = [.31, .29, .40];
	
	public var factionLegend:Sprite;
	
	public var labelSprite:Sprite;
	public var yAxisSprite:Sprite;
	
	public var totPrefBars:Array<Array<Sprite>> = [];
	public var totPrefBarWidth:Float;
	
	public var calculateButton:SimpleButton;
	public var resetButton:SimpleButton;
	
	public var factionColours:Array<Int> = [0x585799,0x587A52,0x76A09E];
	
	public var fpa:FindCombinedVoteAnimation;
	
	public var stg:Stage;
	
	
	public function new(fpa:FindCombinedVoteAnimation)
	{
		this.fpa = fpa;
	}
	public function setup(s:Stage)
	{
		stg = s;
		totalWidth = Math.round(Math.min(Main.calibrationFactor*1000, (s.stageWidth-Main.calibrationFactor*40)*.9));
		graphHeight = Math.round(totalWidth*.333333);
		graphSprite = new Sprite();
		var testTextFormat = new TextFormat(Main.simulationFont.fontName, 14, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var testField = new TextField();
		testField.text = "TEST";
		testField.defaultTextFormat = testTextFormat;
		totGraphHeight = graphHeight+8*testField.textHeight;
		graphY = s.stageHeight-graphHeight-4*testField.textHeight;
		firstGraphX = .5*(s.stageWidth-totalWidth);
		firstGraphWidth = totalWidth*.5*(1-.5*gapPercent);
		secondGraphX = firstGraphX+totalWidth*.5*(1+.5*gapPercent);
		secondGraphWidth = .5*firstGraphWidth;
		thirdGraphX = secondGraphX+totalWidth*.25*(1+.5*gapPercent);
		thirdGraphWidth = secondGraphWidth;
		createGraphAxis();
		graphSprite.addChild(graphAxis);
		createFactionPrefBars();
		graphSprite.addChild(factionPrefBars);
		createFactionSizeBars();
		graphSprite.addChild(factionSizeBars);
		createTotPreferenceBars();
		createFactionLegend();
		graphSprite.addChild(factionLegend);
		createCalculateButton();
		graphSprite.addChild(calculateButton);
		createResetButton();
		createLabelSprite();
		graphSprite.addChild(labelSprite);
		createYAxisText();
		graphSprite.addChild(yAxisSprite);
		//graphSprite.addChild(combinedBars);
		//graphSprite.addChild(voteBarMainSprite);
		//#if false GET RID OF THIS #end
		//s.addEventListener(MouseEvent.MOUSE_UP, reset);
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
		graphAxis.graphics.moveTo(thirdGraphX,graphY+graphHeight);
		graphAxis.graphics.lineTo(thirdGraphX+thirdGraphWidth,graphY+graphHeight);
		graphAxis.graphics.lineTo(thirdGraphX+thirdGraphWidth,graphY);
	}
	public function getHeight()
	{
		return totGraphHeight;
	}
	public function createYAxisText()
	{
		yAxisSprite = new Sprite();
		var yAxisField:Array<TextField> = [];
		var yAxisTextFormat = new TextFormat(Main.simulationFont.fontName, 14, null, null, null, null, null, null, TextFormatAlign.CENTER);
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
		yAxisField[1].text = "Total Preference";
		yAxisField[1].width = yAxisField[1].textWidth*1.1;
		yAxisField[1].rotation = 90;
		yAxisField[1].x = thirdGraphX-firstGraphX+thirdGraphWidth+yAxisField[0].textHeight*1.2;
		yAxisField[1].y = .5*(graphHeight-yAxisField[1].width);
		for(i in 0...yAxisField.length)
		{
			yAxisSprite.addChild(yAxisField[i]);
		}
		yAxisSprite.y=graphY;
		yAxisSprite.x=firstGraphX;
	}
	public function createLabelSprite()
	{
		labelSprite = new Sprite();
		var labelField:Array<TextField> = [];
		var labelTextFormatSml = new TextFormat(Main.simulationFont.fontName, 12, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var labelTextFormatMed = new TextFormat(Main.simulationFont.fontName, 14, null, null, null, null, null, null, TextFormatAlign.CENTER);
		//var labelTextFormatBig = new TextFormat(Main.simulationFont.fontName, 16, null, null, null, null, null, null, TextFormatAlign.CENTER);
		for(i in 0...9)
		{
			labelField.push(new TextField());
			labelField[i].defaultTextFormat = labelTextFormatMed;
			labelField[i].autoSize = TextFieldAutoSize.NONE;
			labelField[i].textColor = 0x000000;
		}
		labelField[0].text = "Kill\nGary";
		labelField[0].x = firstGraphX+.2*firstGraphWidth-labelField[0].width*.5;
		labelField[0].y = graphY+graphHeight;
		labelField[1].text = "Kill\nBoth";
		labelField[1].x = firstGraphX+.4*firstGraphWidth-labelField[1].width*.5;
		labelField[1].y = graphY+graphHeight;
		labelField[2].text = "Just\nBird";
		labelField[2].x = firstGraphX+.6*firstGraphWidth-labelField[2].width*.5;
		labelField[2].y = graphY+graphHeight;
		labelField[3].text = "No\nKilling";
		labelField[3].x = firstGraphX+.8*firstGraphWidth-labelField[3].width*.5;
		labelField[3].y = graphY+graphHeight;
		labelField[4].text = "Faction Size\nand\nVote Outcome";
		labelField[4].x = secondGraphX+.5*secondGraphWidth-labelField[4].width*.5;
		labelField[4].y = graphY+graphHeight;
		labelField[5].text = "Kill\nGary";
		labelField[5].x = thirdGraphX+.2*thirdGraphWidth-labelField[5].width*.5;
		labelField[5].y = graphY+graphHeight;
		labelField[5].defaultTextFormat = labelTextFormatSml;
		labelField[6].text = "Kill\nBoth";
		labelField[6].x = thirdGraphX+.4*thirdGraphWidth-labelField[6].width*.5;
		labelField[6].y = graphY+graphHeight;
		labelField[6].defaultTextFormat = labelTextFormatSml;
		labelField[7].text = "Just\nBird";
		labelField[7].x = thirdGraphX+.6*thirdGraphWidth-labelField[7].width*.5;
		labelField[7].y = graphY+graphHeight;
		labelField[7].defaultTextFormat = labelTextFormatSml;
		labelField[8].text = "No\nKilling";
		labelField[8].x = thirdGraphX+.8*thirdGraphWidth-labelField[8].width*.5;
		labelField[8].y = graphY+graphHeight;
		labelField[8].defaultTextFormat = labelTextFormatSml;
		//labelField[9].text = "Total\nPreferability";
		//labelField[9].x = thirdGraphX+.5*thirdGraphWidth-labelField[9].width*.5;
		//labelField[9].y = graphY+graphHeight+labelField[9].textHeight;
		
		for(i in 0...labelField.length)
		{
			labelSprite.addChild(labelField[i]);
		}
	}
	public function createCalculateButton()
	{
		var calculateButtonSprites:Array<Sprite> = [];
		var calculateButtonTextFormat = new TextFormat(Main.simulationFont.fontName, 16, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var colours:Array<Int> = [0x000000, 0x587DA0, 0x2D4052];
		for(i in 0...3)
		{
			calculateButtonSprites.push(new Sprite());
			var calculateField = new TextField();
			calculateField.defaultTextFormat = calculateButtonTextFormat;
			calculateField.autoSize = TextFieldAutoSize.NONE;
			calculateField.text = "Find Preference";
			calculateField.width = calculateField.textWidth*1.2;
			calculateField.height = calculateField.textHeight*1.2;
			calculateField.textColor = colours[i];
			calculateField.border = true;
			calculateField.borderColor = colours[i];
			calculateButtonSprites[i].addChild(calculateField);
		}
		calculateButton = new SimpleButton(calculateButtonSprites[0], calculateButtonSprites[1], calculateButtonSprites[2], calculateButtonSprites[1]);
		calculateButton.x = secondGraphX;
		calculateButton.y = graphY-calculateButton.height;
		calculateButton.addEventListener(MouseEvent.CLICK, calButtonClick);
	}
	public function calButtonClick(?e:Event)
	{
		fpa.animateBar();
		graphSprite.addEventListener(Event.ENTER_FRAME, fpa.animateBar);
		graphSprite.removeChild(calculateButton);
		graphSprite.addChild(resetButton);
		resetButton.addEventListener(MouseEvent.CLICK, CombinedVote.reset);
	}
	public function createResetButton()
	{
		var resetButtonSprites:Array<Sprite> = [];
		var resetButtonTextFormat = new TextFormat(Main.simulationFont.fontName, 16, null, null, null, null, null, null, TextFormatAlign.CENTER);
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
		resetButton.x = secondGraphX;
		resetButton.y = graphY-resetButton.height;
	}
	public function createFactionLegend()
	{
		factionLegend = new Sprite();
		
		var rectWidth:Float = factionPrefBarWidth;
		
		var factionField:Array<TextField> = [];
		var factionTextFormat = new TextFormat(Main.simulationFont.fontName, 14, null, null, null, null, null, null, TextFormatAlign.LEFT);
		for(i in 0...4)
		{
			factionField.push(new TextField());
			factionField[i].defaultTextFormat = factionTextFormat;
			factionField[i].autoSize = TextFieldAutoSize.NONE;
			factionField[i].textColor = 0x000000;
		}
		factionField[0].text = "Faction Legend";
		var rectOffY = factionField[0].textHeight*1.4;
		var rectSpace = factionField[0].textHeight*1.2;
		factionField[1].text = "= Kill Gary";
		factionField[2].text = "= Kill Both";
		factionField[3].text = "= No Killing";
		for(i in 1...factionField.length)
		{
			factionField[i].y = i*rectSpace;
			factionField[i].x = rectWidth*1.1;
			factionLegend.graphics.beginFill(factionColours[i-1]);
			factionLegend.graphics.drawRect(0,rectOffY+(i-1)*rectSpace,rectWidth,factionField[0].textHeight*.8);
		}
		for(i in 0...factionField.length)
		{
			factionLegend.addChild(factionField[i]);
		}
		
		
		factionLegend.x = firstGraphX;
		factionLegend.y = graphY-factionField.length*rectSpace-.5*rectSpace;//factionLegend.height*1.1;
	}
	public function getSprite():Sprite
	{
		return graphSprite;
	}
	public function createFactionPrefBars(?barNum:Int = -1)
	{
		factionPrefBars = new Sprite();
		factionPrefBarWidth = firstGraphWidth*.05;
		var barX:Float= 0;
		var barY:Float= 0;
		var barWidth:Float = 0;
		var barHeight:Float = 0;     
		barRects[0] = [];
		for(i in 0...factionPrefRatios.length)
		{
			for(j in 0...factionPrefRatios[i].length)
			{
				barX = firstGraphX+firstGraphWidth*((i+1)/(factionPrefRatios.length+1))+(factionPrefBarWidth)*(j-factionPrefRatios[i].length*.5);
				barY = graphY+graphHeight*(1-factionPrefRatios[i][j]);
				barWidth = factionPrefBarWidth;
				barHeight = graphHeight*(factionPrefRatios[i][j]);
				barRects[0].push(new Rectangle(barX, barY, barWidth, barHeight));
				if(barNum == -1 || barNum == Math.round(i*factionPrefRatios.length+j))
				factionPrefBars.graphics.beginFill(factionColours[j]);
				else
				factionPrefBars.graphics.beginFill(factionColours[j], .3);
				factionPrefBars.graphics.drawRect(barX,barY,barWidth,barHeight);
			}
		}
	}
	public function createFactionSizeBars(?barNum:Int = -1)
	{
		factionSizeBars = new Sprite();
		factionSizeBarWidth = secondGraphWidth*.15;
		var barX:Float= 0;
		var barY:Float= 0;
		var barWidth:Float = 0;
		var barHeight:Float = 0;    
		barRects[1] = [];
		for(i in 0...factionSizeRatios.length)
		{
			barX = secondGraphX+secondGraphWidth*((i+1)/(factionSizeRatios.length+1))-.5*(factionSizeBarWidth);
			barY = graphY+graphHeight*(1-factionSizeRatios[i]);
			barWidth = factionSizeBarWidth;
			barHeight = graphHeight*(factionSizeRatios[i]);
			barRects[1].push(new Rectangle(barX, barY, barWidth, barHeight));
			if(barNum == -1 || barNum == i)
			factionSizeBars.graphics.beginFill(factionColours[i]);
			else
			factionSizeBars.graphics.beginFill(factionColours[i], .3);
			factionSizeBars.graphics.drawRect(barX,barY,barWidth,barHeight);
		}
	}
	public function createTotPreferenceBars()
	{
		totPrefBarWidth = thirdGraphWidth*.1;
		var barX:Float= 0;
		var barY:Float= 0;
		var barWidth:Float = 0;
		var barHeight:Float = 0;
		barRects[2] = [];
		for(i in 0...factionPrefRatios.length)
		{
			totPrefBars.push([]);
			var totBarHeight:Float = 0;
			for(j in 0...factionPrefRatios[i].length)
			{
				totPrefBars[i].push(new Sprite());
				barX = thirdGraphX+thirdGraphWidth*((i+1)/(factionPrefRatios.length+1))-.5*(totPrefBarWidth);
				barY = graphY+graphHeight*(1-factionPrefRatios[i][j]*factionSizeRatios[j]) - totBarHeight;
				barWidth = totPrefBarWidth;
				barHeight = graphHeight*(factionPrefRatios[i][j]*factionSizeRatios[j]);
				totBarHeight += barHeight;
				barRects[2].push(new Rectangle(barX, barY, barWidth, barHeight));
				totPrefBars[i][j].graphics.lineStyle(1, factionColours[j]);
				totPrefBars[i][j].graphics.beginFill(factionColours[j]);
				totPrefBars[i][j].x = barX;
				totPrefBars[i][j].y = barY;
				totPrefBars[i][j].graphics.drawRect(0,0,barWidth,barHeight);
				//graphSprite.addChild(totPrefBars[i][j]);
			}
		}
	}
	public function addTotPrefBar(barNum:Int)
	{
		for(i in 0...totPrefBars[barNum].length)
		{
			graphSprite.addChild(totPrefBars[barNum][i]);
		}
	}
	public function fadeBars(graphNum:Int, barNum:Int)//fades all bars in graphNum except for barNum. Set barNum to -1 to unfade all and -2 to fade all.
	{
		if(graphNum == 0)
		{
			graphSprite.removeChild(factionPrefBars);
			createFactionPrefBars(barNum);
			graphSprite.addChild(factionPrefBars);
		}
		if(graphNum == 1)
		{
			graphSprite.removeChild(factionSizeBars);
			createFactionSizeBars(barNum);
			graphSprite.addChild(factionSizeBars);
		}
	}
}
