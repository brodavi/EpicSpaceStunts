package com.brodavi.epicspacestunts;

import com.brodavi.epicspacestunts.GameState;

import nme.Assets;
import nme.media.Sound;
import nme.media.SoundChannel;

//import pgr.gconsole.GC;

class SoundManager {

	private static var _track01Sound : Sound;
	private static var _track01Channel : SoundChannel;

	private static var _menuSound : Sound;
	private static var _menuChannel : SoundChannel;

	private static var _coinSound : Sound;
	private static var _coinChannel : SoundChannel;

	private static var _shieldSound : Sound;
	private static var _shieldChannel : SoundChannel;

	private static var _boostSound : Sound;
	private static var _boostChannel : SoundChannel;

	private static var _shootSound : Sound;
	private static var _shootChannel : SoundChannel;

	private static var _shipExplosionSound : Sound;
	private static var _shipExplosionChannel : SoundChannel;

	private static var _asteroidExplosionSound : Sound;
	private static var _asteroidExplosionChannel : SoundChannel;

	private static var _buttonSound : Sound;
	private static var _buttonChannel : SoundChannel;

	private static var _playing : Bool = false;

	public static var lastSoundVol : Float = 1;
	public static var lastMusicVol : Float = 1;

	public static var soundVol : Float = 1;
	public static var musicVol : Float = 1;

	public static var isMute : Bool = false;

	public static var gameState : GameState;

	public static function init( gameStateParam : GameState )
	{
		_track01Sound = Assets.getSound( "assets/track01.mp3" );
		_menuSound = Assets.getSound( "assets/menu.mp3" );
		_coinSound = Assets.getSound( "assets/coin.wav" );
		_shieldSound = Assets.getSound( "assets/shield.wav" );
		_boostSound = Assets.getSound( "assets/boost.wav" );
		_shootSound = Assets.getSound( "assets/shoot.wav" );
		_buttonSound = Assets.getSound( "assets/button.wav" );
		_asteroidExplosionSound = Assets.getSound( "assets/asteroidexplosion.wav" );
		_shipExplosionSound = Assets.getSound( "assets/spaceshipexplosion.wav" );
		gameState = gameStateParam;
	}

	public static function mute( ) : Void
	{
		stopTrack01();
		stopMenu();
		isMute = true;
	}

	public static function unMute( ) : Void
	{
		isMute = false;

		if ( gameState.state == PLAYING )
			{
				playTrack01();
			}
		else playMenu();
	}

	public static function playButton( ) : Void
	{
		if ( isMute ) return;

		if ( _buttonChannel == null )
			{
				_buttonChannel = _buttonSound.play( 0, 1 );
			}
		if ( _buttonChannel.position == _buttonSound.length )
			{
				_buttonChannel = _buttonSound.play(0, 1);
			}
	}

	public static function playCoin( ) : Void
	{
		if ( isMute ) return;

		if ( _coinChannel == null )
			{
				_coinChannel = _coinSound.play( 0, 1 );
			}
		if ( _coinChannel.position == _coinSound.length )
			{
				_coinChannel = _coinSound.play(0, 1);
			}
	}

	public static function playShield( ) : Void
	{
		if ( isMute ) return;

		if ( _shieldChannel == null )
			{
				_shieldChannel = _shieldSound.play( 0, 1 );
			}
		if ( _shieldChannel.position == _shieldSound.length )
			{
				_shieldChannel = _shieldSound.play(0, 1);
			}
	}

	public static function playBoost( ) : Void
	{
		if ( isMute ) return;

		if ( _boostChannel == null )
			{
				_boostChannel = _boostSound.play( 0, 1 );
			}
		if ( _boostChannel.position == _boostSound.length )
			{
				_boostChannel = _boostSound.play(0, 1);
			}
	}

	public static function playShoot( ) : Void
	{
		if ( isMute ) return;

		if ( _shootChannel == null )
			{
				_shootChannel = _shootSound.play( 0, 1 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_shootChannel.soundTransform = transform;
			}
		if ( _shootChannel.position == _shootSound.length )
			{
				_shootChannel = _shootSound.play(0, 1);
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_shootChannel.soundTransform = transform;
			}
	}

	public static function playShipExplosion( ) : Void
	{
		if ( isMute ) return;

		if ( _shipExplosionChannel == null )
			{
				_shipExplosionChannel = _shipExplosionSound.play( 0, 1 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_shipExplosionChannel.soundTransform = transform;
			}
		if ( _shipExplosionChannel.position == _shipExplosionSound.length )
			{
				_shipExplosionChannel = _shipExplosionSound.play( 0, 1 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_shipExplosionChannel.soundTransform = transform;
			}
	}

	public static function playAsteroidExplosion( ) : Void
	{
		if ( isMute ) return;

		if ( _asteroidExplosionChannel == null )
			{
				_asteroidExplosionChannel = _asteroidExplosionSound.play( 0, 1 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_asteroidExplosionChannel.soundTransform = transform;
			}
		if ( _asteroidExplosionChannel.position == _asteroidExplosionSound.length )
			{
				_asteroidExplosionChannel = _asteroidExplosionSound.play( 0, 1 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_asteroidExplosionChannel.soundTransform = transform;
			}
	}

	public static function playTrack01( ) : Void
	{
		if ( isMute ) return;

		if ( _track01Channel == null )
			{
				_track01Channel = _track01Sound.play( 0, 999 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_track01Channel.soundTransform = transform;
			}
		if ( _track01Channel.position == _track01Sound.length )
			{
				_track01Channel = _track01Sound.play( 0, 999 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_track01Channel.soundTransform = transform;
			}
	}

	public static function playMenu( ) : Void
	{
		if ( isMute ) return;

		if ( _menuChannel == null )
			{
				_menuChannel = _menuSound.play( 0, 999 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_menuChannel.soundTransform = transform;
			}
		if ( _menuChannel.position == _menuSound.length )
			{
				_menuChannel = _menuSound.play( 0, 999 );
				var transform = new nme.media.SoundTransform();
				transform.volume = 0.4;
				_menuChannel.soundTransform = transform;
			}
	}

	public static function stopTrack01( ) : Void
	{
		if ( isMute ) return;

		if ( _track01Channel != null ) _track01Channel.stop( );
		_track01Channel = null;
	}

	public static function stopMenu( ) : Void
	{
		if ( isMute ) return;

		if ( _menuChannel != null ) _menuChannel.stop( );
		_menuChannel = null;
	}
}