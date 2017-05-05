package Others{
	import Characters.*;
	import Objects.*;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class Fabrica {
		var objeto:Object;
		var nombre;
		public function Fabrica(tipo) {objeto=null;}
		public function getvar(variable){return this[variable];}
		public function setvar(variable,valor){this[variable]=valor;}

	}
	
}
