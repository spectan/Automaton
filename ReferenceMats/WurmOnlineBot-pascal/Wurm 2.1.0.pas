program Wurm;
{$i SRL/SRL.simba}
{$i SRL/SRL/misc/Debug.simba}
var
  Width,Height,Failures,Actions,WaitAfterClick : integer;
  MoveSideToSide,MoveForward,ImprovingItems : boolean;
const
  Tool_Lump = 0;
  Tool_Water = 1;
  Tool_Hammer = 2;
  Tool_Mallet = 3;
  Tool_Log = 4;
  Tool_Pelt = 5;
  Tool_File = 6;
  Tool_CarvingKnife = 7;
  Tool_Whetstone = 8;
  Tool_RockShards = 9;
  Item_Spindle = 0;
  Item_LargeShield = 1;
  Item_LongSpear = 2;
  Item_ShortBow = 3;
  Item_LongBow = 4;
  Item_UnfinishedBow = 5;
  Item_UnfinishedShortBow = 6;
  Item_HuntingArrow = 7;
  Item_WarArrow = 8;
  Item_UnfinishedHuntingArrow = 9;
  Item_Mallet = 10;
  Item_PracticeDoll = 11;
  Item_UnfinishedSpindle = 12;
  Item_Saw = 13;
  Item_GrindStone = 14;
  Item_UnfinishedGrindStone = 15;
  Item_StoneMineDoor = 16;
  QuestionMark = 17;
  Item_RopeTool = 18;
  Item_SmallBarrel = 19;
  Item_Ball = 20;
  Item_Clay = 21;
procedure ClickScreen;
begin
  Mouse(Width/2,Height/2,15,15,false);
end;
procedure MoveForwardOneTile;
begin
  KeyDown(87);
  wait(1000+random(1000));
  KeyUp(87);
end;
procedure TurnRight;
begin
  KeyDown(69);
  wait(750);
  KeyUp(69);
end;
procedure TurnLeft;
begin
  KeyDown(81);
  wait(750);
  KeyUp(81);
end;
function ClickSend : boolean;
var
  SendOption,X,Y : integer;
begin
  SendOption := BitmapFromString(33, 8, 'meJytkcsNACAIQ52QQVjDdRiEsTx' +
        'pKiB+Ym8ayqOgqiJSuwqoPgmNzExECgjT9o1yhUAX5gqTjmeOwMpw' +
        'Kt/E/Bh7iPCVZdYhdItY2c9zrRDhir4vKjkl9vEzJ+duLmszBg==');
  If (FindBitmapIn(SendOption,X,Y,0,0,Width-1,Height-1)) Then
  begin
    SendKeys('3',0);
    Mouse(X+10,Y+5,0,0,true);
    writeln(inttostr(x) + ' ' + inttostr(y));
    result := true;
  end
  else
  begin
    writeln('could not find send');
    result := false;
  end;
  FreeBitmap(SendOption);
end;
procedure WaitForHalfFavor;
var
FavorBar,x,y : integer;
begin
  FavorBar := BitmapFromString(81, 11, 'meJzlVkt2wzAIrGP3krJ1u8pK1u' +
        'k1klOk96g+CAawu82ifixsxQwMAzgfH//xui5bsTxv/ebMMt7P3db' +
        '9Mmxey8ltibdPsusSx/uRXa4eZNn2eesgqVpgtP5rc4+5Wj3ZxVb0' +
        'StOwck+HPTEEr1Yo/3w/ye5PueeTuzu/i720HSAYxyN8DfJodgD4c' +
        'uGOHB8GwZuo7IRQOs7rrjXlk1bVkEDrPxvDngyQZhOKxYH4zQ1zSD' +
        'qTrvXXRNYRSGudfKGcMfqsXkjHRvnkShCiO8p2NFoN+wsSDpGRsmb' +
        'N/anqzz8JjmEdki5Rb2xfQMPXjAwBEmvrWEgxxzHUnnWrFfC13JG+' +
        'KFXdxyNNtG8A7RuSo1Mom3CesslEythWTXa16jrSHls05cXuvYOqu' +
        'lik+EzufSnxpOQBy4qzr7QKlKJSdrwgH9NpQVGegs6cl21njXs74t' +
        '7OIzE1lSiQEA8JYnXYDDiDctvqzBo6HIe6QxXKFOhMaDNfk10RWqD' +
        'A7a2GenQ4pioTAdN6xnoIveahNSrbHiN97wBH8oTMifLlpOaykBVZ' +
        'xtkd5aQomw80fo6jXZi227VAFzWYfs3WakgRrFiY+fv+Ab3t+gXZn0kf');
  repeat
    if FindBitmapToleranceIn(FavorBar,x,y,0,0,Width-1,Height-1,85) then
    begin
      FreeBitmap(FavorBar);
      Exit;
    end
    else
    begin
      writeln('waiting for half favor');
      wait(500);
    end;
  until(false);
end;
procedure WaitForEnergy;
var
EnergyBar,x,y : integer;
begin
  EnergyBar := BitmapFromString(161, 11, 'meJztmFtyozAQRbPG2ICEIMvKw' +
        'zY4+4mdLUwyK5l+dwtwZuY3FdctypEFqHV0W63c3f18vv8nzQOpdB' +
        'OoJ5VuLtqO6vhXuIbGdB7zeexBr6iMfw6o1yGhRuiQztBt2L90u+c' +
        'WrqDmkNpjTlPJM9+C8jGwphLGAFfoLArjxC+pHmcIREbbnYPmgVuS' +
        'SIZX3c4hwKggotcHjOJ15Nv1llFDc7WnHtQccwORPjZ7ChYixcCf2' +
        't1To2qblwTdpDN1gGtzTO0pt9Ke5Cox4pWen/ELqm9tonSKoD89Nu' +
        'Nj4Qv0oacx4uvvK+mdv1w+g+Qn/GItF+z5ztd/19vHhXX5kEdtdQs' +
        'v+tzsJuO5xg6fV29f/coDNv3XmBf6+nZ818fVwnyz778uofFSRffB' +
        't9Sjrf585xmIU1HH5TO2ZEcSF4sXoh2Ke2FTYc0vTJ3ngSW/2so/j' +
        '+hiWLcHWcYd3cL3+i1q0pYFq1ftnCuVJIPpcfw3FOxcop3TLWksko' +
        '7UzontbK6noMDjJvMyGvO5bSjMPTl697hHq5JnG/SsGM0tfEgUJgb' +
        'bnUfsQ0ZG286Fr/BGNj4GcpIMRv0xwZK1JWuheUn8FkbMyTndSnoV' +
        '636ZyZ0g8xpXT/AFAOLYOShMs3zvdqbFF3EClM7zoIl96M+8JIRjT' +
        'bZXFVu9ltZiinPdIF5THteUU6AsoGGST5m3JGDN+ZlScWb6+2fCfU' +
        'zcAdcDp1aNNEBHvqBEiGk2IAOXhggKNd5EZiaO+ZmMM+AiCYh9Tma' +
        '3sy3jTdDtFuUcZbwmkmzooFEQ4yDLxlaI/d2hETRnj2wFAAlftKSM' +
        'seBSPy2WrkTRWoqQQPot3GNYusNi5122G2Iz+zxAjFB+oIsRIiIWp' +
        'ubok7dg40k26LA7k215wGTqoJ5XBY5BqwXuA/eynZuwF/uaj4hnXc' +
        'Dqss6Krmr+i2a2calZkrZQJnUTPgeSVXDxluWXSQN5Ub3hdmbEBa7' +
        'yluK2jaDrBOWU2TVIOTvuubci7SbQTQlfE047TPL9434nPkXinMNj' +
        'lhboL11VgHHhhLVT4qwLz2yklEoxFcOYddcY2ciSzFW+F4ectjIym' +
        'cVBLxztW/MCcV9vzXmKEMfuVNTFNyivQQNiFFELu7M4Gl/hgXDtbd' +
        'txXW/U2/1K6mse2wOpTtFeadwCLS3wIoSo+/I9FNsHdTRhZSOz9Qy' +
        'xUz6KbWXP1WUgFTgnN3IfbtZSextiHKQemmQ2cjibhHrD2XEK6szR' +
        '1fGkeMW1yKUGevKyChAz61Wps1EPEJQa9GSgi4AmyVqa/IRle3Fcv' +
        'ctnhgKj1ppyUKgxbkhmnisQOTc9d3vlSLi1/pwWiHk7S+HQpOKNe5' +
        'JjVNLDIDdWx8MaceBrWfqvlANrOzKfN+zcRzu7MJlvU7b8P3sJV2H' +
        'iPGyFIikjWQANjq5et1Uz+3McsUax0hcQvwats01bQ3NAdjsiS0m7' +
        'g0bdedGwjL7R/x6I06mCkuSsZ2dGycSViyL248NoiH8+3/vzB+7mDXU=');
  repeat
    if FindBitmapToleranceIn(EnergyBar,x,y,0,0,Width-1,Height-1,85) then
    begin
      FreeBitmap(EnergyBar);
      Exit;
    end
    else
    begin
      writeln('waiting for energy');
      wait(500);
    end;
  until(false);
end;
function WaitForActionFinish : boolean;
var
x,y : integer;
message : boolean;
begin
  result := false;
  message := true;
  repeat
  if FindColorTolerance(x,y,5792871,Width/2+15,Height-30,Width/2+20,Height-20,20) then
  begin
    result := true;
    if message then
    begin
      writeln('waiting for action to finish');
      message := false;
    end
    else
    begin
      message := true;
    end;
    wait(500);
  end
  else
  begin
    if result = false then
    begin
      writeln('WaitForActionFinish failed');
    end;
    writeln('action complete');
    WaitForEnergy;
    Exit;
  end;
  until(false);
end;
function GetPileLocation : TPoint;
var
  PileIcon : integer;
begin
  PileIcon := BitmapFromString(15, 6, 'meJz7//9/avWcz1++X7v92C+9xzK' +
        's8f///xDSPKjePaHr7OV7v//8uXbnqXdyJ1Bw5oq9mk45Uxfv3n/s' +
        'ipJFClDE2KcSSOq6V+89ejWvcbFTfFdJ15rz1x6BzAktN/AtMfAs/' +
        'PHzl55HHlDEwKsESJoF1Pz89fs/DADNB5LSxmEiWj7yxgHff/zUcI' +
        'wDiihZRQBJHbc0oGJDz3QtlyQgW987Fyh46MwN7/SuGUu37zx0VsU' +
        'uCSii5ZIDJFVsk46cuT55wWYgt7xj0eVbIGfUTFgGNOHUpdvhhf1u' +
        'KW1AEa/MHiDpmz0xvGDSzQcvfv3+c/fRy4TKWQBjAa4/');
  If not (FindBitmapToleranceIn(PileIcon,result.x,result.y,0,0,Width-1,Height-1,75)) Then
  begin
    //FreeBitmap(PileIcon);
    PileIcon := BitmapFromString(15, 8, 'meJz7/x8BsqsagAjCgHOREbIgLjY' +
        'eBWgmI9uLXzGaLDLAqgWrGvyOweUR/M7AoxjNgwBoqfPZ');
    If not (FindBitmapToleranceIn(PileIcon,result.x,result.y,0,0,Width-1,Height-1,75)) Then
    begin
      writeln('Could not locate pile (GetPileLocation)');
      result.x := 0;
      result.y := 0;
    end;
  end;
  FreeBitmap(PileIcon);
end;
function GetCartLocation : TPoint;
var
  PileIcon : integer;
begin
  PileIcon := BitmapFromString(18, 6, 'meJxLKam8dO3G79+/n754WdXeE5K' +
        'aXdnWfe/R4z9//nz89GnS3IVAkf///89euuLR02cQNhCcPHdh7dYd' +
        'oWk57ZOnP3n+HCgOJOt7JgIZuTWNX799h6hsnTQNqAbCBpJAWyBcO' +
        'EooKFu2ftORU2eA2iFqgCRcDS5dt+8/6Js5t7FvUnpZDVwXXBbCPn' +
        '3x0ooNm4EMoKsgLgSaA3RbTE7RnsNHMXX9/fsvMis/paTyyo1bQL8' +
        'DPVvW0gEUn7Vk+Y+fP4E+mrNsFaYuSNABACwFzpc=');
  If not (FindBitmapToleranceIn(PileIcon,result.x,result.y,0,0,Width-1,Height-1,75)) Then
  begin
    //FreeBitmap(PileIcon);
    PileIcon := BitmapFromString(15, 8, 'meJz7/x8BsqsagAjCgHOREbIgLjY' +
        'eBWgmI9uLXzGaLDLAqgWrGvyOweUR/M7AoxjNgwBoqfPZ');
    If not (FindBitmapToleranceIn(PileIcon,result.x,result.y,0,0,Width-1,Height-1,75)) Then
    begin
      writeln('Could not locate cart');
      result.x := 0;
      result.y := 0;
    end;
  end;
  FreeBitmap(PileIcon);
end;
function GetBinLocation : TPoint;
var
  BinIcon : integer;
begin
  BinIcon := BitmapFromString(58, 8, 'meJydk/0vW2EUx//JWVj8IDEs1Ms' +
        'wQbBRth8sNQ0ybxNUybaYtyBIRKyTGfUy65pWp6peEkLUS1XL3Sc7' +
        '2c3NvdKUmydPTs79nu/zfc75PoqiPMrIib+UfxglAaSsxZW1BJH3X' +
        'YlouK/axJEPUGsqf+XfCfr8gaySCt1ZWp2y11lbJmbntAxkYrHYzc' +
        '3tdnC3qr5BkAKG0L3p4y+7St7eNxDY3SMue13/J7DD39NQyNrZTSb' +
        'zRbl3yx86OwcjDE+Ly1weLxjkoZPk57EJ8n2Dwz/W1uOrfZLzfNax' +
        'oLtvNBodGBolMDc0HRweaRmcP3/Zv4wQsK9uuOQXt0vKNBEH9/dfv' +
        'm0kyK2ovrgMEywsrwj+0+i4kHx3roInAIlsklLLzrnx1Q5PTrfZ+n' +
        'Vq3/fYaQ4NL6gy65wAoZFcMqy0ghK0fV1cQraUqPjHWblqRvn/0WG' +
        '1HEDk+lp7VvKzPJ1a+s+tjXaiq5zLoS3dtjvVGslZDN3S2lltsWKS' +
        'OGpTsvO13WNG4PEDbSfDFWrfNTN08kbfzsw7imveaKUiUobV3NWL5' +
        'QjwsBwBg0wWq6hO0FoID6SaCuGU/LclJ/j0olIZunhJbMa9PL4teW' +
        'XYfsPtAUYeqQgOh68YsVFt04eekakZrVoeC+UopEpkr7vcMneaQAP' +
        'J//Zu8oJ0ajHVVSSCYzvsH9U3Bf7o+AQeYaAKkcQ84fzKmr/8biWW');
  If not (FindBitmapToleranceIn(BinIcon,result.x,result.y,0,0,Width-1,Height-1,75)) Then
  begin
    writeln('Could not locate storage bin');
    result.x := 0;
    result.y := 0;
  end;
  FreeBitmap(BinIcon);
end;
function GetInventoryLocation : TPoint;
var
  ActivatedIcon : integer;
begin
  ActivatedIcon := BitmapFromString(44, 6, 'meJyNktkrhFEYxv8KSWTJNtnJlgy' +
        'yJqQhIiUpF7iQcoE0togkEVluZL9TyC6yZMvWWMdyw5Vlss7FMDV+' +
        'OTl95cbp6+v53vOc532+57wqX3+DwWDj6Pz88qLy9beyc+DxCghaX' +
        'Vs3mUxX1zeJqRoqlp8lAG/d8UloRBQgMEx9//Bgbe+UkJJK8fPr6/' +
        'HxqaikVHkEtc3tHbaOdLrg8EgqfsGh+4dH7+8fOXn5cKpqavsHh6g' +
        'PDI+AhYfp2bm2jk6U4egvr2RrCarrG+oamwDa2vrO7h4ANE1mFgBv' +
        'r29vyiOoZefmASBgBjA7v9DY3AJoammFdnJ6lpKWwSdvsDhFAhgQW' +
        'NlaAp/AEH4EgKY6Jh7g5u2H7PjEJGaUiQk1y+8iDaU++Vv+rMi4hP' +
        '94EN2TNOnEKz6xVFBYnJ6dQ85/Pdg5uynVqNAdYOvkAo0w5RYJd/X' +
        '2AeYWFklJpCfuwmw2Cx2pXFZRCa7U1khZbsHR3WNodExw5JGl5RWh' +
        'hsm9/QPA1PRMa3sHs3R7ewdZ6dDeVcUQkgBTtLG5RW4Xen1sYjJbY' +
        'kSVHlw9fahwBdKS0WhkEsqrtIIjj3BxtAafnZ+HRUWLKd3e3aUXsU' +
        'P+Bt30cdo=');
  If not (FindBitmapToleranceIn(ActivatedIcon,result.x,result.y,0,0,Width-1,Height-1,125)) Then
  begin
  writeln(inttostr(result.x) + ' ' + inttostr(result.x));
    writeln('Could not locate inventory');
    result.x := 0;
    result.y := 0;
  end;
  FreeBitmap(ActivatedIcon);
end;
function GetItemLocations(Bitmap : Integer;From : TPoint) : TPointArray;
var
InventoryItemPoints : TPointArray;
begin
  //writeln('from :'+ inttostr(from.x) + ' ' + inttostr(from.y));
  if not FindBitmapsSpiralTolerance(Bitmap,width/2,height/2,InventoryItemPoints,From.x,0,From.x+200,Height-1,50) then //125
  begin
    writeln('could not find item in inventory');
    SetArrayLength(InventoryItemPoints,1);
    InventoryItemPoints[0].x := 0;
    InventoryItemPoints[0].y := 0;
  end;
  result := InventoryItemPoints;
end;
function ItemNeedsRepair(IconLocation : TPoint) : boolean;
var
RepairBitmap,DamageColumnIcon,X,Y : integer;
DamageLocation : TPoint;
begin
  RepairBitmap := BitmapFromString(20, 8, 'meJxz9fR9/uLF79+/r9+4GRwWJSQ' +
        'uA0euGFJoIpu2bM3JLwKKV1TXbdi0GVkvphSayNu3b4UlZIFccRnF' +
        'p8+eIevFlEITAToArhiZjcaFsNFE/vz9C+f+/PkTWS+mFJrI69dvg' +
        'A6AOAPIRtaLKYUmsnb9xrzCEiAXSAKDAlkvphSaiE9AyMuXr4COAQ' +
        'a+p08ARNf///+BJKYUmggAh3LDuA==');
  DamageColumnIcon := BitmapFromString(22, 8, 'meJxtkU0LAVEUhv+k/AMsJksLo9i' +
        'QaNSYGiVpSEpCydLHxsfGiiykFDLF0myGaWq8dXQ64XY7nd7z3Pfe' +
        'c24QfJbv+1ndDEUU7OPpYlotyrGNehMK5TmjAhL8y/MyWhkKcirhO' +
        'EQygYgj4VgcOaJ9uxMmmaJZdd2nmtfYgQD4k0N7MARD5Gg8IwxVvI' +
        'F5lKxOTzrwkxCVZHoyXyJHTBVKrEtYHvl1QFxvtojnq/2lM8nrbxe' +
        'IjW5fr1nTxYoVOW3m2QENYkrUJonRhPpwHJrG7ySZ55dIf7bd7Q/0' +
        'I/LL6F7m32bWTBo=');
  if not (FindBitmapToleranceIn(DamageColumnIcon,DamageLocation.X,DamageLocation.Y,IconLocation.x,0,Width-1,Height-1,0)) then
    writeln('could not find damage column in inventory');
  writeln(inttostr(DamageLocation.x) + ' ' + inttostr(DamageLocation.y));
  If (FindBitmapToleranceIn(RepairBitmap,X,Y,DamageLocation.X,IconLocation.y-3,DamageLocation.x+50,IconLocation.y+20,85)) Then
    result := false
  else
    result := true;
  FreeBitmap(RepairBitmap);
  FreeBitmap(DamageColumnIcon);
end;
function IsItemInInventory(Bitmap : integer) : boolean;
var
ItemPoints : TPointArray;
InventoryLocation : TPoint;
begin
  ItemPoints := GetItemLocations(Bitmap,GetInventoryLocation);
  if not (ItemPoints[0].x = 0) then
  begin
    result := true;
    writeln('Item is in inventory');
  end
  else
  begin
    result := false;
    writeln('Item is not in inventory');
  end;
end;
function IsActive(Tool : Integer) : boolean;
var
InventoryLocation : TPoint;
IconLocation : TPoint;
Bitmaps : array of integer;
i : integer;
begin
  InventoryLocation := GetInventoryLocation;
  IconLocation.x := 0;
  IconLocation.y := 0;
  SetArrayLength(Bitmaps,10);
  Bitmaps[Tool_RockShards] := BitmapFromString(7, 5, 'meJwTlZFnAINrN24BSVEZeVGwCJAL' +
        'RLv37J0xezKQhItAEFAQiCDqIWw4QjMNSAK1AxkA4Vsq7Q==');
  Bitmaps[Tool_Lump] := BitmapFromString(11, 11, 'meJwTEpcRAiMGJCAEExRCkt29Zy' +
        '8coSlDkwWijKwUIIKowZSdMXsyBEHUICuASxGjAG4LEGBqhCOIAgg' +
        'bUwHcIxBDkDUiy8LV4JHFH5IAdJd2MA==');
  Bitmaps[Tool_Water] := BitmapFromString(9, 11, 'meJwTEJUUgCEGBgYBJC6y+I3ruVh' +
        'lcUlBxIHoyXxnNFkg9ysYoGmEaIGII2uEGwVHQCmILH4pIANNHNlM' +
        'uAiyONwlyAAiCABnHlg8');
  Bitmaps[Tool_Hammer] := BitmapFromString(10, 9, 'meJwTEpcRQkIMDAxCqCLIUrdv32Y' +
        'AA6xSEOAe345VwfLlyyEK0GSB3Pjm7UBdEAVAEq4ALgWxFJcUmssx' +
        'pTAdg0sKAKXcM0Y=');
  Bitmaps[Tool_Whetstone] := BitmapFromString(30, 6, 'meJy7dPmKmY2dqIy8u6//////vQO' +
        'CgWygyOs3b8RkFYAiWXkFt+/e/f37d3hMHFBK28jk2ImTQO6FS5cg' +
        'Gv+DAZARGZcAFP/z9++16zf8QsLaOrvrm1uB4r0TJwFFpkyfAWQ3t' +
        'bVPmzkLoqulvRNoBdBYoC6gyNbtO4AmABkBYRFAKyBqgCQQ/fz5s7' +
        '27B8gIjYp58PAh0F6Ighs3bwIVA50HZAPd4+jmCdEFNBaiEWICUPt' +
        '/GIDYBTe5qKwC6NO5CxZaOzpDRC5dvuLpF3jm7DkIG+gkoOORTUMz' +
        'WUZZDS6IpgboWmAg3Lp9u6CkDMgFsh89fgwJEyD5/MWL2sZmXCbv2' +
        'bcf4uXUzGyIY4ABC7ELaCAkoPKKSt6+fQeJL6AuEysbINvQ3AqoUs' +
        'vAGJfJuiZmQAOBLgf6y9LeCShy8PBhIBeSBoBBCtQODCWgFQCzCP+A');
  Bitmaps[Tool_Pelt] := BitmapFromString(14, 14, 'meJwTEpcRQkIMDAzu8e1ABGQIoU' +
        'oJYaiMbt6KRyUDDACVQRAuxXBL4crwq4QbiNVMNEvxKEYzCk0lkIQ' +
        'YBVEJEUEmkRUjq4d7B9lTyHohCGsowdUwIAFcwUUwmuDBRWSEEhn1' +
        'cMVoKgHWhYJs');
  Bitmaps[Tool_Log] := BitmapFromString(9, 7, 'meJwTlZEXRUIMDAzu8e3RzVuBDGRB' +
        'oAgQJU57AZQFIjRxiCCyFoghECm4OB71QJMhhiMLIuvCFAciAF7ZKi4=');
  Bitmaps[Tool_File] := BitmapFromString(9, 6, 'meJwTlZEXRUUMDAzJyclAEk28vb0d' +
        'lzgQoIkzgAFWcff4diDCtBQoiGk4EAEAfjUXHg==');
  Bitmaps[Tool_CarvingKnife] := BitmapFromString(5, 5, 'meJwTlZEXBSMGMICz////D+FC2BDx' +
        '+Obt7vHtokha4GwgAgD3Gw1x');
  Bitmaps[Tool_Mallet] := BitmapFromString(8, 8, 'meJwTEpcRAiMGBob45u0MYCCEKghB' +
        '7vHtaFJAEYgUXByiHigOkQKSyIIQw+EMNDMhDEyL4LKYgkAEAG8oIys=');
  if not (InventoryLocation.x = 0) and not (InventoryLocation.y = 0) then
  begin
    //writeln(inttostr(InventoryLocation.x) + ' ' + inttostr(InventoryLocation.y));
    FindBitmapToleranceIn(Bitmaps[Tool],IconLocation.x,IconLocation.y,InventoryLocation.x,InventoryLocation.y-2,InventoryLocation.x+100,InventoryLocation.y+15,90);
    if not (IconLocation.x = 0) and not (IconLocation.y = 0) then
    begin
      writeln('tool is active');
      result := true;
    end else
      result := false
  end else
    result := false;
  for i := 0 to high(Bitmaps) do
    FreeBitmap(Bitmaps[i]);
end;
function IsClosedStack(IconLocation : TPoint) : boolean;
var
  ClosedStackIcon : integer;
begin
  ClosedStackIcon := BitmapFromString(11, 11, 'meJyNkNEWgiAQRH+lQyRkdTRFEF' +
        'Ix6f9/iQbWeOmhODywcHd2hhh/r6p7SPM8dQ5b9BO/W97aYzuymyY' +
        'AZ6EW1hgAKKX2cvDEEwC+tgElpDKwigzwDwDZi3vhEk8oaxeIqfqJ' +
        'gCL17W1XUAu6oLN7MCuG0pRCJkDNNDSNQ4sNsFo8nMeNMiaFwSMgR' +
        'A5XVTzAFaUAKc2Wg8+s0X/8YnwD4vPGRg==');
  if FindBitmapToleranceIn(ClosedStackIcon,IconLocation.X,IconLocation.Y,IconLocation.x-20,IconLocation.y-3,IconLocation.x,IconLocation.y+12,75) then
    result := true
  else
    result := false;
  FreeBitmap(ClosedStackIcon);
end;
function IsOpenStack(IconLocation : TPoint) : boolean;
var
  OpenStackIcon : integer;
begin
  OpenStackIcon := BitmapFromString(11, 11, 'meJyNkEsSwiAQRK9iIQaMWokJQs' +
        'B8CHj/K2GTUVy4UIoFDG+6e0jp96q6uzTroXPYoh/51fLW7tuBXTQ' +
        'BOAs1s8YAkMZLvcjbQjwB4GsbcYXUcQhSe7EB/A1A9uQeKOIJh9pF' +
        'Yqp+JKBIfWd7KagZXdABmS2Mhym5FDIDaoIpwmQ7tNiIqCUDGmlGa' +
        'QLqGBAiu7MqGZDqM4UJ2+ATa/Qfv5ie2zu4LQ==');
  if FindBitmapToleranceIn(OpenStackIcon,IconLocation.X,IconLocation.Y,IconLocation.x-20,IconLocation.y-3,IconLocation.x,IconLocation.y+12,75) then
    result := true
  else
    result := false;
  FreeBitmap(OpenStackIcon);
end;
function IsStack(IconLocation : TPoint) : boolean;
begin
  if IsClosedStack(IconLocation) or IsOpenStack(IconLocation) then
    result := true
  else
    result := false;
end;
function MoveToPile(IconLocation : TPoint) : boolean;
var
  PileLocation : TPoint;
begin
  PileLocation := GetPileLocation;
  if  not (PileLocation.x = 0) and not (PileLocation.y = 0) then
  begin
    writeln(inttostr(iconlocation.x) + ' ' + inttostr(iconlocation.y));
    MMouse(IconLocation.x+25,IconLocation.y+5,0,0);
    HoldMouse(IconLocation.x+25,IconLocation.y+5,1);
    MMouse(PileLocation.x+50,PileLocation.y+100,0,0);
    ReleaseMouse(PileLocation.x+50,PileLocation.y+100,1);
    result := true;
  end
  else
  begin
    writeln('could not move item to Pile');
    result := false;
  end;
end;
function MoveItemsToPile(Bitmap : integer) : boolean;
var
 ItemPoints : TPointArray;
 i : integer;
begin
  Result := false;
  ItemPoints := GetItemLocations(Bitmap,GetInventoryLocation);
  if not (ItemPoints[0].x = 0) then
  begin
    for i := 0 to high(ItemPoints) do
    begin
      if MoveToPile(ItemPoints[i]) then
      begin
        writeln('moving item to pile');
        result := true;
      end
      else
      begin
        writeln('failed to move item to pile');
      end;
    end;
  end
  else
    writeln('Item Point x = 0');
end;
function MoveToBin(IconLocation : TPoint) : boolean;
var
  BinLocation : TPoint;
begin
  BinLocation := GetBinLocation;
  if  not (BinLocation.x = 0) and not (BinLocation.y = 0) then
  begin
    MMouse(IconLocation.x+25,IconLocation.y+5,0,0);
    HoldMouse(IconLocation.x+25,IconLocation.y+5,1);
    MMouse(BinLocation.x+50,BinLocation.y+100,0,0);
    ReleaseMouse(BinLocation.x+50,BinLocation.y+100,1);
    result := true;
  end
  else
  begin
    writeln('could not move item to bin');
    result := false;
  end;
end;
function MoveToCart(IconLocation : TPoint) : boolean;
var
  BinLocation : TPoint;
begin
  BinLocation := GetCartLocation;
  if  not (BinLocation.x = 0) and not (BinLocation.y = 0) then
  begin
    MMouse(IconLocation.x+25,IconLocation.y+5,0,0);
    HoldMouse(IconLocation.x+25,IconLocation.y+5,1);
    MMouse(BinLocation.x+50,BinLocation.y+100,0,0);
    ReleaseMouse(BinLocation.x+50,BinLocation.y+100,1);
    result := true;
  end
  else
  begin
    writeln('could not move item to bin');
    result := false;
  end;
end;
function MoveToInventory(IconLocation : TPoint) : boolean;
var
  InventoryLocation : TPoint;
begin
  InventoryLocation := GetInventoryLocation;
  if  not (InventoryLocation.x = 0) and not (InventoryLocation.y = 0) then
  begin
    MMouse(IconLocation.x+25,IconLocation.y+5,0,0);
    HoldMouse(IconLocation.x+25,IconLocation.y+5,1);
    MMouse(InventoryLocation.x+50,InventoryLocation.y-100,0,0);
    ReleaseMouse(InventoryLocation.x+50,InventoryLocation.y-100,1);
    wait(WaitAfterClick);
    ClickSend;
    result := true;
  end
  else
  begin
    writeln('could not move item to inventory (MoveToInventory)');
    result := false;
  end;
end;
function MoveCartItemsToInventory(Bitmap : integer) : boolean;
var
 ItemPoints : TPointArray;
 i : integer;
begin
  Result := false;
  ItemPoints := GetItemLocations(Bitmap,GetCartLocation);
  if not (ItemPoints[0].x = 0) then
  begin
    for i := 0 to high(ItemPoints) do
    begin
      if MoveToInventory(ItemPoints[i]) then
      begin
        writeln('moving item to inventory');
        result := true;
      end
      else
      begin
        writeln('failed to move item to inventory');
      end;
    end;
  end
  else
    writeln('Item Point x = 0');
end;
function GetImproveResource(IconLocation : TPoint) : Integer;
var
X,Y : Integer;
i : integer;
Bitmaps : array of integer;
begin
  result := -1;
  SetArrayLength(Bitmaps,10);
  Bitmaps[Tool_RockShards] := BitmapFromString(10, 8, 'meJwTEJEUgCEGMBBAEkEWv3bjFhC' +
        'hKYCLQ9CM2ZMZkABcfPeevRBZIAOiBi6Iph2C4AqAbDgDLgWxFy6C' +
        'LAWXxQQQBwMAX95ZPw==');
  Bitmaps[Tool_Lump] := BitmapFromString(11, 11, 'meJwTEpcRAiMGJCAEExRCkt29Zy' +
        '8coSlDkwWijKwUIIKowZSdMXsyBEHUICuASxGjAG4LEGBqhCOIAgg' +
        'bUwHcIxBDkDUiy8LV4JHFH5IAdJd2MA==');
  Bitmaps[Tool_Water] := BitmapFromString(9, 11, 'meJwTEJUUgCEGBgYBJC6y+I3ruVh' +
        'lcUlBxIHoyXxnNFkg9ysYoGmEaIGII2uEGwVHQCmILH4pIANNHNlM' +
        'uAiyONwlyAAiCABnHlg8');
  Bitmaps[Tool_Hammer] := BitmapFromString(10, 9, 'meJwTEpcRQkIMDAxCqCLIUrdv32Y' +
        'AA6xSEOAe345VwfLlyyEK0GSB3Pjm7UBdEAVAEq4ALgWxFJcUmssx' +
        'pTAdg0sKAKXcM0Y=');
  Bitmaps[Tool_Whetstone] := BitmapFromString(24, 6, 'meJy7dOmysbmNkLiMq6fv////PX0' +
        'CgGygyOvXb4QlZIEiGdl5t+/c/f37d2hEDFBKU9fo6PETQO6Fi5cg' +
        'Gv+DQUt7Z21DM5Db0zfx6rXrk6ZOB7IbmtumTJsJUdPU2g40EGgIU' +
        'C9QZMvW7WFRcUCGX1AY0ECIGojVEO71GzeBUkCrgWygXXZObhA1QE' +
        'OADLj6nz9//ocBiMkQcSC6dOmyu7ff6TNnIWygdUCHIetFM0dSThk' +
        'uiKwG6LVHjx5DfAckn794UVPXiMuc3Xv3tXV0AxnJaZkQq//8/Qsx' +
        'Geg1oBpDUysgW8/YHCiurm2AyxxtfROgdqCrgG42t7YHihw4eBjIB' +
        'QApMMaA');
  Bitmaps[Tool_Pelt] := BitmapFromString(14, 14, 'meJwTEpcRQkIMDAzu8e1ABGQIoU' +
        'oJYaiMbt6KRyUDDACVQRAuxXBL4crwq4QbiNVMNEvxKEYzCk0lkIQ' +
        'YBVEJEUEmkRUjq4d7B9lTyHohCGsowdUwIAFcwUUwmuDBRWSEEhn1' +
        'cMVoKgHWhYJs');
  Bitmaps[Tool_Log] := BitmapFromString(13, 12, 'meJwTEJUUwEAMDAzu8e3RzVuBCM' +
        'jGlIUAiJrEaS+ADCBCUwnkAmXhaiBsrMogKiEIj1FwWVxqIHZBZCE' +
        'MrOZAHINsF7IyTMfAzUFWhmwXpiFwBLQLOXywqoEog4ckLjXIbsOj' +
        'BogAsTBkHg==');
  Bitmaps[Tool_File] := BitmapFromString(12, 12, 'meJwTEJUUwIEYwACXLERBe3t7cn' +
        'IyLmUQBcuXLweSWNXATcCvgEITgAC/CfHN293j23H5F64AooYMBRA' +
        '1+BUQGeYAiSc8ew==');
  Bitmaps[Tool_CarvingKnife] := BitmapFromString(8, 8, 'meJwTEJEUQEUMYIAp+P//fzRxIPf2' +
        '7dto4iQJxjdvd49vJyiIx2EAJ48iBQ==');
  Bitmaps[Tool_Mallet] := BitmapFromString(8, 8, 'meJwTEpcRAiMGBob45u0MYCCEKghB' +
        '7vHtaFJAEYgUXByiHigOkQKSyIIQw+EMNDMhDEyL4LKYgkAEAG8oIys=');
  for i := 0 to high(Bitmaps) do
  begin
    //writeln(inttostr(iconlocation.x) + ' ' + inttostr(iconlocation.y));
    if (Iconlocation.y = 0) then
    begin
      iconlocation.y := 4;
      writeln('passed 0 value to get improve resource');
    end;
    If (FindBitmapToleranceIn(Bitmaps[i],X,Y,IconLocation.x+20,IconLocation.y-4,Width-1,IconLocation.y+20,90)) Then //125
    begin
      result := i;
      writeln('tool ' + inttostr(i));
    end;
  end;
  if i = -1 then
    writeln('unknown improve resource');
  for i := 0 to high(Bitmaps) do
    FreeBitmap(Bitmaps[i]);
end;
function SelectTool(Tool : integer) : boolean;
var
i : integer;
Bitmaps : array of integer;
IconLocations : TPointArray;
InventoryLocation : TPoint;
MousePos : TPoint;
Active : Boolean;
begin
  SetArrayLength(Bitmaps,10);
  Bitmaps[Tool_RockShards] := BitmapFromString(10, 8, 'meJwTEJEUgCEGMBBAEkEWv3bjFhC' +
        'hKYCLQ9CM2ZMZkABcfPeevRBZIAOiBi6Iph2C4AqAbDgDLgWxFy6C' +
        'LAWXxQQQBwMAX95ZPw==');
  Bitmaps[Tool_Lump] := BitmapFromString(11, 11, 'meJwTEpcRAiMGJCAEExRCkt29Zy' +
        '8coSlDkwWijKwUIIKowZSdMXsyBEHUICuASxGjAG4LEGBqhCOIAgg' +
        'bUwHcIxBDkDUiy8LV4JHFH5IAdJd2MA==');
  Bitmaps[Tool_Water] := BitmapFromString(9, 11, 'meJwTEJUUgCEGBgYBJC6y+I3ruVh' +
        'lcUlBxIHoyXxnNFkg9ysYoGmEaIGII2uEGwVHQCmILH4pIANNHNlM' +
        'uAiyONwlyAAiCABnHlg8');
  Bitmaps[Tool_Hammer] := BitmapFromString(10, 9, 'meJwTEpcRQkIMDAxCqCLIUrdv32Y' +
        'AA6xSEOAe345VwfLlyyEK0GSB3Pjm7UBdEAVAEq4ALgWxFJcUmssx' +
        'pTAdg0sKAKXcM0Y=');
  Bitmaps[Tool_Whetstone] := BitmapFromString(24, 6, 'meJy7dOmysbmNkLiMq6fv////PX0' +
        'CgGygyOvXb4QlZIEiGdl5t+/c/f37d2hEDFBKU9fo6PETQO6Fi5cg' +
        'Gv+DQUt7Z21DM5Db0zfx6rXrk6ZOB7IbmtumTJsJUdPU2g40EGgIU' +
        'C9QZMvW7WFRcUCGX1AY0ECIGojVEO71GzeBUkCrgWygXXZObhA1QE' +
        'OADLj6nz9//ocBiMkQcSC6dOmyu7ff6TNnIWygdUCHIetFM0dSThk' +
        'uiKwG6LVHjx5DfAckn794UVPXiMuc3Xv3tXV0AxnJaZkQq//8/Qsx' +
        'Geg1oBpDUysgW8/YHCiurm2AyxxtfROgdqCrgG42t7YHihw4eBjIB' +
        'QApMMaA');
  Bitmaps[Tool_Pelt] := BitmapFromString(14, 14, 'meJwTEpcRQkIMDAzu8e1ABGQIoU' +
        'oJYaiMbt6KRyUDDACVQRAuxXBL4crwq4QbiNVMNEvxKEYzCk0lkIQ' +
        'YBVEJEUEmkRUjq4d7B9lTyHohCGsowdUwIAFcwUUwmuDBRWSEEhn1' +
        'cMVoKgHWhYJs');
  Bitmaps[Tool_Log] := BitmapFromString(13, 12, 'meJwTEJUUwEAMDAzu8e3RzVuBCM' +
        'jGlIUAiJrEaS+ADCBCUwnkAmXhaiBsrMogKiEIj1FwWVxqIHZBZCE' +
        'MrOZAHINsF7IyTMfAzUFWhmwXpiFwBLQLOXywqoEog4ckLjXIbsOj' +
        'BogAsTBkHg==');
  Bitmaps[Tool_File] := BitmapFromString(12, 12, 'meJwTEJUUwIEYwACXLERBe3t7cn' +
        'IyLmUQBcuXLweSWNXATcCvgEITgAC/CfHN293j23H5F64AooYMBRA' +
        '1+BUQGeYAiSc8ew==');
  Bitmaps[Tool_CarvingKnife] := BitmapFromString(8, 8, 'meJwTEJEUQEUMYIAp+P//fzRxIPf2' +
        '7dto4iQJxjdvd49vJyiIx2EAJ48iBQ==');
  Bitmaps[Tool_Mallet] := BitmapFromString(8, 8, 'meJwTEpcRAiMGBob45u0MYCCEKghB' +
        '7vHtaFJAEYgUXByiHigOkQKSyIIQw+EMNDMhDEyL4LKYgkAEAG8oIys=');
  InventoryLocation := GetInventoryLocation;
  IconLocations := GetItemLocations(Bitmaps[Tool],InventoryLocation);
  Active := IsActive(Tool);
  for i := 0 to high(Bitmaps) do
    FreeBitmap(Bitmaps[i]);
  If (Active) then
  begin
    result := true;
    Exit;
  end;
  if (GetArrayLength(IconLocations) < 1) then
  begin
    result := false;
    writeln('failed to find tool #' + inttostr(Tool));
    Exit;
  end;
  if not(Active) then
  begin
    MMouse(IconLocations[0].x+25,IconLocations[0].y,0,0);
    GetMousePos(MousePos.x,MousePos.y);
    ClickMouse(MousePos.x,MousePos.y,1);
    wait(WaitAfterClick/10);
    ClickMouse(MousePos.x,MousePos.y,1);
    result := true;
  end;
end;
function ClickRepair : boolean;
var
  RepairOption,X,Y : integer;
begin
  RepairOption := BitmapFromString(30, 8, 'meJz7/x8K/vz5++LVm5T8WnlDLxW' +
        'zAHkDdxW7WFWbIAVDT2ULIOkqp+sir+cqq2WnahWqaOqpbOarZOIL' +
        'EtR1kjd0VTT1AhqioO8qr+sC1K5uGQLkKhp5KZv6qpoGhCYUvXr9R' +
        'kbTRtkyWMnYU8UiUNHQR0bbQdnMH8hQMfdXs4tWMvZSMHRXNvJSMv' +
        'ZWMvFTNg/QsAqT1/dQMPYEWqRo7A20Ud7AU9nEF2gyyGote6D6pKL' +
        '2Zy9eK5v4GDkEnTx3+dfv35eu3fGIKFDQdgIqi8qq+/T5y5Ubd609' +
        'Y+T13QPj8q/cuPP79+837z6UNEyUBxsF9AKQrO2Yduvuw/9I4O6Dx' +
        '0n5LbLaDjv2HU0qaFYw9AhLyDt55pKisQdQduKsJapm/r3TFu85eF' +
        'zFPOjO/cexWfWKZn7OwemfvnzTsI0GmawHMjmloEnRAMRQMvVTNHD' +
        'esmNfdnmbqnkI0Ds/f/6CWwd0lYKhN5Chbh0sp+OsrOv4/cdPJVN/' +
        'U4+knqmLNu3YD7QCZKa+K5CUB7tZ1dxPVtsOyJDVd1Iy9TZ0Cn/45' +
        'Lm+TYC2SxzQZHVgqDrEqduFyuu5KZn5gfW6yBt6qJp7A01WNvW5eO' +
        '12bnlHVHq5lUc8KLKMfUAxaOQJIg09pDRtgQxg9MkZuKtbh7f1z2u' +
        'duEDFImD/kVOT5qxUtQzJLe88d/EaMAaBynbsPWJoFzRh5uLte46o' +
        'WYYCbfeOrTRwilm+bjs4GYBCTNEQlEK0HRKUTEHBrmIRJK/nom4dq' +
        'mEXBgxhTbsIc9eI85euA/XeuP3AMzxXQdsBqCyvuhsocuTEeSu/NG' +
        'CSqOuY/u3bD2Cc1rZNBrvTDUjqOKeC2e4qFn4AZxdiFQ==');
  If (FindBitmapToleranceIn(RepairOption,X,Y,0,0,Width-1,Height-1,85)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);;
    result := true;
  end
  else
  begin
    writeln('Option Repair could not be found"');
    result := false;
  end;
  FreeBitmap(RepairOption);
end;
function Improve(Item : Integer) : boolean;
var
ItemIcon,i,X,Y,ImproveTool : integer;
ImproveOptions : array of integer;
InventoryLocation : TPoint;
IconLocations : TPointArray;
begin
  ImprovingItems := true;
  InventoryLocation := GetInventoryLocation;
  if not (InventoryLocation.x = 0) and not (InventoryLocation.y = 0) then
  begin
    case(Item) of
      Item_Ball:
      begin
        ItemIcon := BitmapFromString(9, 9, 'meJwTEJUUACMGGBCAicDFGxsbq6qq' +
        'ampqkGWB7KampsLCory8vLS0tLCwMIgsRD1QPDk5OSEhMSUlJS4uz' +
        's/PD2I40Bygeog4UFdISIiTkzNEKj4+HqgSKAgkgaY5Ojp6eXnBzY' +
        'yOjgYKuri4AMU9PDzQXOIGBnD1aO5H8xcAmmIu+w==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_SmallBarrel:
      begin
        ItemIcon := BitmapFromString(11, 10, 'meJxjYGCIb97OAAbu8e0QBOEWz7' +
        '4NYUAUwJVhipSXl0PUQ0TgDLg40MxyMIBrhHCB4kA2XD1cGUQKohJ' +
        'ZAcQoiEpkuzCtxuUYiIGY4si2QzyO7Ei4AqyOhJAAl09r1A==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_RopeTool:
      begin
        ItemIcon := BitmapFromString(12, 9, 'meJzTtnLVtnbTs/PUtXXXd/AGshk' +
        'YGATT+oAkj2MUb0gpkAEU1LZ01rf30rX1MHTyAyqGqIHIQkigLEQc' +
        'GUDUQBCQq2HuoGnuANECF0RTgwmAzoC4BK4GwgAKAvXCnQF3MJqxy' +
        'HqRVcJNxoWwOgYrAAC1FTL4');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      QuestionMark:
      begin
        ItemIcon := BitmapFromString(10, 14, 'meJxlUQsOgjAM9S4iTAQVEMbGHA' +
        'tDgyaek2Pim8M5oWma/l77up3kM70OB95vPMm6V1S2hHb72igy4zh' +
        'OH4GDMLrIVAxRIeBPK7ENDmUh69A1Y3vMtZ+JmbY9oIFRsH71KB9J' +
        'cwPEANkP6LgZLQSp1KIECGjD+kfNJaaRT5q7cdgfmVQaSML7IGPQ7' +
        'bkOcm7phXlDytZaKJb6b2I3gjzWgSrek1C1OHPGUgUnLMTuOxlzgD' +
        'K/UKk3QkmORw==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_StoneMineDoor:
      begin
        ItemIcon := BitmapFromString(12, 12, 'meJx9j8ENwDAIA5m5CzABE3SDTl' +
        'krJ1lupMaPiMBhoKquo2oBM3OH5itIYoBnyYAyG0MVK1pylpPJ0GI' +
        'fj+huBXpJwmDlZVTVF3KbRYYpBjDPnY15c+I/q7wiffIWX5ErnfUC' +
        'fW7gfQ==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_UnfinishedGrindStone:
      begin
        ItemIcon := BitmapFromString(10, 11, 'meJwdkOlygkAQhF8jXMaL+xQ1ku' +
        'ACLst9g5UU7/8idqyaH7szXV/3jBnmbtJ4SSvIlqS5/NEQZNONG5+' +
        'NfjrapPTpsNG8al7zaWX9s5xXUbbO2eTGtX5LJNUpxt+ftBIVmz/o' +
        'ST3RZpYUB9OPrZK2S1L2/F675x003F6DIGQtOhAHtHzrp43uiYpF2' +
        '4UUXUBr2HE7FRo/fGTdAg0g37S8EAZr4WjyBwNkEC4RI//kGiM0Q9' +
        'YgP9zjakq7J8Sf+glfPED+ehRgnmgPPikG+GbDHwqQIK2RwSaFE1U' +
        'oXABp32Gqa8SwI05hhTn2NW5UvUZYDUZw5HYK9NY9R/8F1QxHfQ==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_GrindStone:
      begin
        ItemIcon := BitmapFromString(10, 11, 'meJxdUNsNgzAQY5YSSP8IoaDyUN' +
        'utMkAGySx0jSyDwZIVcTpFPtt3ucS4ufVr7d5VEWCMmxu/ACDB5Jz' +
        '3/Y8EQAkVLXbYKKWU2EgPwHP6lWW6gozMMUYZJIHUGsC69yaxCwwn' +
        'U9JkAI0VQ8+jm2RghhAomf58svGLFo5X6ENw2vGLLCfb1wcMpAPJAmlS');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_Saw:
      begin
        ItemIcon := BitmapFromString(12, 13, 'meJxtkVtuwkAMRdlKBYTAgCAhdJ' +
        'oXCYl4frAFPrKUfmQpWUK31+MxGlDVyLIc+86xPWPSNvysFl/NwjZ' +
        'zWy/zk8Tud+Q+ydgm2Bb42W4/tweTHQmmcU51GIau6whCW09j0ZCH' +
        'Y8DuKhX0fY8n5iwH19UNwqq8RM3dCxRCXgk0ncTZf4QaQpAUQVKKJ' +
        'sq84AVJW0oshcbkp3eBh7AgpVV5/SNQAq0/lsl4bcebFCPz+P7B3i' +
        'EQaCGotFWB+vPjCWF4BHi5DdeFkl6pBsypo7K1aNjdobwsiAtMFtk' +
        'Wk0gmgYbGP41xseySHY17ptCt9guUcHDa');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_UnfinishedSpindle:
      begin
        ItemIcon := BitmapFromString(11, 11, 'meJwTEpcRQkXcfIJKurZyGqZABG' +
        'QLYVMAkQUiSUUdTAXIarAqAMoCxSEkpgKIXojVQBLNDciyeEzG4yq' +
        'yZfGYDET4ZYEIAP4kIgg=');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_PracticeDoll:
      begin
        ItemIcon := BitmapFromString(10, 15, 'meJxdkEFOwzAQRbNjAzv2DW0au2' +
        'ktWjtJm8TglqLAHlZISFyCk3EJjsVzBrzAGo2+53/PfE/pvN4fdRN' +
        '0G1QTsixTzi9tT6ao6vvfcB5q8/FNLu1Q2B7N3LQ3pgEIRSxevsDL' +
        'id0MY/Z3hBJW+gOuXj8lwIlS0cmREVwvT28S4GLXLbYH5gJ4DhaB9' +
        'JEpqr6Diva2HZ6pXI/vF3ZMTSjiqurOZnhKrHQQwbp/XB0exLmwSU' +
        'Ce37Z5Zcn/WOnMuoppOtdEIZZtxH/Jkidj8UkTEMfltyG66s/GP5P' +
        '1/gSLDSgqBAvhazwsnS+m1eVrN9O7WWVzU/8A7uNKxg==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_UnfinishedHuntingArrow:
      begin
        ItemIcon := BitmapFromString(15, 15, 'meJwTEpcRIoS4+QQhiKBKkhQD1c' +
        'hpmBKjGK6SeDOJUSmpqEN1lVS0HSJLjJlAWTtHFyLNhKgkNTwhuoh' +
        'RT6RKZD/iRwCmejzQ');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_HuntingArrow:
      begin
        ItemIcon := BitmapFromString(6, 6, 'meJwTEJUUEJVkYGCAkPHN2yGM////' +
        'A0n3+HYGMIBwgbIQlXDFcCm4IDJXAMlwIAIAwbgVUQ==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_WarArrow:
      begin
        ItemIcon := BitmapFromString(15, 15, 'meJxNkn1ygkAMxT1LixZBilCV8i' +
        'VfCkid1ht4mP7RI/V49peN7pTJZMLm5SV5u+6uWmzKeZw7cfYUJgT' +
        'PYbJ4K5woxft5v0xqbGY+frFV0fvZ0U+7sJoIgnLUw3V95nD2+Lyk' +
        'XeUGieX96/4UlENYfxAH5SnuLmCu3794KVTatJMWhhnaqP2kitgii' +
        'WHASElQTQDWzRmLDxdOLNIUCsx7lzHwrlmEqbQLmOH6g2f9xaYgC0' +
        'ayBuxnh2XS6DAWCSe7MCeNmN/dVkJrPIV4251G7EgKU61etnsv7YQ' +
        'Zn7SWMygGUaP9Um2J7wOYCf/vTkd+6R41ZybBVB+Yyd5uN8spTdNu' +
        'HhdcJVkCJ8q4X9a0SOUExgBKq6uZeUYVlgdgkVqFSpzrXu6uYhE8J' +
        'fpIdGZFqsjwiDIPzTG9a3kJ1URstGpUcFS9g+VRDSuBjfg/XIOQ1g==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_Mallet:
      begin
        ItemIcon := BitmapFromString(10, 9, 'meJxNjlEKwyAMhj2KjKAQWGdrXVt' +
        'p3RjCoJfoYfawI+16+202qXwPms/8CY/ZthFwSEApZUIC1EbTz7zb' +
        'qrbXR+1HLLmJmisQJTy3N566CbysHDOwwx0V1OVDae8TdUm7CUgvr' +
        'HyQdjtm8nNVMvSXjKFdOqqTi0Aux8CSMzzKkn/02V+WVdKg6oZlyX' +
        'AzPn4Bw+M5Fw==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_UnfinishedBow:
      begin
        ItemIcon := BitmapFromString(7, 16, 'meJwlT+tugjAYfYtlIhAHoZTSWgQ' +
        'UgSJYrk4z94dk7/8kO9Wkafqdnttn+czyKCt0VHS442qMq8Ehe1Yu' +
        'DpWyve8vt6R7HPSPUDOY4vK0IPHZizlyNbGz3niUnobw2L9xSGR3h' +
        '8qNEpcm2fSHRzr8AjH39WETftAr3IK09mVBMvXheHZeQ44asv2GiW' +
        'gWjG5Wo0xc9vAUzQxbA+YKtgDBBA3d8Gs8+3UbcPjjIMgmwoDDatb' +
        'BaqWpF+bXIG0RTfImrqf3Rpuv8HNHYILc1y4jmLToUEY0N3psMW6D' +
        '2MSpGUiqn9BGZ83rUaiFlT09tbwagPwD3HxC5g==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_UnfinishedShortBow:
      begin
        ItemIcon := BitmapFromString(49, 6, 'meJz7//+/kLgMBP0Hs4FkS3vno0e' +
        'Pf//+HRoRAxGBAPxqgGRYVBxQ5M/fv1evXfcJCIGIZ2Tn3b5zF65S' +
        'U9fo6PETQO6Fi5eMzW2AIjqGpmfPnf/8+UtETDzcIjQn1TY0C0vIA' +
        'k0AakSWwqMGIv7z58+2jm4gIzgs6sGDhxDxptZ2ZJVbtm4HuhzI8A' +
        'sKA7oNyNi2fSfQg0AGUC8uJwFNwOoSPGogZEFx2evXb+bMW2Bp6wi' +
        'XRVMJdDY82CGOBIpA1IhKySM7SVxGEdlwgk7C9AiECwwfoJdv3rqd' +
        'V1iCVSXQAZJyynBBiAjQMXA3QKJYWkFl774DlDsJ6BJIpOTkF719+' +
        'xaryt1790EiNzkt8/SZs0DGpi1be/omGppaARMnUA0kioFJCxjmlD' +
        'vJ1dP3+o2bwOQNNBPiNkyV2vomQJcAQwaYBcyt7SEJ/viJU8AsYOP' +
        'oClQDACYKo1A=');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_LongBow:
      begin
        ItemIcon := BitmapFromString(15, 15, 'meJxNkWtygkAQhLlCrpCoUZAgqC' +
        'G8BEHwEU2s5AAeJj9ypFwv3+zoCrU1Nex2z3TPOM79ewziYZQ9BfF' +
        'ong/ChOhl3SSuOM/LlZe2/AK7/PxtL789nsP9NO9m1dFLGjlp+7La' +
        'u3E9NXg+8LD6xKg5CzLrgvIgRFNBb/qVoTycvkn8Yu8XO8BB9c4J6' +
        'w9JygONZusjJ9qclaJ47oNSYO6byCCOjRFUaRfy0SK3eF7ByKsBe+' +
        'lmEq/JASOMfLwsVQ+R1ujnRsqaCFFYuMg6bYRgNS7zSRoG6CaNYIh' +
        'mMn6xRb+fb0FG9actfhUggL34NR7D+kRHcsSE66MF80Rl9WUcFYMo' +
        'RRJdhlHOKnm1MvBr+u7QD1GXhQAty9aI/N7x8xy6VEtbTbAGURLOa' +
        '0lTq4TuMi5TREZ3W65M5jZzu1z1zt4X7RdgHTiqruC0BaBSAf8Dto' +
        'mFWA==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_LargeShield:
      begin
        ItemIcon := BitmapFromString(15, 15, 'meJyNUlEOgjAM9S6iTAQVFIGBgA' +
        'MVTfzaAfj1Hn54JK/nk8VmjkhsmubRvnalrZNU0yAdr2IWFgCjb4F' +
        'nEnBYFpWw3q5xksoOCxU9tQ9dlXPOay9rWCSQYm9yndben1AdIGqv' +
        'MyvgxFQhopGlJ9DnMr8AGKX6n4pMZYfJ1L/hv3UipfyTLDsxmtfJl' +
        'CI/ohfpkw1gzOT9j9tyYBp6D9jILBa0keE5g4nKxgaNVhXT8hMsEY' +
        'fBor2q/+s2cEJQMF1eQxf5GZhSSNz04IsrrJsecU4v8XHVog==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_LongSpear:
      begin
        ItemIcon := BitmapFromString(10, 14, 'meJxlUQsOgjAM9S4iTAQVEMbGHA' +
        'tDgyaek2Pim8M5oWma/l77up3kM70OB95vPMm6V1S2hHb72igy4zh' +
        'OH4GDMLrIVAxRIeBPK7ENDmUh69A1Y3vMtZ+JmbY9oIFRsH71KB9J' +
        'cwPEANkP6LgZLQSp1KIECGjD+kfNJaaRT5q7cdgfmVQaSML7IGPQ7' +
        'bkOcm7phXlDytZaKJb6b2I3gjzWgSrek1C1OHPGUgUnLMTuOxlzgD' +
        'K/UKk3QkmORw==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_ShortBow:
      begin
        ItemIcon := BitmapFromString(8, 15, 'meJxjYAABAVFJNAQUdI9vxyUV37y' +
        'dAZtGiC6sGiHqIRpxGYjVLqncUqxaBH2DiRTHaj5W92B1P1b/4gof' +
        'rMECRAB+aSQ1');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end;
      Item_Spindle:
      begin
        ItemIcon := BitmapFromString(11, 11, 'meJwTEJUUQEUMDAzFs2/HN28HIi' +
        'BbAJsCiCwQuce3YypAVoNVAVAWKA4hMRVA9EKsZgADXLJ4TMbjKrJ' +
        'l8ZgMRPhlgQgAdiQwRQ==');
        IconLocations := GetItemLocations(ItemIcon,InventoryLocation);
        FreeBitmap(ItemIcon);
      end
      else
      begin
        writeln('Item to improve not supported');
        result := false;
        Exit;
      end;
    end;
    if GetArrayLength(IconLocations) = 0 then
    begin
      writeln('Failed to find item to improve');
      result := false;
      Exit;
    end;
    SetArrayLength(ImproveOptions,10)
    ImproveOptions[Tool_RockShards] := BitmapFromString(37, 8, 'meJzFkltLAkEAhX9ipltBZWpaqWX' +
        '0aCaB2ZMZ1ZOXDcXyVg/Vr1AxNIO8oqH+AZ980ITtg6FBNqK3Wobh' +
        '2zNn5+yeWU3TjIaFPxvaf8QxX11efEynajwWj0WBYCAg9CPf4Xg8f' +
        'u/1thx2oWAYDgcwSqvZnM1mzGIV257bBbh2tkejkWnRYLdZ6/U3PL' +
        '1u1+10yrhwKIQH8TR4QhYGod/f5Xkqk04/l8tCwYACVysVdID5pVo' +
        'FUsnk7U0KSCYST48PQKlUxA8c+/3kyjixg+xW6suKCVCMxslkMu9k' +
        'UIJgZhhwbNo6nQ7Azgf7HuHRvi4+QW6rO0rda8zHyYOQcXJVBPm8X' +
        'lqSnpUl5fvZ/RRHG9YNcz6XLRYKujgKFGXmshlRJiMaieC5VlVxS+' +
        'GsAufhs3a79WscNt7wtVazWS26OH4PqqOiRqNBjUI0r63it5jXxS0' +
        '6KSiDft+z6/4E9i3TjA==');
    ImproveOptions[Tool_Lump] := BitmapFromString(37, 8, 'meJw1UutLU2EY/0PSnZ33XOam7nY' +
        'uO3MnddezczZ3dU6aZugoKC/gh5BCoZgYYpJiFlmEJgRBX6MLpJia' +
        'ZjpzLVdqBH2L6EMF3j6s50w6HB5efu/ved7n+T2/YrGIWxWCayC5M' +
        'G72l9H2sgoHLSZxTib4BpxRyiudWLULs3gRHyCFmNbkxao9JBci2B' +
        'BmkjCzH+fDJB+m7TECDkIM/kpnK87IOBvQic2IC5F8qLyynrCFEC8' +
        'Vi0XEBjSGOszkgVuMkSlbBLf6kFmCNjCrTDniOjFJ1zRpGVlr8kFj' +
        'yOLDjF7IQlxAJ8QpIU7bYqQtRtijmMmHuAbCFoWuDHWttD2BWAXqI' +
        'D6oMbohF54rM9RD7O0fPjw8un7zwdXBscOjo3RPRu9sBjze1v37z9' +
        '/85z1BSlF8BJD+GxM7X7/rHU3OWNfGVuH4+Hh9a1tU2kgh+rGw6wy' +
        '3E3zQ3dj54+cvZPUKUsta9hNwtvJfxEALpJM2tcjFy5m64Lnc9l66' +
        'N9PRcw0I5YZawG/dndWLzaOTj17NL2uq3ICc781UOJIVfHR+aX3k9' +
        'jRMPTIxvbCSxSz+obGHwxMzBB8ZHJ26N/MUxnkxt9zRM4DMcupC3+' +
        'r7LUg/KULyEd3pJBz0zhTiwnCgxbgqtVUiuLDOHts/ODhVaoAWoqQ' +
        'tBKsBNUhW1pplxPpBENyiCP6WD/kdqiYKE8nNnbBi4BT/fzACRIIN' +
        'qs9xIZ2YUOtzQdyi7pR2qGIa65K0PU7Zw/sHh2SJCa1SQgIzuqGUa' +
        'ipG0dcm4bbSldY5Eu+y+Wjrpdz2juoNJgicqtom2pEkuQbM6IF0yt' +
        '6oPsoEEBM40ZawxVSED0F8/nqJcZ8Zn3r87OUCYpTS1AkwBmxq4e3' +
        '6yOQ0+GH0zuyblU2CDYNd+4cmgTMwOK762eyfW1wbu/9Ea/F19Q1l' +
        'cwW4wi1+VVKjCy/VJ8DAJVU1Ji/E7iuqhRZXN3lvihKbAAERtGZJ7' +
        '2ypCbRv5lSrrGXzgv+MxuQBHVjpLPDNtVFkUcC9gtS2kSsAUtj95o' +
        'qk/wGnRJYF');
    ImproveOptions[Tool_Water] := BitmapFromString(37, 8, 'meJw1UutLU2EY/0PSnZ33XOam7nY' +
        'uO3MnddezczZ3dU6aZugoKC/gh5BCoZgYYpJiFlmEJgRBX6MLpJia' +
        'ZjpzLVdqBH2L6EMF3j6s50w6HB5efu/ved7n+T2/YrGIWxWCayC5M' +
        'G72l9H2sgoHLSZxTib4BpxRyiudWLULs3gRHyCFmNbkxao9JBci2B' +
        'BmkjCzH+fDJB+m7TECDkIM/kpnK87IOBvQic2IC5F8qLyynrCFEC8' +
        'Vi0XEBjSGOszkgVuMkSlbBLf6kFmCNjCrTDniOjFJ1zRpGVlr8kFj' +
        'yOLDjF7IQlxAJ8QpIU7bYqQtRtijmMmHuAbCFoWuDHWttD2BWAXqI' +
        'D6oMbohF54rM9RD7O0fPjw8un7zwdXBscOjo3RPRu9sBjze1v37z9' +
        '/85z1BSlF8BJD+GxM7X7/rHU3OWNfGVuH4+Hh9a1tU2kgh+rGw6wy' +
        '3E3zQ3dj54+cvZPUKUsta9hNwtvJfxEALpJM2tcjFy5m64Lnc9l66' +
        'N9PRcw0I5YZawG/dndWLzaOTj17NL2uq3ICc781UOJIVfHR+aX3k9' +
        'jRMPTIxvbCSxSz+obGHwxMzBB8ZHJ26N/MUxnkxt9zRM4DMcupC3+' +
        'r7LUg/KULyEd3pJBz0zhTiwnCgxbgqtVUiuLDOHts/ODhVaoAWoqQ' +
        'tBKsBNUhW1pplxPpBENyiCP6WD/kdqiYKE8nNnbBi4BT/fzACRIIN' +
        'qs9xIZ2YUOtzQdyi7pR2qGIa65K0PU7Zw/sHh2SJCa1SQgIzuqGUa' +
        'ipG0dcm4bbSldY5Eu+y+Wjrpdz2juoNJgicqtom2pEkuQbM6IF0yt' +
        '6oPsoEEBM40ZawxVSED0F8/nqJcZ8Zn3r87OUCYpTS1AkwBmxq4e3' +
        '6yOQ0+GH0zuyblU2CDYNd+4cmgTMwOK762eyfW1wbu/9Ea/F19Q1l' +
        'cwW4wi1+VVKjCy/VJ8DAJVU1Ji/E7iuqhRZXN3lvihKbAAERtGZJ7' +
        '2ypCbRv5lSrrGXzgv+MxuQBHVjpLPDNtVFkUcC9gtS2kSsAUtj95o' +
        'qk/wGnRJYF');
    ImproveOptions[Tool_Hammer] := BitmapFromString(38, 8, 'meJxlUstPE3EQ/juUst1nW1iW7m6' +
        '7D1r6gtJut9snhYItaQ0GBMLDREMsIqIhVA4SDkr0bKInEy/qReOF' +
        'ixrxASigRD0bYxA1UJM6vz14cbOZzEzmN/PN9029Xm/y5Z2xIVrN4' +
        'IJer9dZf5H1F2gpybgSWGsXKehs+BTbUbKwQcJtkO44raQpOYOLGq' +
        'NmCFEn1bSVjzQ0ea1cp6XF18gGKDlJugxG7bZ7ukmXzigpmzdv8+Q' +
        'c3n6btxtG0HISaghBcwQKEDr8ffZgkY8NN4eKDa1+S0uIklK0nCJ4' +
        'zdLsJyTDymuUBLNiuEun5TQmaqScbGBDWGuEaevF+SjhTjh8BZuSp' +
        'ZQUJcahhpHTpCuOCQmwMMLKhSkJwBu0mkY7hgfTxYnN7b1arfb12/' +
        'czs0uUKwX5yemFw8OjuaWbMwsr4JRGKxjXCfmpyiKEl6qrs9Ub4JQ' +
        'n5mBx1Sg9e7lRq/15++5DV26MEjWonLmyvPPxc/2/j5Diu3tfBsbn' +
        'rYLW0TOyv39AyYjt0bOXQ9nhN1s7Q+eqg5PzgAfnIyg/vRjJj0Pn0' +
        'tj58vgcyouxR4/XTo7PkpJx4nTl+astXEDYBqfmmUARHJDG7suDXo' +
        '1OlCellNObvLZ6+/7DJ7smJBgN1t6eA2nAwZ2a3d9vPkyApSQdZ8M' +
        'oBGnciDSCj8Gy/1aATRkpiSrdGsGFwIEDYJQc1zXi8PWZHRKvN3cn' +
        'KkuFkUqbhiA1sqiMUjJwBuBgXARkNTOoD+3J0aY6cFfwFpymYPnw6' +
        'MiuJigF/jSlZmg1C3l0Bia9jKfP3tbDKFmQGMLjtnZAGEyUm5TknX' +
        'sP0FJCFDUUdIJHEwkxigsRc+tesM2BAavT3FFK2jx5VM9Hn669WLl' +
        '19xjVNjW3vL6xQ5tsWEUd48xKwbBwIdytU7KBACjZC9XVn79+7/84' +
        'uHj1OurQGjU5BNJQARy5w5s3FUd9cNGwmeTgzQHSZA/OXunqX9/YB' +
        'uTvdz+Fc0OYSSbpSlhagn8B1QOwzw==');
    ImproveOptions[Tool_Whetstone] := BitmapFromString(40, 8, 'meJw1Uv1PE3cY/zsm5Xp337tSuLZ' +
        'c73ovtFDa0vder1coYKWMAr6Lynz7gWKI2zIW170giZmGbMl+MDP7' +
        'ZT8YNUaXzcAScBHUCiKomPq2TLPF4UtbE3yuyy6XyydPPvd8Ps/zf' +
        'GI9H81ev10qV968Lc3MLah9Rxh3ZmNjgxJUmo9jtgBpjzL+rYyvz8' +
        'B4CIdCOmKUpCExiXNhWk4SXJSUNSMbrKl3Ga1tBktLLdOKRJXkFVr' +
        'uqHN2kHyUlhImV7fJmTK70iZXB9EYpKXkvQfF4dE8LScQHxkeO/Ho' +
        '6V9m92bQZSM7GryZGpvbYPEiIUGJCYINGxrchKAY2TASQDGC81FK1' +
        'DAuTIpqDePFbEG6qQtnQ4Qjbm7pMUntSEogLgYcWtRIPobZ4/ClBI' +
        '12pV7+u+5RskiAQRSq6pzxD4Lu4Y8n760VK5V3fUM5xCdiXYOFxbu' +
        'VSuX5i3+GRz7H7WHg5D6dWF5dw2w+wN0DR6BVYWnFpfTDEmSlb+56' +
        'AX6/tbQaSO1BnM4/PjFVfPInNNl28LN9R795/uLvmbmbxye/7xw4h' +
        'DeGCCEGnC+/PUPwkez+Y+VKBYnR1QfF9OBB2LBHG3i5/gpWB5z+oV' +
        'FKiBt5nT85ddbItuVP/nD5t1mci1y8MtO/9ygpKFt2jlxbWMTtbcA' +
        'Zn/iObs18uDsHfnA2SIlKz56xT744NX9raWT8NCnoPU1NSayxrdai' +
        'z2K0hzl36qtTZ85dml65/xAqde60ngFRxSw+sAfY4tsC26YkFXJCs' +
        'JFSqbzx/wMqtKACQI4wYfXWWlsB13syEA9aSlkDu6y+zPr6ayTEdY' +
        '6g4lwUjgW4lvEuFO7sy+V7d400x7JVRd0bklRzS4ZypgDD9SF1Jlk' +
        'D3XpPtlQu18lxJMGrITlJye3A0eMBYZB0XHz8LJQ+UNfUSUvtyeyh' +
        'xeX7m0zN+ow2P2YNYGwAMG4PgX+fto1xdpz9+VK1EtSnbu4yOTsbW' +
        'nsBX7gy7Qj2npj66fzlq+D215k/Jk7/+AFqGh77er5wl3Losxi5KG' +
        'b1/+cztHnol6tzEAk49+/Xbvi799JVPwQfM7IhvJoH3BYaHT/56vU' +
        'boB3LT0HF7OrWOQLkU8E5BfD+XB68Tc8uSJEsYQ9LgfR8YRkqd1bW' +
        '/KntmNULHJKPGywe2Azg96/6xS8=');
    ImproveOptions[Tool_Log] := BitmapFromString(37, 8, 'meJw1UutLU2EY/0PSnZ33XOam7nY' +
        'uO3MnddezczZ3dU6aZugoKC/gh5BCoZgYYpJiFlmEJgRBX6MLpJia' +
        'ZjpzLVdqBH2L6EMF3j6s50w6HB5efu/ved7n+T2/YrGIWxWCayC5M' +
        'G72l9H2sgoHLSZxTib4BpxRyiudWLULs3gRHyCFmNbkxao9JBci2B' +
        'BmkjCzH+fDJB+m7TECDkIM/kpnK87IOBvQic2IC5F8qLyynrCFEC8' +
        'Vi0XEBjSGOszkgVuMkSlbBLf6kFmCNjCrTDniOjFJ1zRpGVlr8kFj' +
        'yOLDjF7IQlxAJ8QpIU7bYqQtRtijmMmHuAbCFoWuDHWttD2BWAXqI' +
        'D6oMbohF54rM9RD7O0fPjw8un7zwdXBscOjo3RPRu9sBjze1v37z9' +
        '/85z1BSlF8BJD+GxM7X7/rHU3OWNfGVuH4+Hh9a1tU2kgh+rGw6wy' +
        '3E3zQ3dj54+cvZPUKUsta9hNwtvJfxEALpJM2tcjFy5m64Lnc9l66' +
        'N9PRcw0I5YZawG/dndWLzaOTj17NL2uq3ICc781UOJIVfHR+aX3k9' +
        'jRMPTIxvbCSxSz+obGHwxMzBB8ZHJ26N/MUxnkxt9zRM4DMcupC3+' +
        'r7LUg/KULyEd3pJBz0zhTiwnCgxbgqtVUiuLDOHts/ODhVaoAWoqQ' +
        'tBKsBNUhW1pplxPpBENyiCP6WD/kdqiYKE8nNnbBi4BT/fzACRIIN' +
        'qs9xIZ2YUOtzQdyi7pR2qGIa65K0PU7Zw/sHh2SJCa1SQgIzuqGUa' +
        'ipG0dcm4bbSldY5Eu+y+Wjrpdz2juoNJgicqtom2pEkuQbM6IF0yt' +
        '6oPsoEEBM40ZawxVSED0F8/nqJcZ8Zn3r87OUCYpTS1AkwBmxq4e3' +
        '6yOQ0+GH0zuyblU2CDYNd+4cmgTMwOK762eyfW1wbu/9Ea/F19Q1l' +
        'cwW4wi1+VVKjCy/VJ8DAJVU1Ji/E7iuqhRZXN3lvihKbAAERtGZJ7' +
        '2ypCbRv5lSrrGXzgv+MxuQBHVjpLPDNtVFkUcC9gtS2kSsAUtj95o' +
        'qk/wGnRJYF');
    ImproveOptions[Tool_Pelt] := BitmapFromString(27, 8, 'meJz7/x8E/vz9+/zl67isCg3bGDX' +
        'LMFWzAHXLMBWzAC2rcEllS6ACHedkIKlk6KFk5qdiEaRiHqBiGaJk' +
        '4qNk7AkUVzTxltKwkNGyk9d3Bykz8lA1D4rMqLr74ImWfYSWbZiqR' +
        'ai+e7amXaSCkbuyuQ9QjYK+i5yBq6yOs6Khp5yOs5Ix0ChvZZCBIF' +
        'klUx95XScFQw85PWeQYkMPRUMPFTPv379/Kxq6W3hEnLtyE8g+c+G' +
        'qQ1COsqkfSI0ByGoZDeuUkjag1J8/f2/cuheWVKJk6gsUL6hqAzrm' +
        '1+/fCTkNYMVuCobuacXN127dkzNw2X/0dO+MpcoWQT1TFx48dkZG0' +
        'xaoRs06HEiqmPn//Pmrb9piVcugmMyKh4+fQQycOG+9jn1kQl490K' +
        '7/MPD46YuojGpFIw+gFiUzH6CzlU29gGxJdQuQp0xAGuX1XapaJ71' +
        '5+2Hhsg3uYVnKZv7KpmAv67tpOcZDDAcCDdsoVasQNfsofY80LcdY' +
        'oCFqFoHy+m6qFj7ff/xUNvICGaXnCiSVzYMUjb0T8hv6Zy67fe9Re' +
        'ctkJXCAqFoGgr3pATFQ3SZE2yFR3SpUxdRPxdj3wNHTPVMWKpsG9E' +
        '1beODIaSVjkIGqFoEgl5gH3Ln/ODG3Xk7XqbS+9937j6pWwSAn2YT' +
        'JG7jK6btBDJTTcVIwcAE6CZhOlI18HIOyL169DQyN0+evWrhGKYAT' +
        'hoKBB4QMSii+dfcRMJkBFSTmNSibgyxSMfFVMQ+U0wf5AgD0PULK');
    ImproveOptions[Tool_File] := BitmapFromString(15, 8, 'meJz7/x8FaNpFAUltu2ggqWrsK6f' +
        'nqmTope2Sou0UL6PtABRUMfNTNvNTNPTQsI/WcYnXsItQd4gBims5' +
        'xkjr2cnoOCqb+quY+SsaeAAF5XVdlE19lEx8VCwC5A3cgCIK+iBS0' +
        'djT0jv55NlLv3//vnjluq17FLIb5A09FPTdgQwlE28Id8f+43EZ5c' +
        'pmXjGZtSfPXIRIqduGA90mq++saQtygBzYeXL6zj9//oIb9fv3H5B' +
        'HLAJVzUN0XTM1bCMUjEAmq1qGgBxj5AVUrGEZIKvtqGTkoWweCJKy' +
        'ilC3DFU1D1IxC9C0DAOKKJv6gkzWdd1/5FTfjCUKhu5Zpa3nLl0HO' +
        'cPQR0bXUcHES9nMB+gekIiZP8jNBu4WHtFANUDzb9x+4BqSBQBVX7jl');
    if Item = Item_StoneMineDoor then
    begin
    ImproveOptions[Tool_CarvingKnife] := BitmapFromString(20, 6, 'meJy7e+dOWUlxUIA/EAUHBsyYPh3' +
        'I+P///8QJ/U+fPvnz509zYyNEBEJWV1V+/fr13t27qSnJQFmgFohe' +
        'OAKqWbJ4EVAcqBGoAFnvqpUrgOJLlyw5ferUz58/seqFC8J1Qciwk' +
        'GAgIyQoCKjx8OFDcDcDUXlZKVwlVr0QMyF683JzLl26lJyYABQEun' +
        'PD+nX49Z44cTwhLnbF8mXHjx0DivR0db1///73r1/79u4NDw3Br7e' +
        '3pxuo8uKFC4kJ8QCEj833');
    end
    else
    begin
    ImproveOptions[Tool_CarvingKnife] := BitmapFromString(28, 8, 'meJxTNPZq7Jrx/OXr7z9+7tp/TNv' +
        'ETUbDWs0mXNHUU9nMV9HYS1bbUV7XSd7QVcnMW8UiSEHfVV7XRcXU' +
        'T9nET17fXd7AQ9HMX8XMX80ySBnIsAgCopKGCecuXTdzDFY0dJ2xa' +
        'P2mnQdUzQMUjdyUDNwVjbzkjTxVrYPVbcLVrMIUjD0V9N2UTX2VDN' +
        '3k9VyVTLyVTL3VLYJVLYLVzINUzIOULQPl9d2UTH0vX7vtHZYhqW6' +
        'haOSuau5f3zVLTs8pJL386s17v3//efP2Q35Vm6Khx////2taJ9+6' +
        '+1DZ1P/KjTvuEYWa1mFuYQWv375Xs/S39Ek6dfYyUP2la7ftfRN//' +
        '/6tZhmobOSlYOSmaOChah6qahl05/7jmOxaWS07x4DET5+/qFuFA8' +
        '2Mz6pQ0HOR17TtnLywe+pSDbPAtv55MxeuBrp/x76jKUVt8oYeURn' +
        'Vp85d+f7jB1ClkrGXkom/um24oomPpmO0kUtM79RFW/YcufvwOdA0' +
        'oNuApIKBi7SWnZKJh7V38sWrNxVNvIHaPUIzFAw8f/789R8GgK7dt' +
        'ONgYFyhinUoMNjVbUJDksuVTH0uXL5RWNeXkN9q4RkHVKZmGQwy2c' +
        'RHxcRH0dhdycDz1PlrwXF5l6/fVrEKA8bjz1+/dOyjtZ1S1IHmWAS' +
        '6hWQeO3MZGCCqpj7dUxbMWrRWxTwAaK9jYLKufdjytduApikaeQNJ' +
        'eR2Qd5RNA9RsQms7ZwJFmnpmKZh4qVmGHjh6ZuLsFcom/nmVXecv3' +
        'ZDVd88ua331+i3QnNWb96ibeSmbeNf3zP767TswJJv65wP1AlMRiD' +
        'T2VrUJUzYDeUffLhjoNiPnaEUDTwVjH0vPBGDiAZpw885D98g8AG0' +
        'pKow=');
    end;
    ImproveOptions[Tool_Mallet] := BitmapFromString(38, 8, 'meJxlUstPE3EQ/juUst1nW1iW7m6' +
        '7D1r6gtJut9snhYItaQ0GBMLDREMsIqIhVA4SDkr0bKInEy/qReOF' +
        'ixrxASigRD0bYxA1UJM6vz14cbOZzEzmN/PN9029Xm/y5Z2xIVrN4' +
        'IJer9dZf5H1F2gpybgSWGsXKehs+BTbUbKwQcJtkO44raQpOYOLGq' +
        'NmCFEn1bSVjzQ0ea1cp6XF18gGKDlJugxG7bZ7ukmXzigpmzdv8+Q' +
        'c3n6btxtG0HISaghBcwQKEDr8ffZgkY8NN4eKDa1+S0uIklK0nCJ4' +
        'zdLsJyTDymuUBLNiuEun5TQmaqScbGBDWGuEaevF+SjhTjh8BZuSp' +
        'ZQUJcahhpHTpCuOCQmwMMLKhSkJwBu0mkY7hgfTxYnN7b1arfb12/' +
        'czs0uUKwX5yemFw8OjuaWbMwsr4JRGKxjXCfmpyiKEl6qrs9Ub4JQ' +
        'n5mBx1Sg9e7lRq/15++5DV26MEjWonLmyvPPxc/2/j5Diu3tfBsbn' +
        'rYLW0TOyv39AyYjt0bOXQ9nhN1s7Q+eqg5PzgAfnIyg/vRjJj0Pn0' +
        'tj58vgcyouxR4/XTo7PkpJx4nTl+astXEDYBqfmmUARHJDG7suDXo' +
        '1OlCellNObvLZ6+/7DJ7smJBgN1t6eA2nAwZ2a3d9vPkyApSQdZ8M' +
        'oBGnciDSCj8Gy/1aATRkpiSrdGsGFwIEDYJQc1zXi8PWZHRKvN3cn' +
        'KkuFkUqbhiA1sqiMUjJwBuBgXARkNTOoD+3J0aY6cFfwFpymYPnw6' +
        'MiuJigF/jSlZmg1C3l0Bia9jKfP3tbDKFmQGMLjtnZAGEyUm5TknX' +
        'sP0FJCFDUUdIJHEwkxigsRc+tesM2BAavT3FFK2jx5VM9Hn669WLl' +
        '19xjVNjW3vL6xQ5tsWEUd48xKwbBwIdytU7KBACjZC9XVn79+7/84' +
        'uHj1OurQGjU5BNJQARy5w5s3FUd9cNGwmeTgzQHSZA/OXunqX9/YB' +
        'uTvdz+Fc0OYSSbpSlhagn8B1QOwzw==');

    for i := 0 to high(IconLocations) do
    begin
      ImproveTool := GetImproveResource(IconLocations[i]);
      if ImproveTool = -1 then
      begin
        writeln('Unknown tool needed to improve');
        writeln('GetImproveResource failed');
        continue;
      end;
      SelectTool(ImproveTool);
      wait(500+random(500));
      if ItemNeedsRepair(IconLocations[i]) then
      begin
        Mouse(IconLocations[i].x+175,IconLocations[i].y+5,0,0,false);
        wait(WaitAfterClick);
        ClickRepair;
        wait(2000);
        WaitForActionFinish;
      end;
      Mouse(IconLocations[i].x+175,IconLocations[i].y+5,0,0,false);
      wait(WaitAfterClick);
      If (FindBitmapToleranceIn(ImproveOptions[ImproveTool],X,Y,0,0,Width-1,Height-1, 125)) Then
      begin
        Mouse(X+25,Y+5,0,0,true);
        wait(2000);
      end
      else
      begin
        writeln('option ' + inttostr(ImproveTool) + ' could not be found - check ImproveOptions array');
        Mouse(Width/2,Height/2,0,0,true);
      end;
      if not WaitForActionFinish then
        //Failures := Failures + 1
      else
        Actions := Actions + 1;
    end;
  end;
  result := true;
  for i := 0 to high(ImproveOptions) do
    FreeBitmap(ImproveOptions[i]);
end;
function SpinYoYo : boolean;
var
YoYo,Spin,X,Y : integer;
begin
  result := false;
  YoYo := BitmapFromString(9, 13, 'meJxdj00OgjAQhT2LUakoCYGWP4E' +
        'imMiCrWtO4NITuPAeXsLr+bVjjLFpmjfvzZt5VcaukyosB94grRf+' +
        'KGNV3kMGug2rQfht0au8AwSoxm6Sg5N0s/L2XXWiGVX6aZaBzKF5G' +
        'WVihFRZx4vdD+wdrxswdildgMwtWsWl8hYA5Xx/cQF7dqU1i1R+pD' +
        'zPj8vtyQW4aW6psxfTFVJcSJSi/kmAj6RbEn7VX55gvGQWVXj3U2P' +
        '5O3nIHzWjhI+7KWpHGKQ3qoBI8A==');
  Spin :=  BitmapFromString(20, 10, 'meJxlUgkSxCAIe6QXovv/Z+yGBh' +
        'jrOgyDgYYgLV2+x6ldmmgdUsdE0ODngkfKri9bAPtcabgO/SBAioF' +
        '53fkJOJ1W9CIETgb2MmbdROjzAK9RQ53UTAStmb186VLfU0S9gtCD' +
        'uYm7koit/kGoPy1rIKMFEl5cXvS95n2Yd2rOBzEfU7d41WQ4d4Sgx' +
        'O6yi/suNm+Xf80Ak5P7zY20E0nwbcdbmTz+Bp71q6VQ9gOiyT0M');
  if FindBitmapToleranceIn(YoYo,X,Y,0,0,Width-1,Height-1,90) then
  begin
    Mouse(X+25,Y+5,0,0,false);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(Spin,X,Y,0,0,Width-1,Height-1,100) then
    begin
      Mouse(X+25,Y+5,0,0,true);
      writeln('spinning yoyo');
      result := true;
    end
    else
      writeln('could not find spin option');
  end
  else
    writeln('could not find yoyo');
  FreeBitmap(YoYo);
  FreeBitmap(Spin);
end;
function CreateStaff(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,LogIcon,WeaponsOption,StaffOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  LogIcon := BitmapFromString(14, 14, 'meJxlkktOwzAQhjkJSBSVkEdToq' +
        'RpUruJkiamFLFhyQJxFhbcgJtwJ47BNww1UbEsazT69T9mHJsxMS6' +
        'qh3DdRfXupmy5waqJNuPZ8dAJyy6x+19k1cebEcBiKx0A7uX9+e2T' +
        'S50294l19HnhDMrW8yjs9eOLgksHTiGxe2gTe0cHgIdprUgMoAhsn' +
        'pnrYquEKjqFzdLytntctg+5e0rbg8cowMNiM0qEqicanN6bArSgOc' +
        '8tGKQxqQPxxqaiEsQ4gqN4ldX/jR29rXkvF6vZssLniegflXXw6Bi' +
        '1oInodG6c8yC9CDPYUIQwKBq2pkg/ZFlHeyAgKWTCxv1seZAVF433' +
        'qf4lI8h6R1Iiy9IBV70uXUXpy9+oB1bAcES0aCjmuaH4BlsIlQA=');
  WeaponsOption := BitmapFromString(46, 10, 'meJxtVAsShSAIPGSCv979j+FDVh' +
        'CrhnEQEXeBGGNw7VxvyFjbnttP1rltN0Qsuf/majLttVNplGtaUqA' +
        'QRI5KmwHbrXqH5S14CxcvLlPX9aIsykU8dc5yJJI0crL4HhkPAT8t' +
        'Ur6Kw9QFtirYfog6NHkOMaFgBUg8N+xDBnCED5BAJ1rItivJ7R7hM' +
        'xYx8k37RUViW0eygxtIg+TgG6KhNNNiq4cNvFq8FWGv9W0/mW462g' +
        'YPgvBMZ4m9ZzZBayEweqYxIFztFzEbKieYLM7b81EpQUJfSJLH1Gj' +
        'uPHV0KWc92pbExdwqGvWRvZiTd8/Iu6A29Ad8cf+ol18X5JHa0kMt' +
        'VnLM4jhjHZVLiRXcLI6cd6cQ30KiWJF4Buj4YeM06OdkWJnfM8QUN' +
        'mqiaMyOPjlGQaj7Ei5xG4ZV9U6b9VI3whDjEgr9dRHzJ2T7OZQCqj' +
        '8zIsF2');
  StaffOption := BitmapFromString(22, 8, 'meJxtUQEOxCAIe+ShoN7+/wyPUey' +
        'xZISYgtCCio5m8/jyc+/d57eP5d7uE/hkbHmBzsuBh469JfIkCYax' +
        'xJnhyOuQwLh1CWDo7mNIwj5dRa1eOQlDqNOk8NcZgsecR7pFmSF5s' +
        '50C9P5VyhbtcBYha28MtfEBWGwzpXXk0z3fAVcchnNmGFvkDN1QD1' +
        '3kKVoXSRwfQcxfI6DiD/s5LE0=');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(WeaponsOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(StaffOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        //MMouse(X+25,Y-10,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating staff');
        result := true;
      end;
    end;
  end;
  FreeBitmap(LogIcon);
  FreeBitmap(CreateOption);
  FreeBitmap(WeaponsOption);
  FreeBitmap(StaffOption);
end;
function CreateTenon(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,MiscOption,TenonOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  MiscOption := BitmapFromString(23, 10, 'meJxtUgkSxCAIe2QRRbv/f4aLBJ' +
        'R2t8M4AUPkKFW5uMEowMV1uXVFqAoBKwC2YGkdpi7LmHOWNtRVjLh' +
        'F/HybppvCIsvwFBNZfIhXcdcwXqQnoNAxG7hClleeRLbUjM8Iq50d' +
        'UYI2DjJywad/Zwl9KMRMBrDPxM49n9dMUhlyZNNgnYxKMo5z29Zxc' +
        'Rm1f7jfJWZylrJpqR1fyrNxttXgln6fyFUF86wsNYgJnE3lrekr/V' +
        '5mCiwHOyH+DVwp/gKLv2Fa');
  TenonOption := BitmapFromString(27, 8, 'meJxtUgsOxSAIO+TzA7r7X8OHVBD' +
        'dFkKkllLiMrUxRuGeKmdqHoLkyhNUPFVKs9RccF5l7AIZgvktOHU4' +
        'MjV6bE8xCgky7APopTTGciIwrAaM0zL3g8O9KIKVF8e6kLE1bsWD5' +
        'J+srIFbM0OuEAWPcSYLTZhE9hEfCN0Ok622PMBPhR+6Pa+8OSb4uJ' +
        '/4UnHEueCNgOZdLuX74pW9fY+j/Qr4GQxv4PwB3tBkew==');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(TenonOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        MMouse(X+25,Y-10,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating tenon');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(TenonOption);
end;
function CreateShaft(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,WeaponsOption,ShaftOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJy9ks9LwnAYxv/EzArDkjINbG' +
        'mXyi5iUZ3MqE7+WKeadTCqs2KHPKSBYSMhhwt114G7CJttrAdeGmM' +
        'TDx4c7+HZ+/287/Pu3dfrmfPOJK5ZVpZlTdPe6/XAin+KDiiccHp1' +
        'edFuf4c3ggvznodisVp9ncLCNM0Jp2KnE9/bJQ2XbCZDJflctt/vQ' +
        'YeC663Wl67rIJlIBJmD+P6PKCKjKAomJJ5c3DACr+jsnur05Jjytd' +
        'obNEQykUA5hCRJ0BBRZms4HNq/wg0j8AvGWljJ39HI/H8wDzJrgdU' +
        'Cx2Gl8KLmloUbRoC0FkVLcOwWVb6lRfsAgiCcp8+ODpOb4ZDbwgEj' +
        'dmJRnuexQ4zN3d48Pz06LD4ajfu7AgTa4mJQH6zIv+wrl0tEGoZBn' +
        'd0wRTqVGgwGKHypVIi0W+CyAcZpr9uNbTPI4Eqoqoq/wOZzRH42mw' +
        'DGwjOIP5tN3Lc=');
  WeaponsOption := BitmapFromString(35, 6, 'meJxtkt0vwmEcxf9EUWgjQuYlccW' +
        '8RApXDFPyMhu2lNxja66wsqxkS2/KpAu6q4uWWu3ns33nN0Nr353f' +
        '2XnOeZ7zPKY+41M83mg0ctmseWRYq2mZnpp8yeVgSqXS1uYGjKIo1' +
        'tmZSqUCP2QagGGmkkk0TGHQeD2eYrEIuWy3w6wsOcDNZjP/+jo/N3' +
        'sXCsHA2+atJAIKhQIYYBkdwVxMzvynulYNVvfhMEw0EgEDmA/RqGi' +
        'Ojw7RkII/TL1e93lPAI5F28fHO5/K908ERkM3y29vrkmEFJNOnRbQ' +
        'oW2r1WpigieACRaNMIKZu+5tOrm8OJ+wjMkSfbtOBPJ/zmTW11btt' +
        'gU6UYPE5G+QyojyZ5CchT2zYbfLSQlyQMzT6ZSYUFqXvvMqEFCDaL' +
        'ivx+D3+ULBIAx1SXWsVav7FYS/XIrLuVUulwcH+vHHnCsbN5vh93Z' +
        '2PqtVbudgf18NYhtoHmOxfmOvPAYOTtXJRAKHf4N4VG/5PI8BGYlf' +
        'PVCFyg==');
  ShaftOption := BitmapFromString(24, 6, 'meJxrbW768+fP379/Hz54UFtdFRz' +
        'g/////0kT+p8+eQIUb2lsBIpUlJXeu3sXyP3w4QNQCqIGAuDsX79+' +
        'LV+2FMhtaqh/8eI5RHzp4kUhgQFAQ4B6gSKPHz+ur60BMnKzMr9+/' +
        'QpkQJQhM2ZMmwq0Zfu2rfm5OXBxoCHIahJiY5YtWXLk8CGggWjakR' +
        'lAlwCVAdVMmzIZWRzOvn3rVl9Pd2N9XXpKMi5zgNpbm5uAjCmTJ33' +
        '8+BGrOUC/A30UHRG+Z9cuTHOAYRsRGgIMw0cPHwLZwKCAGIhpzszp' +
        '0398/w4MmTmzZmGac/HCBaBFAN+/CVA=');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(WeaponsOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(ShaftOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        MMouse(X+25,Y-10,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating shaft');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(WeaponsOption);
  FreeBitmap(ShaftOption);
end;
function CreatePlank(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,LogIcon,WeaponsOption,PlankOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  LogIcon := BitmapFromString(14, 14, 'meJxlkktOwzAQhjkJSBSVkEdToq' +
        'RpUruJkiamFLFhyQJxFhbcgJtwJ47BNww1UbEsazT69T9mHJsxMS6' +
        'qh3DdRfXupmy5waqJNuPZ8dAJyy6x+19k1cebEcBiKx0A7uX9+e2T' +
        'S50294l19HnhDMrW8yjs9eOLgksHTiGxe2gTe0cHgIdprUgMoAhsn' +
        'pnrYquEKjqFzdLytntctg+5e0rbg8cowMNiM0qEqicanN6bArSgOc' +
        '8tGKQxqQPxxqaiEsQ4gqN4ldX/jR29rXkvF6vZssLniegflXXw6Bi' +
        '1oInodG6c8yC9CDPYUIQwKBq2pkg/ZFlHeyAgKWTCxv1seZAVF433' +
        'qf4lI8h6R1Iiy9IBV70uXUXpy9+oB1bAcES0aCjmuaH4BlsIlQA=');
  WeaponsOption := BitmapFromString(46, 10, 'meJxtVAsShSAIPGSCv979j+FDVh' +
        'CrhnEQEXeBGGNw7VxvyFjbnttP1rltN0Qsuf/majLttVNplGtaUqA' +
        'QRI5KmwHbrXqH5S14CxcvLlPX9aIsykU8dc5yJJI0crL4HhkPAT8t' +
        'Ur6Kw9QFtirYfog6NHkOMaFgBUg8N+xDBnCED5BAJ1rItivJ7R7hM' +
        'xYx8k37RUViW0eygxtIg+TgG6KhNNNiq4cNvFq8FWGv9W0/mW462g' +
        'YPgvBMZ4m9ZzZBayEweqYxIFztFzEbKieYLM7b81EpQUJfSJLH1Gj' +
        'uPHV0KWc92pbExdwqGvWRvZiTd8/Iu6A29Ad8cf+ol18X5JHa0kMt' +
        'VnLM4jhjHZVLiRXcLI6cd6cQ30KiWJF4Buj4YeM06OdkWJnfM8QUN' +
        'mqiaMyOPjlGQaj7Ei5xG4ZV9U6b9VI3whDjEgr9dRHzJ2T7OZQCqj' +
        '8zIsF2');
  PlankOption := BitmapFromString(24, 10, 'meJxtUokRAyEIbNIP8fovwyDPSi' +
        '5xGAZxWR5ptOqYLp1E770bsdmlk0hNOosgS8BOSDCYIa9gKPAf4Xy' +
        'VQEOaHFtjnfzyjB3HaHc6QGqu8et35tAlOvVXhaF36ItvowQS1eYC' +
        'gLxdDMaTefp8hLbROvxzmedVD7IgyvDGhqR/+8q9o7t6kZyRx6aoE' +
        'NPQT3Tn9wTqO+NFYltsQ87VlsH74vT1dwd0FCbLcslMPFbDOz8xMd' +
        'Y9WZlZacOOcUm6D9Y1gcE=');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(WeaponsOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(PlankOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        //MMouse(X+25,Y-10,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating plank');
        result := true;
      end;
    end;
  end;
  FreeBitmap(LogIcon);
  FreeBitmap(CreateOption);
  FreeBitmap(WeaponsOption);
  FreeBitmap(PlankOption);
end;
function CreateWhetstone(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,MiscOption ,WhetStoneOption: Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  MiscOption := BitmapFromString(70, 10, 'meJxtVYESxRAM+8hhNu//f2OPRi' +
        'O17dyOqkojKp1XPq/U//XubXZ8mGvD7NbMs2Zbi1UaIZU6LWu2Ygn' +
        'je5BL9rrz1ZLjYQT1DDijG4ZHGaie50kBWIOl/8vVRlKWWu/b8LbO' +
        'zzq/0e7fsHfjPfu99bXZ/oxQDK22vvuRz6P0VkkCsg5QkSwzMgyax' +
        'U5LvR/7+r6YxXCy4eC1MbXVZsDGExkRyvgP2KOd3Xgs2BHPdkaUCn' +
        'YxkjPFE7de6QgPISODwTPKTjiN2CtaKlJYFguC01fS5tB3DNSpj6c' +
        'cfERLcM67T9WMJn7HIP2pQDCzZp26YLFjWtHMzsjg8+UvMU2fioRC' +
        'lWh1W8UzYsz0kYX07YIovco8JffE7408zNoJ4igP739GoODJrV/et' +
        'kXe7tobg2bHK6OaWaomP+c175cwptEWe8qJWuzOspDCJ1nRIEJVHS' +
        '9jgOQxkwD7wKMKcf+lWK8AtEzm3e6zfkN5Rn7jkuSoFiUT58JSrDk' +
        'y+KyfvuNKLaJSSeRXZdDrI5ZGDChZnNpZEiUwgibChXgF6LCpDrKU' +
        'qrtXQi2h0FKRtw+qmBVVIuBVohKWLF+vqnbia9JQhWCPm7b1wn49v' +
        'oTxB7UaLdM=');
  WhetStoneOption := BitmapFromString(51, 8, 'meJxtVAmSxCAIfOSq8cj8/xku0ID' +
        'ITIqiUBAbaFP7qiwTUp5B8tc6ZO9dWiepz2Dpsw2JJ42dsSiGdop4' +
        'JeCFq8F19s8tfhcbpmWJmB+RRXK65sxjUc5nfii+DZP58kViUAxp8' +
        '77P+pAWAeaJQhgwjpgArdpYcp4pNp8t1g3LM91GyVs+r2XbV8ylSY' +
        'Ir2WkJzGFnfcfEg4hHCb4Ug/uAzkBTAzXmdExTRRuAgZ8NYgWmYCV' +
        'DvHwdq9EjIkynHHaCekozeLEPmLVmHtpkGDUAc1qmDmsSlBzudX0N' +
        'N1ZxMwQtxaCbs8445nkQUxIwK5+8FnORUAEY6xLTQN2A+fWGAIZPt' +
        'tq7iMHOEy/Q3sVKtLmboFXgn+B8uIDZmPC+TrfHeQuJvc1q/HbVNI' +
        'u+Uios/wG7EqMq');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y-25,0,0);
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(WhetStoneOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        MMouse(X+25,Y-25,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating whetstone');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(WhetStoneOption);
end;
function CreateGrindstone(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,MiscOption,GrindStoneOption: Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  MiscOption := BitmapFromString(70, 10, 'meJxtVYESxRAM+8hhNu//f2OPRi' +
        'O17dyOqkojKp1XPq/U//XubXZ8mGvD7NbMs2Zbi1UaIZU6LWu2Ygn' +
        'je5BL9rrz1ZLjYQT1DDijG4ZHGaie50kBWIOl/8vVRlKWWu/b8LbO' +
        'zzq/0e7fsHfjPfu99bXZ/oxQDK22vvuRz6P0VkkCsg5QkSwzMgyax' +
        'U5LvR/7+r6YxXCy4eC1MbXVZsDGExkRyvgP2KOd3Xgs2BHPdkaUCn' +
        'YxkjPFE7de6QgPISODwTPKTjiN2CtaKlJYFguC01fS5tB3DNSpj6c' +
        'cfERLcM67T9WMJn7HIP2pQDCzZp26YLFjWtHMzsjg8+UvMU2fioRC' +
        'lWh1W8UzYsz0kYX07YIovco8JffE7408zNoJ4igP739GoODJrV/et' +
        'kXe7tobg2bHK6OaWaomP+c175cwptEWe8qJWuzOspDCJ1nRIEJVHS' +
        '9jgOQxkwD7wKMKcf+lWK8AtEzm3e6zfkN5Rn7jkuSoFiUT58JSrDk' +
        'y+KyfvuNKLaJSSeRXZdDrI5ZGDChZnNpZEiUwgibChXgF6LCpDrKU' +
        'qrtXQi2h0FKRtw+qmBVVIuBVohKWLF+vqnbia9JQhWCPm7b1wn49v' +
        'oTxB7UaLdM=');
  GrindStoneOption := BitmapFromString(50, 6, 'meJxlUwESwyAI++MqarX7/zM2SiD' +
        'S2uM4oBggYmnnz75iRtZH7aolEjytdv1bWocrfSAHRgRnskdGeLmo' +
        'Bck50OXZG5NZAi7y2TPxi/Wfc6DruNw9ZzW5g6FvGVeKXOqq9t4UK' +
        'sYnJkTtNr4biEOtoomru7faP1Jhw1B91HZI4xWoXhHTr0/xlZA8o3' +
        'dlVGAQ8OBDxYDa8BrTZfGAiWAovlXZSvS5iA2uiI+zmQcJEEQAEiW' +
        'cH56S2EYuQ4mJxNdgkc8+5X2n6GqST+4GK6a98l2StDNcPy+6rSsv' +
        'dH8IBGQJvKCV084/mCsrLw==');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y-25,0,0);
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(GrindStoneOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        MMouse(X+25,Y-25,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating grindstone');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(GrindStoneOption);
end;
function CreateArrowShaft(IconLocation : TPoint) : boolean;
var
  X,Y,CreateOption,MiscOption,ArrowShaftOption : Integer;
begin
  CreateOption := BitmapFromString(24, 6, 'meJz7//9/XeuUm3ceaNhEWnrGnzx' +
        '7+ffv35eu3LBxC1e1Dg2Iy7ty/Q5Q5M3b98X1fXJaTv/BQE7XxdI7' +
        '8cSZS79//7l09aZ9YApQMLmoRdnUW8HQY/vugwnZVWrW4RHp5afOX' +
        'VE09rh971Fsdp28gauDT9ynz19UzAKB6rVsIxRNfXfsPZKYWyev7x' +
        'KdWQNUDBRXMvZUNPaU0Xb8+fPnfxgAukHRxNPIOap74rzNOw/duf8' +
        'YKKho6AMyxzFeydT3589fcMW/fv8GkvL6bkqmnspm/kApNXMveT1X' +
        'JRN/ZfMgRWPvi1dvFdT2xWTXWPkmAVWqWAQDSQUDN6DjgYrVzf0VT' +
        'f3lDd1ltGyB4sqmAYpG7kAvHzh6unfqIlWLwKySpnOXb6pahAAVA3' +
        '2kZR2wcsMukEozvz9//6qZecvpux08dq5n6gJZXcfcksbzl29AZBW' +
        'NvBX03S08Y85dug7Ue+P2A+eAVCUT37qOmV+/ff/0+Wt95wyQvwzc' +
        'jp48D1Qgp+9q6ZkI1A5SfOehe1QOAJMg8hw=');
  MiscOption := BitmapFromString(43, 8, 'meJw1U49PE3cU/zs2j1573ystpb/' +
        'vem0PqG3p7+v1lx3VNgKlcVkj3YjWCQ5ZjIuyjEwHajaTZboENJot' +
        'xriZOJaMkIwQI9lAhbXl9zQmKkbdLygLe99r9s3l5b7v3nufz3ufd' +
        '3PzlaMnh2kubvLkGlyZD8+Ozj0skzrXzs4Osopqx16VPSm3ROCd0D' +
        'plOrfCGECMKDf4GpwZBH6LiLiozOChrTHSGJTp3XX6VsilbTGw9fY' +
        'ExQqIDSFTCJmDlClIMWEoQhq96uZ9kEjo3BA2N1/We7uQTURm39Lq' +
        'Y/AouZjK3kZzMQ2fegPZlXxc25oDOMoUoLgIbUsAHG1PUmyYYoKkw' +
        'aNghTfVNkLjIA1+QmOHCgAEVm70UEyoEbCYMDz1TW1wpa1xQuupa9' +
        'xN8wloBMI+Gfkq//4g4iL54unL177DBGxvgW1w7MsW+qvV6vb2vwu' +
        'lpbbc4Tptq9WbmZy6t7m5tbiynswWAahJzE3PzEHY7MOSQ2iXSxOQ' +
        'm4Ngte7OPdkjDxYq8PXZ8xfFE8MUK4J/aOTS+qMn4OwsDMDVEe68+' +
        'u1tmhOufPN9MnsIQzvTYEmjb3Nr68znowpTaH++b3XtEaFuujMxfe' +
        '7LMcoc6Cr0lxdXKYt4+4fJjoO9iBVTueL0vfsUG8EEDF6wCoNnceX' +
        '3TL4fMX53PPfq9R+kNPPBc1+rHan2g9DdtjQo3/jEFKi5UF6WGT1Y' +
        'fXsCpzOhvpOfPX2+cfnqjVDmMMkEaS4KvSNWUNoToCOoCQTAs/P/g' +
        'abk5hDOtWAJkEXgfB2ffnHl1p3JyvIani2PK6t2J+p0LuirlgXQH5' +
        '8ffbd38PrNcYU5gCmxgkQgSDS69na9N3T+Unlp7dipCyA3wNFchNS' +
        '01tYPWcLgUbGCxtUBZJS2BLLGpZoRqUL41wflQu9ge/fxlmgOe4x+' +
        'XN/kpa1RUsKCo25JN0fffrbxsufEBY1rP95hDu8wZQlWltdzhQHS5' +
        'CkODG28eImsifGJ6TMXx+r5ZPqdY+XlNcoS+ennmbMXx2CM3UdPzc' +
        'zOU1wUcnU+DLdL7wB6gXSP3pm6fvNHTExqTdmU2qXmiYaWGgFVc7L' +
        'RmQX5VLY4zYgSQ7xCCrM/mu4uLa7AEoJYHfk+yhrjwwem7s5uVau/' +
        'VVai7YeU/B5eyP5yvwRA86Ulf6oHSTtQG69M7/3go+G//v7n1es/j' +
        '58ewa1JS0iZRULvq/2w/wEDKADy');
  ArrowShaftOption := BitmapFromString(29, 6, 'meJwLTa+5evPe799/3rz7UNo0Rd0' +
        '6/P///409c2/eeaBk7AVkN/TMuXX3kYZtpIV75NlLN37//g0k7QPT' +
        'lUy8r9287xyQpmjiHZ5RB1QZmlIOVGbvn/zm7fvbdx9GZ1Qpmwc6+' +
        'iZ8+vJV2zkOqCClrEvXOV7NFmRFakmbulWwkqnv/qOn+2Ys1XCI7J' +
        '2+5NCJ80pGXr3TFnVMnK/jlDBt/robt+/PWrJO1Tywa/KC2UvW69s' +
        'G9kyev3nXwTsPngANUTB0B5LKxl6qFoGKYNeqmPoqm/qq24T9/PlL' +
        '1SJAxSJIydgdyFY08AA67PSF64oGrrfuPIhKLbl7/7GCvsvla7d9o' +
        'gouXr2dX9Mbl1Nv7RkPMlbfDWSsqa+iqbesnhNIxNgLqFHVxPfnr1' +
        '9qFgGKRp5q5n7ff/xUNPFSMvG9euNeaFLZ+Su35PRcrty4k1beDXS' +
        '2imkAULFrcKaBS9SaTXuBhiiZ+gBJVTNvWW07YOgB2bLa9vL67jJa' +
        'loeOneuaMl9O3xXou4PHzsjpOinouwMD5PHT5y09MxQMPNonzHvx6' +
        'k3b5MXa9jE17VO+ffvx6fOX+u5pIGONPcDGBmrYhkKsADpPXt9FQc' +
        '/Zyifp/KXrv37/PnX2om1ghpKpt6KJr2NAGlCNrXc80IM23vF//v4' +
        '1c4mVM3ADAAbBDtI=');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75)  then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y-10,0,0);
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(ArrowShaftOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        //MMouse(X+25,Y-60,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating shaft');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(ArrowShaftOption);
end;
function CreatePeg(IconLocation : TPoint) : boolean;
var
  X,Y,CreateOption,MiscOption,ArrowShaftOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  MiscOption := BitmapFromString(70, 10, 'meJxtVYESxRAM+8hhNu//f2OPRi' +
        'O17dyOqkojKp1XPq/U//XubXZ8mGvD7NbMs2Zbi1UaIZU6LWu2Ygn' +
        'je5BL9rrz1ZLjYQT1DDijG4ZHGaie50kBWIOl/8vVRlKWWu/b8LbO' +
        'zzq/0e7fsHfjPfu99bXZ/oxQDK22vvuRz6P0VkkCsg5QkSwzMgyax' +
        'U5LvR/7+r6YxXCy4eC1MbXVZsDGExkRyvgP2KOd3Xgs2BHPdkaUCn' +
        'YxkjPFE7de6QgPISODwTPKTjiN2CtaKlJYFguC01fS5tB3DNSpj6c' +
        'cfERLcM67T9WMJn7HIP2pQDCzZp26YLFjWtHMzsjg8+UvMU2fioRC' +
        'lWh1W8UzYsz0kYX07YIovco8JffE7408zNoJ4igP739GoODJrV/et' +
        'kXe7tobg2bHK6OaWaomP+c175cwptEWe8qJWuzOspDCJ1nRIEJVHS' +
        '9jgOQxkwD7wKMKcf+lWK8AtEzm3e6zfkN5Rn7jkuSoFiUT58JSrDk' +
        'y+KyfvuNKLaJSSeRXZdDrI5ZGDChZnNpZEiUwgibChXgF6LCpDrKU' +
        'qrtXQi2h0FKRtw+qmBVVIuBVohKWLF+vqnbia9JQhWCPm7b1wn49v' +
        'oTxB7UaLdM=');
  ArrowShaftOption := BitmapFromString(17, 8, 'meJxdUIkRwzAIG7IxGKfZfwwqEHF' +
        'JOM4nHoGwux9qngZw6NxhZWR+hlYoc5dkfeEE8dqp6yIGyEw10MZc' +
        '6SexP21Y5tXC72pR7E+BHoSvfKdQiTQKqpIUljalC+vrIPsxCmcmq' +
        '3dyRRwYkwPc15WY/Mny4mYezemLFA7nlv4bCH9jS/fT');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75)  then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y-10,0,0);
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(ArrowShaftOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        //MMouse(X+25,Y-60,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating peg');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(ArrowShaftOption);
end;
function Filet(IconLocation : TPoint) : boolean;
var
X,Y,FiletOption : Integer;
begin
  FiletOption := BitmapFromString(18, 8, 'meJxtkIESABEIRH+yEP7/N5zbQpd' +
        'rdt6YFFtjfIJLm0xi5KlSE6hCzUvKwlle6hUO+sLJL+4uLSYtQJ5y' +
        'sS4ULBt1/EXwYJSWoO2clc7Y3RWeDQ7vefcUTs1trDshU7vf5MzfH' +
        's5iz/aMhO/C1DMe+TED4A==');
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(FiletOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    Mouse(X+25,Y+5,0,0,true);
    wait(WaitAfterClick);
    result := true;
  end
  else
    result := false;
  FreeBitmap(FiletOption);
end;
function CreateShortBow(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,MiscOption,ShortBowOption : Integer;
begin
  CreateOption := BitmapFromString(31, 6, 'meJxtkT1PwlAUhn+iiBoMkSAfJlD' +
        'BBcSFgAEmxIATH25SdENnCQ4yyAKBRhJoWgL0B7RLkxbb1Dc5sWla' +
        'b+7w5vQ5z733VBSEXDbj9x1gHx36Ws0mgmVZnXZrt9sixyLni8W3Y' +
        'RiiIDCJBCo3ueu1KKKiKMpDo048lhdGgJPk9gZZKZeoPh5/ISMU8n' +
        'k0IkiShIyQYpKqqhJPjS5Y1/V/5XbxZ7+3/hZugko4dNZj2dHoE6e' +
        'Q1pa7YDD2WOjJTpj4wMmx82ie5+9rd7fFwkU85pU74at0iuM4zApX' +
        'ZbtPb699l3w6mbw89xAgXK2WZMBAgqeBweCdSNM0yemFa9WqLMto+' +
        'RgOiXHK49EIMHzdbjbpSwYV/HRN0zDtx06byPlsBsAL/wJgEEZ9');
  MiscOption := BitmapFromString(69, 10, 'meJzdlMtPU0EYxf9EsRQqRgPIQ6' +
        'jgApH3qxbUREDlVcGERi24wA0kQAK4gQUEQoUABRpKgEpSXFWSNi2' +
        '0qb/ki5Obub0buiChaSbfPTP3zDkz57u2vHu2u/UPHR0NDQyox48f' +
        '3oNQZDKZG3PKu7kw5LI1+u02GzXj+fnv3GXcrh3ft69v37ymZpyZm' +
        'TaK6Xa/SqVS6XT69OSkvbUFpKy0ZHtr6/rqCuPNjQ2C7O3tsoxjcV' +
        'ZVaXYaG14eh0LMRqNRrl7wCZ/vz8UFoNvlyspQUV52sL8PwkitHY6' +
        'VNpmqflq5uLhAzdjS1GQUg+zvkxMUrq7OSCRCsba2+mNqKv9+Xk+3' +
        'OxwOCwIzRUdbG6o0O6wBp6hxVsdiMcG/eL0w4AU9WRn8m5tYpmD85' +
        'fdntWPWpqY21tcZsamJ8YwMc6rzc7PPa2tkPSQoMd4vSOb/T+QZGY' +
        'ofP0LSysoyvhSuGJQwjUHtwkid1Y5Zm5ryjo/39/X+XFoyJx/v6EH' +
        'M8NCglR1Hgd2qd4LBYF/vu67ODjJj7illR2NQu9DOyWTS+FahPd9K' +
        'm1pW/qQUp9JBWlQkBnz9Li//yj3KFRMMCRvBEATZh4cHGgPCiNnDB' +
        'w6SbGXHzEDAJGzgEjZptCJHIY9W2ozkuzs78n3TGvns7JR2g03epW' +
        '1ZySN4/Ys6OQo0IJus1j5zagyfPJ5EIkHXfB4btbJjZuAquVZ2CQQ' +
        'CzIJIo8XjcTJmpe2O/f8B720Fug==');
  ShortBowOption := BitmapFromString(49, 6, 'meJxtkllLQlEUhX9iZkaPZVlaVFT' +
        'QbIPDe2Xa9KBYVlBQ9lD9hMTICmfRnAosMMw3TbEPNlziei+Xwzqb' +
        'xTqLtbbTYW+1Wu12u1gorK2u6HU9nU5nZ3vr4+OducNmYzJqGkklk' +
        '1w5wcI5OjwolYqC+QDKz3XCYsnn87lsVvjdCm+5HBzA4sI8/JWlJT' +
        'CTWq3222yen51ytW1uVCoVEQycHPf16vCDCJPI09NpIADgfI5EhON' +
        '02OEI/u9HJpcXFwB0HsNhTQWA3+cDwCSN4PUV+OTYfxMM7u95MHZ/' +
        'dzs9NakIylvKc9iWCSdYk6OypOJ3KxBIPB4DEPW61UopYFKdm52Rf' +
        'PBcLpc97l3VEypLBr2+0WhocjQtKfxuBelueXEhnU4JJnbiAuMEDH' +
        'C7XPX6j+ZzRC2xU7FSnMJhDwf6DSpL0NgZSgmFHjQVpLuvz0+pj/O' +
        '7WvV5vbJdRIcsayPeui0hnslkICQSCdOwUcV5fXmRLlTrjWwsGjUO' +
        'DWoqSHcwx81jYPOoCQ9C/gP99vXx');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y-30,0,0);
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(ShortBowOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        MMouse(X+25,Y-20,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating short bow');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(ShortBowOption);
  FreeBitmap(MiscOption);
end;
function CreateBow(IconLocation : TPoint) : boolean;
var
X,Y,CreateOption,MiscOption,ShortBowOption : Integer;
begin
  CreateOption := BitmapFromString(31, 6, 'meJxtkT1PwlAUhn+iiBoMkSAfJlD' +
        'BBcSFgAEmxIATH25SdENnCQ4yyAKBRhJoWgL0B7RLkxbb1Dc5sWla' +
        'b+7w5vQ5z733VBSEXDbj9x1gHx36Ws0mgmVZnXZrt9sixyLni8W3Y' +
        'RiiIDCJBCo3ueu1KKKiKMpDo048lhdGgJPk9gZZKZeoPh5/ISMU8n' +
        'k0IkiShIyQYpKqqhJPjS5Y1/V/5XbxZ7+3/hZugko4dNZj2dHoE6e' +
        'Q1pa7YDD2WOjJTpj4wMmx82ie5+9rd7fFwkU85pU74at0iuM4zApX' +
        'ZbtPb699l3w6mbw89xAgXK2WZMBAgqeBweCdSNM0yemFa9WqLMto+' +
        'RgOiXHK49EIMHzdbjbpSwYV/HRN0zDtx06byPlsBsAL/wJgEEZ9');
  MiscOption := BitmapFromString(69, 10, 'meJzdlMtPU0EYxf9EsRQqRgPIQ6' +
        'jgApH3qxbUREDlVcGERi24wA0kQAK4gQUEQoUABRpKgEpSXFWSNi2' +
        '0qb/ki5Obub0buiChaSbfPTP3zDkz57u2vHu2u/UPHR0NDQyox48f' +
        '3oNQZDKZG3PKu7kw5LI1+u02GzXj+fnv3GXcrh3ft69v37ymZpyZm' +
        'TaK6Xa/SqVS6XT69OSkvbUFpKy0ZHtr6/rqCuPNjQ2C7O3tsoxjcV' +
        'ZVaXYaG14eh0LMRqNRrl7wCZ/vz8UFoNvlyspQUV52sL8PwkitHY6' +
        'VNpmqflq5uLhAzdjS1GQUg+zvkxMUrq7OSCRCsba2+mNqKv9+Xk+3' +
        'OxwOCwIzRUdbG6o0O6wBp6hxVsdiMcG/eL0w4AU9WRn8m5tYpmD85' +
        'fdntWPWpqY21tcZsamJ8YwMc6rzc7PPa2tkPSQoMd4vSOb/T+QZGY' +
        'ofP0LSysoyvhSuGJQwjUHtwkid1Y5Zm5ryjo/39/X+XFoyJx/v6EH' +
        'M8NCglR1Hgd2qd4LBYF/vu67ODjJj7illR2NQu9DOyWTS+FahPd9K' +
        'm1pW/qQUp9JBWlQkBnz9Li//yj3KFRMMCRvBEATZh4cHGgPCiNnDB' +
        'w6SbGXHzEDAJGzgEjZptCJHIY9W2ozkuzs78n3TGvns7JR2g03epW' +
        '1ZySN4/Ys6OQo0IJus1j5zagyfPJ5EIkHXfB4btbJjZuAquVZ2CQQ' +
        'CzIJIo8XjcTJmpe2O/f8B720Fug==');
  ShortBowOption := BitmapFromString(27, 8, 'meJy9kctKw1AURT8xfYhTpQ9bdaK' +
        'INaIiKP5G7VtU0PgVlUrjoLFpa2MaqYMMApk2JMQFB6SUWnAiXDbr' +
        'bjaHu+9Rkql0Qpk/cRwvOH86yr8M3N0u2rZtjceFXBYHHZhmGIaoO' +
        'B+WRQZQS4fkT1QVxvF9f+nA+7tboFmvvXQ6gN7tthoNAH3VdYFq5R' +
        'og6Uwm2uMDXK9VnzRt6cC1ZAJAgyAA0AWHx7wZBvDpOOdnp1/TKUy' +
        'jg/29FQPX06nZbDY/8MeR1sdHpeFwIHx1ecFTf/tDevFX1Hlut3G4' +
        'SuWbVlMqS2vXdaU46nlepVxesRS6GL1eZnNDlvI+GrEUs9/PZzMSI' +
        '0Nyp7AFF/O5KIok/A0hxTeP');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y-30,0,0);
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(ShortBowOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        MMouse(X+25,Y-20,0,0);
        Mouse(X+25,Y+5,0,0,true);
        writeln('creating short bow');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(ShortBowOption);
  FreeBitmap(MiscOption);
end;
function CreateKindling : boolean;
var
Active : TPoint;
X,Y,CreateOption,LogIcon,MiscOption,KindlingOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  MiscOption := BitmapFromString(70, 10, 'meJxtVYESxRAM+8hhNu//f2OPRi' +
        'O17dyOqkojKp1XPq/U//XubXZ8mGvD7NbMs2Zbi1UaIZU6LWu2Ygn' +
        'je5BL9rrz1ZLjYQT1DDijG4ZHGaie50kBWIOl/8vVRlKWWu/b8LbO' +
        'zzq/0e7fsHfjPfu99bXZ/oxQDK22vvuRz6P0VkkCsg5QkSwzMgyax' +
        'U5LvR/7+r6YxXCy4eC1MbXVZsDGExkRyvgP2KOd3Xgs2BHPdkaUCn' +
        'YxkjPFE7de6QgPISODwTPKTjiN2CtaKlJYFguC01fS5tB3DNSpj6c' +
        'cfERLcM67T9WMJn7HIP2pQDCzZp26YLFjWtHMzsjg8+UvMU2fioRC' +
        'lWh1W8UzYsz0kYX07YIovco8JffE7408zNoJ4igP739GoODJrV/et' +
        'kXe7tobg2bHK6OaWaomP+c175cwptEWe8qJWuzOspDCJ1nRIEJVHS' +
        '9jgOQxkwD7wKMKcf+lWK8AtEzm3e6zfkN5Rn7jkuSoFiUT58JSrDk' +
        'y+KyfvuNKLaJSSeRXZdDrI5ZGDChZnNpZEiUwgibChXgF6LCpDrKU' +
        'qrtXQi2h0FKRtw+qmBVVIuBVohKWLF+vqnbia9JQhWCPm7b1wn49v' +
        'oTxB7UaLdM=');
  KindlingOption := BitmapFromString(34, 10, 'meJx1UwkOAyEIfOQqRXf//w3LIS' +
        'OrrTEEzTAwiGOM+mmVu9shR/Flt3s63Kk91B+17ZZtGLVyqVaQdk8' +
        'WIjA7Ps5ZbC9aBQjs/ulT4pGQHKg8xMHJfuNHxYtvYKRzexGPtDzE' +
        'JSjz1NKhxXVhyaVlvxGenRIdQ51ZLCrPIT91LUITuBUsEgLDEFiID' +
        'x7+myXwV1gwnFpgNy3zpVK13hb3/clO7TU6tjVk2pixnGW9zpElqu' +
        'LFEGX7UmmpM/AlBP1ZL5KQlCfBRndrC/D4KXPwYqox7Wsy431fk+8' +
        'hFhv/xUm0vd5kKBV72UgU02UqWt7vLJMHzJqlPzNj/KnVq0pfV5Mm' +
        'vw==');
  LogIcon := BitmapFromString(14, 14, 'meJxlkktOwzAQhjkJSBSVkEdToq' +
        'RpUruJkiamFLFhyQJxFhbcgJtwJ47BNww1UbEsazT69T9mHJsxMS6' +
        'qh3DdRfXupmy5waqJNuPZ8dAJyy6x+19k1cebEcBiKx0A7uX9+e2T' +
        'S50294l19HnhDMrW8yjs9eOLgksHTiGxe2gTe0cHgIdprUgMoAhsn' +
        'pnrYquEKjqFzdLytntctg+5e0rbg8cowMNiM0qEqicanN6bArSgOc' +
        '8tGKQxqQPxxqaiEsQ4gqN4ldX/jR29rXkvF6vZssLniegflXXw6Bi' +
        '1oInodG6c8yC9CDPYUIQwKBq2pkg/ZFlHeyAgKWTCxv1seZAVF433' +
        'qf4lI8h6R1Iiy9IBV70uXUXpy9+oB1bAcES0aCjmuaH4BlsIlQA=');
  result := false;
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(LogIcon,X,Y,Active.x,0,Width-1,Active.y,85) then
    begin
      Mouse(X+25,Y+5,0,0,false);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(CreateOption,X,Y,Active.x,0,Width-1,Active.y,75) then
      begin
        MMouse(X+25,Y+5,0,0);
        wait(WaitAfterClick);
        if FindBitmapToleranceIn(MiscOption,X,Y,0,0,Width-1,Height-1,75) then
        begin
          MMouse(X+25,Y+5,0,0);
          wait(WaitAfterClick);
          if FindBitmapToleranceIn(KindlingOption,X,Y,0,0,Width-1,Height-1,75) then
          begin
            Mouse(X+25,Y+5,0,0,true);
            writeln('creating kindling');
            result := true;
          end;
        end;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(KindlingOption);
  FreeBitmap(MiscOption);
  FreeBitmap(LogIcon);
end;

function CreateMortar : boolean;
var
Active,ClayPoint,SandPoint,MousePos : TPoint;
Clay,Sand : integer;
X,Y,Create,Miscellaneous,Mortar : integer;
begin
  result := false;
  Clay := BitmapFromString(7, 6, 'meJxjYGCYMXsyMmLAEMnISkETQRNH' +
        'ZgAR0AQIAxkxYAMA/rMykQ==');
  Sand := BitmapFromString(7, 6, 'meJxjYGAw27wfjsQXT2ZAEgFygaRy' +
        '9lQgA8JGRkBxiBpkBhABTYAwkBEDNgAAR88tKA==');
  Create := BitmapFromString(31, 6, 'meJxtkT1PwlAUhn+iiBoMkSAfJlD' +
        'BBcSFgAEmxIATH25SdENnCQ4yyAKBRhJoWgL0B7RLkxbb1Dc5sWla' +
        'b+7w5vQ5z733VBSEXDbj9x1gHx36Ws0mgmVZnXZrt9sixyLni8W3Y' +
        'RiiIDCJBCo3ueu1KKKiKMpDo048lhdGgJPk9gZZKZeoPh5/ISMU8n' +
        'k0IkiShIyQYpKqqhJPjS5Y1/V/5XbxZ7+3/hZugko4dNZj2dHoE6e' +
        'Q1pa7YDD2WOjJTpj4wMmx82ie5+9rd7fFwkU85pU74at0iuM4zApX' +
        'ZbtPb699l3w6mbw89xAgXK2WZMBAgqeBweCdSNM0yemFa9WqLMto+' +
        'RgOiXHK49EIMHzdbjbpSwYV/HRN0zDtx06byPlsBsAL/wJgEEZ9');
  Miscellaneous := BitmapFromString(69, 10, 'meJzdlMtPU0EYxf9EsRQqRgPIQ6' +
        'jgApH3qxbUREDlVcGERi24wA0kQAK4gQUEQoUABRpKgEpSXFWSNi2' +
        '0qb/ki5Obub0buiChaSbfPTP3zDkz57u2vHu2u/UPHR0NDQyox48f' +
        '3oNQZDKZG3PKu7kw5LI1+u02GzXj+fnv3GXcrh3ft69v37ymZpyZm' +
        'TaK6Xa/SqVS6XT69OSkvbUFpKy0ZHtr6/rqCuPNjQ2C7O3tsoxjcV' +
        'ZVaXYaG14eh0LMRqNRrl7wCZ/vz8UFoNvlyspQUV52sL8PwkitHY6' +
        'VNpmqflq5uLhAzdjS1GQUg+zvkxMUrq7OSCRCsba2+mNqKv9+Xk+3' +
        'OxwOCwIzRUdbG6o0O6wBp6hxVsdiMcG/eL0w4AU9WRn8m5tYpmD85' +
        'fdntWPWpqY21tcZsamJ8YwMc6rzc7PPa2tkPSQoMd4vSOb/T+QZGY' +
        'ofP0LSysoyvhSuGJQwjUHtwkid1Y5Zm5ryjo/39/X+XFoyJx/v6EH' +
        'M8NCglR1Hgd2qd4LBYF/vu67ODjJj7illR2NQu9DOyWTS+FahPd9K' +
        'm1pW/qQUp9JBWlQkBnz9Li//yj3KFRMMCRvBEATZh4cHGgPCiNnDB' +
        'w6SbGXHzEDAJGzgEjZptCJHIY9W2ozkuzs78n3TGvns7JR2g03epW' +
        '1ZySN4/Ys6OQo0IJus1j5zagyfPJ5EIkHXfB4btbJjZuAquVZ2CQQ' +
        'CzIJIo8XjcTJmpe2O/f8B720Fug==');
  Mortar := BitmapFromString(30, 6, 'meJyNkk1LAlEYhX9iNhpGFGFZYbS' +
        '1NqKprcyoVn609eM/5C7XTrYZY3AEnT8wm4EZm+H2wAvDZSpouLw8' +
        'HM6c+3K4Sqnnp8ev7fal3+v3ukCzXjcyO2fF08/FIooiJoyilMKw2' +
        'ayF+YCb6/LKcbB5nkeObgParVbp4txZLu+aDWKxYTBns+FgADDfTV' +
        'N+wZDdzQgzOa7rVisV4Oqy5Pu+bgNSZgGWF50Jiy6Kbj4+OuTq6fS' +
        'NK0T8K/Bncs4wwjDUDTrbtv3Qvr+tVWksSf41MAEakDbGo2HSRpIc' +
        'x3F+LycL0MPBfn4yef1nMjuwD51bllU8KaSSP+Zzqajb6QRBQMM8g' +
        'FTyN2OoQrs=');
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(Clay,ClayPoint.X,ClayPoint.Y,Active.x,0,Width-1,Active.y,75) and
    FindBitmapToleranceIn(Sand,SandPoint.X,SandPoint.Y,Active.x,0,Width-1,Active.y,75) then
    begin
      {
      if not IsActive(Clay) then
      begin
        MMouse(ClayPoint.x,ClayPoint.y,0,0);
        GetMousePos(MousePos.x,MousePos.y);
        ClickMouse(MousePos.x,MousePos.y,1);
        wait(100);
        ClickMouse(MousePos.x,MousePos.y,1);
      end
      else
        writeln('clay is active');
      }
      //writeln(inttostr(sandpoint.x) + ' ' + inttostr(sandpoint.y));
      Mouse(SandPoint.X+25,SandPoint.Y+5,0,0,false);
      wait(200);
      if FindBitmapToleranceIn(Create,X,Y,Active.x,0,Width-1,Height-1,125) then
      begin
        MMouse(X+25,Y+5,0,0);
        wait(200);
        if FindBitmapToleranceIn(Miscellaneous,X,Y,Active.x,0,Width-1,Height-1,125) then
        begin
          MMouse(X+25,Y+5,0,0);
          wait(200);
          if FindBitmapToleranceIn(Mortar,X,Y,Active.x,0,Width-1,Height-1,125) then
          begin
            Mouse(X+25,Y+5,0,0,true);
            result := true;
          end else
            writeln('could not find mortar');
        end else
          writeln('could not find Miscellaneous');
      end else
        writeln('could not find Create');
    end else
      writeln('could not find sand or clay');
  end;
  FreeBitmap(Clay);
  FreeBitmap(Sand);
  FreeBitmap(Create);
  FreeBitmap(Miscellaneous);
  FreeBitmap(Mortar);
end;
function CreateDoorLock : boolean;
var
SmallAnvilIcon,CreateOption,LocksOption,DoorLockOption,X,Y : integer;
Active : TPoint;
begin
  result := false;
  SmallAnvilIcon := BitmapFromString(16, 11, 'meJyFkGsOgjAQhD2KQZQqEJGXUN' +
        'AGQeN/jsAhepQeoYfyMg5sgqSgTjZNoTPbb2sd09U/OfHVSYR9yu2' +
        'Q41Mp9fqpTzAR5IfaQWpJRlBKuWibCp6u62A+8HqMyO+iziwVdpBv' +
        'gowi1MQQOdF2n93AvwsLlFfc8bOdqXfmNcxYnajchpyCHm9wpLWeM' +
        'ozAOPWKh395YmP56dqP5+aRrcdOBMhRdAWKDQ8LAAOekADg8gYXsX' +
        'OFEWAGnjsgzYXpYOiHjUrs3+JGpp0=');
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  LocksOption := BitmapFromString(32, 12, 'meJxtU4mRxDAIK3L9O/23kcOABL' +
        'u+jMeDifgE1LGqnjb3uddTx9aj+rlVjyeQzfWLMLlLn/rc1YUjhzn' +
        'xfRqyBMzB6V4OUHBpo0D41C73+Ssy9O/7OgyH5uE8JWBRxOquTrPa' +
        'woMTMol86gUO3vAr0yJWKW7cDnbSThVf+Rs/WpR9NEkafxqHR1BmC' +
        'CAzX/ycMyzQcQKNhbA7MlerqCIBJJkjYwzsKfzEYLhmB3vroYblW6' +
        'qGZ9xIg+MED7f/Shn+s61ljrhPS1HYtZY8EPZT4J2/ycYqE4YA84E' +
        'dSa2M7mgL7Pun42h3FIJOkaLPmf/uxWKnuF/+vH79blwaae5LXgoJ' +
        'IXOlsWzdTOgWuuRYWHz3g6IocPxyDn9NbQmu');
  DoorLockOption := BitmapFromString(47, 10, 'meJxlVAmSwCAIe6Tr7f7/GV0kEN' +
        'HtMI5NOWIK5tp/aKVxn/vMbbzWZ4k43Gp/wB0uBoc2Tv7arIobvpq' +
        'zl8jNqnzfF6sw886zY1+GZawdO1ZRnhKueabTlnVtN7Dt+qq4FWIe' +
        'dZAqKHqRucInVTp7HrzPKKOER5FT2cnT3jdZUznKwJOaFE8r4KcPN' +
        'hE5/PXUeEgbUkCfrcxY7n+cN1vlQAT/a28c51rHr6Zd2LCEvIoJjo' +
        'TA1axiJKaeRsYZmqREYrj5BJziUNuUKwhDHyrPlY2RoaFn8J5Z0Zk' +
        'S5c4OubrrMHGjROKcnAaOFtvgoRejvGfmzfyEUwdhG2kHfFIfpCVb' +
        'ZsAsPDrjb9InKDypAKW+6Plg8izJ2/jcJ84/ik/Ez2isngYOk7tg/' +
        '8NLGLQ4EaTBuhDkvd8CSV5Z951jw5tsfqvfljbOgqidid6vufqe+H' +
        'aLt+Ife+Gufg==');
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(SmallAnvilIcon,X,Y,Active.x,0,Width-1,Active.y,75) then
    begin
       Mouse(X+5,Y+5,0,0,false);
       wait(WaitAfterClick);
       if FindBitmapToleranceIn(CreateOption,X,Y,Active.x,0,Width-1,Active.y,75) then
       begin
         MMouse(X+25,Y+5,0,0);
         wait(WaitAfterClick);
         if FindBitmapToleranceIn(LocksOption,X,Y,Active.x,0,Width-1,Active.y,75) then
         begin
           MMouse(X+25,Y-10,0,0);
           MMouse(X+25,Y+5,0,0);
           wait(WaitAfterClick);
           if FindBitmapToleranceIn(DoorLockOption,X,Y,Active.x,0,Width-1,Active.y,75) then
           begin
             Mouse(X+25,Y+5,0,0,true);
             writeln('creating lock');
             result := true;
           end
           else
             writeln('could not find Door Lock option');
         end
         else
           writeln('could not find Locks option');
       end
       else
         writeln('could not find Create option');
    end
    else
      writeln('could not find small anvil');
  end;
  if result = false then
    Mouse(Width/2,Height/2,15,15,true);
  FreeBitmap(SmallAnvilIcon);
  FreeBitmap(CreateOption);
  FreeBitmap(LocksOption);
  FreeBitmap(DoorLockOption);
end;
function CreateBall : boolean;
var
SmallAnvilIcon,CreateOption,LocksOption,DoorLockOption,X,Y : integer;
Active : TPoint;
begin
  result := false;
  SmallAnvilIcon := BitmapFromString(16, 11, 'meJwTEJVkIAQERCXhCMidPn36bb' +
        'wAWSNEPRAEg8F0bABNY3l5OVZlyACoJjk5GW4FREs5boDmEYgWiCF' +
        'oANPLcC3BGACrSrj65cuXI7sB7mBiFMPdhkcL0AFojifoJPyRC0QA' +
        'zrOTxA==');
  CreateOption  := BitmapFromString(31, 8, 'meJxTNPZu6pn14tW77z9+7tp/1Mw' +
        'rXc0yTNUsQN0yTMUsQMsqXFLZUtUqUMc5WdnUT8nQQ8nMT8UiSMU8' +
        'QMUyRMnER8nYU17fZdeB41IaFjJadvL67jJalkomvqpWwRp2kcV1f' +
        'ecuXbfxSVG18J82b/XWvUe1bMNULUL13bM17SIVjNyVzX0UjLwU9F' +
        '3kDFxldZwVDT3ldJyVjIHGeiuDDPdRswr6//+/vK6TgqGHnJ6zgp6' +
        'zoqmvgpGnumX4pWu3/WLyFA09VMy8FQ1ca1onyRs4AxXXtU65eeeB' +
        'hk2kpWf8ybOXf//+fenKDRu3cFXr0IC4vCvX7wBF3rx9X1zfJ6fl9' +
        'B8M5HRdLNziT567AlJ89ZaTX/Lv33+UjNwVDN2VTX0VTb3lDFwUjT' +
        '2BKpOLWpRNvYGO2b77YEJ2lZp1eER6+alzVxSNPW7fexSbXSdv4Or' +
        'gE/fp8xcVs0Cgei3bCKCDd+w9kphbB2REZVQBnfT9xw9Vcz9NhxgF' +
        'Aw9gSCoaeSib+QEVAwMTaIuMtuPPnz//wwDQSYomnkbOUd0T523ee' +
        'ejO/cdAQUVDH5DhjvFKpr4/f/5CVrx1z9HQ1BpVqxA1+yh9j7SIrA' +
        'ZZA0dQGOq7KZl6Kpv5A9WrmXvJ67kqmfgrmwcpGntfvHqroLYvJrv' +
        'GyjcJqFLFIhhIKhi4Ab0JVKxpE6poFqDrlgx0sHtI5vEzlx2CCzRt' +
        'wnqmLpq1cK2cnitQsbIp0BfuwGA8cPR079RFqhaBWSVN5y7fVLUIA' +
        'ZoADBAt64CVG3aBVJr5/fn7V83MW07f7eCxc/3Tl8rru+aWd5y/dF' +
        '3Z3D+zqPHV67dALWs279WyCNK0iYBoUTTyVtB3t/CMASYnoOyN2w+' +
        'cA1KByayuY+bXb98/ff5a3zkDFCwGbkdPngcqkNN3tfRMPH/5BpB9' +
        '/dY916A0AGkkXIg=');
  LocksOption := BitmapFromString(37, 8, 'meJw9UllPE2EU/R8inb1DHaCzdKZ' +
        '7KVC6TKeFWlqKZRNESYW4RyMoionGLRiJW1xiYjT6ZmJiFDWAIiJS' +
        'tBBAQFCJjxojRrZi8E5UvoebL+fu59zV1X8vnV5par1MO+I478ZYN' +
        'ymVkEJgg61ca4mhBgWTlIwsK8Z5KGkjIchIjou2RyhjCBMUTPAjen' +
        'cGk4fzfpRX6LxNhFhMmcM4L2vNpaQYJMSgzhnv7OojDUFopLOX6X1' +
        'ba3e2LSwu1e89yTgqGEccwighoMktwjmZcW1hCqrXM07MoOAGP2ks' +
        'IaQQynspUwjjZdxUgrDuDJ0VySlcn23PZPIIKYgLCmUK05YwLsiUs' +
        'VhrLYNGWdZysKQUhACM89bvOwk7ZjlitnBjcmQS/qnR9za5AqY1yz' +
        'W9/UNLS8vTn76EqnYRYsjiqxpMjaXT6cF3o9ZAbQaTD6WOnL428eE' +
        'TZghEtx0enZgB79dv3/e2nqOkkv8srgIzhAhjK6RJBRlX3aNnvfV7' +
        'jmOCryJx+HVymBCKHz7p7rhyixB8dTuPTU1/RjlvV+/AqfM3UM53q' +
        'uN698sBnPNDbvX2FtIYhJWnPs7GE4e01mhRpGHu5y+C94JXwzjBor' +
        'yPskShAsKpICb6YYu1YZbTaUKSAcFZF9CIcG7aHgN+VIT3AGmYqCw' +
        'tL4OOEExIAVRQoCCbFzlz4eaDxz1TM7NqC67wrxcsyEHby0CjysQB' +
        'IBAX1VKMPaLRF2ZmF6B6N4wBCG0rBTkQ1oPqvbSjHBBQQZNdQErKw' +
        'sIibY+qo4KyljDG+t6OjO9u7ahMNNvkasApUT0SjPeof1OIMpYmmi' +
        '/AqWxuaiHEQE/fUPvl2ygvN+4/PjQ8nsnkP+3pb79yB3SPNxwEMkm' +
        'puKcvefbSrSx7RfvVu8/7kkiuWgpyNaxP56yBffNDtTnOyL37nep5' +
        'mDaurPwmONcaabBX7Y6jOnN0ndZmkWuGUmMw//jkDJCPch6hIPbqT' +
        'Qqkn5z+HIg3opwbYlJjU5CVHJ4wFsU0rBuKaC1lCFuEsp6WExfn5x' +
        'd/zP1sa7+utjMEXrxSL+0P+8KmUw==');
  DoorLockOption := BitmapFromString(15, 8, 'meJz7//+/nJatrJ6TgpGbkqGrtLa' +
        'drLaToqGnnLaDkpGXuLq5konP////Vc1D/oOBopGXsqmviqm/ooGH' +
        'jJqljIa1mk24oqmnspmvorGXrLYjUI28oStEsWNgytUbdy5dveUQl' +
        'C1v7BmSVHblxu3fv3+/efu+sLZb1ToYqEbNKgyieOL0RZLqFl2T5+' +
        '09dErdKvT23YexebXq5iGesYWfPn+R1QWZrGzuD1GsZhmobOSlZOL' +
        '+8+cvVfNQU4/4vulLNu86fPvuA6CsnL4byM0mfhDFCnouSsZequZB' +
        '33/8VDTxuXT9Tm5Vd1xmtX1QOlBWVtcZSKqYQU0+dOysbWDGlLkrd' +
        'x08qWoRBDTfKSDJyCVm1aa9QFkdW5Brlcx8IIpdQnNu3X104swlM9' +
        'doYEDVdk7/+u070LUN3TNB9hp6gpxqEQAkAUOtw1s=');
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(SmallAnvilIcon,X,Y,Active.x,0,Width-1,Active.y,75) then
    begin
       Mouse(X+5,Y+5,0,0,false);
       wait(WaitAfterClick);
       if FindBitmapToleranceIn(CreateOption,X,Y,Active.x,0,Width-1,Active.y,75) then
       begin
         MMouse(X+25,Y+5,0,0);
         wait(WaitAfterClick);
         if FindBitmapToleranceIn(LocksOption,X,Y,Active.x,0,Width-1,Active.y,75) then
         begin
           MMouse(X+25,Y+5,0,0);
           wait(WaitAfterClick);
           if FindBitmapToleranceIn(DoorLockOption,X,Y,Active.x,0,Width-1,Active.y,75) then
           begin
             MMouse(X+25,Y-10,0,0);
             Mouse(X+25,Y+5,0,0,true);
             writeln('creating ball');
             result := true;
           end
           else
             writeln('could not find ball option');
         end
         else
           writeln('could not find decorations option');
       end
       else
         writeln('could not find Create option');
    end
    else
      writeln('could not find small anvil');
  end;
  if result = false then
    Mouse(Width/2,Height/2,15,15,true);
  FreeBitmap(SmallAnvilIcon);
  FreeBitmap(CreateOption);
  FreeBitmap(LocksOption);
  FreeBitmap(DoorLockOption);
end;
function CreateHuntingArrowHead : boolean;
var
SmallAnvilIcon,CreateOption,MiscOption,ArrowHeadOption,X,Y : integer;
Active : TPoint;
begin
  result := false;
  SmallAnvilIcon := BitmapFromString(16, 11, 'meJwTEJVkIAQERCXhCMidPn36bb' +
        'wAWSNEPRAEg8F0bABNY3l5OVZlyACoJjk5GW4FREs5boDmEYgWiCF' +
        'oANPLcC3BGACrSrj65cuXI7sB7mBiFMPdhkcL0AFojifoJPyRC0QA' +
        'zrOTxA==');
  CreateOption := BitmapFromString(24, 6, 'meJz7//9/XeuUm3ceaNhEWnrGnzx' +
        '7+ffv35eu3LBxC1e1Dg2Iy7ty/Q5Q5M3b98X1fXJaTv/BQE7XxdI7' +
        '8cSZS79//7l09aZ9YApQMLmoRdnUW8HQY/vugwnZVWrW4RHp5afOX' +
        'VE09rh971Fsdp28gauDT9ynz19UzAKB6rVsIxRNfXfsPZKYWyev7x' +
        'KdWQNUDBRXMvZUNPaU0Xb8+fPnfxgAukHRxNPIOap74rzNOw/duf8' +
        'YKKho6AMyxzFeydT3589fcMW/fv8GkvL6bkqmnspm/kApNXMveT1X' +
        'JRN/ZfMgRWPvi1dvFdT2xWTXWPkmAVWqWAQDSQUDN6DjgYrVzf0VT' +
        'f3lDd1ltGyB4sqmAYpG7kAvHzh6unfqIlWLwKySpnOXb6pahAAVA3' +
        '2kZR2wcsMukEozvz9//6qZecvpux08dq5n6gJZXcfcksbzl29AZBW' +
        'NvBX03S08Y85dug7Ue+P2A+eAVCUT37qOmV+/ff/0+Wt95wyQvwzc' +
        'jp48D1Qgp+9q6ZkI1A5SfOehe1QOAJMg8hw=');
  MiscOption := BitmapFromString(43, 8, 'meJw1U49PE3cU/zs2j1573ystpb/' +
        'vem0PqG3p7+v1lx3VNgKlcVkj3YjWCQ5ZjIuyjEwHajaTZboENJot' +
        'xriZOJaMkIwQI9lAhbXl9zQmKkbdLygLe99r9s3l5b7v3nufz3ufd' +
        '3PzlaMnh2kubvLkGlyZD8+Ozj0skzrXzs4Osopqx16VPSm3ROCd0D' +
        'plOrfCGECMKDf4GpwZBH6LiLiozOChrTHSGJTp3XX6VsilbTGw9fY' +
        'ExQqIDSFTCJmDlClIMWEoQhq96uZ9kEjo3BA2N1/We7uQTURm39Lq' +
        'Y/AouZjK3kZzMQ2fegPZlXxc25oDOMoUoLgIbUsAHG1PUmyYYoKkw' +
        'aNghTfVNkLjIA1+QmOHCgAEVm70UEyoEbCYMDz1TW1wpa1xQuupa9' +
        'xN8wloBMI+Gfkq//4g4iL54unL177DBGxvgW1w7MsW+qvV6vb2vwu' +
        'lpbbc4Tptq9WbmZy6t7m5tbiynswWAahJzE3PzEHY7MOSQ2iXSxOQ' +
        'm4Ngte7OPdkjDxYq8PXZ8xfFE8MUK4J/aOTS+qMn4OwsDMDVEe68+' +
        'u1tmhOufPN9MnsIQzvTYEmjb3Nr68znowpTaH++b3XtEaFuujMxfe' +
        '7LMcoc6Cr0lxdXKYt4+4fJjoO9iBVTueL0vfsUG8EEDF6wCoNnceX' +
        '3TL4fMX53PPfq9R+kNPPBc1+rHan2g9DdtjQo3/jEFKi5UF6WGT1Y' +
        'fXsCpzOhvpOfPX2+cfnqjVDmMMkEaS4KvSNWUNoToCOoCQTAs/P/g' +
        'abk5hDOtWAJkEXgfB2ffnHl1p3JyvIani2PK6t2J+p0LuirlgXQH5' +
        '8ffbd38PrNcYU5gCmxgkQgSDS69na9N3T+Unlp7dipCyA3wNFchNS' +
        '01tYPWcLgUbGCxtUBZJS2BLLGpZoRqUL41wflQu9ge/fxlmgOe4x+' +
        'XN/kpa1RUsKCo25JN0fffrbxsufEBY1rP95hDu8wZQlWltdzhQHS5' +
        'CkODG28eImsifGJ6TMXx+r5ZPqdY+XlNcoS+ennmbMXx2CM3UdPzc' +
        'zOU1wUcnU+DLdL7wB6gXSP3pm6fvNHTExqTdmU2qXmiYaWGgFVc7L' +
        'RmQX5VLY4zYgSQ7xCCrM/mu4uLa7AEoJYHfk+yhrjwwem7s5uVau/' +
        'VVai7YeU/B5eyP5yvwRA86Ulf6oHSTtQG69M7/3go+G//v7n1es/j' +
        '58ewa1JS0iZRULvq/2w/wEDKADy');
  ArrowHeadOption := BitmapFromString(34, 6, 'meJz7//9/cW33vQdPfv/+nZTXqGU' +
        'f8f//f1WLUH33bE27SCBb2dwHSPZMnvf46Ytfv38nZNfI6Tj/BwNl' +
        'E5CUmlUQkOyeNBeiID6zQtHU18Ij5uLV2+8+fK7vnAFR3DV5vrKxZ' +
        '1J+HdAiRUN3oIimQ5SSvoe8gRvIKFM/INnaN1teyy4mtej37z8KRi' +
        'BxBX1XeT2QYjktJyDZPmEeUCQhpwFoiLyuy7bdh3qnLFTUd5k6fy3' +
        'EFiUjdwVDd2VTX5AWAxeQyZZByhZBisZeQLaMpi2Q1LCNkDf2VDHz' +
        'B7IVjUDi8gaucrog81XMAoGkjn0k0AsQhwEZP3/+UjT1Ujb11rQKh' +
        'Xrc1FfTIUbBwANsAohUMPFWMPRQswDZK6luAXKJia+aZYi8vguEDd' +
        'GlDLHUEBRuWo7xSqa+qhag0FMw9ATaomTkpmjso24dBrFFwzZK1Sp' +
        'EzT4KrDgWGLZJ+Y0a5r4Hj58BmQZxuZ6rkom/sjnIEBWLgD9//2pY' +
        'Byua+YG5wSCTDdyADoN4X9EsYOfB0xPmrDZw9D955hLEFnWbEG2HR' +
        'HWw11SMfeMyq4Bh++Xrt6qWiSCXgzWqWgTK6jgpmQeA/et9+PhZoG' +
        'shflEG2wUKQH03YLIBsfVdzV1jLl65+ezF68Scmp+/fgEAa9pO2A==');
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(SmallAnvilIcon,X,Y,Active.x,0,Width-1,Active.y,75) then
    begin
       Mouse(X+5,Y+5,0,0,false);
       wait(WaitAfterClick);
       if FindBitmapToleranceIn(CreateOption,X,Y,Active.x,0,Width-1,Active.y,75) then
       begin
         MMouse(X+25,Y+5,0,0);
         wait(WaitAfterClick);
         if FindBitmapToleranceIn(MiscOption,X,Y,Active.x,0,Width-1,Active.y,75) then
         begin
           MMouse(X+25,Y-30,0,0);
           MMouse(X+25,Y+5,0,0);
           wait(WaitAfterClick);
           if FindBitmapToleranceIn(ArrowHeadOption,X,Y,Active.x,0,Width-1,Active.y,75) then
           begin
             Mouse(X+25,Y+5,0,0,true);
             writeln('creating arrow head');
             result := true;
           end
           else
             writeln('could not find arrow head option');
         end
         else
           writeln('could not find misc option');
       end
       else
         writeln('could not find Create option');
    end
    else
      writeln('could not find small anvil');
  end;
  if result = false then
    Mouse(Width/2,Height/2,15,15,true);
  FreeBitmap(SmallAnvilIcon);
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(ArrowHeadOption);
end;
function CreateArmourChains : boolean;
var
CreateOption,MiscOption,ArmourChainsOption,X,Y : integer;
begin
  result := false;
  Mouse(Width/2,Height/2,0,0,false);
  wait(WaitAfterClick);
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  MiscOption := BitmapFromString(70, 10, 'meJxtVYESxRAM+8hhNu//f2OPRi' +
        'O17dyOqkojKp1XPq/U//XubXZ8mGvD7NbMs2Zbi1UaIZU6LWu2Ygn' +
        'je5BL9rrz1ZLjYQT1DDijG4ZHGaie50kBWIOl/8vVRlKWWu/b8LbO' +
        'zzq/0e7fsHfjPfu99bXZ/oxQDK22vvuRz6P0VkkCsg5QkSwzMgyax' +
        'U5LvR/7+r6YxXCy4eC1MbXVZsDGExkRyvgP2KOd3Xgs2BHPdkaUCn' +
        'YxkjPFE7de6QgPISODwTPKTjiN2CtaKlJYFguC01fS5tB3DNSpj6c' +
        'cfERLcM67T9WMJn7HIP2pQDCzZp26YLFjWtHMzsjg8+UvMU2fioRC' +
        'lWh1W8UzYsz0kYX07YIovco8JffE7408zNoJ4igP739GoODJrV/et' +
        'kXe7tobg2bHK6OaWaomP+c175cwptEWe8qJWuzOspDCJ1nRIEJVHS' +
        '9jgOQxkwD7wKMKcf+lWK8AtEzm3e6zfkN5Rn7jkuSoFiUT58JSrDk' +
        'y+KyfvuNKLaJSSeRXZdDrI5ZGDChZnNpZEiUwgibChXgF6LCpDrKU' +
        'qrtXQi2h0FKRtw+qmBVVIuBVohKWLF+vqnbia9JQhWCPm7b1wn49v' +
        'oTxB7UaLdM=');
  ArmourChainsOption := BitmapFromString(70, 8, 'meJx1VAuSxSAIO2S12tr7X8NVIiH' +
        '6ZjuOg5RPCGguT7aVbOX6jnU/7X4+2+fK2KF/v4y9NhpP2eNAeR5p' +
        '9iP33iORaZJ4TVR3HTaGsMbf8kz7PcWyN5fkFQ2veTTNdRcT6hWat' +
        'SM+vXhctXhFaV/D0VbRjKgoO3V5UfcN0sgbGJ7C1AzkDbkAXmsBwu' +
        '4fYEzBqFM5lGDGldDTPjtI+IJedp8l4ONxIFQApw16JBkRmXkPGGz' +
        '6QhX4G0IhrArcDy8fpy2OUpe8zJBLPfB4jZiiRlpILyYkYEi0LH1X' +
        'ThgQ6SZvT2PhEAR/i44Iw/DV6cIoroDeL71HDPUfJLP8WCkDBgPR9' +
        'DfSLYYbZnWfjVd7tFXEFJIuNH7lQ7lr+DJoL3CDuoxux8ybOysiLd' +
        'PeJyTJvdCkZ0XB/0MvvXHacY4EXpU1dQsbGic4pTql67dHQKWW850' +
        'RYPoyXLmYQdxlJk0yLV0eEGZUzd7rePr4OG+O2kqRVyjpGgeeY8AJ' +
        'wcfjH+2pfWA=');
  if FindBitmapToleranceIn(CreateOption,X,Y,0,0,Width-1,Height-1,75) then
  begin
    Mouse(X+5,Y+5,0,0,false);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(MiscOption,X,Y,0,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y-60,0,0);
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(ArmourChainsOption,X,Y,0,0,Width-1,Height-1,75) then
      begin
      MMouse(X+25,Y-165,0,0);
      Mouse(X+25,Y+5,0,0,true);
      writeln('creating chains');
      result := true;
      end
      else
        writeln('could not find Armour Chains option');
    end
    else
      writeln('could not find Misc option');
  end
  else
    writeln('could not find Create option');
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(ArmourChainsOption);
end;
function CreateStringOfCloth : boolean;
var
SpindleIcon,CreateOption,MiscOption,StringOfClothOption,X,Y,
RagsIcon,StringOfClothIcon : integer;
ItemLocations : TPointArray;
Active : TPoint;
begin
  result := false;
  SpindleIcon := BitmapFromString(13, 12, 'meJxzFBJzxIYYYACrLFxN8ezb8c' +
        '3bgQiPSqAURA0Quce3E6MSjzKgOEQWSOJSBjEHIoXLF8hq8LgHv4O' +
        'JN4dadhFUA0QAknFJMQ==');
  CreateOption := BitmapFromString(33, 10, 'meJy9ks9LwnAYxv/EzArDkjINbG' +
        'mXyi5iUZ3MqE7+WKeadTCqs2KHPKSBYSMhhwt114G7CJttrAdeGmM' +
        'TDx4c7+HZ+/287/Pu3dfrmfPOJK5ZVpZlTdPe6/XAin+KDiiccHp1' +
        'edFuf4c3ggvznodisVp9ncLCNM0Jp2KnE9/bJQ2XbCZDJflctt/vQ' +
        'YeC663Wl67rIJlIBJmD+P6PKCKjKAomJJ5c3DACr+jsnur05Jjytd' +
        'obNEQykUA5hCRJ0BBRZms4HNq/wg0j8AvGWljJ39HI/H8wDzJrgdU' +
        'Cx2Gl8KLmloUbRoC0FkVLcOwWVb6lRfsAgiCcp8+ODpOb4ZDbwgEj' +
        'dmJRnuexQ4zN3d48Pz06LD4ajfu7AgTa4mJQH6zIv+wrl0tEGoZBn' +
        'd0wRTqVGgwGKHypVIi0W+CyAcZpr9uNbTPI4Eqoqoq/wOZzRH42mw' +
        'DGwjOIP5tN3Lc=');
  MiscOption := BitmapFromString(69, 10, 'meJzdlMtPU0EYxf9EsRQqRgPIQ6' +
        'jgApH3qxbUREDlVcGERi24wA0kQAK4gQUEQoUABRpKgEpSXFWSNi2' +
        '0qb/ki5Obub0buiChaSbfPTP3zDkz57u2vHu2u/UPHR0NDQyox48f' +
        '3oNQZDKZG3PKu7kw5LI1+u02GzXj+fnv3GXcrh3ft69v37ymZpyZm' +
        'TaK6Xa/SqVS6XT69OSkvbUFpKy0ZHtr6/rqCuPNjQ2C7O3tsoxjcV' +
        'ZVaXYaG14eh0LMRqNRrl7wCZ/vz8UFoNvlyspQUV52sL8PwkitHY6' +
        'VNpmqflq5uLhAzdjS1GQUg+zvkxMUrq7OSCRCsba2+mNqKv9+Xk+3' +
        'OxwOCwIzRUdbG6o0O6wBp6hxVsdiMcG/eL0w4AU9WRn8m5tYpmD85' +
        'fdntWPWpqY21tcZsamJ8YwMc6rzc7PPa2tkPSQoMd4vSOb/T+QZGY' +
        'ofP0LSysoyvhSuGJQwjUHtwkid1Y5Zm5ryjo/39/X+XFoyJx/v6EH' +
        'M8NCglR1Hgd2qd4LBYF/vu67ODjJj7illR2NQu9DOyWTS+FahPd9K' +
        'm1pW/qQUp9JBWlQkBnz9Li//yj3KFRMMCRvBEATZh4cHGgPCiNnDB' +
        'w6SbGXHzEDAJGzgEjZptCJHIY9W2ozkuzs78n3TGvns7JR2g03epW' +
        '1ZySN4/Ys6OQo0IJus1j5zagyfPJ5EIkHXfB4btbJjZuAquVZ2CQQ' +
        'CzIJIo8XjcTJmpe2O/f8B720Fug==');
  StringOfClothOption := BitmapFromString(65, 8, 'meJytVMlOAkEQ/URxxHgUBG/qwQW' +
        'i4oLgWUVwuxAV3PCq/oCsBsSwGU4skoDhgNwGIfiSTipjNz0SYtKp' +
        'VKpeVb/XUzWKYUz5fRLxuCIE+/2+GBzhuF07352Oz3uog5HdRcT+J' +
        'PNfbAeebrfrcjpHI0BxDoBnQdter1culTbW1xiAYWDPTk8qlTJVwQ' +
        'YDgc9Gg5hYZ8zFYrHd/gKS6zxrtbwXCkDCwqfOHMxiNr2l0/g0tdr' +
        'Hqt1Gd8nKmXOwvwc8o4Ha66sg4s7trXq9zomFwIlxg1bCud+PCApR' +
        'jkg0EoEoOHe3Nxy3VDLJUrCvqZTshWOx6H0ohJ67ble1WiWMWK4lF' +
        'ri8IBrHR75Wq/X0+LAwPyd+L8ZfK4GL4AVYxKgoHD1KwcKXSSAYNz' +
        'BiuQ4xvD+U4gXYlg0cOZIgu0hHAlKqqo4sgcplxMAc0wLf6/FgpOF' +
        'gL6YmjUNKCIefId9sms7lshw9fH02CRhUnUF6SSTYJG86HNpBEstl' +
        'xOy2FSwsshgqpoUt15ASsIxY52azyf6WWm7YQaTQNp/PY+tlEtAhm' +
        '8kABhrLS4uEEctlxH4AIgcnmg==');
  RagsIcon := BitmapFromString(21, 6, 'meJz7//9/SXnV9Rs3hcRlXD19L12' +
        '6/Pv379ev32Rk5wFFtPVNzp47//btW6Ca////A0XCouKACv78/Xv1' +
        '2nWfgBCgIFBEWEIWKHXz1m2/oDAgw9TS9uOnT0DGpi1bW9o7gYyun' +
        'n6I9p8/f7Z1dAMZwWFRDx48BApC9AKRsoYOUPHa9RuB5sAVQ2RFpe' +
        'QhIgXFZUC3zZm3wNLWEciFCEIQ0J3JaZmBoRE6hqa4tEPsBdoCtCK' +
        'vsARZO1Ax0NmyimqLliyDiG/YtBmoUl3b4OjxExARoC6gZ4GMnPwi' +
        'YJggay8qrfj69SvQ12WVNRBxTV0joJOePnsG1AI0HBK8wHAGBh0wA' +
        'IGCAPoRvBQ=');
  StringOfClothIcon := BitmapFromString(12, 12, 'meJwTEpcRAiMGBgYhGBsrAir4+v' +
        'UrRBkDDOBR8BUG4MowFcDNwSqOrACX+XCVaLrgNqIZBWHgV3Ptxi2' +
        'CdqF5DW4Ospsh5uAKSSDApQDNYciCALjLa3o=');
  Active := GetInventoryLocation;
  if FindBitmapToleranceIn(SpindleIcon,X,Y,Active.x,0,Width-1,Height-1,95) then
  begin
    Mouse(X+25,Y+5,0,0,false);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(CreateOption,X,Y,Active.x,0,Width-1,Height-1,85) then
    begin
      MMouse(X+5,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(MiscOption,X,Y,Active.x,0,Width-1,Height-1,85) then
      begin
        MMouse(X+25,Y+5,0,0);
        wait(WaitAfterClick);
        if FindBitmapToleranceIn(StringOfClothOption,X,Y,Active.x,0,Width-1,Height-1,85) then
        begin
          Mouse(X+25,Y+5,0,0,true);
          writeln('creating string');
          result := true;
        end
        else
          writeln('could not find StringOfCloth option');
      end
      else
        writeln('could not find Misc option');
    end
    else
      writeln('could not find Create option');
  end
  else
    writeln('could not find Spindle');
  if (result = false) then
    ClickScreen;
  //------------------
  ItemLocations := GetItemLocations(RagsIcon,Active);
  if not (ItemLocations[0].x = 0) and not (ItemLocations[0].y = 0) then
  begin
    MoveToBin(ItemLocations[0]);
  end
  else
    writeln('could not move rags to bin');
  //--------------------------
   //------------------
  ItemLocations := GetItemLocations(StringOfClothIcon,Active);
  if not (ItemLocations[0].x = 0) and not (ItemLocations[0].y = 0) then
  begin
    MoveToBin(ItemLocations[0]);
  end
  else
    writeln('could not move strings to bin');
  //--------------------------
  FreeBitmap(CreateOption);
  FreeBitmap(MiscOption);
  FreeBitmap(StringOfClothOption);
  FreeBitmap(SpindleIcon);
  FreeBitmap(RagsIcon);
  FreeBitmap(StringOfClothIcon);
end;
function CreateKeyMould : boolean;
var
ItemIcon,FirstOption,SecondOption,ThirdOption,X,Y : integer;
Active : TPoint;
begin
  result := false;
  ItemIcon := BitmapFromString(12, 11, 'meJwTEpcRwoYYwACrFFzB8uXL29' +
        'vbcSmDKwCSycnJmMqQFWA1CtkKoAloCiAuRNaI5maILB5HQhTAzcG' +
        'lBqIdzsDl2XYwIBhoeBQAAI6zQUc=');
  FirstOption := BitmapFromString(31, 8, 'meJxTNPZu6pn14tW77z9+7tp/1Mw' +
        'rXc0yTNUsQN0yTMUsQMsqXFLZUtUqUMc5WdnUT8nQQ8nMT8UiSMU8' +
        'QMUyRMnER8nYU17fZdeB41IaFjJadvL67jJalkomvqpWwRp2kcV1f' +
        'ecuXbfxSVG18J82b/XWvUe1bMNULUL13bM17SIVjNyVzX0UjLwU9F' +
        '3kDFxldZwVDT3ldJyVjIHGeiuDDPdRswr6//+/vK6TgqGHnJ6zgp6' +
        'zoqmvgpGnumX4pWu3/WLyFA09VMy8FQ1ca1onyRs4AxXXtU65eeeB' +
        'hk2kpWf8ybOXf//+fenKDRu3cFXr0IC4vCvX7wBF3rx9X1zfJ6fl9' +
        'B8M5HRdLNziT567AlJ89ZaTX/Lv33+UjNwVDN2VTX0VTb3lDFwUjT' +
        '2BKpOLWpRNvYGO2b77YEJ2lZp1eER6+alzVxSNPW7fexSbXSdv4Or' +
        'gE/fp8xcVs0Cgei3bCKCDd+w9kphbB2REZVQBnfT9xw9Vcz9NhxgF' +
        'Aw9gSCoaeSib+QEVAwMTaIuMtuPPnz//wwDQSYomnkbOUd0T523ee' +
        'ejO/cdAQUVDH5DhjvFKpr4/f/5CVrx1z9HQ1BpVqxA1+yh9j7SIrA' +
        'ZZA0dQGOq7KZl6Kpv5A9WrmXvJ67kqmfgrmwcpGntfvHqroLYvJrv' +
        'GyjcJqFLFIhhIKhi4Ab0JVKxpE6poFqDrlgx0sHtI5vEzlx2CCzRt' +
        'wnqmLpq1cK2cnitQsbIp0BfuwGA8cPR079RFqhaBWSVN5y7fVLUIA' +
        'ZoADBAt64CVG3aBVJr5/fn7V83MW07f7eCxc/3Tl8rru+aWd5y/dF' +
        '3Z3D+zqPHV67dALWs279WyCNK0iYBoUTTyVtB3t/CMASYnoOyN2w+' +
        'cA1KByayuY+bXb98/ff5a3zkDFCwGbkdPngcqkNN3tfRMPH/5BpB9' +
        '/dY916A0AGkkXIg=');
  SecondOption := BitmapFromString(43, 8, 'meJw1U49PE3cU/zs2j1573ystpb/' +
        'vem0PqG3p7+v1lx3VNgKlcVkj3YjWCQ5ZjIuyjEwHajaTZboENJot' +
        'xriZOJaMkIwQI9lAhbXl9zQmKkbdLygLe99r9s3l5b7v3nufz3ufd' +
        '3PzlaMnh2kubvLkGlyZD8+Ozj0skzrXzs4Osopqx16VPSm3ROCd0D' +
        'plOrfCGECMKDf4GpwZBH6LiLiozOChrTHSGJTp3XX6VsilbTGw9fY' +
        'ExQqIDSFTCJmDlClIMWEoQhq96uZ9kEjo3BA2N1/We7uQTURm39Lq' +
        'Y/AouZjK3kZzMQ2fegPZlXxc25oDOMoUoLgIbUsAHG1PUmyYYoKkw' +
        'aNghTfVNkLjIA1+QmOHCgAEVm70UEyoEbCYMDz1TW1wpa1xQuupa9' +
        'xN8wloBMI+Gfkq//4g4iL54unL177DBGxvgW1w7MsW+qvV6vb2vwu' +
        'lpbbc4Tptq9WbmZy6t7m5tbiynswWAahJzE3PzEHY7MOSQ2iXSxOQ' +
        'm4Ngte7OPdkjDxYq8PXZ8xfFE8MUK4J/aOTS+qMn4OwsDMDVEe68+' +
        'u1tmhOufPN9MnsIQzvTYEmjb3Nr68znowpTaH++b3XtEaFuujMxfe' +
        '7LMcoc6Cr0lxdXKYt4+4fJjoO9iBVTueL0vfsUG8EEDF6wCoNnceX' +
        '3TL4fMX53PPfq9R+kNPPBc1+rHan2g9DdtjQo3/jEFKi5UF6WGT1Y' +
        'fXsCpzOhvpOfPX2+cfnqjVDmMMkEaS4KvSNWUNoToCOoCQTAs/P/g' +
        'abk5hDOtWAJkEXgfB2ffnHl1p3JyvIani2PK6t2J+p0LuirlgXQH5' +
        '8ffbd38PrNcYU5gCmxgkQgSDS69na9N3T+Unlp7dipCyA3wNFchNS' +
        '01tYPWcLgUbGCxtUBZJS2BLLGpZoRqUL41wflQu9ge/fxlmgOe4x+' +
        'XN/kpa1RUsKCo25JN0fffrbxsufEBY1rP95hDu8wZQlWltdzhQHS5' +
        'CkODG28eImsifGJ6TMXx+r5ZPqdY+XlNcoS+ennmbMXx2CM3UdPzc' +
        'zOU1wUcnU+DLdL7wB6gXSP3pm6fvNHTExqTdmU2qXmiYaWGgFVc7L' +
        'RmQX5VLY4zYgSQ7xCCrM/mu4uLa7AEoJYHfk+yhrjwwem7s5uVau/' +
        'VVai7YeU/B5eyP5yvwRA86Ulf6oHSTtQG69M7/3go+G//v7n1es/j' +
        '58ewa1JS0iZRULvq/2w/wEDKADy');
  ThirdOption := BitmapFromString(47, 8, 'meJw1U/1PG3UY/z8s9O57L32hwL3' +
        '1+n5taeF6XO+uLW0prOAYU0cWcSy+Y7Yxl+2HsaVLRDeGRocjbpEf' +
        'dPtBTUYWHWoGwuq6wcYSFnQu+jtOoSb1uVa/uTx5cvfc83w+n+fzr' +
        'dVqNn+uNb7P2dEv6GP2cJHgZcTKlCdNCXpLqN8W6MPdGvJoFkcQcQ' +
        'na00MKKtbWaZfytDeDBA0JSYyRLa4IwSdxXrNH9pBiivZnCV6FzpR' +
        'okKLhjBYRm6DcBuK6rW2xJlekVqvhomHzZe1SgRA1jOuq1Y9TKjDd' +
        'L1G+DM6pzvAeV3jAFS5CE1rQre1dBKe6Ol9wxfY2uaLIrRHuJOVNk' +
        '54Mziu0L4N4lfClMVa2OINYW7ypVWp2RUiPQQgaDYMCWUJQaW/KFi' +
        'zYAjlHsN8WzCJGBhYwl/KnLbaQw5eDYsQnG2Aoj7F/7PjslWuOSLG' +
        'j99Byea1a/Wft0ZYy8KqlPVxZ24j1jFCeFBvOPXn6OwIWrEKKAKMb' +
        '/n3t2Lmdnd2JyenxE2ay//ApnE0EkvtWKxvQZOXn9VD3XhAZKgkha' +
        'eV0iJDTwZypDKsEtKFy5cH2n8+GR480wDjE5Pz1G4Rbo3zprxcWR8' +
        'bP4Yw8+PLE7ZUK5e05WZopnZ97zuF7593SzOw8chvW9jjOKThrCnv' +
        'wjVMhtXj3/sPh0WNDo0d3q1VC1G8uLp+98CnpTZcufvbdj6t2X9ak' +
        'LKasrijhMcyJoYIJhpG/Wbh15v1LoPOZD2YbYKYvfX709Az0xzgF2' +
        'NX+P9VqFXlTfLTnwaPHlCdTrqzrg4cxTrZLfaA8xiTqI3SsQdabaW' +
        '6PmSMEDZogXoGH8uqQO6RCXRmV9OikVITcFuiF2OyKw1dSTBJu3Vm' +
        'HB2dy6pOpj+fBG81MfGd31xnMAwUwhpWJN7fGAP/3S+UDYxMbm7+A' +
        'DTA2gTOKPdwPs+Bfa2sMCea+7FJvgzUVyMIIjOt0hoq01/jr7x06Y' +
        'C4Fa4kgPmHjTT0blaTbhEq6FcQknKG+Bhjw4dUvbuRHTjqkvpuLS6' +
        'ULl2l/7pXx06t318EASFBfPzL5eOvJ2fNzJju3Zm2Du5ZCdUEc0gD' +
        'VmNWeAHub8NjuW0uV0sUrOJ8oTV+GNZG+DPjn+YNv07z87Q8/mcWM' +
        'DLGpJfLVwuJ7H16NF0Z/ffrHf2ACfW+emPpo7ktwWtQYWblzDwCvb' +
        '2x2GMNWtgvuXWvINH9IHUKsCm4Hgjgnw6WuC55viQzWMciEaPLF2C' +
        '6/MlC+9xAA3F4uS5kDdCAPjoKlb28/e+t4qb6gKETEKX79xeU79ze' +
        '3fkv2H4I3/wLSH/3i');
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(ItemIcon,X,Y,Active.x,0,Width-1,Active.y,75) then
    begin
       Mouse(X+5,Y+5,0,0,false);
       wait(WaitAfterClick);
       if FindBitmapToleranceIn(FirstOption,X,Y,Active.x,0,Width-1,Active.y,75) then
       begin
         MMouse(X+25,Y+5,0,0);
         wait(WaitAfterClick);
         if FindBitmapToleranceIn(SecondOption,X,Y,Active.x,0,Width-1,Active.y,75) then
         begin
           MMouse(X+25,Y-10,0,0);
           MMouse(X+25,Y+5,0,0);
           wait(WaitAfterClick);
           if FindBitmapToleranceIn(ThirdOption,X,Y,Active.x,0,Width-1,Active.y,75) then
           begin
             Mouse(X+25,Y+5,0,0,true);
             writeln('creating item');
             result := true;
           end
           else
             writeln('could not find Third option');
         end
         else
           writeln('could not find Second option');
       end
       else
         writeln('could not find First option');
    end
    else
      writeln('could not find item icon');
  end;
  if result = false then
    Mouse(Width/2,Height/2,15,15,true);
  FreeBitmap(ItemIcon);
  FreeBitmap(FirstOption);
  FreeBitmap(SecondOption);
  FreeBitmap(ThirdOption);
end;
function CreateLockPick : boolean;
var
ItemIcon,FirstOption,SecondOption,ThirdOption,X,Y : integer;
Active : TPoint;
begin
  result := false;
  ItemIcon := BitmapFromString(8, 10, 'meJxjYMAObuMAwWAwnRRQjhskYwC' +
        'g1cEYAOKk5cuXo+nFFISbCTEHzXCgCAD8JmYQ');
  FirstOption := BitmapFromString(31, 6, 'meJxtkT1PwlAUhn+iiBoMkSAfJlD' +
        'BBcSFgAEmxIATH25SdENnCQ4yyAKBRhJoWgL0B7RLkxbb1Dc5sWla' +
        'b+7w5vQ5z733VBSEXDbj9x1gHx36Ws0mgmVZnXZrt9sixyLni8W3Y' +
        'RiiIDCJBCo3ueu1KKKiKMpDo048lhdGgJPk9gZZKZeoPh5/ISMU8n' +
        'k0IkiShIyQYpKqqhJPjS5Y1/V/5XbxZ7+3/hZugko4dNZj2dHoE6e' +
        'Q1pa7YDD2WOjJTpj4wMmx82ie5+9rd7fFwkU85pU74at0iuM4zApX' +
        'ZbtPb699l3w6mbw89xAgXK2WZMBAgqeBweCdSNM0yemFa9WqLMto+' +
        'RgOiXHK49EIMHzdbjbpSwYV/HRN0zDtx06byPlsBsAL/wJgEEZ9');
  SecondOption := BitmapFromString(22, 6, 'meJx1kM9LwnAYxv/EbEXRLdu8VZS' +
        'VUtlP7V5LW+fSfhm1DhUkdk0Ml2HM2Eldwo7L22xjfeALo0vw5eF5' +
        'n708e94nocif7bbv+2BCkaXYiByffm82f4bDfv9rNZ1CCcMQzGV3H' +
        'x/uBWE/CIJup7OxvmY0GqViER18MwxIrfZyXS6Pjcb2clnbtoXD1O' +
        'TEc7UK52F+flaC7GxvOY7DyDIjCBcLQokeDvrtzbGmiVE7KriuS57' +
        '5udm/++OS5Hnefw7F05Ory4tI4e9kJmEhf0hycQXBxBWv9boIuZnJ' +
        'RFeAlcpTcnEBgkgVkLyqDgbftGdZFs2YpqnMxEWTH60WSq/XXV5KR' +
        'g7qwf6drkPSqRU+0SQ7WP0CLxrpsQ==');
  ThirdOption := BitmapFromString(24, 6, 'meJyNUE1LAlEU/YnZKIoLbcTcpZi' +
        'V4kef6sqEGrVpXeNHKTUuLEhsqaIbRbeGOgqznIRZjM3wOvDg0TJ4' +
        'PM495777zj2EkGQiruv612wW2Pdzth1CCG6/jx+PRj/b7Xq9iseij' +
        'M+kr97fWhSYpmlZ1mI+P00moD4/1ey7trIkDQcD1t/v9xr1OvhsJq' +
        '0oCuXdLudnpwOMgy+qlTLA5cW5qqpQnQ47SgfHGYbB5qANQ+gTesD' +
        'Lry/3okhL8a6kaRq8hYIHVKX9/5kjPT7APGPgBFvAbalYgIoVeK+n' +
        'Vq30ul02BztS22epFNsLd7v9ETkMA4BERABFQdhsvqHmr3P4Han6+' +
        'L2/OU8nEyS5XC6OjyKMF25vmrIMEIueQELO6MHAX8nnBKQ=');
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(ItemIcon,X,Y,Active.x,0,Width-1,Active.y,75) then
    begin
       Mouse(X+5,Y+5,0,0,false);
       wait(WaitAfterClick);
       if FindBitmapToleranceIn(FirstOption,X,Y,Active.x,0,Width-1,Active.y,75) then
       begin
         MMouse(X+25,Y+5,0,0);
         wait(WaitAfterClick);
         if FindBitmapToleranceIn(SecondOption,X,Y,Active.x,0,Width-1,Active.y,75) then
         begin
           MMouse(X+25,Y-10,0,0);
           MMouse(X+25,Y+5,0,0);
           wait(WaitAfterClick);
           if FindBitmapToleranceIn(ThirdOption,X,Y,Active.x,0,Width-1,Active.y,75) then
           begin
             MMouse(X+25,Y-30,0,0);
             Mouse(X+25,Y+5,0,0,true);
             writeln('creating item');
             result := true;
           end
           else
             writeln('could not find Third option');
         end
         else
           writeln('could not find Second option');
       end
       else
         writeln('could not find First option');
    end
    else
      writeln('could not find item icon');
  end;
  if result = false then
    Mouse(Width/2,Height/2,15,15,true);
  FreeBitmap(ItemIcon);
  FreeBitmap(FirstOption);
  FreeBitmap(SecondOption);
  FreeBitmap(ThirdOption);
end;
function Pull(ClickX,ClickY : integer) : boolean;
var
MoveOption,PullOption,X,Y : integer;
begin
  result := false;
  MoveOption := BitmapFromString(25, 8, 'meJyN0QEOgCAMA8AX2vL/z0xn3ay' +
        'ixoWQQeY5ICIAcB+KiOCx0Xv0GBojZ541+WGU1sssuVCYqJHxQvlS' +
        'XUWFKP1C1JaL8hoVdF4zb/4jVf1jWc7j/KFaS6fAW/ABmSjktTjlf' +
        'VrZkYD8pNDaTPnz9cOJ8mtXSwT9dH3kRlYOjETP');
  PullOption := BitmapFromString(15, 8, 'meJxtTgEOADEE++HU/x/j0M2crGl' +
        'EqKrZBUQA50SssjpkLTJ6eYt9/hTTZ8hKHN+T7Lki8jCqqtofNyHP' +
        'T98z93jSnPuvVTEA1U0+xclQnuWsHdj6IWP9AAB20Jo=');
  Mouse(ClickX,ClickY,5,5,false);
  wait(WaitAfterClick);
  If (FindBitmapToleranceIn(MoveOption,X,Y,0,0,Width-1,Height-1,75)) Then
  begin
     MMouse(X+25,Y+5,0,0);
     wait(WaitAfterClick);
     if FindBitmapToleranceIn(PullOption,X,Y,0,0,Width-1,Height-1,75) then
     begin
       Mouse(X+25,Y+5,0,0,true);
       writeln('Pulling');
       result := true;
     end;
  end;
  FreeBitmap(MoveOption);
  FreeBitmap(PullOption);
end;
function PracticeDoll(ClickX,ClickY : integer) : boolean;
var
Active : TPoint;
PracticeDollIcon,PracticeOption,TakeOption,DropOption,X,Y : integer;
begin
  result := false;
  PracticeDollIcon := BitmapFromString(10, 15, 'meJxdkEFOwzAQRbNjAzv2DW0au2' +
        'ktWjtJm8TglqLAHlZISFyCk3EJjsVzBrzAGo2+53/PfE/pvN4fdRN' +
        '0G1QTsixTzi9tT6ao6vvfcB5q8/FNLu1Q2B7N3LQ3pgEIRSxevsDL' +
        'id0MY/Z3hBJW+gOuXj8lwIlS0cmREVwvT28S4GLXLbYH5gJ4DhaB9' +
        'JEpqr6Diva2HZ6pXI/vF3ZMTSjiqurOZnhKrHQQwbp/XB0exLmwSU' +
        'Ce37Z5Zcn/WOnMuoppOtdEIZZtxH/Jkidj8UkTEMfltyG66s/GP5P' +
        '1/gSLDSgqBAvhazwsnS+m1eVrN9O7WWVzU/8A7uNKxg==');
  PracticeOption := BitmapFromString(38, 8, 'meJx1UgkOBCEIe6HY+f9jXKWC9dj' +
        'GTAwWSmFaW6gO+DmwIuafQL/3RL6yApJmk1b6KcE3GzRPBFP8fuNo' +
        'w6KaKsozGauxUzHQ7zYjK54TgNAIknM+s2EJpuJJuxRVDmFQ+fSYE' +
        'aCmon/PgvSozfxTgThi3Iu8p0qtTM8FtAtV6uPytd2BQ9FsTUksEy' +
        'MrPA6XD0eoHx6TzN0Bm0fZ+67opbBNdSD9qtznLtZYZK26L6LIX1G' +
        'v9rhW/1GLzvMHmpznQw==');
  TakeOption := BitmapFromString(22, 8, 'meJx1kAEOwCAIA19o2f8/43RgrTU' +
        'jxhikB6X3IyDRWj1GPhA7gDoRz8rNmvkDIyTkJqAIOAii5Ugk4OuY' +
        'jUIKjJCHXoY837xZzBmUud1JC2qrYBE0KKG7VOUS/maQZSKwnRpBZ' +
        '3DCWqnNYC5US7gZGckXDbAb0Q==');
  DropOption := BitmapFromString(24, 12, 'meJxtUgEShCAIfGShCPb/Z9wZK4' +
        'hVwziIsCy0xEIsZ21kDnzYisdrbaUpsXpE0ym/9Fma0DibFph0auo' +
        't2LvwWTi6wxnl0fH2DcdAejoVLdzxBDGzp1nrhus6PScID0N8RoBT' +
        'W+Yzr164kTT+GQHLifIPPo624dhmHq/glvdzFDar43pQ/cDZ2YLMn' +
        'HEASseMVa5hMe8anPU5V5p64pge8n/PHEr6+5GAXw/HI7cMyCW3nL' +
        'f84jXLY+abJrNoozD0nERb2iYYn7pXvVxCfYKEgF29WKNLTnNC6HO' +
        'sFJr/A0ZEngA=');
  Mouse(ClickX,ClickY,5,5,false);
  wait(WaitAfterClick);
  ClickRepair;
  Mouse(ClickX,ClickY,5,5,false);
  wait(WaitAfterClick);
  If (FindBitmapToleranceIn(PracticeOption,X,Y,0,0,Width-1,Height-1,75)) Then
  begin
    result := true;
    Mouse(X+25,Y+5,0,0,true);
    writeln('Practicing on doll');
  end
  else
    writeln('Option Practice could not be found');
  wait(600000);
  Mouse(ClickX,ClickY,5,5,false);
  wait(WaitAfterClick);
  If (FindBitmapToleranceIn(TakeOption,X,Y,0,0,Width-1,Height-1,75)) Then
  begin
    result := true;
    Mouse(X+25,Y+5,0,0,true);
    writeln('Picking up Practice Doll');
  end
  else
    writeln('Option Take could not be found');
  wait(WaitAfterClick);
  Active := GetInventoryLocation;
  if not (Active.x = 0) and not (Active.y = 0) then
  begin
    if FindBitmapToleranceIn(PracticeDollIcon,X,Y,Active.x,0,Width-1,Active.y,95) then
    begin
      Mouse(X+25,Y+5,0,0,false);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(DropOption,X,Y,0,0,Width-1,Height-1,75) then
      begin
        Mouse(X+25,Y+5,0,0,true);
        writeln('Dropping Practice Doll');
        result := true;
      end;
    end;
  end;
  wait(WaitAfterClick);
  Pull(ClickX,ClickY);
  Pull(ClickX,ClickY);
  Pull(ClickX,ClickY);
  Pull(ClickX,ClickY);
  Pull(ClickX,ClickY);
  WaitForActionFinish;
  FreeBitmap(PracticeOption);
  FreeBitmap(TakeOption);
  FreeBitmap(PracticeDollIcon);
  FreeBitmap(DropOption);
end;
function TargetPractice(ClickX,ClickY : integer) : boolean;
var
TargetPracticeOption,X,Y : integer;
begin
  result := false;
  TargetPracticeOption := BitmapFromString(30, 8, 'meJxVUltLFGEY/h3GujPzzWHXYd3' +
        'DHHYOum7ucdadnZ1d121b0xtTQ4O6CIPKDoRRsBdlaATeZDd1FXSR' +
        'FUiCVAaKeShtBYNuIlAkLcnWsHdWCPoYPt55vvd95nme+Q4O/lvOw' +
        'AlGydN+06HkKb/JqsdqSIVWM65wFykayKchv0HJWUoyKSWHBB3xCc' +
        'wTIYTkEadsY5swT9zGKi+nZmi1lRRSiNOAk4QR0WSDBTaQp+U2T7y' +
        '/ruk4zsVJSce5FtwTsXujta4w4UvYXWHEA2eStJh1Rs0iUcfqQ7hP' +
        's7vDuDsMbDiXwH3wWMyUP4m5I4Qvnu44/bH8uVKpbGxuDVwfBalwO' +
        'njj7qe1dZuzodHsfb+8urn1fXBoGHAkpoRg28zsAvQvfig3p3uRYB' +
        'zadzTkcG/M0iymCDFp90bW1r+0918m5Wwo072988NWF4DT7nM3CbG' +
        'F8qcnJqdLIw9oJXv7/sND5hevZvouDbOBQvHUhXdzi2AQcELUEfgV' +
        'U5Z+rwbpEZzGR9tLo+NPn0/BJwCvcchVRwaj5CDSvb3fUGNsmJHNq' +
        'h4dkH+/qVLZJ6VMFTfqmgrOQBFqJlj0aD1sc8f80sqZi6X2nvMNeq' +
        'fVU9WAuaNISJNSFngYNcOoOarKjEQDEFcwD8YhVYJvQf404PWxLpJ' +
        'LOhpzVixqGyUaFJ+CzmbzZH2w8OjJhDXLW8y0nKl1hZBkPpt8UxoZ' +
        '5462gnELV1unXs/eGXuMeaP9A0PzS2VSMPb3/zglk5TSdlfIUuWJw' +
        'TUjOf1qaWx399f2zs8rt+5ZKfGJw6xoIQu7rHUuLJe/ftvoOnsNNI' +
        'B3OVacX1yFeqW8Hs31QQ7Tb+fg9S9ZR1E/');
  MMouse(ClickX,ClickY,0,0);
  wait(random(500));
  Mouse(ClickX,ClickY,2,2,false);
  wait(WaitAfterClick);
  If (FindBitmapToleranceIn(TargetPracticeOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    result := true;
    Mouse(X+25,Y+5,0,0,true);
  end
  else
  writeln('Option Target Practice could not be found');
  FreeBitmap(TargetPracticeOption);
end;
procedure Drop;
var
DropOption,X,Y : integer;
begin
  DropOption := BitmapFromString(24, 12, 'meJxtUgEShCAIfGShCPb/Z9wZK4' +
        'hVwziIsCy0xEIsZ21kDnzYisdrbaUpsXpE0ym/9Fma0DibFph0auo' +
        't2LvwWTi6wxnl0fH2DcdAejoVLdzxBDGzp1nrhus6PScID0N8RoBT' +
        'W+Yzr164kTT+GQHLifIPPo624dhmHq/glvdzFDar43pQ/cDZ2YLMn' +
        'HEASseMVa5hMe8anPU5V5p64pge8n/PHEr6+5GAXw/HI7cMyCW3nL' +
        'f84jXLY+abJrNoozD0nERb2iYYn7pXvVxCfYKEgF29WKNLTnNC6HO' +
        'sFJr/A0ZEngA=');
  If (FindBitmapToleranceIn(DropOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    end
  else
  writeln('Option Drop could not be found"');
  FreeBitmap(DropOption);
end;
procedure DropDirt;
var
DirtMap,X,Y : integer;
begin
  DirtMap := BitmapFromString(15, 10, 'meJxtkFsOgkAMRVmMQR6DhCiOyl' +
        'OIIBpX4IdxLX64A3finlyGB6oTYmxuJk3nTOe2Kmn8pFFJExYHf12' +
        'Tz/LOGsKJC/Ig2yNXl/5mh7x17a2qIOs4Bbs+XoikLw635LTiuQD0' +
        'NJjofHta35C3BMX2ch+TVDgpmqu+GzaGhkIKMxakCGAa586ywLyrt' +
        '4bnyiSGlHnD8hikLauIqhMVA/yQkqhhdcC8sv6FShu+JplEG2xgBv' +
        'MyqUxtLzIkFU5M2vPU0eWnc3lU30lp1S9fVzK77B8ez2+6pnBk');
  If (FindBitmapToleranceIn(DirtMap, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+7,Y+6,0,0,false);
    wait(WaitAfterClick);
    Drop;
  end
  else
  writeln('Dirt not found in inventory');
  FreeBitmap(DirtMap);
end;
procedure CartDirt;
var
CartMap,DirtIcon : integer;
CartPoint,Inventory,DirtPoint : TPoint;
begin
  CartMap := BitmapFromString(20, 10, 'meJzLrmrIpiP6//8/tfT+hwFcIh' +
        'DGfySAaQ5cDaYIHvWYDkO2Apd6TL3EuISgSoL24gkrXPZSEk0QBAA' +
        'EAGN4');
  DirtIcon := BitmapFromString(15, 10, 'meJxtkFsOgkAMRVmMQR6DhCiOyl' +
        'OIIBpX4IdxLX64A3finlyGB6oTYmxuJk3nTOe2Kmn8pFFJExYHf12' +
        'Tz/LOGsKJC/Ig2yNXl/5mh7x17a2qIOs4Bbs+XoikLw635LTiuQD0' +
        'NJjofHta35C3BMX2ch+TVDgpmqu+GzaGhkIKMxakCGAa586ywLyrt' +
        '4bnyiSGlHnD8hikLauIqhMVA/yQkqhhdcC8sv6FShu+JplEG2xgBv' +
        'MyqUxtLzIkFU5M2vPU0eWnc3lU30lp1S9fVzK77B8ez2+6pnBk');
  If (FindBitmapToleranceIn(CartMap,CartPoint.X,CartPoint.Y,0,0,Width-1,Height-1,75)) Then
  begin
    Inventory := GetInventoryLocation;
    If (FindBitmapToleranceIn(DirtIcon,DirtPoint.X,DirtPoint.Y,Inventory.x,0,Inventory.x+100,Inventory.y,75)) Then
    begin
      MMouse(DirtPoint.x+25,DirtPoint.y+5,0,0);
      HoldMouse(DirtPoint.x+25,DirtPoint.y+5,1);
      MMouse(CartPoint.x+50,CartPoint.y+100,0,0);
      ReleaseMouse(DirtPoint.x+25,DirtPoint.y+5,1);
    end
    else
      writeln('Dirt not found in inventory');
  end
  else
    writeln('Could not locate cart inventory');
  FreeBitmap(CartMap);
  FreeBitmap(DirtIcon);
end;
function OrePileToBin : boolean;
var
  PileMap,OreIcon,BinMap : integer;
  PilePoint,BinPoint,OrePoint : TPoint;
begin
  result := false;
  BinMap := BitmapFromString(15, 10, 'meJzLrmrIJgX9//+foAgxUrgU/w' +
        'cDTBFkcVzK0GxEU0AjxaQ6A5cWMkIMggB+6w9m');
  OreIcon := BitmapFromString(15, 10, 'meJxtUEEOgjAQ5CcaglJQYkBopR' +
        'KKlAP6PS8mPkX9hjG+xqmjjQebSbOdnZ1MN9U2LluhdlGhhTTxupk' +
        'X2+B9wM8KDQZ3lNfhSqa1FZXBDc1CD5TdH8/xsEeRbPpUW3RRC9UB' +
        'FNAQMo/T+Rh8D54sLtcbeRoCYCj2LaZCBj+LFsW/5gQESJ41o0ulr' +
        'dej5QvO+pxZ68T4CH4NxlsRXknzcKWAaVZOkjz4d+LKYKXMvNQDnI' +
        'V0O2Fabgwg45ZWGWQAsEOXwY1/dihUD5B3T9mhgB7kC1Q4fCI=');
  PileMap := BitmapFromString(15, 8, 'meJzLrmrIRkX///+Hk0QirIrh5sB' +
        'l0Uz+DwN4lGE6BlklLsVoAL9iNDeT6gwiPQgA0AbyQQ==');
  If (FindBitmapToleranceIn(PileMap,PilePoint.X,PilePoint.Y,0,0,Width-1,Height-1,75)) Then
  begin
    If (FindBitmapToleranceIn(BinMap,BinPoint.X,BinPoint.Y,0,0,Width-1,Height-1,75)) Then
    begin
      If (FindBitmapToleranceIn(OreIcon,OrePoint.X,OrePoint.Y,PilePoint.X,PilePoint.Y,Width-1,Height-1,75)) Then
      begin
        MMouse(OrePoint.x+25,OrePoint.y+5,0,0);
        HoldMouse(OrePoint.x+25,OrePoint.y+5,1);
        MMouse(BinPoint.X,BinPoint.Y+100,0,0);
        ReleaseMouse(BinPoint.X,BinPoint.Y+100,1);
        writeln('put ore in bin');
        result := true;
      end
      else
        writeln('failed to find ore');
    end
    else
      writeln('failed to find bin');
  end
  else
    writeln('failed to find pile');
  FreeBitmap(BinMap);
  FreeBitmap(OreIcon);
  FreeBitmap(PileMap);
end;
procedure CartClay;
var
CartMap,ClayIcon : integer;
CartPoint,Inventory,ClayPoint : TPoint;
begin
  CartMap := BitmapFromString(20, 10, 'meJzLrmrIpiP6//8/tfT+hwFcIh' +
        'DGfySAaQ5cDaYIHvWYDkO2Apd6TL3EuISgSoL24gkrXPZSEk0QBAA' +
        'EAGN4');
  ClayIcon := BitmapFromString(15, 10, 'meJxtkV0OgjAQhLmJBRWwthFLqU' +
        'BRjPjDQXwwXscXEy/rwMaGgJtJsyzfwu6UCc1EOuOKSe3LLJAGp9f' +
        'HUpVRWi2SAhXkkLBXSNrbujwLeyHs/XlBSOKsDpUFRr1hWhGAosOc' +
        'vF+4HMnjeZ+SKLpXiMW2iM1x+OspT6IxfGmwGuR4+uCIRET6gL140' +
        'eCU+xYVB4xISqKsBrzKT7JqvX/ByybedaPCNHKGcTV0LNgYJrQzAe' +
        'bDcIwBgYeovdsafvYVXAce50mOXrqUL/+va/k=');
  If (FindBitmapToleranceIn(CartMap,CartPoint.X,CartPoint.Y,0,0,Width-1,Height-1,75)) Then
  begin
    Inventory := GetInventoryLocation;
    If (FindBitmapToleranceIn(ClayIcon,ClayPoint.X,ClayPoint.Y,Inventory.x,0,Inventory.x+100,Inventory.y,75)) Then
    begin
      MMouse(ClayPoint.x+25,ClayPoint.y+5,0,0);
      HoldMouse(ClayPoint.x+25,ClayPoint.y+5,1);
      MMouse(CartPoint.x+50,CartPoint.y+100,0,0);
      ReleaseMouse(ClayPoint.x+25,ClayPoint.y+5,1);
    end
    else
      writeln('Clay not found in inventory');
  end
  else
    writeln('Could not locate cart inventory');
  FreeBitmap(CartMap);
  FreeBitmap(ClayIcon);
end;
procedure BinClay;
var
CartMap,ClayIcon : integer;
CartPoint,Inventory,ClayPoint : TPoint;
begin
  CartMap := BitmapFromString(15, 10, 'meJzLrmrIJgX9//+foAgxUrgU/w' +
        'cDTBFkcVzK0GxEU0AjxaQ6A5cWMkIMggB+6w9m');
  ClayIcon := BitmapFromString(15, 10, 'meJxtkV0OgjAQhLmJBRWwthFLqU' +
        'BRjPjDQXwwXscXEy/rwMaGgJtJsyzfwu6UCc1EOuOKSe3LLJAGp9f' +
        'HUpVRWi2SAhXkkLBXSNrbujwLeyHs/XlBSOKsDpUFRr1hWhGAosOc' +
        'vF+4HMnjeZ+SKLpXiMW2iM1x+OspT6IxfGmwGuR4+uCIRET6gL140' +
        'eCU+xYVB4xISqKsBrzKT7JqvX/ByybedaPCNHKGcTV0LNgYJrQzAe' +
        'bDcIwBgYeovdsafvYVXAce50mOXrqUL/+va/k=');
  If (FindBitmapToleranceIn(CartMap,CartPoint.X,CartPoint.Y,0,0,Width-1,Height-1,75)) Then
  begin
    Inventory := GetInventoryLocation;
    If (FindBitmapToleranceIn(ClayIcon,ClayPoint.X,ClayPoint.Y,Inventory.x,0,Inventory.x+100,Inventory.y,75)) Then
    begin
      MMouse(ClayPoint.x+25,ClayPoint.y+5,0,0);
      HoldMouse(ClayPoint.x+25,ClayPoint.y+5,1);
      MMouse(CartPoint.x+50,CartPoint.y+100,0,0);
      ReleaseMouse(ClayPoint.x+25,ClayPoint.y+5,1);
    end
    else
      writeln('Clay not found in inventory');
  end
  else
    writeln('Could not locate cart inventory');
  FreeBitmap(CartMap);
  FreeBitmap(ClayIcon);
end;
procedure CartSand;
var
CartMap,ClayIcon : integer;
CartPoint,Inventory,ClayPoint : TPoint;
begin
  CartMap := BitmapFromString(20, 10, 'meJzLrmrIpiP6//8/tfT+hwFcIh' +
        'DGfySAaQ5cDaYIHvWYDkO2Apd6TL3EuISgSoL24gkrXPZSEk0QBAA' +
        'EAGN4');
  ClayIcon := BitmapFromString(15, 10, 'meJxdkY0NgjAQhdnCAYwRBASJiM' +
        'hfgQCCxBjXcBzjBI7gAK7ma19sCM1L83p8dz2ufjl64uKL0SsGNzu' +
        'rvTfUspMWcpJ2m/ebY4W4o462igAmdvh8IRg37RDfVVd41DTDggBy' +
        'NUYt3k/jv5hLs3y8piQwBmH4SVaLKhYkSWYqkJRsoxjQEnb0o3l80' +
        'kaT7H8VpFYk0LkVlYhoYEbSYAJu1iFLj2K2cOm+ucME9W0d5nZcoz' +
        'iO7FlO+NRAjJBHqxigGQlLCT+r30Jel8rr5DGu+RxI+QERUWro');
  If (FindBitmapToleranceIn(CartMap,CartPoint.X,CartPoint.Y,0,0,Width-1,Height-1,75)) Then
  begin
    Inventory := GetInventoryLocation;
    If (FindBitmapToleranceIn(ClayIcon,ClayPoint.X,ClayPoint.Y,Inventory.x,0,Inventory.x+100,Inventory.y,75)) Then
    begin
      MMouse(ClayPoint.x+25,ClayPoint.y+5,0,0);
      HoldMouse(ClayPoint.x+25,ClayPoint.y+5,1);
      MMouse(CartPoint.x+50,CartPoint.y+100,0,0);
      ReleaseMouse(ClayPoint.x+25,ClayPoint.y+5,1);
    end
    else
      writeln('Sand not found in inventory');
  end
  else
    writeln('Could not locate cart inventory');
  FreeBitmap(CartMap);
  FreeBitmap(ClayIcon);
end;
function Dig : boolean;
var
DigOption,DirtIcon,X,Y : integer;
begin
  DigOption := BitmapFromString(16, 12, 'meJyNkV0OwCAIg48pyYjc/xRbjF' +
        'IYjKnpgzFfy49NuEVdQ/1bJHy7A37cax7h3nLCq8XyV92+XiZPkWf' +
        'PeBd4+uVzPizGy57HLNUUYZ+vrop5s+zj3Cb3vIajRMWT8lkPt3sp' +
        'RA==');
  DirtIcon := BitmapFromString(15, 10, 'meJxtkdsNwjAMRTsLAhJKeSi0Bd' +
        'In5VVm4AMxCx9swCbsxBic1CJCCMuybm+O3cYdGKsWuYpL6tBkA2O' +
        'pQRcIlVQ4/fma5HFsd9PyNCnaKDtEdifY9fEiETqpYCDRDNRpJYBe' +
        'Nh6TPN+ewSekl8A8Xu7fJA4V0x9102oVF75XmO+ElOzgzWjVhHZLl' +
        '+c58sKThNwdntqbLXE88EOKYBtRtp/kLW8J/kW43jLNCesEe8CRm8' +
        'qt3eYXuTjyAW7bxrJJN7lodVrLKNp9yq8RklW8AaTcbXg=');
  ClickScreen;
  wait(waitafterclick);
  If (FindBitmapToleranceIn(DigOption, X, Y,0,0,Width-1,Height-1,100)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    if not MoveItemsToPile(DirtIcon) then
      writeln('failed to move dirt to pile');
    result := true;
  end
  else
  begin
    writeln('Option Dig could not be found"');
    result := false;
  end;
  FreeBitmap(DigOption);
  FreeBitmap(DirtIcon);
end;
function DigClay : boolean;
var
DigOption,DirtIcon,X,Y : integer;
Clay,InventoryLocation : TPoint;
begin
  DigOption := BitmapFromString(14, 10, 'meJz7/x8Kfv/+nZBVI6NmKaNhDe' +
        'Qqmnoqm/kqGnvJajvK6zrJG7oCBZVMvOW07OOyKr//+BmXW6NqHqB' +
        'o5KZk4K5o5CVv5KlqHaxuE65mFQZUKaPlIKluoWjknpjX8Pv3Hzk9' +
        'J6CgunmIQ2jWhSs33777UNs+BWKvinmAspGXgpGbooEHkKtqGQQSt' +
        'AjYuutAz5T5cvpuU+atgaiU03FWMvZSMvFXtw0HcjUdo4GkspH3z1' +
        '+/9F0zZHWd1SyCICqVTXxUrENVTP1SiluBtiuZ+gAFNaxDgCoVTbx' +
        '0bMM0bcIgKlUtQ1QsApPz6oE+SspvADoGKKhg5LFtz5HuyfNNXCJP' +
        'nr38Hwn8AoZSfoOCgYuyiTcoQAy9TJzDL1678/zlm6SC+p8/f8npO' +
        'WvaRMrqOsnpuyroOSsZeauY+aqYh+i4pKtZhSiZ+SuZ+maXt125fk' +
        'fDNkLB0E3F3FfRyFvBwEPZwh+s2F/NInTJmm1fvn4Dmnbp6q2AhCo' +
        'A5ZbN0w==');
  DirtIcon := BitmapFromString(15, 10, 'meJwTEpcRwkAMYIApjlXZjNmTgQ' +
        'hZPZwNNweuDI4YYADOBjIyslIwVQIF4VJoJqOphKuHIDQvwNVDDER' +
        'TielfoAhcAZpKrIZjArTQQHMGsgK0AMQfF2hcAKhMWLs=');
  ClickScreen;
  wait(waitafterclick);
  If (FindBitmapToleranceIn(DigOption, X, Y,0,0,Width-1,Height-1,100)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    InventoryLocation := GetInventoryLocation;
    If (FindBitmapToleranceIn(DirtIcon,Clay.X,Clay.Y,InventoryLocation.x,0,Width-1,Height-1,100)) Then
    begin
      if not MoveToPile(Clay) then
        writeln('failed to move dirt to pile');
    end;
    result := true;
  end
  else
  begin
    writeln('Option Dig could not be found"');
    result := false;
  end;
  FreeBitmap(DigOption);
  FreeBitmap(DirtIcon);
end;
function Fisher : boolean;
var
FishOption,X,Y : integer;
begin
  FishOption := BitmapFromString(19, 6, 'meJz7//9/UIA/MvoPFmlpbvrz58/' +
        'fv38fPnhQW10FEZ84of/p0ydA8ebGxv9IAFnj71+/li9bCmQ0NtS/' +
        'ePECIr5k8aLgwACgLqDe/zhsnD5t6ocPH7Zv25qXmwMXB+qCs3Fph' +
        'Ni1dMmSx48fT50yGVkcv0ageqA3gYwpkyZ9+vSReI3lZaWPHj0EBg' +
        '7QOxAT0DQCAHnvx1Q=');
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(FishOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    result := true;
  end
  else
  begin
    writeln('Option Fish could not be found"');
    result := false;
  end;
  FreeBitmap(FishOption);
end;
function ContinueBrickConstruction : boolean;
var
ContinueOption,BrickIcon,X,Y : integer;
begin
  ContinueOption := BitmapFromString(41, 6, 'meJx1UjFPwmAU/IlAqRA3EEwIigu' +
        'KCzFBmBBGrRtRC2zqH8BBBlmo2ECBpiQw4tKtSbFNveTFl0b6NV++' +
        'XC/37l7f68qyKudlKR7DSSbi94oCcJzPLeZzz/NwA4MJgqCrqt/bL' +
        'ch6rUYMHgIiAdkyzmUzs9kUgpVlFQsFACSyho42HsMHAPenplHtQ6' +
        'cDJWxREnbmaJGA8Wj00ahfA1xVq+jBdd396J/djkjcwFTLsvDHhl9' +
        'FAsawCv4etDccvvPAcS4rF+FoWZLQW6TPfrRIkJKTHJ0+kFl2VjrV' +
        'dR1bQJb69Pj68gwSQ6aB93tdHvg/Z9/3yUcUTUs/TKfgQAz2CEOAd' +
        'utmuVwAtJpN27bR0ttgQG74tUzTRK1hGPmjbKTz12TCu4gU0NIdx1' +
        'HubomBFRJRtVmvSyfFX31SrUw=');
  BrickIcon := BitmapFromString(8, 6, 'meJxjYACBGbMno6GMrBSsghCEKUIq' +
        'AlqKKQIEALHDPIM=');
  if not (IsItemInInventory(BrickIcon)) then
    MoveCartItemsToInventory(BrickIcon);
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(ContinueOption,X,Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    result := true;
  end
  else
  begin
    writeln('Option Continue could not be found');
    result := false;
  end;
  FreeBitmap(ContinueOption);
  FreeBitmap(BrickIcon);
end;
function DestroyDoorWall : boolean;
var
BashOption,X,Y : integer;
begin
  BashOption := BitmapFromString(37, 6, 'meJxtkktLAlEYhn9iZkYXCTKVxDI' +
        'qqKDsYkYF1ca020YCza0tqp+QGyeTvKLhBWTAjbnTlNNDHw1DeDgc' +
        'nvnmPef9zjujlLJaxmQGA4HBYAA4HfO53AdcrVS8Hg+Vo+Ahj8Phs' +
        'F6r7e5sU1G/Q+Du9qbRqMNul7NYKKBkhal8Vqtywpx9tt1uK5Od7G' +
        'VNpV45H9jz+/EFvvv9xEMcCBzs67puKAUQT4xbYC2djsdiAOubpgH' +
        '30ahspKXHZHKkHYervyH3vb6KdDqdl+enFd+yWSkgXrJRmBWWoAgE' +
        'KJfL62uralSYKKcmbeY25F703Gw2I+HLf3aGxrCzWa29Xk+K2Wz29' +
        'ORY0jbEBIJAMiQTSeDi/KxUKgK4yKtwKNTtfgF8R2nJbEeAEibbJU' +
        'wm7bVaLambQ+N2InAtOHChVXLwLXmpbG1u0B4WyMT3PZORuMx2/B6' +
        'Ehiafz3OIFO0z02gW3S74B/nrgwM=');
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(BashOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    result := true;
  end
  else
  begin
    writeln('Option Bash could not be found"');
    result := false;
  end;
  FreeBitmap(BashOption);
end;
function CastTrueHit(Active : TPoint) : boolean;
var
  SpellsOption,TrueHitOption,X,Y : integer;
begin
  SpellsOption := BitmapFromString(28, 8, 'meJxzC04/fubSz5+/vv/4eez0Jbe' +
        'QdC37aBXTAAUDDzk9JyBSNvJRNPGR13dXMvUDIRNfIKls7v///381' +
        'yyAgqWzqK6vtrGDkqWwRoGYeom4ffvfB46K6Ccom3po24Rn51Y+fv' +
        'QTqktN1Ujb2VjDx0bKPVLcKk9VzUjL1lTdwVzTyVjLzUzbzVbcJA5' +
        'qmZOIJJOX1XBWNPBSMvRWNPRT03RSNvD59/uoYmKJiGahqGQbkyuk' +
        '5Sus6AFWGxhV8+vzlyrXbTuH5arah5h6xJ85e+v37z+Xrd4DqlY28' +
        'QWaa+oJIM//E3LrfQLm/f2/cvh+ZVp5R0vrm3YcjJ853T1kUmlgAc' +
        'qSOE1DltAUb1GxC+6Yu2n3guLy+y859x+KzKoCejc2uO3X2soKhK1' +
        'CNgjHInbL67sCg652yQNnELya94tGTF9ouqWpWIRFpFc19sy9du1P' +
        'eNElJH6RSxzFa2yFO2cgNGM7A8ATq+g8DQCcpGLiBwhMcAnJ6zrWd' +
        's968fb9o1RafhCols0BFE181i2A5fVcVcz9FQ+cvX7+rmgcCVaqa+' +
        'Ska+2o5xoDMNPb++euXukWAvK6jnIGLqkWwsnkAKHbMgoEkMGwVDN' +
        '3ic2p6pi68fe9RVeu0x09fuIVlaVhHqFoEBSWUXLlxR9kEFKdAz+r' +
        'ZePdPX7ht9yFgyO8/fGri3NXKFn75NX0Xrt5WAdurYuoPjinfO/cf' +
        'x6aXK5p4lzb0vXv/0S0kbc/B48CYAvro6KkLzoFpwEgHqswtbwO67' +
        'cjJ8wZ2fqoWAdZBWUCjgCFw4/YDj+hCeSNPsJk+EHcGxuXfvPMAGE' +
        'dAQ+KzqwCBhU9e');

  ClickScreen;
  Wait(WaitAfterClick);
  if FindBitmapToleranceIn(SpellsOption,X,Y,Active.x,0,Width-1,Active.y,75) then
  begin
    Mouse(X+5,Y+5,0,0,false);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(TrueHitOption,X,Y,Active.x,0,Width-1,Active.y,75) then
    begin
      Mouse(X+25,Y+5,0,0,true);
      result := true;
    end
    else
    begin
      writeln('Option truehit could not be found');
      result := false;
    end;
  end
  else
  begin
    writeln('Option spells could not be found"');
    result := false;
  end;
  FreeBitmap(SpellsOption);
end;
function Pray : boolean;
var
PrayOption,X,Y : integer;
begin
  PrayOption := BitmapFromString(21, 8, 'meJz7/x8E/vz5++zF64TsKlldJ3l' +
        'DLxWzAHkDdxW7WFWbIAVDT2ULIOkqp+sir+cqq2WnahWqaOqpbOar' +
        'ZOIL1Kto5KVs6hudXn33/mMZNSsZTRtly2AlY08Vi0BFQx8ZbQdlM' +
        '38gQ8XcX80uWsnYS8HQXdnIS8nYW8nED6gdaIiclj1Q8PfvP/JG7k' +
        'CRqub+m3cfyum5BSSUXLt1//fv32/evi9tmiyv73blxl1H/0R5fXc' +
        'Dh+Cnz18CFcvrukqomqXk11+7eVfNMhQokphbpwJysMetuw8iU0oU' +
        'jT0cA1M+ff6ibOLXPmFe77SFKuZBDd2z5i7d+B8GHj15FpZcomoeA' +
        'mSrWQbK6jkoaNubuMX2Tlu0acfBO/ceAcXldJxN7QNv3HmgZOp/8e' +
        'pt78hcoKCsvpOSKdAj3kpm3nI6TkARsNWeag5xF6/dzi5tjc2ptfF' +
        'JBLnT0EPJxOPY6YsZJS237z1SMvQCCgLDTc7AXd06XMXUX80K5HgF' +
        'AzdN2zBVy5CfP385+CXq2oev2rQXZLuuM9AjFY0T7j961jd9qbZjE' +
        'sQueT0XdetQNZtQFXNQYMrruygbewC9UNM+/du3758+fWnsmQWKI0' +
        'MPRSMfY48EINveL1XVIhgAw7Lmgw==');
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(PrayOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    result := true;
  end
  else
  begin
    writeln('Option Pray could not be found"');
    result := false;
  end;
  FreeBitmap(PrayOption);
end;
function Tracking : boolean;
var
  TrackOption,X,Y : integer;
begin
  TrackOption := BitmapFromString(26, 8, 'meJz7/x8F+Ht7+fuAUAAQ+XqjIx+' +
        'oLAh5QxFIF0wQogwoAlMP0oKE0Lg4TIO7wdcHiMCm+cBNnjlt2sOH' +
        'D4FGlRUX3b1758/v3x8+vJ/Q1wuUTYyLvXD+/K9fv548eQyUBZoAc' +
        'VtTQ/3WLZuRTPOGm9bcWB8IFPfxfvzoUW1VJVAwKyPt69cvQMbxY8' +
        'dWr1oZ6OfT0tQIlIWoDw8O3Ltnd6CfL7pPfUF2BcKCKDYyfMmihYc' +
        'PHQRqhKgBuirIzxdoFwRB9K5fu2bm9GlB/r6Q0AaphAULcqjeunmz' +
        'u7OjrqYqJSEebhrQYchRAxRfsmjRyhXLgW7z9/ZEixdoqIIRUG9mW' +
        'mp4cPCunTsgak6dPLFsyWKgvbVVFUAHhwQFAMWDA/x379pZlJ/nj+' +
        'EeJNM8p0+Z8v37969fvsyaMR3i/sS4mMuXLgHj5eHDB6UlxcGBUNM' +
        'mT5ywccN6AKB7Plg=');
  MoveSideToSide := true;
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(TrackOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    result := true;
  end
  else
  begin
    writeln('Option Track could not be found');
    result := false;
  end;
  FreeBitmap(TrackOption);
end;
function Stealth : boolean;
var
StealthOption,X,Y : integer;
begin
  StealthOption := BitmapFromString(39, 13, 'meJxb39y8nr6oNSUFQtIT5QQGDr' +
        'ilDEgALkK8aRDFBPUiW4qmBs0E+liK7HGsXDwKkG1H04IreDEdj+Y' +
        'kzEBAswXTNGTFWBMSVsUMqAC/13C5E4+lREYQMT4laCn+hIQneCn0' +
        'Ka4AxJ+QMH2KK9IJBi/tENBSCElnBAAhNR1K');
  If (FindBitmapToleranceIn(StealthOption, X, Y,0,0,Width-1,Height-1,75)) Then
  begin
    Mouse(X+20,Y+5,0,0,true);;
    result := true;
  end
  else
  begin
    writeln('Option Stealth could not be found"');
    result := false;
  end;
  FreeBitmap(StealthOption);
end;
function ClickMining : boolean;
var
MiningOption,X,Y : integer;
begin
  MiningOption := BitmapFromString(29, 8, 'meJyNkk9Lw0AUxD+hSbb1qq5/wU+' +
        'geDG1KB5KpSIUD6baVNRjPbZ6axXqsfHgkkKFeojkkHoMgTjNazZL' +
        'K9QwDI9J9veWIQPXvTiv5HSNVDkrD1wXQxzH01BbYoqQy9lIxWY1O' +
        'Q7Oco6BAP8ajTLgVPOnFguQRr1+enIMAvyx2SSs9NuG/e15URQdmY' +
        'fytpPctj0l3+RciI+f8fiyWo2TZ3dnu91qAQI/2N+bwd7UrLyhF00' +
        'TBBV7bVn4AEzKX1+6WITh4f6OsHj71uvBP4dDFUgOJrWRADNHorYd' +
        'hiEleWZIbM26KpdKz0/teawsWSYsdfDTRX9jt9Z5EATU8EKsdJaIV' +
        'nQ7HZTAV1feHUdiIaffp//h/9isHF3b4GtCCN/3i4UCbv4LFOiGVA==');
  If (FindBitmapToleranceIn(MiningOption,X,Y,0,0,Width-1,Height-1,85)) Then
  begin
    MMouse(X+25,Y+5,0,0);
    result := true;
  end
  else
  begin
    writeln('Option Mining could not be found');
    result := false;
  end;
  FreeBitmap(MiningOption);
end;
function Farming(Rows,Columns : integer;BottomRight : boolean) : boolean;
var
FarmOption,X,Y,i,j : integer;
RightLeft : boolean;
begin
  RightLeft := BottomRight;
  FarmOption := BitmapFromString(23, 8, 'meJxdkQkSxCAIBB9pRDzy/2dkgdE' +
        'J2RRljRwdwOf5fNKn9FV1/NnVupnrEEVaEb1ES5VSmxUyB35PM9E0' +
        'zr7PpgGZ4FQAj2XI+d1kYwiZML5fQ1+hXcQVkFwCTwzlBv1OOtbOj' +
        'HJyEN2NRSesYpTYNm7XY9newrmYbCHnHFTGslvsASXQaIOz+LrSTv' +
        'IqCOHrfCGaIPsR/ZTXv4EHWwk5TRLyA9p7NEQ=');
  for i := 0 to Columns do
  begin
    for j := 0 to Rows do
    begin
      ClickScreen;
      Wait(WaitAfterClick);
      If (FindBitmapToleranceIn(FarmOption,X,Y,0,0,Width-1,Height-1,85)) Then
      begin
        Mouse(X+25,Y+5,0,0,true);
        result := true;
        WaitForActionFinish;
        MoveForwardOneTile;
      end
      else
      begin
      {
        if ClickTrack then
        begin
          result := true;
          WaitForActionFinish;
          MoveForwardOneTile;
        end
        else
        }
          result := false;
        writeln('Option Farm could not be found');
      end;
    end;
    if not RightLeft then
    begin
      TurnRight;
      MoveForwardOneTile;
      TurnRight;
      RightLeft := false;
    end
    else
    begin
      TurnLeft;
      MoveForwardOneTile;
      TurnLeft;
      RightLeft := true;
    end;
  end;
  FreeBitmap(FarmOption);
end;
function Woodcutting : boolean;
var
  CutDownOption,X,Y : Integer;
begin
  CutDownOption := BitmapFromString(46, 8, 'meJx1VAESwyAI++NU1Pr/d2woBlP' +
        'a9bweIoYQOEu7Sru++JI03ebay/K7rUfssaXBZuhpXrbHhEh4Bt2t' +
        '87q0aZSaV96Jg3izdwoNK/WTRZf6p1EklbnNAAlMzJ/B8JUeF8iGF' +
        'ct3jxNZ/GN8P9pM7sGHIUSItjRGvomwOKS7So7AHvebdMwnQRPPlR' +
        'FzQPgUpTkf7866CATHdP1dup3XuhPz/kvKUEkaY4LJsE5JH8/5dOl' +
        'Cow3WqrgxWdM1ea6hMiMycZJU1+kF9YVVjZqQVnPmTzlg24dWtAvs' +
        'A/5xONdm8/CiYZi0JwffgkYCGRafX4MwUfwaQDex/mo5+lf7B39KQtc=');
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(CutDownOption,X,Y,0,0,Width-1,Height-1,85)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    result := true;
  end
  else
  begin
  {
    if ClickTrack then
      result := true
    else
    }
      result := false;
    MoveForwardOneTile;
    writeln('Option Cut Down could not be found');
  end;
  FreeBitmap(CutDownOption);
end;
function ChopUpTree : boolean;
var
  ChopUpOption,X,Y : Integer;
begin
  ChopUpOption := BitmapFromString(39, 10, 'meJxlUwsShSAIPKRppt3/Gu8JC9' +
        'tmDdMgwq78ah+1j19+x3ktMaV16KZQ/wpuKZv/1+ICRkZBV9LSenn' +
        'B9h229eovpyx7u2ZdYse54ZTEL+1U5GXElSsnblmNUs8lfF7Ux59R' +
        's26Lqzkpbt0y6KxplhSlA0vm3iPE/1CSxZIyueY6LkaSkq5kRuYw7' +
        'hDztD+joAvsqC/LfFJDs3IkwllyxJEPMHBjJOntxltr9URJpmyiZB' +
        'pHoGmm6DUCQcG5emoullem74qBKG4xPFKo9KHzyNtITbPOqFv0SZ8' +
        'qfSRaTJGXQu38b2PAv88JF0q3QxTAsryxdzMyjWqgXzFX2Z3J6VLS' +
        'RBicCnZ/W0M+niHH5gZwWaIjMddG/AFnZEdo');
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(ChopUpOption,X,Y,0,0,Width-1,Height-1,85)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);
    result := true;
  end
  else
  begin
    result := false;
    writeln('Option chop up could not be found');
  end;
  FreeBitmap(ChopUpOption);
end;
function ShieldBasher : boolean;
var
  ShieldIcon,X,Y : integer;
begin
  ShieldIcon := BitmapFromString(12, 17, 'meJwNkdtv0nAUx998NV4GOMaAwV' +
        'Ypa8sKg1KglOsKlNEVBgIbbAxoCixVNi5RYSiOofO2q4kP88FbND6' +
        '4J5fo5jT+Yf6Sk/NyPvmeT85JF5t5sV2pd+utXqc3GA53v3z8/P30' +
        '9Ozsx/n5z4uLX5eXv82RDSLeRf0VK1vHAyKRlGyJGh0VfFwpsijEs' +
        '9WC2HByG8G1lxR/17fUd/Mtbv8Ee3REhmoQmVLNcKDGUcbGSmLnbb' +
        't/RCcfkKzEDt9gD19TbM3oygQSFdy/gjl5B7fZe37yeHiYk55hHiH' +
        'c3zNuDnFPgYqslKsNf2wVwkOWgBApDEpSH/hYg8JcdxeqbWGODDm3' +
        'lC2sh+N5vcnvYCuuRBsm095E00IXvI3+VLmFzSZ0JobwLOpxVo+6+' +
        'XffFo4/RJ/sz3dehGpb4c4OUu+5FwRLMI1QccgWvW3xGXt76M4xKG' +
        'R7D9t+hXafasU6KkposWpaKU+nls13csDfzFQhgjf687AnqyzeU8x' +
        'n1BSncITkTuY66bvlCqBU2hwUEJI30znEyimz4mg4BVvYcYgc0xOq' +
        'KVKpxQDjia9HEiWYTILRaGpN7otBmH900qaF7aArJ7DJ2YW82MitV' +
        'ahwTocGFfzyCMWoYScACCqgNVgBA+5AR4tccnXaHtMhXjmbAhrjkH' +
        'MKtdscbnTGJlPB4ONqPKZBaDXi1SMeGcOPEF4NRMrUiAGxyjVGGLO' +
        '///QVCIO9E6hXC7tu+qLXzA6lDldoEJBw5eqYVG/++/vnfncg01o0' +
        'RloNETfcDGBUOhwkAMBgIg8Oj/4D3nG6rw==');

  repeat
  begin
    If (FindBitmapToleranceIn(ShieldIcon,X,Y,0,0,Width-1,Height-1,85)) Then
    begin
      Mouse(X+5,Y+5,0,0,true);
      result := true;
      writeln('bashing');
    end
    else
      writeln('could not find sheild icon');
    wait(5000+random(10000));
  end
  until(false);
  FreeBitmap(ShieldIcon);
end;
function Miner : boolean;
var
MineOption,X,Y : integer;
begin
  MoveForward := true;
  MineOption := BitmapFromString(21, 8, 'meJy7c/v2pAn9/j5eENTf23Pn9m0' +
        'g4////3BBPAioDKg+yN8XyAaST548IVIjXPvihQvaW5r9fbzbWpo3' +
        'blgP0Q4nlyxa+PLlyz9//jTW1QJFEmKjr1y5DOQCLc1ITQYqSE9J3' +
        'r1zZ4CP966dOypKS9C0z587BygF1AvUAhQ5fuxYU0MdkFFTVQE0B6' +
        'gAKHvq5Ekg+eDBfWSNEBIo7u/tBUQQkV+/fv2HAaCBEAXz5szu7er' +
        'as2sX0Ato2iF6kbWHBPoj+x2oPSk+7sOHD8AQCCCk/eyZ00uXLAYy' +
        'ujs7bty4DtLu6w3UdfnSpSB/P4LaE+NjgbqAbgD6NCsjDQAFUxtz');
  ClickScreen;
  wait(WaitAfterClick);
  if ClickMining then
  begin
    wait(WaitAfterClick);
    If (FindBitmapToleranceIn(MineOption,X,Y,0,0,Width-1,Height-1,85)) Then
    begin
      Mouse(X+25,Y+5,0,0,true);
      result := true;
    end
    else
    begin
      writeln('Option Mine could not be found');
      result := false;
    end;
  end else
  result := false;
  FreeBitmap(MineOption);
end;
function MineUp : boolean;
var
MineOption,X,Y : integer;
begin
  MoveForward := true;
  MineOption := BitmapFromString(68, 8, 'meJx9lAuOBCEIRC84gnv/w7grSFG' +
        'gsx1iaJsAj0+vtcaQLWLnGGvf+Ckp8hBRvUV16gzRSa8/Lzk2YgLF' +
        'JHzKkRPUlJ2e+GNfzXLZA5Z4HZ+QGwTOXywFBIk1nHmxQAoFgRCLE' +
        'EuJ/oVF0B084VPyRrur3RdL23Q/NYzPPYi2HgjQm3OP6+eI0J6DoS' +
        'jb80TlKalzB+HWpeE8WcImb7xBrpSczzlbuGZDxdGWXqdgFiEWczu' +
        'oKXdrvvTljNlpTeBQ8qUm7DwTEL3NUE9m9Pw/3J1/WXiG2+ph058s' +
        'mmP2ZoHzIZkYFjy+ivC+SIZe8b9qyp0534xYQMbhbOuMFRaQUgWyG' +
        'vB8JQCu+tUGGLF88R8sQWTSA2XF8MOhNUehmOiPguet9aLMTB8D4d' +
        'DRo7b78xdPW1RK');
  ClickScreen;
  wait(WaitAfterClick);
  if ClickMining then
  begin
    wait(WaitAfterClick);
    If (FindBitmapToleranceIn(MineOption,X,Y,0,0,Width-1,Height-1,85)) Then
    begin
      MMouse(X+25,Y-30,0,0);
      Mouse(X+25,Y+5,0,0,true);
      result := true;
    end
    else
    begin
      writeln('Option Mine could not be found');
      result := false;
    end;
  end else
  result := false;
  FreeBitmap(MineOption);
end;
function Prospect : boolean;
var
MineOption,X,Y : integer;
MousePos : TPoint;
begin
  MoveSideToSide := true;
  ClickScreen;
  Wait(WaitAfterClick);
  MineOption := BitmapFromString(42, 10, 'meJx9VAEOAyEI+6DU/7/GzSFQQG' +
        'eI8bhKC6JrxRCBYJphfwqGCNlx/pB5jbMXb6Pg80uHuWePuQUkjLI' +
        'nS3Q39m7/2SWz03ycOpw91ersOk7XEBiicwzVe5nyYLddUArlVQFF' +
        '7RDmDSU55sszs4zpuceaK0O5W1eYH4FZeRT2h6rZ2GumdMRJjLeBV' +
        '6N0C8fhaOF/sf+vYVT+4I1dynmNdoI+16QATqe3R+06gw27oY5hUv' +
        'bYeoP7Jbrcr265HyS9DBpWSsHVdYGhvy1SteEiktk5eB71r9oHHOp' +
        'gGg==');
  if ClickMining then
  begin
    wait(WaitAfterClick);
    If (FindBitmapToleranceIn(MineOption,X,Y,0,0,Width-1,Height-1,75)) Then
    begin
      GetMousePos(MousePos.x,MousePos.y);
      MMouse(MousePos.x+100,MousePos.y,0,0);
      Mouse(X+25,Y+5,0,0,true);
      result := true;
    end
    else
    begin
      writeln('Option Prospect could not be found');
      result := false;
    end;
  end else
  result := false;
  FreeBitmap(MineOption);
end;
function FiletFish : boolean;
var
FishLocations : TPointArray;
Active : TPoint;
i,FishIcon : Integer;
begin
  result := false;
  FishIcon := BitmapFromString(12, 12, 'meJxdkO0KglAMhrubEjXTEsnv/D' +
        'hmVlh0Cf2Ibqc/QTfbo4ODKGPM7dnZ9lqxMoJ86aeL8VunLb/mvsT' +
        'c4mqGNeY3D6l+f5/X+0lghhWkFSmv7u2ksWIl1Zl3spOdHGl3ss6r' +
        'ejK0U5J3JB6xoeqVPRPxU0xIwbb1jQcB8JqZkiQ3+Zmqk3dmpFZ+N' +
        'sNkeTtpuY7l5UC3uAg2XYkpGBNRwwgO8KsgFxE0qRUbVIoUcyVgB0' +
        '3qoSSxXX3H06IDrZXsIwrgUXXQpBqOFenI0PIH1cdwwQ==');
  Active := GetInventoryLocation;
  FishLocations := GetitemLocations(FishIcon,Active);
  if not (FishLocations[0].x = 0) and not (FishLocations[0].y = 0) then
  begin
    For i := 0 to high(FishLocations) do
    begin
      if IsStack(FishLocations[i]) then
      begin
        if IsClosedStack(FishLocations[i]) then
        begin
          Mouse(FishLocations[i].x-10,FishLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not Filet(FishLocations[i]) then
        begin;
        FreeBitmap(FishIcon);
        Mouse(Width/2,Height/2,15,15,true);
        result := false;
        Exit;
        end
        else
        begin
          writeln('fileting');
          WaitForActionFinish;
        end;
      end;
    end;
  end
  else
  begin
    writeln('no fish in inventory');
  end;
  FreeBitmap(FishIcon);
end;
function FiletCookedMeat : boolean;
var
FishLocations : TPointArray;
Active : TPoint;
i,CookedMeatIcon : Integer;
begin
  result := false;
  CookedMeatIcon := BitmapFromString(13, 14, 'meJxtkUEOgjAQRbmKG0SgogQElA' +
        'KWCBI0MXHpwsO48ABuTDyHVzHG0/hJYVLBZtL8tq9/Op0R881Q6G5' +
        'srQqtG9BmlDdzIBBWlE+Tai728vR0eZbnKwLayWrsM15BML5lvJQA' +
        'BZHWcjMJ1sYixUwmknm9P8TjCD5N3lCoVmDuj1uPBCMxsuq5SQyF2' +
        'HFBbvJJpH8Mo1x1UwXpBgvapOr1XrRVd4YUf/PqHjeCrEeqV6TbLN' +
        'vhq73ySJ0awti00bhQuPkB7cDspPUQxhKN0L0YhmgKKjL8FM8Y+4m' +
        'mDHzIF7GcrIU=');
  Active := GetInventoryLocation;
  FishLocations := GetitemLocations(CookedMeatIcon,Active);
  if not (FishLocations[0].x = 0) and not (FishLocations[0].y = 0) then
  begin
    For i := 0 to high(FishLocations) do
    begin
      if IsStack(FishLocations[i]) then
      begin
        if IsClosedStack(FishLocations[i]) then
        begin
          Mouse(FishLocations[i].x-10,FishLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not Filet(FishLocations[i]) then
        begin;
        FreeBitmap(CookedMeatIcon);
        Mouse(Width/2,Height/2,15,15,true);
        result := false;
        Exit;
        end
        else
        begin
          writeln('fileting');
          WaitForActionFinish;
        end;
      end;
    end;
  end
  else
  begin
    writeln('no meat in inventory');
  end;
  FreeBitmap(CookedMeatIcon);
end;
function CreateStaffs: boolean;
var
ShaftLocations,WoodScrapLocations,LogLocations : TPointArray;
Active,BinLocation : TPoint;
i,LogIcon,WoodScrapIcon : Integer;
begin
  result := false;
  LogIcon := BitmapFromString(14, 14, 'meJxlkktOwzAQhjkJSBSVkEdToq' +
        'RpUruJkiamFLFhyQJxFhbcgJtwJ47BNww1UbEsazT69T9mHJsxMS6' +
        'qh3DdRfXupmy5waqJNuPZ8dAJyy6x+19k1cebEcBiKx0A7uX9+e2T' +
        'S50294l19HnhDMrW8yjs9eOLgksHTiGxe2gTe0cHgIdprUgMoAhsn' +
        'pnrYquEKjqFzdLytntctg+5e0rbg8cowMNiM0qEqicanN6bArSgOc' +
        '8tGKQxqQPxxqaiEsQ4gqN4ldX/jR29rXkvF6vZssLniegflXXw6Bi' +
        '1oInodG6c8yC9CDPYUIQwKBq2pkg/ZFlHeyAgKWTCxv1seZAVF433' +
        'qf4lI8h6R1Iiy9IBV70uXUXpy9+oB1bAcES0aCjmuaH4BlsIlQA=');
  WoodScrapIcon := BitmapFromString(8, 9, 'meJxTNrBQNbJSMbBkAAM1I2sgGygC' +
        'REA2UMQ9vj26eSuQARRXNrCACKob20CkQGwTOw0zByADogwCIGygY' +
        'g1zhBSEhOiC2wgXhGvHFIEoBnIheiEk0HCIY6BqjKxApKElkAEkAe' +
        'd6JZ4=');
  Active := GetInventoryLocation;
  LogLocations := GetitemLocations(LogIcon,Active);
  if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
  begin
    For i := 0 to high(LogLocations) do
    begin
      if IsStack(LogLocations[i]) then
      begin
        if IsClosedStack(LogLocations[i]) then
        begin
          Mouse(LogLocations[i].x-10,LogLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreateStaff(LogLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no logs in inventory - getting logs out of bin');
    BinLocation := GetBinLocation;
    //writeln('bin location: ' + inttostr(BinLocation.x) + ' ' + inttostr(BinLocation.y));
    LogLocations := GetitemLocations(LogIcon,BinLocation);
    if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
    begin
      MoveToInventory(LogLocations[0]);
      wait(WaitAfterClick);
    end
    else
      writeln('no logs in bin');
  end;

  //------------------ move woodscrap to bin
  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  //--------------------------

  FreeBitmap(LogIcon);
  FreeBitmap(WoodScrapIcon);
end;
function CreateShortBows : boolean;
var
WoodScrapLocations,LogLocations : TPointArray;
Active,BinLocation : TPoint;
i,LogIcon,WoodScrapIcon : Integer;
begin
  result := false;
  LogIcon := BitmapFromString(4, 7, 'meJxjYIAC9/h2IBndvBXIAJIQQSAD' +
        'joDiECk4A1kcjoC6ACTGHK4=');
  WoodScrapIcon := BitmapFromString(5, 5, 'meJyLbt7KAAPRYDYyiSzuHt+OxgCS' +
        'QDZEBEgCAGwJEU0=');
  Active := GetInventoryLocation;
  LogLocations := GetitemLocations(LogIcon,Active);
  if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
  begin
    For i := 0 to high(LogLocations) do
    begin
      if IsStack(LogLocations[i]) then
      begin
        if IsClosedStack(LogLocations[i]) then
        begin
          Mouse(LogLocations[i].x-10,LogLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreateShortBow(LogLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no logs in inventory - getting logs out of bin');
    BinLocation := GetBinLocation;
    LogLocations := GetitemLocations(LogIcon,BinLocation);
    if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
    begin
      MoveToInventory(LogLocations[0]);
      wait(WaitAfterClick);
    end
    else
      writeln('no logs in bin');
  end;

  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  FreeBitmap(LogIcon);
  FreeBitmap(WoodScrapIcon);
end;
function CreateBows : boolean;
var
WoodScrapLocations,LogLocations : TPointArray;
Active,BinLocation : TPoint;
i,LogIcon,WoodScrapIcon : Integer;
begin
  result := false;
  LogIcon := BitmapFromString(4, 7, 'meJxjYIAC9/h2IBndvBXIAJIQQSAD' +
        'joDiECk4A1kcjoC6ACTGHK4=');
  WoodScrapIcon := BitmapFromString(5, 5, 'meJyLbt7KAAPRYDYyiSzuHt+OxgCS' +
        'QDZEBEgCAGwJEU0=');
  Active := GetInventoryLocation;
  LogLocations := GetitemLocations(LogIcon,Active);
  if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
  begin
    For i := 0 to high(LogLocations) do
    begin
      if IsStack(LogLocations[i]) then
      begin
        if IsClosedStack(LogLocations[i]) then
        begin
          Mouse(LogLocations[i].x-10,LogLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreateBow(LogLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no logs in inventory - getting logs out of bin');
    BinLocation := GetBinLocation;
    LogLocations := GetitemLocations(LogIcon,BinLocation);
    if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
    begin
      MoveToInventory(LogLocations[0]);
      wait(WaitAfterClick);
    end
    else
      writeln('no logs in bin');
  end;

  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  FreeBitmap(LogIcon);
  FreeBitmap(WoodScrapIcon);
end;
function CreateArrows : boolean;
var
ArrowHeadIcon,ArrowShaftIcon,WoodScrapIcon : Integer;
begin
  result := false;
  WoodScrapIcon := BitmapFromString(8, 9, 'meJxTNrBQNbJSMbBkAAM1I2sgGygC' +
        'REA2UMQ9vj26eSuQARRXNrCACKob20CkQGwTOw0zByADogwCIGygY' +
        'g1zhBSEhOiC2wgXhGvHFIEoBnIheiEk0HCIY6BqjKxApKElkAEkAe' +
        'd6JZ4=');
  ArrowShaftIcon := BitmapFromString(13, 13, 'meJxNkV1ygjAUhdmKo2I0MgpCIx' +
        'AKBhXtQ7fgYvrQJXV7fjexGWcyd26Sc89PoutRffSbo9sYtzbDtr1' +
        'K/79lJUmiOTQuPVjqqvpcm5NuLjTLolVVTwPm8fNHVWZYFgLjilkN' +
        'edUzyEjEQM6WqV3/BU/W3XL3Tc+KGM4hCTxYWhQNPEGU2+nxS4WfL' +
        'YppadOyE1jecJjZKWJgwANXzBITGFnAK5/rpdVemcKV9rCsu9NgBs' +
        'XIQ4+H2bac78x8X+OKSg9V5MGMeD46hIQQXQvhObzhy49kH2ADQ5U' +
        'n8qIMvmeXVY/RucDE2PSuxWFaWJbkOthFXmNJmL10yKX8FwRXwun/' +
        'UfmwxHwCmIdkUA==');
  ArrowHeadIcon := BitmapFromString(5, 5, 'meJzTMLVXN7ZRNbJSM7YBMnSsXbWs' +
        'nBnAQNvKRd3UngEG1Iysde08gIJAtq6th46Vi461m4a5k4a5I5ChZ' +
        'ekMALbWDBI=');


end;
function CreateShafts : boolean;
var
ShaftLocations,WoodScrapLocations,LogLocations : TPointArray;
Active,BinLocation : TPoint;
i,LogIcon,ShaftIcon,WoodScrapIcon : Integer;
begin
  result := false;
  LogIcon := BitmapFromString(4, 7, 'meJxjYIAC9/h2IBndvBXIAJIQQSAD' +
        'joDiECk4A1kcjoC6ACTGHK4=');
  ShaftIcon := BitmapFromString(24, 6, 'meJwLj4r79ev3nz9/rl677hsQIiQ' +
        'u8////4yc/Nu37wDFQyNjgCKunr4XL10Gcl+/fg2UgqiBADj7x8+f' +
        'bZ3dQG5weNT9Bw8h4k2tHSKSckBDgHqBIjdv3fILCgMyTK3sPn78B' +
        'GRAlCEzCkvKgbbMmbfA0tYRLg40BFmNioZuS3vn2vUbgQaiaUdmAF' +
        '0CVAZUk1dYgiwOZ589dz45LTMwNFLX0AyXOUDt4VFxQEZOftGbt2+' +
        'xmgP0O9BHskrqi5YswzQHGLaScsrAMLx+4yaQDQwKiIGY5hSXVX79' +
        '+hUYMmWVNZjmHDh4CGgRAG+H0p4=');
  WoodScrapIcon := BitmapFromString(5, 5, 'meJyLbt7KAAPRYDYyiSzuHt+OxgCS' +
        'QDZEBEgCAGwJEU0=');
  Active := GetInventoryLocation;
  LogLocations := GetitemLocations(LogIcon,Active);
  if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
  begin
    For i := 0 to high(LogLocations) do
    begin
      if IsStack(LogLocations[i]) then
      begin
        if IsClosedStack(LogLocations[i]) then
        begin
          Mouse(LogLocations[i].x-10,LogLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreateShaft(LogLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no logs in inventory - getting logs out of bin');
    BinLocation := GetBinLocation;
    //writeln('bin location: ' + inttostr(BinLocation.x) + ' ' + inttostr(BinLocation.y));
    LogLocations := GetitemLocations(LogIcon,BinLocation);
    if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
    begin
      MoveToInventory(LogLocations[0]);
      wait(WaitAfterClick);
    end
    else
      writeln('no logs in bin');
  end;

  //------------------ move woodscrap to bin
  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  //--------------------------
  ShaftLocations := GetItemLocations(ShaftIcon,Active);
  if not (ShaftLocations[0].x = 0) and not (ShaftLocations[0].y = 0) then
  begin
    MoveToBin(ShaftLocations[0]);
  end
  else
    writeln('could not move shaft to bin');

  FreeBitmap(LogIcon);
  FreeBitmap(ShaftIcon);
  FreeBitmap(WoodScrapIcon);
end;
function CreateTenons : boolean;
var
TenonLocations,WoodScrapLocations,LogLocations : TPointArray;
Active,BinLocation : TPoint;
i,LogIcon,TenonIcon,WoodScrapIcon : Integer;
begin
  result := false;
  LogIcon := BitmapFromString(14, 14, 'meJxlkktOwzAQhjkJSBSVkEdToq' +
        'RpUruJkiamFLFhyQJxFhbcgJtwJ47BNww1UbEsazT69T9mHJsxMS6' +
        'qh3DdRfXupmy5waqJNuPZ8dAJyy6x+19k1cebEcBiKx0A7uX9+e2T' +
        'S50294l19HnhDMrW8yjs9eOLgksHTiGxe2gTe0cHgIdprUgMoAhsn' +
        'pnrYquEKjqFzdLytntctg+5e0rbg8cowMNiM0qEqicanN6bArSgOc' +
        '8tGKQxqQPxxqaiEsQ4gqN4ldX/jR29rXkvF6vZssLniegflXXw6Bi' +
        '1oInodG6c8yC9CDPYUIQwKBq2pkg/ZFlHeyAgKWTCxv1seZAVF433' +
        'qf4lI8h6R1Iiy9IBV70uXUXpy9+oB1bAcES0aCjmuaH4BlsIlQA=');
  TenonIcon := BitmapFromString(10, 14, 'meJxlUQsOgjAM9S4iTAQVEMbGHA' +
        'tDgyaek2Pim8M5oWma/l77up3kM70OB95vPMm6V1S2hHb72igy4zh' +
        'OH4GDMLrIVAxRIeBPK7ENDmUh69A1Y3vMtZ+JmbY9oIFRsH71KB9J' +
        'cwPEANkP6LgZLQSp1KIECGjD+kfNJaaRT5q7cdgfmVQaSML7IGPQ7' +
        'bkOcm7phXlDytZaKJb6b2I3gjzWgSrek1C1OHPGUgUnLMTuOxlzgD' +
        'K/UKk3QkmORw==');
  WoodScrapIcon := BitmapFromString(8, 9, 'meJxTNrBQNbJSMbBkAAM1I2sgGygC' +
        'REA2UMQ9vj26eSuQARRXNrCACKob20CkQGwTOw0zByADogwCIGygY' +
        'g1zhBSEhOiC2wgXhGvHFIEoBnIheiEk0HCIY6BqjKxApKElkAEkAe' +
        'd6JZ4=');
  Active := GetInventoryLocation;
  LogLocations := GetitemLocations(LogIcon,Active);
  if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
  begin
    For i := 0 to high(LogLocations) do
    begin
      if IsStack(LogLocations[i]) then
      begin
        if IsClosedStack(LogLocations[i]) then
        begin
          Mouse(LogLocations[i].x-10,LogLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreateTenon(LogLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no logs in inventory - getting logs out of bin');
    BinLocation := GetBinLocation;
    //writeln('bin location: ' + inttostr(BinLocation.x) + ' ' + inttostr(BinLocation.y));
    LogLocations := GetitemLocations(LogIcon,BinLocation);
    if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
    begin
      MoveToInventory(LogLocations[0]);
      wait(WaitAfterClick);
    end
    else
      writeln('no logs in bin');
  end;

  //------------------ move woodscrap to bin
  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  //--------------------------
  TenonLocations := GetItemLocations(TenonIcon,Active);
  if not (TenonLocations[0].x = 0) and not (TenonLocations[0].y = 0) then
  begin
    MoveToBin(TenonLocations[0]);
  end
  else
    writeln('could not move tenon to bin');

  FreeBitmap(LogIcon);
  FreeBitmap(TenonIcon);
  FreeBitmap(WoodScrapIcon);
end;
function CreatePlanks : boolean;
var
ShaftLocations,WoodScrapLocations,LogLocations : TPointArray;
Active,BinLocation : TPoint;
i,LogIcon,ShaftIcon,WoodScrapIcon : Integer;
begin
  result := false;
  LogIcon := BitmapFromString(14, 14, 'meJxlkktOwzAQhjkJSBSVkEdToq' +
        'RpUruJkiamFLFhyQJxFhbcgJtwJ47BNww1UbEsazT69T9mHJsxMS6' +
        'qh3DdRfXupmy5waqJNuPZ8dAJyy6x+19k1cebEcBiKx0A7uX9+e2T' +
        'S50294l19HnhDMrW8yjs9eOLgksHTiGxe2gTe0cHgIdprUgMoAhsn' +
        'pnrYquEKjqFzdLytntctg+5e0rbg8cowMNiM0qEqicanN6bArSgOc' +
        '8tGKQxqQPxxqaiEsQ4gqN4ldX/jR29rXkvF6vZssLniegflXXw6Bi' +
        '1oInodG6c8yC9CDPYUIQwKBq2pkg/ZFlHeyAgKWTCxv1seZAVF433' +
        'qf4lI8h6R1Iiy9IBV70uXUXpy9+oB1bAcES0aCjmuaH4BlsIlQA=');
  ShaftIcon := BitmapFromString(14, 14, 'meJx9kltOwzAQRdkJJaS1CTFt83' +
        'CaR0kfQLuHflRdSz/YATthTyyDY09kRZUguopGN0fOzB1ru9Go7FW' +
        'xnuWdrlytba/K/s4/06xR+KVzBjLvVPE6KO9gLl8/p+s3RZw18JM0' +
        'v0+yiSkeTBkZyxszYCI5OW0/THt4bt7S9p1aV1v8wAQ+tDHL2nhRo' +
        '4DBBOxw/hQyerF0G/uf/oXFy9odyCx+hJs/BoxY3ESmQIIFRgrBor' +
        'klHAJJ6v0/mK52YH7SzXjSGyxp9ggGEuHgj2HByJmuHhcrQpalkM8' +
        'YFmwIbVk7cm6nfkeYAR56Y+n+BOV3TeEug3WX4Wm1M+uj3AcaM93R' +
        't7dlWD6B4aBfz5mjkg==');
  WoodScrapIcon := BitmapFromString(8, 9, 'meJxTNrBQNbJSMbBkAAM1I2sgGygC' +
        'REA2UMQ9vj26eSuQARRXNrCACKob20CkQGwTOw0zByADogwCIGygY' +
        'g1zhBSEhOiC2wgXhGvHFIEoBnIheiEk0HCIY6BqjKxApKElkAEkAe' +
        'd6JZ4=');
  Active := GetInventoryLocation;
  LogLocations := GetitemLocations(LogIcon,Active);
  if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
  begin
    For i := 0 to high(LogLocations) do
    begin
      if IsStack(LogLocations[i]) then
      begin
        if IsClosedStack(LogLocations[i]) then
        begin
          Mouse(LogLocations[i].x-10,LogLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreatePlank(LogLocations[i]) then
        begin
          Mouse(Width/2,Height/2,15,15,true);
          Exit;
        end;
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no logs in inventory - getting logs out of bin');
    BinLocation := GetBinLocation;
    //writeln('bin location: ' + inttostr(BinLocation.x) + ' ' + inttostr(BinLocation.y));
    LogLocations := GetitemLocations(LogIcon,BinLocation);
    if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
    begin
      MoveToInventory(LogLocations[0]);
      wait(WaitAfterClick);
    end
    else
    begin
      BinLocation := GetPileLocation;
      LogLocations := GetitemLocations(LogIcon,BinLocation);
      if not (LogLocations[0].x = 0) and not (LogLocations[0].y = 0) then
      begin
        MoveToInventory(LogLocations[0]);
        wait(WaitAfterClick);
      end
      else
        writeln('no logs in bin or pile');
    end;
  end;

  //------------------ move woodscrap to bin
  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
    MoveToPile(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  //--------------------------

  wait(WaitAfterClick);

  ShaftLocations := GetItemLocations(ShaftIcon,Active);
  if not (ShaftLocations[0].x = 0) and not (ShaftLocations[0].y = 0) then
  begin
    MoveToBin(ShaftLocations[0]);
    MoveToPile(ShaftLocations[0]);
  end
  else
    writeln('could not move planks to bin');

  FreeBitmap(LogIcon);
  FreeBitmap(ShaftIcon);
  FreeBitmap(WoodScrapIcon);
end;
function CreateWhetstones : boolean;
var
WhetstoneLocations,RockShardLocations : TPointArray;
Active,BinLocation : TPoint;
i,RockShardIcon,WhetstoneIcon : Integer;
begin
  result := false;
  RockShardIcon := BitmapFromString(15, 10, 'meJxdkFsSgjAMRV0K1kcriqCWIv' +
        'hA0R3644xLUbfhOK7GoxnyQSbDXG5OmzTDrHRFY/Pa+v14uYnLk8v' +
        'r3j9cccR0oR5mJaUo8ZSm1Vl8HMFe7w+JABtka5MEtEmL/l+Ir5jk' +
        '9XbptSFnifvjKb5iOAJr6XfborTthMp0LpcEYEiSJ4yWlfKUVChJ2' +
        'NWW58fVyYUDAkeBDikCZrJufve383RCl0l39qa/MrN0ZPni8I1mvp' +
        '/kZh7ASE7pS9E0op3w1u9MGlgs/he9aojF');
  WhetstoneIcon := BitmapFromString(16, 12, 'meJx9kdEOgjAMRf0URJCpIApjCB' +
        'K2qOHB//8gT9fomzRL05beS3ubnt3ucssuw765E+TNSPyr4KkU7ZQ' +
        '1Y1o70wdt4BOPWH1aRZLroFj6FVvYWbF403mKWiEgJSA1LpzGl+kf' +
        'VOr5TREGGjb/jU4etOV9gWHfThSX/8bX4/AsOs+PijiG8qxDGAOUb' +
        'Hd2pNbalZEw9j3cHr/dFbJieZwf8rTu0VYhK8aaaKWCyxW+4mcxhU' +
        'TPoWOI5p2XeaI+ojyCo1sf5ATxCuKjGiqOqOqCHEK8tClzUtqkbKO' +
        '3HHpbdXp94zzADzopXyU=');
  Active := GetInventoryLocation;
  RockShardLocations := GetitemLocations(RockShardIcon,Active);
  if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
  begin
    For i := 0 to high(RockShardLocations) do
    begin
      if IsStack(RockShardLocations[i]) then
      begin
        if IsClosedStack(RockShardLocations[i]) then
        begin
          Mouse(RockShardLocations[i].x-10,RockShardLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreateWhetstone(RockShardLocations[i]) then
        begin
          Mouse(Width/2,Height/2,15,15,true);
          Exit;
        end;
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no shardss in inventory - getting shardss out of bin');
    BinLocation := GetBinLocation;
    //writeln('bin location: ' + inttostr(BinLocation.x) + ' ' + inttostr(BinLocation.y));
    RockShardLocations := GetitemLocations(RockShardIcon,BinLocation);
    if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
    begin
      MoveToInventory(RockShardLocations[0]);
      wait(WaitAfterClick);
    end
    else
    begin
      BinLocation := GetPileLocation;
      RockShardLocations := GetitemLocations(RockShardIcon,BinLocation);
      if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
      begin
        MoveToInventory(RockShardLocations[0]);
        wait(WaitAfterClick);
      end
      else
        writeln('no shards in bin or pile');
    end;
  end;


  wait(WaitAfterClick);

   {
  RockShardLocations := GetItemLocations(RockShardIcon,Active);
  if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
  begin
    MoveToBin(RockShardLocations[0]);
  end
  else
    writeln('could not move RockShards to bin');
    }
    {
  WhetstoneLocations := GetItemLocations(WhetstoneIcon,Active);
  if not (WhetstoneLocations[0].x = 0) and not (WhetstoneLocations[0].y = 0) then
  begin
    MoveToPile(WhetstoneLocations[0]);
    writeln('moving whetstones to bin');
  end
  else
    writeln('could not move whetstones to pile');
     }
  FreeBitmap(RockShardIcon);
  FreeBitmap(WhetstoneIcon);
end;
function CreateGrindstones : boolean;
var
WhetstoneLocations,RockShardLocations : TPointArray;
Active,BinLocation : TPoint;
i,RockShardIcon,WhetstoneIcon : Integer;
begin
  result := false;
  RockShardIcon := BitmapFromString(15, 10, 'meJxdkFsSgjAMRV0K1kcriqCWIv' +
        'hA0R3644xLUbfhOK7GoxnyQSbDXG5OmzTDrHRFY/Pa+v14uYnLk8v' +
        'r3j9cccR0oR5mJaUo8ZSm1Vl8HMFe7w+JABtka5MEtEmL/l+Ir5jk' +
        '9XbptSFnifvjKb5iOAJr6XfborTthMp0LpcEYEiSJ4yWlfKUVChJ2' +
        'NWW58fVyYUDAkeBDikCZrJufve383RCl0l39qa/MrN0ZPni8I1mvp' +
        '/kZh7ASE7pS9E0op3w1u9MGlgs/he9aojF');
  WhetstoneIcon := BitmapFromString(16, 12, 'meJx9kdEOgjAMRf0URJCpIApjCB' +
        'K2qOHB//8gT9fomzRL05beS3ubnt3ucssuw765E+TNSPyr4KkU7ZQ' +
        '1Y1o70wdt4BOPWH1aRZLroFj6FVvYWbF403mKWiEgJSA1LpzGl+kf' +
        'VOr5TREGGjb/jU4etOV9gWHfThSX/8bX4/AsOs+PijiG8qxDGAOUb' +
        'Hd2pNbalZEw9j3cHr/dFbJieZwf8rTu0VYhK8aaaKWCyxW+4mcxhU' +
        'TPoWOI5p2XeaI+ojyCo1sf5ATxCuKjGiqOqOqCHEK8tClzUtqkbKO' +
        '3HHpbdXp94zzADzopXyU=');
  Active := GetInventoryLocation;
  RockShardLocations := GetitemLocations(RockShardIcon,Active);
  if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
  begin
    For i := 0 to high(RockShardLocations) do
    begin
      if IsStack(RockShardLocations[i]) then
      begin
        if IsClosedStack(RockShardLocations[i]) then
        begin
          Mouse(RockShardLocations[i].x-10,RockShardLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not CreateGrindstone(RockShardLocations[i]) then
        begin
          Mouse(Width/2,Height/2,15,15,true);
          Exit;
        end;
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no shardss in inventory - getting shardss out of bin');
    BinLocation := GetBinLocation;
    //writeln('bin location: ' + inttostr(BinLocation.x) + ' ' + inttostr(BinLocation.y));
    RockShardLocations := GetitemLocations(RockShardIcon,BinLocation);
    if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
    begin
      MoveToInventory(RockShardLocations[0]);
      wait(WaitAfterClick);
    end
    else
    begin
      BinLocation := GetPileLocation;
      RockShardLocations := GetitemLocations(RockShardIcon,BinLocation);
      if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
      begin
        MoveToInventory(RockShardLocations[0]);
        wait(WaitAfterClick);
      end
      else
        writeln('no shards in bin or pile');
    end;
  end;


  wait(WaitAfterClick);

   {
  RockShardLocations := GetItemLocations(RockShardIcon,Active);
  if not (RockShardLocations[0].x = 0) and not (RockShardLocations[0].y = 0) then
  begin
    MoveToBin(RockShardLocations[0]);
  end
  else
    writeln('could not move RockShards to bin');
    }
    {
  WhetstoneLocations := GetItemLocations(WhetstoneIcon,Active);
  if not (WhetstoneLocations[0].x = 0) and not (WhetstoneLocations[0].y = 0) then
  begin
    MoveToPile(WhetstoneLocations[0]);
    writeln('moving whetstones to bin');
  end
  else
    writeln('could not move whetstones to pile');
     }
  FreeBitmap(RockShardIcon);
  FreeBitmap(WhetstoneIcon);
end;
function CreateArrowShafts : boolean;
var
ShaftLocations,WoodScrapLocations,ArrowShaftLocations : TPointArray;
Active,BinLocation : TPoint;
i,ShaftIconBin,ShaftIconInventory,WoodScrapIcon,ArrowShaftIcon : Integer;
begin
  result := false;
  ShaftIconBin := BitmapFromString(11, 11, 'meJwTEJUUwIEYGBhwSUFko5u34l' +
        'IDkXWPb8eqYPjJwtXgkQUArT4rrg==');
  ShaftIconInventory := BitmapFromString(11, 11, 'meJwTEJUUwIEYGBhwSUFko5u34l' +
        'IDkXWPb8eqYPjJwtXgkQUArT4rrg==');
  WoodScrapIcon := BitmapFromString(8, 9, 'meJwTEpcRAiMGMBCCceGC7vHt0c1b' +
        'kaUgbIgUXBzIgCiDAGQtcC6EhOtCVgm3BasI3BCIXjR7kdXAHQkAW' +
        'l0ecg==');
  ArrowShaftIcon := BitmapFromString(13, 13, 'meJwTEJUUwIsYGBjwK4CoiW/ejl' +
        '8lFdW4x7dTRQ217KKnOQTVEB9rAAIvMFg=');
  Active := GetInventoryLocation;

  ShaftLocations := GetItemLocations(ShaftIconInventory,Active);
  writeln(inttostr(ShaftLocations[0].x) + ' ' + inttostr(ShaftLocations[0].y));
  if not (ShaftLocations[0].x = 0) and not (ShaftLocations[0].y = 0) then
  begin
    For i := 0 to high(ShaftLocations) do
    begin;
      if IsStack(ShaftLocations[i]) then
      begin
        if IsClosedStack(ShaftLocations[i]) then
        begin
          Mouse(ShaftLocations[i].x-10,ShaftLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
      if not CreateArrowShaft(ShaftLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no shafts in inventory - getting shafts out of bin');
    BinLocation := GetBinLocation;
    ShaftLocations := GetitemLocations(ShaftIconBin,BinLocation);
    if not (ShaftLocations[0].x = 0) and not (ShaftLocations[0].y = 0) then
    begin
      MoveToInventory(ShaftLocations[0]);
      result := true;
      wait(WaitAfterClick);
    end
    else
      writeln('no shafts in bin');
  end;

  //------------------ move woodscrap to bin
  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  //--------------------------
  //------------------ move arrow shafts to bin
  ArrowShaftLocations := GetItemLocations(ArrowShaftIcon,Active);
  if not (ArrowShaftLocations[0].x = 0) and not (ArrowShaftLocations[0].y = 0) then
  begin
    MoveToBin(ArrowShaftLocations[0]);
  end
  else
    writeln('could not move Arrow Shaft to bin');
  //--------------------------
  FreeBitmap(ShaftIconBin);
  FreeBitmap(ShaftIconInventory);
  FreeBitmap(WoodScrapIcon);
  FreeBitmap(ArrowShaftIcon);
end;
function CreatePegs : boolean;
var
ShaftLocations,WoodScrapLocations,ArrowShaftLocations : TPointArray;
Active,BinLocation : TPoint;
i,ShaftIconBin,ShaftIconInventory,WoodScrapIcon,PegIcon : Integer;
begin
  result := false;
  ShaftIconBin := BitmapFromString(11, 11, 'meJxlkMsOgjAQRfsxRpGKCAGRZ7' +
        'EI+A7RpQs/xoVf5P95sBuCzWQyze25Mx2Z1Mvi4JanVXmWcUVwdfI' +
        '9VyGEvdFBe/frjgjqm6uOTn6g9vQF9fH6kGFd1eN+1c3CYhrkdqSN' +
        '2j7f/QOorCWvtmfM8RyqIICEp68482yoYmvmoYuTt/6u+3depI0Vl' +
        'RQj50XWGBWQsfnIUJVJTcyj0gqVHVcj1iyEqUyLUV8QvsnkULSeeI' +
        'm1VriJ35FpA04G7HerTvK35C+eolFK');
  ShaftIconInventory := BitmapFromString(11, 11, 'meJxlkMsOgjAQRfsxRpGKCAGRZ7' +
        'EI+A7RpQs/xoVf5P95sBuCzWQyze25Mx2Z1Mvi4JanVXmWcUVwdfI' +
        '9VyGEvdFBe/frjgjqm6uOTn6g9vQF9fH6kGFd1eN+1c3CYhrkdqSN' +
        '2j7f/QOorCWvtmfM8RyqIICEp68482yoYmvmoYuTt/6u+3depI0Vl' +
        'RQj50XWGBWQsfnIUJVJTcyj0gqVHVcj1iyEqUyLUV8QvsnkULSeeI' +
        'm1VriJ35FpA04G7HerTvK35C+eolFK');
  WoodScrapIcon := BitmapFromString(8, 9, 'meJxTNrBQNbJSMbBkAAM1I2sgGygC' +
        'REA2UMQ9vj26eSuQARRXNrCACKob20CkQGwTOw0zByADogwCIGygY' +
        'g1zhBSEhOiC2wgXhGvHFIEoBnIheiEk0HCIY6BqjKxApKElkAEkAe' +
        'd6JZ4=');
  PegIcon := BitmapFromString(10, 14, 'meJxlUQsOgjAM9S4iTAQVEMbGHA' +
        'tDgyaek2Pim8M5oWma/l77up3kM70OB95vPMm6V1S2hHb72igy4zh' +
        'OH4GDMLrIVAxRIeBPK7ENDmUh69A1Y3vMtZ+JmbY9oIFRsH71KB9J' +
        'cwPEANkP6LgZLQSp1KIECGjD+kfNJaaRT5q7cdgfmVQaSML7IGPQ7' +
        'bkOcm7phXlDytZaKJb6b2I3gjzWgSrek1C1OHPGUgUnLMTuOxlzgD' +
        'K/UKk3QkmORw==');
  Active := GetInventoryLocation;

  ShaftLocations := GetItemLocations(ShaftIconInventory,Active);
  writeln(inttostr(ShaftLocations[0].x) + ' ' + inttostr(ShaftLocations[0].y));
  if not (ShaftLocations[0].x = 0) and not (ShaftLocations[0].y = 0) then
  begin
    For i := 0 to high(ShaftLocations) do
    begin;
      if IsStack(ShaftLocations[i]) then
      begin
        if IsClosedStack(ShaftLocations[i]) then
        begin
          Mouse(ShaftLocations[i].x-10,ShaftLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
      if not CreatePeg(ShaftLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no shafts in inventory - getting shafts out of bin');
    BinLocation := GetBinLocation;
    ShaftLocations := GetitemLocations(ShaftIconBin,BinLocation);
    if not (ShaftLocations[0].x = 0) and not (ShaftLocations[0].y = 0) then
    begin
      MoveToInventory(ShaftLocations[0]);
      result := true;
      wait(WaitAfterClick);
    end
    else
      writeln('no shafts in bin');
  end;

  //------------------ move woodscrap to bin
  WoodScrapLocations := GetItemLocations(WoodScrapIcon,Active);
  if not (WoodScrapLocations[0].x = 0) and not (WoodScrapLocations[0].y = 0) then
  begin
    MoveToBin(WoodScrapLocations[0]);
  end
  else
    writeln('could not move woodscrap to bin');
  //--------------------------
  //------------------ move pega to bin
  ArrowShaftLocations := GetItemLocations(PegIcon,Active);
  if not (ArrowShaftLocations[0].x = 0) and not (ArrowShaftLocations[0].y = 0) then
  begin
    MoveToBin(ArrowShaftLocations[0]);
  end
  else
    writeln('could not move peg to bin');
  //--------------------------
  FreeBitmap(ShaftIconBin);
  FreeBitmap(ShaftIconInventory);
  FreeBitmap(WoodScrapIcon);
  FreeBitmap(PegIcon);
end;
function Mill(IconLocation : TPoint) : boolean;
var
  X,Y,CreateOption,FoodOption,FlourOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  FoodOption := BitmapFromString(23, 8, 'meJxlUQkOgDAIe6Q7UPz/N+ZoNwQ' +
        '1ZGmwLWUbI32lS+knq25gWK5Vp86ztJdGYQXfK0nYdAwAgja4zdNN' +
        'tq1ghIRgaZyRYTJprs2rDGYgk0X87UD4N7dsiJclGkz07UAb+SsAE' +
        'nIj6zTbyycu25Bz7yXRxG8pJuGlcfrELOCbg47a4zqWNjxK/pU7Nk' +
        'j9UWj4AFN1NEI=');
  FlourOption := BitmapFromString(21, 8, 'meJx9UAkOwCAI+yQq4v7/DSd2IGo' +
        'yQgg0tByJJbH03j2ql5q4Uam5tpmLuyIslNnaFmunC+h000tV0Liw' +
        'QweG5iW777mxrE3jN51HTsDDOCD3zjNpKH0u+fRwKXBoHjpe0i8dD' +
        'ffrrGwH3Xceb0dUt9PilPC6Jz4TybjLBV93jRY5');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75)  then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(FoodOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(FlourOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        Mouse(X+25,Y+5,0,0,true);
        writeln('milling');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(FoodOption);
  FreeBitmap(FlourOption);
end;
function MillOats : boolean;
var
ItemLocations : TPointArray;
Active : TPoint;
i,OatIcon : Integer;
begin
  result := false;
  OatIcon := BitmapFromString(14, 8, 'meJxNjo0SgiAQhB+lP1IynYxUBJo' +
        'yqd7/jWxhm6ubm5vlY/dAnd3eeNW67WnI01Jsmn7ddKvKgCzLsmtH' +
        'befKx9QuHv0TE12HNxqi7O8wwIkrChZ42d2U8UL+NUpnQ2ECs5jf/' +
        'T5CH8ZZOGzl5UqnCCk66/DiTq6lM5Fh0nYiwRWJ7CTnx9IxR35Z+2' +
        'CEVeSnhTArn/kAuuynfw==');
  Active := GetInventoryLocation;
  ItemLocations := GetitemLocations(OatIcon,Active);
  if not (ItemLocations[0].x = 0) and not (ItemLocations[0].y = 0) then
  begin
    For i := 0 to high(ItemLocations) do
    begin
      if IsStack(ItemLocations[i]) then
      begin
        if IsClosedStack(ItemLocations[i]) then
        begin
          Mouse(ItemLocations[i].x-10,ItemLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not Mill(ItemLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no oats in inventory');
  end;
  FreeBitmap(OatIcon);
end;
function MixDough(IconLocation : TPoint) : boolean;
var
  X,Y,CreateOption,FoodOption,DoughOption : Integer;
begin
  CreateOption := BitmapFromString(33, 10, 'meJxtUwkSwyAIfGTQEE3//4xWWK' +
        'BrWofJwMolS+S8hKTpYKXMBOev59F1SQPe1YR8TFJ/53FE4/aaobi' +
        'c49WvGTJuV/CdFpgJoUgWhc9yqFg4L9y/kzsxMzvcC2UGM0sm53wg' +
        'eNQCEdjcB6eK8qtZZzMnpq4rRnpgkl0jRCdChOYpjtT0vkjmlxx1u' +
        'dUtMYu616Nh7o2RViX+OXOtRjsQIM1ZiEd6RXC3NawYZoyU6V5g0W' +
        '3I4m7ca4uW7rtk5nabHDXaKG7YXtGVR4pjjLQzFKMmzGJH/C9IczD' +
        'jj1Sdd57/lF2wUbbDuaX8fN9tLGEI0vJUP8j/87A=');
  FoodOption := BitmapFromString(23, 8, 'meJxlUQkOgDAIe6Q7UPz/N+ZoNwQ' +
        '1ZGmwLWUbI32lS+knq25gWK5Vp86ztJdGYQXfK0nYdAwAgja4zdNN' +
        'tq1ghIRgaZyRYTJprs2rDGYgk0X87UD4N7dsiJclGkz07UAb+SsAE' +
        'nIj6zTbyycu25Bz7yXRxG8pJuGlcfrELOCbg47a4zqWNjxK/pU7Nk' +
        'j9UWj4AFN1NEI=');
  DoughOption := BitmapFromString(29, 8, 'meJx1UQEOxCAIe6RDUff/b3iMIjL' +
        'dmcZAAYFK3K5Sr8LEbYwhhrgkED6zudwcuXYKzOOKUarUwgXInq1U' +
        '+wq1W4BCRB0b466ONNupMfQQdw+NebwE5QidVcYv0lxEX4wuC1n8f' +
        'Zsqc+zojE01SUiRIcK8QYZGXfFiVs7cCPBeKRe0TjYJPySVh5k3oD' +
        'mB0fwU5o9S7FrJGPu03zmHmLL17Vuj178vc7ns+wJztoaYP5YGhqE=');
  result := false;
  Mouse(IconLocation.X+25,IconLocation.Y+5,0,0,false);
  wait(WaitAfterClick);
  if FindBitmapToleranceIn(CreateOption,X,Y,IconLocation.x,0,Width-1,Height-1,75)  then
  begin
    MMouse(X+25,Y+5,0,0);
    wait(WaitAfterClick);
    if FindBitmapToleranceIn(FoodOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
    begin
      MMouse(X+25,Y+5,0,0);
      wait(WaitAfterClick);
      if FindBitmapToleranceIn(DoughOption,X,Y,IconLocation.x,0,Width-1,Height-1,75) then
      begin
        Mouse(X+25,Y+5,0,0,true);
        writeln('mixing');
        result := true;
      end;
    end;
  end;
  FreeBitmap(CreateOption);
  FreeBitmap(FoodOption);
  FreeBitmap(DoughOption);
end;
function MixDoughs : boolean;
var
ItemLocations : TPointArray;
Active : TPoint;
i,FlourIcon : Integer;
begin
  result := false;
  FlourIcon := BitmapFromString(10, 8, 'meJzTt/diYGC4duMWHO3es5cBDHS' +
        's3ZClgOJAcsbsyUAGkIRIQQSREVAKjiAKkBlUQUCr8UhpmTsx4ADa' +
        'Vq4Aos19lQ==');
  Active := GetInventoryLocation;
  ItemLocations := GetitemLocations(FlourIcon,Active);
  if not (ItemLocations[0].x = 0) and not (ItemLocations[0].y = 0) then
  begin
    For i := 0 to high(ItemLocations) do
    begin
      if IsStack(ItemLocations[i]) then
      begin
        if IsClosedStack(ItemLocations[i]) then
        begin
          Mouse(ItemLocations[i].x-10,ItemLocations[i].y+5,0,0,true);
          result := true;
        end;
      end else
      begin
        if not MixDough(ItemLocations[i]) then
        Mouse(Width/2,Height/2,15,15,true);
        WaitForActionFinish;
        result := true;
      end;
    end;
  end
  else
  begin
    writeln('no flour in inventory');
  end;
  FreeBitmap(FlourIcon);
end;
function PackerCultivator : boolean;
var
PackOption,CultivateOption,X,Y : integer;
begin
  PackOption := BitmapFromString(22, 8, 'meJxtUAkOwCAIeyROcf7/HRtSqew' +
        'ghCDQUryubaX1UtVcLDY99ISLF6e3LrVZnMNRycBVt6c7GVYxGKxi' +
        'k+KLBKgXgyewxeCLYMK9ASdDsCm7mMRG8DAHivHxD+65eOhgCxeBI' +
        'QsGf/i+5VcDleQu/4ECCP/ObP053wIeVwBb+8h3uYaxVDnJDYRNKSA=');
  CultivateOption := BitmapFromString(40, 8, 'meJx1UwsShSAIPGSCmnX/Y/SIXxv' +
        'TaxyGFNllQeqTxn7Fx3OR7ojTbkdtn3JkYWLz15dcMUcvSnzrw3bE' +
        'kUixulmXHr38O0MQaEHMrYY9QOnHylQaOTIhoA8DMsLs9rD87FUsw' +
        '7rgS3pYteefK8NQxlQJjwhqN8IpOGueqHcVnYPeSlyxGw9bD7cvVZ' +
        'GzNdTS8n4I+b6fCIG42Bf/5dG+lCHAKqem+aYXm1J1GorlOxVuNCi' +
        '8jAoq8BrFmAecJeSfjcbrJT8FsRwnDPinM8Umdry0QNTOSjlm5nlQ' +
        'Oo3YqaSKT8Acfo/cD0LmG44=');
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(PackOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);;
    result := true;
  end
  else
  begin
    writeln('Option Pack could not be found"');
  end;
  WaitForActionFinish;
  ClickScreen;
  Wait(WaitAfterClick);
  If (FindBitmapToleranceIn(CultivateOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);;
    result := true;
  end
  else
  begin
    writeln('Option Cultivate could not be found"');
  end;
  FreeBitmap(CultivateOption);
  FreeBitmap(PackOption);
end;
function Steal(StealX,StealY : integer) : boolean;
var
StealIcon,X,Y : integer;
begin
  StealIcon := BitmapFromString(23, 8, 'meJzzji48ee7qz1+/v//4efTUBb/' +
        '4Mm27mL2Hz6iY+qka+8rpuSoZemm7pGg7xctoOyia+CiZeKuYByib' +
        'BSoYeahaBCoaef3////u/ccFNT2qFv7Kxp4F9ZOePH+tYRcBFDfwT' +
        'NdyjJHWs5PRcVQ29Vcx81c08JDRslM09ZE38FA2BWr3VDD2UjELAC' +
        'r+9PmLg0+CsinQCh8ViwB5Azdtl+T/YKBo7GnpnXzy7KXfv39fvHL' +
        'd1j1K0dAjMKHkyvXbQJE3b98XVHUoGHoCVebVTgByj5661DV5fmhS' +
        'iYK+u6KpN1BczTpM3tBjx/7jcRnlymZeMZm1J89cBHrk9r2HcXnNq' +
        'ub+Dn5JQAcoGfsAFSsYuKmY+URn1zd3zzx/+XpV+ywlU3+gOFC9nL' +
        '7zz5+//sPA799/VC2CDexDeyYv2LLn2O17j4CCcjpOQFLTIQYYPqr' +
        'mIbqumbpOMV++fFM29QWKK5v6KRh5AQ3RsAyQ1XZUMvJQNg9UMva6' +
        'cOVmdmlrXE6dlVc8UJmGbQyQfPz0hXtkkbplqKp5ENC/127ek1Kz+' +
        'fP3r5qpl5yu6/4jp/pmLFEwdM8qbT136bqiAchYp8AkLWv/Fet3gn' +
        'xtFQok3SNy9h06BfQdMKyOnb7oEp4LNO3IyQtAxfIG7hYe0UC9QPa' +
        'N2w9cQ7KAUVzXOevbtx+fPn+t65gG1A4JEwCNyRkP');
  repeat
  begin
    Mouse(StealX,StealY,20,0,false);
    Wait(WaitAfterClick);
    If (FindBitmapToleranceIn(StealIcon,X,Y,0,0,Width-1,Height-1, 75)) Then
    begin
      Mouse(X+25,Y+5,0,0,true);;
      result := true;
    end
    else
    begin
      result := false;
    end;
    wait(random(700));
  end
  until(false);
  FreeBitmap(StealIcon);
end;
function PickLock(StealX,StealY : integer) : boolean;
var
LockIcon,X,Y : integer;
begin
  LockIcon := BitmapFromString(40, 8, 'meJw1UmlPE2EQ/h+Gdnff3W0Xe2z' +
        'bPVq6hSJr2227bWm1RaAYUSTyQSV+EDXEIx6JisYLb4wKXlGMMd6J' +
        'eABiBDyIERVEEI0af4BiNThvG98Pm9nJMzPP88zMzuL35+/fr99/L' +
        'G3exshx+KWcIUauRK4I6QpSrigSE6QYwXmXZrCrrDdNOSPm0jQrV9' +
        'JSDPJIiNBilPOlocTkTRNChBKjSNC50lrSFaLlStaXphwhQJLOMOE' +
        'IkPmYLVlgmVdXvWLDxNQXs1LFKdWcUkU6NOhGCXGTkqbdSa60GpCM' +
        'B5cD3qQsRHhQFSPgucX+Wqu6BElxgJGuMAylhCgtJQzWclqOmT0pR' +
        'k6xnlSBORQCAGLgDJ1J+/xc7o9FXYyZlNWUp1f1D47MzPwGMpmG9S' +
        'ivi/EkG1t2dl6+xZQsBGmgkZESkOe8i5TokuGRUegw/GpU0etBkTt' +
        'U1zswjDtMfs4sW4sEPKu4PFu/cmPnldtYOx+kZb1p3e437ydIZyjv' +
        'c/jew6ftHRcZKdbQvGV84pPZl4G8tSxz5UYP6QxSjgDl0EAa58M+0' +
        'M7wg75nbYdOk/z8PYfPPnryHPZ1p6e//cR5Ro4ub940NjEF+wIkr2' +
        'a7bz2yBxtm/7/pL9+yTa3AoeAA8CQcapG1lAS3HQFWxHqPd15t3XG' +
        'QxkbplBhBYoyVk9gfXxXgaUnn/LW0qEOMBA2+rBxn5CQtVRLOAOPG' +
        'yJPnrm9u66Dz3cArk5Ky+BaZvCkk6biPHIUqRtbncB6DxU/woaK5J' +
        'ZDfeaBj39FOg6UCDDHaKkge3wzkDdaKwhSSD3Bl2Z+/ZgjrPMiYlC' +
        'TJa0iOw06NfACQuw6e2n+sC4n4es1KxmD1U1KYKUkAz/zcZE/f0N6' +
        'jXYStoqaxZezDFGlXcX+beqH7ZihZb/JlkASqYyh/VwQffDww3NZ+' +
        'hnYn9h7uetg/COru9w5CXGRTa5taxz9OE64w3qCoX7p2N9W4Kb9Nj' +
        'RZ0Q7HfaPEXWLHeBaI//eTZi1wu9258MpFdg/L3A7Rbth85ee4acm' +
        'lGW8BoVwuOGR1BX2zpy9dv4a6GXo16tDqw160tHhgagcy7sY/x7Gq' +
        '4eeytnFi79cDxs93/ANFOsmU=');
  repeat
  begin
    Mouse(StealX,StealY,5,5,false);
    Wait(WaitAfterClick);
    If (FindBitmapToleranceIn(LockIcon,X,Y,0,0,Width-1,Height-1, 75)) Then
    begin
      Mouse(X+25,Y+5,0,0,true);;
      result := true;
    end
    else
    begin
      result := false;
    end;
    wait(10000+random(5000));
  end
  until(false);
  FreeBitmap(LockIcon);
end;
function ClickFlatten : boolean;
var
FlatOption,X,Y : integer;
begin
  FlatOption := BitmapFromString(33, 10, 'meJxlUwESwyAIe+IUqP//yQYEI3' +
        'Ye51mEhIAdY47pS9xGN9EZZqKwhzbV3J9X8am21HzHLa50iPjun+4' +
        'fY37v9UlPEnWWQHA/8HEoUttWFIX/ooDHK3dYB0+i0AIKaimKPBxd' +
        'kGBHAvFTo1NIUlgz3SqE0oD/WpTGGOT2gKBoODvLoGurq/q9zg6Lo' +
        'QD5aJTyYDp+Tgq9VB8Ee1WuNwX13hVaRi68AWQhjJWggYBC5VnPog' +
        'rOArPjHNl899izLFlAIbdYFi+7BkSS9LyohG0URqXI+qNQ2IzdOKm' +
        '7RdW3yYMUHbvEDkS6PptCqbQsiFJOdak/+3yZf/ZqguxfCek/fr75' +
        '8g==');
  If (FindBitmapToleranceIn(FlatOption, X, Y,0,0,Width-1,Height-1, 75)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);;
    result := true;
  end
  else
  begin
    writeln('Option Flatten could not be found"');
    result := false;
  end;
  FreeBitmap(FlatOption);
end;
function ClickEat : boolean;
var
  EatOption,X,Y : integer;
begin
  EatOption := BitmapFromString(16, 10, 'meJyVkFsOACEIA69ouf9dVqMbMk' +
        'h/bAghOikPaegxvqr1EvgN6TDkd1EUyEuWDwTbsbbz7FycnX/GjzU' +
        'Hy6cn/e3842KyS+cp7kv/PsZ1osA9k5yNAvmR');
  If (FindBitmapToleranceIn(EatOption,X,Y,0,0,Width-1,Height-1,85)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);;
    result := true;
  end
  else
  begin
    writeln('Option Eat could not be found"');
    result := false;
  end;
  FreeBitmap(EatOption);
end;
function ClickDrink : boolean;
var
  DrinkOption,X,Y : integer;
begin
  DrinkOption := BitmapFromString(25, 10, 'meJwLDw8Lpx76jwRwKSBSHFkEly' +
        '4yjIJzsZJojsfDQDMKTQGm43GJY1VGUASrXvKMwuMqrL4mySi08Iw' +
        'gxSiS4j0ChvArAwAg+XpD');
  If (FindBitmapToleranceIn(DrinkOption,X,Y,0,0,Width-1,Height-1,85)) Then
  begin
    Mouse(X+25,Y+5,0,0,true);;
    result := true;
  end
  else
  begin
    writeln('Option Drink could not be found"');
    result := false;
  end;
  FreeBitmap(DrinkOption);
end;
procedure CheckFood;
var
FoodBar,MealIcon,x,y : integer;
MealLocations : TPointArray;
InventoryLocation : TPoint;
begin
  FoodBar := BitmapFromString(64, 7, 'meJzVlEsSwiAMhnusFi8g4FUA76g' +
        'LXeuBDI+EENLpwoUj8y0YyOMnSbssf79s2DguAsanATi0BdiIK+IC' +
        'XE+EB6pvdscIoQVBDN+LjE5YslAE6H+87sSz8p7gBvPtIc391lPMa' +
        'F6HBrn+kdfEaMUv1aPu8NuI1PonWX9HvQvrOazY34285ibOqWVSam' +
        'syoL9qrg1SbHjrR/3tsUzJqL/Z2D39O3OoiMehhfhCXtPfD0vqQfw' +
        '4ikp83gLUj4mY/vyErl+rtpfjPejv3xcz/u2v4/v1AWMLhMc=');
  if not FindBitmapToleranceIn(FoodBar,x,y,0,0,Width-1,Height-1,75) then
  begin
      MealIcon := BitmapFromString(16, 16, 'meJx1UttNw0AQpAUaICIk9mFixW' +
        'fic/xQbEx4SPzyxweCVvigACSERB20ghA0QBnMepLlZIS1stZ7M7N' +
        'z3p3a0rjWuOZw2QVpHWaNyZq4vkQxXKxQNHmLd1ScmvwkPK4DWwGA' +
        'ylG5BmBn++CIiaj1IqgcJMuJLUTTtTy9eXi7uH1kfvf8be+/hJKLP' +
        'mAwMEmK8dwRyVAk36TABmCjyNIDZRVPmAaIKM6qcwSc++LvH58vr0' +
        '+kqL5SoI8rIFFxUv7Dw9XUFqoP1sCVT0FlP87oX2F+MriI6GNAW7z' +
        '+Rv2x7KKs/spnMkHXsL57PdLwm/IU4urfhylXKWwNcJBWmBcGNxD3' +
        'W6hV7INE1mDWYP31w+cXv1hhbaKim7dXGBx20r/vrFz7n7Jv/dbtm' +
        'QQXGcdOPvMOCbc66FuLZ1vJGqcbMz+0XLya');
      InventoryLocation := GetInventoryLocation;
      MealLocations := GetItemLocations(MealIcon,InventoryLocation);
      FreeBitmap(MealIcon);
      if not (MealLocations[0].x = 0) and not (MealLocations[0].y = 0) then
      begin
        writeln('Eating food');
        Mouse(MealLocations[0].x+25,MealLocations[0].y+5,0,0,false);
        wait(WaitAfterClick);
        ClickEat;
      end
      else
      begin
        writeln('Could not find food to eat');
      end;
  end;
  FreeBitmap(FoodBar);
end;
procedure CheckWater;
var
WaterBar,WaterIcon,x,y : integer;
WaterLocations : TPointArray;
InventoryLocation : TPoint;
begin
  WaterBar := BitmapFromString(69, 7, 'meJzdlO1SgkAUQH3HIgVEwaZUvkT' +
        'tSVSWRbAeSMvP/pr2JN27uyyI1K9mmok5w+AOy3DmXKzV/tUR9huS' +
        'GdCr53TvgKlAmT6WuOVMHoAbDq50FdgV9uphv07sRmSrkaMB1AV06' +
        'umx1wTmPmAkA6CVBO10CJiLkfUMjDsvT/dwXow66chKhlYSmPPAjA' +
        'dtCvityDMi1yBukzg6sbXQVvH9bZU42sfutZrtqsSxguVxc8V2me/' +
        'areQDT5x9kTfO+cBZcz6B9w1wPmzk4kmyX8uNQOm1URDREG7KZb/p' +
        'JWIVGk1EINaIJ2OBZj3WiGWCRxFAxFJpFiv29DxT0EqDrNG4g3Uwk' +
        'JUOMdBcBDIp4Lcj3ggzNYkrFCJHh58MuMi9ilLVs1c5deJCYToKvx' +
        '+kmFc2fldSMUqx2WODVzQSOmLerFwHR+7CSCpQ36DZitDJXGb98nf' +
        '046dUoHtphBR6VUrxTFmjhTSSOhjIii+N6JXRX/8V/fLxBX1TIsE=');
  if not FindBitmapToleranceIn(WaterBar,x,y,0,0,Width-1,Height-1,50) then
  begin
      WaterIcon := BitmapFromString(11, 13, 'meJx9kVkOwjAMRHsaoBtdJFTovk' +
        'BLoAIuwpk4FhyAK/DPSy1FwAfRKHLs8cie+IVys97Lej8f/AIod9P' +
        'xDKoDGTfd6aAYlqWKmjFqT5Zlhc0Y1MewHqfSnhtAiNsz1cf9yo0C' +
        'siQhIOisOzupETcEJ2lncU5+virtpCEAUgXPm46ddYsI7TKSm25Jv' +
        'qZjRJBlSG4I0i5VI8K08fYC04gbQBAOCiz7h8CCi1VFwPOnKgRWY3' +
        '4v74XzCZlTzMQNzLS+D416R73gDscAgRio/6VQ09fs8fwN1H6F3w==');
      InventoryLocation := GetInventoryLocation;
      WaterLocations := GetItemLocations(WaterIcon,InventoryLocation);
      FreeBitmap(WaterIcon);
      if not (WaterLocations[0].x = 0) and not (WaterLocations[0].y = 0) then
      begin
        writeln('Drinking water');
        Mouse(WaterLocations[0].x+25,WaterLocations[0].y+5,0,0,false);
        wait(WaitAfterClick);
        ClickDrink;
      end
      else
      begin
        writeln('Could not find water to drink');
      end;
  end;
  FreeBitmap(WaterBar);
end;
procedure MovePiles(BitmapToMove,Repeats : Integer; ClickSendButton : Boolean);
var
  i,DirtMap : integer;
  StackPoint : TPoint;
begin
  DirtMap := BitmapFromString(15, 10, 'meJxtkFsOgkAMRVmMQR6DhCiOyl' +
        'OIIBpX4IdxLX64A3finlyGB6oTYmxuJk3nTOe2Kmn8pFFJExYHf12' +
        'Tz/LOGsKJC/Ig2yNXl/5mh7x17a2qIOs4Bbs+XoikLw635LTiuQD0' +
        'NJjofHta35C3BMX2ch+TVDgpmqu+GzaGhkIKMxakCGAa586ywLyrt' +
        '4bnyiSGlHnD8hikLauIqhMVA/yQkqhhdcC8sv6FShu+JplEG2xgBv' +
        'MyqUxtLzIkFU5M2vPU0eWnc3lU30lp1S9fVzK77B8ez2+6pnBk');
  BitmapToMove := DirtMap;
  for i := 0 to Repeats do
  begin
  writeln('moving dirt');
  if FindBitmapToleranceIn(BitmapToMove,StackPoint.x,StackPoint.y,0,0,Width/3,Height-1,75) then
  begin
    MMouse(StackPoint.x+25,StackPoint.y+5,0,0);
    HoldMouse(StackPoint.x+25,StackPoint.y+5,1);
    MMouse(Width/2,Height/2,0,0);
    ReleaseMouse(Width/2,Height/2,1);
  end;
  if ClickSendButton then
  begin
    wait(1000);
    ClickSend;
  end;
  wait(700);
  if FindBitmapToleranceIn(BitmapToMove,StackPoint.x,StackPoint.y,Width/3,0,Width*2/3-100,Height-1,75) then
  begin
    MMouse(StackPoint.x+25,StackPoint.y+5,0,0);
    HoldMouse(StackPoint.x+25,StackPoint.y+5,1);
    MMouse(Width*2/3,Height/2,0,0);
    ReleaseMouse(Width*2/3,Height/2,1);
  end;
  wait(700);
  end;
  FreeBitmap(BitmapToMove);
end;
function toggleClimbing : boolean;
var
  ClimbingButton,X,Y : integer;
begin
  ClimbingButton := BitmapFromString(38, 8, 'meJy9UUEKACAI67F+xX93UkTdsg5' +
        'FCE3ndKmIiiw7ak+P6NYsr0eVE63b/hNi1PWYhkl4QiKe6BPFVhT9' +
        'AnGsTkJ2bLfj9Qj5r3jkEsU3V1uH5zsiVqV4dgMgswLr');
  if FindBitmapToleranceIn(ClimbingButton,x,y,0,0,Width-1,Height-1,25) then
  begin
    Mouse(X+5,Y+3,0,0,true);
    wait(200+random(300));
    ClickScreen;
  end
  else
    result := false;
  FreeBitmap(ClimbingButton);
end;
function ClimbingOff : boolean;
var
  ClimbingButton,X,Y : integer;
begin
  ClimbingButton := BitmapFromString(38, 8, 'meJy9UUEKACAI67F+xX93UkTdsg5' +
        'FCE3ndKmIiiw7ak+P6NYsr0eVE63b/hNi1PWYhkl4QiKe6BPFVhT9' +
        'AnGsTkJ2bLfj9Qj5r3jkEsU3V1uH5zsiVqV4dgMgswLr');
  if FindBitmapToleranceIn(ClimbingButton,x,y,0,0,Width-1,Height-1,25) then
  begin
    Mouse(X+5,Y+3,0,0,true);
    wait(200+random(300));
    ClickScreen;
  end
  else
    result := false;
  FreeBitmap(ClimbingButton);
end;
function Climber : boolean;
begin
  toggleClimbing;
  sendkeys('x',0);
  wait(90000);
  sendkeys('x',0);
  ClimbingOff;
  result := true;
end;
procedure Quit;
var
  QuitButton,X,Y : integer;
begin
  QuitButton := BitmapFromString(19, 8, 'meJw7cupMdWdvSGo2BNV29X389Cm' +
        'psBwuggslFJSdu3wVzr336HFj3ySCuiBowuz5QARkzFi0bO3WHRDB' +
        'lJLKa7du//nz5+6DRzlVDUCR1knTgNy/f/89fPK0rrsfouzkuQtzl' +
        'q26dfc+3DSgCFAlkFHfMxFoApDx+/fvFRs2AxnN/VNevH4DUZZWWv' +
        'X////0shq4RqCy/zAAtAjiHqD3t+8/WFDXjOxgoAJkLlBjZFY+mqe' +
        'Adi1bv+nJ8+fTFi7BpREYYhCH9c2cC/ECUD3E8VPnL/70+QsujUDH' +
        'A9UD7QUGRX5tE1Cksq370dNnwMABuhxoAgCshv1l');
  PressKey(123);
  wait(1000);
  If (FindBitmapToleranceIn(QuitButton,X,Y,0,0,Width-1,Height-1,85)) Then
  begin
    Mouse(X+10,Y+5,0,0,true);;
  end else
  begin
    writeln('failed to quit');
  end;
end;
procedure MainLoop;
var
  ActionsToPerform,StopAfterFailures,ActionsSinceLastMove,
  startTime,endTime : integer;
  StopAfterActionsToPerform,LookingStraight : boolean;
begin
  Failures := 0;
  Actions := 0;
  wait(WaitAfterClick);
  GetClientDimensions(Width,Height);
  MouseSpeed := 12;
  WaitAfterClick := 1500;
  MoveSideToSide := false;
  MoveForward := false;
  StopAfterFailures := 10;
  ActionsToPerform := 4;
  StopAfterActionsToPerform := false;
  LookingStraight := true;
  ImprovingItems := false;
  endTime := 180;
  startTime := GetTimeRunning;
  repeat

    //ALL THIS SHIT IS CLASSIC LIGHT

    //if not Tracking then
    //if not Miner then
    //if not Fisher then
    //if not ShieldBasher then
    //if not DestroyDoorWall then
    //if not ContinueBrickConstruction then
    //if not CreateShafts then
    if not CreateShortBows then
    //if not CreateBows then
    //if not CreateLockPick then
    //if not CreateStringOfCloth then
    //if not CreateMortar then
    //if not Improve(Item_StoneMineDoor) then
    //if not Improve(Item_HuntingArrow) then
    //if not Improve(Item_UnfinishedShortBow) then
    //if not Improve(Item_Shortbow) then

    // ALL THIS SHIT IS CLASSIC

    //if not CreateKeyMould then
    //if not CreateBall then
    //if not CreateArrowShafts then
    //if not CreateHuntingArrowHead then
    //if not Steal(310,230) then
    //if not PickLock(623,439) then
    //if not TargetPractice(648,353) then
    //if not DigClay then
    //if not Pray then
    //if not Improve(Item_UnfinishedHuntingArrow) then
    //if not Improve(Item_Spindle) then
    //if not Improve(Item_Ball) then

    //ALL THIS SHIT IS IRONWOOD

    //writeln(getkeycode('x'));
    //MovePiles(0,25,false);
    //if not CreateDoorLock then
    //if not CreateArmourChains then
    //if not CreateKindling then
    //if not CreateStaffs then
    //if not CreateTenons then
    //if not CreatePegs then
    //if not CreatePlanks then
    //if not CreateWhetstones then
    //if not CreateGrindstones then
    //if not SpinYoYo then
    //if not Tracking then
    //if not TestWalking then
    //if not Farming(18,8,true) then
    //if not MineUp then
    //if not Prospect then
    //if not Climber then
    //if not FiletFish then
    //if not FiletCookedMeat then
    //if not Stealth then
    //if not Dig then
    //if not WoodCutting then
    //if not ChopUpTree then
    //if not PackerCultivator then
    //if not PracticeDoll(600,500) then
    //if not MillOats then
    //if not MixDoughs then
    //if not Improve(Item_SmallBarrel) then
    //if not Improve(Item_RopeTool) then
    //if not Improve(QuestionMark) then
    //if not Improve(Item_GrindStone) then
    //if not Improve(Item_UnfinishedGrindStone) then
    //if not Improve(Item_WarArrow) then
    //if not Improve(Item_UnfinishedBow) then
    //if not Improve(Item_LongBow) then
    //if not Improve(Item_Saw) then
    //if not Improve(Item_UnfinishedSpindle) then
    //if not Improve(Item_Mallet) then
    //if not Improve(Item_LongSpear) then
    //if not Improve(Item_LargeShield) then
    //if not Improve(Item_PracticeDoll) then
    begin
      TakeScreenshot('C:\Users\Anonymous\Desktop\Wurm\Screenshots\Wurm');
      Failures := Failures + 1;
    end;
    //OrePileToBin;
    //CreateMortar;
    //CartDirt;
    //CartSand;
    //BinClay;
    //853 ore per bin
    //16000 clay per bin
    //if (Actions < 853)then
    wait(3000);
    if not ImprovingItems then
    begin
      if not WaitForActionFinish then
      begin
        //Failures := Failures + 1;
        if MoveForward then
        begin
          writeln('Moving forward one tile');
          MoveForwardOneTile;
        end;
      end
      else
      begin
        ActionsSinceLastMove := ActionsSinceLastMove + 1;
        Actions := Actions + 1;
      end;
    end;

    If (ActionsSinceLastMove > 10) and MoveSideToSide then
    begin
      if LookingStraight then
      begin
        KeyDown(68);
        wait(1500);
        KeyUp(68);
        LookingStraight := false;
      end
      else
      begin
        KeyDown(65);
        wait(1500);
        KeyUp(65);
        LookingStraight := true;
      end;
      ActionsSinceLastMove := 0;
    end;
    CheckFood;
    CheckWater;
    wait(random(3000));
    writeln('Ran for ' + inttostr((GetTimeRunning - startTime)/1000) + ' seconds');
    writeln('Performed ' + inttostr(Actions) + ' actions');
    writeln('Failed ' + inttostr(Failures) + ' times');
    if Failures > StopAfterFailures then
    begin
      writeln('Failed ' + inttostr(Failures) + ' times, exiting');
      Quit;
      Exit;
    end;
    if (Actions > ActionsToPerform - 1) and StopAfterActionsToPerform then
    begin
      writeln('Finished ' + inttostr(Actions) + ' Actions. Exiting.');
      Exit;
    end;
    if not (endTime = 0) then
    begin
      if ((GetTimeRunning - startTime)/60000 > endTime) then
        Failures := StopAfterFailures + 1;
    end;
  until(false);
end;
begin
  SetupSRL;
  MainLoop;
end.
