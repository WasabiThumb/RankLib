-- Don't touch this stuff! We need it to work!
-- This is the only thing you can change \/
local trustadmins = false;
-- /\ Set this to true if you want both superadmins and admins to execute RankLib commands.
-- Feel free to look around this code and check for malware or whatever, I assure you there is none.


function readrankname( id )
  local tab = util.JSONToTable( file.Read("ranklib/ranklist.txt", "DATA") )
  return tab[1];
end

function hasperm( rankid, permname )
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
  local newcont = util.TableToJSON( table.Add( tabl1, tabl2 );
  if (tabl2 == "") then newcont = tabl1 end
  revoke( player )
  file.Write( nam, newcont, true ) )
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
  return false
end

-- Picks up info from clients and executes these functions. For security reasons, superadmin only (unless you change the boolean up there).
util.AddNetworkString("ranklib_set")

net.Receive("ranklib_set", function(len, ply)
  if !ply:IsSuperAdmin() and !trustadmins then return end
  if !ply:IsAdmin() then return end
  setrank( net.ReadString(), net.ReadInt() )
end )
