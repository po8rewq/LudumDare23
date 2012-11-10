package entities;

import com.haxepunk.Entity;

import flash.display.BitmapData;

import com.haxepunk.graphics.Emitter;
import com.haxepunk.HXP;

/**
 * ...
 * @author adrien
 */
class EmitterEntity extends Entity 
{
	var _emitter : Emitter;
	var _particlesNumber : Int;
		
	public function new (?pParticlesNumber: Int = 30) 
	{
		super();		
		
		_particlesNumber = pParticlesNumber;
		
		var source : BitmapData = nme.Assets.getBitmapData('gfx/explosion.png');
		
		_emitter = new Emitter(source, 32, 32);
		_emitter.newType('explode',[0, 1, 2]);
		_emitter.setMotion('explode', 0, 0, 0.2, 360, 20, 1);
		
		this.graphic = _emitter;
	}		
	
	public function explode(x:Float, y:Float):Void 
	{
	  	for(i in 0...30)
	    	_emitter.emit('explode',x,y);
	}
	
//	override public function update():Void 
//	{
//		var random_x:Float = (Math.random() * (HXP.width - 10)) + 5;
//	    var random_y:Float = (Math.random() * (HXP.height - 10)) + 5;
//	    _explode(random_x, random_y);
//	}


}
