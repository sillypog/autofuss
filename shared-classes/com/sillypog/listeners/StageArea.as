package com.sillypog.listeners{
	
	/***********************************************************\
	* Drag an instance of a StageArea sprite on to the stage	*
	* and you get a nice easy way of telling your model about	* 
	* stage changes	without having to rely on the stage itself	*
	\***********************************************************/
	
	import flash.display.Sprite;
	
	import com.sillypog.patterns.mvc.IModel;
	
	import flash.events.Event;
	import com.sillypog.events.MessageEvent;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.system.Capabilities;
	
	public class StageArea extends Sprite{
		
		private var model:IModel;
		private var theStage:Stage;
		
		
		private var resX:int;
		private var resY:int;
		private var ratio:Number;
		
		
		/***************\
		* Constructor	*
		\***************/
		public function StageArea():void{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		public function setModel(m:IModel):void{
			// Save a reference to the model
			model = m;
			// Send stage events to it
			theStage.align = StageAlign.TOP_LEFT;
			theStage.scaleMode = StageScaleMode.NO_SCALE; 
			theStage.addEventListener(Event.RESIZE, resized); // the resize event never triggers!
			trace('StageArea: setModel()');
		}
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function resized(e:Event):void{
			trace('StageArea: resized(). Height:'+e.target.stageHeight+', width:'+e.target.stageWidth);
			
			width = e.target.stageWidth;
			//height = e.target.stageHeight;
			// Preserve aspect ratio (550/400)
			//height = width * (400/550);
			height = width * ratio;
			x = 0;
			y = 0;
			
			// Send the height & width of the stage area
			var message:MessageEvent = new MessageEvent(Event.RESIZE,{width:width, height:height});
			model.processMessage(message);
			
		}
		
		protected function init(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace('StageArea: init(). Stage is: height: '+this.stage.stageHeight+', width: '+this.stage.stageWidth); // The output from this line is as expected. So what's up?
			theStage = this.stage;
			
			trace('StageArea: init(). Resolution - x:'+Capabilities.screenResolutionX +', y:'+Capabilities.screenResolutionY);
			resX = Capabilities.screenResolutionX;
			resY = Capabilities.screenResolutionY;
			ratio = resY/resX;
		}
		
	}
}