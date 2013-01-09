package com.sillypog.loaders{
	
	import flash.events.Event;
	
	public class DataLoaderEvent extends Event{
		
		public function DataLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void{
			super(type, bubbles, cancelable);
		}
		
	}
}