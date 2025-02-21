local Gui = require 'scripts.modules.gui'
local SplitView = require 'scripts.gui.split_view'

local Public = SplitView{
    main_button_name = Gui.uid_name('top_button'),
    main_button_sprite = 'utility/change_recipe',
    main_button_tooltip = 'Open the settings menu',
    main_frame_caption = 'Settings menu',
    main_frame_name = Gui.uid_name('main_frame'),
}

return Public
