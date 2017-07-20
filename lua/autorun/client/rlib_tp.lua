local tprsubject;

net.Receive( "tpr_receive", function()
    tprsubject = net.ReadEntity()
end )

net.Receive( "tpra", function()
    if tpsubject:IsValid() then
      LocalPlayer():SetPos( tprsubject:GetPos() )
    else
      chat.AddText( "Player is offline!" )
    end
end )
