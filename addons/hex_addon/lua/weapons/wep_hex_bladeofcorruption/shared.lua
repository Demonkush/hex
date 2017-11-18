if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Blade of Corruption"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee"
SWEP.PrintName          = "Blade of Corruption"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/glass/longsword/w_glass_longsword.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/DeathCoilMissileLaunch1.wav")
SWEP.Primary.Delay          = 0.9
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 4

SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

-- Blade of Corruption -- Elements: Poison / Shadow --
-- Primary Low: Slash ( Regular slashes )
-- Primary Norm: Viper Sting ( Poison side slash )
-- Primary High: Acid Slash ( Poison / Shadow X Slash )
-- Hidden Power: Slash of Torment ( Poison / Shadow / Storm X Slash, ground slash, chance to cast homing Shadow Bolt )

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Magesoul") == 1 then
        self:MagesoulAbility()
        self:EmitSound("wc3sound/exp/CorrosiveBreathMissileLaunch1.wav",85,math.random(100,110))
        if self.Owner:GetNWInt("Overpowered") == 0 then
            if SERVER then
                self.Owner:SubtractMana(self.Primary.ManaCost)
            end
        end
        return
    end

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/exp/ChimaeraAlternateMissileLaunch1.wav",85,math.random(100,110))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/exp/ChimaeraAlternateMissileLaunch1.wav",85,math.random(100,110))
            self:DoPrimaryAttack("high")
        else
            self:EmitSound(self.Primary.Sound,85,math.random(85,115))
            self:DoPrimaryAttack("normal")
        end
    else
        self:EmitSound(self.Primary.Sound,55,math.random(145,155))
        self:DoPrimaryAttack("low")
    end
end

function SWEP:MagesoulAbility()
    local projent = "ent_hex_slashtorment"
    local gravity = true

    if SERVER then
        -- Slash attacks
        local slash = ents.Create(projent)
        slash:SetPos(self:GetOwner():GetPos()+self:GetOwner():GetAimVector()*50+Vector(0,0,64))
        slash:SetAngles(self:GetAngles())
        slash:SetOwner(self:GetOwner())
        slash:Spawn()

        slash:SetPower("high")
    end
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin(self.Owner:GetShootPos())
        effect:SetEntity(self.Weapon)
        effect:SetAttachment(1)
    util.Effect("MuzzleSword001",effect)

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end

function SWEP:DoPrimaryAttack(output)
    local projent = "ent_hex_slashpoison"
    local gravity = true

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if HEX.MOD.WeaponPowerLock == true then
        output = HEX.MOD.WeaponPowerLockMode
    end

    if output == "high" then
        gravity = false
    end
    if SERVER then
        -- Slash attacks
        local slash = ents.Create(projent)
        slash:SetPos(self:GetOwner():GetPos()+self:GetOwner():GetAimVector()*50+Vector(0,0,64))
        slash:SetAngles(self:GetAngles())
        slash:SetOwner(self:GetOwner())
        slash:Spawn()

        slash:SetPower(output)
    end
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    
    if output != "low" then
        local effect = EffectData()
            effect:SetOrigin(self.Owner:GetShootPos())
            effect:SetEntity(self.Weapon)
            effect:SetAttachment(1)
        util.Effect("MuzzleSword001",effect)
    end

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end

if CLIENT then
    local EFFECT = {}
    function EFFECT:Init(data)
        self.Weapon = data:GetEntity()
        self.Entity:SetRenderBounds(Vector(-16,-16,-16),Vector(16,16,16))
        self.Entity:SetParent(self.Weapon)
        self.DieTime = CurTime()+math.Rand(0.25,0.35)
        
        local pos,ang = GetMuzzlePosition(self.Weapon)
        local light = DynamicLight(self.Weapon:EntIndex())
        light.Pos               = pos
        light.Size              = 256
        light.Decay             = 400
        light.R                 = 155
        light.G                 = 255
        light.B                 = 125
        light.Brightness        = 2
        light.DieTime           = CurTime()+0.35
    end
    function EFFECT:Think()
        return IsValid(self.Weapon) && self.DieTime >= CurTime()
    end
    function EFFECT:Render() end
    effects.Register(EFFECT,"MuzzleSword001")
end