package Objects{
	import HitTest;
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
	
	public class ExplosionMarco{
		public var fuerza=6;
		public var pena=70;
		public var daño:Boolean=true;
		public var existe:Boolean=false;
		public var activo:Boolean=false;
		
		public var objeto;
		public var granada;
		public var clase;
		
		public function ExplosionMarco(objeto,granada,enemigo) {
			this.objeto=objeto
			this.clase=granada.clase;
			objeto.gotoAndPlay(1);
			
			objeto.x=granada.getvar("objeto").x;
			objeto.y=granada.getvar("objeto").y;
			
			objeto.addEventListener("enterFrame",tr);
			existe=true;
			activo=true;
		}
		function tr(e:Event):void{
			if(activo){
				if(HitTest.complexHitTestObject(clase.getvar("player1"),objeto)&&daño){
				  	clase.setvar(["vida"+1],clase.getvar(["vida"+1])-(fuerza*((100-((clase.getvar("cplayer1").getvar("defensa"))*((100-pena)/100)))/100)));
				}
				if(HitTest.complexHitTestObject(clase.getvar("player2"),objeto)&&daño){
				  	clase.setvar(["vida"+2],clase.getvar(["vida"+2])-(fuerza*((100-((clase.getvar("cplayer2").getvar("defensa"))*((100-pena)/100)))/100)));
				}
				
				if(objeto.currentFrame==21) existe=false;
				if(objeto.currentFrame==3) daño=false;
					//objeto.parent["existegranadamarco"+objeto.name.charAt(objeto.name.length-1)]=false;
				
				if(!existe){
					objeto.x=-150;
					objeto.y=-150;
					objeto.removeEventListener("enterFrame",tr);
				}
			}
		}
	}
	
}
/*
onClipEvent(load){
	
}
onClipEvent(enterFrame){
	if(activo){
		if(_root.inicializar){
			unloadMovie(this);
		}
		if(this.at.hitTest(_root.pers1)&&daño){
		   _root.pers1.vida-=fuerza*((100-((_root.pers1.defensa)*((100-pena)/100)))/100);
		}
		if(this.at.hitTest(_root.pers2)&&daño){
		   _root.pers2.vida-=fuerza*((100-((_root.pers2.defensa)*((100-pena)/100)))/100);;
		}
		if(_currentframe==21) unloadMovie(this);
	}
}
*/
