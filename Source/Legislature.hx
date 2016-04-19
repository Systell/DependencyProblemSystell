package;

import openfl.display.*;
import openfl.Lib;
import openfl.events.*;

class Legislature extends Simulation
{
	public var legislatureDisplay:LegislatureDisplay;
	public var currentPriority = 0;
	public function new (s:Stage, calibrationFactor:Float)
	{
		super(s, calibrationFactor);
		legislatureDisplay = new LegislatureDisplay();
		maxPriority = 0;
	}
	public override function precompute(priority:Int, timeToCompute:Int):Bool
	{
		if(priority<currentPriority)
		return true;
		switch(priority)
		{
			case 0:
			legislatureDisplay.setup(s);
			currentPriority++;
			return true;
		}
		return false;
	}
	public override function resize()
	{
		s.removeChild(legislatureDisplay.legislatureDisplaySprite);
		legislatureDisplay = new LegislatureDisplay();
		legislatureDisplay.setup(s);
		s.addChild(legislatureDisplay.legislatureDisplaySprite);
	}
	public override function activate()
	{
		while(currentPriority <= maxPriority)
		{
			while(!precompute(currentPriority, 99999))
			{
			}
		}
		s.addChild(legislatureDisplay.legislatureDisplaySprite);
	}
	public override function deactivate()
	{
		s.removeChild(legislatureDisplay.legislatureDisplaySprite);
	}
	public override function enterFrame(e:Event)
	{
		
	}
	public override function getSpriteHeight():Float
	{
		if(LegislatureDisplay.totSpriteHeight == null)
		return 0;
		else
		return LegislatureDisplay.totSpriteHeight;
	}
}
