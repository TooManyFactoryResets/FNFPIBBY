local allowCountdown = false
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

function onCreate()
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
        makeLuaText("fakeScore", 'Score: 0 - ?', 300, 650, 670);
    end
    setObjectCamera("fakeScore", 'hud');
    setTextColor('fakeScore', '0xffffff')
    setTextSize('fakeScore', 18);
    addLuaText("fakeScore");
    setTextFont('fakeScore', font)
    setTextAlignment('fakeScore', 'center')
end

function onCreatePost()
    makeLuaText('dodgeIt', "They want to share their newfound joy with you.", 600, screenWidth / 2 + 50, screenHeight / 2 - 50);
    setObjectCamera("dodgeIt", 'other');
    setTextColor('dodgeIt', '0xff0000')
    setTextSize('dodgeIt', 20);
    addLuaText("dodgeIt");
    setProperty('dodgeIt.alpha', tonumber(0))
    setTextFont('dodgeIt', font);
    setTextAlignment('dodgeIt', 'center');

    makeLuaText('youFool', "Hit the arrows to avoid their attempts.", 500, screenWidth / 2 + 100, screenHeight / 2);
    setObjectCamera("youFool", 'other');
    setTextColor('youFool', '0xff0000')
    setTextSize('youFool', 20);
    addLuaText("youFool");
    setProperty('youFool.alpha', tonumber(0))
    setTextFont('youFool', font)
    setTextAlignment('youFool', 'center')

    makeLuaText('cool', "you can press space to hey woah (serves no purpose)", 650, 300, 300);
    setObjectCamera("cool", 'other');
    setTextColor('cool', '0xff0000')
    setTextSize('cool', 20);
    addLuaText("cool");
    setProperty('cool.alpha', tonumber(0))
    setTextFont('cool', font);
    setTextAlignment('cool', 'center');

    makeLuaText('cool2', "do it now im not asking", 600, 350, 320);
    setObjectCamera("cool2", 'other');
    setTextColor('cool2', '0xff0000')
    setTextSize('cool2', 20);
    addLuaText("cool2");
    setProperty('cool2.alpha', tonumber(0))
    setTextFont('cool2', font);
    setTextAlignment('cool2', 'center');

end    

function onUpdate(elapsed)
    
    -- transformation
    if getProperty('songMisses') >= 5 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
        cameraFlash('game', '0xffffff', 0.2)
        --characterPlayAnim('boyfriend', 'hurt', true)
        triggerEvent('Change Character', 'bf', 'bf@NOWYOU')
    end

    if curBeat == 425 and getProperty('boyfriend.curCharacter') == 'bf@NOWYOU' then
        playSound('HA_HA')
        setProperty('health', -100)
    end
    if keyJustPressed('space') then
        -- literally useless
        characterPlayAnim('boyfriend', 'hey', true)
    end

    -- hint
    if curStep == 1 then
        runTimer('fadelin1', 1, 1);
    elseif curStep == 30 then
        runTimer('getOut1', 1, 1);
    end
    if curStep == 1 then
        runTimer('fadelin2', 1, 1);
    elseif curStep == 30 then
        runTimer('getOut2', 1, 1);
    end

    --cool
    if curStep == 38 then
        runTimer('cool1', 1, 1);
    elseif curStep == 50 then
        runTimer('coolOut1', 1, 1);
    end
    if curStep == 38 then
        runTimer('cool2', 1, 1);
    elseif curStep == 50 then
        runTimer('coolOut2', 1, 1);
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
    --    addMisses(1)
    --end 
end


function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', '');
	end
    --if tag == 'startDialogueEnd' then
    --    startDialogue('dialogueEnd', '');
    --end
    if tag == 'fadelin1' then
        doTweenAlpha('comeChild1', 'dodgeIt', 1, 0.5, 'linear')
    end
    if tag == 'getOut1' then
        doTweenAlpha('leavenow1', 'dodgeIt', 0, 1, 'linear')
    end

    if tag == 'fadelin2' then
        doTweenAlpha('comeChild2', 'youFool', 1, 0.5, 'linear')
    end
    if tag == 'getOut1' then
        doTweenAlpha('leavenow2', 'youFool', 0, 1, 'linear')
    end

    if tag == 'cool1' then
        doTweenAlpha('coolUsefulInfoIn', 'cool', 1, 0.2, 'linear')
    end
    if tag == 'coolOut1' then
        doTweenAlpha('coolUsefulInfoOut', 'cool', 0, 0.2, 'linear')
    end
    if tag == 'cool2' then
        doTweenAlpha('coolUsefulInfoP2In', 'cool2', 1, 0.2, 'linear')
    end
    if tag == 'coolOut2' then
        doTweenAlpha('coolUsefulInfoP2Out', 'cool2', 0, 0.2, 'linear')
    end

    if tag == 'holdASec' then
        triggerEvent('Change Character', 'bf', 'bf@NOWYOU')
    end
end

function onBeatHit()

    if curBeat < 416 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
        local health = getProperty('health')
        if health > 0.32 and health < 1.5 then
            setProperty('health', health- 0.04)
        end
        if health >= 1.5 then
            setProperty('health', health- 0.07)
        end
    end
end