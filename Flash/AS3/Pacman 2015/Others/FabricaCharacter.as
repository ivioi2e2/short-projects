package Others{
	
	public class FabricaCharacter extends Fabrica{
		
		public function FabricaCharacter(tipo) {
			super(tipo);
			if(tipo=="pacman")super.objeto=new PacmanObject();
			if(tipo=="fantasma")super.objeto=new FantasmaObject();
		}

	}
	
}
