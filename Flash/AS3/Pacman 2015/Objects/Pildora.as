package Objects{
	import HitTest;
	import Others.*;
	import Objects.*;
	import flash.geom.*;
  	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Shape;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.KeyboardEvent;
	import flash.display.StageScaleMode;
	
	public class Pildora extends Punto {

		public function Pildora(objeto,escenario,clase) {
			super(objeto,escenario,clase);
		}
		
		public override function tocado(){
			clase.setvar("puntuacion",clase.getvar("puntuacion")+50);
			clase.getvar("cCPildoras").notificarObservadores();
			objeto.visible=false;
		}

	}
	
}
