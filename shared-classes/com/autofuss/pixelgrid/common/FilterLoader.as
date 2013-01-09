package com.autofuss.pixelgrid.common{
	
	import com.sillypog.loaders.AbstractDataLoader;
	
	import com.sillypog.patterns.mvc.IModel;
	import flash.net.URLLoaderDataFormat;
	
	public class FilterLoader extends AbstractDataLoader{
		
		/***************\
		* Constructor	*
		\***************/
		public function FilterLoader(r:IModel, format:String=URLLoaderDataFormat.TEXT):void {
			super(r,format);
		}
	
		
	}
}