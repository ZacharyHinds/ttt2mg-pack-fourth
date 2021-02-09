if SERVER then
  AddCSLuaFile()
end

--Concept: The floor damages players (maybe spawn props to stand on?)

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "The Floor is Lava!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local lava_delay = CurTime() + 5
    hook.Add("Think", "LavaMinigameThink", function()
      if lava_delay > CurTime() then return end
      if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("Think", "LavaMinigameThink") return end
      local plys = util.GetAlivePlayers()
      -- local dmg = DamageInfo()
      -- dmg:SetDamage(1)
      -- dmg:SetAttacker(game.GetWorld())
      -- dmg:SetInflictor(game.GetWorld())
      -- dmg:SetDamageType(DMG_BURN)
      for i = 1, #plys do
        local ply = plys[i]
        if ply:IsOnGround() then
          ply:Ignite(5)
          -- ply:TakeDamageInfo(dmg)
        else
          ply:Extinguish()
        end
      end
      lava_delay = CurTime() + 0.5
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "LavaMinigameThink")
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
