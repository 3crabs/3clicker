-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")

-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Seed the random number generator
math.randomseed(os.time())

-- Go to the menu screen
--composer.gotoScene("src.menu")
--composer.setVariable("number", 1)
--composer.gotoScene("src.level")
--composer.gotoScene("src.death")
composer.gotoScene("src.win")
