-- local fx = 'fire_petrol_two'
-- local fx = 'fire_petrol_two' -- head
-- local fx = 'fire_map_quick'
-- local fx = 'ent_amb_beach_campfire'

-- cool stuff too:
-- fire_petrol_two
-- proj_molotov_flame
-- fire_wrecked_train
-- ent_amb_fire_ring_bike -- this is a ring around wheels :D, 0.25 size
-- ent_amb_fire_ring -- also cool for wheels but way too loud, 0.2 size
-- ent_amb_fire_ring -- again a great one

local function GetNearbyBikes()
  local bikes = {}
  local hash = GetHashKey('dmc12')

  for vehicle in EnumerateVehicles() do
    if GetEntityModel(vehicle) == hash then
      table.insert(bikes, vehicle)
    end
  end

  return bikes
end

local function GetWheelOffsets(vehicle)
  local offsets = {}
  local bones = {
    'wheel_lf',
    'wheel_rf'
  }

  for _, boneName in ipairs(bones) do
    local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)

    if boneIndex ~= -1 then
      local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
      local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos)

      table.insert(offsets, off)
    end
  end

  return offsets
end

local function CreateParticle(vehicle, fxName, offset, scale)
  UseParticleFxAssetNextCall('core')
  return StartParticleFxLoopedOnEntity(fxName, vehicle, offset, 0.0, 0.0, 0.0, scale, false, false, false)
end

local function GetOldBikes(new, old)
  local map = {}
  local ret = {}

  for _, v in ipairs(new) do
    map[v] = true
  end

  for _, v in ipairs(old) do
    if not map[v] then
      table.insert(ret, v)
    end
  end

  return ret
end

Citizen.CreateThread(function ()
  local last = {}
  local ptfxs = {}

  local function CheckBikes()
    local current = GetNearbyBikes()

    for _, bike in ipairs(GetOldBikes(current, last)) do
      if ptfxs[bike] then
        for _, ptfx in ipairs(ptfx[bike]) do
          StopParticleFxLooped(ptfx)
        end

        ptfxs[bike] = nil
      end
    end

    for _, bike in ipairs(current) do
      if not ptfxs[bike] then
        ptfxs[bike] = {}

        for _, offset in ipairs(GetWheelOffsets(bike)) do
          local ringOffset  = offset + vector3(-0.05, -0.05,  0.0 )
          local fireOffset  = offset + vector3( 0.0,  -0.05, -0.3 )
          local trailOffset = offset + vector3( 0.0,   0.0,  -0.25)

          local ring = CreateParticle(bike, 'ent_amb_elec_crackle', ringOffset, 10.0)
          table.insert(ptfxs[bike], ring)

          for i=0, 3 do
            local fire = CreateParticle(bike, 'ent_amb_elec_crackle', fireOffset, 10.0)
            table.insert(ptfxs[bike], fire)
          end

          -- for i=0, 6 do
          --   local trail = CreateParticle(bike, 'ent_amb_beach_campfire', trailOffset, 1.00)
          --   table.insert(ptfxs[bike], trail)
          --   Citizen.Wait(250)
          -- end
        end
      end
    end

    last = current
  end

  while true do
    CheckBikes()
    Citizen.Wait(250)
  end
end)
