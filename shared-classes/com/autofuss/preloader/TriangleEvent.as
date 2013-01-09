package com.autofuss.preloader{
	
	import flash.events.Event;
	
	public class TriangleEvent extends Event{
		
		public static const FINAL_POSITION:String = "Final Position";
		
		public function TriangleEvent(eventID:String){
			super(eventID);
		}
		
	}
}