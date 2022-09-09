

function GM:CanRespawn(ply)
	if ply:Team() == 1 then
		return false
	end
	
	if self:GetGameState() == 0 then
		if ply.NextSpawnTime and ply.NextSpawnTime > CurTime() then return end
		
		if ply:KeyPressed(IN_JUMP) or ply:KeyPressed(IN_ATTACK) then
			return true
		end
	end

	return false
end