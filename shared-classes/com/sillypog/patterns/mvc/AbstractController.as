package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.mvc.IController;
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.mvc.IView;
	
	import flash.events.Event;
	
	import com.sillypog.errors.AbstractMethodError;
	
	public class AbstractController implements IController{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var model:IModel;
		private var view:IView;
	
		// Initialization:
		public function AbstractController(m:IModel):void{
			setModel(m);
		}
	
		// Public Methods:		
		public function setModel(m:IModel):void{
			model=m;
		}
		
		public function getModel():IModel{
			return model;
		}
		
		public function setView(v:IView):void{
			view=v;
		}
		
		public function getView():IView{
			return view;
		}
		
		/* The response to view events will be dependent on the implementation */
		public function viewEvent(e:Event):void{
			throw(new AbstractMethodError('AbstractController: viewEvent()'));
		}
		// Protected Methods:
	}
	
}