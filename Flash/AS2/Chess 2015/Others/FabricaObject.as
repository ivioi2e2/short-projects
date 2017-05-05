package Others{
	
	public class FabricaObject extends Fabrica{
		
		public function FabricaObject(tipo) {
			super(tipo);
			if(tipo=="Tablero"){
				super.objeto=new TableroObject();
			}
			else if(tipo=="BotonTableroord"){
				super.objeto=new BotonTableroordObject();
			}
			else if(tipo=="BotonTablerovac"){
				super.objeto=new BotonTablerovacObject();
			}
			else if(tipo=="BotonMenu"){
				super.objeto=new BotonMenuObject();
			}
			else if(tipo=="TorreB"){
				super.objeto=new TorreBlancaObject();
			}
			else if(tipo=="TorreN"){
				super.objeto=new TorreNegraObject();
			}
			else if(tipo=="CaballoB"){
				super.objeto=new CaballoBlancoObject();
			}
			else if(tipo=="CaballoN"){
				super.objeto=new CaballoNegroObject();
			}
			else if(tipo=="AlfilB"){
				super.objeto=new AlfilBlancoObject();
			}
			else if(tipo=="AlfilN"){
				super.objeto=new AlfilNegroObject();
			}
			else if(tipo=="DamaB"){
				super.objeto=new DamaBlancaObject();
			}
			else if(tipo=="DamaN"){
				super.objeto=new DamaNegraObject();
			}
			else if(tipo=="ReyB"){
				super.objeto=new ReyBlancoObject();
			}
			else if(tipo=="ReyN"){
				super.objeto=new ReyNegroObject();
			}
			else if(tipo=="PeonB"){
				super.objeto=new PeonBlancoObject();
			}
			else if(tipo=="PeonN"){
				super.objeto=new PeonNegroObject();
			}
		}
	}
}