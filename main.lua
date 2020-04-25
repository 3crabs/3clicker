-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")

-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Go to the menu screen
composer.gotoScene("src.menu")
--composer.gotoScene("src.level_1")
