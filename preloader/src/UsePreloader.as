/***********************************************************************************\
*																					*
* This class is an example of how to use the Autofuss preloader. 					*
*																					*
* Each time you wish to use the preloader, create a copy of preloader.fla and size	*
*  the stage to match the movie you will be preloading. Set UsePreloader as the 	*
*  document class. Copy UsePreloader.as into the same directory as preloader.fla	*
*  and change the line "preloader.loadSWF('...');" to match the location of your 	*
*  movie to be preloaded. Publish the preloader.fla and embed the resulting swf in	*
*  your web page.																	*
*																					*
* You can preload from a network location by supplying the full URL. The domains of	*
*  the preloader and preloaded movie must match however or a sandbox security error	*
*  will occur.																		*
*																					*
* Peter Hastie - 9th June 2008														*
*																					*
\***********************************************************************************/

package{
	
	import flash.display.Sprite;
	
	import flash.display.Loader;
	
	import flash.events.Event;
	import com.sillypog.loaders.LoaderMessage;				// Contains the strings required by the preloader
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import com.autofuss.preloader.AutofussPreloader;		// The specific implementation of the visuals for AutofussPreloader. It extends AbstractPreloader which deals with loading data.
	
	public class UsePreloader extends Sprite{
		
		var preloader:AutofussPreloader;					// The instance of the preloader class
		var mainContent:Loader;									// The container which copies the loaded data out of the preloader which can then be destroyed
		
		/***************\
		* Constructor	*
		\***************/
		public function UsePreloader():void{
			preloader = new AutofussPreloader();												// Instantiate the Autofuss preloader
			addChild(preloader);																// Display it on the stage
			preloader.addEventListener(LoaderMessage.START_APP,getApp);							// Allow the preloader to inform us that the data is ready
			preloader.loadSWF('../Animating Logos/New Production Version/shatterlogo.swf');	// Begin downloading. This line is changed for each swf loaded. A URL can be supplied but the content must be in the same sandbox
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		public function getApp(e:Event){
			preloader.removeEventListener(LoaderMessage.START_APP,getApp);	// Stop listening for the event now it has happened. Helps with garbage collection
			mainContent = preloader.getContent();							// Copy the movie from the preloader
			
			// Clean up
			removeChild(preloader);											// Remove the preloader animation from the stage
			preloader = null;												// Remove the preloader from memory
			
			// Set the stage for the application
			stage.align = StageAlign.TOP_LEFT;								// Ensure downloaded movie aligns to the top left of the stage
			stage.scaleMode = StageScaleMode.SHOW_ALL;						// Don't let the movie scale automatically, make it respond to stage resize as required
			
			// Add the content
			addChild(mainContent);											// Add the downloaded movie to the stage. It should be immediately visible
		}
		
	}
}