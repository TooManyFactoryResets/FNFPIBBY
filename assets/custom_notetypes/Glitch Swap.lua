function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == "Glitch Swap" then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'GlitchSwapNote_Assets'); --Change texture

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			end
		end
	end
end
-- This note exists for better contrast and noticabiliy against the dark bg's and other dark note you HAVE to hit
-- basically just a glitch note but dark red
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == "Glitch Swap" then
		setProperty('health', getProperty('health')-3);
		playSound('HA_HA', 0.8);
		addMisses(999);
		characterPlayAnim('boyfriend', 'hurt', true);
	end

end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == "Glitch Swap" then
		setProperty('health', getProperty('health') +0.0475);
		addMisses(-1);
		cameraShake('camGame', 0.01, 0.2);
	end
end