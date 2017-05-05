package Player{
	import flash.geom.*;
	import HitTest;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
  	import flash.ui.Keyboard;
	
	public class Marco2 {
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
		public var nbi:Number=10;
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
		public var inicializar:Boolean=true;
		public var recuperar:Boolean=false;
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
		
		public var nump:int;
		public var dir:String;
		public var enemigo:String;
		
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
		
		public var player;
		public var suelo;
		public var stage;
		
		public function Marco2(objeto,escenario) {
			player=objeto;
			stage=player.parent;
			suelo=stage.suelo;
			player.addEventListener("enterFrame",tr);
			escenario.addEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
			escenario.addEventListener(KeyboardEvent.KEY_UP,KeyUp);
			player.stop();
			
			xscalei=player.scaleX;
			yscalei=player.scaleY;
			xscale=xscalei;
			yscale=yscalei;
			
			evasion=1-(player.height/600);
			//player.pers.at.visible=false;
			//Establecimiento de variables dependientes de jugador
			if(player.name=="player1"){
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
				enemigo="player2";
				this.enemigo=enemigo;
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
				enemigo="player1";
			}
		}
		
		function tr(e:Event):void{
			//Temporizadores
			//if(tgca>0)tgca--;
			if(td>0)td--;
			if(td==0) hd=true;
			if(nbd>=10)recargar=true;
			if(tbp<tbpi) tbp++;
			
			if(inicializar){
				activo=false;
				if(player.name.charAt(player.name.length-1)==1){
					dir="derecha";
					player.x=200;
					player.y=600;
					player.scaleX=-xscalei;
				}
				else{
					dir="izquierda";
					player.x=766;
					player.y=188;
					player.scaleX=xscalei;
				}
				g=gi;
				vida=vidai;
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
				recargar=false;
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
				if(!HitTest.complexHitTestObject(player.base,suelo)){
					player.y+=g;
					restarsaltos=false;
					if(HitTest.complexHitTestObject(player.base,suelo))fuerzas=0;
					if(!saltando) cayendo=true;
					//player.y-=30;
					//if(!saltando) cayendo=true;
					//player.y+=gaux;
					//if(gaux<g*4)gaux+=5;
					//if(nsaux==ns)nsaux--;
				}else if(HitTest.complexHitTestObject(player.base,suelo)){
					if(!caminando&&!agachado)player.gotoAndStop("normal");
					cayendo=false;
					restarsaltos=true;
					//gaux=g;
					//nsaux=ns;
					//fsaltoaux=fsalto;
					//cayendo=false;
					saltando=false;
				}
				if(HitTest.complexHitTestObject(player.basecontrol,suelo)){
					player.y-=30;
					//saltar=false;
					//player.y-=3;
				}
				
				//Reaccion a salto
				player.y-=fuerzas;
				if(fuerzas==g) cayendo=true;
				if(fuerzas>0) fuerzas-=5;
				else{
					fuerzas=0;
					if(saltando)cayendo=true;
					saltando=false;
				}
				
				//Bloqueo con ambiente y jugador
				if(HitTest.complexHitTestObject(player.limde,suelo))bloqde=true;
				else bloqde=false;
				if(HitTest.complexHitTestObject(player.limiz,suelo))bloqiz=true;
				else bloqiz=false;
				
				if(!cayendo&&!saltando&&!agachado&&!aterrisando&&!atacando&&!agarrandose&&!caminando&&!recargar&&!tapuntararriba&&!atespecial){
					player.gotoAndStop("normal");
					player.pers.gotoAndStop("normal");
				}
				else if(!recargar&&!disparar&&!atacando&&!tapuntararriba&&!atespecial){
					//gotoAndStop("normal");
					player.pers.gotoAndStop("normal");
					//pers.gotoAndStop("recargar");
				}
				
				////////Accion de teclas\\\\\\\\\\\\
				//Moverse a la derecha
				if(tderecha){
					if(recargar&&!recuperar) recuperar=true;
					dir="derecha";
					if(!agachado&&!bloqde){
						player.x+=vel;
						if(!saltando&&!cayendo)player.gotoAndStop("caminando");
						caminando=true;
					}
				}
				//Moverse a la izquierda
				else if(tizquierda){
					if(recargar&&!recuperar) recuperar=true;
					dir="izquierda";
					if(!agachado&&!bloqiz){
						player.x-=vel;
						if(!saltando&&!cayendo)player.gotoAndStop("caminando");
						caminando=true;
					}
				}
				else caminando=false;
				//Moverse hacia arriba o saltar
				if(tarriba&&!bloqar&&!saltando&&!cayendo){
					if(recargar&&!recuperar) recuperar=true;
					if(restarsaltos){
						fuerzas=fuerzasi-peso;
						saltando=true;
						cayendo=false;
						restarsaltos=false;
					}
				}
				//Moverse hacia abajo o agacharse
				if(tabajo&&!bloqab){
					if(recargar&&!recuperar) recuperar=true;
					if(!agachado)agachado=true;
					player.gotoAndStop("agachado");
					//bajar plataformas
					/*if(tbp<tbpi&&_root.plat.hitTest(_x,_y,true)){
						player.y+=20;
					}*/
				}
				//Apuntar hacia arriba
				if(tapuntararriba&&!recargar&&!atespecial){
					player.pers.gotoAndStop("atacando");
				}
				//Ataque normal
				if(tatacar&&vida>0){
					if(!recargar){
						atacando=true;
						player.pers.gotoAndStop("atacando");
					}
					if(hd&&nb>0&&td<=0&&!recargar){
						//if(dir=="derecha")_root.attachMovie("bala","bala"+nb+nump,100+nb,{_x:_x+15, _y:_y-_height/2});
						//else _root.attachMovie("bala","bala"+nb+nump,100+nb,{_x:_x-15, _y:_y-_height/2});
						disparar=true;
					}
					//atacando=true;
				}
				//Ataque especial
				if(tespecial&&!atespecial&&ng>0&&the<=0){
					atespecial=true;
				}
				
				////////////Reaccion a estados\\\\\\\\\\\\\\\
				if(disparar){
					player.pers.gotoAndStop("disparando");
					/*if(_root["bala3"+i+nump].existe!=true){
						duplicateMovieClip(_root.bala3,["bala3"+i+nump],300+i+(nump*20));
						if(Key.isDown(apuntararriba)){
							_root["bala3"+i+nump]._y=_y-_height-70;
							if(dir=="derecha")_root["bala3"+i+nump]._x=_x-17;
							else _root["bala3"+i+nump]._x=_x+15;
							//_root["bala3"+i+nump]._x=_x;
							_root["bala3"+i+nump].vely=velbala;
							_root["bala3"+i+nump].velx=0;
							_root["bala3"+i+nump]._rotation=90;
						}
						else{
							if(!agachado)_root["bala3"+i+nump]._y=_y-_height/3*2-10;
							else _root["bala3"+i+nump]._y=_y-_height/2;
							if(dir=="derecha")_root["bala3"+i+nump]._x=_x+_width/2+40;
							else _root["bala3"+i+nump]._x=_x-_width/2-40;
							_root["bala3"+i+nump].velx=velbala;
							_root["bala3"+i+nump].vely=0;
						}				
						_root["bala3"+i+nump].activo=true;
						nb--;
						hd=false;*/
						disparar=false;
						//td=tdi;
						//nbd++;
					//}
					//else i++;
					//if(i==nbi+1) i=1;
				}else if(!disparar&&!recargar&&atacando)player.pers.gotoAndStop("atacando");
				//Recargar
				if(recargar&&!atespecial){
					player.pers.gotoAndStop("recargar");
					if(fra<18)fra++;
				}
				else fra=1;
				if(player.pers.currentFrame==4&&player.pers.cuerpo.currentFrame==18){
					recargar=false;
					nbd=0;
					hd=true;
					td=tdi;
				}
				
				//Recuperar
				if(recuperar){
					player.pers.cuerpo.gotoAndPlay(fra);
					recuperar=false;
				}
				/*else if(disparar&&atacando){
					pers.gotoAndStop("disparando");
				}
				else if(atacando&&!recargar&&!disparar){
					pers.gotoAndStop("atacando");
				}
				else pers.gotoAndStop("normal");*/
				//Agachado
				if(agachado){
					
				}
				//Saltando
				if(saltando){
					player.gotoAndStop("saltando");
				}
				//Cayendo
				if(cayendo){
					player.gotoAndStop("cayendo");
					
					//if(_root.suelo.hitTest(_x,_y-35,true)) gotoAndStop("aterrisando");
				}
				//Apuntar arriba
				if(tapuntararriba){
					if(!disparar)player.pers.gotoAndStop("atacando");
					else player.pers.gotoAndStop("disparando");
					player.pers.cuerpo.gotoAndStop("arriba");
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
				if(vida<=0){
					vida=0;
					muerto=true;
					atacando=false;
					fureeni=0;
					fureen=fureeni;
					reen=false;
					/*if(player.name.charAt(_name.length-1)=="1"){
						escenario.textog.ganador="El ganador es player2";
					}
					else escenario.textog.ganador="El ganador es player1";*/
					
					//escenario.textog._visible=true;
					activo=false;
				}
				
				
				//Ataques
				if(player.pers.currentFrame==5&&player.pers.cuerpo.currentFrame==5){
					atespecial=false;
				}
				//Ataque especial
				if(atespecial&&the<=0){
					//Establecer valores temporales de ataque especial
					player.pers.gotoAndStop("lanzando");
					/*if(_root["granada1"+j+nump].existe!=true){
						duplicateMovieClip(_root.granada1,["granada1"+j+nump],j+(nump*20));
						if(Key.isDown(apuntararriba)){
							_root["granada1"+j+nump]._y=_y-_height-70;
							if(dir=="derecha")_root["granada1"+j+nump]._x=_x+27;
							else _root["granada1"+j+nump]._x=_x+15;
							//_root["bala3"+i+nump]._x=_x;
							_root["granada1"+j+nump].vely=velbala/2;
							_root["granada1"+j+nump].velx=0;
							_root["granada1"+j+nump]._rotation=90;
						}
						else{
							if(!agachado)_root["granada1"+j+nump]._y=_y-_height/3*2;
							else _root["granada1"+j+nump]._y=_y-_height/2+10;
							if(dir=="derecha")_root["granada1"+j+nump]._x=_x+_width/2+40;
							else _root["granada1"+j+nump]._x=_x-_width/2-40;
							_root["granada1"+j+nump].velx=velbala;
							_root["granada1"+j+nump].vely=0;
						}
						_root["granada1"+j+nump].activo=true;
						the=them;
						ng--;
					}
					else j++;*/
					if(j==ngi+1) j=1;
				}
				else if(the>0)the--;
				if(the==them-5) atespecial=false;
				if(atacando){
					//this.pers.cabeza.gotoAndStop("atacando");
				}
				//else this.pers.cabeza.gotoAndStop("normal");
			}
			if(muerto==true){
				player.gotoAndStop("muerto");
				if(HitTest.complexHitTestObject(player.basecontrol,suelo)){
					player.y-=30;
				}
				if(HitTest.complexHitTestObject(player.base,suelo)){
					cayendo=false;
				}
				else if(!HitTest.complexHitTestObject(player.base,suelo)){
					player.y+=g;
					if(HitTest.complexHitTestObject(player.base,suelo))fuerzas=0;
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
				//if(player.scaleX>0)player.scaleX*=-1;
				//if(!moviz)player.gotoAndStop("caminando");
			}else if(event.keyCode==izquierda) {
				tizquierda=false;
				//if(player.scaleX<0)player.scaleX*=-1;
				//if(!movde)player.gotoAndStop("caminando");
			}
			if(event.keyCode==arriba){
				tarriba=false;
			} 
			if(event.keyCode==abajo){
				tabajo=false;
				agachado=false;
				tbp=0;
			} 
			if(event.keyCode==apuntararriba){
				tapuntararriba=false;
				//player.pers.gotoAndStop("normal");
			} 
			if(event.keyCode==atacar){
				tatacar=false;
				atacando=false;
			} 
			if(event.keyCode==especial){
				tespecial=false;
			} 
		}
	}
	
}
/*
onClipEvent(enterFrame){
	//Cambio de capa
	if(_root[enemigo]._y<_y) this.swapDepths(1);
	
	if(activo==true){
		
		/*if(recargar&&agachado){
			pers.gotoAndStop("recargar");
			
		}*/
		/*
		
///Recargar movieclip ultimo frame
_parent._parent.recargar=false;
_parent._parent.nbd=0;
_parent._parent.hd=true;
_parent._parent.td=_parent._parent.tdi;

//atespecial ultimo frame
_parent._parent.atespecial=false;

		
}
*/