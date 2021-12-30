-- Event notes hooks
function onCreate()
	makeLuaSprite('psychicVignette', 'psychic/vignette', 0, 0);
	setObjectCamera('psychicVignette', 'hud');
	setGraphicSize('psychicVignette', screenWidth, screenHeight);
	setScrollFactor('psychicVignette', 0, 0);
	addLuaSprite('psychicVignette', false);
	setProperty('psychicVignette.alpha', 0.00001);
end

function onEvent(name, value1, value2)
	if name == "Vignette Fade" then
		duration = tonumber(value1)
		targetAlpha = tonumber(value2)

		if duration <= 0 then
			setProperty('psychicVignette.alpha', targetAlpha);
			if cameraZoomOnBeat then
				setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.07);
			end
		else
			doTweenAlpha('PsyVigAlphaTwn', 'psychicVignette', targetAlpha, duration, 'linear');
		end
	end
end