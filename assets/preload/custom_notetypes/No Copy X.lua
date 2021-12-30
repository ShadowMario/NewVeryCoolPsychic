function onCreate()
	for i = 0, getProperty('unspawnNotes.length') do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'No Copy X' then
			setPropertyFromGroup('unspawnNotes', i, 'copyX', false);
		end
	end
end