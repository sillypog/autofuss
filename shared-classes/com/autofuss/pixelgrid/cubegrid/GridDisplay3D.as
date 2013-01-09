package com.autofuss.pixelgrid.cubegrid{
	
	import com.autofuss.pixelgrid.flatgrid.GridDisplay;
	
	import com.sillypog.patterns.mvc.IModel;
	import flash.display.Sprite;
	
	import com.sillypog.patterns.observer.ISubject;
	import flash.events.Event;
	import com.sillypog.events.MessageEvent;
	
	import com.autofuss.pixelgrid.common.GridModel;
	import com.autofuss.pixelgrid.flatgrid.Logo;
	
	public class GridDisplay3D extends GridDisplay{
		
		public const OFFSET_FRACTION:Number = 0.0;
		public const EDGE_OFFSET:Number = 6.8;
		
		private const DEFAULT_SPRITE_WIDTH:Number = 107.6;
		private const DEFAULT_SPRITE_HEIGHT:Number = 115.5;
		
		private const FACE_SPRITE_W_RATIO:Number = 1.429;	//115.5/80.8;
		private const FACE_SPRITE_H_RATIO:Number = 1.548;	//107.6/69.5;
		
		private var actualWidth:Number;		// Will be calculated in applyLogos and becomes logo.width
		private var actualHeight:Number;
		private var actualX:Number;			// Will be multiplied by tx and becomes logo.x
		private var actualY:Number;
		
		
		/***************\
		* Constructor	*
		\***************/
		public function GridDisplay3D(m:IModel, t:Sprite=null):void{
			super(m,t);
		}
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		
		/*******************************************************************\
		*																	*
		* drawView is the same												*
		* measure is the same because of getOFFSET_FRACTION					*
		* applyLogos will need to be completely changed						*
		\*******************************************************************/
		override protected function getOFFSET_FRACTION():Number{
			return (OFFSET_FRACTION);
		}
		
		override protected function applyLogos(tiles:Object):void{
			// Before starting the loop, calculate the values that are constant for these measurements
			actualWidth = logoWidth * FACE_SPRITE_W_RATIO;
			actualHeight = logoHeight * FACE_SPRITE_H_RATIO;
			actualX = (logoWidth - (EDGE_OFFSET * (actualWidth / DEFAULT_SPRITE_WIDTH))) + logoPadding;
			actualY = logoHeight + logoPadding;
			// Want to start in the top right, work back along the row, then do the same for each row
			for (var tx:int = tiles.xTiles-1; tx > -1; tx--){
				for (var ty:uint =0; ty < tiles.yTiles; ty++){
					var logo:Logo;
					if (GridModel(getModel()).getValue('inverseState')){
						logo = new InverseLogo3D(tx,ty);
					} else {
						logo = new Logo3D( tx, ty );
					}
					positionLogo(logo, tx, ty);
				}
			}
			centreGrid();
		}
		
		/* Positions each individual tile correctly */
		override protected function positionLogo(logo:Logo, tx:uint, ty:uint):void{
			// Use precalculated values as much as possible
			logo.width = actualWidth;
			logo.height = actualHeight;
			logo.x = tx * actualX;
			logo.y = ty * actualY;
			logo.setState(0);
			logo.cacheAsBitmap = true;	// This might help speed and CPU usage
			logos.push( logo );
			gridContainer.addChild( logo );
		}
		
		override protected function centreGrid():void{
			super.centreGrid();
			// Shift it by the half the amount that the cubes protrude at their maximum size
			var xShift:Number = ((5 * EDGE_OFFSET) * (actualWidth / DEFAULT_SPRITE_WIDTH)) / 2;
			var yShift:Number = ((5 * EDGE_OFFSET) * (actualHeight / DEFAULT_SPRITE_HEIGHT)) / 2;
			gridContainer.x += xShift;
			gridContainer.y += yShift;
		}
			
	}
}