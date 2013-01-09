package com.autofuss.background{
	
	import flash.display.Sprite;
	
	import flash.display.Shape;
	
	import flash.events.Event;
	
	/***********************************************************************************************\
	* Want to provide a mask which presents a cutout logo in the centre regardless of stage size	*
	\***********************************************************************************************/
	
	public class MaskArea extends Sprite{
		
		private var logo:LogoCutout;
		
		private var logoWidth:Number;
		private var logoHeight:Number;
		
		private var topBorder:Sprite;
		private var bottomBorder:Sprite;
		private var leftBorder:Sprite;
		private var rightBorder:Sprite;
		
		/***************\
		* Constructor	*
		\***************/
		public function MaskArea():void{}
	
	
	
		/*******************\
		* Public methods	*
		\*******************/
		public function drawMask():void{
			addElements();
			positionElements();
		}
		
		public function resized(e:Event):void{
			positionElements();
		}
		
		
		/*******************\
		* Private methods	*
		\*******************/
		private function addElements():void{
			// draw a logo
			logo = new LogoCutout();
			logoWidth = logo.width;
			logoHeight = logo.height;
			
			addChild(logo);
			
			// draw the borders
			topBorder = new Sprite();
			bottomBorder = new Sprite();
			leftBorder = new Sprite();
			rightBorder = new Sprite();
			
			addChild(topBorder);
			addChild(bottomBorder);
			addChild(leftBorder);
			addChild(rightBorder);
			
			fillGrey(topBorder);
			fillGrey(bottomBorder);
			fillGrey(leftBorder);
			fillGrey(rightBorder);
			
		}
		
		private function positionElements():void{
			// Place the logo in the centre of the stage
			logo.width = logoWidth;
			logo.height = logoHeight;
			
			logo.x = (stage.stageWidth / 2) - (logoWidth / 2);
			logo.y = (stage.stageHeight / 2) - (logoHeight / 2);
			
			// Stretch each border around it
			topBorder.x = 0;
			topBorder.y = 0;
			topBorder.height = logo.y;
			topBorder.width = stage.stageWidth;
			
			bottomBorder.x = 0;
			bottomBorder.y = logo.y + logoHeight;
			bottomBorder.height = stage.stageHeight - bottomBorder.y;
			bottomBorder.width = stage.stageWidth;
			
			leftBorder.x = 0;
			leftBorder.y = 0;
			leftBorder.height = stage.stageHeight;
			leftBorder.width = logo.x;
			
			rightBorder.x = logo.x + logoWidth;
			rightBorder.y = 0;
			rightBorder.height = stage.stageHeight;
			rightBorder.width = stage.stageWidth - rightBorder.x;
			
		}
		
		private function fillGrey(target:Sprite):void{
			// Draw a 10px square in the sprite
			target.graphics.beginFill(0x373535);
			target.graphics.drawRect(0,0,10,10);
			target.graphics.endFill();
		}
			
		
		
	}
}