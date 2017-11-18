AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.ActiveRange = 0
ENT.FireInterval = 0.2
ENT.Projectile = "ent_hex_projectile_arcanebolt"
ENT.ProjectileForce = 1024
ENT.FireSound = "wc3sound/exp/PriestCastAttack1.wav"
ENT.AlwaysFiring = false
ENT.GravityToggle = false
ENT.NextFire = 0
ENT.StatInit = false

function ENT:ShootProjectile(ent,force)
	timer.Simple(0.25,function()
		local proj = ents.Create(ent)
		proj:SetPos(self:GetPos())
		proj:SetOwner(proj)
		proj:Spawn()

		self:EmitSound(self.FireSound)

		local ang = self:GetAngles():Forward() * force
		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(ang)
			phys:EnableGravity(self.GravityToggle)
		end
	end)
end

function ENT:CheckForTargets()
	local targets = 0
	for k, v in pairs(ents.FindInSphere(self:GetPos(),self.ActiveRange)) do
		if v:IsPlayer() then
			targets = targets + 1
		end
	end
	if targets > 0 then return true end
end

function ENT:Think()
	if self.NextFire < CurTime() then
		self.NextFire = CurTime() + self.FireInterval
		if self.AlwaysFiring == 1 then
			self:ShootProjectile(self.Projectile,self.ProjectileForce)
			return 
		end
		if self:CheckForTargets() == true then
			self:ShootProjectile(self.Projectile,self.ProjectileForce)
		end
	end
	self:NextThink(CurTime()+0.5)
	return true
end

function ENT:AcceptInput(input,activator,called,data)
		self:ShootProjectile(self.Projectile,self.ProjectileForce)
end

function ENT:KeyValue(key, value)
	if key == "activerange" then self.ActiveRange = value
	elseif key == "fireinterval" then 	self.FireInterval = value
	elseif key == "projectile" then 	self.Projectile = value
	elseif key == "projectileforce" then self.ProjectileForce = value
	elseif key == "firesound" then self.FireSound = value	
	elseif key == "alwaysfiring" then 	self.AlwaysFiring = value
	elseif key == "gravitytoggle" then 	
		local set
		if value == 1 then
			set = false
		elseif value == 2 then
			set = true
		end
		self.GravityToggle = set
	end
end