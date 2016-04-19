package;

import openfl.display.*;
import openfl.Lib;
import openfl.events.*;

class Preference extends Simulation
{
	public static var preferenceGraph:PreferenceGraph;
	public static var findPreferenceAnimation:FindPreferenceAnimation;
	public var currentPriority = 0;
	public static var stg:Stage;
	public function new (s:Stage, calibrationFactor:Float)
	{
		Preference.stg = s;
		super(s, calibrationFactor);
		findPreferenceAnimation = new FindPreferenceAnimation();
		preferenceGraph = new PreferenceGraph(findPreferenceAnimation);
		findPreferenceAnimation.setup(preferenceGraph);
		maxPriority = 0;
	}
	public override function precompute(priority:Int, timeToCompute:Int):Bool
	{
		if(priority<currentPriority)
		return true;
		switch(priority)
		{
			case 0:
			preferenceGraph.setup(s);
			currentPriority++;
			return true;
		}
		return false;
	}
	public override function resize()
	{
		reset();
	}
	public static function reset(?e:Event)
	{
		Preference.stg.removeChild(preferenceGraph.getSprite());
		Preference.stg.removeChild(findPreferenceAnimation.animationSprite);
		findPreferenceAnimation = new FindPreferenceAnimation();
		preferenceGraph = new PreferenceGraph(findPreferenceAnimation);
		findPreferenceAnimation.setup(preferenceGraph);		
		preferenceGraph.setup(Preference.stg);
		Preference.stg.addChild(preferenceGraph.getSprite());
		Preference.stg.addChild(findPreferenceAnimation.animationSprite);
	}
	public override function activate()
	{
		while(currentPriority <= maxPriority)
		{
			while(!precompute(currentPriority, 99999))
			{
			}
		}
		//findPreferenceAnimation.animateBar();
		s.addChild(preferenceGraph.getSprite());
		s.addChild(findPreferenceAnimation.animationSprite);
		//s.addEventListener(Event.ENTER_FRAME, findPreferenceAnimation.animateBar);
	}
	public override function deactivate()
	{
		s.removeChild(preferenceGraph.getSprite());
		s.removeChild(findPreferenceAnimation.animationSprite);
	}
	public override function enterFrame(e:Event)
	{
		
	}
	public override function getSpriteHeight():Float
	{
		if(preferenceGraph.totGraphHeight == null)
		return 0;
		else
		return preferenceGraph.totGraphHeight;
	}
}
