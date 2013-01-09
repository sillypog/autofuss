package com.sillypog.patterns.observer {
	
	import flash.events.Event;
	
	public interface IObserver {
		// Receive notifications from the observable subject we are subscribed to
		function update(o:ISubject, notification:Event):void;
	}
	
}