package com.sillypog.loaders{
	
	import flash.display.Loader;
	
	public interface IPreloader {
		
		function loadSWF(swfSource:String):void;
		function getContent():Loader;
		
	}
}