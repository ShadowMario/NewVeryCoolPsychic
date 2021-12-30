function onCreate()
	makeAnimatedLuaSprite('bgFlames', 'psychic/BG_Flames', -460, -520)
	addAnimationByPrefix('bgFlames', 'normal', 'BG Flames0');
	addAnimationByPrefix('bgFlames', 'crazy', 'BG Flames Crazy');

	setScrollFactor('bgFlames', 0.95, 0.98);
	addLuaSprite('bgFlames', false);
	setProperty('gfGroup.visible', false);
	
	if not lowQuality then
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
flameIsBig = false;
function onEvent(name, value1, value2)
	if name == "BG Flames Get Crazy" and not (getProperty('bgFlames.animation.curAnim.name') == 'crazy') then
		makeLuaSprite('redFlash', nil, -500, -400);
		makeGraphic('redFlash', screenWidth * 2, screenHeight * 2, 'FF8ACE');
		--setBlendMode('redFlash', 'add');
		addLuaSprite('redFlash', true);
		doTweenAlpha('redFlashTween', 'redFlash', 0, 1.5, 'sineOut');
		runTimer('removeRedFlash', 1);
		objectPlayAnimation('bgFlames', 'crazy');
		flameIsBig = true;
		runTimer('particleSpawn', 0.025, 0);

		if cameraZoomOnBeat then
			setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.5);
			setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.4);
		end
	elseif name == 'Flip Notes' or name == 'Swap Notes' then
		runTimer('Save New Note X', 0.31);
		isMoving = true;
	elseif name == 'Must Press Swap' then
		runTimer('Save New Note X', 0.36);
		isMoving = true;
	end
end

function onUpdate(elapsed)
	if not flameIsBig or difficulty == 0 then
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
	
	if not lowQuality then
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

	tag = ('flamesParticle'..particleCount);
	math.randomseed(os.clock() * 100 + getSongPosition());
	setProperty(tag..'.scale.x', math.random(1000, 1500) / 1000);
	if flameIsBig then
		setProperty(tag..'.x', math.random(-500, 2000));
	else
		setProperty(tag..'.x', math.random(0, 1500));
	end
	velX = math.random(-50, 50);
	setProperty(tag..'.velocity.x', velX);
	math.randomseed(os.clock() * 92.4 - getSongPosition());
	setProperty(tag..'.scale.y', math.random(1000, 1500) / 1000);
	if flameIsBig then
		setProperty(tag..'.y', math.random(100, 1000));
	else
		setProperty(tag..'.y', math.random(150, 500));
	end
	setProperty(tag..'.velocity.y', math.random(-75, -150));
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