package com.autofuss.pixelgrid.cubegrid{
	
	import com.autofuss.pixelgrid.flatgrid.Logo;
	
	public class Logo3D extends Logo{
		
		private var currentState:uint;
		private var blockHeight:int;
		
		private const MAX_HEIGHT:int = 6;
		private const MIN_HEIGHT:int = 1;
		
		public function Logo3D(tx:uint, ty:uint){
			super(tx, ty);
			blockHeight = MAX_HEIGHT;
			currentState = 2;			// Have to set the initial state so that in the first check, the XOR check doesn't say false
		}
		
		
		override public function setState( value:uint ):void{

			// If the last bit of value is the same as last bit of state, no change. Exclusively if they are different, reset height
			/* // Here's an example of XOR check
				var one:int = 255;
				var two:int = 0;
				trace( ((one >> 1) ^ (two >> 1)) ? 'true' : 'false' );	// Returns true
			*/
			blockHeight = (value ^ currentState) ? MAX_HEIGHT : blockHeight-1;	
			blockHeight = (blockHeight >= MIN_HEIGHT) ? blockHeight : MIN_HEIGHT;
			// Set the new frame
			gotoAndStop( (value & 1) ? 7-blockHeight : 7+blockHeight);
			// Store the new state
			currentState = value;	
			
			
			/* Write a long version of that to see if I'm even close. Seems to work */
			/*
			// Set the height
			if (value != currentState){
				blockHeight = MAX_HEIGHT;
			} else {
				if (blockHeight > MIN_HEIGHT){
					blockHeight--;
				}
			}
			
			// Set the frame
			if (value){
				gotoAndStop(7 + blockHeight);
			} else {
				gotoAndStop(7 - blockHeight);
			}
			
			// Save state 
			currentState = value;
			*/
			
			
			
		}
	
	}
}