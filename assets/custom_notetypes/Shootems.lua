function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Shootems' then --Check if the note on the chart is a Shootems Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'Shootems_Assets'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', -65);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 35);
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end
--getPropertyFromClass('strumTime' - 1)
--or 
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Shootems' then

		cameraFlash('game', '0xFFFFFF', 0.2, true)
		playSound('HESGOTAGUN', 0.5)
		characterPlayAnim('boyfriend', 'dodge', true)
		setProperty('boyfriend.specialAnim', true);
		if songName == 'Gunshot' then
			triggerEvent('Change Character', 'dad', 'pico-SAVEHIM')
		end
		if songName == 'Gunshot' then
			characterPlayAnim('dad', 'singDOWN', true)
		end
		setProperty('health', getProperty('health')+ 0.04)
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	local shotCounter = 0

	if noteType == 'Shootems' then
		cameraFlash('game', '0xFFFFFF', 0.2, true)
		playSound('HESGOTAGUN')
		shotCounter = shotCounter + 3
		setProperty('health', getProperty('health')- 0.2)
		characterPlayAnim('boyfriend', 'hurt', true)
		setProperty('boyfriend.specialAnim', true);
		if songName == 'Gunshot' then
			characterPlayAnim('dad', 'singDOWN', true)
		end
		repeat

			shotCounter = shotCounter - 1
			runTimer('shot', 0.5, 10)
			if shotCounter < 0 then
				shotCounter = 0
			end
			

		until shotCounter == 0
		
	end
	
end


function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'shot' then
		if keyPressed("space") then
			setProperty('health', getProperty('health')- 0.05)
		else
			setProperty('health', getProperty('health')- 0.131)
		end
	end
end