package com.sillypog.display{
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	public class CentredSprite extends Sprite{
		
		public function centre(xDim:Boolean = true, yDim:Boolean = true):void{
			if (xDim){
				x = (stage.stageWidth / 2) - (width / 2);
			}
			
			if (yDim){
				y = (stage.stageHeight / 2) - (height / 2);
			}
		}
		
		public function recentre(e:Event):void{
			centre();
		}
		
		
	}
}