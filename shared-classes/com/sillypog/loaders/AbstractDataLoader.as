package com.sillypog.loaders {
	
	/***********************************************************\
	* This is a generic data loader class to be used with MVC.	*
	*  Ideally it can cope with multiple types of data loading 	*
	*  and provides a consistent interface.						*
	*															*
	\***********************************************************/
	
	import com.sillypog.loaders.IDataLoader;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	
	import com.sillypog.patterns.mvc.IModel;
	
	import com.sillypog.events.MessageEvent;
	import com.sillypog.events.CustomErrorEvent;
	import com.sillypog.errors.LoadError;
	
	public class AbstractDataLoader implements IDataLoader{
		
		protected var dataLoader:URLLoader;
		
		protected var requester:IModel;
		
		protected var storedURL:String;
		protected var dataFormat:String;
	
		/*******************\
		* Constructor		*
		\*******************/
		public function AbstractDataLoader(r:IModel, format:String=URLLoaderDataFormat.TEXT) {
			requester = r;
			dataFormat = format;
		}
	
		/*******************\
		* Public Methods	*
		\*******************/
		
		/* This function is required by IDataLoader interface */
		public function loadData(url:String=null):void{
			// Save the url
			if (url){
				storedURL = url;
			}
			// Add any specific url information to the base. Default is to add nothing
			var fullQuery:String = formatQuery(storedURL);
			// Load in the data
			dataLoader = new URLLoader();
			dataLoader.dataFormat = dataFormat;
			dataLoader.addEventListener(ProgressEvent.PROGRESS, this.calculateProgress);
			// These events don't need to be processed at all so send them directly. Messages and events should both be compatible.
			dataLoader.addEventListener(Event.COMPLETE,this.verifyData);
			// Error messages are processed and sent in a consistent manner
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, this.sendError);
			dataLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.sendError);
			//dataLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
			// Get the data
			//trace('AbstractDataLoader: loadData(): about to load '+fullQuery);
			dataLoader.load(new URLRequest(fullQuery));
		}
		
		/* This function is required by IDataLoader interface */
		public function setType(type:String):void{
			dataFormat = type;
		}
		
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		
		/* This function allows a basename to be appended to a fixed location */
		protected function formatQuery(url:String):String{
			return(url);
		}
		
		/* When all the data loading operation has finished (successfully or otherwise), the information is passed to the requester */
		protected function loadComplete(bundle:Event):void{
			// Remove the listeners
			removeListeners();
			// Destroy the loader
			dataLoader = null;
			// Send the bundle
			requester.processMessage(bundle);
		}
		
		/* Checks that the data downloaded correctly before sending it to the requester */
		protected function verifyData(e:Event):void{
			// Decide if the data is good
			var downloadProgress:Number = calculateProgress(dataLoader);
			var verifyMessage:Event;
			if (downloadProgress == 100){
				// Got all of the file, send it on
				verifyMessage = new MessageEvent(LoaderMessage.COMPLETE,dataLoader.data);
			} else {
				// Didn't get the whole file, send an error
				verifyMessage = new CustomErrorEvent(LoadError.TRUNCATED, downloadProgress);
			}
			loadComplete(verifyMessage);
		}
		
		/* Remove all of the data listeners	*/
		private function removeListeners():void{
			dataLoader.removeEventListener(ProgressEvent.PROGRESS, this.calculateProgress);
			dataLoader.removeEventListener(Event.COMPLETE,this.verifyData);
			dataLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.sendError);
			dataLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.sendError);
			//dataLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
		}
		
		// Removing this function because if httpStatus is not 200, an ioError is triggered anyway
		/* If the status of the http response is not 200, throw an error */
		/*
		private function httpStatus(e:HTTPStatusEvent):void{
			if ((e.status != 200) && (e.status != 0)){
				sendError(e);
			}
		}
		*/
		
		/* Calculates % of data downloaded and sends this to requester. It takes either a progress event or the dataLoader object */
		private function calculateProgress(e:Object):Number{
			var downloadProgress:Number = (e.bytesLoaded/e.bytesTotal) * 100;
			var progressMessage:MessageEvent = new MessageEvent(LoaderMessage.PROGRESS, downloadProgress);
			requester.processMessage(progressMessage);
			return(downloadProgress);
		}
		
		/* Sends consistent error messages to the requester */
		private function sendError(e:Event):void{
			var loadError:CustomErrorEvent = new CustomErrorEvent(LoadError.LOAD_ERROR, e.type);
			loadComplete(loadError)
		}
		
		
	}
	
}