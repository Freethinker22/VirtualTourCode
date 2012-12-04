package classes // This class builds the construct for a scrollbar
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.filters.DropShadowFilter;
	
	public class ScrollbarConstruct extends Sprite
	{
		private var _theme:Theme; // Reference to the Theme class
		
		// Button vars
		protected var _upScrollBtn:SimpleButton; // Object that becomes the up scroll button
		protected var _downScrollBtn:SimpleButton; // Object that becomes the down scroll button
		protected var _dragHandle:SimpleButton; // Object that becomes the drag handle
		protected var _track:Sprite; // Object that becomes the track
		protected var _scrollbar:Sprite; // Object that holds all of the objects in the scroll bar
		
		// Settable vars
		private var _trackWidth:Number; // Incoming width of the track
		private var _trackHeight:Number; // Incoming height of the track
		private var _dragHandleUp:Sprite; // Library reference to the scrollbar's drag handle up state
		private var _dragHandleOver:Sprite; // Library reference to the scrollbar's drag handle over state
		private var _upScrollBtnUp:Sprite; // Library reference to the scrollbar's up arrow button over state
		private var _upScrollBtnOver:Sprite; // Library reference to the scrollbar's up arrow button over state
		private var _downScrollBtnUp:Sprite; // Library reference to the scrollbar's down arrow button up state
		private var _downScrollBtnOver:Sprite; // Library reference to the scrollbar's down arrow button over state

		public function ScrollbarConstruct(theme:Theme, trackWidth:Number, trackHeight:Number)
		{
			// Set argument vars
			_theme = theme;
			_trackWidth = trackWidth;
			_trackHeight = trackHeight;
			
			// Settable vars
			_dragHandleUp = _theme.dragHandleUp;
			_dragHandleOver = _theme.dragHandleOver;
			_upScrollBtnUp = _theme.upScrollBtnUp;
			_upScrollBtnOver = _theme.upScrollBtnOver;
			_downScrollBtnUp = _theme.downScrollBtnUp;
			_downScrollBtnOver = _theme.downScrollBtnOver;
			
			_upScrollBtn = new SimpleButton;
			_upScrollBtn.upState = _upScrollBtnUp;
			_upScrollBtn.overState = _upScrollBtnOver;
			_upScrollBtn.downState = _upScrollBtnOver;
			_upScrollBtn.hitTestState = _upScrollBtnUp;
			_upScrollBtn.x = _upScrollBtn.width / 2;
			_upScrollBtn.y = 7; // Moves the button down to the top of the track because of arc in arrow graphic
			_upScrollBtn.filters = [new DropShadowFilter(3, 45, 0x000000)]; // Adds drop shadow to object
			
			_downScrollBtn = new SimpleButton;
			_downScrollBtn.upState = _downScrollBtnUp;
			_downScrollBtn.overState = _downScrollBtnOver;
			_downScrollBtn.downState = _downScrollBtnOver;
			_downScrollBtn.hitTestState = _downScrollBtnUp;
			_downScrollBtn.x = _downScrollBtn.width / 2;
			_downScrollBtn.y = trackHeight - _upScrollBtn.height - 5;
			_downScrollBtn.filters = [new DropShadowFilter(3, 45, 0x000000)]; // Adds drop shadow to object
						
			_dragHandle = new SimpleButton;
			_dragHandle.upState = _dragHandleUp;
			_dragHandle.overState = _dragHandleOver;
			_dragHandle.downState = _dragHandleOver;
			_dragHandle.hitTestState = _dragHandleUp;
			_dragHandle.x = (_upScrollBtn.width / 2) - (_dragHandle.width / 2);
			_dragHandle.y = _upScrollBtn.height;
			_dragHandle.filters = [new DropShadowFilter(3, 45, 0x000000)]; // Adds drop shadow to object
			
			_track = new Sprite;
			_track.graphics.beginFill(_theme.trackColor);
			_track.graphics.drawRect((_upScrollBtn.width / 2) - (_trackWidth / 2), _upScrollBtn.height, _trackWidth, (_trackHeight - _upScrollBtn.height - _downScrollBtn.height));
			_track.graphics.endFill();
			_track.buttonMode = true;
			
			// Must be added in this order to index properly
			_scrollbar = new Sprite;
			_scrollbar.addChild(_track);
			_scrollbar.addChild(_upScrollBtn);
			_scrollbar.addChild(_downScrollBtn);
			_scrollbar.addChild(_dragHandle);
			addChild(_scrollbar);
		}
	}
}