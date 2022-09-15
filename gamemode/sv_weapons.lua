Weapons = {}

function registerWeapon(weapon_name, ammo_type, ammo_amount) 
	local weapon = {}
	weapon.name = weapon_name
	weapon.ammo_type = ammo_type
	weapon.ammo_amount = ammo_amount
	table.insert(Weapons, weapon)
 end

local tempG = {}
tempG.registerWeapon = registerWeapon

-- inherit from _G
local meta = {}
meta.__index = _G
meta.__newindex = _G
setmetatable(tempG, meta)

function loadWeapons(rootFolder)
	local files, dirs = file.Find(rootFolder .. "*.lua", "LUA")
	for k, v in pairs(files) do

		local name = v:sub(1, -5)
		local f = CompileFile(rootFolder .. v)
		if !f then
			return
		end
		setfenv(f, tempG)
		local b, err = pcall(f)

		local s = SERVER and "Server" or "Client"
		local b = SERVER and 90 or 0
		if !b then
			MsgC(Color(255, 50, 50 + b), s .. " loading weapons failed " .. name .. ".lua\nError: " .. err .. "\n")
		else
			MsgC(Color(50, 255, 50 + b), s .. " loaded weapons file " .. name .. ".lua\n")
		end
	end
	return Weapons
end

function applyWeapons(ply)
	for i, weapon in ipairs(Weapons) do
		ply:Give(weapon.name)
		if weapon.ammo_type ~= nil then
			ply:GiveAmmo(weapon.ammo_amount, weapon.ammo_type)
		end
	end
end

function GM:LoadWeapons()
	loadWeapons((GM or GAMEMODE).Folder:sub(11) .. "/gamemode/weapons/")
	loadWeapons("prophunters/weapons/")
end

GM:LoadWeapons()