using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;

namespace WurmMacro
{
	public class ScriptCollection : List<ScriptModel>
	{
		static string ScriptPath = Path.Combine(Directory.GetCurrentDirectory(), "scripts");

		/// <summary>
		/// コンストラクタ処理
		/// </summary>
		public ScriptCollection()
		{
			Refresh();
		}

		public void Refresh()
		{
			Clear();
			if (!Directory.Exists(ScriptPath))
			{
				Directory.CreateDirectory(ScriptPath);
			}

			//スクリプト一覧を保存
			var files = Directory.GetFiles(ScriptPath, "*.txt", SearchOption.TopDirectoryOnly);
			foreach (var file in files)
			{
				Add(new ScriptModel(file));
			}
		}

		public ScriptModel Get(string macroName) => this.Where(_ => _.MacroName == macroName).First();

		public void Reset()
		{
			foreach (var model in this)
			{
				if (null != model)
				{
					model.ScreenShot.Dispose();
					model.ScreenShot = null;
				}
			}
			Clear();
		}
	}

	public class ScriptModel
	{
		static string ScriptPath = Path.Combine(Directory.GetCurrentDirectory(), "scripts");
		public Bitmap ScreenShot { get; set; }
		public string MacroName { get; set; }
		public string Script { get; set; }

		public ScriptModel(string filename)
		{
			MacroName = Path.GetFileNameWithoutExtension(Path.GetFileName(filename));
			if (File.Exists(filename))
			{
				//スクリプト込々
				Script = File.ReadAllText(filename);

				//スクリーンショット読み込み
				var bmpfilepath = Path.ChangeExtension(filename, "jpg");
				if (File.Exists(bmpfilepath))
				{
					ScreenShot = new Bitmap(bmpfilepath);
				}
			}
		}

		public override string ToString() => MacroName;

		public ScriptModel(string macroname, string script, Bitmap bmp)
		{
			MacroName = macroname;
			Script = script;
			ScreenShot = bmp;
        }

		~ScriptModel()
		{
			if (null != ScreenShot)
			{
				try
				{
					ScreenShot.Dispose();
					ScreenShot = null;
                }
				catch
				{
				}
			}
		}

		public void Save()
		{
			var tpath = Path.Combine(ScriptPath, MacroName + ".txt");
			var bpath = Path.Combine(ScriptPath, MacroName + ".jpg");
			File.WriteAllText(tpath, Script);
			ScreenShot.Save(bpath, ImageFormat.Jpeg);
		}

		public void Delete()
		{
			var tpath = Path.Combine(ScriptPath, MacroName + ".txt");
			var bpath = Path.Combine(ScriptPath, MacroName + ".jpg");
			ScreenShot.Dispose();
			ScreenShot = null;
			if (File.Exists(tpath))
			{
				try
				{
					File.Delete(tpath);
				}
				catch
				{
				}
			}
			if (File.Exists(bpath))
			{
				try
				{
					File.Delete(bpath);
				}
				catch
				{
				}
			}
		}
	}
}
