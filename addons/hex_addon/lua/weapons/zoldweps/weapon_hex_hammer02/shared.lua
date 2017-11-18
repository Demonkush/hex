if (SERVER) then
    AddCSLuaFile("shared.lua")
end

if (CLIENT) then
    SWEP.PrintName      = "Magmar Hammer"
    SWEP.Slot           = 1
    SWEP.SlotPos        = 1
    SWEP.ViewModelFlip  = false
end

SWEP.Category = "Hex"

SWEP.Base = "hex_sckbase"

SWEP.HoldType           = "melee"
SWEP.PrintName          = "Magmar Hammer"
SWEP.Spawnable          = true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/morrowind/nordic/hammer/w_nordic_hammer.mdl"
SWEP.ShowWorldModel     = true

SWEP.Primary.Sound          = Sound("weapons/hammer/morrowind_hammer_slash.wav")
SWEP.Primary.Recoil         = 0.8
SWEP.Primary.Damage         = 25
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.003
SWEP.Primary.Delay          = 1
SWEP.Primary.ClipSize       = 10
SWEP.Primary.DefaultClip    = 10
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ManaCost = 3
SWEP.Primary.AttackRange = 200

SWEP.Secondary.Sound          = Sound("wc3sound/SearingArrowTarget3.wav")
SWEP.Secondary.Delay          = 3
SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = false
SWEP.Secondary.Ammo             = "none"
SWEP.Secondary.ManaCost = 8
SWEP.Secondary.AttackRange = 0


function SWEP:MainAbility()
    if self:GetNextPrimaryFire() > CurTime() then return end

    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos()+(self.Owner:GetAimVector()*self.Primary.AttackRange)
    tr.filter = self.Owner
    local trace = util.TraceLine(tr)

    if !trace.Hit then return end

    if self.Owner:GetNWInt("Mana") >= self.Primary.ManaCost then
        if SERVER then
            self.Owner:SubtractMana(self.Primary.ManaCost)
        end
        self.Owner:EmitSound(self.Primary.Sound,40,math.random(75,85))
        self:HammerSmash()
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
        self:EmitSound(self.Secondary.Sound)
        self:ThrowHammer(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
    else
        return
    end
end

function SWEP:HammerSmash()

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos()+(self.Owner:GetAimVector()*self.Primary.AttackRange)
    tr.filter = self.Owner
    local trace = util.TraceLine(tr)

    if trace.Hit then
        local fx = EffectData()
        fx:SetOrigin( trace.HitPos )
        util.Effect( "fx_hex_bowblast01", fx )
        self:EmitSound( "wc3sound/exp/FireBallMissileDeath.wav", 40, math.random(115,135) )


        if SERVER then
            for _, v in ipairs(ents.FindInSphere(trace.HitPos,95)) do
                self:DoSmash(v)
            end
        end
    end

    self:SetNextPrimaryFire(CurTime()+(self.Primary.Delay*self.Primary.AtkSpdMod))

end

function SWEP:DoSmash(vic)
    if vic:IsPlayer() then
        local vel = ( ( vic:GetPos() - self.Owner:GetPos() ) * 2 )
        vel = Vector(math.Clamp(vel.x,-700,700),math.Clamp(vel.y,-700,700),math.Clamp(vel.z,-700,700))

        vic:SetVelocity(vel+Vector(0,0,200))

        if vic != self.Owner then

            local dmginfo = DamageInfo()
            dmginfo:SetAttacker( self.Owner )
            dmginfo:SetInflictor( self )
            dmginfo:SetDamage( math.random(13,18) )
            dmginfo:SetDamageElement("fire")
            vic:TakeDamageInfo( dmginfo )

        end
    else
        vic:TakeDamage(25)
    end
end

function SWEP:ThrowHammer(damage, recoil, num_bullets, aimcone)

    if SERVER then
        for i=1,num_bullets do

            local tr = self.Owner:GetEyeTrace()
            local ent = ents.Create( "ent_hex_hammer02" )

            local projrec = recoil * 1000
            ent:SetPos(self.Owner:GetShootPos())
            ent:SetOwner( self.Owner )
            ent:SetAngles(self.Owner:EyeAngles())
            ent:Spawn()

            ent.Weapon = "a "..self.PrintName

            local phys = ent:GetPhysicsObject()
            phys:ApplyForceCenter( self.Owner:GetAimVector() +  self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 100000)
            phys:SetVelocity( phys:GetVelocity() + (self.Owner:GetAimVector()*Vector(math.random(-projrec,projrec),math.random(-projrec,projrec),math.random(-projrec,projrec))))
            phys:AddAngleVelocity( phys:GetAngleVelocity() + self.Owner:GetForward() * 555 )
            phys:EnableGravity(true)
        end
    end

    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "MuzzleHammer02", effect )

    self:SetNextPrimaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
    self:SetNextSecondaryFire(CurTime()+(self.Secondary.Delay*self.Secondary.AtkSpdMod))
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
    
    effects.Register( EFFECT, "MuzzleHammer02" )
end