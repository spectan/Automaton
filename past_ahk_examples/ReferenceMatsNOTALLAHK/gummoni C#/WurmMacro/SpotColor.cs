using System.Drawing;

namespace WurmMacro
{
	public static class SpotColor
	{
		static Bitmap myBitmap { get; } = new Bitmap(1, 1);
		static object _lock = new object();

		/// <summary>
		/// 色取得
		/// </summary>
		/// <param name="x"></param>
		/// <param name="y"></param>
		/// <returns></returns>
		public static Color GetPixel(int x, int y) => GetPixel(new Point(x, y));
		static readonly Size _size = new Size(1, 1);
		static readonly Point _point00 = new Point(0, 0);

		public static Color GetPixel(Point pt)
		{
			try
			{
				var g = Graphics.FromImage(myBitmap);
				g.CopyFromScreen(pt, _point00, _size);
				var color = myBitmap.GetPixel(0, 0);
				return color;
			}
			catch
			{
				return new Color();
			}
		}
		public static Color GetPixel(Point pt1, Point pt2) => GetPixel(pt1.X + pt2.X, pt1.Y + pt2.Y);

		public static Bitmap Snapshot(Rectangle rect)
		{
			var bmp = new Bitmap(rect.Width, rect.Height);
			try
			{
				var g = Graphics.FromImage(bmp);
				g.CopyFromScreen(rect.Location, _point00, rect.Size);
				return bmp;
			}
			catch
			{
				return bmp;
			}
		}
	}
}
