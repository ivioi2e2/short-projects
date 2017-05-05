package Others{
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
	
	public class EstadoDebil extends Decorador implements Estado{
		public var estado;
		public var cfantasma;
		public var fantasma;
		public var clase;
		
		public function EstadoDebil(estado) {
			//super(estado)
			this.estado=estado;
			this.fantasma=estado.getvar("fantasma");
		}
		
		public override function manejador(){
			clase=estado.getvar("clase");
			fantasma.gotoAndStop("debil");
			cfantasma.setvar("vel",2.5);
			cfantasma.setDir(cfantasma.getvar("dir"));
		}
		
		public function fantasmaTocado(){
			cfantasma.removeEstadoDebil();
			fantasma.x=int(fantasma.x);
			fantasma.y=int(fantasma.y);
			clase.setvar("puntuacion",clase.getvar("puntuacion")+clase.getvar("bonus"));
			clase.setvar("bonus",clase.getvar("bonus")*2);
			cfantasma.setvar("debilitado",false);
			cfantasma.setvar("estadoactual",cfantasma.getvar("estadovuelta"));
			cfantasma.getvar("comportamiento").setEstado(cfantasma.getvar("estadoactual"));
			cfantasma.getvar("comportamiento").pedirComportamiento();
		}
		
		public function getObjetivo(){return null;}
		
		public override function getEstadoDecorado(){return estado;}
		public function setEstadoDecorado(estado){this.estadodecorado=estado;}
		
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}
	}
	
}
