if SERVER then
  AddCSLuaFile()
end

--Concept: Players receive a random "super power"
--Powers:
---Explosion - Explosion Immunity, but can detonate themselves a la coffin dance bomb for heavy damage to self and AoE
---Jump - High Jump, fall damage immunity
---Super Speed - Fast Movement Speed
---Regeneration - Slowly heal over time
---Flaming - Fire immunity, damage aura around
---Shapeshifter - Prop disguise
---Invisibility - Always invisible
---

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_tilted_angle = {
    slider = true,
    min = 0,
    max = 180,
    desc = "ttt2mg_tilted_angle (Def. 60)"
  },

  ttt2mg_tilted_min_delay = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2mg_tilted_min_delay (Def. 1)"
  },

  ttt2mg_tilted_max_delay = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2mg_tilted_max_delay (Def. 10)"
  },

  ttt2mg_tilted_speed = {
    slider = true,
    min = 0,
    max = 2,
    decimal = 2,
    desc = "ttt2mg_tilted_speed (Def. 0.10)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Tilted"
    },
    desc = {
      en = ""
    }
  }
end

local ttt2mg_tilted_speed = CreateConVar("ttt2mg_tilted_speed", "0.01", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Speed of rotations")
if SERVER then
  util.AddNetworkString("ttt2mg_tilted")
  local ttt2mg_tilted_angle = CreateConVar("ttt2mg_tilted_angle", "60", {FCVAR_ARCHIVE}, "Max angle titlted can reach")
  function MINIGAME:OnActivation()
    local delay = 5 + CurTime()
    local angle = math.random(ttt2mg_tilted_angle:GetInt()) * (-1 ^ math.random(1,2))
    hook.Add("Think", "TiltedMinigameThink", function()
      if GetRoundState() ~= ROUND_ACTIVE then
        hook.Remove("Think", "TiltedMinigameThink")
        return
      end
      local plys = util.GetAlivePlayers()
      if delay < CurTime() then
        net.Start("ttt2mg_tilted")
        net.WriteBool(true)
        net.WriteInt(angle, 32)
        net.Send(plys)
        delay = CurTime() + 5
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "TiltedMinigameThink")
    net.Start("ttt2mg_tilted")
    net.WriteBool(false)
    net.Broadcast()
  end

  -- function MINIGAME:IsSelectable()
  --   -- return false
  -- end
end

if CLIENT then
  function MINIGAME:OnActivation()
    local roll = 0
    hook.Add("CreateMove", "TiltedMinigameThink", function(cmd)
      local ply = LocalPlayer()
      if not ply.tiltMinigame_enable then return end
      if not ply:Alive() or not ply:IsPlayer() then return end
      local speed = ttt2mg_tilted_speed:GetFloat()
      if roll < ply.tiltedMinigame_roll + speed and roll > ply.tiltedMinigame_roll - speed then
        roll = ply.tiltedMinigame_roll
      elseif ply.tiltedMinigame_roll > roll then
        roll = roll + speed
      elseif ply.tiltedMinigame_roll < roll then
        roll = roll - speed
      else
        roll = ply.tiltedMinigame_roll
      -- elseif ply.tiltedMinigame_roll == roll then
      --   -- roll = 0
      end

      -- local mouseY = cmd:GetMouseY() * -1
      -- local mouseX = cmd:GetMouseX() * -1
      local view = cmd:GetViewAngles()

      local tilted = Angle(view.p, view.y, roll)
      tilted.p = math.Clamp(tilted.p, -89, 89)

      cmd:SetViewAngles(tilted)
      -- ply:SetEyeAngles(invert)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("CreateMove", "TiltedMinigameThink")
  end

  net.Receive("ttt2mg_tilted", function()
    if net.ReadBool() then
      LocalPlayer().tiltMinigame_enable = true
      LocalPlayer().tiltedMinigame_roll = net.ReadInt(32)
    else
      LocalPlayer().tiltMinigame_enable = nil
      LocalPlayer().tiltedMinigame_roll = 0
    end
  end)
end
