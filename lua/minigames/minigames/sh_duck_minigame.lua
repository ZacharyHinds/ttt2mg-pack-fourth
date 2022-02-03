if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "DUCK!"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("StartCommand", "DuckMinigameCommand", function(ply, ucmd)
      if ucmd:KeyDown(IN_DUCK) then
        ply.duckMinigame_isDucked = true
      else
        ply.duckMinigame_isDucked = false
      end
    end)

    local delay = CurTime() + 0.5
    hook.Add("Think", "DuckMinigameThink", function()
      if GetRoundState() ~= ROUND_ACTIVE then self:OnDeactivation() return end
      if delay > CurTime() then return end
      local dmginfo = DamageInfo()
      dmginfo:SetAttacker(game.GetWorld())
      dmginfo:SetDamage(1)
      local plys = util.GetAlivePlayers()
      for i = 1, #plys do
        local ply = plys[i]
        if not ply.duckMinigame_isDucked then
          ply:TakeDamageInfo(dmginfo)
        end
      end
      delay = CurTime() + 0.5
    end)

  end

  function MINIGAME:OnDeactivation()
    hook.Remove("StartCommand", "DuckMinigameCommand")
    hook.Remove("Think", "DuckMinigameThink")

end
