local lastDirectionHit = -1;
local psychicDanced = true;
animationList = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'};

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if dadName == 'psychic' then
		if not psychicDanced and lastDirectionHit == direction then
			characterPlayAnim('dad', animationList[direction+1]..'-alt', true);
		end
		lastDirectionHit = direction;
		psychicDanced = false;
	end
end

function onUpdatePost(elapsed)
	if psychicDanced then
		return;
	end

	if getProperty('dad.animation.curAnim.name') == 'idle' then
		psychicDanced = true;
	end
end
