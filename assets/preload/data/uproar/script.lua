function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-spirit-dead');
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'GameOverScary');
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'SpiritBFDeath');
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'SpiritBFRetry');
	setProperty('camZooming', true);
end

local blockEnd = true;
local shouldPlayCutscene = true;
function onEndSong()
	if isStoryMode and blockEnd then
		if shouldPlayCutscene then --Workaround for bug on cutscene
			shouldPlayCutscene = false;
			setProperty('camHUD.visible', false);
			setProperty('camGame.visible', false);
			startVideo('Uproar_Cutscene');
			runTimer('End for real', 155.0);
		end
		return Function_Stop;
	end
	return Function_Continue;
end

function onGameOverConfirm(retry)
	if retry then
		setProperty('boyfriend.visible', false)
	end
end

-- Dialogue shit
local allowCountdown = false;
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
		allowCountdown = true;
		--setProperty('inCutscene', true);
		--runTimer('startDialogue', 0.8);
		onTimerCompleted('startDialogue', 0, 0);

		-- snap camera
		cameraSetTarget('boyfriend');
		setProperty('camFollowPos.x', getProperty('camFollow.x') - 40);
		setProperty('camFollowPos.y', getProperty('camFollow.y') - 40);
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'Spiritual_Unrest');
	elseif tag == 'End for real' then
		blockEnd = false;
		endSong();
	end
end