specialZoom = false;
canBeat = false;

defaultCamZoom = 1;
function onCreatePost()
	defaultCamZoom = getProperty('defaultCamZoom');
end

maxAddX = 500;
maxAddY = 500;
function onEvent(name, value1, value2)
	if name == "Uproar Zoom" and cameraZoomOnBeat then
		if getProperty('camZooming') then
			canBeat = true;
			setProperty('camZooming', false);
		end

		addToZoom = tonumber(value1);
		if addToZoom == 0 then
			onBeatHit();
		else
			specialZoom = true;
			setProperty('camGame.zoom', getProperty('camGame.zoom') + addToZoom);
			setProperty('camFollowPos.x', getProperty('camFollowPos.x') + maxAddX * addToZoom);
			setProperty('camFollowPos.y', getProperty('camFollowPos.y') + maxAddY * addToZoom);
			setProperty('cameraSpeed', 0);
		end
	end
end

function onMoveCamera(focus)
	if specialZoom and focus == 'boyfriend' then
		diff = getProperty('camGame.zoom') - defaultCamZoom;
		camX = getProperty('camFollow.x') + maxAddX * diff;
		camY = getProperty('camFollow.y') + maxAddY * diff;
		setProperty('camFollow.x', camX);
		setProperty('camFollow.y', camY);
	end
end

function onBeatHit()
	if canBeat then
		setProperty('camZooming', true);
		canBeat = false;
	end

	if specialZoom then
		setProperty('cameraSpeed', 1);
	end
	specialZoom = false;
end