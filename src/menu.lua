local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function gotoGame()
    composer.gotoScene("src.level_1", { time = 800, effect = "crossFade" })
end

local function gotoRecords()
    composer.gotoScene("src.plug", { time = 800, effect = "crossFade" })
end

local function gotoShop()
    composer.gotoScene("src.plug", { time = 800, effect = "crossFade" })
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(sceneGroup, "assets/background_menu.png", 540, 960)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local playButton = display.newImageRect(sceneGroup, "assets/button_menu.png", 250, 70)
    playButton.x = display.contentCenterX + 120
    playButton.y = display.contentCenterY - 90
    playButton:addEventListener("tap", gotoGame)
    display.newText(sceneGroup, "Играть", display.contentCenterX + 120, display.contentCenterY - 90)

    local recordsButton = display.newImageRect(sceneGroup, "assets/button_menu.png", 250, 70)
    recordsButton.x = display.contentCenterX + 120
    recordsButton.y = display.contentCenterY
    recordsButton:addEventListener("tap", gotoRecords)
    display.newText(sceneGroup, "Рекорды", display.contentCenterX + 120, display.contentCenterY)

    local shopButton = display.newImageRect(sceneGroup, "assets/button_menu.png", 250, 70)
    shopButton.x = display.contentCenterX + 120
    shopButton.y = display.contentCenterY + 90
    shopButton:addEventListener("tap", gotoShop)
    display.newText(sceneGroup, "Магазин", display.contentCenterX + 120, display.contentCenterY + 90)
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
        composer.removeScene("src.menu")
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
