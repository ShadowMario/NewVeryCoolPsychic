-- Event notes hooks
alreadySwapped = false;
intendedStrumPos = {};
function onCountdownTick(counter)
	if counter == 0 then
		for i = 0, 3 do
			intendedStrumPos[i] = getPropertyFromGroup('playerStrums', i, 'x');
		end
	end
end

function onEvent(name, value1, value2)
	if name == "Flip Notes" then
		swapNotesFromStrum(0, 3);
		swapNotesFromStrum(1, 2);

		if not lowQuality then
			for i = 0, 3 do
				tag = 'psychicNoteTrail'..i;
				setProperty(tag..'.alpha', 0.0001);
				doTweenAlpha(tag..'alphaTweenThing', tag, 0.5, 0.25, 'sineIn');
			end
			runTimer('removeTrailThing', 0.3);
		end
	elseif name == "Swap Notes" then
		note1 = tonumber(value1);
		note2 = tonumber(value2);
		
		oldNoteX = intendedStrumPos[note1];
		intendedStrumPos[note1] = intendedStrumPos[note2];
		intendedStrumPos[note2] = oldNoteX;
	end
end

function swapNotesFromStrum(note1, note2)
	lastArrowPositions = {};
	lastArrowPositions[note1] = intendedStrumPos[note1];
	lastArrowPositions[note2] = intendedStrumPos[note2];

	for i = 0, 1 do
		if note1 == note2 then
			return;
		elseif note1 > note2 then
			oldNote = note2;
			note2 = note1;
			note1 = oldNote;
		end

		swapped = false;
		if intendedStrumPos[note2] < intendedStrumPos[note1] then
			swapped = true;
		end

		newPos = note2;
		spr = note1;

		if not (i == 0) then
			newPos = note1;
			spr = note2;
		end

		rot = 40;
		if getPropertyFromGroup('playerStrums', i, 'ID') > 1 then
			rot = -40;
		end

		if swapped then
			if newPos == note1 then
				newPos = note2;
			else
				newPos = note1;
			end
			rot = -rot;
		end

		newX = 0;
		if i == 0 then
			newX = lastArrowPositions[note2];
			noteTweenX('flipNotesTwn'..note1, note1 + 4, newX, 0.3, 'sineInOut');
			noteTweenAngle('flipNotesAngleTwn'..note1, note1 + 4, rot, 0.2, 'sineIn');
			runTimer('flipNotesAngleTimer'..note1, 0.25);
			intendedStrumPos[note1] = newX;
		else 
			newX = lastArrowPositions[note1];
			noteTweenX('flipNotesTwn'..note2, note2 + 4, newX, 0.3, 'sineInOut');
			noteTweenAngle('flipNotesAngleTwn'..note2, note2 + 4, rot, 0.2, 'sineIn');
			runTimer('flipNotesAngleTimer'..note2, 0.25);
			intendedStrumPos[note2] = newX;
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	for i = 0, 3 do
		if tag == 'flipNotesAngleTimer'..i then
			noteTweenAngle('flipNotesAngleTwn'..i, i + 4, 0, 0.4, 'elasticOut');
		end
	end

	if tag == 'removeTrailThing' then
		for i = 0, 3 do
			tag = 'psychicNoteTrail'..i;
			doTweenAlpha(tag..'alphaTweenThing', tag, 0.0, 0.2, 'sineOut');
		end
	end
end