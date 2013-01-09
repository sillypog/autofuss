package com.sillypog.loaders{
	
	import flash.events.Event;
	
	public interface IPreloaderVisuals extends IPreloader {
		
		function processMessage(message:Event):void;
		function startApplication(e:Event);
		function displayError():void
		
	}
}