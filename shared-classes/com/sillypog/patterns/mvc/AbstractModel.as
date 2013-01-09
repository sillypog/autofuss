package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.observer.AbstractObservable;
	import com.sillypog.errors.AbstractMethodError;
	
	import flash.events.Event;
	
	/* All of the Observer pattern work is taken care of by extending AbstractObservable */
	public class AbstractModel extends AbstractObservable implements IModel{
	
		// Initialization:
		public function AbstractModel() {}
	
		// Public Methods:
		
		/* This function is the single entry point for sending information to this class
		    Content can be any type, eg String, XML or an object. It will be up to the
			individual implementations to decide how to cast this based on the type		*/
		public function processMessage(message:Event):void{
			// The result of processing a message will be dependent on the application
			// Throw an error event that this method should have been overwritten
			throw(new AbstractMethodError('AbstractModel: processMessage'));
			
		}
		
		// Protected Methods:
	}
	
}