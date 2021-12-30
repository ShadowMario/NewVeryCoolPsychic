function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-senpai');
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-wilter');
	--precacheSound('BFSenpai_Dies');
	
	makeLuaSprite('wilterRedScreen', nil, -700, -500);
	makeGraphic('wilterRedScreen', screenWidth * 2, screenHeight * 2, 'FF3D6E');
	setScrollFactor('wilterRedScreen', 0, 0);
	addLuaSprite('wilterRedScreen', true);
	setProperty('wilterRedScreen.alpha', 0.0000001);
	setBlendMode('wilterRedScreen', 'add');
end

local firstNote = true;
function opponentNoteHit(id, direction, noteType, isSustainNote)
	-- vignette overlay on start -- end overlay
	if firstNote then
		doTweenAlpha('vignetteStartTween', 'psychicVignette', 0, 1, 'sineOut');
		firstNote = false;
	end
end

-- vignette overlay on start
function onSongStart()
	doTweenAlpha('vignetteStartTween', 'psychicVignette', 0.6, 10, 'linear');
end


-- Dialogue shit
local allowCountdown = false;
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
		allowCountdown = true;
		setProperty('inCutscene', true);
		characterPlayAnim('boyfriend', 'cute', true);
		
		cameraSetTarget('boyfriend');
		setProperty('camGame.zoom', 1);
		setProperty('camHUD.alpha', 0);
		doTweenAlpha('camHUDAlphaTwn', 'camHUD', 1, 1, 'linear'); 
		doTweenZoom('camGameZoomTwn', 'camGame', getProperty('defaultCamZoom'), 1, 'quadOut');
		doTweenX('camFollowPosXTween', 'camFollowPos', getProperty('camFollow.x'), 1, 'sineOut');
		doTweenY('camFollowPosYTween', 'camFollowPos', getProperty('camFollow.y'), 1, 'sineOut');
		runTimer('startDialogue', 1.2);
		return Function_Stop;
	end
	return Function_Continue;
end

maxZoom = 0.95;
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'Love_Is_A_Flower');
	elseif tag == 'YEEES! KILLLL!' then
		playSound('BFSenpai_Dies');
	elseif tag == 'endSongAgain' then
		endSong();
	elseif tag == 'redTransOutTimer' then
		doTweenAlpha('redTransOutAlphaTwn', 'redTransOut', 1, 2, 'linear');
	elseif tag == 'startFirstShake' then
		cameraShake('game', 0.05, 1);
		runTimer('startWeakShake', 1);
		runTimer('cameraShakeZoomLoop', 0.125, 24);
		onTimerCompleted('cameraShakeZoomLoop', 0, 1);
	elseif tag == 'startWeakShake' then
		cameraShake('game', 0.03, 1);
		runTimer('startLastShake', 1);
		maxZoom = 0.9;
	elseif tag == 'startLastShake' then
		cameraShake('game', 0.01, 1);
		maxZoom = 0.86;
	elseif tag == 'createTrailThingie' then
		spawnTrail();
	elseif tag == 'cameraShakeZoomLoop' then
		if loopsLeft % 2 == 0 then
			doTweenZoom('camGameZoomTwn', 'camGame', 0.85, 0.5, 'elasticOut');
		else
			if maxZoom then
				doTweenZoom('camGameZoomTwn', 'camGame', 0.925, 0.5, 'elasticOut');
			else
				doTweenZoom('camGameZoomTwn', 'camGame', 1, 0.5, 'elasticOut');
			end
		end
	end
end

function onNextDialogue(count)
	if count == 15 then
		characterDance('boyfriend');
		cameraShake('hud', 0.05, 0.35);
		cameraShake('game', 0.02, 0.35);
		playSound('ANGRY_TEXT_BOX', 0.8);
	end
end


-- End cutscene
local allowEnd = false;
cutsceneX = 590;
cutsceneY = 431;
cutsceneImage = 'psychic/bf-senpai-death';

function onEndSong()
	if not allowEnd and isStoryMode then
		allowEnd = true;
		setProperty('inCutscene', true);
		setProperty('boyfriendGroup.visible', false);
		setProperty('gf.stunned', true);
		setProperty('dad.stunned', true);

		makeLuaSprite('redTransIn', nil, -500, -400);
		makeGraphic('redTransIn', screenWidth * 2, screenHeight * 2, 'FF1B31')
		addLuaSprite('redTransIn', true);
		--setBlendMode('redTransIn', 'add') --looks bad, makes the carpet looks like vomit
		setProperty('redTransIn.alpha', 0);

		--for debug shit
		cancelTween('PsyVigAlphaTwn');
		setProperty('psychicVignette.visible', false);
		-----------------
		
		makeAnimatedLuaSprite('cutsceneBf', cutsceneImage, cutsceneX, cutsceneY);
		addAnimationByPrefix('cutsceneBf', 'cutscene', 'SENBF DEATH', 24, false);
		addAnimationByIndices('cutsceneBf', 'cutsceneLoop', 'SENBF DEATH', '78, 79, 80', 24);
		addLuaSprite('cutsceneBf', true);

		makeLuaSprite('vignetteCutscene', 'psychic/vignetteCutscene')
		setObjectCamera('vignetteCutscene', 'other');
		setGraphicSize('vignetteCutscene', screenWidth, screenHeight);
		setScrollFactor('vignetteCutscene', 0, 0);
		addLuaSprite('vignetteCutscene', true);
		setProperty('vignetteCutscene.alpha', 0.00001);

		makeLuaSprite('redTransOut', nil, 0, 0);
		setObjectCamera('redTransOut', 'other');
		makeGraphic('redTransOut', screenWidth, screenHeight, 'FF1B31')
		setScrollFactor('redTransOut', 0, 0);
		addLuaSprite('redTransOut', true);
		setProperty('redTransOut.alpha', 0.00001);

		doTweenAlpha('camHUDAlphaTwn', 'camHUD', 0, 1, 'linear');
		doTweenX('camFollowPosXTwn', 'camFollowPos', cutsceneX + 400, 2.5, 'quadOut');
		doTweenY('camFollowPosYTwn', 'camFollowPos', cutsceneY + 150, 2.5, 'quadOut');
		doTweenZoom('camGameZoomTwn', 'camGame', 0.85, 2.5, 'sineInOut');
		doTweenAlpha('redTransInAlphaTwn', 'redTransIn', 0.4, 3.5, 'sineInOut');
		doTweenAlpha('vignetteCutsceneTwn', 'vignetteCutscene', 0.5, 1.25, 'sineInOut');
		--runTimer('YEEES! KILLLL!', 0.25);
		runTimer('endSongAgain', 8.2);
		runTimer('redTransOutTimer', 4);
		runTimer('startFirstShake', 3.2);
		runTimer('createTrailThingie', 2.42);

		playSound('BFSenpai_Dies');
		return Function_Stop;
	end
	return Function_Continue;
end

function onUpdate(elapsed)
	if allowEnd then --on ending cutscene
		if getProperty('cutsceneBf.animation.curAnim.finished') then
			objectPlayAnimation('cutsceneBf', 'cutsceneLoop', false);
		end
	end
end

startedRedTween = false;
function onStepHit()
	if curStep > 960 and curStep < 1024 and not startedRedTween then
		doTweenAlpha('wilterRedTween', 'wilterRedScreen', 0.4, ((1024 - curStep) * stepCrochet) / 1000, 'linear');
		startedRedTween = true;
	elseif curStep >= 1024 and startedRedTween then
		doTweenAlpha('wilterRedTween', 'wilterRedScreen', 0.0, 0.5, 'linear');
	end
end



-- blah blah coolswag
function spawnTrail()
	image = cutsceneImage;
	frame = 'SENBF DEATH';
	x = cutsceneX;
	y = cutsceneY;
	alpha = 0.75;
	height = 0;

	frameNum = tostring(getProperty('cutsceneBf.animation.curAnim.curFrame'));
	height = getProperty('cutsceneBf.height');
	debugPrint('k2')

	trailTag = 'psychicCutsceneTrail';
	makeAnimatedLuaSprite(trailTag, image, x, y);
	setProperty(trailTag..'.alpha', alpha);
	--setBlendMode(trailTag, 'add');
	addAnimationByIndices(trailTag, 'stufftest', frame, frameNum, 0);
	addLuaSprite(trailTag, false);
	setObjectOrder(trailTag, getObjectOrder('gfGroup'));

	doTweenX(trailTag..'ScaleTweenX', trailTag..'.scale', 1.35, 0.85, 'sineOut');
	doTweenY(trailTag..'ScaleTweenY', trailTag..'.scale', 1.35, 0.85, 'sineOut');
	doTweenX(trailTag..'TweenX', trailTag, x - 30, 0.85, 'sineOut');
	doTweenY(trailTag..'TweenY', trailTag, y - height / 6, 0.85, 'sineOut');
	doTweenAlpha(trailTag..'AlphaTween', trailTag, 0, 0.85, 'linear');
	
	setProperty('camGame.zoom', 1.15);
	doTweenZoom('camGameZoomTwn', 'camGame', 0.85, 0.5, 'elasticOut');
end