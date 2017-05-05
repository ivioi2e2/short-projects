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
	
	public class EstadoVuelta implements Estado{
		public var cfantasma;
		public var fantasma;
		public var clase;
		
		public var posicioninivel;

		public function EstadoVuelta() {
			// constructor code
		}
		
		public function manejador(){
			posicioninivel=cfantasma.getvar("clase").getvar("posicioninivel");
			fantasma=cfantasma.getvar("character");
			clase=cfantasma.getvar("clase");
			fantasma.gotoAndStop(5);
			cfantasma.setvar("vel",5);
			cfantasma.setDir(cfantasma.getvar("dir"));
			fantasma.addEventListener("enterFrame",eV);
			clase.getvar("cCPildoras").altaObservador(cfantasma);
			clase.getvar("cCReversers").altaObservador(cfantasma);
		}
		function eV(e:Event){
			if(!clase.getvar("pausa")&&cfantasma.getvar("estadoactual")==this){
				if(!cfantasma.getvar("atrapado")&&fantasma.x>=int(posicioninivel[0]+200)&&fantasma.x<=int(posicioninivel[0]+210)&&fantasma.y>=int(posicioninivel[1]+160)&&fantasma.y<=int(posicioninivel[1]+170)){
					cfantasma.setvar("atrapado",true);
					clase.setPosicion(fantasma,clase.getvar("posicionifantasma1"));
					cfantasma.setDir("abajo");
				}
				if(cfantasma.getvar("atrapado")){
					if(fantasma.y==int(posicioninivel[1]+220)){
						if(fantasma.name.charAt(fantasma.name.length-1)<3){
							clase.setPosicion(fantasma,clase.getvar("posicionifantasma2"));
							cfantasma.setvar("estadoactual",cfantasma.getvar("estadobase"));
							cfantasma.getvar("comportamiento").setEstado(cfantasma.getvar("estadoactual"));
							cfantasma.getvar("comportamiento").pedirComportamiento();
							cfantasma.setDir("arriba");
						}
						else if(fantasma.name.charAt(fantasma.name.length-1)==3) cfantasma.setDir("izquierda");
						else cfantasma.setDir("derecha");
					}
					if((fantasma.name.charAt(fantasma.name.length-1)==3&&fantasma.x<=int(posicioninivel[0]+170))||(fantasma.name.charAt(fantasma.name.length-1)==4&&fantasma.x>=int(posicioninivel[0]+235))){
						
						if(fantasma.name.charAt(fantasma.name.length-1)==3){
							cfantasma.setDir("derecha");
							clase.setPosicion(fantasma,clase.getvar("posicionifantasma3"));
						}
						else{
							cfantasma.setDir("izquierda");
							clase.setPosicion(fantasma,clase.getvar("posicionifantasma4"));
						}
						
						cfantasma.setvar("estadoactual",cfantasma.getvar("estadobase"));
						cfantasma.getvar("comportamiento").setEstado(cfantasma.getvar("estadoactual"));
						cfantasma.getvar("comportamiento").pedirComportamiento();
						cfantasma.getvar("estadoactual").setvar("n",8);
					}
				}
			}
		}
		
		public function fantasmaTocado(){}
		
		public function getObjetivo(){return [posicioninivel[0]+205,posicioninivel[1]+165];}
		
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}
	}
	
}
