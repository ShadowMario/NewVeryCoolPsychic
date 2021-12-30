function onCreate()
	makeLuaSprite('uproarScreenThing', nil, -700, -500);
	makeGraphic('uproarScreenThing', screenWidth * 2, screenHeight * 2, 'FFFFFF');
	setScrollFactor('uproarScreenThing', 0, 0);
	addLuaSprite('uproarScreenThing', true);
	setProperty('uproarScreenThing.alpha', 0.0000001);
	setProperty('uproarScreenThing.color', getColorFromHex('000000'));
end

function onEvent(name, value1, value2)
	if name == 'Uproar Screen Thing' then
		if value1 == '1' then
			doTweenAlpha('uproarScreenThingTween', 'uproarScreenThing', 0, 0.6, 'sineOut');
			setProperty('uproarScreenThing.color', getColorFromHex('FFFFFF'));
			if flashingLights then
				setBlendMode('uproarScreenThing', 'add');
			end
		else
			doTweenAlpha('uproarScreenThingTween', 'uproarScreenThing', 1, 0.4, 'sineOut');
			setProperty('uproarScreenThing.color', getColorFromHex('000000'));
			setBlendMode('uproarScreenThing', 'normal');
		end
	end
end
