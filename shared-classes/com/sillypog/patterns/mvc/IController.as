package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.mvc.IView;
	
	import flash.events.Event;
	
	public interface IController {
		
		function setModel(m:IModel):void;
		function getModel():IModel;
		function setView(v:IView):void;
		function getView():IView;
		// This is the function that responds to events in the view
		function viewEvent(e:Event):void;
		
	}
	
}