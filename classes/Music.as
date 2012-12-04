package classes // This class will take the incoming song, play it and provide controls for it
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	public class Music extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _music:Sound; // Reference to the Sound class
		private var _channel:SoundChannel; // Reference to the soundChannel class
		private var _label:TextField; // TextField to hold the word "Music" next to the buttons
		private var _slash:TextField; // TextField to hold the slash inbetween the play and pause buttons
		private var _labelFormat:TextFormat; // Format of the label text
		
		// Button vars
		private var _playText:TextField; // TextField that becomes the play button
		private var _pauseText:TextField; // TextField that becomes the pause button
		private var _playTextFormat:TextFormat; // Format of the play text
		private var _pauseTextFormat:TextFormat; // Format of the pause text
		
		// Settable vars
		private var _position:Number; // Var to store the position of the music when paused
		private var _song:String; // String to hold path of incoming song
		private var _isPlaying:Boolean; // Flag used to determine if music is playing or not
		private var _musicBtnsX:Number; // X position for the music play and pause button
		private var _musicBtnsY:Number; // Y position for the music play and pause button

		public function Music(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_position =  0;
			_song = _xmlData.song;
			_isPlaying = _xmlData.musicAutoPlay;
			_musicBtnsX = _xmlData.musicBtnsX;
			_musicBtnsY = _xmlData.musicBtnsY;
			
			// Create and set objects
			_music = new Sound();
			_music.load(new URLRequest(_song));
			
			init();
			buttonSetup();
			setPlayButtonIcon();
		}
		
		// Create and setup the text formats
		private function init():void
		{
			_labelFormat = new TextFormat;
			_labelFormat.font = "Verdana, Arial, Times";
			_labelFormat.size = 15;
			_labelFormat.color = 0xFFFFFF;
			_labelFormat.align = "left";
			
			_playTextFormat = new TextFormat;
			_playTextFormat.font = "Verdana, Arial, Times";
			_playTextFormat.size = 14;
			_playTextFormat.color = 0xFFFFFF;
			_playTextFormat.align = "left";
			
			_pauseTextFormat = new TextFormat;
			_pauseTextFormat.font = "Verdana, Arial, Times";
			_pauseTextFormat.size = 14;
			_pauseTextFormat.color = 0xFFFFFF;
			_pauseTextFormat.align = "left";
		}
		
		// Creates the text and their containers that make up the play/pause button set and their label
		private function buttonSetup():void
		{
			var mainContainer:Sprite = new Sprite;
			var playContainer:Sprite = new Sprite;
			var pauseContainer:Sprite = new Sprite;
			
			_label = new TextField;
			_label.text = "MUSIC:";
			_label.antiAliasType = AntiAliasType.ADVANCED;
		 	_label.autoSize = TextFieldAutoSize.LEFT;
		  	_label.setTextFormat(_labelFormat);
			_label.mouseEnabled = false;
			
			_playText = new TextField;
			_playText.text = "Play";
			_playText.antiAliasType = AntiAliasType.ADVANCED;
		 	_playText.autoSize = TextFieldAutoSize.LEFT;
		  	_playText.setTextFormat(_playTextFormat);
			
			playContainer.addChild(_playText);
			playContainer.x = _label.width;
			playContainer.y = _label.y;
			playContainer.buttonMode = true;
			playContainer.mouseChildren = false;
						
			_slash = new TextField;
			_slash.text = "/";
			_slash.antiAliasType = AntiAliasType.ADVANCED;
			_slash.autoSize = TextFieldAutoSize.LEFT;
			_slash.setTextFormat(_labelFormat);
			_slash.mouseEnabled = false;
			_slash.x = _label.width + _playText.width - 2;
			_slash.y = _label.y;
			
			_pauseText = new TextField;
			_pauseText.text = "Pause";
			_pauseText.antiAliasType = AntiAliasType.ADVANCED;
		 	_pauseText.autoSize = TextFieldAutoSize.LEFT;
		  	_pauseText.setTextFormat(_pauseTextFormat);
			
			pauseContainer.addChild(_pauseText);
			pauseContainer.x = _label.width + _playText.width + _slash.width - 4;
			pauseContainer.y = _label.y;
			pauseContainer.buttonMode = true;
			pauseContainer.mouseChildren = false;
			
			mainContainer.addChild(_label);
			mainContainer.addChild(playContainer);
			mainContainer.addChild(_slash);
			mainContainer.addChild(pauseContainer);			
			mainContainer.x = _musicBtnsX;
			mainContainer.y = _musicBtnsY;
			addChild(mainContainer);
			
			playContainer.addEventListener(MouseEvent.CLICK, onPlayPause);
			pauseContainer.addEventListener(MouseEvent.CLICK, onPlayPause);
		}
		
		// Switch the underline between the play and pause buttons depending on if isPlaying is true or false
		private function setPlayButtonIcon():void
		{
			if(_isPlaying)
			{
				_playTextFormat.underline = true;
				_pauseTextFormat.underline = false;
				
				_playText.setTextFormat(_playTextFormat);
				_pauseText.setTextFormat(_pauseTextFormat);
			}
			
			else
			{
				_playTextFormat.underline = false;
				_pauseTextFormat.underline = true;
				
				_playText.setTextFormat(_playTextFormat);
				_pauseText.setTextFormat(_pauseTextFormat);
			}
		}
		
		// Stop music if isPlaying is true otherwise start it, also allows play and pause to switch roles if they're already selected
		private function onPlayPause(e:MouseEvent):void
		{
			if(_isPlaying)
			{
				_position = _channel.position;
				_channel.stop();
				_isPlaying = false;
				setPlayButtonIcon();
			}
			
			else
			{
				_channel = _music.play(_position, int.MAX_VALUE);
				_isPlaying = true;
				setPlayButtonIcon();
			}
		}
		
		// Called from Main, starts music if initial value of isPlaying is true
		public function startMusic():void
		{
			if(_isPlaying)
			{
				_channel = _music.play(0, int.MAX_VALUE);
			}
		}
	}
}