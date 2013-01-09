/*******************************************************************\
*																	*
* Wrap '*grid.swf' in a preloader. This can be embedded in HTML		*
*																	*
* Peter Hastie - 8th June 2008										*
*																	*
\*******************************************************************/

package{
	
	import flash.display.Sprite;
	
	import flash.display.Loader;
	
	import flash.events.Event;
	import com.sillypog.loaders.LoaderMessage;								// Defines the message strings used in preloaders
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import com.autofuss.preloader.AutofussPreloader;						// Contains the scripting specific to the Autofuss preloader. Inherits from AbstractPreloader which loads the file
	
	
	
	public class GridPreloader extends Sprite{
		
		var preloader:AutofussPreloader;									// The instance of the preloader class
		var mainContent:Loader;												// The container which copies the loaded data out of the preloader which can then be destroyed
		
		/***************\
		* Constructor	*
		\***************/
		public function GridPreloader():void{
			preloader = new AutofussPreloader();							// Instantiate the Autofuss preloader
			addChild(preloader);											// Display it on the stage
			preloader.addEventListener(LoaderMessage.START_APP,getApp);		// Allow the preloader to inform us that the data is ready
			preloader.loadSWF('cubegrid.swf');								// Begin downloading. This line is changed for each swf loaded. A URL can be supplied but the content must be in the same sandbox
		}
		
		
		
		/*******************\
		* Private methods	*
		\*******************/
		public function getApp(e:Event){
			preloader.removeEventListener(LoaderMessage.START_APP,getApp);	// Stop listening for the event now it has happened. Helps with garbage collection
			mainContent = preloader.getContent();							// Copy the movie from the preloader
			
			// Clean up
			removeChild(preloader);											// Remove the preloader animation from the stage
			preloader = null;												// Remove the preloader from memory
			
			// Set the stage for the application
			stage.align = StageAlign.TOP_LEFT;								// Ensure downloaded movie aligns to the top left of the stage
			stage.scaleMode = StageScaleMode.NO_SCALE;						// Don't let the movie scale automatically, make it respond to stage resize as required
			
			// Add the content
			addChild(mainContent);											// Add the downloaded movie to the stage. It should be immediately visible
		}
			
	}
}