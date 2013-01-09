﻿package {
	
	import flash.display.Sprite;
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.mvc.IView;
	
	import com.sillypog.listeners.MouseListener;
	
	import flash.events.Event;
	
	import com.autofuss.pixelgrid.common.*;
	import com.autofuss.pixelgrid.cubegrid.*;
	
	public class CubeGrid extends Sprite{
		
		public var stageArea:StageArea;
		
		private var model:IModel;
		private var backgroundView:IView;
		private var gridDisplay:IView;
		private var menuDisplay:IView;
		private var mouseListener:IView;
		
		/***************\
		* Constructor	*
		\***************/
		public function CubeGrid() {
			// Set up the model
			model = new GridModel();
			// Add assets once a stage is ready
			addEventListener(Event.ADDED_TO_STAGE, drawAssets);
		}
		
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function drawAssets(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, drawAssets);
			
			// Set up the stage
			stageArea = new StageArea();
			addChild(stageArea);
			stageArea.width = stage.stageWidth;
			stageArea.height = stage.stageHeight;
			stageArea.x = 0;
			stageArea.y = 0;
			stageArea.setModel(model);							// The background 'stage'. Listens for resizing
			
			// Set up views:
			backgroundView = new Background(model,stageArea);	// The coloured background for the stage
			gridDisplay = new GridDisplay3D(model,stageArea);	// The display of the tiles
			menuDisplay = new MenuBar(model,this);				// The display of the controls. Add directly to stage for independent resizing
			mouseListener = new MouseListener(model,stageArea);	// Sends mouse move events			
			
			// Send an init event to model
			var initEvent = new Event(Event.INIT);
			model.processMessage(initEvent);
		}
	
		
	}
}