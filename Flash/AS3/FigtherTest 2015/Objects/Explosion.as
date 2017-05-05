package Objects{
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
	
	public class Explosion {
		public var daño:Boolean=true;
		public var fuerza=25;
		public var pena=70;
		public var activo:Boolean=false;
		public var stage;
		public var objeto;
		
		public function Explosion(objeto,escenario) {
			objeto.gotoAndPlay(1);
			this.objeto=objeto
			stage=escenario;
			escenario.addEventListener("enterFrame",tr);
		}
		function tr(e:Event):void{
			if(activo){
				//if(_root.inicializar){
					//unloadMovie(this);
				//}
				if(HitTest.complexHitTestObject(stage.player1,objeto)&&daño){
				   stage.player1.vida-=fuerza*((100-((stage.player1.defensa)*((100-pena)/100)))/100);
				}
				if(HitTest.complexHitTestObject(stage.player2,objeto)&&daño){
				   stage.player2.vida-=fuerza*((100-((stage.player2.defensa)*((100-pena)/100)))/100);;
				}
				//if(objeto.currentFrame=21) removeMovieClip(objeto);
			}
		}
	}
	
}
/*
onClipEvent(load){
	
}
onClipEvent(enterFrame){
	if(activo){
		if(_root.inicializar){
			unloadMovie(this);
		}
		if(this.at.hitTest(_root.pers1)&&daño){
		   _root.pers1.vida-=fuerza*((100-((_root.pers1.defensa)*((100-pena)/100)))/100);
		}
		if(this.at.hitTest(_root.pers2)&&daño){
		   _root.pers2.vida-=fuerza*((100-((_root.pers2.defensa)*((100-pena)/100)))/100);;
		}
		if(_currentframe==21) unloadMovie(this);
	}
}
*/
