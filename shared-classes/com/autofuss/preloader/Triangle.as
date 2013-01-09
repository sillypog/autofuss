package com.autofuss.preloader {
	
	import flash.display.Sprite;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.None;
	
	import flash.geom.Point;
	
	import flash.events.Event;
	
	public class Triangle extends BlackTriangle{
		
		private const TOP:String = "Top";
		private const BOTTOM:String = "Bottom";
		private const LEFT:String = "Left";
		private const RIGHT:String = "Right";
		
		private const LOGO_FACE_W:Number = 77;
		private const LOGO_FACE_H:Number = 89;
		
		private const MIN_HEIGHT:Number = 6.7;
		private const MIN_WIDTH:Number = 7.1;
		
		private const MAX_HEIGHT:Number = 33.5;
		private const MAX_WIDTH:Number = 35.5;
		
		private const MIN_SCALE:Number = 1.0;
		private const MAX_SCALE:Number = 5.0;
		private const ROTATIONS:Array = [0,45,90,135,180,225,270,315];
		
		private var frontLayer:TriangleArea;
		private var rearLayer:TriangleArea;
		private var currentLayer:TriangleArea;
		
		private var currentEdge:String;		// The edge that the animation is heading towards
		private var tweenPoint:Point;
		private var currentScale:Number;
		private var currentRotation:Number;
		
		private var finalPosition:TrianglePosition;
		
		private var tweens:Array;
		
		private var finalising:Boolean;
		
		/***************\
		* Constructor	*
		\***************/
		public function Triangle(fLayer:TriangleArea, rLayer:TriangleArea):void {
			frontLayer = fLayer;
			rearLayer = rLayer;
			
			init();
			animate();
		}
		
		
		public function consolidate(tp:TrianglePosition):void{
			finalPosition = tp;
		}
		
		/*******************\
		* Private methods	*
		\*******************/
		private function init():void{
			// Save layer info
			currentLayer = rearLayer;
			// Position the triangle at the centre of the rearLayer. Animation will swap it to the front
			x = (currentLayer.originalSize / 2) - (width / 2);
			y = (currentLayer.originalSize / 2) - (height / 2);
			currentScale = 1.0;
			currentRotation = 0.0;
			//Add it
			currentLayer.addChild(this);
			// Instantiate the tween variables
			tweens = new Array();
			tweenPoint = new Point(x,y);
		}
		
		private function animate():void{
			// Swap layer
			swapLayer();
			// Choose a random size to become
			chooseSize();
			// Choose a rotation
			chooseRotation();
			// Choose a random edge of the area to move to
			currentEdge = chooseEdge();
			// Choose a random point along that edge
			choosePoint();
			// Do these as a tween
			doTween();
		}
		
		
		private function swapLayer():void{
			var oldLayer:Sprite = currentLayer;
			currentLayer = (currentLayer == frontLayer) ? rearLayer : frontLayer;
			oldLayer.removeChild(this);
			currentLayer.addChild(this);
		}
		
		private function chooseEdge():String{
			var edges:Array = new Array(TOP, BOTTOM, LEFT, RIGHT);
			if (currentEdge){
				// Splice out the current value from edges
				edges.splice(edges.indexOf(currentEdge),1);
				// Now pick an edge from the remaining 3
				return (edges[ Math.floor(Math.random() * 3) ]);
			} else {
				return (edges[ Math.floor(Math.random() * 4) ]);
			}
		}
		
		private function choosePoint():void{
			switch(currentEdge){
				case TOP	:	tweenPoint.x = (Math.random() * currentLayer.originalSize); 
								tweenPoint.y = 0;
								break;
				case BOTTOM	:	tweenPoint.x = (Math.random() * currentLayer.originalSize);
								tweenPoint.y = currentLayer.originalSize;	
								break;
				case LEFT	:	tweenPoint.x =  0;
								tweenPoint.y = (Math.random() * currentLayer.originalSize);
								break;
				case RIGHT	:	tweenPoint.x = currentLayer.originalSize; 			
								tweenPoint.y = (Math.random() * currentLayer.originalSize);
								break;
				default		:	throw new Error('Triangle: choosePoint(): no edge assigned');
								break;
			}
		}
				
		private function chooseSize():void{
			// Want to scale it such that it maintains aspect ratio
			currentScale = (Math.random() * (MAX_SCALE - MIN_SCALE)) + MIN_SCALE
		}
		
		private function chooseRotation():void{
			currentRotation = ROTATIONS[Math.floor(Math.random() * ROTATIONS.length)]; 
		}
		
		private function doTween():void{
			var xTween = new Tween(this,"x",Regular.easeInOut, x, tweenPoint.x, 1, true);
			var yTween = new Tween(this,"y",Regular.easeInOut, y, tweenPoint.y, 1, true);
			var scaleXTween = new Tween(this,"scaleX",None.easeIn, scaleX, currentScale, 1, true);
			var scaleYTween = new Tween(this,"scaleY",None.easeIn, scaleY, currentScale, 1, true);
			var rotTween = new Tween(this,"rotation",None.easeIn, rotation, currentRotation, 0.1, true);
			// Save the tweens
			tweens.push(xTween,yTween,scaleXTween,scaleYTween,rotTween);
			//Listen for complete events
			for (var i:int = 0; i < tweens.length; i++){
				Tween(tweens[i]).addEventListener(TweenEvent.MOTION_FINISH, removeTween);
			}
		}
		
		private function removeTween(e:TweenEvent = null):void{
			e.target.removeEventListener(TweenEvent.MOTION_FINISH, removeTween);
			tweens.splice(tweens.indexOf(e.target),1);
			if (tweens.length == 0){
				if (!finalPosition){
					animate();
				} else if (!finalising){
					gotoFinal();
				} else {
					// It has got to final position. Send out an event so we can wrap up
					var completeEvent:TriangleEvent = new TriangleEvent(TriangleEvent.FINAL_POSITION);
					dispatchEvent(completeEvent);
				}
			}
		}
		
		private function gotoFinal():void{
			// Switch on the finalising flag
			finalising = true;
			if (currentLayer != rearLayer){
				swapLayer();
			}
			// Get the position of the top left of the logo within this box. It will be at the centre, minus the width/height of that part of the sprite
			var relativeLogoPos:Point = new Point();
			relativeLogoPos.x = (currentLayer.originalSize / 2) - (LOGO_FACE_W / 2);
			relativeLogoPos.y = (currentLayer.originalSize / 2) - (LOGO_FACE_H / 2);
			
			
			// Tween the shape
			var xTween = new Tween(this,"x",Regular.easeInOut, x, finalPosition.coords.x + relativeLogoPos.x, 1, true);
			var yTween = new Tween(this,"y",Regular.easeInOut, y, finalPosition.coords.y + relativeLogoPos.y, 1, true);
			var scaleXTween = new Tween(this,"scaleX",None.easeIn, scaleX, finalPosition.newScale, 1, true);
			var scaleYTween = new Tween(this,"scaleY",None.easeIn, scaleY, finalPosition.newScale, 1, true);
			var rotTween = new Tween(this,"rotation",Regular.easeInOut, rotation, finalPosition.rot, 0.1, true);
			// Save the tweens
			tweens.push(xTween,yTween,scaleXTween,scaleYTween,rotTween);
			//Listen for complete events
			for (var i:int = 0; i < tweens.length; i++){
				Tween(tweens[i]).addEventListener(TweenEvent.MOTION_FINISH, removeTween);
			}
		}
		
	}
}