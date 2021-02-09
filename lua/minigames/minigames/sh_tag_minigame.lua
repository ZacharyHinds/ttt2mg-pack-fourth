if SERVER then
  AddCSLuaFile()
  -- resource.AddFile("material/vgui/ttt/tid")
end

--TODO Add halo effect for "it" player, add ConVars for It timer, create Icon for It player

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Tag!"
    },
    desc = {
      English = "The explosive variety!"
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_tag_epop")
  util.AddNetworkString("ttt2mg_tag_it_status")

  local function DetonateItPlayer(ply)
    if not ply or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then return end
    if not ply:GetNWBool("ttt2mgTagIsIt", false) then return end
    local effect = EffectData()
    ply:EmitSound(Sound("ambient/explosions/explode_4.wav"))

    util.BlastDamage(ply, game.GetWorld(), ply:GetPos(), 150, 10000)

    effect:SetStart(ply:GetPos() + Vector(0, 0, 10))
    effect:SetOrigin(ply:GetPos() + Vector(0, 0, 10))
    effect:SetScale(1)

    util.Effect("HelicopterMegaBomb", effect)
    net.Start("ttt2mg_tag_epop")
    net.WriteString("ttt2mg_tag_exploded")
    net.WriteString(ply:Nick())
    net.Broadcast()
    ply:SetNWBool("ttt2mgTagIsIt", false)
  end

  local function SelectItPlayer(ply)
    if GetRoundState() ~= ROUND_ACTIVE then return end
    if not ply or not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then
      local plys = util.GetAlivePlayers()
      ply = plys[math.random(#plys)]
    end
    ply:SetNWBool("ttt2mgTagIsIt", true)
    net.Start("ttt2mg_tag_it_status")
    net.WriteInt(30, 32)
    net.Send(ply)
    ply:GiveEquipmentWeapon("weapon_ttt2mg_tagrevolver")
    net.Start("ttt2mg_tag_epop")
    net.WriteString("ttt2mg_tag_is_it")
    net.WriteString(ply:Nick())
    net.Broadcast()
    timer.Create("ttt2mgTagTimer", 30, 1, function()
      if not ply:GetNWBool("ttt2mgTagIsIt", false) then
        net.Start("ttt2mg_tag_epop")
        net.WriteString("ttt2mg_tag_no_explode")
        net.Broadcast()
        timer.Simple(0.05, function()
          SelectItPlayer()
        end)
        return
      end
      DetonateItPlayer(ply)
      timer.Simple(2.5, SelectItPlayer)
    end)
  end

  hook.Add("ScalePlayerDamage", "TagRevolverHitReg", function(ply, hitgroup, dmginfo)
    local attacker = dmginfo:GetAttacker()

    if GetRoundState() ~= ROUND_ACTIVE or not attacker or not IsValid(attacker) or not attacker:IsPlayer() or not IsValid(attacker:GetActiveWeapon()) then return end

    if not ply or not ply:IsPlayer() then return end

    local rev = attacker:GetActiveWeapon()

    if rev:GetClass() ~= "weapon_ttt2mg_tagrevolver" then return end

    attacker:SetNWBool("ttt2mgTagIsIt", false)
    net.Start("ttt2mg_tag_epop")
    net.WriteString("ttt2mg_tag_tagged")
    net.WriteString(ply:Nick())
    net.Send(attacker)
    attacker:StripWeapon("weapon_ttt2mg_tagrevolver")
    net.Start("ttt2mg_tag_it_status")
    net.WriteInt(0, 1)
    net.WriteBool(false)
    net.Send(attacker)
    timer.Remove("ttt2mgTagTimer")
    timer.Simple(2.5, function()
      SelectItPlayer(ply)
    end)

    dmginfo:SetDamage(0)
    return true
  end)

  hook.Add("TTT2PostPlayerDeath", "TagMinigamePostDeath", function(ply, _, attacker)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:GetNWBool("ttt2mgTagIsIt", false) then return end
    ply:SetNWBool("ttt2mgTagIsIt", false)
    timer.Remove("ttt2mgTagTimer")
    timer.Simple(1, SelectItPlayer)
  end)

  function MINIGAME:OnActivation()
    timer.Simple(12.5, SelectItPlayer)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("ttt2mgTagTimer")
    local plys = player.GetAll()
    for i = 1, #plys do
      local ply = plys[i]
      ply:StripWeapon("weapon_ttt2mg_tagrevolver")
      ply:SetNWBool("ttt2mgTagIsIt", false)
    end
  end
end

if CLIENT then



  function MINIGAME:OnActivation()
    hook.Add("PreDrawHalos", "AddItGlow", function()
      local plys = player.GetAll()
      -- local client = LocalPlayer()
      for i = 1, #plys do
        local ply = plys[i]
        if not ply:GetNWBool("ttt2mgTagIsIt", false) or not ply:Alive() or ply:IsSpec() then continue end
        outline.Add(ply, Color(209, 209, 36), OUTLINE_MODE_VISIBLE)
      end
    end)
    hook.Add("TTTRenderEntityInfo", "ttt2mg_tag_targetid", function(tData)
      local ply = tData:GetEntity()

      if not ply:IsPlayer() then return end
      -- 
      -- local client = LocalPlayer()

      if not ply:GetNWBool("ttt2mgTagIsIt", false) then return end

      if tData:GetAmountDescriptionLines() > 0 then
        tData:AddDescriptionLine()
      end

      tData:AddDescriptionLine(
        LANG.TryTranslation("ttt2mg_tag_tid"),
        COLOR_ORANGE
      )

      tData:AddIcon(
        Material("vgui/ttt/tid/tid_destructible"),
        COLOR_ORANGE
      )
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PreDrawHalos", "AddItGlow")
  end

  hook.Add("Initialize", "ttt2mg_tag_init_status", function()
    STATUS:RegisterStatus("ttt2mg_tag_it", {
      hud = Material("vgui/ttt/tid/tid_destructible.vmt"),
      type = "bad"
    })
  end)

  net.Receive("ttt2mg_tag_it_status", function()
    local time = net.ReadInt(32)
    local isIt = net.ReadBool()
    if isIt then
      STATUS:AddTimedStatus("ttt2mg_tag_it", time, true)
    else
      STATUS:RemoveStatus("ttt2mg_tag_it")
    end
  end)

  net.Receive("ttt2mg_tag_epop", function()
    local msg = net.ReadString()
    if msg == "ttt2mg_tag_no_explode" then
      EPOP:AddMessage({
        text = LANG.TryTranslation(msg),
        color = COLOR_ORANGE},
        "",
        2
      )
    else
      local nick = net.ReadString()
      EPOP:AddMessage({
        text = LANG.GetParamTranslation(msg, {nick = nick}),
        color = COLOR_ORANGE},
        "",
        2
      )
    end
  end)
end
