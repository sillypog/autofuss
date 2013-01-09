package com.autofuss.preloader {
	
	import flash.geom.Point;
	
	public class TrianglePosition {
		
		public var coords:Point;
		public var rot:Number;
		public var newScale:Number
	
		/***************\
		* Constructor	*
		\***************/
		public function TrianglePosition(xPos:Number=0, yPos:Number=0.8, r:Number=0, s:Number=1) {
			coords = new Point (xPos,yPos);
			rot = r;
			newScale = s;
		}
	
		
	}
	
}