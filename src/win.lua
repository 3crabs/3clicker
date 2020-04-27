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

local function nextLevel()
    audio.play(clickSound)
    composer.setVariable("number", composer.getVariable("number") + 1)
    composer.gotoScene("src.level", { time = 800, effect = "crossFade" })
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    clickSound = audio.loadSound("sounds/click.wav")

    local background = display.newImageRect(sceneGroup, "assets/background_win.png", 540, 960)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local rect = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 450, 500)
    rect:setFillColor(0, 0, 0, 0.7)

    display.newText(sceneGroup, 'Ура, вы прошли уровень!', display.contentCenterX, display.contentCenterY - 100, native.systemFont, 32)

    if composer.getVariable("number") < 7 then
        local nextLevelButton = display.newImageRect(sceneGroup, "assets/button_menu.png", 250, 70)
        nextLevelButton.x = display.contentCenterX
        nextLevelButton.y = display.contentCenterY + 70
        nextLevelButton:addEventListener("tap", nextLevel)
        display.newText(sceneGroup, "дальше", display.contentCenterX, display.contentCenterY + 70)
    else
        display.newText(sceneGroup, 'Вы прошли beta\nверсию 3clicker!', display.contentCenterX, display.contentCenterY, native.systemFont, 32)
    end

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
