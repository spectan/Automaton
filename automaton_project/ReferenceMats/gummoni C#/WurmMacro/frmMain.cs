using System;
using System.Drawing;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WurmMacro
{
	public partial class frmMain : Form
	{
		ViewModel vmodel { get; }
		HUD hud => vmodel.hud;
		TTS tts => vmodel.tts;

		public frmMain()
		{
			InitializeComponent();

			try
			{
				vmodel = new ViewModel(this);
				
				//設定一覧
				propertyGrid2.SelectedObject = vmodel.gui;
				tts.IsSpeach = vmodel.gui.IsSpeach;

				//マクロ一覧
				UpdateMacroList();

				//テンプレート一覧
				UpdateTemplateList();

				//起動OK
				tts.Speak("起動しました");

				//スタミナ・作業ウェイト検知位置検索
				var spt = hud.GetMatch("stamina");
				var wpt = hud.GetMatch("wait");
				if (0 < spt.X)
				{
					vmodel.gui.Stamina = spt;
				}
				else
				{
					tts.Show("スタミナゲージが検出できませんでした。設定してください。");
				}
				if (0 < wpt.Y)
				{
					vmodel.gui.Progress = wpt;
				}
				else
				{
					tts.Show("作業ゲージが検出できませんでした。設定してください。");
				}

				timer1.Start();
			}
			catch(Exception ex)
			{
				MessageBox.Show(ex.Message);
				MessageBox.Show("先にワームクライアントを起動してください");
				Environment.Exit(-1);
			}

		}

		private void timer1_Tick(object sender, EventArgs e)
		{
			timer1.Stop();
			vmodel.Update();
			propertyGrid1.SelectedObject = null;
			propertyGrid1.SelectedObject = vmodel;
			Text = task_status;
			timer1.Start();
		}

		private void btStart_Click(object sender, EventArgs e)
		{
			btStart.BackColor = Color.Lime;
			btStop.BackColor = Color.LightGray;
			isPower = false;
			Thread.Sleep(100);
			new Task(TaskMain).Start();
			tts.Speak("マクロを実行します");
		}

		bool isPower = true;
		string[] scripts = null;
		string task_status = "";
		void TaskMain()
		{
			isPower = true;
			scripts = tbScript.Lines;
			var length = scripts.Length;
			while (isPower)
			{
				task_status = "作業開始";
				var dtstart = DateTime.Now;
				for (var idx = 0; idx < scripts.Length; idx++)
				{
					if (!isPower) return;
					hud.Activate();
                    var line = scripts[idx];
					task_status = string.Format("{0}/{1} {2}", idx, length, line);
					hud.Decode(line);
					Application.DoEvents();
				}
				task_status = "作業完了待ち";
                while (isPower && !vmodel.Idle)
				{
					Thread.Sleep(100);
				}
				task_status = "作業完了";
				var dtend = DateTime.Now;
				var dlt = dtend.Subtract(dtstart).TotalMilliseconds;
				if (3000 > dlt)
				{
					Thread.Sleep(3000);
				}
			}
		}

		private void btStop_Click(object sender, EventArgs e)
		{
			btStart.BackColor = Color.LightGray;
			btStop.BackColor = Color.Lime;
			isPower = false;
			tts.Speak("マクロを停止します");
		}

		private void btSave_Click(object sender, EventArgs e)
		{
			hud.Activate();
			Thread.Sleep(1);
			Application.DoEvents();
			hud.scripts.Reset();
			var model = new ScriptModel(tbMacroName.Text, tbScript.Text, SpotColor.Snapshot(vmodel.hud.GetWindowRect()));
			model.Save();
			model.ScreenShot.Dispose();
			model.ScreenShot = null;
			UpdateMacroList();

			tts.Speak("マクロデータを保存しました");
		}

		private void lbMacroList_SelectedIndexChanged(object sender, EventArgs e)
		{
			//マクロ変更
			var model = (ScriptModel)lbMacroList.SelectedItem;
			if (null != model)
			{
				tbMacroName.Text = model.MacroName;
				tbScript.Text = model.Script;
				pictureBox1.Image = model.ScreenShot;
				tts.Speak(model.MacroName + "を開きます");
			}
		}

		private void propertyGrid2_PropertyValueChanged(object s, PropertyValueChangedEventArgs e)
		{
			vmodel.gui.Save();
		}

		private void btInputXY_Click(object sender, EventArgs e)
		{
			tts.Show("XY座標を合わせてスペースキーを押してください。");
			tbXY.Text = string.Format("{0},{1}", vmodel.X, vmodel.Y);
			Clipboard.SetText(tbXY.Text);
			tts.Show("クリップボードにコピーしました。");
		}

		private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
		{
			tts.Speak(tabControl1.SelectedTab.Text + "タブを選択");
		}

		void UpdateMacroList()
		{
			hud.scripts.Refresh();
			lbMacroList.Items.Clear();
			lbMacroList.Items.AddRange(hud.scripts.ToArray());
		}

		void UpdateTemplateList()
		{
			//hud.templates.Refresh();
			lbTempleteList.Items.Clear();
			lbTempleteList.Items.AddRange(hud.templates.ToArray());
		}

		private void button1_Click(object sender, EventArgs e)
		{
			var model = (ScriptModel)lbMacroList.SelectedItem;
			tts.Speak(model.MacroName + "を削除しました");
			model.Delete();
			UpdateMacroList();
		}

		private void pictureBox1_Click(object sender, EventArgs e)
		{
			var img = pictureBox1.Image;
			if (null != img)
			{
				new frmImage((Bitmap)img).Show();
            }
		}

		private void btInstruction_Click(object sender, EventArgs e)
		{
			var list = hud.commands.Values.ToList();
			list.Sort(new CommandComparer());
            new frmInstruction(tts, list.ToArray()).Show();
		}

		private void lbTempleteList_DrawItem(object sender, DrawItemEventArgs e)
		{
			var mat = (TemplateModel)lbTempleteList.Items[e.Index];
			var bmp = mat.Pattern.Bitmap;
			var name = mat.Filename;

			e.DrawBackground();
			e.Graphics.DrawImage(bmp, e.Bounds.X, e.Bounds.Y, 32, 32);
			e.Graphics.DrawString(name, lbTempleteList.Font, Brushes.Black, 32, 9);
			e.DrawFocusRectangle();
		}

		private void lbTempleteList_DoubleClick(object sender, EventArgs e)
		{
			var mat = (TemplateModel)lbTempleteList.SelectedItem;
			if (null != mat)
			{
				//ウィンドウ開いてテンプレートマッチング
				hud.Activate();
				var bmp = new MatBitmap(SpotColor.Snapshot(hud.GetWindowRect()));
				var pt = bmp.Search(mat.Pattern);
				var g = Graphics.FromImage(bmp.Bitmap);
				var w = mat.Pattern.Width;
				var h = mat.Pattern.Height;
				var x = pt.X;
				var y = pt.Y;
				g.DrawRectangle(Pens.Lime, x, y, w, h);
				new frmImage(bmp.Bitmap, "マッチング結果").ShowDialog();
				bmp.Bitmap.Dispose();
			}
		}
	}


}
