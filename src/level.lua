local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local monsterKillSound

local startGame = false

local hero
local countTab = 0
local countTabText
local prevTapTime = 0
local levelTime
local timeText
local levelCount
local gameLoopTimer
local upGroup
local downGroup
local number = composer.getVariable("number")

local cock
local streakLevel = 2
local streakCount = 0

local function getPostfix()
    return '_' .. number
end

local function initLevel()
    if number == 1 then
        levelCount = 200
        levelTime = 30
    end
    if number == 2 then
        levelCount = 300
        levelTime = 40
    end
    if number == 3 then
        levelCount = 450
        levelTime = 50
    end
    if number == 4 then
        levelCount = 800
        levelTime = 60
    end
    if number == 5 then
        levelCount = 150
        levelTime = 20
    end
    if number == 6 then
        levelCount = 110
        levelTime = 15
    end
    if number == 7 then
        levelCount = 90
        levelTime = 10
    end
end

local function checkEnd()
    if (countTab >= levelCount) then
        return true
    end

    if levelTime <= 0 then
        return true
    end
    return false
end

local function checkWin()
    if (countTab >= levelCount) then
        return true
    end
    return false
end

local function gotoResultScreen()
    timer.cancel(gameLoopTimer)
    if checkWin() then
        composer.gotoScene("src.win", { time = 800, effect = "crossFade" })
    else
        composer.gotoScene("src.death", { time = 800, effect = "crossFade" })
    end
end

local function createMiniHero()
    local h = math.random(20, 100)
    local w = 1.2 * h
    local newMiniHero = display.newImageRect(downGroup, "assets/hero.png", w, h)
    newMiniHero.x = hero.x
    newMiniHero.y = hero.y
    newMiniHero:rotate(math.random(360))
    physics.addBody(newMiniHero, "dynamic", { radius = w / 2, bounce = 0.8 })

    local r = 800
    local xEnd = (math.random(2 * r) - r)
    local yEnd = ((-1) ^ math.random(1, 2)) * math.sqrt(r * r - xEnd * xEnd)
    transition.to(newMiniHero, {
        x = xEnd + hero.x,
        y = yEnd + hero.y,
        time = 650,
        onComplete = function()
            display.remove(newMiniHero)
        end
    })
end

local function tapOnHero()
    startGame = true

    if countTab < levelCount then
        countTab = countTab + 1
    end

    -- анимация количества монет
    local currentTapTime = system.getTimer()
    local delta = currentTapTime - prevTapTime
    local scale = 1 / (delta / 300)
    if scale < 1 then
        scale = 1
    end

    if scale >= streakLevel then
        streakCount = streakCount + 1
        if streakCount >= 5 then
            countTab = countTab + 1
            cock.x = display.contentCenterX - 130
            cock.y = display.contentCenterY - 130
        end
    else
        countTab = countTab + streakCount
        streakCount = 0
        cock.x = display.contentCenterX + 520
        cock.y = display.contentCenterY + 140
    end

    transition.to(countTabText, { time = 50, xScale = scale, yScale = scale })
    transition.to(countTabText, { time = 100, delay = 55, xScale = 1, yScale = 1 })
    prevTapTime = currentTapTime

    -- анимация героя
    local heroScaleX = 1.1
    local heroScaleY = 1.1
    if streakCount >= 10 then
        heroScaleX = 0.8
        heroScaleY = 0.8
        monsterKillSound.play()
    end
    transition.to(hero, { time = 50, xScale = heroScaleX, yScale = heroScaleY })
    transition.to(hero, { time = 50, delay = 55, xScale = 1, yScale = 1 })

    countTabText.text = countTab

    for _ = 1, scale do
        createMiniHero()
    end
end

local function gameLoop()
    if levelTime > 0 and startGame then
        levelTime = levelTime - 1
        timeText.text = levelTime
    end

    if checkEnd() then
        composer.setVariable("gameResult", checkWin())
        gotoResultScreen()
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view

    initLevel()

    monsterKillSound = audio.loadSound("sounds/monster_kill_sound.mp3")

    downGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert(downGroup)  -- Insert into the scene's view group

    upGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert(upGroup)  -- Insert into the scene's view group

    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(downGroup, "assets/background_level" .. getPostfix() .. ".png", 540, 960)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- петух
    local cockSheetOptions = {
        width = 725,
        height = 378,
        numFrames = 5,
        sourceX = 150
    }
    local cockSheet = graphics.newImageSheet("assets/cock.png", cockSheetOptions)
    local cockSequences = {
        {
            name = "normalRun",
            start = 1,
            count = 5,
            time = 800,
            loopCount = 0,
            loopDirection = "forward"
        }
    }
    cock = display.newSprite(downGroup, cockSheet, cockSequences)
    cock.x = display.contentCenterX + 520
    cock.y = display.contentCenterY + 140
    cock:rotate(82)
    cock:play()

    local platform_bottom = display.newRect(downGroup, display.contentCenterX, display.contentHeight, 540, 50)
    platform_bottom:setFillColor(1, 1, 1, 0)
    physics.addBody(platform_bottom, "static")
    local platform_top = display.newRect(downGroup, display.contentCenterX, 0, 540, 50)
    platform_top:setFillColor(1, 1, 1, 0)
    physics.addBody(platform_top, "static")
    local platform_left = display.newRect(downGroup, 0, display.contentCenterY, 50, 960)
    platform_left:setFillColor(1, 1, 1, 0)
    physics.addBody(platform_left, "static")
    local platform_right = display.newRect(downGroup, display.contentWidth, display.contentCenterY, 50, 960)
    platform_right:setFillColor(1, 1, 1, 0)
    physics.addBody(platform_right, "static")

    countTabText = display.newText(downGroup, countTab, display.contentCenterX, display.contentCenterY / 2, native.systemFont, 64)
    timeText = display.newText(downGroup, levelTime, display.contentCenterX, display.contentCenterY / 3 - 30, native.systemFont, 64)

    local levelTabText = display.newText(downGroup, "Цель уровня: " .. levelCount, 20, 20, native.systemFont, 32)
    levelTabText.anchorX = 0
    levelTabText.anchorY = 0

    hero = display.newImageRect(upGroup, "assets/hero.png", 316, 264)
    hero.x = display.contentCenterX
    hero.y = display.contentCenterY + display.contentCenterY / 3
    physics.addBody(hero, "dynamic", { radius = 150, bounce = 0.8 })

    hero:addEventListener("tap", tapOnHero)
end


-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay(1000, gameLoop, 0)
    end
end


-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("src.level")
    end
end


-- destroy()
function scene:destroy(event)

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

    audio.dispose(monsterKillSound)
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
