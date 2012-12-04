package classes // This class takes a DisplayObject with text in it and adds a scrollbar
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent
	import flash.utils.Timer;
	import classes.Theme;
	
	public class TextScrollbar extends ScrollbarConstruct
	{
		private var _theme:Theme; // Reference to the Theme class
		private var _targetObject:DisplayObject; // DisplayObject to be scrolled
		private var _contentTop:Number; // Top limit of targetObject
		private var _contentBottom:Number; // Bottom limit of targetObject
		private var _dragHandleTop:Number; // Top limit of dragHandle
		private var _dragHandleBottom:Number; // Bottom limit of dragHandle
		private var _range:Number; // Is equal to the incoming trackHeight
		private var _ratio:Number; // Is the ratio between the target height and the range
		private var _targetYPos:Number; // The Y position of the target after is has been scrolled
		private var _ctrl:Number; // This is to adapt to the target's position
		private var _isUp:Boolean; // Flag used to determine if the up button is pressed
		private var _isDown:Boolean; // Flag used to determine if the down button is pressed
		private var _moveAmt:Number; // Amount to move DisplayObject when up or down button is clicked
		private var _downwardOffset:Number; // Distance from top of ObjectContainer to top of targetObject
		private var _changeInY:Number; // The difference between the mouseY and the drag handle's y position
		private var _mask:Sprite; // Mask used to hide extra text outside the bounds of where its to display
		private var _maskX:Number; // X position of the mask
		private var _maskY:Number; // Distance from top of object container to where the text disappears
		private var _upTimer:Timer; // Timer used to calculate if the up btn is held down
		private var _downTimer:Timer; // Timer used to calculate if the down btn is held down
		
		public function TextScrollbar(theme:Theme, target:DisplayObject, trackWidth:Number, trackHeight:Number, downwardOffset:Number = 0, moveAmt:Number = 15, maskX:Number = 0, maskY:Number = 0):void
		{			
			// Set argument vars
			_theme = theme;
			_targetObject = target;
			_downwardOffset = downwardOffset;
			_moveAmt = moveAmt;
			_maskX = maskX;
			_maskY = maskY;
			
			super(_theme, trackWidth, trackHeight);
			
			_dragHandle.addEventListener(MouseEvent.MOUSE_DOWN, dragScroll);
			_dragHandle.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			_track.addEventListener(MouseEvent.CLICK, trackClickHandler);
		
			init(target);
		}

		private function init(target:DisplayObject):void
		{	
			if(_targetObject.height <= _track.height) // If the target needs scrolling, make the scrollbar visible
			{
				this.visible = false;
			}
			
			_contentTop = 0; // This is the top of the MC that gets scrolled but doesn't use the MC's Y pos
			_contentBottom = (_track.height + _upScrollBtn.height + _downScrollBtn.height);

			_dragHandleTop = _contentTop + _upScrollBtn.height;
			_dragHandleBottom = (_contentBottom - _downScrollBtn.height - _dragHandle.height);
			
			_range = _track.height; // Drags too far when target is really tall
			_ctrl = _targetObject.y;
			_isUp = false;
			_isDown = false;
			_upTimer = new Timer(250);
			_downTimer = new Timer(250);
			
			_upScrollBtn.addEventListener(Event.ENTER_FRAME, upScrollHoldHandler);
			_upScrollBtn.addEventListener(MouseEvent.CLICK, upScrollClickHandler);
			_upScrollBtn.addEventListener(MouseEvent.MOUSE_DOWN, upScroll);
			_upScrollBtn.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			_upScrollBtn.addEventListener(MouseEvent.MOUSE_OUT, stopScroll);

			_downScrollBtn.addEventListener(Event.ENTER_FRAME, downScrollHoldHandler);
			_downScrollBtn.addEventListener(MouseEvent.CLICK, downScrollClickHandler);
			_downScrollBtn.addEventListener(MouseEvent.MOUSE_DOWN, downScroll);
			_downScrollBtn.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			_downScrollBtn.addEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			
			_dragHandle.addEventListener(MouseEvent.MOUSE_WHEEL, wheelScrollHandler);
			_targetObject.addEventListener(MouseEvent.MOUSE_WHEEL, wheelScrollHandler);
			_track.addEventListener(MouseEvent.MOUSE_WHEEL, wheelScrollHandler);
			
			_upTimer.addEventListener(TimerEvent.TIMER, startUpScroll);
			_downTimer.addEventListener(TimerEvent.TIMER, startDownScroll);

			_scrollbar.x = _targetObject.x + _targetObject.width; // Horizontal placement of Scrollbar
			_scrollbar.y = _targetObject.y + _downwardOffset; // Vertical placement of Scrollbar
			
			setMask();
		}
		
		// Sets up the mask to allow only certain content to be shown
		private function setMask():void
		{
			_mask = new Sprite;
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(_targetObject.x, _targetObject.y, _targetObject.width, (_track.height + _upScrollBtn.height + _downScrollBtn.height) + _downwardOffset);
			_mask.graphics.endFill();
			_mask.x = _maskX;
			_mask.y = _maskY;
			addChild(_mask);
			_targetObject.mask = _mask;	
		}
		
		// Called when the up btn is moused down, starts timer to see if the user is holding down the btn
		private function upScroll(e:MouseEvent):void 
		{
			_upTimer.start();
		}
		
		// Called when the down btn is moused down, starts timer to see if the user is holding down the btn
		private function downScroll(e:MouseEvent):void 
		{
			_downTimer.start();
		}
		
		// If the user holds down the btn for more than 250ms, the timer goes off and _isUp is set to true
		private function startUpScroll(e:TimerEvent):void
		{
			_isUp = true;
		}
		
		// If the user holds down the btn for more than 250ms, the timer goes off and _isDown is set to true
		private function startDownScroll(e:TimerEvent):void
		{
			_isDown = true;
		}
		
		// When _isUp is true and the frame resets via EnterFrame, the dragHandle is scrolled until _isUp is false
		private function upScrollHoldHandler(e:Event):void 
		{
			if(_isUp) 
			{
				if(_dragHandle.y > _dragHandleTop) 
				{
					_dragHandle.y -= _moveAmt;
					
					if(_dragHandle.y < _dragHandleTop) 
					{
						_dragHandle.y = _dragHandleTop;
					}
					
					startScroll();
				}
			}
		}
		
		// When _isDown is true and the frame resets via EnterFrame, the dragHandle is scrolled until _isDown is false
		private function downScrollHoldHandler(e:Event):void 
		{
			if(_isDown) 
			{
				if(_dragHandle.y < _dragHandleBottom) // < = is above   > = is below
				{
					_dragHandle.y += _moveAmt;
					
					if(_dragHandle.y > _dragHandleBottom) 
					{
						_dragHandle.y = _dragHandleBottom;
					}
					
					startScroll();
				}
			}
		}
		
		// If the up btn is only clicked and not held down, the drag handle is only moved the preset amount
		private function upScrollClickHandler(e:MouseEvent):void 
		{
			if(_dragHandle.y > _dragHandleTop) 
			{
				_dragHandle.y -= _moveAmt;
				
				if(_dragHandle.y < _dragHandleTop) 
				{
					_dragHandle.y = _dragHandleTop;
				}
				
				startScroll();
			}
		}
		
		// If the down btn is only clicked and not held down, the drag handle is only moved the preset amount
		private function downScrollClickHandler(e:MouseEvent):void 
		{			
			if(_dragHandle.y < _dragHandleBottom) // < = is above   > = is below
			{
				_dragHandle.y += _moveAmt;
				
				if(_dragHandle.y > _dragHandleBottom) 
				{
					_dragHandle.y = _dragHandleBottom;
				}
				
				startScroll();
			}
		}

		// Handles moving the dragHandle if the user uses the mouse wheel to navigate
		private function wheelScrollHandler(e:MouseEvent):void
		{
			var delta:Number = e.delta;

			if(delta > 0)
			{
				_dragHandle.y -= _moveAmt;
				if(_dragHandle.y < _dragHandleTop)
				{
					_dragHandle.y = _dragHandleTop;
				}
			}
			
			else if(delta < 0)
			{
				_dragHandle.y += _moveAmt;
				if(_dragHandle.y > _dragHandleBottom)
				{
					_dragHandle.y = _dragHandleBottom;
				}
			}
			
			startScroll();
		}

		// Handles moving the dragHandled if the user clicks on the track
		private function trackClickHandler(e:MouseEvent):void
		{
			var clickPos:Number = e.localY;
			
			if(clickPos < _dragHandleTop + (_dragHandle.height / 2))
			{
				_dragHandle.y = _dragHandleTop;
			}

			else if(clickPos > _dragHandleBottom - (_dragHandle.height / 2))
			{
				_dragHandle.y = _dragHandleBottom;
			}

			else
			{
				_dragHandle.y = clickPos;
			}
			
			startScroll();
		}

		private function dragScroll(e:MouseEvent):void 
		{			
			_changeInY = mouseY - _dragHandle.y;
			this.addEventListener(MouseEvent.MOUSE_MOVE, moveScroll);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveScroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
		}

		// Resets flags, timers, and event listeners
		private function stopScroll(e:MouseEvent):void 
		{
			_isUp = false;
			_isDown = false;
			_upTimer.stop();
			_downTimer.stop();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, moveScroll);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveScroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);;
		}

		// This function replaces the startDrag function
		private function moveScroll(e:MouseEvent):void
		{
			e.updateAfterEvent();
 
			// Move dragHandle vertically with changeInY
			_dragHandle.y = mouseY - _changeInY;
 
			// Limit vertical movement going up and down
			if(_dragHandle.y < _dragHandleTop)
			{
				_dragHandle.y = _dragHandleTop;
			}
 
			if(_dragHandle.y > _dragHandleBottom)
			{
				_dragHandle.y = _dragHandleBottom;
			}
			
			startScroll();
		}

		// Calculates the position of the dragHandle and its ratio to the content and updates the location of the content based on the position of the dragHandle
		private function startScroll():void 
		{
			_ratio = (_targetObject.height - _range) / _range; // Minus range so bottom of target stays visible
			_targetYPos = ((_dragHandle.y - _upScrollBtn.height) * _ratio) - _ctrl;
			_targetObject.y = -_targetYPos;
		}
	}
}