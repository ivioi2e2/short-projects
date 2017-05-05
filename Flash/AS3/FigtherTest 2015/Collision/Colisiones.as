package{
	
	import flash.geom.*;
	import HitTest;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Colisiones extends MovieClip{
		
		var dibujo = new Shape();
		
		public function Colisiones():void{
			addChild(dibujo);
			addEventListener(Event.ENTER_FRAME,probar);
		}
		
		public function probar(e:Event):void{
			
			//Hago que el Item1 "persiga" al ratón
			Item1_mc.x = mouseX;
			Item1_mc.y = mouseY;
			
			//Obtiene un Rectángulo con el área de choque entre Item1_mc e Item2_mc
			var rect:Rectangle = HitTest.complexIntersectionRectangle(Item1_mc,Item2_mc);
			
			//Dibuja el rectángulo obtenido
			dibujo.graphics.clear();
			dibujo.graphics.beginFill(0xff0000,.6);
			dibujo.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
			
			//Rellena el campo Chocan_txt con el resultado del choque
			Chocan_txt.text = HitTest.complexHitTestObject(Item1_mc,Item2_mc)?"Si chocan":"No chocan";
		}

	}
}