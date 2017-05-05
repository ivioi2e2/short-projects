package Others{
	import Character.*;
	import Objects.*;
	import flash.events.Event;
	import flash.display.MovieClip;
	public dynamic class Fabrica extends MovieClip{
		var clasepadre;

		public function Fabrica() {}
		
		/*public function CrearBala(player,dir,arriba){
			var enemigo;
			clasepadre=player.getvar("player").parent;
			
			for(var i=1;i<=10;i++){
				this["bala"+i]=new BalaMetalSlug();
				this["existe"+i]=false;
			}
			
			clasepadre.addChild(this.bala1);
			this.existe1=true;
			
			enemigo=player.getvar("enemigo");
			
			new BalaMarco(this.bala1,this.bala1.at,player.getvar("player"),enemigo,dir,arriba);
		}*/
		
		public function crearProyectil(proyectil,emisor,n){
			var objetivo;
			//Si emisor es del tipo clase
			clasepadre=emisor.getvar("player").parent;
			objetivo=emisor.getvar("enemigo");
			
			for(var i=1;i<=n;i++){
				if(proyectil=="balamarco") this[proyectil+i]=new BalaMarcoObject();
				else if(proyectil=="granadamarco") this[proyectil+i]=new GranadaMarcoObject();
				else if(proyectil=="explosionmarco") this[proyectil+i]=new ExplosionMarcoObject();
				this["existe"+proyectil+i]=false;
			}
			clasepadre.addChild(this[proyectil+1]);
			clasepadre.swapChildrenAt(clasepadre.getChildIndex(emisor.getvar("player")),clasepadre.getChildIndex(this[proyectil+1]));
			clasepadre.swapChildrenAt(clasepadre.getChildIndex(objetivo),clasepadre.getChildIndex(this[proyectil+1]));
			this["existe"+proyectil+1]=true;
			
			
			if(proyectil=="balamarco"){
				new BalaMarco(this[proyectil+1],emisor,objetivo);
			}
			else if(proyectil=="granadamarco"){
				new GranadaMarco(this[proyectil+1],emisor,objetivo);
			}
			else if(proyectil=="explosionmarco"){
				new ExplosionMarco(this[proyectil+1],emisor,objetivo);
			}
		}
		public function crearPersonaje(objeto,emisor,posicion){
			var tipo=objeto.substring(0,objeto.length-1);
			if(tipo=="marco"){
				emisor[objeto]=new MarcoObject();
				emisor[objeto].name=objeto;
				emisor.addChild(emisor[objeto]);
				emisor[objeto].x=posicion[0];
				emisor[objeto].y=posicion[1];
			}
			else if(tipo=="robosaurio"){
				emisor[objeto]=new RobosaurioObject();
				emisor[objeto].name=objeto;
				emisor.addChild(emisor[objeto]);
				emisor[objeto].x=posicion[0];
				emisor[objeto].y=posicion[1];
			}
			
			
		}
		
		public function EliminarObjeto(objeto){
			removeChild(objeto);
		}

	}
	
}
