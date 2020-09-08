using System;
using System.Collections.Generic;
using System.Threading;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Drawing;
using System.ComponentModel;

namespace WurmMacro
{
	public class CommentAttribute : Attribute
	{
		public string Comment { get; set; }

		public CommentAttribute(string comment)
		{
			Comment = comment;
		}
	}

	public class HUD
	{
		public Point OffsetXY { get; set; }
		Process proc { get; }
		GUIModel gui { get; }
		TTS tts { get; }
        Form form { get; }
		public Dictionary<string, Command> commands = new Dictionary<string, Command>();
		public ScriptCollection scripts { get; } = new ScriptCollection();
		public TemplateCollection templates { get; } = new TemplateCollection();

		public HUD(Form form, Process proc, GUIModel gui, TTS tts)
		{
			this.form = form;
            this.proc = proc;
			this.gui = gui;
			this.tts = tts;
			var methods = this.GetType().GetMethods();
			foreach (var method in methods)
			{
				var dispname = method.GetCustomAttribute<DisplayNameAttribute>();
				if (null != dispname)
				{
					commands[method.Name.ToLower()] = new Command(method);
				}
			}
		}

		/// <summary>
		/// 実行
		/// </summary>
		/// <param name="command"></param>
		public void Decode(string command)
		{
			command = command.Trim();
			if (string.IsNullOrEmpty(command)) return;

			var idx = command.IndexOf(' ');
			var cmd = command.Substring(0, idx).ToLower();
			var prm = command.Substring(idx + 1).Trim().Split(',');
			try
			{
				commands[cmd].Execute(this, prm);
			}
			catch (KeyNotFoundException ex)
			{
				tts.Show(ex.Message);
			}
		}

		[DllImport("user32", SetLastError = true)]
		[return: MarshalAs(UnmanagedType.Bool)]
		static extern bool SetForegroundWindow(IntPtr hWnd);

		[DllImport("user32", SetLastError = true)]
		private static extern IntPtr GetForegroundWindow();

		[DllImport("user32", SetLastError = true)]
		static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

		/// <summary>
		/// マウスの移動やマウスボタンのクリックを合成します。
		/// </summary>
		/// <param name="dwFlags">移動とクリックのオプション</param>
		/// <param name="dx">水平位置または移動量</param>
		/// <param name="dy">垂直位置または移動量</param>
		/// <param name="cButtons">ホイールの移動</param>
		/// <param name="dwExtraInfo">アプリケーション定義の情報</param>
		/// <remarks></remarks>
		[DllImport("user32", SetLastError = true)]
		private static extern void mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);

		[DllImport("user32", SetLastError = true)]
		public static extern uint keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

		[DllImport("user32", SetLastError = true)]
		static extern void SetCursorPos(int X, int Y);

		[DllImport("user32", SetLastError = true)]
		[return: MarshalAs(UnmanagedType.Bool)]
		static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

		[StructLayout(LayoutKind.Sequential)]
		public struct RECT
		{
			public int Left;
			public int Top;
			public int Right;
			public int Bottom;
		}


		public void DoEvent(int wait = 1)
		{
			Thread.Sleep(1);
			//Application.DoEvents();
			Thread.Sleep(wait);
		}

		/// <summary>
		/// ウィンドウをアクティブにする
		/// </summary>
		public void Activate()
		{
			var hwnd = GetForegroundWindow();
			if (null != hwnd)
			{
				uint ret = 0;
				var pid = GetWindowThreadProcessId(hwnd, out ret);
				if (proc.Id == pid)
				{
					return;
				}
			}
			SetForegroundWindow(proc.MainWindowHandle);
		}

		[DisplayName("マクロ呼び出し")]
		[Description("例：ABCマクロを3回回す　Loop 3,ABC")]
		[Comment("回数指定してマクロを実行します")]
		public void Loop(int loopCount, string macroName)
		{
			try
			{
				var macro = scripts.Get(macroName);
				var lines = macro.Script.Replace("\r\n", "\n").Replace("\r", "\n").Split('\n');
                for (var idx = 0; idx < loopCount; idx++)
				{
					foreach (var line in lines)
					{
						Decode(line);
					}
				}
				while (!gui.IsIdle) Thread.Sleep(100);
			}
			catch
			{
				tts.Show(string.Format("LOOP命令で存在しないマクロ{0}が呼び出されました。", macroName));
			}
        }

		[DisplayName("画面上からテンプレート画像がある場所に移動してマウス移動")]
		[Description("例：ABC画像のある場所からX=+10, Y=+20の位置へ移動 MatchMove ABC,10,20")]
		[Comment("画像サーチしてカーソル移動")]
		public void MatchMove(string filename, int dx, int dy)
		{
			var pt = new Point(0, 0);
			try
			{
				Activate();
				var bmp = new MatBitmap(SpotColor.Snapshot(GetWindowRect()));
				var mat = templates.Get(filename);
				pt = bmp.Search(mat.Pattern);
			}
			catch
			{
			}
            pt.X += dx;
			pt.Y += dy;
			Move(pt.X, pt.Y);
		}

		internal Point GetMatch(string filename)
		{
			var pt = new Point(0, 0);
			try
			{
				Activate();
				var bmp = new MatBitmap(SpotColor.Snapshot(GetWindowRect()));
				var mat = templates.Get(filename);
				return bmp.Search(mat.Pattern, true);
			}
			catch
			{
			}
			return new Point(0, 0);
		}

		[DisplayName("画面上からテンプレート画像がある場所に移動してマウス移動")]
		[Description("例：ABC画像のある場所からX=+10, Y=+20の位置へ移動 MatchLeftClick ABC,10,20")]
		[Comment("画像サーチしてカーソル移動＆クリック")]
		public void MatchLeftClick(string filename, int dx, int dy)
		{
			var pt = new Point(0, 0);
			try
			{
				Activate();
				var bmp = new MatBitmap(SpotColor.Snapshot(GetWindowRect()));
				var mat = templates.Get(filename);
				pt = bmp.Search(mat.Pattern);
			}
			catch(Exception ex)
			{
				tts.Show(ex.Message);
			}
			pt.X += dx;
			pt.Y += dy;
			LeftClick(pt.X, pt.Y);
		}

		[DisplayName("画面上からテンプレート画像がある場所に移動してマウス移動")]
		[Description("例：ABC画像のある場所からX=+10, Y=+20の位置へ移動 MatchRightClick ABC,10,20")]
		[Comment("画像サーチしてカーソル移動＆クリック")]
		public void MatchRightClick(string filename, int dx, int dy)
		{
			var pt = new Point(0, 0);
			try
			{
				Activate();
				var bmp = new MatBitmap(SpotColor.Snapshot(GetWindowRect()));
				var mat = templates.Get(filename);
				pt = bmp.Search(mat.Pattern);
			}
			catch
			{
			}
			pt.X += dx;
			pt.Y += dy;
			RightClick(pt.X, pt.Y);
		}

		[DisplayName("キーを押す")]
		[Description("例：Lキーを押す　Key L")]
		[Comment("キーボードのキーを押します。")]
		public void Key(string keys)
		{
			foreach (var key in keys)
			{
				keybd_event((byte)key, 0, 0, (UIntPtr)0);
				DoEvent(100);
				keybd_event((byte)key, 0, 2, (UIntPtr)0);
				DoEvent(100);
			}
		}

		[DisplayName("しゃべらす")]
		[Description("例：おはようをしゃべらす　Speak おはよう")]
		[Comment("コンピューターにしゃべらせます")]
		public void Speak(string message)
		{
			tts.Speak(message);
		}

		[DisplayName("ウィンドウ表示")]
		[Description("例：何か押してくださいメッセージを表示します　Speak 何か押してください")]
		[Comment("ウィンドウを表示します")]
		public void MessageBox(string message)
		{
			tts.Show(message);
		}

		[DisplayName("マウス左ダウン（ドラッグ）")]
		[Description("例：X=100, Y=200でマウスダウン　MouseLeftDown 100, 200")]
		[Comment("マウス左クリックを押したままにします")]
		public void MouseLeftDown(int x, int y)
		{
			SetCursorPos(x + OffsetXY.X, y + OffsetXY.Y);
			DoEvent();
			mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
			DoEvent(100);
		}

		[DisplayName("マウス左アップ（ドロップ）")]
		[Description("例：X=100, Y=200でマウスアップ　MouseLeftUp 100, 200")]
		[Comment("マウス左クリックを離します")]
		public void MouseLeftUp(int x, int y)
		{
			SetCursorPos(x + OffsetXY.X, y + OffsetXY.Y);
			DoEvent();
			mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
			DoEvent(100);
		}

		[DisplayName("マウス右ダウン（ドラッグ）")]
		[Description("例：X=100, Y=200でマウスダウン　MouseRightDown 100, 200")]
		[Comment("マウス左クリックを押したままにします")]
		public void MouseRightDown(int x, int y)
		{
			SetCursorPos(x + OffsetXY.X, y + OffsetXY.Y);
			DoEvent();
			mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
			DoEvent(100);
		}

		[DisplayName("マウス右アップ（ドロップ）")]
		[Description("例：X=100, Y=200でマウスアップ　MouseRightUp 100, 200")]
		[Comment("マウス右クリックを離します")]
		public void MouseRightUp(int x, int y)
		{
			SetCursorPos(x + OffsetXY.X, y + OffsetXY.Y);
			DoEvent();
			mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
			DoEvent(100);
		}

		[DisplayName("マウスカーソル移動")]
		[Description("例：X=100, Y=200へ移動する　Move 100, 200")]
		[Comment("マウス左クリックを押したままにします")]
		public void Move(int x, int y)
		{
			SetCursorPos(x + OffsetXY.X, y + OffsetXY.Y);
			DoEvent(100);
		}

		[DisplayName("ホイールアップ")]
		[Description("例：ホイール３UP　WhellUp 100, 200, 3")]
		[Comment("マウスホイールを上にスクロールします")]
		public void WhellUp(int x, int y, int value)
		{
			SetCursorPos(x + OffsetXY.X, y + OffsetXY.Y);
			DoEvent();
			mouse_event(MOUSEEVENTF_WHEEL, 0, 0, value * +100, 0);
			DoEvent(100);
		}

		[DisplayName("ホイールダウン")]
		[Description("例：ホイール３DOWN　WhellUp 100, 200, 3")]
		[Comment("マウスホイールを下にスクロールします")]
		public void WhellDown(int x, int y, int value)
		{
			SetCursorPos(x + OffsetXY.X, y + OffsetXY.Y);
			DoEvent(100);
			mouse_event(MOUSEEVENTF_WHEEL, 0, 0, value * -100, 0);
			DoEvent();
		}

		[DisplayName("クリック左")]
		[Description("例：X=100, Y=200でクリック　LeftClick 100, 200")]
		[Comment("マウス左クリックします。")]
		public void LeftClick(int x, int y)
		{
			MouseLeftDown(x, y);
			MouseLeftUp(x, y);
		}

		[DisplayName("クリック右")]
		[Description("例：X=100, Y=200でクリック　RightClick 100, 200")]
		[Comment("マウス右クリックします。")]
		public void RightClick(int x, int y)
		{
			MouseRightDown(x, y);
			MouseRightUp(x, y);
		}

		[DisplayName("休止時間")]
		[Description("例：(1秒休止)　Sleep 1000")]
		[Comment("ウェイトを設定します")]
		public void Sleep(int milliseconds)
		{
			Thread.Sleep(milliseconds);
		}


		/// <summary>
		/// プロセスウィンドウの描画領域を返す
		/// </summary>
		/// <returns></returns>
		public Rectangle GetWindowRect()
		{
			RECT rect;
			GetWindowRect(proc.MainWindowHandle, out rect);
			return new Rectangle(rect.Left, rect.Top, rect.Right - rect.Left, rect.Bottom - rect.Top);
		}


		//dx と dy の各パラメータは、正規化された絶対座標を意味します。
		private const int MOUSEEVENTF_ABSOLUTE = 0x8000;
		//マウスが移動したことを示します。
		private const int MOUSEEVENTF_MOVE = 0x1;
		//左ボタンが押されたことを示します。
		private const int MOUSEEVENTF_LEFTDOWN = 0x2;
		//左ボタンが離されたことを示します。
		private const int MOUSEEVENTF_LEFTUP = 0x4;
		//右ボタンが押されたことを示します。
		private const int MOUSEEVENTF_RIGHTDOWN = 0x8;
		//右ボタンが離されたことを示します。
		private const int MOUSEEVENTF_RIGHTUP = 0x10;
		//中央ボタンが離されたことを示します。
		private const int MOUSEEVENTF_MIDDLEDOWN = 0x20;
		//中央ボタンが離されたことを示します。
		private const int MOUSEEVENTF_MIDDLEUP = 0x40;

		//Windows NT/2000：マウスにホイールが実装されている場合、そのホイールが回転したことを示します。移動量は、dwData パラメータで指定します。
		private const int MOUSEEVENTF_WHEEL = 0x800;
		//Windows 2000：X ボタンが押されたことを示します。
		private const int MOUSEEVENTF_XDOWN = 0x80;
		//Windows 2000：X ボタンが離されたことを示します。
		private const int MOUSEEVENTF_XUP = 0x100;

		// ホイールの移動量
		private const int WHEEL_DELTA = 120;


		#region "WM"
		private const UInt32 WM_ACTIVATE = 0x0006;
		private const UInt32 WM_ACTIVATEAPP = 0x001C;
		private const UInt32 WM_AFXFIRST = 0x0360;
		private const UInt32 WM_AFXLAST = 0x037F;
		private const UInt32 WM_APP = 0x8000;
		private const UInt32 WM_ASKCBFORMATNAME = 0x030C;
		private const UInt32 WM_CANCELJOURNAL = 0x004B;
		private const UInt32 WM_CANCELMODE = 0x001F;
		private const UInt32 WM_CAPTURECHANGED = 0x0215;
		private const UInt32 WM_CHANGECBCHAIN = 0x030D;
		private const UInt32 WM_CHANGEUISTATE = 0x0127;
		private const UInt32 WM_CHAR = 0x0102;
		private const UInt32 WM_CHARTOITEM = 0x002F;
		private const UInt32 WM_CHILDACTIVATE = 0x0022;
		private const UInt32 WM_CLEAR = 0x0303;
		private const UInt32 WM_CLOSE = 0x0010;
		private const UInt32 WM_COMMAND = 0x0111;
		private const UInt32 WM_COMPACTING = 0x0041;
		private const UInt32 WM_COMPAREITEM = 0x0039;
		private const UInt32 WM_CONTEXTMENU = 0x007B;
		private const UInt32 WM_COPY = 0x0301;
		private const UInt32 WM_COPYDATA = 0x004A;
		private const UInt32 WM_CREATE = 0x0001;
		private const UInt32 WM_CTLCOLORBTN = 0x0135;
		private const UInt32 WM_CTLCOLORDLG = 0x0136;
		private const UInt32 WM_CTLCOLOREDIT = 0x0133;
		private const UInt32 WM_CTLCOLORLISTBOX = 0x0134;
		private const UInt32 WM_CTLCOLORMSGBOX = 0x0132;
		private const UInt32 WM_CTLCOLORSCROLLBAR = 0x0137;
		private const UInt32 WM_CTLCOLORSTATIC = 0x0138;
		private const UInt32 WM_CUT = 0x0300;
		private const UInt32 WM_DEADCHAR = 0x0103;
		private const UInt32 WM_DELETEITEM = 0x002D;
		private const UInt32 WM_DESTROY = 0x0002;
		private const UInt32 WM_DESTROYCLIPBOARD = 0x0307;
		private const UInt32 WM_DEVICECHANGE = 0x0219;
		private const UInt32 WM_DEVMODECHANGE = 0x001B;
		private const UInt32 WM_DISPLAYCHANGE = 0x007E;
		private const UInt32 WM_DRAWCLIPBOARD = 0x0308;
		private const UInt32 WM_DRAWITEM = 0x002B;
		private const UInt32 WM_DROPFILES = 0x0233;
		private const UInt32 WM_ENABLE = 0x000A;
		private const UInt32 WM_ENDSESSION = 0x0016;
		private const UInt32 WM_ENTERIDLE = 0x0121;
		private const UInt32 WM_ENTERMENULOOP = 0x0211;
		private const UInt32 WM_ENTERSIZEMOVE = 0x0231;
		private const UInt32 WM_ERASEBKGND = 0x0014;
		private const UInt32 WM_EXITMENULOOP = 0x0212;
		private const UInt32 WM_EXITSIZEMOVE = 0x0232;
		private const UInt32 WM_FONTCHANGE = 0x001D;
		private const UInt32 WM_GETDLGCODE = 0x0087;
		private const UInt32 WM_GETFONT = 0x0031;
		private const UInt32 WM_GETHOTKEY = 0x0033;
		private const UInt32 WM_GETICON = 0x007F;
		private const UInt32 WM_GETMINMAXINFO = 0x0024;
		private const UInt32 WM_GETOBJECT = 0x003D;
		private const UInt32 WM_GETTEXT = 0x000D;
		private const UInt32 WM_GETTEXTLENGTH = 0x000E;
		private const UInt32 WM_HANDHELDFIRST = 0x0358;
		private const UInt32 WM_HANDHELDLAST = 0x035F;
		private const UInt32 WM_HELP = 0x0053;
		private const UInt32 WM_HOTKEY = 0x0312;
		private const UInt32 WM_HSCROLL = 0x0114;
		private const UInt32 WM_HSCROLLCLIPBOARD = 0x030E;
		private const UInt32 WM_ICONERASEBKGND = 0x0027;
		private const UInt32 WM_IME_CHAR = 0x0286;
		private const UInt32 WM_IME_COMPOSITION = 0x010F;
		private const UInt32 WM_IME_COMPOSITIONFULL = 0x0284;
		private const UInt32 WM_IME_CONTROL = 0x0283;
		private const UInt32 WM_IME_ENDCOMPOSITION = 0x010E;
		private const UInt32 WM_IME_KEYDOWN = 0x0290;
		private const UInt32 WM_IME_KEYLAST = 0x010F;
		private const UInt32 WM_IME_KEYUP = 0x0291;
		private const UInt32 WM_IME_NOTIFY = 0x0282;
		private const UInt32 WM_IME_REQUEST = 0x0288;
		private const UInt32 WM_IME_SELECT = 0x0285;
		private const UInt32 WM_IME_SETCONTEXT = 0x0281;
		private const UInt32 WM_IME_STARTCOMPOSITION = 0x010D;
		private const UInt32 WM_INITDIALOG = 0x0110;
		private const UInt32 WM_INITMENU = 0x0116;
		private const UInt32 WM_INITMENUPOPUP = 0x0117;
		private const UInt32 WM_INPUTLANGCHANGE = 0x0051;
		private const UInt32 WM_INPUTLANGCHANGEREQUEST = 0x0050;
		private const UInt32 WM_KEYDOWN = 0x0100;
		private const UInt32 WM_KEYFIRST = 0x0100;
		private const UInt32 WM_KEYLAST = 0x0108;
		private const UInt32 WM_KEYUP = 0x0101;
		private const UInt32 WM_KILLFOCUS = 0x0008;
		private const UInt32 WM_LBUTTONDBLCLK = 0x0203;
		private const UInt32 WM_LBUTTONDOWN = 0x0201;
		private const UInt32 WM_LBUTTONUP = 0x0202;
		private const UInt32 WM_MBUTTONDBLCLK = 0x0209;
		private const UInt32 WM_MBUTTONDOWN = 0x0207;
		private const UInt32 WM_MBUTTONUP = 0x0208;
		private const UInt32 WM_MDIACTIVATE = 0x0222;
		private const UInt32 WM_MDICASCADE = 0x0227;
		private const UInt32 WM_MDICREATE = 0x0220;
		private const UInt32 WM_MDIDESTROY = 0x0221;
		private const UInt32 WM_MDIGETACTIVE = 0x0229;
		private const UInt32 WM_MDIICONARRANGE = 0x0228;
		private const UInt32 WM_MDIMAXIMIZE = 0x0225;
		private const UInt32 WM_MDINEXT = 0x0224;
		private const UInt32 WM_MDIREFRESHMENU = 0x0234;
		private const UInt32 WM_MDIRESTORE = 0x0223;
		private const UInt32 WM_MDISETMENU = 0x0230;
		private const UInt32 WM_MDITILE = 0x0226;
		private const UInt32 WM_MEASUREITEM = 0x002C;
		private const UInt32 WM_MENUCHAR = 0x0120;
		private const UInt32 WM_MENUCOMMAND = 0x0126;
		private const UInt32 WM_MENUDRAG = 0x0123;
		private const UInt32 WM_MENUGETOBJECT = 0x0124;
		private const UInt32 WM_MENURBUTTONUP = 0x0122;
		private const UInt32 WM_MENUSELECT = 0x011F;
		private const UInt32 WM_MOUSEACTIVATE = 0x0021;
		private const UInt32 WM_MOUSEFIRST = 0x0200;
		private const UInt32 WM_MOUSEHOVER = 0x02A1;
		private const UInt32 WM_MOUSELAST = 0x020D;
		private const UInt32 WM_MOUSELEAVE = 0x02A3;
		private const UInt32 WM_MOUSEMOVE = 0x0200;
		private const UInt32 WM_MOUSEWHEEL = 0x020A;
		private const UInt32 WM_MOUSEHWHEEL = 0x020E;
		private const UInt32 WM_MOVE = 0x0003;
		private const UInt32 WM_MOVING = 0x0216;
		private const UInt32 WM_NCACTIVATE = 0x0086;
		private const UInt32 WM_NCCALCSIZE = 0x0083;
		private const UInt32 WM_NCCREATE = 0x0081;
		private const UInt32 WM_NCDESTROY = 0x0082;
		private const UInt32 WM_NCHITTEST = 0x0084;
		private const UInt32 WM_NCLBUTTONDBLCLK = 0x00A3;
		private const UInt32 WM_NCLBUTTONDOWN = 0x00A1;
		private const UInt32 WM_NCLBUTTONUP = 0x00A2;
		private const UInt32 WM_NCMBUTTONDBLCLK = 0x00A9;
		private const UInt32 WM_NCMBUTTONDOWN = 0x00A7;
		private const UInt32 WM_NCMBUTTONUP = 0x00A8;
		private const UInt32 WM_NCMOUSEHOVER = 0x02A0;
		private const UInt32 WM_NCMOUSELEAVE = 0x02A2;
		private const UInt32 WM_NCMOUSEMOVE = 0x00A0;
		private const UInt32 WM_NCPAINT = 0x0085;
		private const UInt32 WM_NCRBUTTONDBLCLK = 0x00A6;
		private const UInt32 WM_NCRBUTTONDOWN = 0x00A4;
		private const UInt32 WM_NCRBUTTONUP = 0x00A5;
		private const UInt32 WM_NCXBUTTONDBLCLK = 0x00AD;
		private const UInt32 WM_NCXBUTTONDOWN = 0x00AB;
		private const UInt32 WM_NCXBUTTONUP = 0x00AC;
		private const UInt32 WM_NCUAHDRAWCAPTION = 0x00AE;
		private const UInt32 WM_NCUAHDRAWFRAME = 0x00AF;
		private const UInt32 WM_NEXTDLGCTL = 0x0028;
		private const UInt32 WM_NEXTMENU = 0x0213;
		private const UInt32 WM_NOTIFY = 0x004E;
		private const UInt32 WM_NOTIFYFORMAT = 0x0055;
		private const UInt32 WM_NULL = 0x0000;
		private const UInt32 WM_PAINT = 0x000F;
		private const UInt32 WM_PAINTCLIPBOARD = 0x0309;
		private const UInt32 WM_PAINTICON = 0x0026;
		private const UInt32 WM_PALETTECHANGED = 0x0311;
		private const UInt32 WM_PALETTEISCHANGING = 0x0310;
		private const UInt32 WM_PARENTNOTIFY = 0x0210;
		private const UInt32 WM_PASTE = 0x0302;
		private const UInt32 WM_PENWINFIRST = 0x0380;
		private const UInt32 WM_PENWINLAST = 0x038F;
		private const UInt32 WM_POWER = 0x0048;
		private const UInt32 WM_POWERBROADCAST = 0x0218;
		private const UInt32 WM_PRINT = 0x0317;
		private const UInt32 WM_PRINTCLIENT = 0x0318;
		private const UInt32 WM_QUERYDRAGICON = 0x0037;
		private const UInt32 WM_QUERYENDSESSION = 0x0011;
		private const UInt32 WM_QUERYNEWPALETTE = 0x030F;
		private const UInt32 WM_QUERYOPEN = 0x0013;
		private const UInt32 WM_QUEUESYNC = 0x0023;
		private const UInt32 WM_QUIT = 0x0012;
		private const UInt32 WM_RBUTTONDBLCLK = 0x0206;
		private const UInt32 WM_RBUTTONDOWN = 0x0204;
		private const UInt32 WM_RBUTTONUP = 0x0205;
		private const UInt32 WM_RENDERALLFORMATS = 0x0306;
		private const UInt32 WM_RENDERFORMAT = 0x0305;
		private const UInt32 WM_SETCURSOR = 0x0020;
		private const UInt32 WM_SETFOCUS = 0x0007;
		private const UInt32 WM_SETFONT = 0x0030;
		private const UInt32 WM_SETHOTKEY = 0x0032;
		private const UInt32 WM_SETICON = 0x0080;
		private const UInt32 WM_SETREDRAW = 0x000B;
		private const UInt32 WM_SETTEXT = 0x000C;
		private const UInt32 WM_SETTINGCHANGE = 0x001A;
		private const UInt32 WM_SHOWWINDOW = 0x0018;
		private const UInt32 WM_SIZE = 0x0005;
		private const UInt32 WM_SIZECLIPBOARD = 0x030B;
		private const UInt32 WM_SIZING = 0x0214;
		private const UInt32 WM_SPOOLERSTATUS = 0x002A;
		private const UInt32 WM_STYLECHANGED = 0x007D;
		private const UInt32 WM_STYLECHANGING = 0x007C;
		private const UInt32 WM_SYNCPAINT = 0x0088;
		private const UInt32 WM_SYSCHAR = 0x0106;
		private const UInt32 WM_SYSCOLORCHANGE = 0x0015;
		private const UInt32 WM_SYSCOMMAND = 0x0112;
		private const UInt32 WM_SYSDEADCHAR = 0x0107;
		private const UInt32 WM_SYSKEYDOWN = 0x0104;
		private const UInt32 WM_SYSKEYUP = 0x0105;
		private const UInt32 WM_TCARD = 0x0052;
		private const UInt32 WM_TIMECHANGE = 0x001E;
		private const UInt32 WM_TIMER = 0x0113;
		private const UInt32 WM_UNDO = 0x0304;
		private const UInt32 WM_UNINITMENUPOPUP = 0x0125;
		private const UInt32 WM_USER = 0x0400;
		private const UInt32 WM_USERCHANGED = 0x0054;
		private const UInt32 WM_VKEYTOITEM = 0x002E;
		private const UInt32 WM_VSCROLL = 0x0115;
		private const UInt32 WM_VSCROLLCLIPBOARD = 0x030A;
		private const UInt32 WM_WINDOWPOSCHANGED = 0x0047;
		private const UInt32 WM_WINDOWPOSCHANGING = 0x0046;
		private const UInt32 WM_WININICHANGE = 0x001A;
		private const UInt32 WM_XBUTTONDBLCLK = 0x020D;
		private const UInt32 WM_XBUTTONDOWN = 0x020B;
		private const UInt32 WM_XBUTTONUP = 0x020C;
		#endregion
	}
}
