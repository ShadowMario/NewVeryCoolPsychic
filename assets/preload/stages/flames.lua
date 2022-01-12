function onCreate()
	if getPropertyFromClass('ClientPrefs', 'uproarParticles') then
		spawnParticles();
	end
end

-- for note shake supporting events too
bfNoteX0 = 0;
bfNoteX1 = 0;
bfNoteX2 = 0;
bfNoteX3 = 0;
dadNoteX0 = 0;
dadNoteX1 = 0;
dadNoteX2 = 0;
dadNoteX3 = 0;
isMoving = false;
function onCountdownStarted()
	for i = 0, 3 do
		_G['bfNoteX'..i] = _G['defaultPlayerStrumX'..i];
		_G['dadNoteX'..i] = _G['defaultOpponentStrumX'..i];
	end
end

-- animate BG
function onEvent(name, value1, value2)
	if name == 'Flip Notes' or name == 'Swap Notes' then
		runTimer('Save New Note X', 0.31);
		isMoving = true;
	elseif name == 'Must Press Swap' then
		runTimer('Save New Note X', 0.36);
		isMoving = true;
	end
end

function onUpdate(elapsed)
	if difficulty == 0 or not (getProperty('flameIsBig')) or getProperty('endingSong') then
		return;
	end

	shakeAmount = 4;
	songPos = getSongPosition();
	if(songPos > 86400 and songPos < 91200) then
		shakeAmount = 4 - (songPos - 86400) / 400;
	end
	if(songPos > 110400) then
		shakeAmount = 4 - (songPos - 110400) / 800;
	end
	
	if shakeAmount < 0 then
		shakeAmount = 0;
	end

	for i = 0, 3 do
		if not isMoving then
			setPropertyFromGroup('playerStrums', i, 'x', _G['bfNoteX'..i] + getRandomFloat(-shakeAmount, shakeAmount));
			setPropertyFromGroup('opponentStrums', i, 'x', _G['dadNoteX'..i] + getRandomFloat(-shakeAmount, shakeAmount));
		end
		setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + getRandomFloat(-shakeAmount, shakeAmount));
		setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + getRandomFloat(-shakeAmount, shakeAmount));
	end
	
	if getPropertyFromClass('ClientPrefs', 'uproarParticles') then
		particleThink();
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'removeRedFlash' then
		removeLuaSprite('removeRedFlash');
	elseif tag == 'particleSpawn' then
		particleTimer();
	elseif tag == 'Save New Note X' then
		for i = 0, 3 do
			_G['bfNoteX'..i] = getPropertyFromGroup('playerStrums', i, 'x');
			_G['dadNoteX'..i] = getPropertyFromGroup('opponentStrums', i, 'x');
		end
		isMoving = false;
	end
end

-- correct camera position
function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('camFollow.x', getProperty('camFollow.x') - 100);
		setProperty('camFollow.y', getProperty('camFollow.y') - 50);
	end
end

-- particle logic
particleCount = 0;
particleLimit = 90;
particleTime = 2.5;
function spawnParticles()
	for i = 1, particleLimit do
		tag = ('flamesParticle'..i);
		makeLuaSprite(tag, nil, -10000, -10000);
		makeGraphic(tag, 15, 15, 'FF447F');
		addLuaSprite(tag, false);
		setBlendMode(tag, 'add');
	end
	runTimer('particleSpawn', 0.1, 0);
end

function particleTimer()
	particleCount = particleCount + 1;
	if particleCount > particleLimit then
		particleCount = 1;
	end

	flameIsBig = getProperty('flameIsBig');
	tag = ('flamesParticle'..particleCount);
	setProperty(tag..'.scale.x', getRandomFloat(1000, 1500) / 1000);
	if flameIsBig then
		setProperty(tag..'.x', getRandomFloat(-500, 2000));
	else
		setProperty(tag..'.x', getRandomFloat(0, 1500));
	end
	velX = getRandomFloat(-50, 50);
	setProperty(tag..'.velocity.x', velX);
	setProperty(tag..'.scale.y', getRandomFloat(1000, 1500) / 1000);
	if flameIsBig then
		setProperty(tag..'.y', getRandomFloat(100, 1000));
	else
		setProperty(tag..'.y', getRandomFloat(150, 500));
	end
	setProperty(tag..'.velocity.y', getRandomFloat(-75, -150));
	setProperty(tag..'.alpha', 1);

	if flameIsBig then
		order = getObjectOrder('bgFlames') + 1;
		if particleCount % 2 == 0 and getProperty('uproarScreenThing.alpha') < 1 then
			order = getObjectOrder('boyfriendGroup') + 1;
		end
		setObjectOrder(tag, order);
	end

	doTweenAlpha(tag..'AlphaTween', tag, 0, particleTime, 'linear');
	doTweenX(tag..'ScaleX', tag..'.scale', 0, particleTime, 'linear');
	doTweenY(tag..'ScaleY', tag..'.scale', 0, particleTime, 'linear');
	doTweenX(tag..'SpeedX', tag..'.velocity', velX * -0.75, particleTime/2, 'linear');
end