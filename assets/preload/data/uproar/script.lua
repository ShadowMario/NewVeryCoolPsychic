function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-spirit-dead');
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'GameOverScary');
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'SpiritBFDeath');
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'SpiritBFRetry');
	setProperty('camZooming', true);
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
		startDialogue('dialogue');

		-- snap camera
		cameraSetTarget('boyfriend');
		setProperty('camFollowPos.x', getProperty('camFollow.x') - 40);
		setProperty('camFollowPos.y', getProperty('camFollow.y') - 40);
		return Function_Stop;
	end
	return Function_Continue;
end