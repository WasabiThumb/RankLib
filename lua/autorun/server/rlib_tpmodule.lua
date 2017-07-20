AddCSLuaFile( "autorun/client/rlib_tp.lua" )

util.AddNetworkString("tpr_receive")
util.AddNetworkString("tpra")
hook.Add( "PlayerSay", "rlib_hookset5", function(ply, txt, tch)
  if ( string.sub( txt, 1, 5 ) == "/tpr " ) and permdata( getrank(ply), "tpr" ) then
        local totp = getplayerbyname( string.sub( txt, 6 ) );
        if (totp == nil) then return end
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
  if ( string.sub( txt, 1, 9 ) == "/tprhere " ) and permdata( getrank(ply), "tprhere" ) then
        local totp = getplayerbyname( string.sub( txt, 10 ) );
        if (totp == nil) then return end
        totp:ChatPrint("User " .. ply:Nick() .. " has requested you to teleport to them. Use '/tpr_accept' to accept teleport request.")
        net.Start("tpr_receive")
        net.WriteEntity(ply)
        net.WriteBool(true)
        net.Send(totp)
        return ""
  end
  if ( string.sub( txt, 1, 4 ) == "/tp " ) and permdata( getrank(ply), "tp" ) then
        local totp = getplayerbyname( string.sub( txt, 5 ) );
        if (totp == nil) then return end
        ply:SetPos( totp:GetPos() )
        return ""
  end
  if ( string.sub( txt, 1, 8 ) == "/tphere " ) and permdata( getrank(ply), "tphere" ) then
        local totp = getplayerbyname( string.sub( txt, 9 ) );
        if (totp == nil) then return end
        totp:SetPos( ply:GetPos() )
        return ""
  end
end )
