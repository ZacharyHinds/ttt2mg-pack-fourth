if SERVER then
  AddCSLuaFile()
end

--Conecpt: All players receive the Demonic Possesion item

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Demonology"
    },
    desc = {
      en = "No exorcists allowed!"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]
      ply:GiveEquipmentItem("item_demonic_possession")
      ply.DemonicPossession = true
    end
  end

  function MINIGAME:OnDeactivation()

  end

  function MINIGAME:IsSelectable()
    if items.GetStored("item_demonic_possession") then
      return true
    else return false end
  end
end
