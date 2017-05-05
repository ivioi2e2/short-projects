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
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.KeyboardEvent;
	import flash.display.StageScaleMode;
	import flash.display.IBitmapDrawable;
	
	public class genPiezas {
		
		public var objeto;
		public var escenario;
		public var clasep;
		public function genPiezas(objeto,escenario,clasep) {
			trace(objeto+" "+objeto.name);
			this.objeto=objeto;
			this.escenario=escenario;
			this.clasep=clasep;
		}
		
		public function eliminar(){
			clasep.removeChild(objeto);
		}

	}
	
}
