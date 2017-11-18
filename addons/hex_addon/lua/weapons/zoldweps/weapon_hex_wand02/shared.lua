if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Thornwood Wand"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee"
SWEP.PrintName          = "Thornwood Wand"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/iron/mace/w_iron_mace.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("wc3sound/exp/KeeperOfTheGroveMissileLaunch3.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 2
SWEP.Primary.Cone			= 0.003
SWEP.Primary.Delay          = 1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"
SWEP.Primary.ManaCost = 2

SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = false
SWEP.Secondary.Ammo             = "none"



function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end

    if self.Owner:GetNWInt("Mana") >= self.Primary.ManaCost then
        if SERVER then
            self.Owner:SubtractMana(self.Primary.ManaCost)
        end
        self:EmitSound(self.Primary.Sound,85,math.random(75,95))
        self:ShootProjectile(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
    else
        return
    end
end

function SWEP:SecondaryAbility()

end

function SWEP:ShootProjectile(damage, recoil, num_bullets, aimcone)

    if SERVER then
        for i=1,num_bullets do

            local tr = self.Owner:GetEyeTrace()
            local ent = ents.Create( "ent_hex_wandbolt02" )

            local projrec = recoil * 1500
            ent:SetPos(self.Owner:GetShootPos())
            ent:SetOwner( self.Owner )
            ent:SetAngles(self.Owner:EyeAngles())
            ent:Spawn()

            ent.Weapon = "a "..self.PrintName
         
            local phys = ent:GetPhysicsObject()
            phys:ApplyForceCenter( self.Owner:GetAimVector() * 10000)
            phys:SetVelocity( phys:GetVelocity() + ( self.Owner:GetForward()*Vector(math.random(-projrec,projrec),math.random(-projrec,projrec),math.random(-projrec,projrec)) ) )
            phys:EnableGravity(true)
        end
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleWand002", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))
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
        light.R                 = 215
        light.G                 = 255
        light.B                 = 155
        light.Brightness        = 2
        light.DieTime           = CurTime() + 0.35
    end
    
    function EFFECT:Think()
        return IsValid( self.Weapon ) && self.DieTime >= CurTime()
    end
    
    function EFFECT:Render()

    end
    
    effects.Register( EFFECT, "MuzzleWand002" )
end