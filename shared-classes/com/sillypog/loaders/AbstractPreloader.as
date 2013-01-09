package com.sillypog.loaders{
	
	import com.sillypog.patterns.mvc.AbstractModelSprite;
	import com.sillypog.loaders.IPreloader;
	
	import com.sillypog.loaders.AbstractDataLoader;
	
	import com.sillypog.errors.AbstractMethodError;
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	import com.sillypog.events.MessageEvent;
	import com.sillypog.events.CustomErrorEvent;
	import com.sillypog.loaders.LoaderMessage;
	
	import flash.display.Loader;
	import flash.net.URLLoaderDataFormat;
	
	import flash.utils.ByteArray;
	
	public class AbstractPreloader extends AbstractModelSprite implements IPreloader{
		
		protected var loader:AbstractDataLoader;
		
		protected var swfData:Loader;
		
		protected var finalStageAlign:String;
		protected var finalStageMode:String;
		
		/***************\
		* Constructor	*
		\***************/
		public function AbstractPreloader():void{
			addEventListener(Event.ADDED_TO_STAGE,processMessage);			// Automatically draw it once it is added to the stage
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		override public function processMessage(message:Event):void{
			switch(message.type){
				case Event.ADDED_TO_STAGE	:	drawAssets();													break;
				case LoaderMessage.PROGRESS	:	progressEvent(Number(MessageEvent(message).messageInfo));		break;
				case LoaderMessage.COMPLETE	:	completeEvent(ByteArray(MessageEvent(message).messageInfo));	break;
			}
		}
		
		public function loadSWF(swfSource:String):void{
			loader = new AbstractDataLoader(this, URLLoaderDataFormat.BINARY);
			loader.loadData(swfSource);
		}
		
		public function getContent():Loader{
			return(swfData);
		}
		
		/*******************\
		* Protected methods	*
		\*******************/
		/* This will be different each time depending on the loader skin */
		protected function drawAssets():void{
			throw (new AbstractMethodError('AbstractPreloader: drawAssets'));
		}
		
		protected function progressEvent(currentProgress:Number):void{
			throw (new AbstractMethodError('AbstractPreloader: progressEvent'));
		}
		
		protected function completeEvent(dataBytes:ByteArray):void{
			trace('AbstractPreloader: completeEvent()');
			// Can save the loaded data in this class and call a function in the subclass to say the loaded data is ready...that way ByteArray stuff is hidden here
			swfData = new Loader();
			
			/*
			// Give the loader access to the stage
			swfData.visible = false;
			addChild(swfData);
			trace('AbstractPreloader: completeEvent(): added Loader to stage');
			*/
			
			// Pass the loaded information to the loader for display
			swfData.loadBytes(dataBytes);
			trace('AbstractPreloader: completeEvent(): passed bytes to Loader');
			// Then let the subclass deal with displaying the data
			dataLoaded();
		}
		
		protected function dataLoaded():void{
			throw (new AbstractMethodError('AbstractPreloader: dataLoaded'));
		}
			
		
		
		
	}
}