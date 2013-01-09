package com.sillypog.patterns.observer {
	
	import flash.events.Event;
	
	public class AbstractObservable implements ISubject{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var observers:Array;		// Stores a list of all subscribed observers
	
		// Initialization:
		public function AbstractObservable() {
			// Instantiate the Observers array
			observers = new Array();
		}
	
		// Public Methods:
		public function addSubscriber(o:IObserver):void{
			// Avoid adding duplicates
			for (var i:int=0; i < observers.length; i++){
				if (observers[i]==o){
					//trace("Won't add duplicate");
					return;
				}
			}
			observers.push(o);
		}
		
		public function removeSubscriber(o:IObserver):void{
			//Remove this entry from the array
			for (var i:int=0; i<observers.length; i++){
				if (observers[i]==o){
					observers.splice(i,1);
					break;
				}
			}
		}
		
		public function notifyObservers(notification:Event):void{
			for (var notify in observers){
				observers[notify].update(this,notification);
			}
		}
		// Protected Methods:
		
	}
	
}