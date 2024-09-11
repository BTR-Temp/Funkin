package funkin.ui.charSelect;

#if html5
import funkin.graphics.video.FlxVideo;
#end
#if hxCodec
import hxcodec.flixel.FlxVideoSprite;
#end
import funkin.ui.MusicBeatSubState;
import funkin.audio.FunkinSound;

/**
 * After about 2 minutes of inactivity on the title screen,
 * the game will enter the Attract state, as a reference to physical arcade machines.
 *
 * In the current version, this just plays the ~~Kickstarter trailer~~ Erect teaser, but this can be changed to
 * gameplay footage, a generic game trailer, or something more elaborate.
 */
class IntroSubState extends MusicBeatSubState
{
  static final ATTRACT_VIDEO_PATH:String = Paths.stripLibrary(Paths.videos('introSelect'));

  var introSound:FunkinSound = null;

  public override function create():Void
  {
    // Pause existing music.
    if (FlxG.sound.music != null)
    {
      FlxG.sound.music.destroy();
      FlxG.sound.music = null;
    }

    #if html5
    trace('Playing web video ${ATTRACT_VIDEO_PATH}');
    playVideoHTML5(ATTRACT_VIDEO_PATH);
    #end

    #if hxCodec
    trace('Playing native video ${ATTRACT_VIDEO_PATH}');
    playVideoNative(ATTRACT_VIDEO_PATH);
    #end

    introSound = new FunkinSound();
    introSound.loadEmbedded(Paths.sound('CS_Lights'));
    introSound.pitch = 1;

    FlxG.sound.defaultSoundGroup.add(introSound);
    FlxG.sound.list.add(introSound);

    introSound.play(true);
  }

  #if html5
  var vid:FlxVideo;

  function playVideoHTML5(filePath:String):Void
  {
    // Video displays OVER the FlxState.
    vid = new FlxVideo(filePath);

    vid.scrollFactor.set();
    if (vid != null)
    {
      vid.zIndex = 0;

      vid.finishCallback = onAttractEnd;

      add(vid);
    }
    else
    {
      trace('ALERT: Video is null! Could not play cutscene!');
    }
  }
  #end

  #if hxCodec
  var vid:FlxVideoSprite;

  function playVideoNative(filePath:String):Void
  {
    // Video displays OVER the FlxState.
    vid = new FlxVideoSprite(0, 0);

    vid.scrollFactor.set();

    if (vid != null)
    {
      vid.zIndex = 0;
      vid.bitmap.onEndReached.add(onAttractEnd);

      add(vid);
      vid.play(filePath, false);
    }
    else
    {
      trace('ALERT: Video is null! Could not play cutscene!');
    }
  }
  #end

  public override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (controls.ACCEPT)
    {
      onAttractEnd();
    }
  }

  /**
   * When the attraction state ends (after the video ends or the user presses any button),
   * switch immediately to the title screen.
   */
  function onAttractEnd():Void
  {
    #if (html5 || hxCodec)
    if (vid != null)
    {
      #if hxCodec
      vid.stop();
      #end
      remove(vid);

      vid.destroy();
      vid = null;
    }
    #end

    close();
  }
}
