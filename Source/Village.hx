package;

import openfl.display.*;
import openfl.Lib;
import openfl.events.*;

class Village extends Simulation
{
	//public var villageSprite:Sprite;
	public static var villageGraph:VillageGraph;
	public static var stg:Stage;
	//public var villageAnimation:VillageAnimation;
	public function new (stage:Stage, calibrationFactor:Float)
	{
		Village.stg = stage;
		super(Village.stg, calibrationFactor);
		VillageAnimation.setup(Village.stg);
		villageGraph = new VillageGraph(Village.stg);
		Village.stg.addChild(VillageAnimation.squaresSprite);
		Village.stg.addChild(villageGraph.getSprite());
		//var exampleSprite = new Sprite();
		//exampleSprite.graphics.beginFill(0x8888AA);
		//exampleSprite.graphics.drawRect(0,0,200,200);
		maxPriority = 0;
		
		//var spr = new Sprite();
			//spr.graphics.beginFill(0x000000);
			//spr.graphics.drawRect(38,238, 9.5, 9.6);
			//s.addChild(spr);
	}
	public static function reset(?e:Event)
	{
		Village.stg.removeChild(villageGraph.getSprite());
		Village.stg.removeChild(VillageAnimation.squaresSprite);
		VillageAnimation.setup(Village.stg);
		Village.stg.addChild(VillageAnimation.squaresSprite);
		villageGraph = new VillageGraph(Village.stg);
		Village.stg.addChild(villageGraph.getSprite());
	}
	public override function precompute(priority:Int, timeToCompute:Int):Bool
	{
		return true;
	}
	public override function resize()
	{
		reset();
	}
	public override function activate()
	{
		//s.addChild(villageSprite);
		Village.stg.addChild(VillageAnimation.squaresSprite);
		Village.stg.addChild(villageGraph.getSprite());
	}
	public override function deactivate()
	{
		//s.removeChild(villageSprite);
		//s.removeChild(VillageAnimation.squaresSprite);
		reset();
		s.removeChild(VillageAnimation.squaresSprite);
		s.removeChild(villageGraph.getSprite());
	}
	public override function enterFrame(e:Event)
	{
		//if(VillageAnimation.isMoving)
		//{
			//VillageAnimation.move();
			//if(!VillageAnimation.isMoving)
			//{
				//villageGraph.transfered();
			//}
		//}
	}
	public static function barAnimation(e:Event)
	{
		if(VillageAnimation.isMoving)
		{
			VillageAnimation.move();
			if(!VillageAnimation.isMoving)
			{
				villageGraph.transfered();
			}
		}
	}
	public override function getSpriteHeight():Float
	{
		if(villageGraph.totGraphHeight == null)
		return 0;
		else
		return villageGraph.totGraphHeight;
	}
}
