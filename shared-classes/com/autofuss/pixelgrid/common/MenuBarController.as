package com.autofuss.pixelgrid.common{
	
	import com.sillypog.patterns.mvc.AbstractController;
	
	import com.sillypog.patterns.mvc.IModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import fl.events.SliderEvent;
	import fl.events.ColorPickerEvent;
	import com.sillypog.events.MessageEvent
	
	import flash.utils.Timer;

	
	public class MenuBarController extends AbstractController{
		
		private const DELAY:int = 5000;
		private var hideTimer:Timer;
		
		/***************\
		* Constructor	*
		\***************/
		public function MenuBarController(m:IModel):void{
			super(m);
			hideTimer = new Timer(DELAY);
			hideTimer.addEventListener(TimerEvent.TIMER, hideMenu);
		}
		
		
		/*******************\
		* Public methods	*
		\*******************/
		override public function viewEvent(e:Event):void{
			switch (e.type){
				case MouseEvent.MOUSE_MOVE	:	showMenu();							break;
				case Event.CHANGE			:	selectionChange(e);					break;	
				case ColorPickerEvent.CHANGE:	colourChange(ColorPickerEvent(e));	break;
				case MouseEvent.CLICK		:	toggleFullScreen(e);				break;
				case MouseEvent.MOUSE_OVER	:	animate(e);							break;
				//case SliderEvent.CHANGE		:	sliderChange(SliderEvent(e));	break;
			}
		}
		
		public function showMenu():void{
			// Make the view visible
			MenuBar(getView()).showMenu();
			// Reset the counter
			hideTimer.reset();
			hideTimer.start();
		}
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function hideMenu(e:TimerEvent):void{
			// Hide the view
			MenuBar(getView()).hideMenu();
			// Stop the timer
			hideTimer.stop();
		}
		
		
		/* Process inversion and sliders separately */
		protected function selectionChange(e:Event):void{
			if (e is SliderEvent){
				sliderChange(SliderEvent(e));
			} else if (e is ColorPickerEvent){
				colourChange(ColorPickerEvent(e));
			} else {
				trace('Event from '+e.target.name+'. Target selection is '+e.target.selected);
				var message:MessageEvent = new MessageEvent(GridMessage.INVERSION,e.target.selected);
				getModel().processMessage(message);
			}
		}
		
		/* Send the new values to the model */
		protected function sliderChange(e:SliderEvent):void{
			var messageInfo:Object = new Object();
			messageInfo[e.target.name] = e.target.value;
			getModel().processMessage(new MessageEvent(GridMessage.PARAMETERS, messageInfo));
		}
		
		/* Send new background colour to model for distribution */
		protected function colourChange(e:ColorPickerEvent):void{
			var notification:MessageEvent = new MessageEvent(GridMessage.RECOLOUR, e.target.selectedColor);
			getModel().processMessage(notification);
		}
		
		/* Toggle fullscreen */
		protected function toggleFullScreen(e:Event):void{
			//trace('Toggle full screen: '+e.target.stage.displayState);
			var notification:MessageEvent = new MessageEvent(GridMessage.FULLSCREEN);
			getModel().processMessage(notification);
		}
		
		protected function animate(e:Event):void{
			e.target.gotoAndPlay('on');
		}
		
		
	}
}