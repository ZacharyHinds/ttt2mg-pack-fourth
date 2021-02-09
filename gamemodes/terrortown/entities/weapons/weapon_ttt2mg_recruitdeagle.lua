SWEP.Base = "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.AdminSpawnable = true

SWEP.HoldType = "pistol"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

if SERVER then
  AddCSLuaFile()
elseif CLIENT then
  SWEP.PrintName = "Recruiter Deagle"
  SWEP.Author = "Wasted"

  SWEP.Slot = 8

  SWEP.ViewModelFOV = 54
  SWEP.ViewModelFlip = false

  SWEP.Category = "Deagle"
  SWEP.Icon = "vgui/ttt/icon_recruitdeagle"
  SWEP.EquipMenuData = {
    type = "item_weapon",
    desc = "ttt2mg_recruitdeagle_desc"
  }
end

SWEP.AllowDrop = false
SWEP.notBuyable = true

SWEP.Primary.Delay = 1
SWEP.Primary.Recoil = 6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.00001
SWEP.Primary.Ammo = ''
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1

SWEP.InLoadoutFor = nil
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.UseHands = true
SWEP.Kind = WEAPON_EXTRA
SWEP.CanBuy = {}
SWEP.LimitedStock = true
SWEP.globalLimited = true
SWEP.NoRandom = true

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_Deagle.Single")

SWEP.IronSightsPos = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:OnDrop()
  self:Remove()
end

local function RecruitDeagleCallback(attacker, tr, dmg)
  if CLIENT then return end

  local target = tr.Entity

  if not GetRoundState() == ROUND_ACTIVE or not IsValid(attacker) or not attacker:IsPlayer() or not attacker:IsTerror() then return end

  local deagle = attacker:GetWeapon("weapon_ttt2mg_recruitdeagle")
  if IsValid(deagle) then deagle:Remove() end

  if not IsValid(target) or not target:IsPlayer() or not target:IsTerror() then return end

  target:SetRole(attacker:GetSubRole(), attacker:GetTeam())
  SendFullStateUpdate()
end

function SWEP:ShootBullet(dmg, recoil, numbul, cone)
  cone = cone or 0.01
  local bullet = {}
  bullet.Num = 1
  bullet.Src = self:GetOwner():GetShootPos()
  bullet.Dir = self:GetOwner():GetAimVector()
  bullet.Spread = Vector(cone, cone, 0)
  bullet.Tracer = 0
  bullet.TracerName = self.Tracer or "Tracer"
  bullet.Force = 10
  bullet.Damage = 0
  bullet.Callback = RecruitDeagleCallback

  self:GetOwner():FireBullets(bullet)
  self.BaseClass.ShootBullet(self, dmg, recoil, numbul, cone)
end
