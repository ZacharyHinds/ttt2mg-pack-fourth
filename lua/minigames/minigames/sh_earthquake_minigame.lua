if SERVER then
  AddCSLuaFile()
end

-- TODO Occasionlly shake/move players' cameras

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Earthquake Alert!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then

  local function RandomViewPunch(ply)
    if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
    ply:ViewPunch(Angle(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5)))
  end

  function MINIGAME:OnActivation()
    local quake_delay = CurTime() + math.random(12, 17)
    local plys = player.GetAll()
    hook.Add("Think", "EarthquakeMinigameThink", function()
      if quake_delay > CurTime() then return end
      for i = 1, #plys do
        local ply = plys[i]
        if not ply:Alive() or ply:IsSpec() then return end
        RandomViewPunch(ply)
      end
      timer.Simple(math.random(2, 5), function() quake_delay = CurTime() + math.random(5, 20) end)
    end)
  end

  function MINIGAME:OnDeactivation()

  end

  function MINIGAME:IsSelectable()
    return false
  end
end
