package;

import openfl.display.*;
import openfl.Lib;
import openfl.events.*;

class CombinedVote extends Simulation
{
	public static var combinedVoteGraph:CombinedVoteGraph;
	public static var findCombinedVoteAnimation:FindCombinedVoteAnimation;
	public var currentPriority = 0;
	public static var stg:Stage;
	public function new (s:Stage, calibrationFactor:Float)
	{
		CombinedVote.stg = s;
		super(s, calibrationFactor);
		findCombinedVoteAnimation = new FindCombinedVoteAnimation();
		combinedVoteGraph = new CombinedVoteGraph(findCombinedVoteAnimation);
		findCombinedVoteAnimation.setup(combinedVoteGraph);
		maxPriority = 0;
	}
	public override function precompute(priority:Int, timeToCompute:Int):Bool
	{
		if(priority<currentPriority)
		return true;
		switch(priority)
		{
			case 0:
			combinedVoteGraph.setup(s);
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
		CombinedVote.stg.removeChild(combinedVoteGraph.getSprite());
		CombinedVote.stg.removeChild(findCombinedVoteAnimation.animationSprite);
		findCombinedVoteAnimation = new FindCombinedVoteAnimation();
		combinedVoteGraph = new CombinedVoteGraph(findCombinedVoteAnimation);
		findCombinedVoteAnimation.setup(combinedVoteGraph);		
		combinedVoteGraph.setup(CombinedVote.stg);
		CombinedVote.stg.addChild(combinedVoteGraph.getSprite());
		CombinedVote.stg.addChild(findCombinedVoteAnimation.animationSprite);
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
		s.addChild(combinedVoteGraph.getSprite());
		s.addChild(findCombinedVoteAnimation.animationSprite);
		//s.addEventListener(Event.ENTER_FRAME, findPreferenceAnimation.animateBar);
	}
	public override function deactivate()
	{
		s.removeChild(combinedVoteGraph.getSprite());
		s.removeChild(findCombinedVoteAnimation.animationSprite);
	}
	public override function enterFrame(e:Event)
	{
		
	}
	public override function getSpriteHeight():Float
	{
		if(combinedVoteGraph.totGraphHeight == null)
		return 0;
		else
		return combinedVoteGraph.totGraphHeight;
	}
}
