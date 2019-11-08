To Include in your mission:

1) copy both Fnc_LoadFnc_UAV.sqf and images(entire folder) to your mission root folder
2) Inside your description.ext add class RscUAVDisp to your RscTitles, e.g.
  class RscTitles {
    class RscUAVDisp{
      idd = 6969;
      access = 0;
      duration = 1e+011;
      fadeIn = 0;
      fadeOut = 0;
      movingEnable = false;
      enableSimulation = true;

      onLoad = "uiNamespace setVariable ['RscUAVDisp',_this select 0]";
    };
  };
3)In your mission initPlayerLocal.sqf add:
  [] ExecVm "Scripts\UAV\Fnc_LoadFnc_UAV.sqf";
  player addaction ["UAV calldown", Fnc_UAV_Init, [], -100, false, true]; 