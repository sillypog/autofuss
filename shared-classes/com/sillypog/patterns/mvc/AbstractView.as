package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.mvc.IView;
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.mvc.IController;
	import com.sillypog.patterns.observer.ISubject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.sillypog.errors.AbstractMethodError;
	
	public class AbstractView implements IView{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var model:IModel;
		private var controller:IController;
		
		public var viewName:String;								// The unique name for this view
		
		protected var target:Sprite;								// A reference to the clip for the view to be added to
	
		/***********************************************************\
		* Constructor												*
		*															*
		* @params:													*
		*  m:Observable - Reference to the model					*
		*  t:Sprite - Reference to Display Container				*
		*															*
		\***********************************************************/
		public function AbstractView(m:IModel, t:Sprite=null){
			
			viewName = 'unnamed AbstractView';
			
			setModel(m);
			
			target = t;
			
			// Register for updates from model
			getModel().addSubscriber(this);
		}
		
		// Public Methods:
		public function defaultController(model:IModel):IController{
			//Should override this in concrete class
			throw(new AbstractMethodError(viewName));
			//Have to return null here because it is not a Void function
			return null;
		}
		
		public function setModel(m:IModel):void{
			model=m;
		}
		
		public function getModel():IModel{
			return model;
		}
		
		public function setController(c:IController):void{
			controller=c;
			//Tell the controller who its view is
			c.setView(this);
		}
		
		public function getController():IController{
			//If there's no controller, we need to make default one
			if (controller === null){
				setController(defaultController(getModel()));
			}
			return controller;
		}
		
		//update() in Observer interface. Fill in with concrete
		public function update(o:ISubject, notification:Event):void{
			throw(new AbstractMethodError(viewName));
		}
	}
}