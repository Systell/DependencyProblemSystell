package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.Assets;
import openfl.text.*;

class LegislatureDisplay
{
	public var legislatureDisplaySprite:Sprite;
	public var mainColumnSprite:Sprite;
	public var mainColumnTextSprite:Sprite;
	public var preferenceSprite:Sprite;
	public var voteOutcomeSprite:Sprite;
	public var preferenceOutcomeSprite:Sprite;
	public var yourOutcomeSprite:Sprite;
	public var preferenceAdjustSprite:Sprite;
	
	public var preferenceSquares:Array<LegislaturePreferenceSquare> = [];
	
	public static var partyColours:Array<Int> = [0xC6A5B1,0x938467,0x6A8C6A];
	
	public var spacing:Float;
	
	public var changeYoursButton:Array<SimpleButton>= [];
	public var changeYoursRect:Array<Rectangle>= [];
	public var changeYoursParty:Array<Int> = [];
	public var changeYoursButtonParty:Array<Int> = [];
	public var yourOutcomeSelectSprite:Array<Sprite> = [];
	
	public var expandButtons:Array<SimpleButton>= [];
	public var contractButtons:Array<SimpleButton>= [];
	public var currentExpanded:Int = -1;
	public var adjustBar:Array<Sprite> = [];
	public var preferenceAdjustMain:Sprite;
	public var adjustButton:Array<SimpleButton> = [];
	
	public var totTextWidth:Float = 0;
	
	public static var districtAmount:Int = 9;
	public static var mainDisplayWidth:Float;
	public static var mainDisplayHeight:Float;
	public static var preferenceAdjustWidth:Float;
	public static var totSpriteHeight:Float;
	
	public var partyChangeSize:Float;
	
	public var origSmallestText:Int = 12;
	public var origSmallText:Int = 14;
	public var origLargeText:Int = 16;
	public var smallestText:Int = 12;
	public var smallText:Int = 14;
	public var largeText:Int = 16;
	public function new()
	{
		
	}
	public function setup(s:Stage)
	{
		if(Main.textSizeRatio > 0)
		{
			smallestText=Math.round(origSmallestText*Main.textSizeRatio);
			smallText=Math.round(origSmallText*Main.textSizeRatio);
			largeText=Math.round(origLargeText*Main.textSizeRatio);
		}
		
		LegislatureDisplay.mainDisplayWidth =  Math.round(Math.min(Main.calibrationFactor*800, (s.stageWidth)*.65));
		LegislatureDisplay.mainDisplayHeight = Math.round(LegislatureDisplay.mainDisplayWidth*.5);
		LegislatureDisplay.preferenceAdjustWidth = Math.round(LegislatureDisplay.mainDisplayWidth*.25);
		spacing = mainDisplayHeight/districtAmount;
		legislatureDisplaySprite = new Sprite();
		mainColumnSprite = new Sprite();
		mainColumnTextSprite = new Sprite();
		mainColumnSprite.x = .5*(s.stageWidth-LegislatureDisplay.mainDisplayWidth*.75);
		
		var testTextFormat = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var testField = new TextField();
		testField.text = "TEST";
		
		LegislatureDisplay.totSpriteHeight = LegislatureDisplay.mainDisplayHeight+testField.textHeight*1;
		mainColumnSprite.y = s.stageHeight-LegislatureDisplay.mainDisplayHeight;
		mainColumnTextSprite = new Sprite();
		columnTextSetup();
		legislatureDisplaySprite.addChild(mainColumnTextSprite);
		preferenceSetup();
		mainColumnSprite.addChild(preferenceSprite);
		preferenceAdjustSetup();
		legislatureDisplaySprite.addChild(preferenceAdjustSprite);
		voteOutcomeSetup();
		mainColumnSprite.addChild(voteOutcomeSprite);
		yourOutcomeSetup();
		mainColumnSprite.addChild(yourOutcomeSprite);
		preferenceOutcomeSetup();
		mainColumnSprite.addChild(preferenceOutcomeSprite);
		legislatureDisplaySprite.addChild(mainColumnSprite);
	}
	public function columnTextSetup()
	{
		var columnField:Array<TextField> = [];
		var columnTextFormat = new TextFormat(Main.simulationFont.fontName, smallText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		for(i in 0...4)
		{
			columnField.push(new TextField());
			columnField[i].defaultTextFormat = columnTextFormat;
			columnField[i].autoSize = TextFieldAutoSize.NONE;
			columnField[i].textColor = 0x000000;
		}
		columnField[0].text = "District\nPreferences";
		columnField[1].text = "Vote\nOutcome";
		columnField[2].text = "Your\nOutcome";
		columnField[3].text = "Total\nPreferability";
		totTextWidth = 0;
		var totTextHeight:Float = 0;
		for(i in 0...columnField.length)
		{
			totTextWidth += columnField[i].textWidth;
			totTextHeight = Math.max(columnField[i].textHeight, totTextHeight);
		}
		mainDisplayWidth = Math.max(mainDisplayWidth,totTextWidth*1.1);
		var columnSpacing = mainDisplayWidth/columnField.length;
		var fieldHeight = 0;
		columnField[0].x = -.5*columnField[0].width+.5*spacing;
		columnField[1].x = -.5*columnField[1].width+.5*spacing;
		columnField[2].x = -.5*columnField[2].width+.5*spacing;
		//columnField[3].x = -.5*columnField[3].width;
		for(i in 0...columnField.length)
		{
			columnField[i].x += i*columnSpacing;
			mainColumnTextSprite.addChild(columnField[i]);
		}
		mainColumnTextSprite.x = mainColumnSprite.x;
		mainColumnTextSprite.y = mainColumnSprite.y-totTextHeight*1.1;
	}
	public function preferenceSetup()
	{
		preferenceSprite = new Sprite();
		var nonGap = spacing*.75;
		var offSetY = .5*(spacing-nonGap);
		var localVictory:Array<Array<Float>> = [[.6,.2,.4],[.7,.2,.3],[.7,.3,.2],[.6,.4,.2],[.4,.6,.2],[.3,.7,.3],[.2,.6,.4],[.2,.4,.6],[.4,.2,.6]];
		var nationalVictory:Array<Array<Float>> = [[.9,.7,.8],[.9,.7,.8],[.9,.8,.7],[.9,.8,.7],[.8,.9,.7],[.8,.9,.8],[.7,.9,.8],[.7,.8,.9],[.8,.7,.9]];
		for(i in 0...LegislatureDisplay.districtAmount)
		{
			preferenceSquares.push( new LegislaturePreferenceSquare(localVictory[i],nationalVictory[i],.1,new Rectangle(0, 0, nonGap, nonGap)));
			preferenceSquares[i].squareSprite.x = 0;
			preferenceSquares[i].squareSprite.y = i*spacing+offSetY;
			preferenceSprite.addChild(preferenceSquares[i].squareSprite);
		}
	}
	public function preferenceAdjustSetup()
	{
		preferenceAdjustSprite = new Sprite();
		preferenceAdjustSprite.y = mainColumnSprite.y;
		preferenceAdjustSprite.x = mainColumnSprite.x-preferenceAdjustWidth;
		var buttonSize:Float = .25*spacing;
		for(i in 0...districtAmount)
		{
			var buttonSprite = adjustIcons(false, buttonSize);
			expandButtons.push(new SimpleButton(buttonSprite[0], buttonSprite[1], buttonSprite[2], buttonSprite[1]));
			expandButtons[i].addEventListener(MouseEvent.CLICK, expandPreferenceAdjust);
			var buttonSprite = adjustIcons(true, buttonSize);
			contractButtons.push(new SimpleButton(buttonSprite[0], buttonSprite[1], buttonSprite[2], buttonSprite[1]));
			contractButtons[i].addEventListener(MouseEvent.CLICK, contractPreferenceAdjust);
			expandButtons[i].x = preferenceAdjustWidth - expandButtons[i].width*1.1;
			contractButtons[i].x = preferenceAdjustWidth - contractButtons[i].width*1.1;
			var offSetY = .5*(spacing-expandButtons[i].height);
			expandButtons[i].y = offSetY + i*spacing;
			offSetY = .5*(spacing-contractButtons[i].height);
			contractButtons[i].y = offSetY + i*spacing;
			preferenceAdjustSprite.addChild(expandButtons[i]);
			//preferenceAdjustSprite.addChild(contractButtons[i]); 
		}
		for(i in 0...7)
		{
			adjustBar.push(new Sprite());
		}
	}
	public function preferenceAdjustCreate(districtNum:Int)
	{
		preferenceAdjustSprite.removeChild(preferenceAdjustMain);
		preferenceAdjustMain = new Sprite();
		var downward:Bool = true;//whether preference adjuster goes down from the arrow or up
		if(districtNum > districtAmount*.5)
		downward = false;
		var dir:Int = -1;//direction
		if(downward)
		dir = 1;
		
		var preferenceAdjustField:Array<TextField> = [];
		var preferenceAdjustTextFormat = new TextFormat(Main.simulationFont.fontName, smallestText, null, null, null, null, null, null, TextFormatAlign.LEFT);
		for(i in 0...4)
		{
			preferenceAdjustField.push(new TextField());
			preferenceAdjustField[i].defaultTextFormat = preferenceAdjustTextFormat;
			preferenceAdjustField[i].autoSize = TextFieldAutoSize.NONE;
			preferenceAdjustField[i].textColor = 0x000000;
		}
		preferenceAdjustField[0].text = "Local\nVictory";
		preferenceAdjustField[1].text = "National\nVictory";
		preferenceAdjustField[2].text = "No Majority";
		
		var textLength:Float = 0;
		for(i in 0...preferenceAdjustField.length-1)
		{
			textLength = Math.max(textLength,preferenceAdjustField[i].textWidth);
			preferenceAdjustField[i].width= preferenceAdjustField[i].textWidth*1.1;
		}
		
		preferenceAdjustField[3].text = "Preferability";
		for(i in 0...preferenceAdjustField.length)
		{
			preferenceAdjustMain.addChild(preferenceAdjustField[i]);
		}
		
		//textLength*=1.1;
		var adjustHeight = LegislatureDisplay.mainDisplayHeight*.4;
		var maxBarWidth = LegislatureDisplay.mainDisplayHeight*.4;
		var barHeight = .1*adjustHeight;
		
		var adjustButtonHeight = .8*barHeight;
		var adjustButtonWidth = adjustButtonHeight*3;
		
		for(i in 0...adjustBar.length)
		{
			adjustBar[i] = new Sprite();
			var tempSpr:Array<Sprite> = createAdjustButtonSprite(adjustButtonWidth,adjustButtonHeight);
			adjustButton.push(new SimpleButton(tempSpr[0], tempSpr[1], tempSpr[2], tempSpr[1]));
			adjustButton[i].addEventListener(MouseEvent.MOUSE_DOWN,adjustActive);
			
		}
		var offSetY:Float = districtNum*spacing;
		
		//if(!downward)
		//offSetY -= adjustHeight;
		adjustBar[0].y = offSetY+adjustHeight*0;
		adjustBar[1].y = offSetY+adjustHeight*.1*dir;
		adjustBar[2].y = offSetY+adjustHeight*.2*dir;
		adjustBar[3].y = offSetY+adjustHeight*.45*dir;
		adjustBar[4].y = offSetY+adjustHeight*.55*dir;
		adjustBar[5].y = offSetY+adjustHeight*.65*dir;
		adjustBar[6].y = offSetY+adjustHeight*.9*dir;
		//??Don't know why the scaling for the text is all weird
		if(dir > 0)
		{
			preferenceAdjustField[0].y = offSetY+adjustHeight*.15*dir-preferenceAdjustField[0].textHeight*.5;
			preferenceAdjustField[1].y = offSetY+adjustHeight*.6*dir-preferenceAdjustField[1].textHeight*.5;
			preferenceAdjustField[2].y = offSetY+adjustHeight*.95*dir-preferenceAdjustField[2].textHeight*.5;
		}
		else
		{
			preferenceAdjustField[0].y = offSetY+adjustHeight*.15*dir-preferenceAdjustField[0].textHeight*.25;
			preferenceAdjustField[1].y = offSetY+adjustHeight*.6*dir-preferenceAdjustField[1].textHeight*.25;
			preferenceAdjustField[2].y = offSetY+adjustHeight*.95*dir-preferenceAdjustField[2].textHeight*.25;
		}
		
		//if(dir < 0)
		//preferenceAdjustField[3].y = offSetY-dir*preferenceAdjustField[3].textHeight*.5;
		//else
		preferenceAdjustField[3].y = offSetY-dir*preferenceAdjustField[3].textHeight;
		
		var width = preferenceSquares[districtNum].localVictoryCurrent[0]*maxBarWidth;
		adjustBar[0].graphics.beginFill(LegislatureDisplay.partyColours[0]);
		adjustBar[0].graphics.drawRect(0,0,width,barHeight);
		width = preferenceSquares[districtNum].localVictoryCurrent[1]*maxBarWidth;
		adjustBar[1].graphics.beginFill(LegislatureDisplay.partyColours[1]);
		adjustBar[1].graphics.drawRect(0,0,width,barHeight);
		width = preferenceSquares[districtNum].localVictoryCurrent[2]*maxBarWidth;
		adjustBar[2].graphics.beginFill(LegislatureDisplay.partyColours[2]);
		adjustBar[2].graphics.drawRect(0,0,width,barHeight);
		width = preferenceSquares[districtNum].nationalVictoryCurrent[0]*maxBarWidth;
		adjustBar[3].graphics.beginFill(LegislatureDisplay.partyColours[0]);
		adjustBar[3].graphics.drawRect(0,0,width,barHeight);
		width = preferenceSquares[districtNum].nationalVictoryCurrent[1]*maxBarWidth;
		adjustBar[4].graphics.beginFill(LegislatureDisplay.partyColours[1]);
		adjustBar[4].graphics.drawRect(0,0,width,barHeight);
		width = preferenceSquares[districtNum].nationalVictoryCurrent[2]*maxBarWidth;
		adjustBar[5].graphics.beginFill(LegislatureDisplay.partyColours[2]);
		adjustBar[5].graphics.drawRect(0,0,width,barHeight);
		width = preferenceSquares[districtNum].noMajorityCurrent*maxBarWidth;
		adjustBar[6].graphics.beginFill(0x444444);
		adjustBar[6].graphics.drawRect(0,0,width,barHeight);
		
		for(i in 0...adjustBar.length)
		{
			adjustBar[i].x = maxBarWidth-adjustBar[i].width;
			adjustBar[i].removeChildren();
			//adjustBar[i].addChild(adjustButton[i]);
			#if false ADJUST BAR IS HERE #end
			adjustButton[i].y = .5*(adjustBar[i].height-adjustButton[i].height);
			preferenceAdjustMain.addChild(adjustBar[i]);
		}
		
		for(i in 0...preferenceAdjustField.length-1)
		{
			preferenceAdjustField[i].x = maxBarWidth;
		}
		preferenceAdjustField[3].x = .5*(maxBarWidth-preferenceAdjustField[3].width);
		
		preferenceAdjustMain.x -= textLength;
		preferenceAdjustMain.graphics.lineStyle(1, 0x000000);
		if(downward)
		{
			preferenceAdjustMain.graphics.moveTo(maxBarWidth,offSetY+adjustHeight*dir);
			preferenceAdjustMain.graphics.lineTo(maxBarWidth,offSetY);
			preferenceAdjustMain.graphics.lineTo(0,offSetY);
		}
		else
		{
			preferenceAdjustMain.graphics.moveTo(maxBarWidth,offSetY+barHeight);
			preferenceAdjustMain.graphics.lineTo(maxBarWidth,offSetY+adjustHeight*dir+barHeight);
			preferenceAdjustMain.graphics.moveTo(maxBarWidth,offSetY+barHeight);
			preferenceAdjustMain.graphics.lineTo(0,offSetY+barHeight);
		}
		preferenceAdjustSprite.addChild(preferenceAdjustMain);
	}
	public function adjustABar()
	{
		
	}
	public function adjustActive(e:Event)
	{
		for(i in 0...adjustBar.length)
		{
			trace(adjustBar[i].mouseX, adjustBar[i].width, adjustBar[i].mouseY, adjustBar[i].height);
			if(adjustBar[i].mouseX<adjustBar[i].width && adjustBar[i].mouseY<adjustBar[i].height)
			{
				trace(i);
			}
		}
	}
	public function adjustDeactive(e:Event)
	{
		
	}
	public function createAdjustButtonSprite(buttonWidth:Float,buttonHeight:Float):Array<Sprite>
	{
		var triangleWidth = Math.min(buttonHeight,.333*buttonWidth);
		var seperation = buttonWidth-triangleWidth*2;
		var halfSep = .5*seperation;
		var adjustSprites:Array<Sprite> = [];
		var colours:Array<Int> = [0x7FA8A6, 0x587DA0, 0x2D4052];
		for(i in 0...3)
		{
			adjustSprites.push(new Sprite());
			//adjustSprites[i].graphics.beginFill(0x000000, 0);
			adjustSprites[i].graphics.lineStyle(1, colours[i], 1, true);
			adjustSprites[i].graphics.moveTo(halfSep, 0);
			adjustSprites[i].graphics.lineTo(halfSep+triangleWidth, .5*triangleWidth);
			adjustSprites[i].graphics.lineTo(halfSep, triangleWidth);
			
			adjustSprites[i].graphics.moveTo(-.5*buttonWidth+triangleWidth, 0);
			adjustSprites[i].graphics.lineTo(-.5*buttonWidth, .5*triangleWidth);
			adjustSprites[i].graphics.lineTo(-.5*buttonWidth+triangleWidth, triangleWidth);
			
			adjustSprites[i].graphics.beginFill(0x000000, 0);
			adjustSprites[i].graphics.lineStyle(0, 0x000000, 0, true);
			adjustSprites[i].graphics.drawRect(-.5*adjustSprites[i].width,0,adjustSprites[i].width,adjustSprites[i].height);
		}
		return adjustSprites;
	}
	public function expandPreferenceAdjust(e:Event)
	{
		var selectNum:Int = 0;
		for(i in 0...expandButtons.length)
		{
			if(expandButtons[i].mouseX < expandButtons[i].width && expandButtons[i].mouseY < expandButtons[i].height)
			{
				selectNum = i;
				break;
			}
		}
		preferenceAdjustCreate(selectNum);
		preferenceAdjustSprite.removeChild(expandButtons[selectNum]);
		if(currentExpanded != -1)
		{
			preferenceAdjustSprite.removeChild(contractButtons[currentExpanded]);
			preferenceAdjustSprite.addChild(expandButtons[currentExpanded]);
		}
		preferenceAdjustSprite.addChild(contractButtons[selectNum]);
		currentExpanded = selectNum;
	}
	public function contractPreferenceAdjust(e:Event)
	{
		var selectNum:Int = 0;
		for(i in 0...contractButtons.length)
		{
			if(contractButtons[i].mouseX < contractButtons[i].width && contractButtons[i].mouseY < contractButtons[i].height)
			{
				selectNum = i;
				break;
			}
		}
		preferenceAdjustSprite.removeChild(preferenceAdjustMain);
		preferenceAdjustSprite.removeChild(contractButtons[selectNum]);
		preferenceAdjustSprite.addChild(expandButtons[selectNum]);
		currentExpanded = -1;
	}
	public function adjustIcons(contract:Bool, triangleWidth:Float):Array<Sprite>
	{
		var halfTriangleWidth = .5*triangleWidth;
		var adjustSprites:Array<Sprite> = [];
		for(i in 0...3)
		{
			adjustSprites.push(new Sprite());
			adjustSprites[i].graphics.beginFill(0x000000, 0);
			if(contract)
			{
				var colours:Array<Int> = [0x666666, 0x587DA0, 0x2D4052];
				adjustSprites[i].graphics.lineStyle(1, colours[i], 1, true);
				adjustSprites[i].graphics.moveTo(0, 0);
				adjustSprites[i].graphics.lineTo(triangleWidth, .5*triangleWidth);
				adjustSprites[i].graphics.lineTo(0, triangleWidth);
				adjustSprites[i].graphics.beginFill(0x000000, 0);
				adjustSprites[i].graphics.lineStyle(0, 0x000000, 0, true);
				adjustSprites[i].graphics.drawRect(0,0,adjustSprites[i].width,adjustSprites[i].height);
			}
			else
			{
				var colours:Array<Int> = [0x000000, 0x587DA0, 0x2D4052];
				adjustSprites[i].graphics.lineStyle(1, colours[i], 1, true);
				adjustSprites[i].graphics.moveTo(triangleWidth, 0);
				adjustSprites[i].graphics.lineTo(0, .5*triangleWidth);
				adjustSprites[i].graphics.lineTo(triangleWidth, triangleWidth);
				adjustSprites[i].graphics.beginFill(0x000000, 0);
				adjustSprites[i].graphics.lineStyle(0, 0x000000, 0, true);
				adjustSprites[i].graphics.drawRect(0,0,adjustSprites[i].width,adjustSprites[i].height);
			}
		}
		return adjustSprites;
	}
	public function voteOutcomeSetup()
	{
		voteOutcomeSprite = new Sprite();
		var nonGap = spacing*.75;
		voteOutcomeSprite.x = mainDisplayWidth*.25;
		var offSetY = .5*(spacing-nonGap);
		for(i in 0...LegislatureDisplay.districtAmount)
		{
			var colour = LegislatureDisplay.partyColours[preferenceSquares[i].maxValHolder];
			voteOutcomeSprite.graphics.beginFill(colour);
			voteOutcomeSprite.graphics.drawRect(0,i*spacing+offSetY,nonGap,nonGap);
		}
	}
	public function yourOutcomeSetup()
	{
		yourOutcomeSprite = new Sprite();
		var totWidth = mainDisplayHeight*.25;
		var nonGap = spacing*.75;
		var nonGapBig = spacing*.75;
		var nonGapSmall = spacing*.3;
		var nonGapSpace = spacing*.1;
		var offSetY = .5*(spacing-nonGapBig);
		yourOutcomeSprite.x = mainDisplayWidth*.5;
		var partyAmount = partyColours.length;
		changeYoursButton = [];
		var offSetRatio:Float = 1.1;
		partyChangeSize = nonGapSmall;
		var offSetSmall = .5*(spacing-(partyAmount-1)*offSetRatio*partyChangeSize);
		for(i in 0...LegislatureDisplay.districtAmount)
		{
			changeYoursParty.push(preferenceSquares[i].maxValHolder);
			yourOutcomeSelectSprite.push(new Sprite());
			yourOutcomeSelectSprite[yourOutcomeSelectSprite.length-1] = createSelectedSprite(changeYoursParty[i], nonGapBig);
			yourOutcomeSelectSprite[yourOutcomeSelectSprite.length-1].y = i*spacing+offSetY;
			yourOutcomeSprite.addChild(yourOutcomeSelectSprite[yourOutcomeSelectSprite.length-1]);
			
			for(j in 0...partyAmount-1)
			{
				var buttonSprites:Array<Sprite> = createYoursButtonSprite((changeYoursParty[i]+1+j)%partyColours.length, partyChangeSize);
				changeYoursButton.push(new SimpleButton(buttonSprites[0],buttonSprites[1],buttonSprites[2],buttonSprites[1]));
				changeYoursButton[changeYoursButton.length-1].x = Math.min(totWidth-nonGapSmall,nonGapBig*1.5);
				changeYoursButton[changeYoursButton.length-1].y = offSetSmall+i*spacing+j*(changeYoursButton[changeYoursButton.length-1].height*offSetRatio);
				changeYoursRect.push(new Rectangle(changeYoursButton[changeYoursButton.length-1].x, changeYoursButton[changeYoursButton.length-1].y, changeYoursButton[changeYoursButton.length-1].width, changeYoursButton[changeYoursButton.length-1].height));
				changeYoursButtonParty.push((changeYoursParty[i]+1+j)%(partyAmount));
				changeYoursButton[changeYoursButton.length-1].addEventListener(MouseEvent.CLICK, yourOutcomeChange);
				yourOutcomeSprite.addChild(changeYoursButton[(partyAmount-1)*i+j]);
			}
		}
	}
	public function createSelectedSprite(partyNum:Int, size:Float):Sprite
	{
		var selectSprite:Sprite = new Sprite();
		var colour = LegislatureDisplay.partyColours[partyNum];
		selectSprite.graphics.beginFill(colour);
		selectSprite.graphics.drawRect(0,0,size,size);
		return selectSprite;
	}
	public function createYoursButtonSprite(partyNum:Int, partyChangeSize:Float):Array<Sprite>
	{
		var partySprites = [];
		partySprites.push(new Sprite());
		partySprites[0].graphics.lineStyle(1,0x000000);
		partySprites[0].graphics.beginFill(LegislatureDisplay.partyColours[partyNum]);
		partySprites[0].graphics.drawRect(0,0,partyChangeSize,partyChangeSize);
		partySprites.push(new Sprite());
		partySprites[1].graphics.lineStyle(1,0x587DA0);
		partySprites[1].graphics.beginFill(LegislatureDisplay.partyColours[partyNum]);
		partySprites[1].graphics.drawRect(0,0,partyChangeSize,partyChangeSize);
		partySprites.push(new Sprite());
		partySprites[2].graphics.lineStyle(1,0x2D4052);
		partySprites[2].graphics.beginFill(LegislatureDisplay.partyColours[partyNum]);
		partySprites[2].graphics.drawRect(0,0,partyChangeSize,partyChangeSize);
		return partySprites;
	}
	public function yourOutcomeChange(e:Event)
	{
		var selectNum:Int = 0;
		var buttonNum:Int = 0;
		var partyAmount = partyColours.length;
		for(i in 0...changeYoursButton.length)
		{
			if(changeYoursButton[i].mouseX<changeYoursButton[i].width && changeYoursButton[i].mouseY<changeYoursButton[i].height)
			{
				selectNum = Math.floor(i/(partyAmount-1)+.001);
				buttonNum = i;
				break;
			}
		}
		changeYoursParty[selectNum] = changeYoursButtonParty[buttonNum];
		yourOutcomeSprite.removeChild(yourOutcomeSelectSprite[selectNum]);
		var x:Float = yourOutcomeSelectSprite[selectNum].x;
		var y:Float = yourOutcomeSelectSprite[selectNum].y;
		var width:Float = yourOutcomeSelectSprite[selectNum].width;
		var height:Float = yourOutcomeSelectSprite[selectNum].height;
		yourOutcomeSelectSprite[selectNum] = createSelectedSprite(changeYoursButtonParty[buttonNum], width);
		yourOutcomeSelectSprite[selectNum].y = y;
		yourOutcomeSprite.addChild(yourOutcomeSelectSprite[selectNum]);
		for(i in 0...partyAmount-1)
		{
			var partyNum:Int = (changeYoursParty[selectNum]+1+i)%partyColours.length;
			var buttonSprites:Array<Sprite> = createYoursButtonSprite(partyNum, partyChangeSize);
			var arrayNum:Int = (partyAmount-1)*selectNum+i;
			changeYoursButton[arrayNum].upState = buttonSprites[0];
			changeYoursButton[arrayNum].overState = buttonSprites[1];
			changeYoursButton[arrayNum].downState = buttonSprites[2];
			changeYoursButton[arrayNum].hitTestState = buttonSprites[1];
			changeYoursButtonParty[arrayNum] = partyNum;
		}
		mainColumnSprite.removeChild(preferenceOutcomeSprite);
		preferenceOutcomeSetup();
		mainColumnSprite.addChild(preferenceOutcomeSprite);
	}
	public function preferenceOutcomeSetup()
	{
		preferenceOutcomeSprite = new Sprite();
		preferenceOutcomeSprite.x = mainDisplayWidth*.75;
		var graphHeight = .8*LegislatureDisplay.mainDisplayHeight;
		var graphWidth = mainDisplayWidth*.25;
		var barWidth = .2*graphWidth;
		var ratioV:Float = getVotePreferenceBarRatio();
		var ratioY:Float = getYourPreferenceBarRatio();
		var axisSprite:Sprite = new Sprite();
		axisSprite.graphics.lineStyle(1,0x000000);
		axisSprite.graphics.moveTo(0,0);
		axisSprite.graphics.lineTo(0,graphHeight);
		axisSprite.graphics.lineTo(graphWidth,graphHeight);
		preferenceOutcomeSprite.addChild(axisSprite);
		preferenceOutcomeSprite.graphics.beginFill(0x555555);
		preferenceOutcomeSprite.graphics.drawRect(.33*graphWidth-.5*barWidth,(1-ratioV)*graphHeight,barWidth,ratioV*graphHeight);
		preferenceOutcomeSprite.graphics.beginFill(0x555577);
		preferenceOutcomeSprite.graphics.drawRect(.66*graphWidth-.5*barWidth,(1-ratioY)*graphHeight,barWidth,ratioY*graphHeight);
		
		var labelTextFormat = new TextFormat(Main.simulationFont.fontName, smallestText, null, null, null, null, null, null, TextFormatAlign.CENTER);
		var voteLabelField = new TextField();
		voteLabelField.defaultTextFormat = labelTextFormat;
		voteLabelField.autoSize = TextFieldAutoSize.NONE;
		voteLabelField.textColor = 0x000000;
		voteLabelField.text = "Vote";
		
		var yourLabelField = new TextField();
		yourLabelField.defaultTextFormat = labelTextFormat;
		yourLabelField.autoSize = TextFieldAutoSize.NONE;
		yourLabelField.textColor = 0x000000;
		yourLabelField.text = "Yours";
		
		var offSet = Math.max(voteLabelField.textWidth, yourLabelField.textWidth)*.05;
		voteLabelField.x = .33*graphWidth-.5*voteLabelField.textWidth;
		yourLabelField.x = .66*graphWidth-.5*yourLabelField.textWidth;
		if(voteLabelField.x+voteLabelField.textWidth+offSet>yourLabelField.x)
		{
			voteLabelField.x = graphWidth*.5-offSet-voteLabelField.textWidth;
			yourLabelField.x = graphWidth*.5+offSet;
		}
		voteLabelField.width = Math.ceil(voteLabelField.textWidth*1.1);
		yourLabelField.width = Math.ceil(yourLabelField.textWidth*1.1);
		voteLabelField.y = graphHeight+voteLabelField.textHeight*.1;
		yourLabelField.y = graphHeight+yourLabelField.textHeight*.1;
		preferenceOutcomeSprite.addChild(voteLabelField);
		preferenceOutcomeSprite.addChild(yourLabelField); 
	}
	public function getVotePreferenceBarRatio():Float
	{
		var partyAmount:Int = LegislatureDisplay.partyColours.length;
		var majorityParty:Int = -1;
		var totalPossiblePref:Float = LegislatureDisplay.districtAmount*2;
		var totalPref:Float = 0;
		var seats:Array<Int> = [];
		for(i in 0...partyAmount)
		{
			seats.push(0);
			for(j in 0...LegislatureDisplay.districtAmount)
			{
				if(preferenceSquares[j].maxValHolder == i)
				seats[i]++;
			}
			if(seats[i] >= LegislatureDisplay.districtAmount/2)
			{
				majorityParty = i;
				break;
			}
		}
		for(i in 0...LegislatureDisplay.districtAmount)
		{
			var localPref:Float = preferenceSquares[i].localVictoryCurrent[preferenceSquares[i].maxValHolder];
			totalPref+=localPref;
			if(majorityParty == -1)
			{
				totalPref+= preferenceSquares[i].noMajorityCurrent;
			}
			else
			{
				totalPref+= preferenceSquares[i].nationalVictoryCurrent[majorityParty];
			}
		}
		return totalPref/totalPossiblePref;
	}
	public function getYourPreferenceBarRatio():Float
	{
		var partyAmount:Int = LegislatureDisplay.partyColours.length;
		var majorityParty:Int = -1;
		var totalPossiblePref:Float = LegislatureDisplay.districtAmount*2;
		var totalPref:Float = 0;
		var seats:Array<Int> = [];
		for(i in 0...partyAmount)
		{
			seats.push(0);
			for(j in 0...LegislatureDisplay.districtAmount)
			{
				if(changeYoursParty[j] == i)
				seats[i]++;
			}
			if(seats[i] >= LegislatureDisplay.districtAmount/2)
			{
				majorityParty = i;
				break;
			}
		}
		for(i in 0...LegislatureDisplay.districtAmount)
		{
			var localPref:Float = preferenceSquares[i].localVictoryCurrent[changeYoursParty[i]];
			totalPref+=localPref;
			if(majorityParty == -1)
			{
				totalPref+= preferenceSquares[i].noMajorityCurrent;
			}
			else
			{
				totalPref+= preferenceSquares[i].nationalVictoryCurrent[majorityParty];
			}
		}
		return totalPref/totalPossiblePref;
	}
}
