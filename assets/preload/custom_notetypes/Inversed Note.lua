function onCreate()
	for i = 0, getProperty('unspawnNotes.length') do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Inversed Note' then
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', not (getPropertyFromGroup('unspawnNotes', i, 'mustPress')));
		end
	end
end