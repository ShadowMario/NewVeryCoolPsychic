package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class TheEndState extends MusicBeatState
{
	var funnyText:Alphabet;
	override function create()
	{
		super.create();

		funnyText = new Alphabet(0, 0, 'The End', true);
		funnyText.screenCenter();
		funnyText.y -= 25;
		add(funnyText);
		funnyText.alpha = 0;

		FlxTween.tween(funnyText, {alpha: 1}, 3,
		{
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					new FlxTimer().start(0.4, function(tmr:FlxTimer)
					{
						var text:String = funnyText.text;
						switch(tmr.elapsedLoops)
						{
							case 1, 2, 3: text += '.';
							case 4: text += '?';
						}
						funnyText.changeText(text);
						FlxG.sound.play(Paths.sound('dialogue'));
						funnyText.screenCenter(X);
					}, 4);
				});
			}
		});

		FlxTween.tween(funnyText, {alpha: 0}, 2, {
			startDelay: 8,
			onComplete: function(twn:FlxTween)
			{
				MusicBeatState.switchState(new StoryMenuState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		});
	}
}
