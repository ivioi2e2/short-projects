package Objects{
	import flash.events.Event;
	import flash.geom.*;
	import HitTest;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.KeyboardEvent;
  	import flash.ui.Keyboard;
	
	public class GranadaMarco {
		public var existe:Boolean;
		public var dir:String;
		public var fuerza:Number=10;
		public var tocado:Boolean=false;
		
		public function GranadaMarco(objeto,escenario) {
			existe=true;
			objeto.addEventListener("enterFrame",tr);
			dir=escenario["player"+objeto.name.charAt(objeto.name.length-1)].dir
			// constructor code
		}
		
		function tr(e:Event){
			if(activo){
				/*if(_root.inicializar){
					unloadMovie(this);
				}*/
				if(dir=="derecha"){
					objeto.x+=velx;
					objeto.y-=vely;
					objeto.rotation+=5;
				}
				else{
					objeto.x-=velx;
					objeto.y-=vely;
					objeto.rotation-=5;
				}
				if(velx>0){
					velx--;
				}
				vely-=2;
				if(objeto.x<0||objeto.x>Stage.width){
					existe=false;
					//unloadMovie(this);
				}
				if(objeto.y<0||objeto.y>Stage.height){
					existe=false;
					//unloadMovie(this);
				}
				if(_root.suelo.hitTest(_x,_y,true)){
					existe=false;
					//duplicateMovieClip(_root.explosion1,["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)],1000+_name.charAt(_name.length-2)+(_name.charAt(_name.length-1)*10));
					//_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._y=_y;
					//_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._x=_x;
					//_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)].activo=true;
					//unloadMovie(this);
				}
				else if(_root.plat.hitTest(_x,_y,true)&&vely<0){
					existe=false;
					//duplicateMovieClip(_root.explosion1,["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)],1000+_name.charAt(_name.length-2)+(_name.charAt(_name.length-1)*10));
					//_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._y=_y;
					//_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._x=_x;
					//_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)].activo=true;
					//unloadMovie(this);
				}
				if(escenario["player"+(escenario["player"+objeto.name.charAt(_name.length-1)].enemigo._name.charAt(_root["pers"+_name.charAt(_name.length-1)].enemigo._name.length))]=="thekid"){
					if(HitTest.complexHitTestObject(escenario["player"+(escenario["player"+objeto.name.charAt(objeto.name.length-1)].enemigo)],objeto.at)){
						existe=false;
				}
				else{
					if(HitTest.complexHitTestObject(escenario["player"+(escenario["player"+objeto.name.charAt(_name.length-1)].enemigo)],objeto.at)&&!tocado){
						escenario[escenario["player"+objeto.name.charAt(objeto.name.length-1)].enemigo].vida-=fuerza*((100-escenario[escenario["player"+objeto.name.charAt(objeto.name.length-1)].enemigo].defensai)/100);
						existe=false;
						if(dir=="derecha"){
							objeto.scaleX=objeto.scaleX*-1;
							dir="izquierda";
						}
						else {
							objeto.scaleX=objeto.scaleX*-1;
							dir="derecha";
						}
						tocado=true;
						//unloadMovie(this);
					}
					else tocado=false;
						//unloadMovie(this);
					}
				}
			}
		}
	}
	
}

/*
onClipEvent(load){
	existe=true;
	dir=_root["pers"+_name.charAt(_name.length-1)].dir;
	fuerza=10;
	tocado=false;
	//if(_name.charAt(_name.length-1)=="1"||_name.charAt(_name.length-1)=="2") activo=true;
}
onClipEvent(enterFrame){
	if(activo){
		if(_root.inicializar){
			unloadMovie(this);
		}
		if(dir=="derecha"){
			_x+=velx;
			_y-=vely;
			_rotation+=5;
		}
		else{
			_x-=velx;
			_y-=vely;
			_rotation-=5;
		}
		if(velx>0){
			velx--;
		}
		vely-=2;
		if(_x<0||_x>Stage.width){
			existe=false;
			unloadMovie(this);
		}
		if(_y<0||_y>Stage.height){
			existe=false;
			unloadMovie(this);
		}
		if(_root.suelo.hitTest(_x,_y,true)){
			existe=false;
			duplicateMovieClip(_root.explosion1,["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)],1000+_name.charAt(_name.length-2)+(_name.charAt(_name.length-1)*10));
			_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._y=_y;
			_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._x=_x;
			_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)].activo=true;
			unloadMovie(this);
		}
		else if(_root.plat.hitTest(_x,_y,true)&&vely<0){
			existe=false;
			duplicateMovieClip(_root.explosion1,["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)],1000+_name.charAt(_name.length-2)+(_name.charAt(_name.length-1)*10));
			_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._y=_y;
			_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)]._x=_x;
			_root["explosion1"+_name.charAt(_name.length-2)+_name.charAt(_name.length-1)].activo=true;
			unloadMovie(this);
		}
		if(_root["personaje"+(_root["pers"+_name.charAt(_name.length-1)].enemigo._name.charAt(_root["pers"+_name.charAt(_name.length-1)].enemigo._name.length))]=="thekid"){
			if(_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].hitTest(this.at)){
				existe=false;
		}
		else{
			if(_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].hitTest(_x+_width/2,_y,true)||_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].hitTest(_x+_width/4,_y-_height/2,true)||_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].hitTest(_x+_width/4,_y+_height/2,true)||_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].hitTest(_x-_width/2,_y,true)||_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].hitTest(_x-_width/4,_y-_height/2,true)||_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].hitTest(_x-_width/4,_y+_height/2,true)&&!tocado){
				_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].vida-=fuerza*((100-_root[_root["pers"+_name.charAt(_name.length-1)].enemigo].defensai)/100);
				existe=false;
				if(dir=="derecha"){
					x=x*-1;
					dir="izquierda";
				}
				else {
					x=x*-1;
					dir="derecha";
				}
				tocado=true;
				//unloadMovie(this);
			}
			else tocado=false;
				//unloadMovie(this);
			}
		}
	}
}
*/