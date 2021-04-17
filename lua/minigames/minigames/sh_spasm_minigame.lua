if SERVER then
  AddCSLuaFile()
end

--Concept: Players receive occasional random inputs

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_spasm_max = {
    slider = true,
    min = 1,
    max = 10,
    decimal = 1,
    desc = "ttt2mg_spasm_max (Def. 2)"
  },

  ttt2mg_spasm_min = {
    slider = true,
    min = 0,
    max = 5,
    decimal = 1,
    desc = "ttt2mg_spasm_min (Def. 0)"
  },
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Muscle Spasms"
    },
    desc = {
      en = ""
    }
  }
end

if SERVER then
  local ttt2mg_spasm_max = CreateConVar("ttt2mg_spasm_max", "2", {FCVAR_ARCHIVE}, "Max length of spasm")
  local ttt2mg_spasm_min = CreateConVar("ttt2mg_spasm_min", "0", {FCVAR_ARCHIVE}, "Min length of spasm")
  local ttt2mg_spasm_delay_max = CreateConVar("ttt2mg_spasm_delay_max", "60", {FCVAR_ARCHIVE}, "Max delay between spasms")
  local ttt2mg_spasm_delay_min = CreateConVar("ttt2mg_spasm_delay_min", "5", {FCVAR_ARCHIVE}, "Min delay between spasms")
  local ttt2mg_spasm_all = CreateConVar("ttt2mg_spasm_all", "1", {FCVAR_ARCHIVE}, "Should all players spasm at once")
  local function SpasmPlayer(ply, ucmd)
    if not IsValid(ply) or not ply:Alive() then return end
    if ply:GetNWInt("SpasmMinigameTime") < CurTime() then return end

    if math.random(0,100) > 25 then
      ucmd:SetForwardMove(math.random(-25,100))
    end
    if math.random(0,100) > 50 then
      ucmd:SetSideMove(math.random(-100,100))
    end
    if math.random(0,100) > 50 then
      ucmd:SetUpMove(math.random(-50,50))
    end
    if (math.random(0,100) > 99) and not ucmd:KeyDown(IN_DUCK) then
      ucmd:SetButtons(ucmd:GetButtons() + IN_DUCK)
      -- ucmd:AddKey(IN_DUCK)
    end
    if (math.random(0,100) > 90) and not ucmd:KeyDown(IN_JUMP) then
      ucmd:SetButtons(ucmd:GetButtons() + IN_JUMP)
      -- ucmd:AddKey(IN_JUMP)
    end
    if (math.random(0,100) > 50) and not ucmd:KeyDown(IN_USE) then
      ucmd:SetButtons(ucmd:GetButtons() + IN_USE)
      -- ucmd:AddKey(IN_USE)
    end
    if math.random(1, 100) > 75 and not ucmd:KeyDown(IN_RUN) then
      ucmd:SetButtons(ucmd:GetButtons() + IN_RUN)
      -- ucmd:AddKey(IN_RUN)
    end
    if (math.random(1,100) > 50) and not ucmd:KeyDown(IN_RELOAD) then
      ucmd:SetButtons(ucmd:GetButtons() + IN_USE)
      -- ucmd:AddKey(IN_RELOAD)
    end
    if math.random(1,100) > 99 and ucmd:KeyDown(IN_ATTACK)  then
      -- ucmd:AddKey(IN_ATTACK)
      ucmd:SetButtons(ucmd:GetButtons() - IN_ATTACK)
    end
    if math.random(1, 100) > 50 and ucmd:KeyDown(IN_ATTACK2) then
      -- ucmd:AddKey(IN_ATTACK2)
      ucmd:SetButtons(ucmd:GetButtons() - IN_ATTACK2)
    end
    if math.random(1,100) > 0 then
      -- local view = ucmd:GetViewAngles()
      local add_angle = AngleRand()
      add_angle.p = math.Clamp(add_angle.p, -89, 89)
      -- view.x = view.x + add_angle.x
      -- view.y = view.y + add_angle.y
      -- view.z = view.z + add_angle.z
      ucmd:SetViewAngles(add_angle)
    end
  end

  function MINIGAME:OnActivation()
    hook.Add("StartCommand", "SpasmMinigameControl", SpasmPlayer)
    local delay = math.random(ttt2mg_spasm_delay_min:GetInt(), ttt2mg_spasm_delay_max:GetInt()) + CurTime()
    hook.Add("Think", "SpasmMinigameThink", function()
      if delay > CurTime() then return end
      local plys = util.GetAlivePlayers()
      if ttt2mg_spasm_all:GetBool() then
        for i = 1, #plys do
          local ply = plys[i]
          ply:SetNWInt("SpasmMinigameTime", math.Rand(ttt2mg_spasm_min:GetFloat(), ttt2mg_spasm_max:GetFloat()) + CurTime())
        end
      else
        plys[math.random(#plys)]:SetNWInt("SpasmMinigameTime", math.Rand(ttt2mg_spasm_min:GetFloat(), ttt2mg_spasm_max:GetFloat()) + CurTime())
      end
      delay = math.random(ttt2mg_spasm_delay_min:GetInt(), ttt2mg_spasm_delay_max:GetInt())
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("StartCommand", "SpasmMinigameControl")
    timer.Remove("SpasmMinigameTimer")
    local plys = player.GetAll()
    for i = 1, #plys do
      ply:SetNWInt("SpasmMinigameTime", 0)
    end
  end

  -- function MINIGAME:IsSelectable()
  --   return false
  -- end
end
