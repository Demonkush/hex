AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


function ENT:Use(activator,caller)
	if self.NextCrestUse > CurTime() then return end
	if activator:Alive() then
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 512 )) do
			if v != activator then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( activator )
				dmginfo:SetInflictor( activator )
				dmginfo:SetDamage( math.random(7,10) )
				dmginfo:SetDamageElement("water")
				v:TakeDamageInfo( dmginfo )

				if v:IsPlayer() then
					v:BuffSoaked(activator,5,3)
				end
			end
		end
		
		self:EmitSound("wc3sound/exp/WaterElementalMissile1.wav",75,math.random(75,85))
		self:SetNWBool("CrestActive",false)
		timer.Simple(15,function()
			if IsValid(self) then
				self:SetNWBool("CrestActive",true)
			end
		end)

		timer.Simple(0.1,function()
			local fx = EffectData()
			fx:SetOrigin( self:GetPos() )
			util.Effect( "fx_hex_waterblast02", fx )
			local fx2 = EffectData() fx2:SetOrigin( self:GetPos() ) fx2:SetScale(2)
			fx2:SetAngles(Angle(155,215,255))
			util.Effect( "fx_hex_model_blast", fx2 )
		end)
		self.NextCrestUse = CurTime() + 15
	end
end

function ENT:OnRemove()

end