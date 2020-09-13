using System;
using System.Linq;
using System.Diagnostics;
using System.Windows.Forms;
using System.ComponentModel;

namespace WurmMacro
{
	public class ViewModel
	{
		[Category("ステータス")]
		[DisplayName("赤色")]
		[Description("")]
		public int R { get; private set; }
		[Category("ステータス")]
		[DisplayName("緑色")]
		[Description("")]
		public int G { get; private set; }
		[Category("ステータス")]
		[DisplayName("青色")]
		[Description("")]
		public int B { get; private set; }
		[Category("ステータス")]
		[DisplayName("X座標")]
		[Description("")]
		public int X { get; private set; }
		[Category("ステータス")]
		[DisplayName("Y座標")]
		[Description("")]
		public int Y { get; private set; }
		[Category("ステータス")]
		[DisplayName("スタミナ")]
		[Description("True=スタミナがある, False=スタミナが減っている")]
		public bool Stamina { get; private set; }
		[Category("ステータス")]
		[DisplayName("作業状態")]
		[Description("True=作業していない, False=作業中")]
		public bool Progress { get; private set; }
		[Category("ステータス")]
		[DisplayName("アイドル状態")]
		[Description("True=作業していない, False=作業中")]
		public bool Idle { get; private set; }

		[Browsable(false)]
		public GUIModel gui { get; }                                            // GUIから得られた情報
		[Browsable(false)]
		public HUD hud { get; }                                                 // キー入力、マウス操作
		[Browsable(false)]
		public TTS tts { get; }

		/// <summary>
		/// コンストラクタ処理
		/// </summary>
		public ViewModel(Form form)
		{
			var proc = Process.GetProcesses().Where(_ => 0 <= _.ProcessName.IndexOf("WurmLauncher")).FirstOrDefault();
			if (null == proc)
			{
				throw new Exception("ワームクライアント検出できませんでした。");
			}
			gui = new GUIModel();
			tts = new TTS();
			hud = new HUD(form, proc, gui, tts);
		}

		/// <summary>
		/// データ更新
		/// </summary>
		public void Update()
		{
			//XY座標(ターゲットプロセスのウィンドウ領域内で座標を調整)
			var rect = hud.GetWindowRect();
			var pos = Cursor.Position;
			X = Math.Max(0, Math.Min(pos.X - rect.Left, rect.Width));
			Y = Math.Max(0, Math.Min(pos.Y - rect.Top, rect.Height));

			//カーソル位置の色
			var _Color = SpotColor.GetPixel(pos.X, pos.Y);
			R = _Color.R;
			G = _Color.G;
			B = _Color.B;

			//HUDオフセット更新
			hud.OffsetXY = rect.Location;
			gui.OffsetXY = rect.Location;

			//GUI情報
			Stamina = gui.IsStaminaFull;
			Progress = gui.IsIdle;
			Idle = Stamina & Progress;
        }
	}
}
