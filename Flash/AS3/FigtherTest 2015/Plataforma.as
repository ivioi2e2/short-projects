package{
	import flash.geom.*;
	import HitTest;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
  	import flash.ui.Keyboard;
	import Player.*;
	import Objects.*;
	
	
	public class Plataforma extends MovieClip {
		public function Plataforma() {
			// constructor code
			var player1:Marco2=new Marco2(player1,stage);
			var player2:Marco2=new Marco2(player2,stage);
			var explosion2:Explosion=new Explosion(explosion2,stage);
			var bala1:BalaMetalSlug=new BalaMetalSlug();
			addChild(bala1);
			bala1.x=150;
			bala1.y=150;
			bala1.name="bala1";
			new BalaMarco(bala1,bala1.at,player1,player2);
			
		}
	}
	
}
