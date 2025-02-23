local Special = {}

local this = {
    enabled = false
}

bb.subscribe(this, function(tbl) this = tbl end)

Special.enabled = function()
    return this.enabled
end

return Special
