function onCreate()
	if not lowQuality then
		makeAnimatedLuaSprite('fireplaceBG', 'psychic/Psychic_BG', -460, -520)
		luaSpriteAddAnimationByPrefix('fireplaceBG', 'inverted', 'FireplaceBG Inverted');
		luaSpriteAddAnimationByPrefix('fireplaceBG', 'darken', 'FireplaceBG Darken', 24, false);
		luaSpriteAddAnimationByPrefix('fireplaceBG', 'lighten', 'FireplaceBG Lighten', 24, false);
	else
		makeAnimatedLuaSprite('fireplaceBG', 'psychic/Psychic_BG_low', -460, -520)
	end
	luaSpriteAddAnimationByPrefix('fireplaceBG', 'normal', 'FireplaceBG0');
	luaSpritePlayAnimation('fireplaceBG', 'normal');

	setLuaSpriteScrollFactor('fireplaceBG', 0.95, 0.98);
	addLuaSprite('fireplaceBG', false);
	setProperty('gfGroup.visible', false);
end

-- get strum position for the checks
intendedStrumPos = {};
function onCountdownTick(counter)
	if counter == 0 then
		for i = 0, 3 do
			intendedStrumPos[i] = getPropertyFromGroup('playerStrums', i, 'x');
		end
	end
end

-- animate BG
mustPressSwapped = false;
function onEvent(name, value1, value2)
	if name == "Must Press Swap" then
		mustPressSwapped = not mustPressSwapped;
		recalcBG();
	elseif name == "Flip Notes" then
		oldNoteX = intendedStrumPos[0];
		intendedStrumPos[0] = intendedStrumPos[3];
		intendedStrumPos[3] = oldNoteX;

		oldNoteX = intendedStrumPos[1];
		intendedStrumPos[1] = intendedStrumPos[2];
		intendedStrumPos[2] = oldNoteX;
		recalcBG();
	elseif name == "Swap Notes" then
		note1 = tonumber(value1);
		note2 = tonumber(value2);
		
		oldNoteX = intendedStrumPos[note1];
		intendedStrumPos[note1] = intendedStrumPos[note2];
		intendedStrumPos[note2] = oldNoteX;
		recalcBG();
	end
end

doChecks = false;
function recalcBG()
	if lowQuality then
		return;
	end

	getDark = false;
	if mustPressSwapped --[[or not (intendedStrumPos[0] < intendedStrumPos[1] and intendedStrumPos[1] < intendedStrumPos[2] and intendedStrumPos[2] < intendedStrumPos[3])]] then
		getDark = true;
	end

	if getDark then
		if not (getProperty('fireplaceBG.animation.curAnim.name') == 'inverted') then
			luaSpritePlayAnimation('fireplaceBG', 'darken');
			doChecks = true;
		end
	else
		if not (getProperty('fireplaceBG.animation.curAnim.name') == 'normal') then
			luaSpritePlayAnimation('fireplaceBG', 'lighten');
			doChecks = true;
		end
	end
end

function onUpdate(elapsed)
	if not doChecks then
		return;
	end

	if getProperty('fireplaceBG.animation.curAnim.finished') then
		animName = getProperty('fireplaceBG.animation.curAnim.name');
		if animName == 'darken' then
			luaSpritePlayAnimation('fireplaceBG', 'inverted');
		elseif animName == 'lighten' then
			luaSpritePlayAnimation('fireplaceBG', 'normal');
		end
		doChecks = false;
	end
end

-- correct camera position
function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('camFollow.x', getProperty('camFollow.x') - 100);
		setProperty('camFollow.y', getProperty('camFollow.y') - 50);
	end
end