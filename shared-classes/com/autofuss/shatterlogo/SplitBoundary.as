package com.autofuss.shatterlogo {
	
	import flash.display.Sprite;
	
	import flash.events.Event;

	
	public class SplitBoundary extends Sprite{
		
		// Constants:
		// Public Properties:
		public var maxSize:Number;
		// Private Properties:
		
	
		// Initialization:
		public function SplitBoundary() { }
	
		// Public Methods:
		public function maxReached(e:Event):void{
			if ((width > maxSize) || (height > maxSize)){
				removeEventListener(Event.ENTER_FRAME, maxReached);
				var maxEvent:BoundaryEvent = new BoundaryEvent(BoundaryEvent.MAX_REACHED);
				dispatchEvent(maxEvent);
			}
		}
		
		
		// Protected Methods:
		
	}
	
}