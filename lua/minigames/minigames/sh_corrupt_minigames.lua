if SERVER then
  AddCSLuaFile()
end

--TODO: Set credits to default for new role

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Corrupt Cop"
    },
    desc = {
      en = "Who polices the police?"
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_corrupt_epop")
  function MINIGAME:OnActivation()
    local plys = util.GetFilteredPlayers(function(ply)
      return ply:Alive() and ply:IsPlayer() and not ply:IsSpec() and ply:IsDetective()
    end)
    local ply = plys[math.random(#plys)]
    -- print("[Corrupt Cop Minigame] " .. ply:Nick() .. " selected. Role: " .. ply:GetRoleString())
    timer.Simple(7, function()
      if math.random(1,100) < 50 then
        ply:SetRole(ROLE_DEFECTIVE)
      elseif ply:GetSubRole() ~= ROLE_DETECTIVE then
        ply:SetRole(ROLE_DETECTIVE, ply:GetTeam())
      end
      SendFullStateUpdate()
      net.Start("ttt2mg_corrupt_epop")
      net.WriteString(ply:Nick())
      net.Broadcast()
    end)
  end

  function MINIGAME:OnDeactivation()

  end

  function MINIGAME:IsSelectable()
    local plys = util.GetFilteredPlayers(function(ply)
      return ply:Alive() and ply:IsPlayer() and not ply:IsSpec() and ply:IsDetective()
    end)
    return DEFECTIVE and #plys >= 1
  end
end

if CLIENT then
  net.Receive("ttt2mg_corrupt_epop", function()
    EPOP:AddMessage({
        text = LANG.GetParamTranslation("ttt2mg_corrupt_epop", {nick = net.ReadString()}),
        color = COLOR_ORANGE
    })
  end)
end
