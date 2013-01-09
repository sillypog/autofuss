package com.sillypog.errors {
	
	public class MessageError extends Error{
		
		// Constants:
		public static const UNKNOWN_MESSAGE:String = 'Unknown Message';
		// Public Properties:
		// Private Properties:
	
		// Initialization:
		public function MessageError(message:String) {
			super(message,0);
		}
	
		// Public Methods:
		// Protected Methods:
	}
	
}