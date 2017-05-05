package Others{
	
	public class FabricaObject extends Fabrica{
		
		public function FabricaObject(tipo) {
			super(tipo);
			if(tipo=="menuP"){
				super.objeto=new MenuPrincipalObject();
			}
			else if(tipo=="punto"){
				super.objeto=new PuntoObject();
			}
			else if(tipo=="pildora"){
				super.objeto=new PildoraObject();
			}
			else if(tipo=="pausa"){
				super.objeto=new PausaObject();
			}
			else if(tipo=="nivel1"){
				super.objeto=new NivelObject();
			}
			else if(tipo=="vidas"){
				super.objeto=new VidasObject();
			}
			else if(tipo=="puntuacion"){
				super.objeto=new PuntuacionObject();
			}
		}
	}
}