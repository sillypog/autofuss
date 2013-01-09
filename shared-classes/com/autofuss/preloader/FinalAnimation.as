package com.autofuss.preloader{
	
	import flash.display.MovieClip;
	
	import flash.events.Event;
	
	public class FinalAnimation extends MovieClip{
		
		/***************\
		* Constructor	*
		\***************/
		public function FinalAnimation():void{
			addEventListener(Event.ENTER_FRAME,checkFrame);
		}
		
		/* The registration point is in the middle of this sprite for easy centreing */
		public function recentre(e:Event){
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
		}
		
		/* Avoiding putting code on the timeline by checking for final frame here */ 
		private function checkFrame(e:Event){
			// Send a complete event if this is the last frame
			if (currentFrame == totalFrames){
				removeEventListener(Event.ENTER_FRAME,checkFrame);
				var completeEvent:Event = new Event(Event.COMPLETE);
				dispatchEvent(completeEvent);
			}
		}
		
	}
}
	
		