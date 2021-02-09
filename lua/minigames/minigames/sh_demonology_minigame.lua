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
      English = "Demonology"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      plys[i]:GiveEquipmentItem("item_demonic_possesion")
    end
  end

  function MINIGAME:OnDeactivation()

  end

  function MINIGAME:IsSelectable()
    if items.GetStored("item_demonic_possesion") then
      return true
    else return false end
  end
end
