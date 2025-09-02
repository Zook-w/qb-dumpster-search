local QBCore = exports['qb-core']:GetCoreObject()
local searching = false
local targetAdded = false

local function GetDumpsterId(entity)
  local c = GetEntityCoords(entity)
  return string.format('dumpster-%d_%d_%d', math.floor(c.x), math.floor(c.y), math.floor(c.z))
end

local function StartSearch(entity)
  if searching then return end
  searching = true

  local ped = PlayerPedId()
  TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)

  QBCore.Functions.Progressbar('dumpster_search', 'Searching dumpster', Config.SearchTime, false, true, {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
    },
    {}, {}, {},
    function() -- done
      ClearPedTasks(ped)
      local stashId = GetDumpsterId(entity)
      TriggerServerEvent('qb-dumpster-search:server:OpenDumpster', stashId)
      searching = false
    end,
    function() -- cancel
      ClearPedTasks(ped)
      searching = false
    end
  )
end

-- qb-target
CreateThread(function()
  if not Config.UseQBTarget then return end
  if targetAdded then return end
  targetAdded = true

  local opts = {
    options = {
      {
        icon = 'fas fa-dumpster',
        label = 'Search dumpster',
        action = function(entity) StartSearch(entity) end,
        canInteract = function(entity)
          if not DoesEntityExist(entity) then return false end
          local model = GetEntityModel(entity)
          for _, m in ipairs(Config.DumpsterModels) do
            if model == m then return true end
          end
          return false
        end
      }
    },
    distance = Config.TargetDistance
  }

  for _, model in ipairs(Config.DumpsterModels) do
    exports['qb-target']:AddTargetModel(model, opts)
  end
end)

CreateThread(function()
  if Config.UseQBTarget then return end

  while true do
    local sleep = 800
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    -- Raycast μπροστά
    local forward = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.5, 0.0)
    local ray = StartShapeTestCapsule(coords.x, coords.y, coords.z, forward.x, forward.y, forward.z, 0.75, 16, ped, 7)
    local _, _, _, _, entity = GetShapeTestResult(ray)

    if entity and DoesEntityExist(entity) then
      local dist = #(coords - GetEntityCoords(entity))
      if dist <= Config.InteractDistance then
        local model = GetEntityModel(entity)
        local ok = false
        for _, m in ipairs(Config.DumpsterModels) do
          if model == m then ok = true break end
        end
        if ok then
          sleep = 0
          QBCore.Functions.DrawText3D(coords.x, coords.y, coords.z + 0.95, '~g~[E]~w~ Search dumpster')
          if IsControlJustPressed(0, 38) then -- E
            StartSearch(entity)
          end
        end
      end
    end

    Wait(sleep)
  end
end)
