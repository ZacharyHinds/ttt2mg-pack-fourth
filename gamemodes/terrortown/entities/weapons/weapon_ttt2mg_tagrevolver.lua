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
  SWEP.PrintName = "Tag Revolver"
  SWEP.Author = "Wasted"

  SWEP.Slot = 8

  SWEP.ViewModelFOV = 54
  SWEP.ViewModelFlip = false

  SWEP.Category = "Revolver"
  SWEP.Icon = "vgui/ttt/icon_tagrevolver"
  SWEP.EquipMenuData = {
    type = "item_weapon",
    desc = "ttt2mg_tagrevolver_desc"
  }
end

SWEP.AllowDrop = false
SWEP.notBuyable = true

SWEP.Primary.Delay = 4.5
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.00001
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.DefaultClip = -1

SWEP.InLoadoutFor = nil
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.UseHands = true
SWEP.Kind = WEAPON_EXTRA
SWEP.CanBuy = {}
SWEP.LimitedStock = true
SWEP.globalLimited = true
SWEP.NoRandom = true

SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.WorldModel = Model("models/weapons/w_357.mdl")
SWEP.Weight = 5
SWEP.Primary.Sound = Sound("Weapon_357.Single")

SWEP.IronSightsPos = Vector (-4.64, -3.96, 0.68)
SWEP.IronSightsAng = Vector (0.214, -0.1767, 0)

function SWEP:OnDrop()
  if SERVER then
    self:GetOwner():SetNWBool("ttt2mgTagIsIt", false)
  end
  self:Remove()
end

function SWEP:PrimaryAttack()
  owner = self:GetOwner()
  self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
  self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
  sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
  self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())

  timer.Create("MinigameTagRevolverReload", 0.5, 1, function()
    if owner:GetActiveWeapon().ClassName == "weapon_ttt2mg_tagrevolver" then
      self:GetOwner():SetPlaybackRate(0.5)
    else return
    end
    if self.SendWeaponAnim then self:SendWeaponAnim(self.ReloadAnim) end
    if self.SetIronSights then self:SetIronSights(false) end
  end)
end
