package com.sillypog.display{

	/**
	* Import required packages.
	*/
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.*;
	import flash.net.URLRequest;
	
	/**
	* Class definition.
	*/
	public class TileBG extends Sprite {
	
		/**
		* Class variables.
		*/
		public var bitmap:Bitmap = new Bitmap();
		public var stageInstance:Stage;
		
		/**
		* Class constructor.
		*/
		public function TileBG(obj:*, stage):void {
			name = 'TileSprite';
			stageInstance = stage;
			
			if(obj is BitmapData) {
				bitmap.bitmapData = obj;
				resize();
			} else if (obj is String) {
				var url:URLRequest = new URLRequest(obj);
				var loader:Loader = new Loader();
				configureListeners(loader.contentLoaderInfo);
				loader.load(url);
			} else {
				throw new Error('Problem : First parameter obj must be a string \”path_to_image\” or bitmapData.');
			}
			stageInstance.addChild(this);
			stageInstance.addEventListener(Event.RESIZE, resize);
		}
		
		/**
		* Configure the loader object events.
		*/
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, loaderComplete);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, loaderError);
		}
		
		/**
		* Loader object complete event.
		*/
		private function loaderComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, loaderComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, loaderError);
			bitmap.bitmapData = Bitmap(event.target.content).bitmapData;
			resize();
		}
		
		/**
		* Loader object error event.
		*/
		private function loaderError(event:Event):void {
			throw new Error('Problem : There was an error accessing the image file.');
		}
		
		
		/**
		* Resize the background sprite to the stage size.
		*/
		private function resize(event:Event = null) {
			graphics.beginBitmapFill(bitmap.bitmapData);
			graphics.drawRect(0, 0, stageInstance.stageWidth, stageInstance.stageHeight);
			graphics.endFill();
		}
	
	}

}
