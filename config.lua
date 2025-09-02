Config = {}

Config.DumpsterModels = {
  `prop_dumpster_01a`,
  `prop_dumpster_02a`,
  `prop_dumpster_02b`,
  `prop_dumpster_3a`,
  `prop_dumpster_4a`,
  `prop_bin_05a`
}


Config.UseQBTarget = true
Config.TargetDistance = 2.0
Config.InteractDistance = 2.0


Config.SearchTime = 6500


Config.CooldownSeconds = 600


Config.StashLabel = 'Dumpster Stash'
Config.StashSlots = 20
Config.StashMaxWeight = 25000


Config.Loot = {
  { name = 'plastic',     min = 2, max = 5, chance = 65 },
  { name = 'metalscrap',  min = 1, max = 4, chance = 60 },
  { name = 'glass',       min = 1, max = 3, chance = 55 },
  { name = 'aluminum',    min = 1, max = 3, chance = 30 },
  { name = 'copper',      min = 1, max = 2, chance = 28 },
  { name = 'rubber',      min = 1, max = 2, chance = 25 },
  { name = 'bandage',     min = 1, max = 1, chance = 12 },
  { name = 'lockpick',    min = 1, max = 1, chance = 6 },
}

Config.LootRolls = { min = 4, max = 7 }

Config.EmptyNotify = 'Dumpster is empty, try again later'
Config.BusyNotify  = 'Someone is already searching this dumpster.'
