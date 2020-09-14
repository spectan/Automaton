getPlayerName()
{
  WinActivate, Wurm Online
  WinGetActiveTitle, title
  playerName := SubStr(title, 2, InStr(title, ")") - 2)
  return playerName
}