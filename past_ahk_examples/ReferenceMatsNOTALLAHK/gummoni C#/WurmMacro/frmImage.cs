using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WurmMacro
{
	public partial class frmImage : Form
	{
		public frmImage()
		{
			InitializeComponent();
		}

		public frmImage(Bitmap bmp)
		{
			InitializeComponent();

			Width = bmp.Width;
			Height = bmp.Height;
			pictureBox1.Image = bmp;
		}

		public frmImage(Bitmap bmp, string title)
			: this(bmp)
		{
			Text = title;
		}
	}
}
