package {
	
	/*******************************************************\
	*														*
	* This version will treat the logo as a square and will *
	*  add a white and black triangle to get the edge right	*
	*														*
	\*******************************************************/
	
	import flash.display.Sprite;
	
	import flash.geom.Point;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.autofuss.shatterlogo.*;
	import com.autofuss.background.MaskArea;
	import com.autofuss.utils.MouseWatcher;

	
	public class ShatterLogo extends Sprite {
		
		protected var logoMask:MaskArea;			// A resizable background with a cutout logo in the centre
		
		protected var backLayer:Sprite;				// A container for all the masked content
		protected var logoBox:LogoBox;				// The grey 'square' of the logo without the text
		protected var triangleBox:SplitBoundary;	// A container for all the triangles
		
		protected var triangles:Array;				// Store references to on stage triangle sprites
		protected var whiteTriangle:WhiteTriangle;	// One white triangle is added to the top left of the logo
		protected var reformedTriangles:int;		// Is incremented when triangles return to starting positions. Aids in resetting.
		
		protected var offset:Point;				// Will store x,y offset for triangles on face. Should be width of edge
		
		protected var mouseWatcher:MouseWatcher;	// Keep track of mouse positions
		
		
		/***************\
		* Constructor	*
		\***************/
		public function ShatterLogo():void{
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		
		
		/*******************\
		* Private methods	*
		\*******************/
		private function onAddedToStage(e:Event):void{
			initialiseVars();
			drawAssets();			
			// Listen for events where the mouse hits the logoBox
			logoBox.addEventListener(MouseEvent.MOUSE_OVER,this.shatter);
		}
		
			
		private function initialiseVars():void{
			// Make a place to store future triangle instances
			triangles = new Array();
			// Start watching mouse movements for speed calculations
			mouseWatcher = new MouseWatcher();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseWatcher.storePosition); 
			
		}
		
		private function drawAssets():void{
			// Add a container which will hold all the masked content
			backLayer = new Sprite();
			addChild(backLayer);
			
			// Add a grey box to define the shape of the logo. This is what shatters when hit
			logoBox = new LogoBox();
			backLayer.addChild(logoBox);
			logoBox.centre();
			
			// Add a container for future triangles
			triangleBox = new SplitBoundary();
			backLayer.addChild(triangleBox);
			
			// Add the mask 
			logoMask = new MaskArea();
			addChild(logoMask);
			logoMask.drawMask();
			backLayer.mask = logoMask;
		}
		
		protected function shatter(e:MouseEvent){
			logoBox.removeEventListener(MouseEvent.MOUSE_OVER,shatter);		// The event has happened - logoBox shouldn't continue responding
			logoBox.visible = false;										// Hide the logoBox
			var localPosition:Point = new Point (e.localX, e.localY);		// Calculate the local position of the mouse
			var speed:Number = mouseWatcher.mouseSpeed();					// Calculate the recent speed of the mouse
			triangleBox.maxSize = Math.ceil(logoBox.height * speed) + 0.25;	// Decide what is the largest amount the triangles can move, based on this speed
			triangleFill(speed);											// Fill with triangles
			reformedTriangles = 0;											// Reset the count of reformed triangles
			animateTriangles();												// Animate the triangles
		}
		
		protected function triangleFill(speed:Number):void{
			triangleBox.x = logoBox.x;
			triangleBox.y = logoBox.y;
			var measuringTriangle:TweenTriangle = new TweenTriangle();		// Create a triangle but don't add to the stage. Let's us measure widths
			offset = new Point(0,0);										// Offset from origin is required for positioning some triangles 
			triangleFillFace(speed,measuringTriangle.height);				// Treat the face of the logo as a rectangle - we'll add a white triangle later to clip it 
			addIndividualTriangle(offset, 0, 'white');						// Add the white one to clip the top left corner
			offset = new Point(0, logoBox.height - measuringTriangle.height); // Add the sticking out one at the bottom left corner
			addIndividualTriangle(offset, 0);
		}
		
		protected function triangleFillFace(speed:Number,offset:Number):void{
			var segments:Object = calculateSegments(speed);					// Work out how many triangles to add
			var desiredWidth = logoBox.width / segments.x;					// Size triangles correctly	
			var desiredHeight = (logoBox.height - offset)/ segments.y;
			// Add them
			triangleFillOrient(segments.x, segments.y, desiredWidth, desiredHeight, 0);
			triangleFillOrient(segments.x, segments.y, desiredWidth, desiredHeight, 180);
		}
		
		protected function calculateSegments(speed:Number = 1):Object{
			var segments:Object = {x:Math.ceil(speed), y:Math.ceil(speed)};
			return segments;
		}
		
		protected function triangleFillOrient(segmentsX:int, segmentsY:int, desiredWidth:Number, desiredHeight:Number, tRotation:int=0){
			for (var rows:int = 0; rows < segmentsX; rows++){
				for (var columns:int = 0; columns < segmentsY; columns++){
					// Get a new one
					var newTriangle:TweenTriangle = new TweenTriangle();
					newTriangle.rotation = tRotation;					// Rotate it
					newTriangle.width = desiredWidth;					// Scale it
					newTriangle.height = desiredHeight;
					var origin:Point =  new Point();					// Position it
					if (tRotation){
						origin.x = (columns * newTriangle.width) + newTriangle.width;
						origin.y = (rows * newTriangle.height) + newTriangle.height;
					} else {
						origin.x = columns * newTriangle.width;
						origin.y = rows * newTriangle.height;
					}
					newTriangle.origin = origin.add(offset);
					newTriangle.cacheAsBitmap = true;
					triangleBox.addChild(newTriangle);					// Add it to the stage
					triangles.push(newTriangle);						// Add it to the array
				}
			}
		}
		
		protected function addIndividualTriangle(origin:Point, tRot:Number = 0, type:String = 'black'):void{
			var newTriangle:TweenTriangle = getTriangle(type);
			newTriangle.origin = origin;
			newTriangle.rotation = tRot;
			triangleBox.addChild(newTriangle);
			triangles.push(newTriangle);
		}
		
		protected function getTriangle(type:String):TweenTriangle{
			switch(type){
				case 'white'	:	return(new WhiteTriangle);
				case 'black'	:	return(new TweenTriangle);
				default			:	return(null);
			}
		}
		
		protected function animateTriangles():void{
			// Start moving the triangles at a speed based on their size
			for (var i:int = 0; i < triangles.length; i++){
				triangles[i].vector = new Point (2.5 - (Math.random() * 5), 2.5 - (Math.random() * 5));
				triangles[i].addEventListener(Event.ENTER_FRAME, triangles[i].animate);
				triangles[i].addEventListener(TriangleEvent.ORIGIN_REACHED, trianglesReforming);
				triangleBox.addEventListener(BoundaryEvent.MAX_REACHED, triangles[i].reform);
			}
			// Will also have to tell the boundary to inform us if the triangles have travelled far enough
			triangleBox.addEventListener(Event.ENTER_FRAME, triangleBox.maxReached);
		}

		protected function trianglesReforming(e:Event){
			e.target.removeEventListener(TriangleEvent.ORIGIN_REACHED, trianglesReforming);
			reformedTriangles++;											// Add this to the count
			if (reformedTriangles == triangles.length){
				reset();
			}
		}
		
		protected function reset():void{
			// Clear all triangles. Listeners have already been removed
			for (var i:int =0; i < triangles.length; i++){
				triangleBox.removeChild(triangles[i]);
			}
			triangles.splice(0);											// Empty the triangles array
			logoBox.visible = true;											// Reshow the logoBox
			logoBox.addEventListener(MouseEvent.MOUSE_OVER,this.shatter);	// Reinstate the mouse listener
		}
		
		
		
		
		
	}
}