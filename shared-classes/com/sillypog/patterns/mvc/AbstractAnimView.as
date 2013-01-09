package com.sillypog.patterns.mvc {
	
	import com.sillypog.patterns.mvc.AbstractView;
	
	import com.sillypog.patterns.mvc.IModel;
	
	public class AbstractAnimView extends AbstractView{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		animationCentre:Object;			// Contains a reference to some kind of tweener object
	
		// Initialization:
		public function AbstractAnimView(m:IModel, t:Sprite, ac:Object) { 
			super(m,t);
			animationCentre = ac;
		}
	
		// Public Methods:
		// Protected Methods:
	}
	
}