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
	
	public class Fantasma implements Observer{
		
		public var character;
		public var pacman;
		public var objetivo;
		public var nivel;
		public var stage;
		public var clase;
		
		public var comportamiento=new Comportamiento(this);
		public var estadoactual;
		public var estadobase=new EstadoBase();
		public var estadodebil;
		public var estadovuelta=new EstadoVuelta();
		
		public var n=0;
		public var dir;
		public var ndir;
		public var pdir;
		public var prioridades=[,,,];
		public var evaluar=false;
		public var bloqde;
		public var bloqiz;
		public var bloqar;
		public var bloqab;
		public var vel=5;
		public var velx=0;
		public var vely=0;
		public var teval=0;
		public var opciones;
		public var nopciones=0;
		public var posicioninivel;
		public var debilitado=false;
		public var atrapado=false;

		public function Fantasma(objeto,escenario,clase) {
			character=objeto;
			stage=escenario;
			this.clase=clase
			pacman=clase.getvar("pacman");
			nivel=clase.getvar("nivel");
			posicioninivel=clase.getvar("posicioninivel");
			setDir("arriba");
			
			if(character.name.charAt(character.name.length-1)==1)setDir("izquierda");
			
			estadoactual=estadobase;
			comportamiento.setEstado(estadoactual);
			comportamiento.pedirComportamiento();
			
			character.addEventListener("enterFrame",tr);
		}
		
		function tr(e:Event):void{
			if(!clase.getvar("pausa")){
				
				//Moverse
				//Ralentizacion al entrar en tunel
				if(character.y==posicioninivel[1]+210&&(character.x<posicioninivel[0]+75||character.x>posicioninivel[0]+330)&&dir=="derecha"&&!debilitado) character.x+=velx-2.5;
				else if(character.y==posicioninivel[1]+210&&(character.x<posicioninivel[0]+75||character.x>posicioninivel[0]+330)&&dir=="izquierda"&&!debilitado) character.x+=velx+2.5;
				else character.x+=velx;
				character.y-=vely;
				
				//Ubicacion de punto
				/*clase.getvar("puntoref"+character.name.charAt(character.name.length-1)).width=10;
				clase.getvar("puntoref"+character.name.charAt(character.name.length-1)).height=10;
				clase.getvar("puntoref"+character.name.charAt(character.name.length-1)).gotoAndStop((int(character.name.charAt(character.name.length-1))+int(1)));
				clase.getvar("puntoref"+character.name.charAt(character.name.length-1)).x=objetivo[0];
				clase.getvar("puntoref"+character.name.charAt(character.name.length-1)).y=objetivo[1];*/
				
				//Fuera de la celda
				if(!atrapado){
					//Portal
					if(character.x<=posicioninivel[0]-20)character.x=posicioninivel[0]+420;
					else if(character.x>=posicioninivel[0]+425)character.x=posicioninivel[0]-15;
					
					//Colisiones
					if(HitTest.complexHitTestObject(character.limde,nivel)){
						bloqde=true;
						if(dir=="derecha"&&teval<=0&&character.x-int(character.x)==0&&character.y-int(character.y)==0) evaluar=true;
					}
					else{
						bloqde=false;
						if(((dir=="arriba"&&!HitTest.complexHitTestObject(character.limar,nivel))||(dir=="abajo"&&!HitTest.complexHitTestObject(character.limab,nivel)))
						   &&teval<=0&&!evaluar&&character.x-int(character.x)==0&&character.y-int(character.y)==0) evaluar=true;
					}
					if(HitTest.complexHitTestObject(character.limiz,nivel)){
						bloqiz=true;
						if(dir=="izquierda"&&teval<=0&&character.x-int(character.x)==0&&character.y-int(character.y)==0) evaluar=true;
					} 
					else{
						bloqiz=false;
						if(((dir=="arriba"&&!HitTest.complexHitTestObject(character.limar,nivel))||(dir=="abajo"&&!HitTest.complexHitTestObject(character.limab,nivel)))
						   &&teval<=0&&!evaluar&&(character.x-int(character.x))==0&&(character.y-int(character.y))==0) evaluar=true;
					}
					if(HitTest.complexHitTestObject(character.limar,nivel)){
						bloqar=true;
						if(dir=="arriba"&&teval<=0&&(character.x-int(character.x))==0&&(character.y-int(character.y))==0) evaluar=true;;
					}
					else{
						bloqar=false;
						if(((dir=="derecha"&&!HitTest.complexHitTestObject(character.limde,nivel))||(dir=="izquierda"&&!HitTest.complexHitTestObject(character.limiz,nivel)))
						   &&teval<=0&&!evaluar&&(character.x-int(character.x))==0&&(character.y-int(character.y))==0) evaluar=true
					}
					if(HitTest.complexHitTestObject(character.limab,nivel)){
						bloqab=true;
						if(dir=="abajo"&&teval<=0&&(character.x-int(character.x))==0&&(character.y-int(character.y))==0) evaluar=true;
					}
					else{
						bloqab=false;
						if(((dir=="derecha"&&!HitTest.complexHitTestObject(character.limde,nivel))||(dir=="izquierda"&&!HitTest.complexHitTestObject(character.limiz,nivel)))
						   &&teval<=0&&!evaluar&&(character.x-int(character.x))==0&&(character.y-int(character.y))==0) evaluar=true;
					}
					
					//Colision con Pacman
					if(HitTest.complexHitTestObject(character.centro,pacman.centro)&&!clase.getvar("pausa")){
						estadoactual.fantasmaTocado();
					}
					
					//Eleccion direccion
					if(evaluar){
						ndir="";
						teval=5;
						opciones=[];
						if(!bloqde&&dir!="izquierda"){
							nopciones++;
							opciones=addArrayVar(opciones,"derecha");
						}
						if(!bloqiz&&dir!="derecha"){ 
							nopciones++;
							opciones=addArrayVar(opciones,"izquierda");
						}
						if(!bloqar&&dir!="abajo"){ 
							nopciones++;
							opciones=addArrayVar(opciones,"arriba");
						}
						if(!bloqab&&dir!="arriba"){ 
							nopciones++;
							opciones=addArrayVar(opciones,"abajo");
						}
						objetivo=estadoactual.getObjetivo();
						if(!debilitado&&clase.getvar("tiempo")>5&&objetivo!=null){
							if(Math.abs(objetivo[0]-character.x)>=Math.abs(objetivo[1]-character.y)){
								if(objetivo[0]-character.x<0){
									prioridades[0]="izquierda";
									prioridades[3]="derecha";
								}
								else{
									prioridades[0]="derecha";
									prioridades[3]="izquierda";
								}
								if(objetivo[1]-character.y<0){
									prioridades[1]="arriba";
									prioridades[2]="abajo";
								}
								else{
									prioridades[1]="abajo";
									prioridades[2]="arriba";
								}
							}
							else{
								if(objetivo[0]-character.x<0){
									prioridades[1]="izquierda";
									prioridades[2]="derecha";
								}
								else{
									prioridades[1]="derecha";
									prioridades[2]="izquierda";
								}
								if(objetivo[1]-character.y<0){
									prioridades[0]="arriba";
									prioridades[3]="abajo";
								}
								else{
									prioridades[0]="abajo";
									prioridades[3]="arriba";
								}
							}
							ndir=elegirndir(opciones,prioridades,nopciones);
						}
						else{
							var azar=int(Math.random()*(nopciones));
							if(azar==nopciones)azar-=1;
							ndir=opciones[azar]
						}
						
						pdir=dir;
						setDir(ndir);
						
						evaluar=false;
						nopciones=0;
					}
					else if(!evaluar&&teval>0) teval--;
				}
			}
		}
		
		public function elegirndir(opciones,prioridades,nopciones){
			var j=0;
			var aux="";
			for(var i=0;i<17&&j<4;i++){
				if(opciones[i]==prioridades[j]){
					aux=prioridades[j];
					j=5;
				}
				if(i==nopciones-1){
					i=-1;
					j++;
				}
			}
			return aux;
		}
		
		public function reiniciar(){
			velx=0;
			vely=0;
			setDir("arriba");
			debilitado=false;
			if(character.name.charAt(character.name.length-1)==1)setDir("izquierda");
			if(character.name.charAt(character.name.length-1)>1)atrapado=true;
			estadoactual=estadobase;
			comportamiento.setEstado(estadoactual);
			comportamiento.pedirComportamiento();
			evaluar=false;
			pdir=undefined;
			n=0;
		}
		
		public function eliminar(){
			character.removeEventListener("enterFrame",tr);
			clase.getvar("clasep").removeChild(character);
		}
		
		public function actualizar(){
			if(debilitado&&clase.getvar("tiempod")>=7){
				removeEstadoDebil();
				debilitado=false;
			}
			else if(!debilitado&&clase.getvar("tiempod")<7){
				addEstadoDebil();
				debilitado=true;
				reverseDir();
			}
		}
		
		public function setDir(dirs){
			if(dirs=="arriba"){
				dir="arriba";
				velx=0;
				vely=vel;
				if(character.currentFrame<5) character.ojos.gotoAndStop("arriba");
			}else if(dirs=="abajo"){
				dir="abajo";
				velx=0;
				vely=-vel;
				if(character.currentFrame<5) character.ojos.gotoAndStop("abajo");
			}else if(dirs=="derecha"){
				dir="derecha";
				velx=vel;
				vely=0;
				if(character.currentFrame<5) character.ojos.gotoAndStop("derecha");
			}else if(dirs=="izquierda"){
				dir="izquierda";
				velx=-vel;
				vely=0;
				if(character.currentFrame<5) character.ojos.gotoAndStop("izquierda");
			}
		}
		
		public function reverseDir(){
			if(!atrapado){
				if(dir=="derecha"&&!bloqiz) setDir("izquierda");
				else if(dir=="izquierda"&&!bloqde) setDir("derecha");
				else if(dir=="arriba"&&!bloqab) setDir("abajo");
				else if(dir=="abajo"&&!bloqar) setDir("arriba");
			}
		}
		
		public function addEstadoDebil(){
			estadoactual=new EstadoDebil(estadoactual);
			comportamiento.setEstado(estadoactual);
			comportamiento.pedirComportamiento();
		}
		
		public function removeEstadoDebil(){
			estadoactual=estadoactual.getEstadoDecorado();
			comportamiento.setEstado(estadoactual);
			comportamiento.pedirComportamiento();
		}
		
		public function addArrayVar(array,variable){
			var varaux:Array=new Array(array.length+1);
			for(var i=0;i<=array.length;i++){
				if(i!=array.length) varaux[i]=array[i];
				else varaux[i]=variable;
			}
			return varaux;
		}
		
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}
	}
}
