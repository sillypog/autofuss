package com.sillypog.patterns.mvc{
	
	import flash.display.Sprite;
	
	import com.sillypog.patterns.mvc.IModel;
	
	import com.sillypog.patterns.observer.IObserver;
	
	import com.sillypog.errors.AbstractMethodError;
	
	import flash.events.Event;
	
	public class AbstractModelSprite extends Sprite implements IModel{
		
		private var observers:Array;		// Stores a list of all subscribed observers
		
		/***************\
		* Constructor	*
		\***************/
		public function AbstractModelSprite():void{
			observers = new Array();
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		/* Implement IModel */
		public function processMessage(message:Event):void{
			// The result of processing a message will be dependent on the application
			// Throw an error event that this method should have been overwritten
			throw(new AbstractMethodError('AbstractModel: processMessage'));
		}
		
		/* Implement ISubject */
		public function addSubscriber(o:IObserver):void{
			// Avoid adding duplicates
			for (var i:int=0; i < observers.length; i++){
				if (observers[i]==o){
					return;
				}
			}
			observers.push(o);
		}
		
		public function removeSubscriber(o:IObserver):void{
			//Remove this entry from the array
			for (var i:int=0; i<observers.length; i++){
				if (observers[i]==o){
					observers.splice(i,1);
					break;
				}
			}
		}
		
		public function notifyObservers(notification:Event):void{
			for (var notify in observers){
				observers[notify].update(this,notification);
			}
		}
		
		
	}
}