package com.sillypog.patterns.observer {
	
	// Subject is the observable object. Changes in the observable object will be sent to subscribed observers
	
	import flash.events.Event;
	
	public interface ISubject {
		// Allow addition of a new observer
		function addSubscriber(o:IObserver):void;
		// Allow removal of a subscribed observer
		function removeSubscriber(o:IObserver):void;
		// Send updates to observers in the form of a notification object. The type can be specified later.
		function notifyObservers(notification:Event):void;
	}
	
}