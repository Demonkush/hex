AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/wood_crate001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 255, 255 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(1)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetUseType( SIMPLE_USE )

	--self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end

	timer.Simple(0.1,function()
		local fx = EffectData()
		fx:SetOrigin( self:GetPos() )
		util.Effect( "fx_hex_cratespawn", fx )
	end)

	self:SetHealth(25)
	self:SetMaterial("models/props_wasteland/wood_fence01a")

	self.LootCrateID = math.random(1,99999)

	self.Popped = false

	timer.Create("LootCrate"..self.LootCrateID,20,1,function()
		if IsValid(self) then self:Remove() end
	end)
end

function ENT:CreateNewTimer()
	if timer.Exists("LootCrate"..self.LootCrateID) then
		timer.Destroy("LootCrate"..self.LootCrateID)
	end

	timer.Create("LootCrate"..self.LootCrateID,10,1,function()
		if IsValid(self) then self:Remove() end
	end)
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth( self:Health() - dmg:GetDamage() )

	self:CreateNewTimer() -- Often crates disappear before you can break them, this is a countermeasure.

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then
		phys:AddVelocity(VectorRand()*155)
	end

	if self:Health() < 1 then
		self:Pop()
	end
end

function ENT:Think()
end

function ENT:Pop()
	if self.Popped == true then return end
	self.Popped = true
    local gd = ents.Create( "ent_hex_golddrop" )
    gd:SetPos(self:GetPos())
    gd:Spawn()
	local phys = gd:GetPhysicsObject()
	if ( IsValid( phys ) ) then
		phys:AddVelocity(VectorRand()*55)
	end
    gd.Gold = math.Round( math.random( 25, 100 ) )

    self:EmitSound("wc3sound/exp/CrateDeath1.wav",75,100)

    local ctd = math.random(1,50)
    local itemr = math.random(1,2)
    if ctd > 25 then
	    if itemr == 1 then
		    if HEX.MOD.LootDropWeapons == true then
		    	-- weapon
		    	local wept = math.random(1,#HEX.WeaponTable)
		        local wp = ents.Create( "ent_hex_pickupweapon" )
		        wp:SetPos(self:GetPos())
		        wp:Spawn()
		       	wp:SetItemInfo(HEX.WeaponTable[wept].wep)
		    end
	    end
	    if itemr == 2 then
		    if HEX.MOD.LootDropItems == true then
		    	-- item
		    	local itemt = math.random(1,#HEX.ItemTable)
		        local ip = ents.Create( "ent_hex_pickupitem" )
		        ip:SetPos(self:GetPos())
		        ip:Spawn()
		       	ip:SetItemInfo(HEX.ItemTable[itemt].id)
	      	end
	    end
	end

	local roll = math.random(1,100)
	if roll >= 65 && roll <= 100 then
        local hd = ents.Create( "ent_hex_healthdrop" )
        hd:SetPos(self:GetPos())
        hd:Spawn()
		local phys1 = hd:GetPhysicsObject()
		if ( IsValid( phys1 ) ) then
			phys1:AddVelocity(VectorRand()*200)
		end
	end
	if roll >= 45 && roll <= 75 then
        local md = ents.Create( "ent_hex_manadrop" )
        md:SetPos(self:GetPos())
        md:Spawn()
		local phys2 = md:GetPhysicsObject()
		if ( IsValid( phys2 ) ) then
			phys2:AddVelocity(VectorRand()*200)
		end
	end
	if roll >= 80 then
		local pd = ents.Create( "ent_hex_powerdrop" )
        pd:SetPos(self:GetPos())
        pd:Spawn()
		local phys3 = pd:GetPhysicsObject()
		if ( IsValid( phys3 ) ) then
			phys3:AddVelocity(VectorRand()*200)
		end
	end
	self:Remove()
end

function ENT:OnRemove()
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_hex_cratespawn", fx )
end