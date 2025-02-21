return {
    force_names_map = {
        player = 'Spectator',
        north = 'North',
        south = 'South'
    },
    game_state = {
        initializing = 0,
        picking      = 1,
        preparing    = 2,
        playing      = 3,
        finished     = 4,
        resetting    = 5,
    },
    permission_group = {
        admin   = 'admin',
        default = 'default',
        jail    = 'jail',
        player  = 'player',
    },
    spawn_point = {
        player = { x = 0, y =   0 },
        north  = { x = 0, y = -90 },
        south  = { x = 0, y =  90 },
    },
    tags = {
        Referee    = { rank = 5, default = true, name = 'Referee',    sprite = 'info_no_border' },
        Captain    = { rank = 4, default = true, name = 'Captain',    sprite = 'virtual-signal/signal-star' },
        Custom     = { rank = 3, default = true, name = 'Custom',     sprite = 'item/coin' },
        Laser      = { rank = 2, default = true, name = 'Laser',      sprite = 'item/laser-turret' },
        Main       = { rank = 2, default = true, name = 'Main',       sprite = 'item/assembling-machine-2' },
        Nuclear    = { rank = 2, default = true, name = 'Nuclear',    sprite = 'item/nuclear-reactor' },
        Oil        = { rank = 2, default = true, name = 'Oil',        sprite = 'item/pumpjack' },
        Power      = { rank = 2, default = true, name = 'Power',      sprite = 'item/steam-engine' },
        Rocket     = { rank = 2, default = true, name = 'Rocket',     sprite = 'item/rocket-part' },
        Spam       = { rank = 2, default = true, name = 'Spam',       sprite = 'item/tank-cannon' },
        Support    = { rank = 2, default = true, name = 'Support',    sprite = 'item/electric-mining-drill' },
        Threatfarm = { rank = 2, default = true, name = 'Threatfarm', sprite = 'item/grenade' },
        Wall       = { rank = 2, default = true, name = 'Wall',       sprite = 'item/stone-wall' },
        East       = { rank = 1, default = true, name = 'East',       sprite = 'virtual-signal/signal-E' },
        West       = { rank = 1, default = true, name = 'West',       sprite = 'virtual-signal/signal-W' },
    }
}