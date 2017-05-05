package Characters{
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
	
	public class Pacman {
		
		public var character;
		public var nivel;
		public var stage;
		public var clase;
		public var posicioninivel;
		public var buclewaka=false;
		public var canalmusica;
		public var musica;
		public var tbucleS=100;
		public var tiempoparado=0;
		public var moviendose=false;
		public var muerto=false;
		
		public var dir;
		public var ndir;
		public var pdir;
		public var bloqde;
		public var bloqiz;
		public var bloqar;
		public var bloqab;
		
		public var arriba:int=87;
		public var izquierda:int=65;
		public var derecha:int=68;
		public var abajo:int=83;
		
		public var tderecha:Boolean;
		public var tizquierda:Boolean;
		public var tarriba:Boolean;
		public var tabajo:Boolean;
		
		public static var COME_PILDORA;
		
		public function Pacman(objeto,escenario,clase) {
			character=objeto;
			stage=escenario;
			this.clase=clase
			dir="izquierda";
			posicioninivel=clase.getvar("posicioninivel");
			nivel=clase.getvar("nivel");
			musica=new PacmanWakaSound();
			musica.addEventListener(Event.COMPLETE, musicaopComplete);
			buclewaka=true;
			canalmusica=musica;
			
			character.addEventListener("enterFrame",tr);
			escenario.addEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
		}
		
		function tr(e:Event):void{
			if(!clase.getvar("pausa")){
				if(buclewaka&&moviendose){					
					if(tbucleS>24*((musica.length)/1000)){
						//canalmusica=musica.play(tiempoparado);
						//tbucleS=0;
					}else tbucleS++;
				}
				else if(!moviendose){
					//tbucleS=100;
				}
				//if(canalmusica.position>=musica.length) tiempoparado=60;
				/*if(moviendose&&(canalmusica.position==undefined||canalmusica.position>=musica.length||tiempoparado!=0)){
					//tiempoparado=0;
					canalmusica=musica.play(tiempoparado);
					tiempoparado=0;
					//tiempoparado=canalmusica.position;
					//if(tiempoparado>=musica.length)tiempoparado=0;
				}
				else if(!moviendose){
					tiempoparado=canalmusica.position;
					canalmusica.stop;
				}*/

				//Bloqueos
				if(HitTest.complexHitTestObject(character.limde,nivel))bloqde=true;
				else bloqde=false;
				if(HitTest.complexHitTestObject(character.limiz,nivel))bloqiz=true;
				else bloqiz=false;
				if(HitTest.complexHitTestObject(character.limar,nivel))bloqar=true;
				else bloqar=false;
				if(HitTest.complexHitTestObject(character.limab,nivel))bloqab=true;
				else bloqab=false;
				
				//Reaccion a teclas
				if(tderecha){
					ndir="derecha";
					tderecha=false;
				}
				if(tizquierda){
					ndir="izquierda";
					tizquierda=false;
				}
				if(tarriba){
					ndir="arriba";
					tarriba=false;
				}
				if(tabajo){
					ndir="abajo";
					tabajo=false;
				}
				
				//Movimiento
				if(dir=="derecha"&&!bloqde&&!muerto){
					character.pacman.rotation=180;
					character.x+=5;
					moviendose=true;
				}
				else if(dir=="izquierda"&&!bloqiz&&!muerto){
					character.pacman.rotation=0;
					character.x-=5;
					moviendose=true;
				}
				else if(dir=="arriba"&&!bloqar&&!muerto){
					character.pacman.rotation=90;
					character.y-=5;
					moviendose=true;
				}
				else if(dir=="abajo"&&!bloqab&&!muerto){
					character.pacman.rotation=270;
					character.y+=5;
					moviendose=true;
				}
				else if(!muerto){
					character.pacman.gotoAndPlay("normal");
					moviendose=false;
					
					//trace(canalmusica.position+" "+musica.length);
					//if(canalmusica.position>=musica.length-1) tiempoparado=150;
					//else 
					//tiempoparado=canalmusica.position;
					//trace(canalmusica.position+" "+musica.length);
					//canalmusica.stop();
				}
				
				//Correccion de bloqueo
				if((bloqiz&&bloqde&&(dir=="izquierda"||dir=="derecha"))||(bloqar&&bloqab&&(dir=="arriba"||dir=="abajo"))){
					ndir="";
					dir=pdir;
				}
				//Cambio de direccion
				if(ndir=="derecha"&&!bloqde&&dir!="derecha"){
					pdir=dir;
					dir=ndir;
					character.pacman.gotoAndPlay(0);
				}
				else if(ndir=="izquierda"&&!bloqiz&&dir!="izquierda"){
					pdir=dir;
					dir=ndir;
					character.pacman.gotoAndPlay(0);
				}
				else if(ndir=="arriba"&&!bloqar&&dir!="arriba"){
					pdir=dir;
					dir=ndir;
					character.pacman.gotoAndPlay(0);
				}
				else if(ndir=="abajo"&&!bloqab&&dir!="abajo"){
					pdir=dir;
					dir=ndir;
					character.pacman.gotoAndPlay(0);
				}
				
				//Portal
				if(character.x<=posicioninivel[0]-20)character.x=posicioninivel[0]+420;
				else if(character.x>=posicioninivel[0]+425)character.x=posicioninivel[0]-15;
			}
			else if(!muerto) character.pacman.gotoAndPlay("normal");
		}
		
		public function morir(){
			muerto=true;
			character.gotoAndStop(2);
			//character.pacman.gotoAndPlay(0);
		}
		
		public function reiniciar(){
			muerto=false;
			character.gotoAndStop(1);
			dir="izquierda";
			ndir="";
		}
		
		public function eliminar(){
			character.removeEventListener("enterFrame",tr);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
			clase.setvar("pacman",null);
			clase.getvar("clasep").removeChild(character);
		}
		
		function KeyDown(event:KeyboardEvent):void {
			if((event.keyCode==derecha||event.keyCode==39)&&!clase.getvar("pausa"))tderecha=true;
			if((event.keyCode==izquierda||event.keyCode==37)&&!clase.getvar("pausa"))tizquierda=true;
			if((event.keyCode==arriba||event.keyCode==38)&&!clase.getvar("pausa"))tarriba=true;
			if((event.keyCode==abajo||event.keyCode==40)&&!clase.getvar("pausa"))tabajo=true;
		}
		
		function musicaopComplete(evt:Event):void{}
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}
		/*function KeyUp(event:KeyboardEvent):void {
			if(event.keyCode==derecha)tderecha=false;
			if(event.keyCode==izquierda)tizquierda=true;
			if(event.keyCode==arriba)tarriba=true;
			if(event.keyCode==abajo)tabajo=true;
		}*/
	}
	
}
