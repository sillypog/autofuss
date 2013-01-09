package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.mvc.AbstractModel;
	
	import flash.events.Event;
	
	public class AbstractQModel extends AbstractModel{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var queuing:Boolean;		// Will be set if messages are to be added to the queue instead of going straight out
		private var clearing:Boolean;		// Will be set before the 1st message is cleared from the queue. This avoids recursion.
		
		private var messageQueue:Array;
	
		// Initialization:
		public function AbstractQModel() {
			
			messageQueue = new Array();
			queuing = false;
		}
	
		// Public Methods:
		public function clearMessageQueue():Void{
			if (!clearing){
				// Set the clearing flag
				clearing = true;
				
				// No longer queuing
				setQueuing(false);
				
				for (var i:int = 0; i < messageQueue.length; i++){
					setChanged();
					notifyObservers(messageQueue[i]);
				}
				
				// Now clear the array
				messageQueue.splice(0);
				
				// Done so clear the flag
				clearing = false;
			}
		}
		
		// Change the way notification works to include queuing
		override public function notifyObservers(notification:Event):Void{
			if ((!queuing) || (notification.bypassQueue)){
				// Not queuing, update listeners
				for (var i:Number=0; i<observers.length; i++){
					observers[i].update(this,notification);
				}
			} else {
				// Store on queue
				messageQueue.push(infoObj);
			} 
		}
		
		// Protected Methods:
		protected function setQueuing(newState:Boolean){
			queuing = newState;
			if (newState == true){
				// Add a dummy entry to the queue so that checks for an empty queue that would turn off queuing will fail
				var dummyMessage:Object = new Object();
				messageQueue.push(dummyMessage);
			}
		}
		
	}
	
}