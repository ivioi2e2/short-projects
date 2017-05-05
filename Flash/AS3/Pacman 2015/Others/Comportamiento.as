package Others{
	
	public class Comportamiento {
		
		public var estadoactual;
		public var cfantasma;
		
		public function Comportamiento(cfantasma) {
			this.cfantasma=cfantasma
		}
		public function setEstado(estado){
			estadoactual=estado;
			estadoactual.setvar("cfantasma",cfantasma);
		}
		public function getEstado(){return estadoactual;}
		public function pedirComportamiento(){estadoactual.manejador();}

	}
	
}
