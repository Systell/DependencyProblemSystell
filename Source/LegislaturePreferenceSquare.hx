package;

import openfl.display.*;
import openfl.geom.*;

class LegislaturePreferenceSquare
{
	public var localVictoryDefault:Array<Float> = [];
	public var nationalVictoryDefault:Array<Float> = [];
	public var noMajorityDefault:Float;
	public var localVictoryCurrent:Array<Float> = [];
	public var nationalVictoryCurrent:Array<Float> = [];
	public var noMajorityCurrent:Float;
	
	public var displaySize:Rectangle;
	public var squareSprite:Sprite;
	
	public var maxValHolder:Int = 0;
	public var totalVal:Float = 0;
	public function new(localVictory:Array<Float>,nationalVictory:Array<Float>,noMajority:Float,rect:Rectangle)
	{
		localVictoryDefault = localVictory.copy();
		nationalVictoryDefault = nationalVictory.copy();
		noMajorityDefault = noMajority;
		localVictoryCurrent = localVictory.copy();
		nationalVictoryCurrent = nationalVictory.copy();
		noMajorityCurrent = noMajority;
		
		displaySize = rect;
		createSprite();
	}
	public function restoreDefault()
	{
		localVictoryCurrent = localVictoryDefault.copy();
		nationalVictoryCurrent = nationalVictoryDefault.copy();
		noMajorityCurrent = noMajorityDefault;
		createSprite();
	}
	public function createSprite()
	{
		squareSprite = new Sprite();
		var maxVal:Float = 0;
		maxValHolder = 0;
		totalVal = 0;
		for(i in 0...localVictoryCurrent.length)
		{
			squareSprite.graphics.beginFill(LegislatureDisplay.partyColours[i]);
			if(localVictoryCurrent[i]>maxVal)
			{
				maxVal = localVictoryCurrent[i];
				maxValHolder = i;
			}
			totalVal += localVictoryCurrent[i];
		}
		var startingX:Float = 0;
		var sortedParties:Array<Int> = [];
		var sortingVals:Array<Float> = localVictoryCurrent.copy();
		for(i in 0...localVictoryCurrent.length)
		{
			var rankNum:Int = 0;
			for(j in 0...localVictoryCurrent.length)
			{
				if(j!=i)
				{
					if(localVictoryCurrent[i]<localVictoryCurrent[j])
					rankNum++;
				}
			}
			sortedParties[i] = rankNum;
		}
		for(i in 0...sortedParties.length)//break tie
		{
			for(j in 0...sortedParties.length)
			{
				if(j != i)
				{
					if(sortedParties[i] == sortedParties[j])
					sortedParties[i]++;
				}
			}
		}
		var oldSorted:Array<Int> = sortedParties.copy();
		for(i in 0...oldSorted.length)
		{
			for(j in 0...oldSorted.length)
			{
				if(i==oldSorted[j])
				sortedParties[i] = j;
			}
		}
		for(i in 0...localVictoryCurrent.length)
		{
			var ratio = localVictoryCurrent[sortedParties[i]]/totalVal;
			squareSprite.graphics.beginFill(LegislatureDisplay.partyColours[sortedParties[i]]);
			squareSprite.graphics.drawRect(startingX,0,ratio*displaySize.width,displaySize.height);
			startingX += ratio*displaySize.width;
		}
		squareSprite.graphics.beginFill(0x000000,0);
		squareSprite.graphics.lineStyle(2,LegislatureDisplay.partyColours[maxValHolder]);
		squareSprite.graphics.drawRect(0,0,displaySize.width,displaySize.height);
	}
}
