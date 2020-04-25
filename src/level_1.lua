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

local function gotoResultScreen()
    composer.gotoScene("src.plug", { time = 800, effect = "crossFade" })
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

local function tapOnHero()
    countTab = countTab + 1
    countTabText.text = countTab

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
end

local function gameLoop()
    if levelTime > 0 then
        levelTime = levelTime - 1
    end
    timeText.text = levelTime

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
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(sceneGroup, "assets/background_level_1.png", 540, 960)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    countTabText = display.newText(sceneGroup, countTab, display.contentCenterX, display.contentCenterY / 2, native.systemFont, 64)
    timeText = display.newText(sceneGroup, levelTime, display.contentCenterX, display.contentCenterY / 3, native.systemFont, 64)

    local levelTabText = display.newText(sceneGroup, "Цель уровня: "..levelCount, 20, 20, native.systemFont, 32)
    levelTabText.anchorX = 0
    levelTabText.anchorY = 0

    hero = display.newImageRect(sceneGroup, "assets/hero.png", 316, 264)
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
