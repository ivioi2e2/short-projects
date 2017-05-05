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
	
	public class Punto {
		
		public var objeto;
		public var pacman;
		public var stage;
		public var clase;
		
		public var comido=false;

		public function Punto(objeto,escenario,clase) {
			this.objeto=objeto;
			stage=escenario;
			this.clase=clase
			
			this.objeto.addEventListener("enterFrame",tr);
		}
		
		function tr(e:Event):void{
			if(pacman==null) pacman=clase.getvar("pacman");
			if(HitTest.complexHitTestObject(objeto,pacman.pacman)&&!comido){
				tocado();
				comido=true;
			}
		}
		
		public function tocado(){
			clase.setvar("puntos",clase.getvar("puntos")+1);
			clase.setvar("puntuacion",clase.getvar("puntuacion")+10);
			objeto.visible=false;
			//clase.reproducirWaka();
		}
	}
	
}
