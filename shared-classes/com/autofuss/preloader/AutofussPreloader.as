package com.autofuss.preloader{
	
	import com.sillypog.loaders.AbstractPreloader;
	import com.sillypog.loaders.IPreloaderVisuals;
	
	import com.autofuss.background.MaskArea;
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.ErrorEvent;
	
	import com.sillypog.loaders.LoaderMessage;
	
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	import flash.geom.Point;
	
	public class AutofussPreloader extends AbstractPreloader implements IPreloaderVisuals{
		
		private var rearLayer:TriangleArea;
		private var maskArea:MaskArea;
		private var frontLayer:TriangleArea;
		
		private var triangles:Array;
		private var firstTriangle:Triangle;
		
		private var finishedTriangles:int;
		
		private var endingAnimation:FinalAnimation;
		
		
		/***************\
		* Constructor	*
		\***************/
		public function AutofussPreloader():void{}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		override public function processMessage(message:Event):void{
			super.processMessage(message);
			if (message is ErrorEvent){
				displayError();
			}
		}
		
		public function triangleFinished(e:Event){
			e.target.removeEventListener(TriangleEvent.FINAL_POSITION, triangleFinished);
			finishedTriangles++;
			if (finishedTriangles == triangles.length){
				finishAnimation();
			}
		}
		
		public function startApplication(e:Event){
			// Remove any remaining preloader stuff
			endingAnimation.removeEventListener(Event.COMPLETE, startApplication);
			stage.removeEventListener(Event.RESIZE,endingAnimation.recentre);
			removeChild(endingAnimation);
			endingAnimation=null;
			
			// Let application know that data is ready for display
			var startAppEvent = new Event(LoaderMessage.START_APP);
			dispatchEvent(startAppEvent);
		}
		
		public function displayError():void{
			// Remove everything from the stage
			clearStage();
			// Display the error
			var errorBox:ErrorMessage = new ErrorMessage();
			errorBox.x = (stage.stageWidth / 2) - (errorBox.width / 2);
			errorBox.y = (stage.stageHeight / 2) - (errorBox.height / 2);
			stage.addEventListener(Event.RESIZE, errorBox.recentre);
			addChild(errorBox);
		}
		
		
			
		
		/*******************\
		* Protected methods *
		\*******************/
		override protected function drawAssets():void{
			setStage();
			setMaskArea();
			setTriangleLayers();
			maskRearLayer();
			
			triangles = new Array();
			addTriangle();
		}
		
		override protected function progressEvent(currentProgress:Number):void{
			// Add a new triangle for every 5 percent progress made
			while (currentProgress/5 > triangles.length){
				addTriangle();
			}
		}
		
		override protected function dataLoaded():void{
			consolidate();
		}
		
		
		/*******************\
		* Private methods	*
		\*******************/
		private function setStage(sMode:String = StageScaleMode.NO_SCALE, sAlign:String = StageAlign.TOP_LEFT):void{
			stage.scaleMode = sMode;
			stage.align = sAlign;
		}
		
		private function setMaskArea():void{
			maskArea = new MaskArea();
			addChild(maskArea);
			maskArea.drawMask();
			stage.addEventListener(Event.RESIZE, maskArea.resized);
		}
		
		private function setTriangleLayers():void{
			
			rearLayer = new TriangleArea();
			addChild(rearLayer);
			rearLayer.drawArea();
			stage.addEventListener(Event.RESIZE, rearLayer.resized);
			
			frontLayer = new TriangleArea();
			addChild(frontLayer);
			frontLayer.drawArea();
			stage.addEventListener(Event.RESIZE, frontLayer.resized);
			
		}
		
		private function maskRearLayer():void{
			rearLayer.mask = maskArea;
		}
		
		private function addTriangle():void{
			var newTriangle = new Triangle(frontLayer, rearLayer);
			triangles.push(newTriangle);
		}
		
		private function consolidate():void{
			// Send the triangles to their final coordinates
			var finalPositions:Array = new Array();
			
			// Put in the positions, relative to the top left of the logo
			finalPositions[0] = new TrianglePosition(0,0.8,0,6);
			finalPositions[1] = new TrianglePosition(77,0.8,90,6);
			finalPositions[2] = new TrianglePosition(77,81.6,180,6);
			finalPositions[3] = new TrianglePosition(0,81.6,270,6);
			finalPositions[4] = new TrianglePosition(38.6,36.6,225,7);
			finalPositions[5] = new TrianglePosition(38.6,45.5,45,7);
			finalPositions[6] = new TrianglePosition(0,40.9,315,8);
			finalPositions[7] = new TrianglePosition(77,41.5,135,8);
			finalPositions[8] = new TrianglePosition(0,36.7,0,1);
			finalPositions[9] = new TrianglePosition(77,41.3,90,1);
			
			finalPositions[10] = new TrianglePosition(0,0.8,0,6);
			finalPositions[11] = new TrianglePosition(77,0.8,90,6);
			finalPositions[12] = new TrianglePosition(77,81.6,180,6);
			finalPositions[13] = new TrianglePosition(0,81.6,270,6);
			finalPositions[14] = new TrianglePosition(38.6,36.6,225,7);
			finalPositions[15] = new TrianglePosition(38.6,45.5,45,7);
			finalPositions[16] = new TrianglePosition(0,40.9,315,8);
			finalPositions[17] = new TrianglePosition(77,41.5,135,8);
			finalPositions[18] = new TrianglePosition(0,36.7,0,1);
			finalPositions[19] = new TrianglePosition(77,41.3,90,1);
			
			
			finishedTriangles = 0;
			
			for (var i:int = 0; i < triangles.length; i++){
				triangles[i].addEventListener(TriangleEvent.FINAL_POSITION, triangleFinished);
				triangles[i].consolidate(finalPositions[i]);
			}
		}
		
		private function finishAnimation():void{
			// Get rid of everything from the stage and play a movieclip
			clearStage();
			
			// Draw the ending animation
			endingAnimation = new FinalAnimation();
			endingAnimation.x = (stage.stageWidth / 2);
			endingAnimation.y = (stage.stageHeight / 2);
			endingAnimation.addEventListener(Event.COMPLETE,startApplication);
			stage.addEventListener(Event.RESIZE,endingAnimation.recentre);
			addChild(endingAnimation);
		}
		
		private function clearStage():void{
			triangles.splice(0);
			triangles = null;
			
			stage.removeEventListener(Event.RESIZE, rearLayer.resized);
			stage.removeEventListener(Event.RESIZE, frontLayer.resized);
			stage.removeEventListener(Event.RESIZE, maskArea.resized);
			
			removeChild(rearLayer);
			removeChild(maskArea);
			removeChild(frontLayer);
			
			
			rearLayer = null;
			frontLayer = null;
			maskArea = null;
			
		}
		
		

	
	}
}