--- Buff force's main build to match rocket silo health
local cargo_landing_pad = data.raw['cargo-landing-pad']['cargo-landing-pad']
cargo_landing_pad.is_military_target = true
cargo_landing_pad.max_health = 5000

--- Buff force's main build to match rocket silo health
local character = data.raw['character']['character']
character.is_military_target = true

--- Make raw fish not deconstructable with planners/bots
local fish = data.raw.fish.fish
fish.flags = fish.flags or {}
table.insert(fish.flags, 'not-deconstructable')

--- Fire utils
local fire_flame = table.deepcopy(data.raw.fire['fire-flame'])
fire_flame.name = 'bb-fire-flame'

local fire_sticker = table.deepcopy(data.raw.sticker['fire-sticker'])
fire_sticker.name = 'bb-fire-sticker'

data:extend({ fire_flame, fire_sticker })
