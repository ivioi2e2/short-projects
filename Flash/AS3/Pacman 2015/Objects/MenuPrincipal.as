package Objects{
  	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	
	public class MenuPrincipal {
		
		public var t=0;
		public var opcion=0;
		public var activo=true;
		public var opciones=["pacman","salir"];
		
		public var MenuP;
		public var stage;
		public var clase;
		public var pacmant;
		public var salirt;

		public function MenuPrincipal(objeto,escenario,clase) {
			MenuP=objeto;
			stage=escenario;
			this.clase=clase
			pacmant=MenuP.pacman;
			salirt=MenuP.salir;
			
			MenuP.addEventListener("enterFrame",tr);
			escenario.addEventListener(KeyboardEvent.KEY_UP,KeyUp);
		}
		function tr(e:Event):void{
			if(opciones[opcion]=="pacman"){
				salirt.visible=true;
				t++;
				if(t>10){
					if(pacmant.visible) pacmant.visible=false;
					else pacmant.visible=true;
					t=0;
				}
			}
			else if(opciones[opcion]=="salir"){
				pacmant.visible=true;
				t++;
				if(t>10){
					if(salirt.visible) salirt.visible=false;
					else salirt.visible=true;
					t=0;
				}			
			}
		}
		function KeyUp(event:KeyboardEvent):void{
			if((event.keyCode==87||event.keyCode==38)&&opcion!=0)opcion--;
			if((event.keyCode==83||event.keyCode==40)&&opcion!=opciones.length-1)opcion++;
			if((event.keyCode==32||event.keyCode==13)&&opciones[opcion]!="salir"){
				clase.crearJuego(opciones[opcion]);
				MenuP.removeEventListener("enterFrame",tr);
				stage.removeEventListener(KeyboardEvent.KEY_UP,KeyUp);
				clase.setvar("MenuP",null);
				clase.removeChild(MenuP);
			}
		}

	}
	
}
