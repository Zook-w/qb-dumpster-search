# qb-dumpster-search
Simple Dumpster search working with latest version QBCore including QB-Inventory

Add this in qb-inventory/server/functions.lua

-- === Stash compatibility helpers / exports ===
local function _CreateStash(stashId, label, slots, maxweight)
    Inventories[stashId] = Inventories[stashId] or { items = {}, isOpen = false }
    Inventories[stashId].label = label or (Inventories[stashId].label or stashId)
    Inventories[stashId].slots = slots or (Inventories[stashId].slots or 10)
    Inventories[stashId].maxweight = maxweight or (Inventories[stashId].maxweight or 20000)
end
exports('CreateStash', _CreateStash)


local function _SaveStashItems(stashId, items)
    Inventories[stashId] = Inventories[stashId] or { items = {}, isOpen = false }

    local normalized = {}
    for k, v in pairs(items or {}) do
        if v and v.name then
            local key = string.lower(v.name)
            local def = QBCore.Shared.Items[key]
            if def then
                local slot = v.slot or k
                normalized[slot] = {
                    name    = def.name,
                    label   = def.label,
                    weight  = def.weight or 0,
                    type    = def.type or 'item',
                    unique  = def.unique or false,
                    useable = def.useable or false,
                    image   = def.image or (def.name .. '.png'),
                    amount  = v.amount or 1,
                    info    = v.info or {},
                    slot    = slot
                }
            else
                print(('[qb-inventory] WARNING: item "%s" not found in QBCore.Shared.Items'):format(tostring(v.name)))
            end
        end
    end

    Inventories[stashId].items = normalized
end
exports('SaveStashItems', _SaveStashItems)

local function _OpenStash(src, stashId, data)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    Inventories[stashId] = Inventories[stashId] or { items = {}, isOpen = false }
    local formatted = {
        name = stashId,
        label = (data and data.label) or (Inventories[stashId].label or stashId),
        maxweight = (data and data.maxweight) or (Inventories[stashId].maxweight or 20000),
        slots = (data and data.slots) or (Inventories[stashId].slots or 10),
        inventory = Inventories[stashId].items
    }
    Inventories[stashId].isOpen = true
    TriggerClientEvent('qb-inventory:client:openInventory', src, Player.PlayerData.items, formatted)
end
exports('OpenStash', _OpenStash)
