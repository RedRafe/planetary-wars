local Gui = require 'scripts.public.gui'
local SplitView = require 'scripts.gui.split_view'

local Public = SplitView{
    main_button_name = Gui.uid_name('top_button'),
    main_button_sprite = 'utility/search',
    main_button_tooltip = 'Open the browser menu',
    main_frame_caption = 'Browser menu',
    main_frame_name = Gui.uid_name('main_frame'),
}

return Public