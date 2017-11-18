if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Magic Wand"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee"
SWEP.PrintName          = "Magic Wand"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/iron/mace/w_iron_mace.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/DefendCaster.wav")
SWEP.Primary.Delay          = 0.7
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 3

SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

-- Magic Wand -- Elements: Magic --
-- Primary Low: Magic Bolt
-- Primary Norm: Magic Missile
-- Primary High: Magic Missiles, Faster and stronger bolt with a straight shot, 3 at once.
-- Hidden Power: Super Mana Bomb, splits into 4 homing projectiles. Fire, Ice, Storm, Arcane

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Magesoul") == 1 then
        self:MagesoulAbility()
        self:EmitSound("wc3sound/exp/DefendCaster.wav",85,math.random(73,75))
        if self.Owner:GetNWInt("Overpowered") == 0 then
            if SERVER then
                self.Owner:SubtractMana(self.Primary.ManaCost)
            end
        end
        return
    end

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound(self.Primary.Sound,85,math.random(80,90))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound(self.Primary.Sound,85,math.random(80,90))
            self:DoPrimaryAttack("high")
        else
            self:EmitSound(self.Primary.Sound,40,math.random(110,120))
            self:DoPrimaryAttack("normal")
        end
    else
        self:EmitSound(self.Primary.Sound,40,math.random(140,150))
        self:DoPrimaryAttack("low")
    end
end

function SWEP:MagesoulAbility()
    local projent = "ent_hex_projectile_supermagicbomb"
    local aktspeeddelay = 0.5

    if SERVER then
        local tr,projrec = self.Owner:GetEyeTrace(),1
        local ent = ents.Create(projent)
        ent:SetPos(self.Owner:GetShootPos()+(self.Owner:EyeAngles():Right()*25))
        ent:SetOwner(self.Owner)
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()

        ent.Weapon = "a "..self.PrintName

        ent:SetPower("high")

        ent:SetColor(Color(math.random(105,255),math.random(105,255),math.random(105,255)))

        local phys = ent:GetPhysicsObject()
        phys:ApplyForceCenter(self.Owner:GetAimVector()+self.Owner:GetForward(Vector(math.random(-25,25),math.random(-25,25),0))*10000)
        phys:SetVelocity(phys:GetVelocity()+self.Owner:GetAimVector()+(VectorRand()*projrec*25))
        phys:EnableGravity(true)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin(self.Owner:GetShootPos())
        effect:SetEntity(self.Weapon)
        effect:SetAttachment(1)
    util.Effect("MuzzleWand001",effect)

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod+aktspeeddelay))
end

function SWEP:DoPrimaryAttack(output)
    local projent = "ent_hex_projectile_magicbolt"
    local gravity = false
    local velocity = 25000

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if HEX.MOD.WeaponPowerLock == true then
        output = HEX.MOD.WeaponPowerLockMode
    end

    if output == "low" then
        projent = "ent_hex_projectile_smallmagicbolt"
        velocity = 20000
    end

    local num = 1
    if output == "high" then num = 2 end

    for i=1,num do
        if SERVER then
            local tr,projrec = self.Owner:GetEyeTrace(),num
            local ent = ents.Create(projent)
            ent:SetPos(self.Owner:GetShootPos()+(self.Owner:EyeAngles():Right()*25))
            ent:SetOwner(self.Owner)
            ent:SetAngles(self.Owner:EyeAngles())
            ent:Spawn()

            ent.Weapon = "a "..self.PrintName

            ent:SetPower(output)

            ent:SetColor(Color(math.random(105,255),math.random(105,255),math.random(105,255)))

            local phys = ent:GetPhysicsObject()
            phys:ApplyForceCenter(self.Owner:GetAimVector()+self.Owner:GetForward(Vector(math.random(-255,255),math.random(-255,255),0))*velocity)
            phys:SetVelocity(phys:GetVelocity()+self.Owner:GetAimVector()+(VectorRand()*projrec*75))
            phys:EnableGravity(gravity)
        end
    end
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin(self.Owner:GetShootPos())
        effect:SetEntity(self.Weapon)
        effect:SetAttachment(1)
    util.Effect("MuzzleWand001",effect)

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end