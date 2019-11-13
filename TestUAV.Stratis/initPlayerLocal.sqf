  [] spawn{
    private _SHD = [] ExecVm "Fnc_LoadFnc_UAV.sqf";
    waitUntil{ScriptDone _SHD};
    G_UAV_bOnline = false;
    player addaction ["UAV calldown", Fnc_UAV_Init, [], -100, false, true]; 
  };