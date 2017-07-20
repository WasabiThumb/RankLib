AddCSLuaFile( "autorun/client/rlib_tp.lua" )

function readrankname( id )
  local tab = util.JSONToTable( file.Read("ranklib/ranklist.txt", "DATA") )
  return tab[1];
end

function permdata( rankid, permname )
  local nam = ("ranklib/perms/" .. tostring(rankid) .. ".txt");
  local tab = util.JSONToTable( file.Read(nam, "DATA") )
  return tab[permname]
end

function setrank( player, id )
  local ply = getplayerbyname( player )
  local nam = ("ranklib/plylist/" .. tostring(id) .. ".txt");
  if !ply then return end
  if !file.Exists("plylist", "DATA") then file.CreateDir("plylist") end
  if !file.Exists(nam, "DATA") then file.Write(nam, "") end
  local tabl1 = { ply }
  local tabl2 = util.JSONToTable( file.Read(nam, "DATA") )
  local newcont = util.TableToJSON( table.Add( tabl1, tabl2 ), true );
  if (tabl2 == "") then newcont = tabl1 end
  revoke( player )
  file.Write( nam, newcont )
end

function setrank2( player, id )
  local ply = getplayerbyname( player )
  local nam = ("ranklib/plylist/" .. tostring(id) .. ".txt");
  if !ply then return end
  if !file.Exists("ranklib/plylist", "DATA") then file.CreateDir("plylist") end
  if !file.Exists(nam, "DATA") then file.Write(nam, "") end
  local tabl1 = { ply }
  local tabl2 = util.JSONToTable( file.Read(nam, "DATA") )
  file.Write( nam, util.TableToJSON( table.Add( tabl1, tabl2 ), true ) )
end

function revoke( player )
  local nam = ("ranklib/plylist/" .. tostring( getplayerbyname(player) ) .. ".txt");
  local newtab = util.JSONToTable( file.Read(nam) )
  table.RemoveByValue( newtab, getplayerbyname(player) )
  file.Write( nam )
  setrank2( player, 1 )
end
  

function getrank( player )
  local rank = nil;
  local ply = getplayerbyname( player )
  local tab;
  for i=1,-1 do
    local nam = ("ranklib/plylist/" .. tostring(i) .. ".txt");
    if !file.Exists( nam ) then break end
    tab = util.JSONToTable( file.Read(nam, "DATA") )
    for k,v in pairs( tab ) do
      if (v == ply) then 
        rank = i;
        break;
      end;
    end
  end
  return rank;
end

function getplayerbyname( name )
  local ret = nil;
  for k,v in pairs( player.GetAll() ) do
    if (v:Nick() == name) then ret = v end
  end
  return ret;
end

function SetHighestRank(ply, tbl)
  local highest = 1;
  for i=1,-1 do
    if !IsValid(tbl[i]) then break end
    highest = i;
  end
  setrank(ply:Nick(), highest)
end

-- Function section is over!

-- These are hooks, which are called when an action happens. If the player associated with the action has the right permissions, they may proceed.
-- If you know what you are doing, you can edit some stuff here, like the kick message on line 97.

hook.Add( "PlayerInitialSpawn", "rlib_hookset1", function(ply)
    if !permdata( getrank(ply), "canexist" ) then ply:Kick("You don't have the right rank to exist!") end
    if !permdata( getrank(ply), "canuseflashlight" ) then ply:AllowFlashlight( false ) end
    if !permdata( getrank(ply), "canwalk" ) then ply:SetCanWalk( false ) end
    if !permdata( getrank(ply), "canrun" ) then ply:SetRunSpeed(0) end
    if !permdata( getrank(ply), "canhaveweapon" ) then ply:StripWeapons() end
    ply:SetMaxSpeed( permdata( getrank(ply), "player_maxspeed" ) )
    local rlist_table = util.JSONToTable( file.Read( "ranklib/ranklist.txt", "DATA" ) ) -- Should we set this player to highest rank?
    if rlist_table["autofill_highest"] and ply:IsSuperAdmin() then
      SetHighestRank( ply, rlist_table )
    else if rlist_table["autofill_highest"] and ply:IsAdmin() then
      SetHighestRank( ply, rlist_table )
    end
end )

hook.Add( "PlayerCanPickupWeapon", "rlib_hookset2", function(ply, wep)
    local dta = permdata( getrank(ply), "canhaveweapon" )
    if !dta then
      ply:ChatPrint("Your rank disallows the pickup of weapons!")
    end
    return dta;
end )

hook.Add( "Think", "rlib_hookset3", function()
    for k,v in pairs( ents.GetAll() ) do
      if v:IsVehicle() then
        local driv = v:GetDriver()
        if !permdata( getrank(driv), "candrive" )
          driv:ExitVehicle()
          driv:ChatPrint("You don't have the required rank to drive this vehicle!")
        end
      end
    end
end )

hook.Add( "PlayerNoClip", "rlib_hookset4", function(ply, des)
    if !permdata( getrank(ply), "can_noclip" ) then
      ply:ChatPrint("Your rank does not allow noclipping!")
      return false
    end
end )

util.AddNetworkString("tpr_receive")
util.AddNetworkString("tpra")
hook.Add( "PlayerSay", "rlib_hookset5", function(ply, txt, tch)
  if ( string.sub( txt, 1, 5 ) == "/tpr " ) and permdata( getrank(ply), "tpr" ) then
        local totp = getplayerbyname( string.sub( txt, 6 ) );
        totp:ChatPrint("User " .. ply:Nick() .. " has requested to teleport to you. Use '/tpr_accept' to accept teleport request.")
        net.Start("tpr_receive")
        net.WriteEntity(ply)
        net.WriteBool(false)
        net.Send(totp)
        return ""
  end
  if ( string.sub( txt, 1, 11 ) == "/tpr_accept" ) and permdata( getrank(ply), "tpr_accept" ) then
        net.Start("tpra")
        net.Send(ply)
  end
end )