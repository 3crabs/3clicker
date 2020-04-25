local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local hero
local countCoin = 0
local countCoinText
local prevTapTime = 0

local function tapOnHero()
    countCoin = countCoin + 1
    countCoinText.text = countCoin

    -- анимация героя
    transition.to(hero, { time = 50, xScale = 1.1, yScale = 1.1 })
    transition.to(hero, { time = 50, delay = 55, xScale = 1, yScale = 1 })

    -- анимация количества монет
    local currentTapTime = system.getTimer()
    local delta = currentTapTime - prevTapTime
    local scale = 1 / (delta / 300)
    if scale < 1 then scale = 1 end
    transition.to(countCoinText, { time = 50, xScale = scale, yScale = scale })
    transition.to(countCoinText, { time = 100, delay = 55, xScale = 1, yScale = 1 })
    prevTapTime = currentTapTime
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    countCoinText = display.newText(countCoin, display.contentCenterX, display.contentCenterY / 2, native.systemFont, 64)

    local options = {
        -- Required parameters
        width = 316,
        height = 264,
        numFrames = 1,

        -- Optional parameters; used for scaled content support
        sheetContentWidth = 316, -- width of original 1x size of entire sheet
        sheetContentHeight = 264 -- height of original 1x size of entire sheet
    }
    local sequenceData = {
        name = "walking",
        start = 1,
        count = 3,
        time = 300,
        loopCount = 2, -- Optional ; default is 0 (loop indefinitely)
        loopDirection = "forward" -- Optional ; values include "forward" or "bounce"
    }
    local imageHero = graphics.newImageSheet("assets/hero.png", options)
    hero = display.newSprite(imageHero, sequenceData)
    hero.x = display.contentCenterX
    hero.y = display.contentCenterY + 150
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
