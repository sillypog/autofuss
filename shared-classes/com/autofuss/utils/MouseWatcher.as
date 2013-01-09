package com.autofuss.utils {
	
	/*******************************************************************\
	* This class stores the positions of the mouse for five frames at	*
	* a time. This helps with calculating speeds and angles later.		*
	\*******************************************************************/
	
	import flash.events.EventDispatcher;
	
	import flash.events.MouseEvent;
	
	import flash.geom.Point;
	
	public class MouseWatcher extends EventDispatcher{
		

		private const FRAME_NO:int = 5;				// The number of frames to store mouse positions for
		
		private var mousePositions:Array;			// Will store the mouse positions for the previous frames
	
		/***************\
		* Constructor	*
		\***************/
		public function MouseWatcher() {
			
			// Instantiate the mousePositions array
			mousePositions = new Array();
			for (var i:int = 0; i < FRAME_NO; i++){
				mousePositions[i] = null;
			}
		}
	
	
		/*******************\
		* Public methods	*
		\*******************/
		public function mouseSpeed():Number{
			// Calculate the average change in position between frames
			var change:Number = 0;
			for (var i:int = 0; i < FRAME_NO - 1; i++){
				if ((mousePositions[i]) && (mousePositions[i+1])){
					var dx:Number = mousePositions[i+1].x - mousePositions[i].x;
					var dy:Number = mousePositions[i+1].y - mousePositions[i].y;
					change += Math.sqrt ((dx * dx) + (dy * dy));
				}
			}
			return(change / FRAME_NO);
		}
		
		public function projectPoint():Point{
			/*
			var iPoint_1:Point = Point.interpolate(mousePositions[0],mousePositions[1],0.5);
			var iPoint_2:Point = Point.interpolate(iPoint_1, mousePositions[2],0.5);
			var iPoint_3:Point = Point.interpolate(iPoint_2, mousePositions[3],0.5);
			
			return(iPoint_3);
			*/
			return(mousePositions[0]);
			
		}
		
		public function storePosition(e:MouseEvent):void{
			// Take the oldest value off the array
			mousePositions.shift();
			// Add the newest
			var position:Point = new Point(e.stageX, e.stageY);
			mousePositions.push(position);
		}
	}
	
}