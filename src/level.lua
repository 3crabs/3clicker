local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

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

local function getPostfix()
    return '_' .. number
end

local function initLevel()
    if number == 1 then
        levelCount = 200
        levelTime = 30
    end
    if number == 2 then
        levelCount = 400
        levelTime = 40
    end
    if number == 3 then
        levelCount = 600
        levelTime = 50
    end
    if number == 4 then
        levelCount = 1000
        levelTime = 60
    end
    if number == 5 then
        levelCount = 150
        levelTime = 20
    end
    if number == 6 then
        levelCount = 125
        levelTime = 15
    end
    if number == 7 then
        levelCount = 100
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
        countTabText.text = countTab
    end

    -- анимация героя
    transition.to(hero, { time = 50, xScale = 1.1, yScale = 1.1 })
    transition.to(hero, { time = 50, delay = 55, xScale = 1, yScale = 1 })

    -- анимация количества монет
    local currentTapTime = system.getTimer()
    local delta = currentTapTime - prevTapTime
    local scale = 1 / (delta / 300)
    if scale < 1 then
        scale = 1
    end

    transition.to(countTabText, { time = 50, xScale = scale, yScale = scale })
    transition.to(countTabText, { time = 100, delay = 55, xScale = 1, yScale = 1 })
    prevTapTime = currentTapTime

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

    downGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert(downGroup)  -- Insert into the scene's view group

    upGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert(upGroup)  -- Insert into the scene's view group

    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(downGroup, "assets/background_level" .. getPostfix() .. ".png", 540, 960)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

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
