package com.autofuss.pixelgrid.common {
	
	import com.sillypog.patterns.mvc.AbstractView;
	
	import com.sillypog.patterns.mvc.IModel;
	import com.sillypog.patterns.mvc.IController;
	import com.sillypog.patterns.observer.ISubject;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.events.SliderEvent;
	import fl.events.ColorPickerEvent;
	import com.sillypog.events.MessageEvent;
	
	public class MenuBar extends AbstractView{
		
		
		private const ORIGINAL_WIDTH:Number = 194;
		private const ORIGINAL_HEIGHT:Number = 258.72;
		
		private var menuPanel:MenuPanel;
		
		
		/***************\
		* Constructor	*
		\***************/
		public function MenuBar(m:IModel, t:Sprite=null):void{
			super(m,t);
			viewName = 'MenuBar View';
			drawView();
			MenuBarController(getController()).showMenu();
		}
	
	
	
		/*******************\
		* Public methods	*
		\*******************/
		override public function update(o:ISubject, notification:Event):void{
			switch(notification.type){
				case GridMessage.PARAMETERS	:	setSliders(MessageEvent(notification).messageInfo);	break;
				case MouseEvent.MOUSE_MOVE	:	getController().viewEvent(notification);			break;
				case Event.RESIZE			:	centre();											break;
				default						:														break;
			}
		}
		
		override public function defaultController(model:IModel):IController{
			return(new MenuBarController(model));
		}
		
		
		public function showMenu(){
			menuPanel.visible = true;
		}
		
		public function hideMenu(){
			menuPanel.visible = false;
		}
		
	
		/*******************\
		* Protected Methods	*
		\*******************/
		protected function drawView():void{
			// Have a main panel to add components too
			menuPanel = new MenuPanel();
			target.addChild(menuPanel);
			centre();						// Position the menu
			
			// Have sliders for:
				// Threshold
				// Resolution
				// Padding
				// Frame rate
			menuPanel.threshold.addEventListener(SliderEvent.CHANGE,getController().viewEvent);
			menuPanel.resolution.addEventListener(SliderEvent.CHANGE,getController().viewEvent);
			menuPanel.padding.addEventListener(SliderEvent.CHANGE,getController().viewEvent);
			menuPanel.framerate.addEventListener(SliderEvent.CHANGE,getController().viewEvent);
			// Have a toggle switch to invert colours
			menuPanel.invert.addEventListener(Event.CHANGE,getController().viewEvent);
			// Have  colour picker to select background
			menuPanel.backgroundColour.addEventListener(ColorPickerEvent.CHANGE,getController().viewEvent);
			// Also have a button to go to fullscreen
			menuPanel.fullscreen.addEventListener(MouseEvent.MOUSE_OVER,getController().viewEvent);
			menuPanel.fullscreen.addEventListener(MouseEvent.CLICK,getController().viewEvent);
		}
		
		protected function setSliders(param:Object):void{
			// Sliders have same names as parameters so if they are not null, just use property names
			for (var field:String in param){
				if ((menuPanel[field]) && (param[field])){
					menuPanel[field].value = param[field];
				}
			}
		}
		
		
		protected function centre():void{
			menuPanel.width = ORIGINAL_WIDTH;
			menuPanel.height = ORIGINAL_HEIGHT;
			menuPanel.x = (menuPanel.stage.stageWidth / 2) - (menuPanel.width / 2);
			menuPanel.y = (menuPanel.stage.stageHeight / 2) - (menuPanel.height / 2);
		}
		
		
	}
}