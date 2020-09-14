using System.Collections.Generic;
using System.Linq;
using System.IO;

namespace WurmMacro
{
	public class TemplateCollection : List<TemplateModel>
	{
		static string TemplatePath = Path.Combine(Directory.GetCurrentDirectory(), "templates");

		public TemplateCollection()
		{
			Refresh();
		}

		void Refresh()
		{
			Clear();
			if (!Directory.Exists(TemplatePath))
			{
				Directory.CreateDirectory(TemplatePath);
			}

			//スクリプト一覧を保存
			var files1 = Directory.GetFiles(TemplatePath, "*.png", SearchOption.TopDirectoryOnly);
			foreach (var file in files1)
			{
				Add(new TemplateModel(file));
			}
			//var files2 = Directory.GetFiles(TemplatePath, "*.bmp", SearchOption.TopDirectoryOnly);
			//foreach (var file in files2)
			//{
			//	Add(new TemplateModel(file));
			//}
		}

		public TemplateModel Get(string filename) => this.Where(_ => _.Filename == filename.ToLower()).First();

		void Reset()
		{
			foreach (var model in this)
			{
				if (null != model)
				{
					model.Pattern.Bitmap.Dispose();
					model.Pattern = null;
				}
			}
			Clear();
		}
	}

	public class TemplateModel
	{
		static string TemplatePath = Path.Combine(Directory.GetCurrentDirectory(), "templates");
		public MatBitmap Pattern { get; set; }
		public string Filename { get; set; }

		/// <summary>
		/// コンストラクタ処理
		/// </summary>
		/// <param name="filename"></param>
		public TemplateModel(string filename)
		{
			Pattern = new MatBitmap(filename);
			Filename = Path.GetFileNameWithoutExtension(filename).ToLower();
		}

		public override string ToString()
		{
			return Filename;
		}
	}
}
