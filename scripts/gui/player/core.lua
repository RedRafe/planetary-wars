local Gui = require 'scripts.public.gui'
local SplitView = require 'scripts.gui.split_view'

local Public = SplitView{
    main_button_name = Gui.uid_name('top_button'),
    main_button_sprite = 'entity/character',
    main_button_tooltip = 'Open the player menu',
    main_frame_caption = 'Player menu',
    main_frame_name = Gui.uid_name('main_frame'),
}

return Public