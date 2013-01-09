package com.sillypog.loaders {
	
	import flash.net.URLRequest
	
	public interface IDataLoader {
		
		function loadData(url:String=null):void;
		function setType(type:String):void;
	
	}
	
}