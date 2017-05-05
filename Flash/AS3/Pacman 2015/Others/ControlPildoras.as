package Others{
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
	
	public class ControlPildoras{
		public var observers:Array;
		
		public function ControlPildoras(){
			observers=new Array;
		}
		
		public function registrarObservador(observador){
			if(!searchArrayVar(observers,observador))
				observers=addArrayVar(observers,observador);
		}
		
		public function altaObservador(observador){
			if(searchArrayVar(observers,observador))
				observers=removeArrayVar(observers,observador);
		}
		
		public function notificarObservadores(){
			for(var i=0;i<observers.length;i++){
				observers[i].actualizar();
			}
		}
		
		public function searchArrayVar(array, variable){
			var encontrado=false;
			
			for(var i=0;i<=array.length;i++){if(array[i]==variable) encontrado=true;}
			
			return encontrado;
		}
		
		public function addArrayVar(array,variable){
			var varaux:Array=new Array(array.length+1);
			for(var i=0;i<=array.length;i++){
				if(i!=array.length) varaux[i]=array[i];
				else varaux[i]=variable;
			}
			return varaux;
		}
		
		public function removeArrayVar(array,variable){
			var varaux:Array=new Array(array.length-1);
			var j=0;
			for(var i=0;i<=varaux.length;i++){
				if(array[i]!=variable){
					varaux[j]=array[i];
					j++;
				}
			}
			return varaux;
		}

	}
	
}