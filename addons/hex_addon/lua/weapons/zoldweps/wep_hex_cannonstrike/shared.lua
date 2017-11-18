if (SERVER) then
    AddCSLuaFile("shared.lua")
end

if (CLIENT) then
    SWEP.PrintName      = "Cannonstrike"
    SWEP.Slot           = 1
    SWEP.SlotPos        = 1
    SWEP.ViewModelFlip  = false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "ar2"
SWEP.PrintName          = "Cannonstrike"
SWEP.Spawnable          = true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_rif_outland_multibarrel.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/NecromancerMissileHit3.wav")
SWEP.Primary.Delay          = 1
SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ManaCost = 4

SWEP.Secondary.Sound          = Sound("wc3sound/exp/GryphonRiderMissileLaunch1.wav")
SWEP.Secondary.Delay          = 0.4
SWEP.Secondary.ClipSize       = 1
SWEP.Secondary.DefaultClip    = 1
SWEP.Secondary.Automatic      = true
SWEP.Secondary.Ammo           = "none"
SWEP.Secondary.ManaCost = 7

-- Cannonstrike -- Elements: Physical --
-- Primary Low: Single Shot
-- Primary Norm: Auto Shot
-- Primary High: Multi-Auto Shot
-- Secondary Norm: Bombardment
-- Secondary High: Carpet Bombardment

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound("wc3sound/NecromancerMissileHit3.wav",85,math.random(75,85))
        self:DoPrimaryAttack("high")
        return
    end

    if SERVER then
        self.Owner:SubtractMana(self.Primary.ManaCost)
    end

    if mana >= HEX.MOD.LowManaAttackAmount then
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:EmitSound("wc3sound/NecromancerMissileHit3.wav",85,math.random(75,85))
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

function SWEP:SecondaryAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local mana = self.Owner:GetNWInt("Mana")
    local maxmana = self.Owner:GetNWInt("MaxMana")

    if self.Owner:GetNWInt("Overpowered") == 1 then
        self:EmitSound(self.Secondary.Sound,76,math.random(135,145))
        self:DoSecondaryAttack("high")
        return
    end

    if mana >= self.Secondary.ManaCost then
        if SERVER then
            self.Owner:SubtractMana(self.Secondary.ManaCost)
        end
        self:EmitSound(self.Secondary.Sound,76,math.random(135,145))
        if ( mana == maxmana && HEX.MOD.FullManaOvercharge == true ) then
            self:DoSecondaryAttack("high")
        else
            self:DoSecondaryAttack("normal")
        end
    else
        -- Do nothing
    end
end

function SWEP:DoPrimaryAttack(output)
    local projent = "ent_hex_proj_gunbomb"
    local gravity = true

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if SERVER then
        local function ShootEnt()
            local tr, projrec = self.Owner:GetEyeTrace(), 100
            local ent = ents.Create( projent )
            ent:SetPos(self.Owner:GetShootPos()+(self.Owner:GetForward()*55))
            ent:SetOwner( self.Owner )
            ent:SetAngles(self.Owner:EyeAngles())
            ent:Spawn()

            ent.Weapon = "a "..self.PrintName

            ent:SetPower("normal")

            local phys = ent:GetPhysicsObject()
            phys:ApplyForceCenter(self.Owner:GetAimVector() + self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 20000)
            phys:SetVelocity(phys:GetVelocity() + self.Owner:GetAimVector()+(VectorRand()*projrec))
            phys:EnableGravity(gravity)
        end
        if output == "high" then
            for i=1,5 do
                ShootEnt()
            end
        else
            ShootEnt()
        end
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end

function SWEP:DoSecondaryAttack(output) -- todo -------------------------------------------
    local projent = "ent_hex_proj_gunbomb"
    local gravity = true
    local lesstime = 0.1

    if HEX.MOD.FullManaOvercharge == false then
        if output == "high" then output = "normal" end
    end

    if self.Owner:GetNWString("Overpowered") == true then
        output = "high"
    end

    if output == "high" then
        lesstime = 0.2
    end

    if SERVER then
        local tr, projrec = self.Owner:GetEyeTrace(), 255
        local ent = ents.Create( projent )
        ent:SetPos(self.Owner:GetShootPos()+(self.Owner:GetForward()*55))
        ent:SetOwner( self.Owner )
        ent:SetAngles(self.Owner:EyeAngles())
        ent:Spawn()

        ent.Weapon = "a "..self.PrintName

        ent:SetPower("normal")

        local phys = ent:GetPhysicsObject()
        phys:ApplyForceCenter(self.Owner:GetAimVector() + self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 20000)
        phys:SetVelocity(phys:GetVelocity() + self.Owner:GetAimVector()+(VectorRand()*projrec))
        phys:EnableGravity(gravity)
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleGun001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod-lesstime))
end

if( CLIENT ) then
-- Effect taken from the Nomad laser smg weapon. Workshop id: 104516493
    local EFFECT = {}
    function EFFECT:Init( data )
        self.Weapon = data:GetEntity()
        self.Entity:SetRenderBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
        self.Entity:SetParent( self.Weapon )
        self.LifeTime = math.Rand( 0.25, 0.35 )
        self.DieTime = CurTime() + self.LifeTime
        self.Size = math.Rand( 25, 45 )
        
        local pos, ang = GetMuzzlePosition( self.Weapon )
        local light = DynamicLight( self.Weapon:EntIndex() )
        light.Pos               = pos
        light.Size              = 256
        light.Decay             = 400
        light.R                 = 255
        light.G                 = 155
        light.B                 = 55
        light.Brightness        = 2
        light.DieTime           = CurTime() + 0.35
    end
    function EFFECT:Think()
        return IsValid( self.Weapon ) && self.DieTime >= CurTime()
    end
    function EFFECT:Render()
    end
    effects.Register( EFFECT, "MuzzleGun001" )
end