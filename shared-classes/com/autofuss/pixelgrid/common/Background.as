package com.autofuss.pixelgrid.common{
	
	import com.sillypog.patterns.mvc.AbstractView;
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.observer.ISubject;
	
	import flash.display.Sprite;
	import flash.display.Shape;
	
	import flash.events.Event;
	import com.sillypog.events.MessageEvent;
	
	import flash.geom.ColorTransform;
	
	import flash.display.StageDisplayState;
	
	public class Background extends AbstractView {
		
		private var backgroundBox:Shape;
		
		/***************\
		* Constructor	*
		\***************/
		public function Background(m:IModel, t:Sprite=null):void{
			super(m,t);
			viewName = 'Background View';
			drawBox(); 
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		override public function update(o:ISubject, notification:Event):void{
			switch(notification.type){
				case GridMessage.RECOLOUR	:	recolour(notification);			break;
				case GridMessage.FULLSCREEN	:	toggleDisplay();				break;
			}
		}
		
		
		
		/*******************\
		* Protected methods *
		\*******************/
		protected function drawBox():void{
			backgroundBox = new Shape();
			target.addChild(backgroundBox);
			backgroundBox.graphics.beginFill(0xFFFFFF);   
			backgroundBox.graphics.drawRect(0,0,backgroundBox.stage.stageWidth,backgroundBox.stage.stageHeight);  
			backgroundBox.graphics.endFill();
		}
		
		protected function recolour(notification:Event):void{
			// Unpack the event
			var newColour:uint = uint(MessageEvent(notification).messageInfo);
			// Use ColorTransform to change rectangle colour
			var c:ColorTransform = new ColorTransform();
   			c.color = newColour;
   			backgroundBox.transform.colorTransform = c;
		}
		
		protected function toggleDisplay():void{
			switch(target.stage.displayState) {
                case StageDisplayState.NORMAL:
                    target.stage.displayState = StageDisplayState.FULL_SCREEN;    
                    break;
                case StageDisplayState.FULL_SCREEN:
                default:
                    target.stage.displayState = StageDisplayState.NORMAL;    
                    break;
            }
			trace('Background: toggleDisplay(): now in '+target.stage.displayState);
		}
		
		
	}
}