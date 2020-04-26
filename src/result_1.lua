local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function gotoMenu()
    composer.gotoScene("src.menu", { time = 800, effect = "crossFade" })
end

local function nextLevel()
    composer.gotoScene("src.plug", { time = 800, effect = "crossFade" })
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

    if composer.getVariable('isWin') then
        text = 'Ура, вы прошли уровень!'
        local shopButton = display.newText(sceneGroup, "дальше", display.contentCenterX, display.contentCenterY + 50)
        shopButton:addEventListener("tap", nextLevel)
    else
        text = 'Увы, вы проиграли,\nпопробуйте снова!'
    end
    display.newText(sceneGroup, text, display.contentCenterX, display.contentCenterY / 2, native.systemFont, 32)
    local shopButton = display.newText(sceneGroup, "перейти в меню", display.contentCenterX, display.contentCenterY + 100)
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
