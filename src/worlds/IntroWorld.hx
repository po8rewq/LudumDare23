package worlds;

import com.haxepunk.World;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author adrien
 */
class IntroWorld extends World
{
	static inline var DELAY : Int = 4000;
	static inline var SLIDES : Array<String> = ['screen1.png', 'screen2.png'];
	static inline var TEXTS : Array<Array<Dynamic>> = [ 
		[	{text: '- Faster, faster! ', x: 500, y: 110, size: 16},
			{text: "- Oh boy, I'm late! ", x: 550, y: 150, size: 16},
			{text: '- The Ludum Dare contest is about to begin,'+"\n"+'       and I still have to reach planet Earth! ', x: 100, y: 250, size: 16},
			{text: "- Faster, faster or else I won't have any chance to win this thing! ", x: 100, y: 270, size: 16},
			{text: '- Faster, fast... wait, what is THAT? ', x: 150, y: 300, size: 24} ],
		[	{text: '- Nooooooooooooo .......... ', x: 180, y: 170, size: 24} ]
	];
	
	var _prevTimer : Int;
	
	var _bg : Backdrop;
	var _img : Entity;//Image;
	
	var _currentSlide : Int;
	var _currentText : Int;
	
	/** Texte : PRESS ENTER TO SKIP */
	var _skipText : Entity;
	
	var _textEntity : Entity;
	var _text : Text;
	
	public function new () 
	{
		super();
	}		
	
	public override function begin()
	{
		_currentSlide = -1;
		
		addGraphic(new Image('gfx/bg.png'));
		
		_skipText = new Entity(5, 5);
		_skipText.graphic = new Text('PRESS ENTER TO SKIP', 5, 5);
		add(_skipText);
				
		_bg = new Backdrop("gfx/bgIntro.png", true, false);
		addGraphic(_bg);
		
		Input.define("skip", [Key.ENTER, Key.SPACE]);
		
		nextSlide();
	}
	
	public override function update()
	{
		if (Input.released("skip")) quit();
		
		_bg.x -= 4;
		
		if( _prevTimer > 0 && nme.Lib.getTimer() > _prevTimer + DELAY) nextText();
			//nextSlide();
	
		super.update();
	}
	
	private function nextSlide()
	{
		if(_currentSlide + 1 >= SLIDES.length)
		{
			quit();
		}
		else
		{
			_currentSlide++;
			_currentText = -1;
			
			if(_img == null)
			{
				_img = new Entity(0, 0);
				add(_img);
			}
			_img.graphic = new Image('gfx/'+SLIDES[_currentSlide]);			
			
			nextText();
		}
	}
	
	private function nextText()
	{
		if(_currentText + 1 >= TEXTS[_currentSlide].length)
		{
			nextSlide();
		}
		else
		{		
			_prevTimer = nme.Lib.getTimer();
			
			_currentText++;
			var i : Dynamic = TEXTS[_currentSlide][_currentText];
			
			if(_text != null) _text.clear();
			
			if(_textEntity == null)
			{
				_textEntity = new Entity(i.x , i.y);
				
				_text = new Text(i.text, 0, 0, 0, 0, i.size);
				
				_textEntity.graphic = _text;
				add(_textEntity);
			}
			else
			{
				_textEntity.x = i.x;
				_textEntity.y = i.y;
				
				_text = new Text(i.text, 0, 0, 0, 0, i.size);
				_text.text = i.text;
				
				_textEntity.graphic = _text;
			}
		}
	}
	
	private function quit()
	{
		_currentSlide = -1;
		_currentText = -1;
		HXP.world = new GameWorld();
	}

}
