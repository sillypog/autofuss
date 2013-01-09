package com.autofuss.pixelgrid.flatgrid{
	
	/*******************************************************************\
	*																	*
	* This is designed to work with an image that has been prefiltered	*
	*  in pixel bender. That resulting image will be a grid of 1s and 	*
	*  0s that this uses to set the frame of it's MovieClip.			*
	*																	*
	\*******************************************************************/
	
	import flash.display.MovieClip;
	
	public class Logo extends MovieClip{
		
		
		public var xPos, yPos:uint; //keep track of place in grid
	
		/***************\
		* Constructor	*
		\***************/
		public function Logo(tx:uint, ty:uint){
			xPos = tx;
			yPos = ty;
		}
	
		/*******************\
		* Public Methods	*
		\*******************/
		public function setState( value:uint ):void{
			gotoAndStop((value/255)+1);
		}
		
		
	}
}