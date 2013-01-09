package com.autofuss.shatterlogo {
	
	import flash.geom.Point;
	
	import flash.events.Event;
	
	import com.eclecticdesignstudio.gtweener.GTweener;
	
	public class TweenTriangle extends BlackTriangle{
		
		private var _origin:Point;		// where this triangle started
		private var _vector:Point;		// contains change in x and y for each frame
		
		private var	positionAtReform:Point	// The point the triangle was at when it reversed 
	
		/***************\
		* Constructor	*
		\***************/
		public function TweenTriangle() {}
	
		
		
		/*******************\
		* Public methods	*
		\*******************/
		public function get vector():Point{
			return(_vector);
		}
		
		public function set vector(v:Point):void{
			_vector = v;
		}
		
		public function get origin():Point{
			return(_origin);
		}
		
		public function set origin(o:Point):void{
			_origin = o;
			this.x = o.x;
			this.y = o.y;
		}
		
		public function animate(e:Event):void{
			x += _vector.x;
			y += _vector.y;
		}
		
		
		public function reform(e:Event):void{
			// Stop listening for animation events
			removeEventListener(Event.ENTER_FRAME, animate);
			// Tween back to the origin
			var tweenDuration:int = 3;
			GTweener.addTween (this, tweenDuration, {x:_origin.x, y:_origin.y}, {completeListener: this.reformed} );
		}
		
		
		/*******************\
		* Protected methods	*
		\*******************/
		protected function reformed(e:Event):void{
			// Dispatch an event that the triangle returned to the origin
			var rEvent = new TriangleEvent(TriangleEvent.ORIGIN_REACHED);
			dispatchEvent(rEvent);
		}
	}
}