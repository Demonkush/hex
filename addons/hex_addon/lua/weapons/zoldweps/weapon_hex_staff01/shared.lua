if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Lightning Staff"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee2"
SWEP.PrintName          = "Lightning Staff"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/wooden/staff/w_wooden_staff.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/GryphonRiderMissileLaunch1.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.003
SWEP.Primary.Delay          = 1.5
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 4

SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = false
SWEP.Secondary.Ammo             = "none"
SWEP.Secondary.Delay          = 4
SWEP.Secondary.ManaCost = 8

function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end

    if self.Owner:GetNWInt("Mana") >= self.Primary.ManaCost then
        if SERVER then
            self.Owner:SubtractMana(self.Primary.ManaCost)
        end
        self:EmitSound(self.Primary.Sound)
        self:ShootProjectile(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
    else
        return
    end

end

function SWEP:SecondaryAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end

    if self.Owner:GetNWInt("Mana") >= self.Secondary.ManaCost then
        if SERVER then
            self.Owner:SubtractMana(self.Secondary.ManaCost)
        end
        self:EmitSound(self.Primary.Sound)
        self:ShockNova()
    else
        return
    end

end

function SWEP:ShootProjectile(damage, recoil, num_bullets, aimcone)

    if SERVER then
        for i=1,num_bullets do

            local tr = self.Owner:GetEyeTrace()
            local ent = ents.Create( "ent_hex_staffbolt01" )

            local projrec = recoil * 750
            ent:SetPos(self.Owner:GetShootPos())
            ent:SetOwner( self.Owner )
            ent:SetAngles(self.Owner:EyeAngles())
            ent:Spawn()

            ent.Weapon = "a "..self.PrintName

            local phys = ent:GetPhysicsObject()
            phys:ApplyForceCenter( self.Owner:GetAimVector() +  self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 10000)
            phys:SetVelocity( phys:GetVelocity() + (self.Owner:GetAimVector()*Vector(math.random(-projrec,projrec),math.random(-projrec,projrec),math.random(-projrec,projrec))))
            phys:EnableGravity(true)
        end
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleStaff001", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
end

function SWEP:ShockNova()

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    local fx = EffectData()
    fx:SetOrigin( self.Owner:GetPos() )
    util.Effect( "fx_hex_shocknova", fx )
    self:EmitSound( "wc3sound/exp/LightningShieldTarget.wav", 85, math.random(105,115) )


    if SERVER then
        for _, v in ipairs(ents.FindInSphere(self.Owner:GetPos(),155)) do
            self:DoZap(v)
        end
    end

    self:SetNextPrimaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
    self:SetNextSecondaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
end

function SWEP:DoZap(vic)
    if vic:IsPlayer() then
        local vel = ( ( vic:GetPos() - self.Owner:GetPos() ) * 3 )
        vel = Vector(math.Clamp(vel.x,-700,700),math.Clamp(vel.y,-700,700),math.Clamp(vel.z,-700,700))

        if vic != self.Owner then

            local dmginfo = DamageInfo()
            dmginfo:SetAttacker( self.Owner )
            dmginfo:SetInflictor( self )
            dmginfo:SetDamage( math.random(8,13) )
            vic:TakeDamageInfo( dmginfo )

            vic:SetVelocity(vel+Vector(0,0,400))

            local cts = math.random(1,10)   
            if cts >= 5 then
                if vic:IsPlayer() then
                    vic:BuffStun(self.Owner,math.random(1,2))
                end
            end

        end
    else
        vic:TakeDamage(25)
    end
end

-- Effect taken from the Nomad laser smg weapon. Workshop id: 104516493
if( CLIENT ) then
    local GlowMaterial = CreateMaterial( "hex/glow", "UnlitGeneric", {
        [ "$basetexture" ]      = "sprites/light_glow01",
        [ "$additive" ]         = "1",
        [ "$vertexcolor" ]      = "1",
        [ "$vertexalpha" ]      = "1",
    } )
    
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
        light.R                 = 155
        light.G                 = 215
        light.B                 = 255
        light.Brightness        = 2
        light.DieTime           = CurTime() + 0.35
    end
    
    function EFFECT:Think()
        return IsValid( self.Weapon ) && self.DieTime >= CurTime()
    end
    
    function EFFECT:Render()

    end
    
    effects.Register( EFFECT, "MuzzleStaff001" )
end