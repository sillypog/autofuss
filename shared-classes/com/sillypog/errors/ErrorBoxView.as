package com.sillypog.errors{
	
	import info.anneandpete.patterns.mvc.AbstractView;
	
	import info.anneandpete.patterns.mvc.IModel;
	import info.anneandpete.patterns.observer.ISubject;
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	
	public class ErrorBoxView extends AbstractView{
		
		private var errorsList:Array;	// Holds a list of any currently displayed error boxes
		
		
		/***************\
		* Constructor	*
		\***************/
		public function ErrorBoxView(m:IModel, t:Sprite=null):void{
			super(m,t);
			viewName = 'ErrorBox View';
			
			errorsList = new Array();
		}
		
		
		/*******************\
		* Public functions	*
		\*******************/
		override public function update(o:ISubject, notification:Event):void{
			if (notification is Error){
				displayError(notification);
			}
		}
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function displayError(notification:Error):void{
			var errorBox:ErrorBox = new ErrorBox();
			errorBox.message_txt.text = notification.message;
			target.addChild(errorBox);
			errorsList.push(errorBox);
		}
	
	}
}