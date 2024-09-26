-- cam vars
local xx = 600;
local yy = 550;
local xx2 = 920;
local yy2 = 550;
local ofs = 15;
local followchars = true;

local allowCountdown = false
local startedEndDialogue = false
function onStartCountdown()

	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
	end

	return Function_Continue;
end

function onEndSong()
    if allowCountdown == true then
        allowCountdown = false
    end
    if not allowCountdown and isStoryMode and not startedEndDialogue then
        setProperty('inCutscene', true);
        runTimer('startDialogueEnd', 0.8);
        startedEndDialogue = true;
        return Function_Stop;
    end

    return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', '');
	end
    if tag == 'startDialogueEnd' then
        startDialogue('dialogueEnd', '');
    end
    if tag == 'fadelin1' then
        doTweenAlpha('comeChild1', 'gotShot?', 1, 1.3, 'linear')
    end
    if tag == 'getOut1' then
        doTweenAlpha('leavenow1', 'gotShot?', 0, 1.8, 'linear')
    end

    if tag == 'fadelin2' then
        doTweenAlpha('comeChild2', 'gotShot?2', 1, 1.6, 'linear')
    end
    if tag == 'getOut1' then
        doTweenAlpha('leavenow2', 'gotShot?2', 0, 2.3, 'linear')
    end
end

function onCreate()
    -- test thing -- setProperty('health', 2)
    setProperty('scoreTxt.alpha', tonumber(0))
    
    local var font = "vcr.ttf" -- the font that the text will use.
    cmoffset = -4
    cmy = 20
    tnhx = -10
    offsetYoursX = 940
    offsetUpY = 639
    diffCntrHHisX = 155

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("limit", 'Limit: 0', 200, 920, 77);
    else
        makeLuaText("limit", 'Limit: 0', 200, 920, 639);
    end
    setObjectCamera("limit", 'hud');
    setTextColor('limit', '0x36eaf7')
    setTextSize('limit', 20);
    addLuaText("limit");
    setTextFont('limit', font)
    setTextAlignment('limit', 'center')

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 36);
    else
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 670);
    end
    setObjectCamera("fakeScore", 'hud');
    setTextColor('fakeScore', '0xffffff')
    setTextSize('fakeScore', 18);
    addLuaText("fakeScore");
    setTextFont('fakeScore', font)
    setTextAlignment('fakeScore', 'center')
end

function onCreatePost()
    --setProperty('defaultCamZoom', 0.6)
    makeLuaText('gotShot?', "If you get shot, hold space.", 500, screenWidth / 2 - 250, screenHeight / 2 + 180);
    setObjectCamera("gotShot?", 'other');
    setTextColor('gotShot?', '0xffff33')
    setTextSize('gotShot?', 20);
    addLuaText("gotShot?");
    setProperty('gotShot?.alpha', tonumber(0))
    setTextFont('gotShot?', font);
    setTextAlignment('gotShot?', 'center');

    makeLuaText('gotShot?2', "It'll lessen the damage you take.", 500, screenWidth / 2 -250, screenHeight / 2 + 220);
    setObjectCamera("gotShot?2", 'other');
    setTextColor('gotShot?2', '0xffff33')
    setTextSize('gotShot?2', 20);
    addLuaText("gotShot?2");
    setProperty('gotShot?2.alpha', tonumber(0))
    setTextFont('gotShot?2', font)
    setTextAlignment('gotShot?2', 'center')

    
end

function opponentNoteHit()
    if mustHitSection == false then
        health = getProperty('health')
        if getProperty('health') > 0.5 and curStep < 1246 then
            setProperty('health', health- 0.04);
        end
    end

    if mustHitSection == true and getProperty("dad.curCharacter") == 'pico-SAVEHIM' and getProperty('dad.animation.curAnim.name') == 'idle' then
        triggerEvent('Change Character', 'dad', 'pico')
    elseif mustHitSection == true and getProperty("dad.curCharacter") == 'pico' and getProperty('dad.animation.curAnim.name') == 'idle' then
        triggerEvent('Change Character', 'dad', 'pico-SAVEHIM')
    end
    -- failsafe i guess
    if mustHitSection == true then
        triggerEvent('Change Character', 'dad', 'pico-SAVEHIM')
    end
end

function onUpdate(elapsed)

    if getProperty('dad.curCharacter') == 'pico-SAVEHIM' and getPropertyFromClass('ClientPrefs', 'downScroll') == false then
        doTweenY('upABit', 'iconP2', 562, 0.01, 'linear')
    elseif getProperty('dad.curCharacter') ~= 'pico-SAVEHIM' and getPropertyFromClass('ClientPrefs', 'downScroll') == false then
        doTweenY('downABit', 'iconP2', 572, 0.01, 'linear')
    end
    -- hint
    if curStep == 3 then
        runTimer('fadelin1', 1, 1);
    elseif curStep == 40 then
        runTimer('getOut1', 1, 1);
    end
    if curStep == 4 then
        runTimer('fadelin2', 1, 1);
    elseif curStep == 41 then
        runTimer('getOut2', 1, 1);
    end

        -- transformation
    if getProperty('songMisses') == 5 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
        cameraFlash('game', '0xffffff', 0.2)
      --characterPlayAnim('boyfriend', 'hurt', true)
        triggerEvent('Change Character', 'bf', 'bf@NOWYOU')
    end

    local var oops = 5
    -- limit counter
    if getProperty('songMisses') == 1 then
        oops = 4
        doTweenColor('noPerfect:(', 'limit', 'ffffff', 0.1, 'linear')
    end
    if getProperty('songMisses') == 2 then
        oops = 3
    end
    if getProperty('songMisses') == 3 then
        oops = 2
    end
    if getProperty('songMisses') == 4 then
        oops = 1
    end
    if getProperty('songMisses') == 5 then
        oops = 0
        setTextColor('limit', 'ff0000');
    end
    if getProperty('songMisses') > 5 then
        oops = 0
    end
    setTextString('limit', 'Limit: ' .. oops)

    
    if oops == 2 then
        if curBeat % 2 == 0 then
            setTextColor('limit', 'ff0000');
        end
        if curBeat % 2 == 1 then
            setTextColor('limit', 'ffffff')
        end
    end 

    if oops == 1 then
        if curStep % 2 == 0 then
            setTextColor('limit', 'ff0000');
        end
        if curStep % 2 == 1 then
            setTextColor('limit', '0xffffff')
        end
    end

    -- score shit
    scorin = getProperty('songScore')
    ratin = getProperty('ratingFC')
    setTextString('fakeScore', 'Score: ' .. scorin .. ' - ' .. ratin)

    --if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.L') then
      --  addMisses(1)
    --end
    if followchars == true then
        if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                    triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
end

function onStepHit()
    if curBeat > 0 then
        if curBeat < 289 then
            cameraShake('hud', 0.003, 0.2);
        end
    end

    -- long time?
    
    -- folding time
    if curStep == 1246 then
        --triggerEvent('Camera Follow Pos', '', '')
        removeLuaText('gotShot?', true)
        removeLuaText('gotShot?2', true)
    end
    if curStep == 1247 then
        --triggerEvent('Camera Follow Pos', '100', '100')
        doTweenAlpha('limitSmlimit', 'limit', 0, 0.6, 'linear')
        playSound('1pico_gets_slid')
    end
    if curStep == 1276 then
        cameraFade('game', '000000', 0.8, false)
        doTweenX('beatDown!Time!', 'boyfriend', 550, 0.3, 'linear')
        characterPlayAnim('boyfriend', 'pre-attack', false)
    end
    if curStep == 1279 then
        characterPlayAnim('boyfriend', 'attack', false)
        playSound('2folded_like_an_omelet', 0.50)
    end
end

function onBeatHit()

    --random = math.random(1, 5)
    if curBeat % 2 == 1 and getProperty("dad.curCharacter") == 'pico-SAVEHIM' and getProperty('dad.animation.curAnim.name') == 'idle' and curBeat < 32 then
        --cameraFlash('game', '0xFFFFFF', 0.3, true)
        triggerEvent('Change Character', 'dad', 'pico')
    elseif curBeat % 2 == 0 and getProperty("dad.curCharacter") == 'pico' and getProperty('dad.animation.curAnim.name') == 'idle' or curBeat >= 32 then
        triggerEvent('Change Character', 'dad', 'pico-SAVEHIM')
    end    

    if curBeat == 292 and getProperty('boyfriend.curCharacter') == 'bf@NOWYOU' then
        playSound('HA_HA')
        -- bdeath
        setProperty('health', -999)
    end
end