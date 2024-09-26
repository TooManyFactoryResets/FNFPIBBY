local xx = 580;
local yy = 450;
local xx2 = 820;
local yy2 = 450;
local ofs = 15;
local followchars = true;
function onCreate()
    addCharacterToList('bf@NOWYOU', 'boyfriend')
    precacheImage('Ghost_Kids')
    precacheSound('splat')
    precacheSound('HA_HA')
	-- background shit
	makeLuaSprite('spookstage', 'spookstageP', -200, -125);
	
    --makeAnimatedLuaSprite('spookyWooky', 'Ghost_Kids', -100, 100)
    --addAnimationByIndices('spookyWooky', 'idle', 'spooky dance idle0', 24, false)

	addLuaSprite('spookstage', false);
    addLuaSprite('spookyWooky', false)

    makeAnimatedLuaSprite('glitch', 'static', -600, -300);
    scaleObject('glitch', 2, 2);
    addAnimationByPrefix('glitch', 'glitchout', 'static glitch', 24, true);
    objectPlayAnimation('glitch', 'glitchout');
    addLuaSprite('glitch', true); -- false = add behind characters, true = add over characters
    triggerEvent('Load Shader', '', '')-- delete if you dont want the shader
        
end

function onStepHit()
    cameraShake('hud', 0.003, 0.2);
end

function onBeatHit()
    --objectPlayAnimation('spookyWooky', 'idle', true)
end

function opponentNoteHit()	
    local luckyRoll = math.random(1, 50)
    local luckyRoll2 = math.random(1, 50)
    
    if mustHitSection == false then
        if (luckyRoll >= 45) then
            cameraShake('hud', 0.08, 0.05);
        end
    end
    if mustHitSection == false then
        if (luckyRoll2 >= 45) then
            cameraShake('game', 0.08, 0.05);
        end
    end
end

function onUpdate()
    if followchars == true then
        if mustHitSection == false then
            setProperty('defaultCamZoom',0.85)
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
            setProperty('defaultCamZoom',1.05)
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