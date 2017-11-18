function HEX.DoBrutalDeath(ply)
	if IsValid(ply) then
		if ply.deathpos == nil then return end
		local fx = EffectData()
		fx:SetPos(ply.deathpos)
		util.Effect( "fx_hex_bloodspatter", fx )

		-- todo: bloodspatter fx, clientside gibbing, death sound

	end
end