package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.observer.ISubject;
	
	import flash.events.Event;
	
	/* Model is subject in observer pattern: ie, listeners subsribe to notifcations of change
	In AS3, this is already defined by IEventDispatcher and can be implemented by extending EventDispatcher
	
	However, if I want to change the way events are dispatched, eg by adding them to a queue, it will be better to 
	extend ISubject of the observer pattern
	*/
	
	public interface IModel extends ISubject{
		
		// A common entry point to the model allowing Observers to send information which will change the model
		function processMessage(message:Event):void;
	}
	
}