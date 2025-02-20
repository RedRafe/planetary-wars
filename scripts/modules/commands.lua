local Actions = require 'scripts.modules.command_actions'

for _, command in pairs({
    {
        name = 'instant-map-reset',
        help = 'Instantly rerolls a new map',
        action = Actions.instant_map_reset
    },
    {
        name = 'transition',
        help = 'Moves game state to nest stage',
        action = Actions.transition
    },
}) do
    commands.add_command( command.name, command.help, command.action)
end