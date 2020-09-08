;-------------------------------------------------------------------------
;  Copyright (C) 2010-2015 Christopher Brochtrup
;
;  This file is part of Capture2Text.
;
;  Capture2Text is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  Capture2Text is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with Capture2Text.  If not, see <http://www.gnu.org/licenses/>.
;
;-------------------------------------------------------------------------

PROG_NAME           = Capture2Text          ; The name of this program
VERSION             = 3.7                   ; The version number
AUTHOR              = Christopher Brochtrup ; Author's name
CONTACT             = cb4960@gmail.com      ; Contact info
SETTINGS_FILE       = settings.ini          ; The settings file
WHITELIST_FILE      = Utils/tesseract/tessdata/tessconfigs/whitelist ; Tesseract whitelist

langTableAlreadyCreated = 0  ; Has the language table already been created?

commandLineMode = 0 ; 1 = In Command Line Mode

; Create 2 tables:
;  1) ocrDicTable  - Languages to dictionary codes
;  2) ocrCodeTable - Dictionary codes to Languages
createLanguageTable()
{
  global

  if(!langTableAlreadyCreated)
  {
    ; Create a table with value = OCR lang dropdown item text, key = OCR dictionary
    ocrDicTable := Object()
    ocrDicTable["Afrikaans"]                         := "afr"
    ocrDicTable["Albanian"]                          := "sqi"
    ocrDicTable["Ancient Greek"]                     := "grc"
    ocrDicTable["Arabic"]                            := "ara"
    ocrDicTable["Azerbaijani"]                       := "aze"
    ocrDicTable["Basque"]                            := "eus"
    ocrDicTable["Belarusian"]                        := "bel"
    ocrDicTable["Bengali"]                           := "ben"
    ocrDicTable["Bulgarian"]                         := "bul"
    ocrDicTable["Catalan"]                           := "cat"
    ocrDicTable["Cherokee"]                          := "chr"
    ocrDicTable["Chinese (NHocr)"]                   := "ascii+:zh_CN"
    ocrDicTable["Chinese - Simplified (Tesseract)"]  := "chi_sim"
    ocrDicTable["Chinese - Traditional (Tesseract)"] := "chi_tra"
    ocrDicTable["Croatian"]                          := "hrv"
    ocrDicTable["Czech"]                             := "ces"
    ocrDicTable["Danish"]                            := "dan"
    ocrDicTable["Danish (Alternate)"]                := "dan-frak"
    ocrDicTable["Dutch"]                             := "nld"
    ocrDicTable["English"]                           := "eng"
    ocrDicTable["Esperanto"]                         := "epo"
    ocrDicTable["Esperanto (Alternate)"]             := "epo_alt"
    ocrDicTable["Estonian"]                          := "est"
    ocrDicTable["Finnish"]                           := "fin"
    ocrDicTable["Frankish"]                          := "frk"
    ocrDicTable["French"]                            := "fra"
    ocrDicTable["Galician"]                          := "glg"
    ocrDicTable["German"]                            := "deu"
    ocrDicTable["German (Alternate)"]                := "deu-frak"
    ocrDicTable["Greek"]                             := "ell"
    ocrDicTable["Hebrew"]                            := "heb"
    ocrDicTable["Hindi"]                             := "hin"
    ocrDicTable["Hungarian"]                         := "hun"
    ocrDicTable["Icelandic"]                         := "isl"
    ocrDicTable["Indonesian"]                        := "ind"
    ocrDicTable["Italian (Old)"]                     := "ita_old"
    ocrDicTable["Italian"]                           := "ita"
    ocrDicTable["Japanese (NHocr)"]                  := "ascii+:jpn"
    ocrDicTable["Japanese (Tesseract)"]              := "jpn"
    ocrDicTable["Kannada"]                           := "kan"
    ocrDicTable["Korean"]                            := "kor"
    ocrDicTable["Latvian"]                           := "lav"
    ocrDicTable["Lithuanian"]                        := "lit"
    ocrDicTable["Macedonian"]                        := "mkd"
    ocrDicTable["Malay"]                             := "msa"
    ocrDicTable["Malayalam"]                         := "mal"
    ocrDicTable["Maltese"]                           := "mlt"
    ocrDicTable["Math/Equations"]                    := "equ"
    ocrDicTable["Middle English (1100-1500)"]        := "enm"
    ocrDicTable["Middle French (1400-1600)"]         := "frm"
    ocrDicTable["Norwegian"]                         := "nor"
    ocrDicTable["Polish"]                            := "pol"
    ocrDicTable["Portuguese"]                        := "por"
    ocrDicTable["Romanian"]                          := "ron"
    ocrDicTable["Russian"]                           := "rus"
    ocrDicTable["Serbian"]                           := "srp"
    ocrDicTable["Slovakian"]                         := "slk"
    ocrDicTable["Slovakian (Alternate)"]             := "slk-frak"
    ocrDicTable["Slovenian"]                         := "slv"
    ocrDicTable["Spanish (Old)"]                     := "spa_old"
    ocrDicTable["Spanish"]                           := "spa"
    ocrDicTable["Swahili"]                           := "swa"
    ocrDicTable["Swedish"]                           := "swe"
    ocrDicTable["Tagalog"]                           := "tgl"
    ocrDicTable["Tamil"]                             := "tam"
    ocrDicTable["Telugu"]                            := "tel"
    ocrDicTable["Thai"]                              := "tha"
    ocrDicTable["Turkish"]                           := "tur"
    ocrDicTable["Ukrainian"]                         := "ukr"
    ocrDicTable["Vietnamese"]                        := "vie"

    ; Create a table with value = lang menu item text, key = dictionary
    ocrCodeTable := Object()
    enum := ocrDicTable._NewEnum()

    while enum[k, v]
    {
      ocrCodeTable.Insert(v, k)
    }

    langTableAlreadyCreated = 1
  }

} ; createLanguageTable


; Populate output array called installedDics with the installed dictionaries.
; installedDics:
;   key   = Language
;   value = Dictionary code
getInstalledDics()
{
  global

  createLanguageTable()

  installedDics := Object()

  enum := ocrDicTable._NewEnum()

  while enum[k, v]
  {
    if(isOCRDicInstalled(v))
    {
      installedDics.Insert(k, v)
    }
  }

} ; getInstalledDics


; Is the given OCR dictionary installed? 0 = No, 1 = Yes
isOCRDicInstalled(inDictionary)
{
  global

  exists = 0

  if(inDictionary == "ascii+:jpn")
  {
    exists := FileExist("Utils\nhocr\Dic\PLM-ascii+.dic")
                and FileExist("Utils\nhocr\Dic\PLM-jpn.dic")
                and FileExist("Utils\nhocr\Dic\cctable-ascii+")
                and FileExist("Utils\nhocr\Dic\cctable-jpn")
  }
  else if(inDictionary == "ascii+:zh_CN")
  {
    exists := FileExist("Utils\nhocr\Dic\PLM-ascii+.dic")
                and FileExist("Utils\nhocr\Dic\PLM-zh_CN.dic")
                and FileExist("Utils\nhocr\Dic\cctable-ascii+")
                and FileExist("Utils\nhocr\Dic\cctable-zh_CN")
  }
  else
  {
    file = Utils\tesseract\tessdata\%inDictionary%.traineddata
    exists := FileExist(file) and 1 ; The "and 1" is so exists will be 0 or 1 instead the the file attributes returned by FileExist
  }

  return exists

} ; isOCRDicInstalled


; Read the settings in settings.ini
readSettings()
{
  global

  ; Output
  IniRead, saveToClipboard, %SETTINGS_FILE%, Output, SaveToClipboard, 1
  IniRead, sendToCursor, %SETTINGS_FILE%, Output, SendToCursor, 0
  IniRead, sendToCursorApplyBeforeAndAfterCommands, %SETTINGS_FILE%, Output, SendToCursorApplyBeforeAndAfterCommands, 1
  IniRead, sendToControl, %SETTINGS_FILE%, Output, SendToControl, 0
  IniRead, controlWindowTitle, %SETTINGS_FILE%, Output, ControlWindowTitle, Notepad++
  IniRead, controlClassNN, %SETTINGS_FILE%, Output, ControlClassNN, Scintilla1
  IniRead, replaceControlText, %SETTINGS_FILE%, Output, ReplaceControlText, 0
  IniRead, controlSendCommandBefore, %SETTINGS_FILE%, Output, ControlSendCommandBefore,
  IniRead, controlSendCommandAfter, %SETTINGS_FILE%, Output, ControlSendCommandAfter,
  IniRead, popupWindow, %SETTINGS_FILE%, Output, PopupWindow, 0
  IniRead, popupWindowWidth, %SETTINGS_FILE%, Output, PopupWindowWidth, 350
  IniRead, popupWindowHeight, %SETTINGS_FILE%, Output, PopupWindowHeight, 100
  IniRead, prependText, %SETTINGS_FILE%, Output, PrependText,
  IniRead, appendText, %SETTINGS_FILE%, Output, AppendText,
  IniRead, preserveNewlines, %SETTINGS_FILE%, Output, PreserveNewlines, 0

  ; OCR Specific
  IniRead, scaleFactor, %SETTINGS_FILE%, OCRSpecific, ScaleFactor, 320
  IniRead, ocrPreProcessing, %SETTINGS_FILE%, OCRSpecific, OcrPreProcessing, 1
  IniRead, ocrStripFurigana, %SETTINGS_FILE%, OCRSpecific, OcrStripFurigana, 1
  IniRead, dictionary, %SETTINGS_FILE%, OCRSpecific, Dictionary, English
  IniRead, dictionary1, %SETTINGS_FILE%, OCRSpecific, Dictionary1, Japanese (NHocr)
  IniRead, dictionary2, %SETTINGS_FILE%, OCRSpecific, Dictionary2, Japanese (Tesseract)
  IniRead, dictionary3, %SETTINGS_FILE%, OCRSpecific, Dictionary3, English
  IniRead, textDirection, %SETTINGS_FILE%, OCRSpecific, TextDirection, Vertical
  IniRead, captureBoxColor, %SETTINGS_FILE%, OCRSpecific, CaptureBoxColor, 0080FF
  IniRead, captureBoxAlpha, %SETTINGS_FILE%, OCRSpecific, CaptureBoxAlpha, 40
  IniRead, previewBoxEnabled, %SETTINGS_FILE%, OCRSpecific, PreviewBoxEnabled, 1
  IniRead, previewBoxFont, %SETTINGS_FILE%, OCRSpecific, PreviewBoxFont, Arial
  IniRead, previewBoxFontSize, %SETTINGS_FILE%, OCRSpecific, PreviewBoxFontSize, 16
  IniRead, previewBoxTextColor, %SETTINGS_FILE%, OCRSpecific, PreviewBoxTextColor, 00AAFF
  IniRead, previewBoxBackgroundColor, %SETTINGS_FILE%, OCRSpecific, PreviewBoxBackgroundColor, 080808
  IniRead, previewBoxAlpha, %SETTINGS_FILE%, OCRSpecific, PreviewBoxAlpha, 100
  IniRead, previewLocation, %SETTINGS_FILE%, OCRSpecific, PreviewLocation, 0 
  IniRead, previewRemoveCaptureBox, %SETTINGS_FILE%, OCRSpecific, PreviewRemoveCaptureBox, Fixed
  IniRead, previewBoxWaitTime, %SETTINGS_FILE%, OCRSpecific, PreviewBoxWaitTime, 400
  
  ; IniRead doesn't work with UTF-8, so use this as a workaround
  f := FileOpen(WHITELIST_FILE, "r", "utf-8-raw")
  whitelist := f.ReadLine()
  whitelist := SubStr(whitelist, 25) ; Remove "tessedit_char_whitelist "
  f.Close()

  ; Hotkeys
  IniRead, startAndEndCaptureKey, %SETTINGS_FILE%, Hotkeys, StartAndEndCaptureKey, #q
  IniRead, endOnlyCaptureKey, %SETTINGS_FILE%, Hotkeys, EndOnlyCaptureKey, LButton
  IniRead, toggleActiveCaptureCornerKey, %SETTINGS_FILE%, Hotkeys, ToggleActiveCaptureCornerKey, Space
  IniRead, moveCaptureKey, %SETTINGS_FILE%, Hotkeys, MoveCaptureKey, RButton
  IniRead, cancelCaptureKey, %SETTINGS_FILE%, Hotkeys, CancelCaptureKey, Esc
  IniRead, nudgeLeftKey, %SETTINGS_FILE%, Hotkeys, NudgeLeftKey, Left
  IniRead, nudgeRightKey, %SETTINGS_FILE%, Hotkeys, NudgeRightKey, Right
  IniRead, nudgeUpKey, %SETTINGS_FILE%, Hotkeys, NudgeUpKey, Up
  IniRead, nudgeDownKey, %SETTINGS_FILE%, Hotkeys, NudgeDownKey, Down
  IniRead, dictionary1Key, %SETTINGS_FILE%, Hotkeys, Dictionary1Key, #1
  IniRead, dictionary2Key, %SETTINGS_FILE%, Hotkeys, Dictionary2Key, #2
  IniRead, dictionary3Key, %SETTINGS_FILE%, Hotkeys, Dictionary3Key, #3
  IniRead, ocrPreProcessingKey, %SETTINGS_FILE%, Hotkeys, OcrPreProcessingKey, #b
  IniRead, textDirectionToggleKey, %SETTINGS_FILE%, Hotkeys, TextDirectionToggleKey, #w

  ; Misc
  IniRead, firstRun, %SETTINGS_FILE%, Misc, FirstRun, 0

  ; Adjust opacity from 0-100 scale to 0-255 scale
  captureBoxAlphaScaled := Round((captureBoxAlpha / 100.0) * 255)
  previewBoxAlphaScaled := Round((previewBoxAlpha / 100.0) * 255)

} ; readSettings



