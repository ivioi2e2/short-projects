package{
	import HitTest;
	import Others.*;
	import Objects.*;
	import Characters.*;
	import flash.geom.*;
  	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Shape;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.KeyboardEvent;
	import flash.display.StageScaleMode;
	import flash.display.IBitmapDrawable;
	
	public dynamic class Main extends MovieClip {
		
		public var posicioni=[525,382];				//Posicion inicial
		
		public var cmenuP;							//Clase Menu Principal			
		public var menuP;
		public var juego;
		
		public function Main() {
			crear("menuP",this);
			setPosicion(menuP,posicioni);
			cmenuP=new MenuPrincipal(this.menuP,stage,this);
			
			addEventListener("enterFrame",tr);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
		}
		
		public function crear(tipo,emisor){
			var objeto:Fabrica=null;
			if(tipo=="menuP"){
				objeto=new FabricaObject(tipo);
				this.addChild(objeto.getvar("objeto"));
				menuP=objeto.getvar("objeto");
				
			}
		}
		
		public function crearJuego(tipo){
			if(tipo=="pacman"){
				juego=new JuegoPacman(this,stage);
			}
		}
		
		public function tr(e:Event):void{
			
		}
		function KeyDown(event:KeyboardEvent):void {
			
		}
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}
		public function setPosicion(objeto,posicion){
			objeto.x=posicion[0];
			objeto.y=posicion[1];
		}
	}
	
}
