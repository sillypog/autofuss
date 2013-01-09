package com.sillypog.errors {
	
	public class AbstractMethodError extends Error{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private const ERROR_MESSAGE:String = 'Abstract method not overridden in ';
	
		// Initialization:
		public function AbstractMethodError(callingClass:String) {
			
			var message:String = ERROR_MESSAGE+callingClass
			// The errorID is 0.
			super(message, 0);
		}
	
		// Public Methods:
		// Protected Methods:
	}
	
}