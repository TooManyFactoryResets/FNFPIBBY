
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
    if tag == 'noMo' then
        removeLuaText('reference', true)
    end
    
    -- notesplashes
    if tag == 'splashGoneLeft' then
		removeLuaSprite('splashLEFT', false)
	end
	if tag == 'splashGoneRight' then
		removeLuaSprite('splashRIGHT', false)
	end
	if tag == 'splashGoneUp' then
		removeLuaSprite('splashUP', false)
	end
	if tag == 'splashGoneDown' then
		removeLuaSprite('splashDOWN', false)
	end

end

local hadSplash = false
function onCreate()
    -- Set yo fucken framerate to 120 bitch
    setProperty('defaultCamZoom', 1)
    setProperty('scoreTxt.alpha', tonumber(0))
    --triggerEvent('Camera Follow Pos', '1100', '550')
    setProperty('dad.alpha', tonumber(0))
    setProperty('gf.alpha', tonumber(0))
    setProperty('boyfriend.alpha', tonumber(0.5))
    triggerEvent('Camera Follow Pos', '', '')
    setProperty('healthBar.alpha', tonumber(0))
    setProperty('iconP1.alpha', tonumber(0.8))
    setProperty('iconP2.alpha', tonumber(0))
    precacheImage('noteSplashesRIGHT')
    precacheImage('noteSplashesLEFT')
    precacheImage('noteSplashesDOWN')
    precacheImage('noteSplashesUP')

    if getPropertyFromClass('ClientPrefs', 'noteSplashes') == true then
        setPropertyFromClass('ClientPrefs', 'noteSplashes', false)
        hadSplash = true
    end

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 36);
    else
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 670);
    end
    setObjectCamera("fakeScore", 'hud');
    setTextColor('fakeScore', '0xffffff')
    setTextSize('fakeScore', 18);
    addLuaText("fakeScore");
    setTextFont('fakeScore', 'vcr.ttf')
    setTextAlignment('fakeScore', 'center')

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("misses", 'Misses: 0', 200, 950, 77);
    else
        makeLuaText("misses", 'Misses: 0', 200, 950, 639);
    end
    setObjectCamera("misses", 'hud');
    setTextColor('misses', '0x36eaf7')
    setTextSize('misses', 18);
    addLuaText("misses");
    setTextFont('misses', 'vcr.ttf')
    setTextAlignment('misses', 'center')
    
    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("reference", '(woah Flippy reference)', 300, 900, 47);
    else
        makeLuaText("reference", '(woah Flippy reference)', 300, 900, 669);
    end
    setObjectCamera("reference", 'hud');
    setTextColor('reference', '0x36eaf7')
    setTextSize('reference', 18);
    addLuaText("reference");
    setProperty('reference.alpha', tonumber(0.7))
    setTextFont('reference', 'vcr.ttf')
    setTextAlignment('reference', 'center')

    makeLuaText("gameOver", 'GAME OVER', 500, screenWidth / 2 - 250, screenHeight / 2 - 100);
    setObjectCamera("gameOver", 'hud');
    setTextColor('gameOver', 'ff0000')
    setTextSize('gameOver', 150);
    addLuaText("gameOver");
    setTextFont('gameOver', 'vcr.ttf')
    setProperty('gameOver.alpha', tonumber(0))
    setTextAlignment('gameOver', 'center')
end


function onCreatePost()
    if getPropertyFromClass('ClientPrefs', 'downScroll') == false then
        doTweenY('upABit', 'iconP2', 562, 0.01, 'linear')
    end
end

function onDestroy()
    if hadSplash == true then
        setPropertyFromClass('ClientPrefs', 'noteSplashes', true)
    end
end

function goodNoteHit()
    -- makes the fight fairer
    health = getProperty('health')
    if getProperty('health') > 0.1 then
       setProperty('health', health+ 0.030);
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    health = getProperty('health')
    if getProperty('health') > 0.2 then
        setProperty('health', health- 0.001);
    end

    -- notesplashes

    -- upscroll
    if getPropertyFromClass('ClientPrefs', 'downScroll') == false then
		if direction == 0 and isSustainNote == false then
			makeAnimatedLuaSprite('splashLEFT', 'noteSplashesLEFT', 40, -40)
            setObjectCamera('splashLEFT', 'hud')
			addAnimationByPrefix('splashLEFT', 'toTheLeft', 'noteSplashes 000', 24, false)
			addLuaSprite('splashLEFT', true)
			runTimer('splashGoneLeft', 0.2, 1)
		end
		if direction == 1 and isSustainNote == false then
			makeAnimatedLuaSprite('splashDOWN', 'noteSplashesDOWN', 154, -40)
            setObjectCamera('splashDOWN', 'hud')
			addAnimationByPrefix('splashDOWN', 'toTheDown', 'noteSplashes 000', 24, false)
			addLuaSprite('splashDOWN', true)
			runTimer('splashGoneDown', 0.2, 1)
		end
		if direction == 2 and isSustainNote == false then
			makeAnimatedLuaSprite('splashUP', 'noteSplashesUP', 270, -40)
            setObjectCamera('splashUP', 'hud')
			addAnimationByPrefix('splashUP', 'toTheUp', 'noteSplashes 000', 24, false)
			addLuaSprite('splashUP', true)
			runTimer('splashGoneUp', 0.2, 1)
		end
		if direction == 3 and isSustainNote == false then
			makeAnimatedLuaSprite('splashRIGHT', 'noteSplashesRIGHT', 380, -40)
            setObjectCamera('splashRIGHT', 'hud')
			addAnimationByPrefix('splashRIGHT', 'toTheRight', 'noteSplashes 000', 24, false)
			addLuaSprite('splashRIGHT', true)
			runTimer('splashGoneRight', 0.2, 1)
		end
    end

    -- downscroll
    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        if direction == 0 and isSustainNote == false then
            makeAnimatedLuaSprite('splashLEFT', 'noteSplashesLEFT', 40, 490)
            setObjectCamera('splashLEFT', 'hud')
            addAnimationByPrefix('splashLEFT', 'toTheLeft', 'noteSplashes 000', 24, false)
            addLuaSprite('splashLEFT', true)
            runTimer('splashGoneLeft', 0.2, 1)
        end
        if direction == 1 and isSustainNote == false then
            makeAnimatedLuaSprite('splashDOWN', 'noteSplashesDOWN', 154, 490)
            setObjectCamera('splashDOWN', 'hud')
            addAnimationByPrefix('splashDOWN', 'toTheDown', 'noteSplashes 000', 24, false)
            addLuaSprite('splashDOWN', true)
            runTimer('splashGoneDown', 0.2, 1)
        end
        if direction == 2 and isSustainNote == false then
            makeAnimatedLuaSprite('splashUP', 'noteSplashesUP', 270, 490)
            setObjectCamera('splashUP', 'hud')
            addAnimationByPrefix('splashUP', 'toTheUp', 'noteSplashes 000', 24, false)
            addLuaSprite('splashUP', true)
            runTimer('splashGoneUp', 0.2, 1)
        end
        if direction == 3 and isSustainNote == false then
            makeAnimatedLuaSprite('splashRIGHT', 'noteSplashesRIGHT', 380, 490)
            setObjectCamera('splashRIGHT', 'hud')
            addAnimationByPrefix('splashRIGHT', 'toTheRight', 'noteSplashes 000', 24, false)
            addLuaSprite('splashRIGHT', true)
            runTimer('splashGoneRight', 0.2, 1)
        end
    end
end

local laughing = false
function onUpdate(elapsed)
    if curStep == 1 then
        noteTweenAlpha("Mo5", 4, 0.8, 0.01,"quartInOut");
        noteTweenAlpha("Mo6", 5, 0.8, 0.01, "quartInOut");
        noteTweenAlpha("Mo7", 6, 0.8, 0.01, "quartInOut");
        noteTweenAlpha("Mo8", 7, 0.8, 0.01, "quartInOut");
    end
    if curBeat > 1 and curBeat < 360 then
        -- this shit slurps yo health every frame, which is why higher framerates can kill ya quick
        setProperty('health', getProperty('health')-0.0015)
       
    end
    -- pibbly
    if mustHitSection == true and curStep >= 384 and curStep <= 767 and laughing == false then
        triggerEvent('Camera Follow Pos', '820', '540')
    elseif mustHitSection == false and curStep >= 384 and curStep <= 767 and laughing == false then
        triggerEvent('Camera Follow Pos', '', '')
    end
    -- scary
    if mustHitSection == true and curStep >= 767 and curStep <= 1294 and laughing == false then
        triggerEvent('Camera Follow Pos', '850', '505')
    elseif mustHitSection == false and curStep >= 767 and curStep <= 1294 and laughing == false then
        triggerEvent('Camera Follow Pos', '600', '505')
    end
    if curStep == 1295 then
        triggerEvent('Camera Follow Pos', '', '')
    end

    scorin = getProperty('songScore')
    ratin = getProperty('ratingFC')
    local misses = getProperty('songMisses')
    setTextString('fakeScore', 'Score: ' .. scorin .. ' - ' .. ratin)
	
    if getProperty('songMisses') > 0 then
        setTextColor('misses', '0xffffff')
        setTextString('misses', 'Misses: ' .. misses)
        doTweenAlpha('referencegone', 'reference', 0, 0.3, 'linear')
        runTimer('noMo', 0.4, 2)
    end
    
end

function onStepHit()
    if curStep == 1 then
        doTweenAlpha('pibbfFade', 'dad', 1, 0.5, 'linear')
        doTweenAlpha('speakersFade', 'gf', 1, 1.2, 'linear')
        doTweenAlpha('dadIcon', 'iconP2', 1, 0.3, 'linear')
        doTweenAlpha('hpBar', 'healthBar', 1, 0.3, 'linear')
    end
    if curStep == 10 then
        doTweenAlpha('speakersFade', 'gf', 1, 1.2, 'linear')
    end

    -- laughing things
    if curStep >= 112 and curStep <= 127 then
        if curStep == 112 then 
            triggerEvent('Camera Follow Pos', '300', '550')
            setProperty('defaultCamZoom', 1 + 0.1)
            -- just using events
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 114 then 
            setProperty('defaultCamZoom', 1 + 0.2)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 116 then 
            setProperty('defaultCamZoom', 1 + 0.3)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 118 then 
            setProperty('defaultCamZoom', 1 + 0.4)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 120 then 
            setProperty('defaultCamZoom', 1 + 0.5)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 122 then 
            setProperty('defaultCamZoom', 1 + 0.6)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 124 then 
            setProperty('defaultCamZoom', 1 + 0.7)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 126 then
            triggerEvent('Camera Follow Pos', '', '')
            setProperty('defaultCamZoom', 1)
        end
    end
    if curStep >= 496 and curStep <= 511 then
        if curStep == 496 then 
            laughing = true
            triggerEvent('Camera Follow Pos', '300', '550')
            setProperty('defaultCamZoom', 1 + 0.1)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 498 then 
            setProperty('defaultCamZoom', 1 + 0.2)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 500 then 
            setProperty('defaultCamZoom', 1 + 0.3)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 502 then 
            setProperty('defaultCamZoom', 1 + 0.4)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 504 then 
            setProperty('defaultCamZoom', 1 + 0.5)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 506 then 
            setProperty('defaultCamZoom', 1 + 0.6)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 508 then 
            setProperty('defaultCamZoom', 1 + 0.7)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 510 then 
            laughing = false
            triggerEvent('Camera Follow Pos', '', '')
            setProperty('defaultCamZoom', 1)
            --characterPlayAnim('dad', 'singUP', true)
        end
    end
    if curStep >= 1008 and curStep <= 1022 then
        if curStep == 1008 then 
            laughing = true
            triggerEvent('Camera Follow Pos', '300', '550')
            setProperty('defaultCamZoom', 1 + 0.1)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1010 then 
            setProperty('defaultCamZoom', 1 + 0.2)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1012 then 
            setProperty('defaultCamZoom', 1 + 0.3)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1014 then 
            setProperty('defaultCamZoom', 1 + 0.4)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1016 then 
            setProperty('defaultCamZoom', 1 + 0.5)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1018 then 
            setProperty('defaultCamZoom', 1 + 0.6)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1020 then 
            setProperty('defaultCamZoom', 1 + 0.7)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1022 then 
            laughing = false
            triggerEvent('Camera Follow Pos', '', '')
            setProperty('defaultCamZoom', 1)
            --characterPlayAnim('dad', 'singUP', true)
        end
    end
    if curStep >= 1280 and curStep <= 1294 then
        if curStep == 1280 then 
            laughing = true
            triggerEvent('Camera Follow Pos', '300', '550')
            setProperty('defaultCamZoom', 1 + 0.1)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1282 then 
            setProperty('defaultCamZoom', 1 + 0.2)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1284 then 
            setProperty('defaultCamZoom', 1 + 0.3)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1286 then 
            setProperty('defaultCamZoom', 1 + 0.4)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1288 then 
            setProperty('defaultCamZoom', 1 + 0.5)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1290 then 
            setProperty('defaultCamZoom', 1 + 0.6)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1292 then 
            setProperty('defaultCamZoom', 1 + 0.7)
            --characterPlayAnim('dad', 'singUP', true)
        end
        if curStep == 1294 then 
            laughing = false
            triggerEvent('Camera Follow Pos', '', '')
            setProperty('defaultCamZoom', 1)
            --characterPlayAnim('dad', 'singUP', true)
        end
    end
    if curStep == 1426 then
        doTweenAlpha('loserYouAre', 'gameOver', 1, 0.6, 'linear')
    end
    if curStep == 1454 then
        doTweenAlpha('loserYouAreGone', 'gameOver', 0, 0.6, 'linear')
    end
end