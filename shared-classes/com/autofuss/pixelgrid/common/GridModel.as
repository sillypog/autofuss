package com.autofuss.pixelgrid.common{
	
	import com.sillypog.patterns.mvc.AbstractModel;
	
	import flash.events.Event;
	
	import flash.media.Camera;
	import flash.media.Video;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;
	
	import flash.net.URLLoaderDataFormat;
	
	import com.sillypog.events.MessageEvent;
	import com.sillypog.events.CustomErrorEvent;
	import com.sillypog.loaders.LoaderMessage;
	import com.sillypog.errors.MessageError;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	
	import flash.utils.Timer;
	
	/* !!! Just for debugging 
	import flash.display.ShaderData;
	import flash.display.ShaderInput;
	import flash.display.ShaderParameter;
	// !!! Just for debugging */
	
	public class GridModel extends AbstractModel{
		
		// Numbers
		private const X_RES:int = 160;		// The resolution the camera is set to. Try 64/48 or 160/120
		private const Y_RES:int = 120;
		
		private const MIN_TILES:int = 1;
		private const MAX_TILES:int = 20;
		
		private var actual_x_res:int;		// The actual resolution of the camera
		private var actual_y_res:int;
		
		private var xTiles:int;				// The desired number of tiles determined from this number
		private var yTiles:int;
		
		private var padding:int;			// The amount of padding between tiles
		
		// Display state
		private var inverseState:Boolean;	// Should normal or inverse logos be used
		private var backgroundColour:uint;	// Colour of the surrounding area
		
		
		// Filter Information
		private var shader:Shader;
		private var shFilter:ShaderFilter;
		private var threshold:Number;
		
		// Data instances
		private var camera:Camera;
		private var video:Video;
		private var pixels:BitmapData;
		
		private var loader:FilterLoader;
		
		private var framerate:int;
		private var frameTimer:Timer;
	
	
		/***************\
		* Constructor	*
		\***************/
		public function GridModel() {
			// All set up functions are handled by init
		}
		
		
		/*******************\
		* Public methods 	*
		\*******************/
		override public function processMessage(message:Event):void{
			// Non Errors
			if (!(message is CustomErrorEvent)){
				switch(message.type){
					case Event.INIT					:	init();														break;
					case Event.RESIZE				:	resized(message);											break;
					case MouseEvent.MOUSE_MOVE		:	notifyObservers(message);									break;
					case LoaderMessage.PROGRESS		:																break;
					case LoaderMessage.COMPLETE		:	applyFilter(ByteArray(MessageEvent(message).messageInfo));	break;
					case GridMessage.PARAMETERS		:	setParameters(MessageEvent(message).messageInfo);			break;
					case GridMessage.INVERSION		:	invertFilter(message);										break;
					case GridMessage.RECOLOUR		:	notifyObservers(message);									break;
					case GridMessage.FULLSCREEN		:	notifyObservers(message);									break;
					default		:	throw(new MessageError(MessageError.UNKNOWN_MESSAGE));
				}
			} else {
			// Errors
				trace('GridModel: Received an error');
				notifyObservers(message);
			}
		}
		
		public function getValue(propertyName:String):*{
			return(this[propertyName]);
		}
	
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function init():void{
			setParameters({	threshold:0.5, 
						  	resolution:10,
							padding:0, 
							framerate:50, 
							inverseState:false, 
							backgroundColour:0xFFFFFF});// Parameters to preset levels
			setupCamera();		// Connects to the camera
			loadFilter();		// Creates a binary version of the image
			createTimer(framerate);
		}
		
		protected function setParameters(param:Object):void{
			trace('GridModel: setParameters(): Iterating...');
			for (var prop:String in param){
				trace('     '+prop+': '+param[prop]);
			}
			var newMeasurements:Boolean = false;
			if (param.threshold != null){
				threshold = param.threshold;
				// If the filter has been instantiated, change the threshold
				if (shader){
					trace('GridModel: setParameters: should set threshold to '+threshold+'. Is currently '+shader.data.thresholdValue.value );
					//shader.data.thresholdValue.value = [threshold];
					applyFilter();
				}
			}
			if (param.resolution){
				var correctedResolution:int = param.resolution;
				if (param.resolution < MIN_TILES){
					trace('Too few tiles');
					correctedResolution = MIN_TILES;
				} else if (param.resolution > MAX_TILES){
					trace('Too many tiles');
					correctedResolution = MAX_TILES;
				}
				var oldXTiles:int = xTiles;
				//xTiles = correctedResolution * 4;
				xTiles = Math.floor(correctedResolution * 4.8);	// This is the actual ratio for the 300 * 480 stage
				yTiles = correctedResolution * 3;
				trace('Tile resolution set to x:'+xTiles+' y:'+yTiles);
				// If the resolution has changed, we'll have to set up the video again
				if (xTiles != oldXTiles){
					newMeasurements = true;
					if (camera){
						trace('GridModel: setParameters: camera is ready so resetting video');
						setupVideo();
						applyFilter();
					}
				}
			}
			if (param.framerate){
				framerate = param.framerate;
				if (frameTimer){
					frameTimer.delay = framerate;
					startTimer();
				}
			}
			if (param.padding != null){
				if (padding != param.padding){
					newMeasurements = true;
				}
				padding = param.padding;
			}
			// Inform listeners of these changes
			var messageInfo:Object = {	threshold: threshold,
										resolution:	correctedResolution,
										newMeasurements: newMeasurements,
										xTiles: xTiles,
										yTiles: yTiles,
										padding: padding,
										framerate: framerate,
										backgroundColour: backgroundColour };
			var bundle:MessageEvent = new MessageEvent(GridMessage.PARAMETERS,messageInfo );
			notifyObservers(bundle);
		}
		
		/* Attach camera to a video object which is not on the stage */
		protected function setupCamera():void{
			camera = Camera.getCamera();
			var message:Event;
			if (camera) {
				camera.setMode(X_RES, Y_RES, 18);
				actual_x_res = camera.width;
				actual_y_res = camera.height;
				trace('Actual sizes: '+actual_x_res+' '+actual_y_res);
				// Setup the video in a different function. That will allow us to dynamically alter video resolution
				setupVideo();
				message = new MessageEvent(GridMessage.CAMERA_READY);
			} else {
				// Send an error
				message = new CustomErrorEvent(GridMessage.CAMERA_ERROR);
			}	
			notifyObservers(message);
		}
		
		/* Set up video & bitmapdata objects sized to desired number of tiles */
		protected function setupVideo():void{
			video = new Video(xTiles, yTiles);
			video.attachCamera(camera);
			pixels = new BitmapData(xTiles, yTiles);
			var bundle = new MessageEvent(GridMessage.VIDEO_READY);
		}
		
		/* Load in the threshold filter */
		protected function loadFilter():void{
			// Only need to create the shader once. Do it now
			shader = new Shader();
			shFilter = new ShaderFilter();
			// Get a loader to get the shader into the program
			loader = new FilterLoader(this,URLLoaderDataFormat.BINARY);
			//loader.loadData('assets/Threshold.pbj');
			loader.loadData('http://www.sillypog.com/projects/pixelgrid/assets/Threshold.pbj');
		}
		
		/* Save shader data and apply it to the video */
		protected function applyFilter(bytes:ByteArray = null){
			trace('GridModel: applyFiler');
			if (bytes){
				shader.byteCode = bytes;
			}
			// Access the parameters within the newly loaded shader
			shader.data.thresholdValue.value = [threshold];
			// Apply the shader to the video. This will make a binary image
			shFilter.shader = shader;
			video.filters = [shFilter];
			
			/* //!!! Debugging code !!!
			var shaderData:ShaderData = shader.data; 
			var inputs:Vector.<ShaderInput> = new Vector.<ShaderInput>(); 
			var parameters:Vector.<ShaderParameter> = new Vector.<ShaderParameter>(); 
			var metadata:Vector.<String> = new Vector.<String>(); 
			 
			for (var prop:String in shaderData) 
			{ 
				if (shaderData[prop] is ShaderInput) 
				{ 
					inputs[inputs.length] = shaderData[prop]; 
				} 
				else if (shaderData[prop] is ShaderParameter) 
				{ 
					parameters[parameters.length] = shaderData[prop]; 
				} 
				else 
				{ 
					metadata[metadata.length] = shaderData[prop]; 
				} 
			} 
			trace('Inputs: '+inputs.length);
			trace('Parameters: '+parameters.length);
			trace('Metadata: '+metadata.length);
			trace('First param: '+parameters[0].name+' '+parameters[0].value);
			// !!! End debugging code !!! */
			
		}
		
		/* Have a timer to update display */
		protected function createTimer(interval:int):void{
			frameTimer = new Timer(interval,0);
			frameTimer.addEventListener(TimerEvent.TIMER,timerComplete);
			startTimer();
		}
		
		protected function startTimer():void{
			frameTimer.reset();
			frameTimer.start();
		}
		
		protected function timerComplete(e:TimerEvent):void{
			// Get the video data
			pixels.draw(video);
			// Let listeners know
			var message:MessageEvent = new MessageEvent(GridMessage.INTERVAL, pixels);
			notifyObservers(message);
		}
		
		/* Allow the display to resize */
		protected function resized(e:Event):void{
			var incomingInfo:Object = MessageEvent(e).messageInfo;
			var param:Object = {  height:incomingInfo.height, 
								  width:incomingInfo.width,
								  xTiles:xTiles,
								  yTiles:yTiles };
			var message:MessageEvent = new MessageEvent(Event.RESIZE,param);
			notifyObservers(message);
		}
		
		/* Invert colours in the filter */
		protected function invertFilter(message:Event):void{
			inverseState = Boolean(MessageEvent(message).messageInfo);
			
			var messageInfo:Object = {state: inverseState, 
										xTiles:xTiles,
										yTiles:yTiles };
										
			var newMessage:MessageEvent = new MessageEvent(GridMessage.INVERSION, messageInfo);
			
			notifyObservers(newMessage);
			trace('GridModel: invertFilter: '+inverseState);
		}
		
	}
}