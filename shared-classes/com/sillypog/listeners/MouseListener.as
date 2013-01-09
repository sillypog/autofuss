package com.sillypog.listeners{
	
	import com.sillypog.patterns.mvc.AbstractView;
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.observer.ISubject;
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MouseListener extends AbstractView{
		
		/***************\
		* Constructor	*
		\***************/
		public function MouseListener(m:IModel, t:Sprite=null):void{
			super(m,t);
			viewName = 'MouseListener View';
			setup();
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		override public function update(o:ISubject, notification:Event):void{}
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function setup():void{
			target.addEventListener(MouseEvent.MOUSE_MOVE, dispatch);
		}
		
		protected function dispatch(e:MouseEvent){
			getModel().processMessage(e);
		}
		
	}
}