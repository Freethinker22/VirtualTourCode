package classes.slideMenu // This class manages the scrollbar and is linked to the scrollbar Sprite from the library
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import classes.Param;
	import classes.Theme;
	import classes.events.ScrollbarEvent;

	public class Scrollbar extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _handle:SimpleButton; // Library reference to the scrollbar handle
		private var _handleContainer:Sprite; // Object container for the handle so it can use start and stop drag
		private var _track:Sprite; // Library reference to the scrollbar track
		private var _heightToScroll:Number; // The total height to scroll
		private var _currentThumbId:uint; // The current thumb id
		
		// Settable vars
		private var _isDragged:Boolean; // Used as a flag to check if this is dragged
		private var _limitY:Number; // Limit the dragging of the scrollbar handler
		private var _numOfImages:int; // Total number of thumbs to scroll
		private var _scrollbarWidth:Number; // The scrollbar track width
		private var _scrollbarHeight:Number; // The scrollbar track width
		private var _transitionLength:Number; // The transition duration		
		private var _handleUp:Sprite; // Up state of the drag handle
		private var _handleOver:Sprite; // Over state of the drag handle
		
		public function Scrollbar(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			setProperties();
			buildTrack();
			setHandlerPosition(_currentThumbId);
			addMouseEvents();
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// Setting parameters to this class
		private function setProperties():void
		{
			// Settable vars
			_isDragged = false;
			_limitY = 0;
			_numOfImages = _xmlData.numOfImages;
			_scrollbarWidth = _xmlData.scrollbarWidth;
			_scrollbarHeight = _xmlData.scrollbarHeight;
			_transitionLength = _xmlData.transitionLength;
			_currentThumbId = Math.round(_numOfImages / 2 - 1);
			_handleUp = _theme.dragHandleUp;
			_handleOver = _theme.dragHandleOver;
		}
		
		// Build the scrollbar track
		private function buildTrack():void
		{
			_track = new Sprite;
			_track.graphics.beginFill(_theme.trackColor);
			_track.graphics.drawRect(0, 0, _scrollbarWidth, _scrollbarHeight);
			_track.graphics.endFill();
			
			_handle = new SimpleButton;
			_handle.upState = _handleUp;
			_handle.overState = _handleOver;
			_handle.downState = _handleOver;
			_handle.hitTestState = _handleUp;
			
			_handleContainer = new Sprite;
			_handleContainer.x = (_track.width / 2) - (_handle.width / 2);
			_handleContainer.filters = [new DropShadowFilter(3, 45, 0x000000)]; // Adds drop shadow to object
			_handleContainer.addChild(_handle);
			
			addChild(_track);
			addChild(_handleContainer);
			
			_heightToScroll = (_track.height - _handleContainer.height - (_limitY * 2));
		}
		
		// Set the handle position
		public function setHandlerPosition(id:int, animate:Boolean = false):void
		{
			_currentThumbId = id;
			
			var percent:Number = (_currentThumbId / (_numOfImages - 1));
			if(animate  && !_isDragged)
			{
				TweenMax.to(_handleContainer, _transitionLength, {y:_limitY + percent * _heightToScroll, ease:Quint.easeOut});
			}
			
			else if(!animate)
			{
				_handleContainer.y = _limitY + percent * _heightToScroll;
			}
		}
		 
		// Add mouse events for the scrollbar in order to drag the handle and change the thumbs position
		private function addMouseEvents():void
		{
			_handleContainer.addEventListener(MouseEvent.MOUSE_DOWN, handlerOnMouseDown);
		}
	
		// When handle is pressed
		private function handlerOnMouseDown(e:MouseEvent):void
		{
			_isDragged = true;
			TweenMax.killTweensOf(_handleContainer);
			_handleContainer.startDrag(false, new Rectangle(_handleContainer.x, 0, 0, (_track.height - _handleContainer.height - (_limitY * 2))));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageOnMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageOnMouseUp);
		}
		
		// When the mouse moves over the stage and the handle is pressed
		private function stageOnMouseMove(e:MouseEvent):void
		{
			onScroll();
		}
		
		// When the mouse is released when the handle is pressed
		private function stageOnMouseUp(e:MouseEvent):void
		{
			_isDragged = false;
			_handleContainer.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageOnMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageOnMouseUp);
			setHandlerPosition(_currentThumbId, true);
		}
		
		// Dispatch an event with the corespondig id to scroll the thumbs
		private function onScroll():void
		{
			var percent:Number = ((_handleContainer.y - _limitY) / _heightToScroll);
			var id:int = Math.round(((_numOfImages - 1) * percent));
			if(_currentThumbId != id)
			{
				_currentThumbId = id;
				dispatchEvent(new ScrollbarEvent(ScrollbarEvent.CHANGE, _currentThumbId)); // Dispatch to SlideMenu to change the img displayed
			}
		}
	}
}