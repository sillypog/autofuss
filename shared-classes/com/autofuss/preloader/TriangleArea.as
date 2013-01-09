package com.autofuss.preloader{
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	public class TriangleArea extends Sprite {
		
		private const LOGO_W_X3:Number = 77*1.2;
		
		private var oSize:Number;
		
		/***************\
		* Constructor	*
		\***************/
		public function TriangleArea():void{}
	
		
		/*******************\
		* Public methods	*
		\*******************/
		public function drawArea():void{
			// Set the area to be covered to be 3x the logo width all around
			if ((LOGO_W_X3 < stage.stageWidth) && (LOGO_W_X3 < stage.stageHeight)){
				width = LOGO_W_X3;
			} else {
				width = (stage.stageHeight < stage.stageWidth) ? stage.stageHeight : stage.stageWidth ;
			}
			height = width;
			
			// Centre this
			x = (stage.stageWidth / 2) - (width / 2);
			y = (stage.stageHeight / 2) - (height / 2);
			
			oSize = width;
			
		}
		
		public function resized(e:Event):void{
			drawArea();
		}
		
		public function get originalSize():Number{
			return(oSize);
		}
	
	}
}