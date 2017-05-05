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
	
	public class Player{
		public var ns:int=2;
		public var nsaux:int=ns;
		public var g:Number=5;
		public var gaux:Number=g;
		public var velx:Number=10;
		public var fsalto:Number=47;
		public var fsaltoaux:Number=fsalto;

		public var movde:Boolean=false;
		public var moviz:Boolean=false;
		public var saltar:Boolean=false;
		public var saltando:Boolean=false;
		public var cayendo:Boolean=false;
		
		public var player;
		public var suelo;
		public var stage;
		
		public function Player(objeto,escenario) {
			player=objeto;
			stage=player.parent;
			suelo=stage.suelo;
			player.addEventListener("enterFrame",tr);
			escenario.addEventListener(KeyboardEvent.KEY_DOWN,KeyDown);
			escenario.addEventListener(KeyboardEvent.KEY_UP,KeyUp);
			player.stop();
		}
		function tr(e:Event):void{
			if(!HitTest.complexHitTestObject(player.base,suelo)){
				player.y+=gaux;
				if(gaux<g*4)gaux+=5;
				if(nsaux==ns)nsaux--;
			}else if(HitTest.complexHitTestObject(player.base,suelo)){
				gaux=g;
				nsaux=ns;
				fsaltoaux=fsalto;
				cayendo=false;
				saltando=false;
			}
			if(HitTest.complexHitTestObject(player.basecontrol,suelo)){
				saltar=false;
				player.y-=3;
			}
				
			if(movde&&!HitTest.complexHitTestObject(player.limde,suelo)) player.x+=velx;
			if(moviz&&!HitTest.complexHitTestObject(player.limiz,suelo)) player.x-=velx;
				
				
			if(HitTest.complexHitTestObject(player.tope,suelo)) fsaltoaux=0;
			
			if(saltar){
				gaux=g;
				nsaux--;
				fsaltoaux=fsalto;
				cayendo=false;
				saltando=true;
				saltar=false;
			}
			if(saltando){
				player.y-=fsaltoaux;
				if(fsaltoaux>0){
					fsaltoaux-=5;
				}
				else{
					fsaltoaux=fsalto;
					saltando=false;
					cayendo=true;
				}
			}
		}
		
		function KeyDown(event:KeyboardEvent):void {
			if(event.keyCode==Keyboard.RIGHT) {
				movde=true;
			}else if(event.keyCode==Keyboard.LEFT) {
				moviz=true;
			}
			if(event.keyCode==Keyboard.UP&&nsaux>0){
				saltar=true;
			} 
		}
		function KeyUp(event:KeyboardEvent):void {
			if(event.keyCode==Keyboard.RIGHT) {
				movde=false;
			}else if(event.keyCode==Keyboard.LEFT) {
				moviz=false;
			}
		}
	}
}
