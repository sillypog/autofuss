package com.sillypog.events {
	
	import flash.events.ErrorEvent;
	
	public class CustomErrorEvent extends ErrorEvent{
		
		// Public Properties: - write only
		public var info:Object;							// The message body, eg an error message. This might not be included.
		public var bypass:Boolean;							// Instructs the dispatcher not to queue this message if set
		// Private Properties:
	
		// Initialization:
		public function CustomErrorEvent(type:String, _info:Object=null, _bypass:Boolean=false):void{
			// Satisfy the requirements of the superclass
			//super(type, bubbles, cancelable);
			super(type, false, false);
			
			// Build the bundle
			info = _info;
			bypass = _bypass;
		}
		
		
		// Public methods:
		public function get messageInfo():Object{
			return(info);
		}
		
		public function get bypassQueue():Boolean{
			return(bypass);
		}
		
	}
	
}