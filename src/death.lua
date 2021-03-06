local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local clickSound

local function gotoMenu()
    audio.play(clickSound)
    composer.gotoScene("src.menu", { time = 800, effect = "crossFade" })
end

local function returnLevel()
    audio.play(clickSound)
    composer.gotoScene("src.level", { time = 800, effect = "crossFade" })
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view

    clickSound = audio.loadSound("sounds/click.wav")
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(sceneGroup, "assets/background_death.png", 540, 960)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local rect = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 450, 500)
    rect:setFillColor(0, 0, 0, 0.7)

    display.newText(sceneGroup, 'Увы, вы проиграли,\nпопробуйте снова!', display.contentCenterX, display.contentCenterY - 100, native.systemFont, 32)

    local returnButton = display.newImageRect(sceneGroup, "assets/button_menu.png", 250, 70)
    returnButton.x = display.contentCenterX
    returnButton.y = display.contentCenterY + 70
    returnButton:addEventListener("tap", returnLevel)
    display.newText(sceneGroup, "заново", display.contentCenterX, display.contentCenterY + 70)

    local menuButton = display.newImageRect(sceneGroup, "assets/button_menu.png", 250, 70)
    menuButton.x = display.contentCenterX
    menuButton.y = display.contentCenterY + 160
    menuButton:addEventListener("tap", gotoMenu)
    display.newText(sceneGroup, "перейти в меню", display.contentCenterX, display.contentCenterY + 160)
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

    audio.dispose(clickSound)
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
