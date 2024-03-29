import com.haxepunk.Engine;
import com.haxepunk.HXP;

import worlds.StartScreen;

class Main extends Engine
{

	public static inline var kScreenWidth:Int = 800;
	public static inline var kScreenHeight:Int = 600;
	public static inline var kFrameRate:Int = 30;
	public static inline var kClearColor:Int = 0x333333;

	public function new()
	{
		super(kScreenWidth, kScreenHeight, kFrameRate, false);
	}

	override public function init()
	{
//#if debug
//	#if flash
//		if (flash.system.Capabilities.isDebugger)
//	#end
//		{
//			HXP.console.enable();
//		}
//#end
		HXP.screen.color = kClearColor;
		HXP.screen.scale = 1;
		HXP.world = new StartScreen();
	}

	public static function main()
	{
		new Main();
	}

}
