if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Recruitment Drive"
    },
    desc = {
      en = "It's not a pyramid scheme!"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      plys[i]:GiveEquipmentWeapon("weapon_ttt2mg_recruitdeagle")
    end
  end

  function MINIGAME:OnDeactivation()
    local plys = player.GetAll()
    for i = 1, #plys do
      plys[i]:StripWeapon("weapon_ttt2mg_recruitdeagle")
    end
  end
end
