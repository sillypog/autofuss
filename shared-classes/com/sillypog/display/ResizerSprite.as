package com.sillypog.display{
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	import flash.geom.Point;
	
	import com.sillypog.errors.AbstractMethodError;
	
	public class ResizerSprite extends Sprite{
		
		protected var origin:Point;
		protected var dimensions:Point;
		protected var originalStageDimensions:Point;
		
		/***************\
		* Constructor	*
		\***************/
		public function ResizerSprite():void{
			addEventListener(Event.ADDED_TO_STAGE, listenToResize);
			addEventListener(Event.ADDED_TO_STAGE, storeDimensions);
		}
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function resized(e:Event):void{
			throw new AbstractMethodError('ResizerSprite: resized()');
		}
		
		protected function storeDimensions(e:Event){
			if ((origin === null) && (dimensions === null)){
				origin = new Point(x,y);
				dimensions = new Point(width,height);
				originalStageDimensions = new Point(stage.stageWidth, stage.stageHeight);
			}
		}
		
		/*******************\
		* Private methods	*
		\*******************/
		private function listenToResize(e:Event):void{
			stage.addEventListener(Event.RESIZE,resized);
		}
		
	}
}
			