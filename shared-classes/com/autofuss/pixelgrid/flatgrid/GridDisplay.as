package com.autofuss.pixelgrid.flatgrid{
	
	import com.sillypog.patterns.mvc.AbstractView;
	
	import com.sillypog.patterns.mvc.IModel;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import com.sillypog.events.MessageEvent;
	import com.sillypog.errors.MessageError;
	import com.autofuss.pixelgrid.common.GridMessage;
	
	import com.sillypog.patterns.observer.ISubject;
	
	import com.autofuss.pixelgrid.common.GridModel;
	
	import flash.display.BitmapData;
	
	import flash.display.StageDisplayState;
	import flash.geom.Point;
	
	public class GridDisplay extends AbstractView{
		
		// Sprite references
		protected var gridContainer:Sprite;
		protected var logos:Array;
		
		// Measurment variables
		private const OFFSET_FRACTION:Number = 0.093;	// The fraction of the logo NOT in the main box
		protected const MIN_SIZE:Number = 1.0;
		
		protected var logoPadding:int;
		protected var logoWidth:Number;
		protected var logoHeight:Number;
		protected var triangleOffset:Number;
		
		// See if we can lock in a position for the grid
		protected var containerPosition:Point;			// Stores the position of the grid in 
		protected var targetDimensions:Object;
	
		/***************\
		* Constructor	*
		\***************/
		public function GridDisplay(m:IModel, t:Sprite=null):void{
			super(m,t);
			viewName = 'GridDisplay View';
			
			logos = new Array();	// Instantiate this now so we don't have to redo when tiles are reapplied
			
			drawView();
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		override public function update(o:ISubject, notification:Event):void{
			switch (notification.type){
				case GridMessage.PARAMETERS	:	measure(MessageEvent(notification).messageInfo);							break;
				case GridMessage.CAMERA_READY:																				break;
				case GridMessage.VIDEO_READY:																				break;
				case GridMessage.INTERVAL	:	updateDisplay(BitmapData(MessageEvent(notification).messageInfo));			break;
				case GridMessage.INVERSION	:	invertDisplay(MessageEvent(notification).messageInfo);						break;
				default						:																				break;
			}
			
		}
		
	
		/*******************\
		* Protected methods	*
		\*******************/
		protected function drawView():void{
			trace('OFFSET_FRACTION: '+getOFFSET_FRACTION());
			// Add a container sprite to the stage
			gridContainer = new Sprite();
			target.addChild(gridContainer);
			
			// Save the target dimensions to help when working with fullscreen
			targetDimensions = {width:target.width, height:target.height};
		}
		
		protected function measure(param:Object):void{
			// Only need to run this if resolution has changed
			if (param.newMeasurements){
				
				// Store the padding parameter
				if (param.padding != null){
					logoPadding = param.padding;
				}
				// Determine the size of a logo
				logoHeight = (targetDimensions.height / param.yTiles) - logoPadding;
				logoWidth = (targetDimensions.width / param.xTiles) - logoPadding;
				if ((logoHeight < MIN_SIZE) || (logoWidth < MIN_SIZE)){
					logoHeight = logoWidth = MIN_SIZE;
				}
				// Determine how big the sticking out triangle is in this one
				triangleOffset = logoHeight * getOFFSET_FRACTION();
				
				// This can trigger applyLogos
				if (logos){
					clearLogos();
				}
				applyLogos({xTiles:param.xTiles, yTiles:param.yTiles});
			}
		}
		
		/* Adding this lets measure be used by subclasses */
		protected function getOFFSET_FRACTION():Number{
			return(OFFSET_FRACTION);
		}
		
		
		protected function applyLogos(tiles:Object):void{
			// Have one for every row...
			for( var tx:uint = 0; tx < tiles.xTiles; tx++ ){
				// ...and column
				for( var ty:uint = 0; ty < tiles.yTiles; ty++ ){
					var logo:Logo;
					if (GridModel(getModel()).getValue('inverseState')){
						logo = new InverseLogo(tx,ty);
					} else {
						logo = new Logo( tx, ty );
					}
					positionLogo(logo, tx, ty);
				}
			}
			centreGrid();
		}
		
		
		/* Positions each individual tile correctly */
		protected function positionLogo(logo:Logo, tx:uint, ty:uint):void{
			logo.width = logoWidth;
			logo.height = logoHeight;
			logo.x = tx*(logo.width + logoPadding);
			// Remember to account for the sticking out triangle
			if (ty == 0){
				logo.y = ty*(logo.height + logoPadding);
			} else {
				logo.y = ty * (logo.height - triangleOffset + logoPadding );
			}
			logo.setState(0);
			logo.cacheAsBitmap = true;	// This might help speed and CPU usage
			logos.push( logo );
			gridContainer.addChild( logo );
		}
		
		protected function centreGrid():void{
			trace('CENTREGRID: target.width: '+target.width+' grid.width: '+gridContainer.width+' stage.width'+target.stage.stageWidth);
			trace('CENTREGRID: target.heig: '+target.height+' grid.heig: '+gridContainer.height+' stage.heig'+target.stage.stageHeight);
			if (target.stage.displayState == StageDisplayState.NORMAL){
				gridContainer.x = (target.width / 2) - (gridContainer.width / 2);
				gridContainer.y = (target.height / 2) - (gridContainer.height / 2);
				// Store what that position is for future
				containerPosition = new Point(gridContainer.x, gridContainer.y);
			} else {
				gridContainer.x = (targetDimensions.width / 2) - (gridContainer.width / 2);
				gridContainer.y = (targetDimensions.height / 2) - (gridContainer.height / 2);
			}
		}
		
		protected function clearLogos():void{
			// Remove the tiles
			for (var i:int=0; i< logos.length; i++){
				gridContainer.removeChild(logos[i]);
			}
			// Destroy the array
			logos.splice(0);
		}
		
		protected function updateDisplay(pixels:BitmapData):void{
			for each( var logo:Logo in logos){
				logo.setState( (pixels.getPixel( logo.xPos, logo.yPos ) >> 16 )); //just grab the red channel
			}
		}
		
		protected function invertDisplay(info:Object):void{
			clearLogos();
			var tiles:Object = {xTiles:info.xTiles, yTiles:info.yTiles};
			applyLogos(tiles);
		}
		
	}
}