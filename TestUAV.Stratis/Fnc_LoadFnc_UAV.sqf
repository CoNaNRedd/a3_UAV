
Fnc_UAV_SetCamCtrl = {//call

G_UAV_CtrlCamID = (findDisplay 46) displayAddEventHandler ["MouseMoving", {
params["_Disp", "_dx", "_dy"];
_dx = _dx/G_UAV_CamSensitivity;
_dy = _dy/G_UAV_CamSensitivity;

_aTmp = [_dx, _dy, (vectorDir G_UAV_Cam), (vectorUp  G_UAV_Cam)] call Fnc_UAV_GetUpAndDirRel;
_VDir = _aTmp select 0;
_VUp  = _aTmp select 1;

_VDirUAV = vectorDir G_UAV;
_VUpUAV  = vectorUp  G_UAV;
_XaxisUAV = _VDirUAV vectorCrossProduct _VUpUAV;

_VDir = [ (_VDir vectorDotProduct _XaxisUAV), (_VDir vectorDotProduct _VDirUAV), (_VDir vectorDotProduct _VUpUAV) ];
_VUp  = [ (_VUp  vectorDotProduct _XaxisUAV), (_VUp  vectorDotProduct _VDirUAV), (_VUp  vectorDotProduct _VUpUAV) ];
G_UAV_Cam setVectorDirAndUp[_VDir, _VUp];
}];

};
Fnc_UAV_SetMissileCtrl = {//call

G_UAV_CtrlMissileID = (findDisplay 46) displayAddEventHandler ["MouseMoving", {
params["_Disp", "_dx", "_dy"];
_dx = _dx/250;
_dy = _dy/300;

_aTmp = [_dx, _dy, (vectorDir G_UAV_Missile), (vectorUp  G_UAV_Missile)] call Fnc_UAV_GetUpAndDirRel;
G_UAV_Missile setVectorDirAndUp[(_aTmp select 0), (_aTmp select 1)];
}];

};
Fnc_UAV_SetCmdKeys = {//call

G_UAV_CmdKeysUpID = (findDisplay 46) displayAddEventHandler ["KeyUp", {
params["_Ctrl", "_Key", "_Shift", "_CtrlBtn", "_Alt"];

private _bRet = false;
if(_Key == 1) then{//ESC
_bRet = true;
};
if((_Key >= 2) && (_Key <= 11)) then{//num1 ... num0
_bRet = true;
};

if(_Key ==  4) then{//num3 toggle NV
  [] call Fnc_UAV_ToggleNV;
  _bRet = true;
};
if(_Key ==  5) then{//4 toggle left bar
  if(ctrlShown (G_UAV_aCtrl select 2)) then{
    { (G_UAV_aCtrl select _x) CtrlShow false; }foreach[2,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,29,30,31,32,33,34,35];
  } else{
    { (G_UAV_aCtrl select _x) CtrlShow true; }foreach[2,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,29,30,31,32,33,34,35];
    [] call Fnc_UAV_UpdtWepStatus;
  };
_bRet = true;
};
if(_Key ==  6) then{//5 toggle right bar
  {//foreach arr
    if(ctrlShown (G_UAV_aCtrl select _x)) then{
      (G_UAV_aCtrl select _x) CtrlShow false;
    } else{
      (G_UAV_aCtrl select _x) CtrlShow true;
    };
  }foreach[3,4,5,6,7,8,36,37,38,39];
  _bRet = true;
};
if(_Key == 19) then{//r switch ammo
  if(!G_UAV_bRadarScan) then{
    if(G_UAV_WepSel == "Missile") then{
      G_UAV_WepSel = "Rocket";
      [] call Fnc_UAV_AnimStatus;
    } else{
      if(G_UAV_WepSel == "Rocket") then{
        G_UAV_WepSel = "Missile";
        G_UAV_GuideMode = "TV";
        G_UAV_FlyMode = "DIR";
        [] call Fnc_UAV_AnimStatus;
      };
    };
  };
  _bRet = true;
};
if(_Key == 34) then{//g guidence mode
  if(!G_UAV_bRadarScan) then{
    if(G_UAV_WepSel == "Missile") then{
      if(G_UAV_GuideMode == "TV") then{
        G_UAV_GuideMode = "RAD";
        G_UAV_FlyMode = "DIR";
        [] call Fnc_UAV_AnimStatus;
        [] call Fnc_UAV_AnimStatus;
      } else{
        if(G_UAV_GuideMode == "RAD") then{
          G_UAV_GuideMode = "TV";
          [] call Fnc_UAV_AnimStatus;
        };
      };
    };
  };
  _bRet = true;
};
if(_Key == 33) then{//f fly mode
  if(G_UAV_WepSel == "Missile") then{
    if(G_UAV_GuideMode == "RAD") then{
      if(G_UAV_FlyMode == "DIR") then{
        G_UAV_FlyMode = "TOP";
        [] call Fnc_UAV_AnimStatus;
      } else{
        if(G_UAV_FlyMode == "TOP") then{
          G_UAV_FlyMode = "DIR";
          [] call Fnc_UAV_AnimStatus;
        };
      };
    };
  };
  _bRet = true;
};
if(_Key == 45) then{//x disengage
  if(!isNull G_UAV_TargetObj) then{
    G_UAV_TargetObj  = ObjNull;
    G_UAV_AcquiredObj = ObjNull;
    G_UAV_bRadarScan = false;
    G_UAV_LockInitTime = -1;
    };
  _bRet = true;
};
if(_Key == 46) then{//c toggle color
if(G_UAV_HUDcolor isEqualTo [1,1,1]) then{
    G_UAV_HUDcolor = [0,1,0];
} else{
if(G_UAV_HUDcolor isEqualTo [0,1,0]) then{
    G_UAV_HUDcolor = [0,0,1];
} else{
if(G_UAV_HUDcolor isEqualTo [0,0,1]) then{
    G_UAV_HUDcolor = [1,0,0];
} else{
if(G_UAV_HUDcolor isEqualTo [1,0,0]) then{
    G_UAV_HUDcolor = [1,1,0];
} else{
if(G_UAV_HUDcolor isEqualTo [1,1,0]) then{
    G_UAV_HUDcolor = [0,1,1];
} else{
if(G_UAV_HUDcolor isEqualTo [0,1,1]) then{
    G_UAV_HUDcolor = [1,1,1];
};
};
};
};
};
};
[] call Fnc_UAV_AnimHUDcolor;
_bRet = true;
};
if(_Key == 57) then{//space fire
  [] call Fnc_UAV_DoFire;
  _bRet = true;
};
if(_Key == 78) then{//+ +Zoom
  G_UAV_CamZoom = (G_UAV_CamZoom - 0.1) max 0.1;
  G_UAV_Cam camSetFOV G_UAV_CamZoom;
  G_UAV_Cam camCommit 0;
  playSound "ZoomIn";
  _bRet = true;
};
if(_Key == 74) then{//- -Zoom
  G_UAV_CamZoom = (G_UAV_CamZoom + 0.1) min 0.4;
  G_UAV_Cam camSetFOV G_UAV_CamZoom;
  G_UAV_Cam camCommit 0;
  playSound "ZoomOut";
  _bRet = true;
};
if(_Key in [2,3]) then{//num1, num2  toggle FLIR
  [] call Fnc_UAV_ToggleFlir;
  _bRet = true;
};

_bRet
}];
G_UAV_CmdKeysDownID = (findDisplay 46) displayAddEventHandler ["KeyDown", {
params["_Ctrl", "_Key", "_Shift", "_CtrlBtn", "_Alt"];

private _bRet = false;
if(_Key == 1) then{//ESC
if(G_UAV_bCanESC) then{ G_UAV_bCanESC = false; [] call Fnc_UAV_CleanUp; };
_bRet = true;
};
if((_Key >= 2) && (_Key <= 11)) then{//num1 ... num0
_bRet = true;
};

if(_Key == 30) then{//a -Sensitivity
G_UAV_CamSensitivity = (G_UAV_CamSensitivity + 20) min 210;
_bRet = true;
};
if(_Key == 32) then{//d +Sensitivity
G_UAV_CamSensitivity = (G_UAV_CamSensitivity - 20) max 50;
_bRet = true;
};
if(_Key == 10) then{//9 +transparency
G_UAV_Transparency = (G_UAV_Transparency + 0.1) min 1;
(G_UAV_aCtrl select 2) ctrlSetText format["#(argb,8,8,3)color(0,0,0,%1)", G_UAV_Transparency]; 
(G_UAV_aCtrl select 3) ctrlSetText format["#(argb,8,8,3)color(0,0,0,%1)", G_UAV_Transparency]; 
_bRet = true;
};
if(_Key == 11) then{//0 -transparency
G_UAV_Transparency = (G_UAV_Transparency - 0.1) max 0;
(G_UAV_aCtrl select 2) ctrlSetText format["#(argb,8,8,3)color(0,0,0,%1)", G_UAV_Transparency]; 
(G_UAV_aCtrl select 3) ctrlSetText format["#(argb,8,8,3)color(0,0,0,%1)", G_UAV_Transparency]; 
_bRet = true;
};

_bRet
}];
G_UAV_CmdKeysMouseUpID = (findDisplay 46) displayAddEventHandler ["MouseButtonUp", {
params["_Ctrl", "_Button", "_xPos", "_yPos", "_Shift", "_CtrlBtn", "_Alt"];

if(_Button == 0) then{//left click
[] spawn Fnc_UAV_DoFire;
};
if(_Button == 1) then{//right click
  if(isNull G_UAV_TargetObj) then{
    if(!isNull G_UAV_AcquiredObj) then{
      G_UAV_AcquiredObj setvariable["G_LockOnTimeOut", 0, false];
      G_UAV_AcquiredObj setvariable["G_LockOnTime", 0, false];
    };
    G_UAV_AcquiredObj = ObjNull;
    G_UAV_bRadarScan = false;
    G_UAV_LockInitTime = -1;
  };
};

}];
G_UAV_CmdKeysMouseDownID = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
params["_Ctrl", "_Button", "_xPos", "_yPos", "_Shift", "_CtrlBtn", "_Alt"];

if(_Button == 1) then{//right click
  _bCanRadar = (isNull G_UAV_TargetObj) && (G_UAV_WepSel == "Missile") && (G_UAV_MissileCount > 0) && (G_UAV_GuideMode == "RAD");
  if(_bCanRadar) then{
    if(!G_UAV_bRadarScan) then{
      [] spawn{
        for "_i" from 1 to 3 do{
          playSound3D["a3\sounds_f\arsenal\tools\MineDetector_Beep_01.wss", G_UAV, false, (getPosASL G_UAV), 5, 1, 10];  
          sleep 0.1;
        };
      };
    };
    G_UAV_bRadarScan = true;
    G_UAV_LockInitTime = time;
  };
};

}];

};
Fnc_UAV_GetUpAndDirRel = {//call
params["_dx", "_dy", "_VDir", "_VUp"];

_Yaw = (_VDir select 0) atan2 (_VDir select 1);
_Yaw = [_Yaw, (_Yaw + 360)] select (_Yaw < 0);
_Yaw = [_Yaw, (_Yaw + (_dx*180/pi))] select (_dx != 0);
_Yaw = [_Yaw, (_Yaw + 360)] select (_Yaw <    0);
_Yaw = [_Yaw, (_Yaw - 360)] select (_Yaw >= 360);
_VDrZ0 = [sin _Yaw, cos _Yaw, 0];

_bAimDwn = ((_VDir select 2) < 0);
_MxPitch = [5, 80] select _bAimDwn;
_Pitch = (aCos (((_VDrZ0 vectorDotProduct _VDir) max -1) min 1)) min _MxPitch;//dunno why Im getting vectorDotProduct >1,<-1
_Pitch = [_Pitch, (360 - _Pitch)] select _bAimDwn;
_Pitch = [_Pitch, (_Pitch - (_dy*180/pi))] select (_dy != 0);
_Pitch = [_Pitch, ([_MxPitch, (360-_MxPitch)] select _bAimDwn)] select ((_Pitch > _MxPitch) && (_Pitch < (360-_MxPitch)));

_retVDir = [_VDir, [(sin _Yaw)*(cos _Pitch), (cos _Yaw)*(cos _Pitch), sin _Pitch]] select (_dx != 0);
_retVUp  = [_VUp,    ((_VDir vectorCrossproduct _VDrZ0) vectorCrossproduct _VDir)] select (_dy != 0);

[_retVDir, _retVUp]
};

Fnc_UAV_Init = {//spawn
//----------------------------------------------------------
if(G_UAV_bOnline) exitwith{};
G_UAV_bOnline = true;
//----------------------------------------------------------
[] call Fnc_UAV_DisableESC;
//----------------------------------------------------------
G_UAV_MissileCount = 2;//cfg 2
G_UAV_RocketCount  = 6;//cfg 6
G_UAV_WepSel  = "Missile";
G_UAV_GuideMode = "TV";
G_UAV_FlyMode = "DIR";
G_UAV_CamSensitivity  = 130;//+Sen->(130--)  -Sen->(130++)
G_UAV_CamZoom  = 0.40;//+Zoom->(0.40--)  -Zoom->(0.40++)
G_UAV_Transparency = 0.3;
G_UAV_HUDcolor = [1,1,1];

G_UAV_GuidedMissile = "Missile_AGM_02_F";//CUP_M_AGM_114K_Hellfire_II_AT
G_UAV_UnguidedMissile = "M_RPG32_F";//CUP_R_TBG7V_AT

G_UAV_FlirMode = "OFF";
G_UAV_NV = "OFF";
G_UAV_bHaveGUI = false;
G_UAV_bCanESC = true;
G_UAV_aCtrl = [];

G_UAV_ScanSfxHz = 0.5;//sfx
G_UAV_bRadarScan = false;
G_UAV_bUpdtRADAR = true;
G_UAV_RadarRange = 300;//cfg 300
G_UAV_aRADARObjs = [];
G_UAV_aRADARidc = [];
G_UAV_TargetObj = ObjNull;
G_UAV_AcquiredObj = ObjNull;
G_UAV_RadarSleep = 0.03125;//1/f  f:32Hz
G_UAV_AcquireTime = 2;//cfg 2 seconds
G_UAV_LockOnTime = 5;//cfg 5 seconds
G_UAV_LockOnTimeOut = 1.5;//cfg 1.5 seconds
G_UAV_LockInitTime = -1;
//----------------------------------------------------------
101 cutRsc ["RscStatic", "PLAIN"];
_ppRFx = ppEffectCreate ["filmGrain", 2600];
_ppRFx ppEffectEnable true;
_ppRFx ppEffectAdjust [1,0,2,1,1,0]; 
_ppRFx ppEffectCommit 0;
_ppRFx spawn{ waitUntil{G_UAV_bHaveGUI}; ppEffectDestroy _this; };
//----------------------------------------------------------
_PPos = ASLtoAGL (getPosWorld Player);
G_UAV = createVehicle ["C_IDAP_UAV_06_antimine_F", (_PPos vectorAdd [0,100,80]), [], 0, "FLY"];
G_UAV setDir -90;
G_UAV setvelocity[0,0,0];

G_UAV setcaptive true;
createVehicleCrew G_UAV;
_wp = (group G_UAV) addWaypoint [position player, 0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType "CIRCLE_L";
_wp setWaypointLoiterRadius 100;
G_UAV flyInHeight 80;
G_UAV limitSpeed 80; 
//----------------------------------------------------------
//[] call Fnc_UAV_InitOpViewCam;//cant have PiP
//----------------------------------------------------------
G_UAV_Cam = "camera" camCreate ((getPosATL player) vectorAdd [0,0,4]);
G_UAV_Cam cameraEffect ["External", "TOP"];
G_UAV_Cam camSetFOV G_UAV_CamZoom;
G_UAV_Cam camCommit 0;
G_UAV_Cam attachTo [G_UAV, [0,0,-1]];
showCinemaBorder false;
cameraEffectEnableHUD true;
//----------------------------------------------------------
[] call Fnc_UAV_DrawControls;
[] call Fnc_UAV_SetCamCtrl;
[] call Fnc_UAV_EnableESC;
[] call Fnc_UAV_SetCmdKeys;
//----------------------------------------------------------
G_UAV_sInfoBox   = [] spawn Fnc_UAV_InitInfoBox;
G_UAV_sRadarMain = [] spawn Fnc_UAV_InitRadar;
G_UAV_sRadarSFX  = [] spawn Fnc_UAV_InitRadarSFX;
G_UAV_DrawTargetID = addMissionEventHandler["Draw3D", Fnc_UAV_TrackTarget];
//----------------------------------------------------------
};
Fnc_UAV_InitOpViewCam = {//call
//----------------------------------------------------------
_PPos = getPosWOrld player; _PPos set [2,0];
G_UAV_OpCam = "camera" camCreate (_PPos vectorAdd [0,20,25]);
G_UAV_OpCam cameraEffect ["INTERNAL", "BACK", "OpUAVPiP"];
G_UAV_OpCam camSetTarget player;
G_UAV_OpCam camSetFOV 0.25;
G_UAV_OpCam camCommit 0;
//----------------------------------------------------------
G_UAV_OpCamDir = 0;
//----------------------------------------------------------
G_UAV_OperatorCamMove = [] spawn{
while {TRUE} do{
_Pos = (getPosASL player) vectorAdd [(20*(sin G_UAV_OpCamDir)), (20*(cos G_UAV_OpCamDir)), 25];

G_UAV_OpCam camSetPos (ASLtoAGL _Pos);
G_UAV_OpCam camCommit 0.25;
WaitUntil{camCommitted G_UAV_OpCam};

G_UAV_OpCamDir = (G_UAV_OpCamDir + 1) min 360;
};
};
//----------------------------------------------------------
};
Fnc_UAV_InitInfoBox = {//spawn

while{TRUE} do{
_GRID = (mapGridPosition G_UAV);
_ELEV = ((getPosASL G_UAV) select 2) toFixed 0;
_AZIM = ([0,0,0] getDir G_UAV) toFixed 1;
_VELO = (speed G_UAV) toFixed 1;
private _TYPE = "--";
_ZOOM = ((0.4 - G_UAV_CamZoom)*10)+1;
_SENS = floor linearConversion[50,210,G_UAV_CamSensitivity,200,25];
_COLOR = G_UAV_HUDcolor call BIS_fnc_colorRGBtoHTML;
private _SPDT = "--";

if(!isNull G_UAV_AcquiredObj) then{
_TYPE = gettext(configFile >> 'CfgVehicles' >> (typeof G_UAV_AcquiredObj) >> 'displayName');
_TYPE = [_TYPE, 0, 13] call BIS_fnc_trimString;
_SPDT = (speed G_UAV_AcquiredObj) toFixed 1;;
};
if(!isNull G_UAV_TargetObj) then{
_TYPE = gettext(configFile >> 'CfgVehicles' >> (typeof G_UAV_TargetObj) >> 'displayName');
_TYPE = [_TYPE, 0, 13] call BIS_fnc_trimString;
_SPDT = (speed G_UAV_TargetObj) toFixed 1;;
};

_Str = format["<t color='%1' size='0.75' font='PuristaMedium'>", _COLOR];
_Str = _Str + format["<t align='left'>GRID:</t><t align='right'>%1</t><br />", _GRID];
_Str = _Str + format["<t align='left'>ELEV:</t><t align='right'>%1 mASL</t><br />", _ELEV];
_Str = _Str + format["<t align='left'>AZIM:</t><t align='right'>%1 deg</t><br />", _AZIM];
_Str = _Str + format["<t align='left'>VELO:</t><t align='right'>%1 Km/h</t><br />", _VELO];
_Str = _Str + format["<t align='left'>TYPE:</t><t align='right'>%1</t><br />", _TYPE];
_Str = _Str + format["<t align='left'>SPDT:</t><t align='right'>%1 Km/h</t><br />", _SPDT];
_Str = _Str + format["<t align='left'>ZOOM:</t><t align='right'>x %1</t><br />", _ZOOM];
_Str = _Str + format["<t align='left'>SENS:</t><t align='right'>%2 %1</t><br />", _SENS, "%"];
_Str = _Str + format["</t>"];

(G_UAV_aCtrl select 28) CtrlSetStructuredText (parsetext _Str);
sleep 0.1;
};

};
Fnc_UAV_InitRadar = {//spawn
_GetNearTargets = {

private _aRet = [];
if((count G_UAV_aRADARObjs) > 0) then{
{//foreach G_UAV_aRADARObjs
if((_x Distance2D (screenToWorld [0.5,0.5])) <= 10) then{
if(!(_x isKindOf "CAManBase")) then{
  _aRet pushback _x;
};
};
}foreach G_UAV_aRADARObjs;
};

_aRet
};
_AcquireTarget = {
params["_aObjs"];

private["_Stamp", "_Time", "_Highest"];
_Highest = 0;

{//foreach _aObjs
ScopeName "MainLoop";
_Stamp = _x getVariable["G_AcknowledgedStamp", -1];
if(_Stamp < 0) then{
  _x setVariable["G_AcknowledgedStamp", G_UAV_LockInitTime, false];
  _x setVariable["G_AcknowledgedTime", G_UAV_RadarSleep, false];
} else{
  if(_Stamp == G_UAV_LockInitTime) then{
    _Time = _x getVariable["G_AcknowledgedTime", 0];
    _Time = _Time + G_UAV_RadarSleep;
    if(_Time >= G_UAV_AcquireTime) then{
      G_UAV_AcquiredObj = _x;
      _x setVariable["G_LockOnTimeOut", 0, false];
      _x setVariable["G_LockOnTime", 0, false];
      _x setVariable["G_LockOnTimeStamp", G_UAV_LockInitTime, false];
      breakOut "MainLoop";
    } else{
      _x setVariable["G_AcknowledgedTime", _Time, false];
    };
  } else{
    _x setVariable["G_AcknowledgedStamp", G_UAV_LockInitTime, false];
    _x setVariable["G_AcknowledgedTime", G_UAV_RadarSleep, false];
  };
};
}foreach _aObjs;

};
_SetLockOnTimeOut = {

private["_Stamp", "_Time"];
_Stamp = G_UAV_AcquiredObj getVariable["G_LockOnTimeStamp", -1];
if(_Stamp < 0) then{
  G_UAV_AcquiredObj setVariable["G_LockOnTimeStamp", G_UAV_LockInitTime, false];
  G_UAV_AcquiredObj setVariable["G_LockOnTimeOut", G_UAV_RadarSleep, false];
} else{
  if(_Stamp == G_UAV_LockInitTime) then{
    _Time = G_UAV_AcquiredObj getVariable["G_LockOnTimeOut", 0];
    _Time = _Time + G_UAV_RadarSleep;
    if(_Time >= G_UAV_LockOnTimeOut) then{
      G_UAV_TargetObj = ObjNull;
      G_UAV_AcquiredObj setVariable["G_LockOnTimeOut", 0, false];
      G_UAV_AcquiredObj setVariable["G_LockOnTime", 0, false];
      G_UAV_AcquiredObj setVariable["G_LockOnTimeStamp", -1, false];
      G_UAV_AcquiredObj = ObjNull;
      G_UAV_LockInitTime = time;
    } else{
      G_UAV_AcquiredObj setVariable["G_LockOnTimeOut", _Time, false];
    };
  } else{
    G_UAV_AcquiredObj setVariable["G_LockOnTimeStamp", G_UAV_LockInitTime, false];
    G_UAV_AcquiredObj setVariable["G_LockOnTimeOut", G_UAV_RadarSleep, false];
  };
};

};
_SetLockOnTime = {

private["_Stamp", "_Time"];
_Stamp = G_UAV_AcquiredObj getVariable["G_LockOnTimeStamp", -1];
if(_Stamp < 0) then{
  G_UAV_AcquiredObj setVariable["G_LockOnTimeStamp", G_UAV_LockInitTime, false];
  G_UAV_AcquiredObj setVariable["G_LockOnTime", G_UAV_RadarSleep, false];
} else{
  if(_Stamp == G_UAV_LockInitTime) then{
    _Time = G_UAV_AcquiredObj getVariable["G_LockOnTime", 0];
    _Time = _Time + G_UAV_RadarSleep;
    if(_Time >= G_UAV_LockOnTime) then{
      G_UAV_TargetObj = G_UAV_AcquiredObj;
      G_UAV_AcquiredObj setVariable["G_LockOnTimeOut", 0, false];
      G_UAV_AcquiredObj setVariable["G_LockOnTime", 0, false];
      G_UAV_AcquiredObj setVariable["G_LockOnTimeStamp", -1, false];
      G_UAV_AcquiredObj = ObjNull;
      G_UAV_bRadarScan = false;
      G_UAV_LockInitTime = -1;
    } else{
      G_UAV_AcquiredObj setVariable["G_LockOnTime", _Time, false];
    };
  } else{
    G_UAV_AcquiredObj setVariable["G_LockOnTimeStamp", G_UAV_LockInitTime, false];
    G_UAV_AcquiredObj setVariable["G_LockOnTime", G_UAV_RadarSleep, false];
  };
};

G_UAV_ScanSfxHz = linearConversion[0,G_UAV_LockOnTime,_Time,0.5,0.1,true];
};

private _aObj = [];
while{G_UAV_bOnline} do{

if(G_UAV_bRadarScan) then{
  _aObj = [] call _GetNearTargets;
  if((count _aObj) > 0) then{
    if(isNull G_UAV_AcquiredObj) then{
      [_aObj] call _AcquireTarget;
    } else{
      if(G_UAV_AcquiredObj in _aObj) then{
        [] call _SetLockOnTime;
      } else{
        [] call _SetLockOnTimeOut;
      };
    };
  } else{
    if(!isNull G_UAV_AcquiredObj) then{
      [] call _SetLockOnTimeOut;
    };
  };
};

if(G_UAV_bUpdtRADAR) then{
  G_UAV_bUpdtRADAR = false;
  [] spawn Fnc_UAV_UpdtRadar;
};

sleep G_UAV_RadarSleep;
};

};
Fnc_UAV_UpdtRadar = {//spawn
_CreateControl = {
disableserialization;
params["_Obj", "_iRad", "_iDirRel", "_iDirObj"];

private["_nIDC", "_IDC"];
_nIDC = count G_UAV_aRADARidc;
if(_nIDC == 0) then{ _IDC = 2000; } else{ _IDC = (G_UAV_aRADARidc select (_nIDC-1))+1; };
if(_IDC in G_UAV_aRADARidc) then{
while{TRUE} do{
ScopeName "DupLoop";
_IDC = _IDC + 1;
if(!(_IDC in G_UAV_aRADARidc)) then{ breakOut "DupLoop"; };
};
};

_Obj setVariable ["RADAR_CtrlID", _IDC, false];
G_UAV_aRADARidc pushback _IDC;
G_UAV_aRADARObjs pushback _Obj;

_Ctrl = (uiNamespace getVariable "RscUAVDisp") ctrlCreate ["RscPicture", _IDC]; 

private _Image = "\a3\ui_f\data\Map\VehicleIcons\iconVehicle_ca.paa";
switch(true) do{
case (_Obj isKindOf     "CAManBase") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"; };
case (_Obj isKindOf  "StaticWeapon") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconStaticMG_ca.paa"; };
case (_Obj isKindOf "Wheeled_Apc_F") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconAPC_ca.paa"; };
case (_Obj isKindOf          "Tank") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconTank_ca.paa"; };
case (_Obj isKindOf   "LandVehicle") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconCar_ca.paa"; };
case (_Obj isKindOf    "Helicopter") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconHelicopter_ca.paa"; };
case (_Obj isKindOf         "Plane") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconPlane_ca.paa"; };
case (_Obj isKindOf          "Ship") :{ _Image = "\a3\ui_f\data\Map\VehicleIcons\iconShip_ca.paa"; };
};
_Ctrl ctrlSetText _Image; 

private _Color = [1,0,0,1];
if((side _Obj) == west) then{ _Color = [0,0,1,1]; };
if((side _Obj) == civilian) then{ _Color = [1,1,0,1]; };
_Ctrl ctrlSetTextColor _Color; 

private["_dimX", "_dimY"];
_dimX = G_UAV_RADAR_Rad/8;
_dimY = _dimX*(safeZoneW/safeZoneH);

_iRad = linearConversion[0,300,_iRad,0,G_UAV_RADAR_Rad,true];
_Px = (G_UAV_RADAR_Center select 0)+(_iRad*(sin _iDirRel))-(0.50*_dimX);
_Py = (G_UAV_RADAR_Center select 1)-(_iRad*(cos _iDirRel))-(0.50*_dimY);
_Ctrl ctrlSetAngle [_iDirObj, 0.5, 0.5, false]; 

switch(true) do{
case (_Obj isKindOf "CAManBase") :{ _dimX=_dimX*0.5; _dimY=_dimY*0.5; };
};
_Ctrl ctrlSetPosition [_Px, _Py, _dimX, _dimY]; 
_Ctrl ctrlCommit 0;
if(!G_UAV_bHaveGUI) then{ _Ctrl CtrlShow false; };

};
_UpdateControl = {
disableserialization;

params["_Obj", "_CtrlID", "_iRad", "_iDirRel", "_iDirObj"];

_Ctrl = (uiNamespace getVariable "RscUAVDisp") displayCtrl _CtrlID;
 
private _Color = [1,0,0,1];
if((side _Obj) == west) then{ _Color = [0,0,1,1]; };
if((side _Obj) == civilian) then{ _Color = [1,1,0,1]; };
_Ctrl ctrlSetTextColor _Color; 

private["_dimX", "_dimY"];
_dimX = G_UAV_RADAR_Rad/8;
_dimY = _dimX*(safeZoneW/safeZoneH);

_iRad = linearConversion[0,300,_iRad,0,G_UAV_RADAR_Rad,true];
_Px = (G_UAV_RADAR_Center select 0)+(_iRad*(sin _iDirRel))-(0.50*_dimX);
_Py = (G_UAV_RADAR_Center select 1)-(_iRad*(cos _iDirRel))*1.3-(0.50*_dimX);
_Ctrl ctrlSetAngle [_iDirObj, 0.5, 0.5, false]; 

switch(true) do{
case (_Obj isKindOf "CAManBase") :{ _dimX=_dimX*0.5; _dimY=_dimY*0.5; };
};

_Ctrl ctrlSetPosition [_Px, _Py, _dimX, _dimY]; 
_Ctrl ctrlCommit 0;
};
_UpdateUAVIcon = {
_dimX = G_UAV_RADAR_Rad*0.33;
_dimY = _dimX*(safeZoneW/safeZoneH);
_Px = (G_UAV_RADAR_Center select 0)-(0.50*_dimX);
_Py = (G_UAV_RADAR_Center select 1)-(0.50*_dimY);
(G_UAV_aCtrl select 40) ctrlSetAngle [((getDir G_UAV)-(getDir G_UAV_Cam)), 0.5, 0.5, false]; 
(G_UAV_aCtrl select 40) ctrlSetPosition [_Px, _Py, _dimX, _dimY]; 
(G_UAV_aCtrl select 40) ctrlCommit 0;
};

[] call _UpdateUAVIcon;

private["_CtrlID", "_iRad", "_iDirRel", "_iDirObj"];
_UAVPos = getPosWorld G_UAV; _UAVPos set [2,0];
{//foreach nearEntities
if(_x != G_UAV) then{
if(_x != player) then{

_iRad = (_x distance2D G_UAV) min G_UAV_RadarRange;
_CtrlID  = _x getVariable ["RADAR_CtrlID", -1];
_iDirRel = (G_UAV_Cam getDir _x)-(getDir G_UAV_Cam);
_iDirObj = getDir _x;
if(_CtrlID == -1) then{
  [_x, _iRad, _iDirRel, _iDirObj] call _CreateControl;
} else{
  [_x, _CtrlID, _iRad, _iDirRel, _iDirObj] call _UpdateControl;
};

};
};
}foreach (_UAVPos nearEntities [["LandVehicle", "Plane", "Helicopter", "Ship", "CAManBase"], (G_UAV_RadarRange+60)]);

private _aDel = [];
{//foreach G_UAV_aRADARObjs
if(alive _x) then{
if((_x distance2D G_UAV) > (G_UAV_RadarRange+60)) then{
  _CtrlID = _x getVariable ["RADAR_CtrlID", -1];
  if(_CtrlID != -1) then{
    _x setVariable ["RADAR_CtrlID", -1, false];
    CtrlDelete ((uiNamespace getVariable "RscUAVDisp") displayCtrl _CtrlID);
    G_UAV_aRADARidc = G_UAV_aRADARidc - [_CtrlID];
  };
  _aDel pushback _foreachIndex;
};
} else{
  if(!isNull _x) then{
    _CtrlID = _x getVariable ["RADAR_CtrlID", -1];
    _x setVariable ["RADAR_CtrlID", -1, false];
    CtrlDelete ((uiNamespace getVariable "RscUAVDisp") displayCtrl _CtrlID);
    G_UAV_aRADARidc = G_UAV_aRADARidc - [_CtrlID];
  };
  _aDel pushback _foreachIndex;
};
}foreach G_UAV_aRADARObjs;
if((count _aDel) > 0) then{ { G_UAV_aRADARObjs deleteAt _x; }foreach _aDel; };

G_UAV_bUpdtRADAR = true;
};
Fnc_UAV_InitRadarSFX = {//spawn
while{TRUE} do{

if(!isNull G_UAV_AcquiredObj) then{
  playSound3D["a3\sounds_f\arsenal\weapons\Launchers\NLAW\locking_NLAW.wss", G_UAV, false, (getPosASL G_UAV), 5, 1, 10]; 
  sleep G_UAV_ScanSfxHz;//0.5-0.1
} else{
if(!isNull G_UAV_TargetObj) then{
  playSound3D["a3\sounds_f\arsenal\weapons\Launchers\NLAW\locked_NLAW.wss", G_UAV, false, (getPosASL G_UAV), 5, 1, 10]; 
  sleep 0.2;
} else{
  sleep 0.2;
};
};

};
};
Fnc_UAV_TrackTarget = {//call

if((count G_UAV_aRADARObjs) > 0) then{
  { [_x] call Fnc_UAV_MarkObj; }foreach G_UAV_aRADARObjs;
};

if(!isNull G_UAV_TargetObj) then{
drawIcon3D [
  (MISSION_ROOT+"images\UAV\lockedOn.paa"),
  [1,0,0,1],
  G_UAV_TargetObj modelToWorldVisual [0,0,0],
  1,
  1,
  0,
  "LOCKED",
  2,
  0.1,
  "TahomaB",
  "center",
  true
];
};

};
Fnc_UAV_MarkObj = {//call
//-----------------------------------------------------------------------------------------
params["_Obj"];
//-----------------------------------------------------------------------------------------
private["_img", "_size"];
_img = "\a3\ui_f\data\Map\GroupIcons\selector_selectedMission_ca.paa";
_size = 0.90;

if(_Obj isKindOf "CAManBase") then{
  _img = "\a3\ui_f\data\Map\VehicleIcons\PictureExplosive_ca.paa";
  _size = 0.65;
};
//-----------------------------------------------------------------------------------------
_aBBx = boundingBoxreal _Obj;
_h = abs( ((_aBBx select 1) select 2) - ((_aBBx select 0) select 2) );
_h = _h / 2;
_PosObj = ASLtoAGL (getPosASLVisual _Obj);

_pos = _PosObj vectorAdd [0,0,_h];
drawIcon3D[_img, [1, 0, 0, 0.75], _pos, _size, _size, 0, "", 2, 0.030, "PuristaMedium", "center", true];
//-----------------------------------------------------------------------------------------
_Str = format["%1 m", (floor (_Obj distance2D G_UAV))];
_pos = _PosObj;
drawIcon3D["", [1, 0, 0, 1], _pos, 1, 1, 0, _Str, 1, 0.030, "PuristaMedium", "center", true];
//-----------------------------------------------------------------------------------------
};
Fnc_UAV_CleanUp = {//call

(findDisplay 46) displayRemoveEventHandler ["MouseMoving", G_UAV_CtrlCamID];
(findDisplay 46) displayRemoveEventHandler ["KeyUp",     G_UAV_CmdKeysUpID];
(findDisplay 46) displayRemoveEventHandler ["KeyDown", G_UAV_CmdKeysDownID];
(findDisplay 46) displayRemoveEventHandler ["MouseButtonUp", G_UAV_CmdKeysMouseUpID];
(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", G_UAV_CmdKeysMouseDownID];
removeMissionEventHandler["Draw3D", G_UAV_DrawTargetID];

[] spawn{
terminate G_UAV_sInfoBox;
waitUntil{scriptDone G_UAV_sInfoBox};
terminate G_UAV_sRadarSFX;
waitUntil{scriptDone G_UAV_sRadarSFX};

G_UAV_bOnline = false;
waitUntil{G_UAV_bUpdtRADAR};

101 cutRsc ["RscStatic", "PLAIN"];
_ppRFx = ppEffectCreate ["filmGrain", 2600];
_ppRFx ppEffectEnable true;
_ppRFx ppEffectAdjust [1,0,2,1,1,0]; 
_ppRFx ppEffectCommit 0;
_ppRFx spawn{ sleep 1; ppEffectDestroy _this; };

for "_i" from 0 to ((count G_UAV_aCtrl)-1) do{ CtrlDelete (G_UAV_aCtrl select _i); };
{ CtrlDelete ((uiNamespace getVariable "RscUAVDisp") displayCtrl _x); }foreach G_UAV_aRADARidc;
{ _x setVariable ["RADAR_CtrlID", -1, false]; }foreach G_UAV_aRADARObjs;


G_UAV_Cam cameraEffect ["TERMINATE","BACK"];
camDestroy G_UAV_Cam;
deletevehicle G_UAV;

_Disp = uiNamespace getVariable "RscUAVDisp"; 
_Disp closeDisplay 1;

G_UAV_sInfoBox = nil;
G_UAV_sRadarMain = nil;
G_UAV_sRadarSFX = nil;
G_UAV_aCtrl = nil;
G_UAV_bHaveGUI = nil;
G_UAV_RADAR_Center = nil;
G_UAV_RADAR_Rad    = nil;
G_UAV_aRADARObjs   = nil;
G_UAV_aRADARidc    = nil;

G_UAV = nil;
G_UAV_Cam = nil;
G_UAV_CtrlCamID = nil;
G_UAV_CmdKeysUpID = nil;
G_UAV_CmdKeysDownID = nil;
G_UAV_CmdKeysMouseUpID = nil;
G_UAV_CmdKeysMouseDownID = nil;
G_UAV_DrawTargetID = nil;
G_UAV_NoESC = nil;
G_UAV_bCanESC = nil;

G_UAV_GuidedMissile = nil;
G_UAV_UnguidedMissile = nil;
G_UAV_WepSel = nil;
G_UAV_GuideMode = nil;
G_UAV_FlyMode = nil;
G_UAV_CamSensitivity  = nil;
G_UAV_CamZoom = nil;
G_UAV_Transparency = nil;
G_UAV_HUDcolor = nil;
G_UAV_FlirMode = nil;
G_UAV_NV = nil;
G_UAV_ScanSfxHz = nil;

G_UAV_bRadarScan = nil;
G_UAV_RadarRange = nil;
G_UAV_bUpdtRADAR = nil;
G_UAV_TargetObj = nil;
G_UAV_AcquiredObj = nil;
G_UAV_AcquireTime = nil;
G_UAV_LockOnTime = nil;
G_UAV_LockOnTimeOut = nil;
G_UAV_LockInitTime = nil;

G_UAV_Missile = nil;
G_UAV_Missilecam = nil;
G_UAV_CtrlMissileID = nil;
};
};

Fnc_UAV_DoFire = {//call
private _Target = G_UAV_TargetObj;

private _bFireTV = (G_UAV_WepSel == "Missile") && (G_UAV_MissileCount > 0) && (G_UAV_GuideMode == "TV");
if(_bFireTV) then{
(findDisplay 46) displayRemoveEventHandler ["MouseMoving", G_UAV_CtrlCamID];
(findDisplay 46) displayRemoveEventHandler ["KeyUp",     G_UAV_CmdKeysUpID];
(findDisplay 46) displayRemoveEventHandler ["KeyDown", G_UAV_CmdKeysDownID];
(findDisplay 46) displayRemoveEventHandler ["MouseButtonUp", G_UAV_CmdKeysMouseUpID];
(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", G_UAV_CmdKeysMouseDownID];
[] call Fnc_UAV_DisableESC;
[] spawn Fnc_UAV_FireMisileTV;
};

_bFireRAD = (G_UAV_WepSel == "Missile") && (G_UAV_MissileCount > 0) && (G_UAV_GuideMode == "RAD") && !(isNull G_UAV_TargetObj);
if(_bFireRAD) then{
G_UAV_TargetObj  = ObjNull;
G_UAV_AcquiredObj = ObjNull;
G_UAV_bRadarScan = false;
G_UAV_LockInitTime = -1;

if(G_UAV_FlyMode == "DIR") then{
  [_Target, G_UAV_MissileCount] spawn Fnc_UAV_FireMisileDIR;
};
if(G_UAV_FlyMode == "TOP") then{
  [_Target] spawn Fnc_UAV_FireMisileTOP;
};
};

_bRockets = (G_UAV_WepSel == "Rocket") && (G_UAV_RocketCount > 0);
if(_bRockets) then{
[] spawn Fnc_UAV_FireRocket;
};

if(_bFireTV || _bFireRAD) then{
  G_UAV_MissileCount = G_UAV_MissileCount - 1;
  _ColorStr = G_UAV_HUDcolor call BIS_fnc_colorRGBtoHTML;
  _Str = format["<t font='puristaBold' size='0.8' color='%1'>", _ColorStr];
  _Str = _Str + format["<t align='left'>GuidedMissiles:</t><t align='right'>%1</t>", G_UAV_MissileCount];
  _Str = _Str + "</t>";
  (G_UAV_aCtrl select 29) ctrlSetStructuredText parsetext _Str; 
};
if(_bRockets) then{
  G_UAV_RocketCount = G_UAV_RocketCount - 1;
  _ColorStr = G_UAV_HUDcolor call BIS_fnc_colorRGBtoHTML;
  _Str = format["<t font='puristaBold' size='0.8' color='%1'>", _ColorStr];
  _Str = _Str + format["<t align='left'>Rockets:</t><t align='right'>%1</t>", G_UAV_RocketCount];
  _Str = _Str + "</t>";
  (G_UAV_aCtrl select 30) ctrlSetStructuredText parsetext _Str; 
};

if(_bFireTV || _bFireRAD || _bRockets) then{ [] spawn Fnc_UAV_AnimFire; };

};
Fnc_UAV_AnimFire = {//spawn
disableserialization;

private["_Mindex"];
if(G_UAV_WepSel == "Missile") then{ _Mindex = 12-G_UAV_MissileCount; };
if(G_UAV_WepSel ==  "Rocket") then{ _Mindex = 18- G_UAV_RocketCount; };

if((G_UAV_WepSel == "Missile") && !(_Mindex in [11,12]) ) exitwith{};
if((G_UAV_WepSel ==  "Rocket") && !(_Mindex in [13,14,15,16,17,18]) ) exitwith{};

private["_Disp", "_Ctrl"];
_Disp = uiNamespace getVariable "RscUAVDisp"; 
_Ctrl = G_UAV_aCtrl select _Mindex;

_bAnim = (G_UAV_WepSel == "Missile") && (G_UAV_GuideMode == "RAD");
_bAnim = _bAnim || (G_UAV_WepSel == "Rocket");
if(_bAnim) then{
private["_aPos", "_StartY", "_nSteps", "_iStep", "_nCount"];
_aPos = ctrlPosition _Ctrl;
_StartY = _aPos select 1;
_FinalY = (_aPos select 1) - (_aPos select 3)*0.60;
_nSteps = 8;
_iStep = -1*(abs(_FinalY - _StartY))/_nSteps;
_nCount = 0;

while{true} do{
ScopeName "MoveLoop";
_nCount = _nCount + 1;
if(_nCount >= _nSteps) then{ breakOut "MoveLoop"; };

_PosY = _StartY + _nCount*_iStep;
_aPos set [1, _PosY];

_Ctrl ctrlSetPosition _aPos; 
_Ctrl ctrlCommit 0; 

sleep 0.043;
};
};

_Ctrl CtrlShow false;
};
Fnc_UAV_FireMisileTV = {//spawn
disableserialization;

private["_VDir", "_VUp"];
_VDir = vectorDir G_UAV_Cam;
_VUp  = vectorUp  G_UAV_Cam;

G_UAV_Missile = createVehicle [G_UAV_GuidedMissile, (G_UAV_Cam modeltoworld [0,0,-2]), [], 0, "CAN_COLLIDE"];
G_UAV_Missile setVectorDirAndUp [_VDir, _VUp];
G_UAV_Missile setVelocity (_VDir vectorMultiply 10);
G_UAV_Missile setShotParents [player, player];

101 cutRsc ["RscStatic", "PLAIN"];
sleep 0.20;

if(false)then{//deleteme
setCamShakeParams [0, 0, 1.5, 0, false]; 
addCamShake[12,1.66,44];
sleep 1.66;
setCamShakeParams [0.1, 1, 1, 1, true];
};

_ppRFx = ppEffectCreate ["filmGrain", 2600];
_ppRFx ppEffectEnable true;
_ppRFx ppEffectAdjust [1,0,2,1,1,0]; 
_ppRFx ppEffectCommit 0;
sleep 0.150;
ppEffectDestroy _ppRFx; 

G_UAV_bHaveGUI = false;
{ _x CtrlShow false; }foreach G_UAV_aCtrl;
{ ((uiNamespace getVariable "RscUAVDisp") displayCtrl _x) CtrlShow false; }foreach G_UAV_aRADARidc;
G_UAV_Cam cameraEffect ["TERMINATE","BACK"];

_Offset = [0,-3.20,1];
G_UAV_Missilecam = "camera" camCreate (G_UAV_Missile modeltoworld _Offset);
G_UAV_Missilecam cameraEffect ["External", "BACK"];
G_UAV_Missilecam camSetFOV 0.50;
G_UAV_Missilecam camSetTarget G_UAV_Missile;
G_UAV_Missilecam camCommit 0;
G_UAV_Missilecam attachTo [G_UAV_Missile, _Offset];
if((daytime > 6.5) && (daytime < 18.5)) then{ camUseNVG false; } else{ camUseNVG true; };

[] call Fnc_UAV_SetMissileCtrl;

waitUntil{!(alive G_UAV_Missile) || !(alive player) || !(alive G_UAV)};

(findDisplay 46) displayRemoveEventHandler ["MouseMoving", G_UAV_CtrlMissileID];
[] call Fnc_UAV_SetCamCtrl;
[] call Fnc_UAV_EnableESC;
[] call Fnc_UAV_SetCmdKeys;

G_UAV_Missilecam cameraEffect ["TERMINATE","BACK"];
//G_UAV_OpCam cameraEffect ["External", "BACK", "OpUAVPiP"];
G_UAV_Cam cameraEffect ["External", "BACK"];
showCinemaBorder false;
cameraEffectEnableHUD true;

G_UAV_bHaveGUI = true;
{ _x CtrlShow true; }foreach G_UAV_aCtrl;
{ ((uiNamespace getVariable "RscUAVDisp") displayCtrl _x) CtrlShow true; }foreach G_UAV_aRADARidc;
[] call Fnc_UAV_UpdtWepStatus;
};
Fnc_UAV_FireMisileDIR = {//spawn
private["_Target", "_nMissile"];
_Target   = _this select 0;
_nMissile = _this select 1;

_VDir = vectorDir G_UAV_Cam;
private _MaxSpd = 180 max ((vectorMagnitude (velocity _Target))*2);//in m/s
private _IniSpd = 1;//in m/s

_Yaw = (_VDir select 0) atan2 (_VDir select 1);
_Yaw = [_Yaw, (360 + _Yaw)] select (_Yaw < 0);

private _Missile = createVehicle [G_UAV_GuidedMissile, (G_UAV_Cam modeltoworld [0,0,-2]), [], 0, "CAN_COLLIDE"];
_Missile setVectorDirAndUp [[sin _Yaw, cos _Yaw, 0], [0,0,1]];
_Missile setVelocity (_VDir vectorMultiply _IniSpd);
_Missile setShotParents [player, player];

101 cutRsc ["RscStatic", "PLAIN"];

private _InitPos = getPosWorld _Missile;//go straight
waitUntil{
_Dist = _InitPos vectorDistance (getPosWorld _Missile);
if(_Dist > 25) exitwith{true};

_Spd = linearConversion[0,25,_Dist,_IniSpd,_MaxSpd,true];
_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _Spd);

false
};

private _Stime = time;//yawToLeft +30deg or -30deg;
private _dt = 0.30;
private _iDir = getDir _Missile;
private _degYaw = [30, -30] select ((_nMissile mod 2) == 0);
waitUntil{
if((time -_Stime) > _dt) exitwith{true};

_Dir = linearConversion[0,_dt,(time -_Stime),_iDir,(_iDir+_degYaw),true];
_Missile setDir _Dir;

_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _MaxSpd);

false
};

_Stime = time;//yawToTarget
_dt = 0.30;
_iDir = getDir _Missile;
waitUntil{
if((time -_Stime) > _dt) exitwith{true};

_Dir = linearConversion[0,_dt,(time -_Stime),_iDir,(_Missile getDir _Target),true];
_Missile setDir _Dir;

_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _MaxSpd);

false
};

_Stime = time;//PitchToTarget
_dt = 0.30;
_iDir = (_Missile call BIS_fnc_getPitchBank) select 0;//pitch
waitUntil{
if((time -_Stime) > _dt) exitwith{true};

_PosM = getPosWorld _Missile;
_PosT = getPosWorld _Target;
_Dist = _PosM VectorDistance _PosT;
_dh = (_PosT select 2) - (_PosM select 2);

_Pitch = linearConversion[0,_dt,(time -_Stime),_iDir,(aSin (_dh/_Dist)),true];
[_Missile, _Pitch, 0] call BIS_fnc_setPitchBank;

_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _MaxSpd);

false
};

waitUntil{
if(!(alive _Missile)) exitwith{true};

_PosM = getPosWorld _Missile;
_PosT = getPosWorld _Target;
_Dist = _PosM VectorDistance _PosT;

_VDir = _PosM vectorFromTo _PosT;
_VUp = (vectorNormalized (_VDir vectorCrossProduct [0,0,1])) vectorCrossProduct _VDir;
_Missile setVectorDirAndUp[_VDir, _VUp]; 

_Missile setVelocity (_VDir vectorMultiply _MaxSpd);

false
};

};
Fnc_UAV_FireMisileTOP = {//spawn
private _Target   = _this select 0;

_VDir = vectorDir G_UAV_Cam;
private _MaxSpd = 180 max ((vectorMagnitude (velocity _Target))*2);//in m/s
private _IniSpd = 1;//in m/s

_Yaw = (_VDir select 0) atan2 (_VDir select 1);
_Yaw = [_Yaw, (360 + _Yaw)] select (_Yaw < 0);

private _Missile = createVehicle [G_UAV_GuidedMissile, (G_UAV_Cam modeltoworld [0,0,-2]), [], 0, "CAN_COLLIDE"];
_Missile setVectorDirAndUp [[sin _Yaw, cos _Yaw, 0], [0,0,1]];
_Missile setVelocity (_VDir vectorMultiply _IniSpd);
_Missile setShotParents [player, player];

101 cutRsc ["RscStatic", "PLAIN"];

private _InitPos = getPosWorld _Missile;//go straight
waitUntil{
_Dist = _InitPos vectorDistance (getPosWorld _Missile);
if(_Dist > 25) exitwith{true};

_Spd = linearConversion[0,25,_Dist,_IniSpd,_MaxSpd,true];
_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _Spd);

false
};

private _Stime = time;//Pitch Up
private _dt = 0.30;
waitUntil{
if((time -_Stime) > _dt) exitwith{true};

_Pitch = linearConversion[0,_dt,(time -_Stime),0,90,true];
[_Missile, _Pitch, 0] call BIS_fnc_setPitchBank;

_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _MaxSpd);

false
};

private _nInitial = (getPosATL _Missile) select 2;//goUp
waitUntil{
_Height = (getPosATL _Missile) select 2;
if((abs(_Height - _nInitial)) >= 80) exitwith{true};

_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _MaxSpd);

false
};

_Stime = time;//PitchToTarget
_dt = 0.30;
_nInitial = (_Missile call BIS_fnc_getPitchBank) select 0;//pitch
waitUntil{
if((time -_Stime) > _dt) exitwith{true};

_PosM = getPosWorld _Missile;
_PosT = getPosWorld _Target;
_Dist = _PosM VectorDistance _PosT;
_dh = (_PosT select 2) - (_PosM select 2);

_Pitch = linearConversion[0,_dt,(time -_Stime),_nInitial,(aSin (_dh/_Dist)),true];
[_Missile, _Pitch, 0] call BIS_fnc_setPitchBank;

_Missile setvelocity ((vectorDirVisual _Missile) vectorMultiply _MaxSpd);

false
};

waitUntil{
if(!(alive _Missile)) exitwith{true};

_PosM = getPosWorld _Missile;
_PosT = getPosWorld _Target;
_Dist = _PosM VectorDistance _PosT;

_Missile setDir (_PosM getDir _PosT);

_dh = (_PosT select 2) - (_PosM select 2);
_Pitch = aSin (_dh/_Dist);
[_Missile, _Pitch, 0] call BIS_fnc_setPitchBank;

_Missile setVelocity ((vectorDirVisual _Missile) vectorMultiply _MaxSpd);

false
};

};
Fnc_UAV_FireRocket = {//spawn
private["_VDir", "_VUp"];
_VDir = vectorDir G_UAV_Cam;
_VUp  = vectorUp  G_UAV_Cam;

_m = createVehicle [G_UAV_UnguidedMissile, (G_UAV_Cam modeltoworld [0,0,-1]), [], 0, "CAN_COLLIDE"];
_m setVectorDirAndUp [_VDir, _VUp];
_m setVelocity (_VDir vectorMultiply 200);
_m setShotParents [player, player];
};

Fnc_UAV_AnimStatus = {//call

if(G_UAV_WepSel == "Rocket") then{
  (G_UAV_aCtrl select 23) ctrlSetText "images\UAV\wep2sel.paa"; 

  (G_UAV_aCtrl select 19) ctrlSetText "images\UAV\radaroff.paa"; 
  (G_UAV_aCtrl select 20) ctrlSetText "images\UAV\tvoff.paa"; 
  (G_UAV_aCtrl select 21) ctrlSetText "images\UAV\diroff.paa"; 
  (G_UAV_aCtrl select 22) ctrlSetText "images\UAV\topoff.paa"; 
};

if(G_UAV_WepSel == "Missile") then{
  (G_UAV_aCtrl select 23) ctrlSetText "images\UAV\wep1sel.paa"; 

  if(G_UAV_GuideMode == "TV") then{
    (G_UAV_aCtrl select 19) ctrlSetText "images\UAV\radaroff.paa"; 
    (G_UAV_aCtrl select 20) ctrlSetText "images\UAV\tvon.paa"; 
    (G_UAV_aCtrl select 21) ctrlSetText "images\UAV\diroff.paa"; 
    (G_UAV_aCtrl select 22) ctrlSetText "images\UAV\topoff.paa"; 
  };

  if(G_UAV_GuideMode == "RAD") then{
    (G_UAV_aCtrl select 19) ctrlSetText "images\UAV\radaron.paa"; 
    (G_UAV_aCtrl select 20) ctrlSetText "images\UAV\tvoff.paa"; 

    if(G_UAV_FlyMode == "DIR") then{
      (G_UAV_aCtrl select 21) ctrlSetText "images\UAV\diron.paa"; 
      (G_UAV_aCtrl select 22) ctrlSetText "images\UAV\topoff.paa"; 
    };
    if(G_UAV_FlyMode == "TOP") then{
      (G_UAV_aCtrl select 21) ctrlSetText "images\UAV\diroff.paa"; 
      (G_UAV_aCtrl select 22) ctrlSetText "images\UAV\topon.paa"; 
    };
  };
};

};
Fnc_UAV_UpdtWepStatus = {//call
if(G_UAV_MissileCount < 2) then{
{//foreach ctrl
ScopeName "HideLoop";
_bHide = (_foreachIndex+1) <= (2-G_UAV_MissileCount);
if(_bHide) then{ (G_UAV_aCtrl select _x) CtrlShow false; } else{ breakOut "HideLoop"; };
}foreach [11,12];
};
if(G_UAV_RocketCount < 6) then{
{//foreach ctrl
ScopeName "HideLoop";
_bHide = (_foreachIndex+1) <= (6-G_UAV_RocketCount);
if(_bHide) then{ (G_UAV_aCtrl select _x) CtrlShow false; } else{ breakOut "HideLoop"; };
}foreach [13,14,15,16,17,18];
};
};
Fnc_UAV_AnimHUDcolor = {//call
private _Color = +G_UAV_HUDcolor; _Color pushback 1;
{ (G_UAV_aCtrl select _x) ctrlSetTextColor _Color; }foreach[0,1,5,6,9,10,23];

_ColorStr = G_UAV_HUDcolor call BIS_fnc_colorRGBtoHTML;
_Str = format["<t font='puristaBold' size='0.8' color='%1'>", _ColorStr];
_Str = _Str + format["<t align='left'>GuidedMissiles:</t><t align='right'>%1</t>", G_UAV_MissileCount];
_Str = _Str + "</t>";
(G_UAV_aCtrl select 29) ctrlSetStructuredText parsetext _Str; 

_Str = format["<t font='puristaBold' size='0.8' color='%1'>", _ColorStr];
_Str = _Str + format["<t align='left'>Rockets:</t><t align='right'>%1</t>", G_UAV_RocketCount];
_Str = _Str + "</t>";
(G_UAV_aCtrl select 30) ctrlSetStructuredText parsetext _Str; 

_Str = format["<t font='puristaLight' size='0.8' align='center' color='%1'>Operator Map</t>", _ColorStr];
(G_UAV_aCtrl select 38) ctrlSetStructuredText parsetext _Str; 

_Str = format["<t font='puristaLight' size='0.8' align='center' color='%1'>Operator View</t>", _ColorStr];
(G_UAV_aCtrl select 39) ctrlSetStructuredText parsetext _Str; 

(G_UAV_aCtrl select 31) ctrlSetText (_Color call BIS_fnc_colorRGBAtoTexture);//IntegrityBarBG
(G_UAV_aCtrl select 33) ctrlSetText (_Color call BIS_fnc_colorRGBAtoTexture);//fuelBarBG

};
Fnc_UAV_ToggleFlir = {//call

if(G_UAV_FlirMode == "OFF") then{
G_UAV_FlirMode = "WHITE";
(G_UAV_aCtrl select 25) ctrlSetText "images\UAV\whiteon.paa"; 
true setCamUseTI 0;
} else{
if(G_UAV_FlirMode == "WHITE") then{
G_UAV_FlirMode = "BLACK";
(G_UAV_aCtrl select 26) ctrlSetText "images\UAV\blackon.paa"; 
(G_UAV_aCtrl select 25) ctrlSetText "images\UAV\whiteoff.paa"; 
false setCamUseTI 0;
true setCamUseTI 1;
} else{
if(G_UAV_FlirMode == "BLACK") then{
G_UAV_FlirMode = "THERMAL";
(G_UAV_aCtrl select 24) ctrlSetText "images\UAV\thermalon.paa"; 
(G_UAV_aCtrl select 26) ctrlSetText "images\UAV\blackoff.paa"; 
false setCamUseTI 0;
false setCamUseTI 1;
true setCamUseTI 7;
} else{
if(G_UAV_FlirMode == "THERMAL") then{
G_UAV_FlirMode = "OFF";
(G_UAV_aCtrl select 24) ctrlSetText "images\UAV\thermaloff.paa"; 
(G_UAV_aCtrl select 25) ctrlSetText "images\UAV\whiteoff.paa"; 
(G_UAV_aCtrl select 26) ctrlSetText "images\UAV\blackoff.paa"; 
false setCamUseTI 0;
false setCamUseTI 1;
false setCamUseTI 7;
};
};
};
};

};
Fnc_UAV_ToggleNV = {//call
if(G_UAV_NV == "OFF") then{
G_UAV_NV = "ON";
(G_UAV_aCtrl select 27) ctrlSetText "images\UAV\nighton.paa"; 
camUseNVG true;
} else{
G_UAV_NV = "OFF";
(G_UAV_aCtrl select 27) ctrlSetText "images\UAV\nightoff.paa"; 
camUseNVG false;
};
};
Fnc_UAV_DrawControls = {//call
disableSerialization; 
//----------------------------------------------------------
("UAVLayer" call BIS_fnc_rscLayer) cutRsc ["RscUAVDisp", "PLAIN", -1, false]; 
_Disp = uiNamespace getVariable "RscUAVDisp"; 
//----------------------------------------------------------
_IDC = 1200;
//----------------------------------------------------------
_IDC = _IDC+1;//1201
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.487898 * safezoneW + safezoneX;
_Py = 0.468056 * safezoneH + safezoneY;
_Pw = 0.0434587 * safezoneW;
_Ph = 0.0794423 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\crosshairs.paa"; 
_Ctrl ctrlSetTextColor [1, 1, 1, 1]; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//1202
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.224792 * safezoneW + safezoneX;
_Py = 0.01108 * safezoneH + safezoneY;
_Pw = 0.570476 * safezoneW;
_Ph = 0.987775 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\grid.paa"; 
_Ctrl ctrlSetTextColor [1, 1, 1, 1]; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//leftpanelBG 1203
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = -0.00242227 * safezoneW + safezoneX;
_Py = -0.00416655 * safezoneH + safezoneY;
_Pw = 0.227721 * safezoneW;
_Ph = 1.00861 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(0,0,0,0.3)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//rightPanelBG 1204
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.795965 * safezoneW + safezoneX;
_Py = -0.0207777 * safezoneH + safezoneY;
_Pw = 0.201956 * safezoneW;
_Ph = 1.01278 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(0,0,0,0.3)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//1205
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.798176 * safezoneW + safezoneX;
_Py = 0.635333 * safezoneH + safezoneY;
_Pw = 0.20508 * safezoneW;
_Ph = 0.351666 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\keycmd.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//OP MAP BG 1206
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.799945 * safezoneW + safezoneX;
_Py = 0.00894443 * safezoneH + safezoneY;
_Pw = 0.194929 * safezoneW;
_Ph = 0.301667 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(1,1,1,1)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//OP PIP BG 07
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.801766 * safezoneW + safezoneX;
_Py = 0.322222 * safezoneH + safezoneY;
_Pw = 0.194929 * safezoneW;
_Ph = 0.301667 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(1,1,1,1)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//OP MAP 08
_Ctrl = _Disp ctrlCreate ["PiPUIMap", _IDC]; 

_Px = 0.802547 * safezoneW + safezoneX;
_Py = 0.0125002 * safezoneH + safezoneY;
_Pw = 0.190244 * safezoneW;
_Ph = 0.293334 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;

_PPos = (getPosWorld player) vectorAdd ([sin 116.533, cos 116.533, 0] vectorMultiply 1150);

ctrlMapAnimClear _Ctrl;
_Ctrl ctrlMapAnimAdd [0, 1, _PPos];
_Ctrl ctrlMapAnimAdd [2, 0.2, _PPos];
ctrlMapAnimCommit _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//PIP 09
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.804108 * safezoneW + safezoneX;
_Py = 0.325 * safezoneH + safezoneY;
_Pw = 0.190244 * safezoneW;
_Ph = 0.293334 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

//_Ctrl ctrlSetText "#(argb,512,512,1)r2t(OpUAVPiP,1.0)"; 
_Ctrl ctrlSetText "#(argb,8,8,3)color(0,0,0,1)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//1205 10
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.00382359 * safezoneW + safezoneX;
_Py = 0.089788 * safezoneH + safezoneY;
_Pw = 0.215229 * safezoneW;
_Ph = 0.426668 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\mainstatus.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//11
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Pw = safezoneW*(7/32);
_Ph = _Pw*(safezoneW/safezoneH);
_Px = safezoneX;
_Py = (1-safezoneY)-_Ph;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\radar.paa"; 

G_UAV_aCtrl pushback _Ctrl;

_aPos = CtrlPosition (G_UAV_aCtrl select 10);
G_UAV_RADAR_Center = [((_aPos select 0)+(_aPos select 2)/2), ((_aPos select 1)+(_aPos select 3)/2), 0];
G_UAV_RADAR_Rad    = (_aPos select 2)/2;
//----------------------------------------------------------
_IDC = _IDC+1;//missile 1  12
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.0647226 * safezoneW + safezoneX;
_Py = 0.245967 * safezoneH + safezoneY;
_Pw = 0.0590758 * safezoneW;
_Ph = 0.0919445 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile1.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//missile 2  13
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.1022 * safezoneW + safezoneX;
_Py = 0.242567 * safezoneH + safezoneY;
_Pw = 0.0590758 * safezoneW;
_Ph = 0.0919445 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile1.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//rocket 1  14
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.0272463 * safezoneW + safezoneX;
_Py = 0.226666 * safezoneH + safezoneY;
_Pw = 0.0645411 * safezoneW;
_Ph = 0.0780556 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile2.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//rocket 2  15
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.135772 * safezoneW + safezoneX;
_Py = 0.223267 * safezoneH + safezoneY;
_Pw = 0.0645411 * safezoneW;
_Ph = 0.0780556 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile2.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//rocket 3  16
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.149827 * safezoneW + safezoneX;
_Py = 0.232222 * safezoneH + safezoneY;
_Pw = 0.0645411 * safezoneW;
_Ph = 0.0780556 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile2.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//rocket 4  17
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.0116311 * safezoneW + safezoneX;
_Py = 0.235622 * safezoneH + safezoneY;
_Pw = 0.0645411 * safezoneW;
_Ph = 0.0780556 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile2.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//rocket 5  18
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = -0.00398419 * safezoneW + safezoneX;
_Py = 0.245966 * safezoneH + safezoneY;
_Pw = 0.0645411 * safezoneW;
_Ph = 0.0780556 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile2.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//rocket 6  19
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.163099 * safezoneW + safezoneX;
_Py = 0.242567 * safezoneH + safezoneY;
_Pw = 0.0645411 * safezoneW;
_Ph = 0.0780556 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\missile2.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//guidemode rad 20
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.0576959 * safezoneW + safezoneX;
_Py = 0.155211 * safezoneH + safezoneY;
_Pw = 0.0348721 * safezoneW;
_Ph = 0.0586112 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\radaroff.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//guidemode tv 21
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.0170964 * safezoneW + safezoneX;
_Py = 0.155211 * safezoneH + safezoneY;
_Pw = 0.0348721 * safezoneW;
_Ph = 0.0586112 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\tvon.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//flymode dir 22
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.171688 * safezoneW + safezoneX;
_Py = 0.151189 * safezoneH + safezoneY;
_Pw = 0.0348721 * safezoneW;
_Ph = 0.0586112 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\diroff.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//flymode top 23
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.128745 * safezoneW + safezoneX;
_Py = 0.151189 * safezoneH + safezoneY;
_Pw = 0.0348721 * safezoneW;
_Ph = 0.0586112 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\topoff.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//wepsel 1 24
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.00538445 * safezoneW + safezoneX;
_Py = -0.406945 * safezoneH + safezoneY;
_Pw = 0.213667 * safezoneW;
_Ph = 0.493334 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\wep1sel.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//termal 25
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.684652 * safezoneW + safezoneX;
_Py = 0.681945 * safezoneH + safezoneY;
_Pw = 0.0957724 * safezoneW;
_Ph = 0.18639 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\thermaloff.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//white 26
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.685432 * safezoneW + safezoneX;
_Py = 0.704167 * safezoneH + safezoneY;
_Pw = 0.0957724 * safezoneW;
_Ph = 0.18639 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\whiteoff.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//black 27
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.685432 * safezoneW + safezoneX;
_Py = 0.726389 * safezoneH + safezoneY;
_Pw = 0.0957724 * safezoneW;
_Ph = 0.18639 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\blackoff.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//night 28
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.685432 * safezoneW + safezoneX;
_Py = 0.75 * safezoneH + safezoneY;
_Pw = 0.0957724 * safezoneW;
_Ph = 0.18639 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "images\UAV\nightoff.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//targetInfo 29
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Ctrl ctrlSetBackgroundColor [0,0,0,0.25]; 

_Px = 0.23493 * safezoneW + safezoneX;
_Py = 0.762501 * safezoneH + safezoneY;
_Pw = 0.126222 * safezoneW;
_Ph = 0.214166 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//wep1txt 30
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Str = "<t font='puristaBold' size='0.8'>";
_Str = _Str + format["<t align='left'>GuidedMissiles:</t><t align='right'>%1</t>", G_UAV_MissileCount];
_Str = _Str + "</t>";
_Ctrl ctrlSetStructuredText parsetext _Str; 

_Px = 0.0319313 * safezoneW + safezoneX;
_Py = 0.0208332 * safezoneH + safezoneY;
_Pw = 0.177751 * safezoneW;
_Ph = 0.0238885 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//wep2txt 31
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Str = "<t font='puristaLight' size='0.8'>";
_Str = _Str + format["<t align='left'>Rockets:</t><t align='right'>%1</t>", G_UAV_RocketCount];
_Str = _Str + "</t>";
_Ctrl ctrlSetStructuredText parsetext _Str; 

_Px = 0.0311498 * safezoneW + safezoneX;
_Py = 0.0513889 * safezoneH + safezoneY;
_Pw = 0.177751 * safezoneW;
_Ph = 0.0238885 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//IntegrityBarBG 32
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.0670656 * safezoneW + safezoneX;
_Py = 0.102777 * safezoneH + safezoneY;
_Pw = 0.14574 * safezoneW;
_Ph = 0.016944 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(1,1,1,1)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//IntegrityBartxt 33
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Str = "<t font='puristaLight' size='0.8' align='center' color='#000000'>100%</t>";
_Ctrl ctrlSetStructuredText parsetext _Str; 

_Px = 0.0670656 * safezoneW + safezoneX;
_Py = 0.095 * safezoneH + safezoneY;
_Pw = 0.14574 * safezoneW;
_Ph = 0.042 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//fuelBarBG 34
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.0498885 * safezoneW + safezoneX;
_Py = 0.473611 * safezoneH + safezoneY;
_Pw = 0.161356 * safezoneW;
_Ph = 0.0155552 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(1,1,1,1)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//fuelBartxt 35
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Str = "<t font='puristaLight' size='0.8' align='center' color='#000000'>100%</t>";
_Ctrl ctrlSetStructuredText parsetext _Str; 

_Px = 0.0498885 * safezoneW + safezoneX;
_Py = 0.464 * safezoneH + safezoneY;
_Pw = 0.161356 * safezoneW;
_Ph = 0.042 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//flytime 36
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Str = "<t font='puristaLight' size='0.8' align='center' color='#ffffff'>00:00:00</t>";
_Ctrl ctrlSetStructuredText parsetext _Str; 

_Px = 0.113131 * safezoneW + safezoneX;
_Py = 0.4886 * safezoneH + safezoneY;
_Pw = 0.0973332 * safezoneW;
_Ph = 0.0211107 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//pipNameBG
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.805669 * safezoneW + safezoneX;
_Py = 0.329166 * safezoneH + safezoneY;
_Pw = 0.185559 * safezoneW;
_Ph = 0.0350006 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(0,0,0,0.33)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//mapnameBG
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_Px = 0.804108 * safezoneW + safezoneX;
_Py = 0.0166667 * safezoneH + safezoneY;
_Pw = 0.185559 * safezoneW;
_Ph = 0.0350006 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 

_Ctrl ctrlSetText "#(argb,8,8,3)color(0,0,0,0.33)"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//mapnametxt 39
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Str = "<t font='puristaLight' size='0.8' align='center' color='#ffffff'>Operator Map</t>";
_Ctrl ctrlSetStructuredText parsetext _Str; 

_Px = 0.804108 * safezoneW + safezoneX;
_Py = 0.0166667 * safezoneH + safezoneY;
_Pw = 0.185559 * safezoneW;
_Ph = 0.0350006 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//pipNametxt 40
_Ctrl = _Disp ctrlCreate ["RscStructuredText", _IDC]; 
_Str = "<t font='puristaLight' size='0.8' align='center' color='#ffffff'>Operator View</t>";
_Ctrl ctrlSetStructuredText parsetext _Str; 

_Px = 0.805669 * safezoneW + safezoneX;
_Py = 0.329166 * safezoneH + safezoneY;
_Pw = 0.185559 * safezoneW;
_Ph = 0.0350006 * safezoneH;
_Ctrl ctrlSetPosition [_Px, _Py, _Pw, _Ph]; 
_Ctrl ctrlCommit 0; 
G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
_IDC = _IDC+1;//UAV RADAR 41
_Ctrl = _Disp ctrlCreate ["RscPicture", _IDC]; 

_dimX = G_UAV_RADAR_Rad*0.33;
_dimY = _dimX*(safeZoneW/safeZoneH);
_Px = (G_UAV_RADAR_Center select 0)-(0.50*_dimX);
_Py = (G_UAV_RADAR_Center select 1)-(0.50*_dimY);
_Ctrl ctrlSetAngle [((getDir G_UAV)-(getDir G_UAV_Cam)), 0.5, 0.5, false]; 
_Ctrl ctrlSetPosition [_Px, _Py, _dimX, _dimY]; 
_Ctrl ctrlCommit 0;

_Ctrl ctrlSetText "images\UAV\radar2.paa"; 

G_UAV_aCtrl pushback _Ctrl;
//----------------------------------------------------------
G_UAV_bHaveGUI = true;
//----------------------------------------------------------
};
Fnc_UAV_DisableESC = {//call
G_UAV_NoESC = (findDisplay 46) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then{ true }"]; 
};
Fnc_UAV_EnableESC = {//call
(findDisplay 46) displayRemoveEventHandler ["KeyDown", G_UAV_NoESC];
};

