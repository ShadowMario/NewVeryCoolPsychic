-- Event notes hooks
alreadySwapped = false;
function onCreate()
	for i = 0, getProperty('unspawnNotes.length') do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Inversed Note' then
			setPropertyFromGroup('unspawnNotes', i, 'copyX', false);
		end
	end
end

function onEvent(name, value1, value2)
	if name == "Must Press Swap" then
		for i = 0, 3 do
			j = (i + 4)

			iPos = _G['defaultPlayerStrumX'..i];
			jPos = _G['defaultOpponentStrumX'..i];
			if alreadySwapped then
				iPos = _G['defaultOpponentStrumX'..i];
				jPos = _G['defaultPlayerStrumX'..i];
			end
			noteTweenX('note'..i..'TwnX', i, iPos, 0.35, 'quadInOut');
			noteTweenX('note'..j..'TwnX', j, jPos, 0.35, 'quadInOut');
		end
		alreadySwapped = not alreadySwapped;

		if not lowQuality then
			for i = 0, 7 do
				tag = 'psychicNoteTrail'..i;
				setProperty(tag..'.alpha', 0.0001);
				doTweenAlpha(tag..'alphaTweenThing', tag, 0.5, 0.25, 'sineIn');
			end
			runTimer('removeTrailThing', 0.3);
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'removeTrailThing' then
		for i = 0, 7 do
			tag = 'psychicNoteTrail'..i;
			doTweenAlpha(tag..'alphaTweenThing', tag, 0.0, 0.2, 'sineOut');
		end
	end
end