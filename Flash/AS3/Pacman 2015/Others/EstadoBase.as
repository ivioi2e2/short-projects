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
	
	public class EstadoBase implements Estado{
		public var cfantasma;
		public var fantasma;
		public var pacman;
		public var nivel;
		public var clase;
		
		public var n=0;
		public var objetivo;
		public var iniciado=false;
		public var posicioninivel;
		
		public function EstadoBase() {
			
		}
		
		public function manejador(){
			if(iniciado==false){
				fantasma=cfantasma.getvar("character");
				pacman=cfantasma.getvar("pacman");
				nivel=cfantasma.getvar("nivel");
				clase=cfantasma.getvar("clase");
				posicioninivel=cfantasma.getvar("posicioninivel");
				iniciado=true;
			}
			n=0;
			cfantasma.setvar("vel",5);
			cfantasma.setDir(cfantasma.getvar("dir"));
			if(fantasma.x>=posicioninivel[0]+170&&fantasma.x<=posicioninivel[0]+235&&fantasma.y<=posicioninivel[1]+230&&fantasma.y>=posicioninivel[1]+175) cfantasma.setvar("atrapado",true);
			fantasma.gotoAndStop(fantasma.name.charAt(fantasma.name.length-1));
			clase.getvar("cCPildoras").registrarObservador(cfantasma);
			clase.getvar("cCReversers").registrarObservador(cfantasma);
			fantasma.addEventListener("enterFrame",eC);
		}
		
		function eC(e:Event){
			if(!clase.getvar("pausa")&&cfantasma.getvar("atrapado")&&(cfantasma.getvar("estadoactual")==this||cfantasma.getvar("debilitado"))){
				if(fantasma.name.charAt(fantasma.name.length-1)>2){
					if(fantasma.y<=posicioninivel[1]+200&&n<8*(fantasma.name.charAt(fantasma.name.length-1)-2)){
						cfantasma.setDir("abajo");
						n++;
					}
					else if (fantasma.y>=posicioninivel[1]+220&&n<8*(fantasma.name.charAt(fantasma.name.length-1)-2)){
						cfantasma.setDir("arriba");
					}
					else if(fantasma.y==posicioninivel[1]+220&&n==8*(fantasma.name.charAt(fantasma.name.length-1)-2)){
						if(fantasma.name.charAt(fantasma.name.length-1)==3)cfantasma.setDir("derecha");
						else cfantasma.setDir("izquierda");
						n++;
					}
				}
				if(fantasma.x>=posicioninivel[0]+205&&fantasma.x<=posicioninivel[0]+205){
					fantasma.x=posicioninivel[0]+205;
					cfantasma.setDir("arriba");
				}
				if(fantasma.y<=posicioninivel[1]+170){
					if(fantasma.name.charAt(fantasma.name.length-1)==3)fantasma.x=posicioninivel[0]+200;
					clase.setPosicion(fantasma,clase.getvar("posicionifantasma1"));
					if(Math.random()>0.5) cfantasma.setDir("derecha");
					else cfantasma.setDir("izquierda");
					cfantasma.setvar("atrapado",false);
				}
			}
		}
		
		public function fantasmaTocado(){clase.pacmanMuerto();}
		
		public function getObjetivo(){
			if(fantasma.name.charAt(fantasma.name.length-1)==1/*&&!bloqobjetivo*/){
				objetivo=[pacman.x,pacman.y];
			}
			else if(fantasma.name.charAt(fantasma.name.length-1)==2/*&&!bloqobjetivo*/){
				if(pacman.pacman.rotation==0) objetivo=[pacman.x-60,pacman.y];
				else if(pacman.pacman.rotation==90) objetivo=[pacman.x,pacman.y-60];
				else if(pacman.pacman.rotation==180) objetivo=[pacman.x+60,pacman.y];
				else objetivo=[pacman.x,pacman.y+60];
			}
			else if(fantasma.name.charAt(fantasma.name.length-1)==3/*&&!bloqobjetivo*/){
				if(pacman.pacman.rotation==0) objetivo=[2*(pacman.x-30)-clase.getvar("fantasma1").x,2*pacman.y-clase.getvar("fantasma1").y];
				else if(pacman.pacman.rotation==90) objetivo=[2*pacman.x-clase.getvar("fantasma1").x,2*(pacman.y-30)-clase.getvar("fantasma1").y];
				else if(pacman.pacman.rotation==180) objetivo=[2*(pacman.x+30)-clase.getvar("fantasma1").x,2*pacman.y-clase.getvar("fantasma1").y];
				else objetivo=[2*pacman.x-clase.getvar("fantasma1").x,2*(pacman.y+30)-clase.getvar("fantasma1").y];
			}
			else if(fantasma.name.charAt(fantasma.name.length-1)==4/*&&!bloqobjetivo*/){
				var dpacman=Math.sqrt(Math.pow(pacman.x-fantasma.x,2)+Math.pow(pacman.y-fantasma.y,2));
				if(dpacman>120){
					objetivo=[pacman.x,pacman.y]
				}
				else{
					objetivo=[nivel.x,nivel.y+nivel.height];
				}
			}
			return objetivo;
		}
		
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}
	}
	
}
