local QBCore = exports['qb-core']:GetCoreObject()

local BusyDumpsters = {} 
local LastFill      = {} 

local function RandomLoot()
  local items, slot = {}, 1
  local rolls = math.random(Config.LootRolls.min, Config.LootRolls.max)
  for i = 1, rolls do
    local e = Config.Loot[math.random(1, #Config.Loot)]
    if math.random(1, 100) <= (e.chance or 50) then
      items[slot] = { name = e.name, amount = math.random(e.min or 1, e.max or 1), info = {}, slot = slot }
      slot = slot + 1
      if slot > Config.StashSlots then break end
    end
  end
  if next(items) == nil then
    local f = Config.Loot[1]
    items[1] = { name = f.name, amount = math.random(f.min or 1, f.max or 2), info = {}, slot = 1 }
  end
  return items
end

-- Άνοιγμα κάδου
RegisterNetEvent('qb-dumpster-search:server:OpenDumpster', function(stashId)
  local src = source
  if BusyDumpsters[stashId] then
    TriggerClientEvent('QBCore:Notify', src, Config.BusyNotify, 'error', 2500)
    return
  end
  BusyDumpsters[stashId] = true


  exports['qb-inventory']:CreateStash(stashId, Config.StashLabel, Config.StashSlots, Config.StashMaxWeight)

  local now = os.time()
  local needRefill = (not LastFill[stashId]) or ((now - LastFill[stashId]) >= Config.CooldownSeconds)

  if needRefill then
    local items = RandomLoot()
    exports['qb-inventory']:SaveStashItems(stashId, items)
    LastFill[stashId] = now
  else

  end

  exports['qb-inventory']:OpenStash(src, stashId, {
    label = Config.StashLabel,
    slots = Config.StashSlots,
    maxweight = Config.StashMaxWeight,
  })

  BusyDumpsters[stashId] = nil
end)

