zoomLastFor = -1;
cameraZoomPosX = 0;
cameraZoomPosY = 0;
function onEvent(name, value1, value2)
	if name == 'Wacky Zoom' then
		zoomLastFor = 0.5;
		cameraSetTarget('boyfriend');
		cameraZoomPosX = getProperty('camFollow.x') + 40;
		cameraZoomPosY = getProperty('camFollow.y') + 40;
		setProperty('camFollowPos.x', getProperty('camFollowPos.x') + 30);
		setProperty('camFollowPos.y', getProperty('camFollowPos.y') + 35);
		doTweenZoom('wackyZoomCamTween', 'camGame', 0.825, 0.15, 'linear');
		setProperty('camZooming', false);
		setProperty('cameraSpeed', 4.5);
	end
end

function onUpdate(elapsed)
	if zoomLastFor == -1 then
		return;
	end

	setProperty('camZooming', false);
	zoomLastFor = zoomLastFor - elapsed;
	if zoomLastFor <= 0 then
		setProperty('cameraSpeed', 1);
		setProperty('camZooming', true);
		zoomLastFor = -1;
	end
end

function onMoveCamera(focus)
	if focus == 'dad' then
		setProperty('camZooming', true);
		setProperty('cameraSpeed', 1);
		zoomLastFor = -1;
	end

	if zoomLastFor > 0 then
		setProperty('camFollow.x', cameraZoomPosX);
		setProperty('camFollow.y', cameraZoomPosY);
	end
end