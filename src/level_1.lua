local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local hero
local countTab = 0
local countTabText
local prevTapTime = 0
local levelTime = 40
local timeText
local levelCount = 200
local gameLoopTimer
local upGroup
local downGroup

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
    composer.setVariable('isWin', checkWin())
    composer.gotoScene("src.result_1", { time = 800, effect = "crossFade" })
end

local function createMiniHero()
    local h = math.random(20, 100)
    local w = 1.2 * h
    local newMiniHero = display.newImageRect(downGroup, "assets/hero.png", w, h)
    newMiniHero.x = hero.x
    newMiniHero.y = hero.y
    newMiniHero:rotate(math.random(360))

    local r = 800
    local xEnd = (math.random(2*r) -r)
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
    if countTab < 200 then
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
    if levelTime > 0 then
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

    downGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert(downGroup)  -- Insert into the scene's view group

    upGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert(upGroup)  -- Insert into the scene's view group

    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(downGroup, "assets/background_level_1.png", 540, 960)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    countTabText = display.newText(downGroup, countTab, display.contentCenterX, display.contentCenterY / 2, native.systemFont, 64)
    timeText = display.newText(downGroup, levelTime, display.contentCenterX, display.contentCenterY / 3, native.systemFont, 64)

    local levelTabText = display.newText(downGroup, "Цель уровня: " .. levelCount, 20, 20, native.systemFont, 32)
    levelTabText.anchorX = 0
    levelTabText.anchorY = 0

    hero = display.newImageRect(upGroup, "assets/hero.png", 316, 264)
    hero.x = display.contentCenterX
    hero.y = display.contentCenterY + display.contentCenterY / 3
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
        composer.removeScene("src.level_1")
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
