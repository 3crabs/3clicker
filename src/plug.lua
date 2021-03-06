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


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view

    clickSound = audio.loadSound("sounds/click.wav")
    -- Code here runs when the scene is first created but has not yet appeared on screen

    display.newText(sceneGroup, "Мы боремся за то, чтобы этот раздел\nбыл доступен вам!\nС уважением,\nкоманда 3CRABS games", display.contentCenterX, display.contentCenterY)
    local shopButton = display.newText(sceneGroup, "перейти в меню", display.contentCenterX - 130, display.contentCenterY + 100)
    shopButton:addEventListener("tap", gotoMenu)
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
        composer.removeScene("src.plug")
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
