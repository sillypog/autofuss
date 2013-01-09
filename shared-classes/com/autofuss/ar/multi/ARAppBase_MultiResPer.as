/***************************************************\
* Want to respond to different patterns within a 	*
*  single marker.									*
\***************************************************/

package com.autofuss.ar.multi{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.detector.FLARMultiMarkerDetector;
	
	
	
	[Event(name="init",type="flash.events.Event")]
	[Event(name="init",type="flash.events.Event")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]

	public class ARAppBase_MultiResPer extends Sprite {
		
		private var _loader:URLLoader;
		private var _cameraFile:String;
		//private var _codeFile:String;				// This is no longer valid as we will have multiple codes
		private var _width:int;
		private var _height:int;
		//private var _codeWidth:int;				// This is no longer valid as we will have multiple codes
		
		//Multi patterns
		protected var _patternList:Array;				// Contains the filesnames of codes to load
		private var _loadNumber:int;				// The number of the file to be loaded
		private var _codesList:Array;				// Will contain the list of loaded FLARCodes
		private var _codeWidths:Array;				// Holds all the code widths
		
		protected var _param:FLARParam;
		protected var _code:FLARCode;
		protected var _raster:FLARRgbRaster_BitmapData;
		protected var _detector:FLARMultiMarkerDetector;
		
		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		
		protected var _patternResolutions:Array;		// Holds the resolutions for the pattern codes
		protected var _patternPercentages:Array;		// Holds the amount of each marker covered by pattern
		
		
		public function ARAppBase_MultiResPer() {
		}
		
		protected function init(cameraFile:String, patternList:Array, codeWidths:Array, patternResolutions:Array, patternPercentages:Array, canvasWidth:int = 320, canvasHeight:int = 240):void {
			this._cameraFile = cameraFile;
			this._width = canvasWidth;
			this._height = canvasHeight;

			
			this._patternList = patternList;		// This just contains the filenames, they have to be read first
			this._codesList = new Array();
			this._codeWidths = codeWidths;
			this._patternResolutions = patternResolutions;
			this._patternPercentages = patternPercentages;
			
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.addEventListener(Event.COMPLETE, this._onLoadParam);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
			this._loader.load(new URLRequest(this._cameraFile));
		}
		
		private function _onLoadParam(e:Event):void {
			this._loader.removeEventListener(Event.COMPLETE, this._onLoadParam);
			this._param = new FLARParam();
			this._param.loadARParam(this._loader.data);
			this._param.changeScreenSize(this._width, this._height);
			
			/*	This is where the codeFile would be loaded in but now we have several codeFiles to load in
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
			this._loader.addEventListener(Event.COMPLETE, this._onLoadCode);
			this._loader.load(new URLRequest(this._codeFile));
			*/
			// Don't use a loop to get each file - the loop probably shouldn't step on until the code has loaded
			// Instead, have each complete event trigger the next load
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
			this._loader.addEventListener(Event.COMPLETE, this._onLoadCode);
			this._loader.load(new URLRequest(this._patternList[this._loadNumber]));	
		}
		
		private function _onLoadCode(e:Event):void{
			//trace('ARAppBase_MultiResPer: _onLoadCode()');
			// Make a temporary variable to hold the code
			var currentResolution:int = this._patternResolutions.shift();
			var currentPercentage:int = this._patternPercentages.shift();
			var tempCode:FLARCode = new FLARCode(currentResolution, currentResolution, currentPercentage, currentPercentage);
			tempCode.loadARPatt(this._loader.data);
			// Push the new FLARCode onto the list
			this._codesList.push(tempCode);
			
			// Check if that was the last file. If not, load the next
			if (this._loadNumber < this._patternList.length - 1){
				this._loadNumber ++
				this._loader.load(new URLRequest(this._patternList[this._loadNumber]));
			} else {
				this._loader.removeEventListener(Event.COMPLETE, this._onLoadCode);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
				this._loader = null;
				// Set up camera
				setupCamera();
			}
		}
		
		private function setupCamera():void{
			// setup webcam
			this._webcam = Camera.getCamera();
			if (!this._webcam) {
				this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, 'no webcam!'));
				return;
			}
			this._webcam.setMode(this._width, this._height, 30);
			this._video = new Video(this._width, this._height);
			this._video.attachCamera(this._webcam);
			this._capture = new Bitmap(new BitmapData(this._width, this._height, false, 0), PixelSnapping.AUTO, true);
			
			// setup ARToolkit
			this._raster = new FLARRgbRaster_BitmapData(this._capture.bitmapData);
			//FLARMultiMarkerDetector(i_param:FLARParam, i_code:Array, i_marker_width:Array, i_number_of_code:int)
			this._detector = new FLARMultiMarkerDetector(this._param, this._codesList, this._codeWidths, this._codesList.length);
			
			
			this.dispatchEvent(new Event(Event.INIT));
		}
		
	}
	
}		
	
	