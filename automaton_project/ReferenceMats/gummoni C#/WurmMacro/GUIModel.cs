using System.ComponentModel;
using System.Drawing;
using System.IO;

namespace WurmMacro
{
	[DisplayName("画面情報")]
	public class GUIModel
	{
		[Browsable(false)]
		public Point OffsetXY { get; set; }

		[DisplayName("スタミナゲージ")]
		public Point Stamina { get; set; }

		[DisplayName("作業ゲージ")]
		public Point Progress { get; set; }

		[Browsable(false)]
		public bool IsStaminaFull => 80 > SpotColor.GetPixel(Stamina, OffsetXY).R;

		[Browsable(false)]
		public bool IsIdle => 100 > SpotColor.GetPixel(Progress, OffsetXY).B;

		[DisplayName("音声出力")]
		public bool IsSpeach { get; set; }

		/// <summary>
		/// コンストラクタ処理
		/// </summary>
		public GUIModel()
		{
			Load();
		}

		static readonly string filename = "setting.txt";
		public void Save()
		{
			var lines = new string[]
			{
				string.Format("{0},{1}", Stamina.X, Stamina.Y),
				string.Format("{0},{1}", Progress.X, Progress.Y),
				IsSpeach.ToString(),
			};
			File.WriteAllLines(filename, lines);
		}

		public void Load()
		{
			try
			{
				if (File.Exists(filename))
				{
					var lines = File.ReadAllLines(filename);
					var st = lines[0].Split(',');
					var pr = lines[1].Split(',');
					var stx = int.Parse(st[0]);
					var sty = int.Parse(st[1]);
					var prx = int.Parse(pr[0]);
					var pry = int.Parse(pr[1]);
					var sph = bool.Parse(lines[2]);
					Stamina = new Point(stx, sty);
					Progress = new Point(prx, pry);
					IsSpeach = sph;
				};
			}
			catch
			{
				Stamina = new Point();
				Progress = new Point();
				IsSpeach = true;
			}
		}
	}
}
