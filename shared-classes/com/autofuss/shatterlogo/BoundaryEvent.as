package com.autofuss.shatterlogo {
	
	import com.autofuss.events.CustomEvent;
	
	public class BoundaryEvent extends CustomEvent{
		

		public static const MAX_REACHED:String = 'Boundary reached maximum';
		
		
		/***************\
		* Constructor	*
		\***************/
		public function BoundaryEvent($type:String, $params:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
            super($type, $params, $bubbles, $cancelable);
        }
		
		
	}
}