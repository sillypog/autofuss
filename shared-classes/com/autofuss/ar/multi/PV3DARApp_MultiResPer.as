package com.autofuss.ar.multi {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.pv3d.FLARCamera3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;
	

	[SWF(width=640,height=480,frameRate=60,backgroundColor=0x0)]

	public class PV3DARApp_MultiResPer extends ARAppBase_MultiResPer {
		
		//private static const PATTERN_FILE:String = "Data/patt.hiro";	//pete - commented out because PATTERN_FILE defined in subclasses
		//private static const CAMERA_FILE:String = "Data/camera_para.dat";
		
		protected var _base:Sprite;
		protected var _viewport:Viewport3D;
		protected var _camera3d:FLARCamera3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		protected var _baseNode:FLARBaseNode;
		
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		protected var modelList:Array;			// Holds references to the models 
		
		
		public function PV3DARApp_MultiResPer() {
		}
		
		protected override function init(cameraFile:String, patternList:Array, codeWidths:Array, patternResolutions:Array, patternPercentages:Array, canvasWidth:int=320, canvasHeight:int=240):void {
			this.addEventListener(Event.INIT, this._onInit, false, int.MAX_VALUE);
			super.init(cameraFile, patternList, codeWidths, patternResolutions, patternPercentages);
		}
		
		private function _onInit(e:Event):void {
			trace('PV3DARApp_MultiResPer: _onInit()');
			this.removeEventListener(Event.INIT, this._onInit);
			
			this._base = this.addChild(new Sprite()) as Sprite;
			
			this._capture.width = 640;
			this._capture.height = 480;
			this._base.addChild(this._capture);
			
			this._viewport = this._base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			this._viewport.scaleX = 640 / 320;
			this._viewport.scaleY = 480 / 240;
			this._viewport.x = -4; // 4pix ???
			
			this._camera3d = new FLARCamera3D(this._param);
			
			this._scene = new Scene3D();
			this._baseNode = this._scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			this._renderer = new LazyRenderEngine(this._scene, this._camera3d, this._viewport);
			
			this.stage.addChild(new StatsView(this._renderer));
			
			this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
		}
		
		protected function _onEnterFrame(e:Event = null):void {
			
			this._capture.bitmapData.draw(this._video);
			
			// Special for multi - run this part for each marker
								
			var activeModel:int = -1;			// This will hold the index of the model to display
			
			// Not totally clear what i'm supposed to be looping over. 
			// I think it should be the contents of detector.ResultHolder but this can't be accessed as it is
			// Having said that, this is working!
			//var i:int = 0;			// And this shows all models even if only 1 marker on screen. So I guess it isn't indexing the marker list.
			var confidentMatchIndeces:Array = new Array();	// This will store any confident matches
			for (var i:int = 0; i < this._patternList.length; i++){
				// First of all, we want to flag this model to be off as default
				this.modelList[i].visible = false;
				if (this._detector.detectMarkerLite(this._raster, 80) && this._detector.getConfidence(i) > 0.5) {
					//trace('Should add to array');
					// add to the list of confident matches
					confidentMatchIndeces.push(i);
				} 
			}
			
			// Sort the array to get the most confident match
			//trace('Length before sort: '+confidentMatchIndeces.length);
			confidentMatchIndeces = confidentMatchIndeces.sort();
			//trace('Length after sort: '+confidentMatchIndeces.length);
			
			
			if (confidentMatchIndeces.length > 0){
				var mostConfident:Number = confidentMatchIndeces[0];
				//trace('We have a confident result');
				// Get transform for most confident match
				this._detector.getTransmationMatrix(mostConfident,this._resultMat);
				this._baseNode.setTransformMatrix(this._resultMat);
				activeModel = this._detector.getARCodeIndex(mostConfident);
			}
			
			// Now we want to go through and decide which model should be shown (hopefully just one!)
			// Checking that activeModel is set prevents rendering at the wrong time
			if (activeModel > -1){
				trace ('PV3DARApp_MultiResPer: _onEnterFrame(): Should show model number ' + activeModel);
				this.modelList[activeModel].visible = true;
				this._baseNode.visible = true;
			} else {
				this._baseNode.visible = false;
			}
			
			// Finally render the scene
			this._renderer.render();
		}
		
	}
	
}