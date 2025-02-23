--- Buff force's main build to match rocket silo health
data.raw['cargo-landing-pad']['cargo-landing-pad'].max_health = 5000

--- Make raw fish not deconstructible with planners/bots
local fish = data.raw.fish.fish
fish.flags = fish.flags or {}
table.insert(fish.flags, 'not-deconstructable')
