package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.observer.IObserver;
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.mvc.IController;
	import com.sillypog.patterns.observer.ISubject;
	
	public interface IView extends IObserver{
		
		//Set the model this view is observing
		function setModel(m:IModel):void;
		
		//Return the model this view is observing
		function getModel():IModel;
		
		//Set the controller for this view
		function setController(c:IController):void;
		
		//Return this view's controller
		function getController():IController;
		
		//Return default controller for this view
		function defaultController (model:IModel):IController;
		
	}
	
}