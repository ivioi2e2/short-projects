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
	
	public class BalaMarco {
		public var dir:String;
		public var velx:Number=10;
		public var vely:Number=0;
		public var fuerza:Number=10;
		public var existe:Boolean=false;
		public var tocado:Boolean=false;
		public var activo:Boolean=false;
		
		public var stage;
		public var objeto;
		public var colision;
		public var player;
		public var enemigo;

		public function BalaMarco(objeto,colision,player,enemigo) {
			this.objeto=objeto;
			this.colision=colision;
			this.player=player;
			this.enemigo=enemigo;
			stage=objeto.parent.parent;
			dir=player.dir;
			existe=true;
			activo=true;
			objeto.addEventListener("enterFrame",tr);
			for(var i:uint=0;i<objeto.parent.numChildren;i++){
				trace('\t|\t '+i+'.\t name:'+objeto.parent.getChildAt(i).name+'\t type:'+typeof(objeto.parent.getChildAt(i))+'\t'+objeto.parent.getChildAt(i));
			}
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
				}
				else{
					//objeto.x-=velx;
					objeto.y-=vely;
				}
				if(objeto.x<0||objeto.x>stage.width){
					existe=false;
					player.nb++;
					//removeChild(this);
				}
				if(objeto.y<0||objeto.y>stage.height){
					existe=false;
					player.nb++;
					//unloadMovie(this);
				}
				if(enemigo.toString().substring(8,player.toString().length-1)=="TheKid"){
					if(HitTest.complexHitTestObject(enemigo,objeto.at)){
						existe=false;
						player.nb++;
					}
				}
				else{
					if(!tocado&&HitTest.complexHitTestObject(objeto,objeto.parent.getChildAt(3))){
						trace("hola");
						//stage[stage["player"+objeto.name.charAt(objeto.name.length-1)].enemigo].vida-=fuerza*((100-stage[stage["player"+objeto.name.charAt(objeto.name.length-1)].enemigo].defensai)/100);
						existe=false;
						player.nb++;
						tocado=true;
						//stage.removeChild(objeto.parent.getChildAt(4));
					}
					else tocado=false;
						//unloadMovie(this);
				}
			}
		}
	}
}