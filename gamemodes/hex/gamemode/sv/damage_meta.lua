local dmgmeta = FindMetaTable("CTakeDamageInfo")
function dmgmeta:SetDamageElement(element) dmgmeta.DamageElement = element end
function dmgmeta:GetDamageElement() return dmgmeta.DamageElement end