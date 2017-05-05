package Character{
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
	
	public class Marco{
		public var gi:Number=17;
		public var g:Number=gi; //gravedad
		public var vidai:Number=100;
		public var vida:Number=vidai;  //vida
		public var xscalei:Number;
		public var yscalei:Number;
		public var xscale:Number;
		public var yscale:Number;
	
		public var pesoi:Number=70;  //peso
		public var peso:Number=pesoi;
		public var fuerzai:Number=20;  //fuerza
		public var fuerza:Number=fuerzai;
		public var fuerzasi:Number=120;
		public var fuerzas:Number=0;  //fuerza de salto
		public var defensai:Number=0;  //defensa
		public var defensa:Number=defensai;
		public var penai:Number=10; //penetracion de armadura
		public var pena:Number=penai;
		public var velb:Number=30;  //velocidad basica
		public var veli:Number=(velb)*((100-peso)/100)+fuerzai/50;  //velocidad
		public var vel:Number=veli;
		public var velcaidai:Number=(70*0.1)+10;  //velocidad de caida
		public var velcaida:Number=0;
		public var fureeni:Number=0;  //fuerza de retroceso
		public var fureen:Number=fureeni;
		public var nbi:Number=5;
		public var nb:Number=nbi;
		public var nbdi:Number=0;
		public var nbd:Number=nbdi;
		public var ngi:Number=3;
		public var ng:Number=ngi;
		public var velbalai:Number=20;
		public var velbala:Number=velbalai;
		
		public var tgca:int;
		public var ta:int=10;  //temporizador de ataque
		public var tae:int=0;  //temporizador de ataque enemigo
		public var te:int=0; //temporizador de especial
		public var tem:int=50;
		public var the:int=0; //temporizador para habilitar ataque especial
		public var them:int=100;
		public var tdi:int=5;
		public var td:int=tdi; //temporizador para disparar
		public var tbpi:int=10;
		public var tbp:int=tbpi;  //temporizador de bajar plataforma
		public var tcdi:int=1; 
		public var tcd:int=tcdi; 
	
		//Bloqueos de movimiento
		public var bloqiz:Boolean=false;
		public var bloqde:Boolean=false;
		public var bloqar:Boolean=false;
		public var bloqab:Boolean=false;
	
	
	
		//Estados
		public var j:int=1;
		public var i:int=1;
		public var fra:int=1;
		public var hd:Boolean=true;
		public var saltosi:int=1;
		public var saltos:int=saltosi;
		public var reubicar=false;
		public var posicion:Array;
		public var inicializar:Boolean=true;
		public var recargar:Boolean=false;
		public var disparar:Boolean=false;
		public var muerto:Boolean=false;
		public var restarsaltos:Boolean=false;
		public var reen:Boolean=false;
		public var gcola:Boolean=false;
		public var gcolacambio:Boolean=false;
		public var daño:Boolean=false;
		public var atespecial:Boolean=false;
		public var atacando:Boolean=false;
		public var saltando:Boolean=false;
		public var caminando:Boolean=false;
		public var cayendo:Boolean=false;
		public var agachado:Boolean=false;
		public var aterrisando:Boolean=false;
		public var agarrandose:Boolean=false;
		public var activo:Boolean=false;
		public var limtarriba:Boolean=false;
		
		public var nump:int;
		public var dir:String;
		public var enemigo:Object;
		
		public var arriba:int;
		public var apuntararriba:int;
		public var izquierda:int;
		public var derecha:int;
		public var abajo:int;
		public var atacar:int;
		public var especial:int;
		
		public var tarriba:Boolean;
		public var tapuntararriba:Boolean;
		public var tizquierda:Boolean;
		public var tderecha:Boolean;
		public var tabajo:Boolean;
		public var tatacar:Boolean;
		public var tespecial:Boolean;
	
		public var pvida:Number=vida/500;
		public var pdefensa:Number=defensa/100;
		public var precision:Number=8/10;
		public var pvelx:Number=vel/30;
		public var pvely:Number=(fuerzasi-peso)/100;
		public var evasion:Number;
		public var ppena:Number=pena/100;
		public var pfuerza:Number=fuerza/100;
		public var rango:Number=(1366)/1366;
		public var velat:Number=1-(1.4/3);
		
		public var personaje="marco";
		public var player;
		public var suelo;
		public var plat;
		public var stage;
		public var clase;
		
		public function Marco(objeto,escenario,clase) {
			player=objeto;
			stage=escenario;
			this.clase=clase
			suelo=clase.getvar("suelo");
			plat=clase.getvar("plat");
			plat.visible=false;
			suelo.visible=false;
			player.addEventListener("enterFrame",tr);
			escenario.addEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
			escenario.addEventListener(KeyboardEvent.KEY_UP,KeyUp);
			player.stop();
			
			xscalei=player.scaleX;
			yscalei=player.scaleY;
			xscale=xscalei;
			yscale=yscalei;
			
			evasion=1-(player.height/600);
			//Establecimiento de variables dependientes de jugador
			if(player.name.charAt(player.name.length-1)=="1"){
				nump=1;
				dir="derecha";
				player.scaleX=-xscalei;
				arriba=69;
				apuntararriba=87;
				izquierda=65;
				derecha=68;
				abajo=83;
				atacar=32;
				especial=81;
				enemigo=clase.getvar("player2");
			}
			else{
				nump=2;
				dir="izquierda";
				player.scaleX=xscalei;
				apuntararriba=104;
				arriba=105;
				izquierda=100;
				derecha=102;
				abajo=101;
				atacar=39;
				especial=103;
				enemigo=clase.getvar("cplayer1").getvar("player");
			}
		}
		
		function tr(e:Event):void{
			//Temporizadores
			//if(tgca>0)tgca--;
			if(td>0)td--;
			if(td==0) hd=true;
			if(nbd>=5)recargar=true;
			if(tbp<tbpi) tbp++;
			
			if(inicializar){
				activo=false;
				if(player.name.charAt(player.name.length-1)==1){
					dir="derecha";
					/*posicion=clase.getvar("posicion1");
					player.x=posicion[0];
					player.y=posicion[1];*/
					player.scaleX=-xscalei;
				}
				else{
					dir="izquierda";
					/*posicion=clase.getvar("posicion2");
					player.x=posicion[0];
					player.y=posicion[1];*/
					player.scaleX=xscalei;
				}
				g=gi;
				clase.setvar("vida"+player.name.charAt(player.name.length-1),vidai);
				xscale=xscalei;
				yscale=yscalei;
			
				peso=pesoi;
				fuerza=fuerzai;
				fuerzas=0;
				defensa=defensai;
				pena=penai;
				velb=15;
				vel=veli;
				velcaida=0;
				fureen=fureeni;
				nb=nbi;
				nbd=nbdi;
				velbala=velbalai;
				ng=ngi;
			
				ta=10;
				tae=0;
				te=0;
				tem=50;
				the=0;
				them=100;
				td=tdi;
				
				j=1;
				i=1;
				fra=1;
				hd=true;
				saltosi=1;
				saltos=saltosi;
				reubicar=false;
				recargar=false;
				disparar=false;
				muerto=false;
				restarsaltos=false;
				reen=false;
				daño=false;
				atespecial=false;
				atacando=false;
				saltando=false;
				caminando=false;
				cayendo=false;
				agachado=false;
				aterrisando=false;
				agarrandose=false;
				/*if(player.name.charAt(player.name.length-1)==1){
					player.x=_root.pi1._x;
					player.y=_root.pi1._y;
				}
				else{
					player.x=_root.pi2._x;
					player.y=_root.pi2._y;
				}*/
				inicializar=false;
				activo=true;
			}
			
			if(activo){
				//Cambio de direccion del personaje
				if(dir=="derecha"&&player.scaleX>0)player.scaleX*=-1;
				else if(dir=="izquierda"&&player.scaleX<0)player.scaleX*=-1;
				
				//Gravedad del asunto
				if(!HitTest.complexHitTestObject(player.base,suelo)&&!HitTest.complexHitTestObject(player.base,plat)){
					player.y+=g;
					restarsaltos=false;
					if(HitTest.complexHitTestObject(player.base,suelo))fuerzas=0;
					if(!saltando) cayendo=true;
					//player.y+=gaux;
					//if(gaux<g*4)gaux+=5;
					//if(nsaux==ns)nsaux--;
				}else if(HitTest.complexHitTestObject(player.base,suelo)||HitTest.complexHitTestObject(player.base,plat)){
					//if(!caminando&&!agachado)player.gotoAndStop("normal");
					cayendo=false;
					restarsaltos=true;
					//gaux=g;
					//nsaux=ns;
					//fsaltoaux=fsalto;
				}
				if(HitTest.complexHitTestObject(player.basecontrol,suelo)){
					player.y-=30;
					//player.y-=3;
				}
				if(HitTest.complexHitTestObject(player.basecontrol,plat)&&!cayendo&&!saltando){
					player.y-=10;
				}
				//Reaccion a salto
				player.y-=fuerzas;
				if(fuerzas>=g){
					saltando=false;
					cayendo=true;
				}
				if(fuerzas>0){
					fuerzas-=5;
					cayendo=false;
					saltando=true;
				}
				else{
					fuerzas=0;
					saltando=false;
					if(!HitTest.complexHitTestObject(player.base,suelo)&&!HitTest.complexHitTestObject(player.base,plat))cayendo=true;
				}
				
				//Bloqueo con ambiente y jugador
				if(player.x+player.limiz.x<0)bloqiz=true;
				else bloqiz=false;
				if(player.x+player.limde.x>clase.getvar("stagew"))bloqde=true;
				else bloqde=false;
				
				if(!cayendo&&!saltando&&!aterrisando&&!agarrandose&&!caminando){
					if(!agachado)player.gotoAndStop("normal");
					if(!atacando&&!recargar&&!tapuntararriba&&!atespecial)player.pers.gotoAndStop("normal");
				}
				////////Accion de teclas\\\\\\\\\\\\
				//Moverse a la derecha
				if(tderecha){
					dir="derecha";
					if(!agachado&&!bloqde){
						player.x+=vel;
						if(!saltando&&!cayendo)player.gotoAndStop("caminando");
						caminando=true;
					}
					else if(bloqde)player.gotoAndStop("normal");
				}
				//Moverse a la izquierda
				else if(tizquierda){
					dir="izquierda";
					if(!agachado&&!bloqiz){
						player.x-=vel;
						if(!saltando&&!cayendo)player.gotoAndStop("caminando");
						caminando=true;
					}
					else if(bloqiz)player.gotoAndStop("normal");
				}
				else caminando=false;
				
				//Moverse hacia arriba o saltar
				if(tarriba&&!bloqar&&!saltando&&!cayendo&&!limtarriba){
					if(restarsaltos){
						fuerzas=fuerzasi-peso;
						saltando=true;
						cayendo=false;
						restarsaltos=false;
						limtarriba=true;
					}
				}
				
				//Moverse hacia abajo o agacharse
				if(tabajo&&!bloqab){
					if(!agachado)agachado=true;
					//Bajar plataformas
					if(tbp<tbpi&&HitTest.complexHitTestObject(player.base,plat)&&!HitTest.complexHitTestObject(player.base,suelo)){
						player.y+=20;
					}
				}
				
				//Ataque normal
				if(tatacar&&vida>0){
					if(!recargar){
						atacando=true;
					}
					if(hd&&nb>0&&td<=0&&!recargar){
						disparar=true;
					}
				}
				
				//Ataque especial
				if(tespecial&&!atespecial&&ng>0&&the<=0){
					atespecial=true;
				}
				
				////////////Reaccion a estados\\\\\\\\\\\\\\\
				if(disparar&&atacando){
					player.pers.gotoAndStop("disparando");
					clase.crear("balamarco",this,10,null);
					nb--;
					hd=false;
					disparar=false;
					td=tdi;
					nbd++;
				}
				
				//Fuerza de retroceso
				if(reen){
					if(fureen>0){
						fureen--;
						if(!bloqde)player.x+=fureen;
						if(fureen<fureeni/2){
							fureen/3;
							fureeni=fureeni/2;
						}
						if(fureen<=0){
							fureeni=0;
							fureen=0;
							reen=false;
						}
					}
					else if(fureen<0){
						fureen++;
						if(!bloqiz)player.x+=fureen;
						if(fureen>fureeni/2){
							fureen/3;
							fureeni=fureeni/2;
						}
						if(fureen>=0){
							fureeni=0;
							fureen=0;
							reen=false;
						}
					}
				}
				
				//Ataques
		
				//Colision con daño
				/*if(this.pers.at.hitTest(_root[enemigo])&&daño==true&&pers.at._visible==true){
						if(pers.at.retroceso>0&&!_root[enemigo].reen){
							_root[enemigo].fureeni=pers.at.retroceso;
							if(_root[enemigo]._x<_x){
								_root[enemigo].fureeni=_root[enemigo].fureeni*-1;
							}
							_root[enemigo].fureen=_root[enemigo].fureeni;
							_root[enemigo].reen=true;
			   			}
			   			_root[enemigo].vida-=(pers.at.fuerza*(((100-_root[enemigo].defensai)*((100-pers.at.pena)/100))/100));
				}*/
				
				//Accion al morir
				if(clase.getvar("vida"+nump)<=0){
					vida=0;
					muerto=true;
					atacando=false;
					fureeni=0;
					fureen=fureeni;
					reen=false;
					activo=false;
				}
				
				
				//Ataques
				if(player.currentFrame!=5&&player.pers.currentFrame==5&&player.pers.cuerpo.currentFrame==5){
					atespecial=false;
				}
				//Ataque especial
				if(atespecial&&the<=0){
					//Establecer valores temporales de ataque especial
					
					
					clase.crear("granadamarco",this,3,null);
					ng--;
					the=them;
				}
				else if(the>0)the--;
				if(the==them-5) atespecial=false;
				if(!aterrisando&&!agarrandose){
					//Estados Principales (normal, caminando, agachado, saltando, cayendo, muerto)
					if(cayendo)player.gotoAndStop("cayendo");
					else if(saltando)player.gotoAndStop("saltando");
					else if(caminando){
						player.gotoAndStop("caminando");
					}
					else if(agachado){
						player.gotoAndStop("agachado");
					}
					else player.gotoAndStop("normal");
					
					//Estados secundarios (normal, atacando, disparando, arriba, recargar)
					if(atespecial){
						player.pers.gotoAndStop("lanzando");
					}
					else if(!recargar&&!atespecial){
						if(tapuntararriba){
							if(!disparar&&atacando){
								if(tcd>=0){
									tcd--;
								}
								else {
									tcd=tcdi;
									player.pers.gotoAndStop("atacando");
								}
							}
							else player.pers.gotoAndStop("atacando");
							//trace(player.pers.currentFrame)
							player.pers.cuerpo.gotoAndStop("arriba");
						}
						else if(!tapuntararriba){
							if(!disparar&&atacando){
								if(tcd>=0){
									tcd--;
								}
								else {
									tcd=tcdi;
									player.pers.gotoAndStop("atacando");
								}
							}
							else if(!atacando){
								player.pers.gotoAndStop("normal");
							}
						}
					}
					else {
						player.pers.gotoAndStop("recargar");
					}
				}
		
				//Recargar
				if(recargar&&!atespecial){
					if(fra<18&&player.pers.currentFrame==4){
						fra++;
						player.pers.cuerpo.gotoAndStop(fra);
					}
					
				}
				else fra=1;
				if(player.pers.currentFrame==4&&player.pers.cuerpo.currentFrame==18){
					recargar=false;
					nbd=0;
					hd=true;
					nb=nbi;
					//td=tdi;
				}
			}
			
			
			if(muerto){
				vida=0;
				
					//muerto=true;
					atacando=false;
					fureeni=0;
					fureen=fureeni;
					reen=false;
					
					//escenario.textog._visible=true;
					activo=false;
					
				player.gotoAndStop("muerto");
				if(HitTest.complexHitTestObject(player.basecontrol,suelo)){
					player.y-=30;
				}
				if(HitTest.complexHitTestObject(player.base,suelo)||HitTest.complexHitTestObject(player.base,plat)){
					cayendo=false;
				}
				else if(!HitTest.complexHitTestObject(player.base,suelo)||!HitTest.complexHitTestObject(player.base,plat)){
					player.y+=g;
					if(HitTest.complexHitTestObject(player.base,suelo)||HitTest.complexHitTestObject(player.base,plat))fuerzas=0;
					if(!saltando) cayendo=true;
				}
			}
		}
		
		function KeyDown(event:KeyboardEvent):void {
			if(event.keyCode==derecha) {
				tderecha=true;
				//if(player.scaleX>0)player.scaleX*=-1;
				//if(!moviz)player.gotoAndStop("caminando");
			}else if(event.keyCode==izquierda) {
				tizquierda=true;
				//if(player.scaleX<0)player.scaleX*=-1;
				//if(!movde)player.gotoAndStop("caminando");
			}
			if(event.keyCode==arriba){
				tarriba=true;
			} 
			if(event.keyCode==abajo){
				tabajo=true;
			} 
			if(event.keyCode==apuntararriba){
				tapuntararriba=true;
			} 
			if(event.keyCode==atacar){
				tatacar=true;
			} 
			if(event.keyCode==especial){
				tespecial=true;
			} 
		}
		function KeyUp(event:KeyboardEvent):void {
			if(event.keyCode==derecha) {
				tderecha=false;
			}else if(event.keyCode==izquierda) {
				tizquierda=false;
			}
			if(event.keyCode==arriba){
				tarriba=false;
				limtarriba=false;
			} 
			if(event.keyCode==abajo){
				tabajo=false;
				agachado=false;
				tbp=0;
			} 
			if(event.keyCode==apuntararriba){
				tapuntararriba=false;
			} 
			if(event.keyCode==atacar){
				tatacar=false;
				atacando=false;
			} 
			if(event.keyCode==especial){
				tespecial=false;
			} 
		}
		
		//Funciones
		public function getvar(variable){
			return this[variable];
		}
	}
}