package{
	
	import flash.geom.*;
	import HitTest;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ColisionesFlash extends MovieClip{
		
		var dibujo = new Shape();
		
		public function ColisionesFlash():void{
			addChild(dibujo);
			addEventListener(Event.ENTER_FRAME,probar);
		}
		
		public function probar(e:Event):void{
			
			//Hago que el Item1 "persiga" al ratón
			Item1_mc.x = mouseX;
			Item1_mc.y = mouseY;
			
			//Rellena el campo Chocan_txt con el resultado del choque
			Chocan_txt.text = Item1_mc.hitTestObject(Item2_mc)?"Si chocan":"No chocan";
		}

	}
}