package worlds;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import com.haxepunk.World;
import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author adrien
 */
class StartScreen extends World
{
	
	public function new () 
	{
		super();		
	}
	
	public override function begin()
	{
		Input.define("start", [Key.ENTER]);
	
		addGraphic( Image.createRect(HXP.width, HXP.height, 0x000000) );		
	
		var title : Text = new Text("PIXEL WORLD", 0, 50, 0, 0, 40); //\na game by Adrien Fischer\n\nLudumDare48");
		title.x = (HXP.width - title.width) / 2;
		addGraphic(title);
		
		var ld : Text = new Text("Ludum Dare 23 - 10 Year Anniversary!", 0, 180, 0, 0, 24);
		ld.x = (HXP.width - ld.width) / 2;
		addGraphic(ld);
		
		var ld2 : Text = new Text("April 20th-23rd, 2012", 0, 210, 0, 0, 24);
		ld2.x = (HXP.width - ld2.width) / 2;
		addGraphic(ld2);
		
		var by : Text = new Text("A game by Adrien Fischer",0, 370, 0, 0, 24);
		by.x = (HXP.width - by.width) / 2;
		addGraphic(by);
		
		var site : Text = new Text("revolugame.com", 0, 400, 0, 0, 24);
		site.x = (HXP.width - site.width) / 2;
		addGraphic(site);
		
		var enter : Text = new Text("PRESS ENTER WHEN YOU ARE READY!", 0, 530, 0, 0, 24);
		enter.x = (HXP.width - enter.width) / 2;
		addGraphic(enter);
	}
	
	public override function update()
	{
		if(Input.released("start")) 
			HXP.world = new IntroWorld();
		super.update();
	}

}
