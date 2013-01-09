package com.autofuss.shatterlogo {
	
	import com.autofuss.events.CustomEvent;
	
	public class TriangleEvent extends CustomEvent{
		
		// Constants:
		public static const CROSS_BOUNDARY:String = 'TriangleEvent: Crossed a boundary';
		public static const ORIGIN_REACHED:String = 'TriangleEvent: Returned to origin';
		
		
		/***************\
		* Constructor	*
		\***************/
		public function TriangleEvent($type:String, $params:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
            super($type, $params, $bubbles, $cancelable);
        }
	
		
	}
}