package Others{
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
	
	public dynamic class JuegoPacman {
		
		public var waka=false;
		public var buclewaka=false;
		public var pausa=false;		
		public var iniciado=false;
		public var musica;
		public var musicawaka;
		public var canalwaka;
		public var canalmusica;
		public var canalmusicabucle;
		public var tinicio=0;
		public var tbucleS=0;
		public var posicioni=[512,382];	//Posicion inicial
		public var posicioninivel;		//Posicion inicial nivel
		public var posicionipacman;		//Posicion inicial pacman
		public var posicionifantasma1;	//Posicion inicial fantasma1
		public var posicionifantasma2;	//Posicion inicial fantasma2
		public var posicionifantasma3;	//Posicion inicial fantasma3
		public var posicionifantasma4;	//Posicion inicial fantasma4
		
		public var clasep;
		public var escenario;
		public var cpacman; 						//Clase pacman
		public var cfantasma1;						//Clases fantasma
		public var cfantasma2; 						
		public var cfantasma3; 						
		public var cfantasma4; 		
		public var cCPildoras;
		public var cCReversers;
		
		public var tt=0;
		public var td=0;
		public var tw=3;
		public var mw=0;
		public var tiempo=0;
		public var tiempod=0;	
		public var tiempor=5;	
		public var pacman;
		public var fantasma1;
		public var fantasma2;
		public var fantasma3;
		public var fantasma4;
		public var puntoref1;
		public var puntoref2;
		public var puntoref3;
		public var puntoref4;
		public var vidasO;
		public var puntuacionO;
		public var pausaO;
		public var nivel;
		public var debilitados=false;
		public var puntuacionvidas=10000;
		public var bonus=200;
		public var puntos=0;
		public var puntuacion=0;
		public var vidas=3;
		
		public var puntosc1=[[1,1,1,1,1,1,1,1,1,1,1,1, , ,1,1,1,1,1,1,1,1,1,1,1,1],
						     [1, , , , ,1, , , , , ,1, , ,1, , , , , ,1, , , , ,1],
						     [2, , , , ,1, , , , , ,1, , ,1, , , , , ,1, , , , ,2],
						     [1, , , , ,1, , , , , ,1, , ,1, , , , , ,1, , , , ,1],
						     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
						     [1, , , , ,1, , ,1, , , , , , , , ,1, , ,1, , , , ,1],
						     [1, , , , ,1, , ,1, , , , , , , , ,1, , ,1, , , , ,1],
						     [1,1,1,1,1,1, , ,1,1,1,1, , ,1,1,1,1, , ,1,1,1,1,1,1],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [ , , , , ,1, , , , , , , , , , , , , , ,1, , , , , ],
							 [1,1,1,1,1,1,1,1,1,1,1,1, , ,1,1,1,1,1,1,1,1,1,1,1,1],
							 [1, , , , ,1, , , , , ,1, , ,1, , , , , ,1, , , , ,1],
							 [1, , , , ,1, , , , , ,1, , ,1, , , , , ,1, , , , ,1],
							 [2,1,1, , ,1,1,1,1,1,1,1, , ,1,1,1,1,1,1,1, , ,1,1,2],
							 [ , ,1, , ,1, , ,1, , , , , , , , ,1, , ,1, , ,1, , ],
							 [ , ,1, , ,1, , ,1, , , , , , , , ,1, , ,1, , ,1, , ],
							 [1,1,1,1,1,1, , ,1,1,1,1, , ,1,1,1,1, , ,1,1,1,1,1,1],
							 [1, , , , , , , , , , ,1, , ,1, , , , , , , , , , ,1],
							 [1, , , , , , , , , , ,1, , ,1, , , , , , , , , , ,1],
							 [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];

		public function JuegoPacman(clasep,escenario) {
			this.clasep=clasep;
			this.escenario=escenario;
			pausa=true;
			
			cCReversers=new ControlReversers();
			cCPildoras=new ControlPildoras();
			cCPildoras.registrarObservador(this);
			
			
			crear("nivel1",this);
			posicioninivel=[posicioni[0]-nivel.width/2+30,posicioni[1]-nivel.height/2+30];
			posicionipacman=[posicioninivel[0]+205,posicioninivel[1]+345];
			posicionifantasma1=[posicioninivel[0]+205,posicioninivel[1]+165];
			posicionifantasma2=[posicioninivel[0]+205,posicioninivel[1]+220];
			posicionifantasma3=[posicioninivel[0]+170,posicioninivel[1]+220];
			posicionifantasma4=[posicioninivel[0]+235,posicioninivel[1]+220];
			setPosicion(nivel,posicioninivel);
			crear("puntos",this);
			crear("pacman",this);
			setPosicion(pacman,posicionipacman);  
			cpacman=new Pacman(this.pacman,escenario,this);
			crear("fantasma",this);
			setPosicion(fantasma1,posicionifantasma1);
			fantasma1.name="fantasma1";
			cfantasma1=new Fantasma(this.fantasma1,escenario,this);
			crear("fantasma",this);
			setPosicion(fantasma2,posicionifantasma2);
			fantasma2.name="fantasma2";
			cfantasma2=new Fantasma(this.fantasma2,escenario,this);
			crear("fantasma",this);
			setPosicion(fantasma3,posicionifantasma3);
			fantasma3.name="fantasma3";
			cfantasma3=new Fantasma(this.fantasma3,escenario,this);
			crear("fantasma",this);
			setPosicion(fantasma4,posicionifantasma4);
			fantasma4.name="fantasma4";
			cfantasma4=new Fantasma(this.fantasma4,escenario,this);
			crear("vidas",this);
			vidasO.gotoAndStop(int(vidas+1));
			setPosicion(vidasO,[posicioninivel[0],posicioninivel[1]+nivel.height]);
			crear("puntuacion",this);
			setPosicion(puntuacionO,[posicioninivel[0]+(nivel.width/2)-100,posicioninivel[1]-10]);
			
			/*crear("punto",this,null,null);
			crear("punto",this,null,null);
			crear("punto",this,null,null);
			crear("punto",this,null,null);*/
			
			musica=new PacmanOpeningSound(); 
			musica.addEventListener(Event.COMPLETE,musicaopComplete);
			musica.play();
			musicawaka=new PacmanWakSound();
			musicawaka.addEventListener(Event.COMPLETE, musicaopComplete);
			
			clasep.addEventListener("enterFrame",tr);
			escenario.addEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
		}
		
		public function crear(tipo,emisor){
			var objeto:Fabrica=null;
			if(tipo=="pacman") {
				objeto=new FabricaCharacter(tipo);
				clasep.addChild(objeto.getvar("objeto"));
				this.pacman=objeto.getvar("objeto");
			}
			else if(tipo=="fantasma"){
				objeto=new FabricaCharacter(tipo);
				clasep.addChild(objeto.getvar("objeto"));
				if(this.fantasma1==undefined)this.fantasma1=objeto.getvar("objeto");
				else if(this.fantasma2==undefined)this.fantasma2=objeto.getvar("objeto");
				else if(this.fantasma3==undefined)this.fantasma3=objeto.getvar("objeto");
				else if(this.fantasma4==undefined)this.fantasma4=objeto.getvar("objeto");
				else trace("error, se ha llegado al limite");
			}
			else if(tipo=="punto"){
				objeto=new FabricaObject(tipo);
				clasep.addChild(objeto.getvar("objeto"));
				if(this.puntoref1==undefined)this.puntoref1=objeto.getvar("objeto");
				else if(this.puntoref2==undefined)this.puntoref2=objeto.getvar("objeto");
				else if(this.puntoref3==undefined)this.puntoref3=objeto.getvar("objeto");
				else if(this.puntoref4==undefined)this.puntoref4=objeto.getvar("objeto");
				else trace("error, se ha llegado al limite");
			}
			else if(tipo=="puntos"){
				for(var i=0;i<puntosc1.length;i++){
					for(var j=0;j<puntosc1[4].length;j++){
						if(puntosc1[i][j]==1){
							objeto=new FabricaObject("punto");
							clasep.addChild(objeto.getvar("objeto"));
							this["punto"+i+""+j]=objeto.getvar("objeto");
							setPosicion(this["punto"+i+""+j],[(j*15)+(posicioninivel[0]+15),(i*15)+(posicioninivel[1]+15)]);
							this["cpunto"+i+""+j]=new Punto(this["punto"+i+""+j],escenario,this);
						}
						else if(puntosc1[i][j]==2){
							objeto=new FabricaObject("pildora");
							clasep.addChild(objeto.getvar("objeto"));
							this["pildora"+i+""+j]=objeto.getvar("objeto");
							setPosicion(this["pildora"+i+""+j],[(j*15)+(posicioninivel[0]+15),(i*15)+(posicioninivel[1]+15)]);
							this["cpildora"+i+""+j]=new Pildora(this["pildora"+i+""+j],escenario,this);
						}
					}
				}
			}
			else if(tipo.substring(0,tipo.length-1)=="nivel"){
				objeto=new FabricaObject(tipo);
				clasep.addChild(objeto.getvar("objeto"));
				this.nivel=objeto.getvar("objeto");
				
			}
			else if(tipo=="vidas"){
				objeto=new FabricaObject(tipo);
				clasep.addChild(objeto.getvar("objeto"));
				this.vidasO=objeto.getvar("objeto");
			}
			else if(tipo=="puntuacion"){
				objeto=new FabricaObject(tipo);
				clasep.addChild(objeto.getvar("objeto"));
				this.puntuacionO=objeto.getvar("objeto");
			}
			else if(tipo=="pausa"){
				objeto=new FabricaObject(tipo);
				clasep.addChild(objeto.getvar("objeto"));
				this.pausaO=objeto.getvar("objeto");
			}
		}
		
		/*public function eliminar(objeto){
			clasep.removeChild(objeto);
			objeto=undefined;
		}*/
		
		public function tr(e:Event):void{
			if(!iniciado){
				if(tinicio>96){
					iniciado=true;
					pausa=false;
					musica=new PacmanSirenSound();
					musica.addEventListener(Event.COMPLETE, musicaopComplete);
					//reproducirBucle(musica);
					//canalsound=musica.play();
					//canalsound.addEventListener(Event.SOUND_COMPLETE, musicaopComplete); 
				}
				else tinicio++;
			}
			if(iniciado&&!pausa){
				tt++;
				if(debilitados) td++;
				if(tt==escenario.frameRate){
					tiempo++;
					tt=0;
				}
				
				if(td==escenario.frameRate&&tiempod<7){
					tiempod++;
					td=0;
				}
				if(tiempod==7){
					cCPildoras.notificarObservadores();
					tiempod=0;
				}
				
				if(tiempo==tiempor){
					cCReversers.notificarObservadores();
					if(tiempor==5) tiempor=25;
					else if(tiempor==25) tiempor=1225;
					else tiempor=tiempor+1200;
				}
				
				puntuacionO.puntuacion.text=puntuacion;
				
				if(puntos==240){
					aumentarnivel();
				}
				if(puntuacion==puntuacionvidas){
					vidas++;
					puntuacionvidas+=10000;
				}
				
				if(tw<4){
					tw++;
					mw++;
				}
				//if(tw>=3&&canalwaka!=null) canalwaka.stop();
				//if(mw>musicawaka.length+20) mw=0;
				//
				//if(tw>10&&canalwaka!=null) canalwaka.stop();
			}
			
			/*if(pausa&&pausaO!=undefined)pausaO.visible=true;
			else if(!pausa&&pausaO!=undefined){
				pausaO.visible=true;
				//eliminar(pausaO);
			}*/
		}
		
		public function reproducirBucle(musica){
			canalmusicabucle=musica.play(50,9999);
		}
		
		/*public function reproducirWaka(){
			if(tw==4){
				trace(mw);
				canalwaka=musicawaka.play(mw,9999);
				tw=0;
			}
		}*/
		
		public function actualizar(){
			bonus=200;
			if(debilitados&&tiempod>=7){
				debilitados=false;
				//canalmusicabucle.stop();
				musica=new PacmanSirenSound();
				musica.addEventListener(Event.COMPLETE, musicaopComplete);
				//reproducirBucle(musica);
			}
			else if(debilitados&&tiempod<7){
				tiempod=0;
			}
			else if(!debilitados){
				debilitados=true;
				//canalmusicabucle.stop();
				musica=new PacmanWakSound();
				musica.addEventListener(Event.COMPLETE, musicaopComplete);
				//reproducirBucle(musica);
			}
		}
		
		public function inicializar(e:Event){
			if(vidas>0){
				setPosicion(pacman,posicionipacman);
				setPosicion(fantasma1,posicionifantasma1);
				setPosicion(fantasma2,posicionifantasma2);
				setPosicion(fantasma3,posicionifantasma3);
				setPosicion(fantasma4,posicionifantasma4);
				cpacman.reiniciar();
				cfantasma1.reiniciar();
				cfantasma2.reiniciar();
				cfantasma3.reiniciar();
				cfantasma4.reiniciar();
			}
			else{
				gameover();
			}
		}
		
		public function aumentarnivel(){
			var puntuacion=this.puntuacion;
			var vidas=this.vidas;
			escenario.frameRate++;
			
			//canalmusicabucle.stop();
			eliminarObjetos();
			clasep.removeEventListener("enterFrame",tr);
			escenario.removeEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
			
			clasep.setvar("juego",null);
			clasep.crearJuego("pacman");
			clasep.getvar("juego").setvar("puntuacion",puntuacion);
			clasep.getvar("juego").setvar("vidas",vidas);
			clasep.getvar("juego").getvar("vidasO").gotoAndStop(int(vidas+1));
		}
		
		public function pacmanMuerto(){
			pausa=true;
			iniciado=false;
			debilitados=false;
			td=0;
			tiempod=0;
			tinicio=0;
			cpacman.morir();
			//canalmusicabucle.stop();
			
			musica=new PacmanDiesSound();
			//musica.setVolume(0);
			musica.addEventListener(Event.COMPLETE, musicaopComplete);
			//canalmusica.soundTransform=canalmusica.soundTransform.volume=0;
			canalmusica=musica.play();
			canalmusica.addEventListener(Event.SOUND_COMPLETE, inicializar);
			vidas--;
			vidasO.gotoAndStop(int(vidas+1));
		}
		
		public function gameover(){
			eliminarObjetos();
			//canalmusicabucle.stop();
			/*clasep.removeChild(nivel);
			clasep.removeChild(puntoref1);
			clasep.removeChild(puntoref2);
			clasep.removeChild(puntoref3);
			clasep.removeChild(puntoref4);*/
			escenario.frameRate=18;
			clasep.crear("menuP",this);
			clasep.setPosicion(clasep.getvar("menuP"),posicioni);
			clasep.setvar("cmenuP",new MenuPrincipal(clasep.getvar("menuP"),escenario,clasep));
		}
		
		public function eliminarObjetos(){
			cpacman.eliminar();
			cfantasma1.eliminar();
			cfantasma2.eliminar();
			cfantasma3.eliminar();
			cfantasma4.eliminar();
			eliminarPuntos();
			clasep.removeChild(vidasO);
			clasep.removeChild(puntuacionO);
			clasep.removeChild(nivel);
			
			clasep.removeEventListener("enterFrame",tr);
			escenario.removeEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
		}
		
		public function eliminarPuntos(){
			for(var i=0;i<puntosc1.length;i++){
					for(var j=0;j<puntosc1[4].length;j++){
						if(puntosc1[i][j]==1&&this["punto"+i+""+j]!=null){
							clasep.removeChild(this["punto"+i+""+j]);
							this["punto"+i+""+j].removeEventListener("enterFrame",tr);
							this["punto"+i+""+j]=null;
							this["cpunto"+i+""+j]=null;
						}
						else if(puntosc1[i][j]==2){
							clasep.removeChild(this["pildora"+i+""+j]);
							this["pildora"+i+""+j].removeEventListener("enterFrame",tr);
							this["pildora"+i+""+j]=null;
							this["cpildora"+i+""+j]=null;
						}
					}
				}
		}
		
		function KeyDown(event:KeyboardEvent):void {
			if(event.keyCode==80){
				if(!pausa&&iniciado){
					if(pausaO==undefined){
						crear("pausa",this);
						setPosicion(pausaO,posicioni);
					}
					pausa=true;
				}
				else if(pausa&&iniciado) {
					clasep.removeChild(pausaO);
					pausaO=undefined;
					pausa=false;
				}
			}
			if(event.keyCode==8) gameover();
		}
		
		function musicaopComplete(evt:Event):void{}
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}
		public function setPosicion(objeto,posicion){
			objeto.x=posicion[0];
			objeto.y=posicion[1];
		}
	}
	
}
