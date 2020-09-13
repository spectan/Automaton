namespace WurmMacro
{
	partial class frmMain
	{
		/// <summary>
		/// 必要なデザイナー変数です。
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// 使用中のリソースをすべてクリーンアップします。
		/// </summary>
		/// <param name="disposing">マネージ リソースを破棄する場合は true を指定し、その他の場合は false を指定します。</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows フォーム デザイナーで生成されたコード

		/// <summary>
		/// デザイナー サポートに必要なメソッドです。このメソッドの内容を
		/// コード エディターで変更しないでください。
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.timer1 = new System.Windows.Forms.Timer(this.components);
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.propertyGrid1 = new System.Windows.Forms.PropertyGrid();
			this.tabPage2 = new System.Windows.Forms.TabPage();
			this.propertyGrid2 = new System.Windows.Forms.PropertyGrid();
			this.tabPage3 = new System.Windows.Forms.TabPage();
			this.lbMacroList = new System.Windows.Forms.ListBox();
			this.tabPage4 = new System.Windows.Forms.TabPage();
			this.lbTempleteList = new System.Windows.Forms.ListBox();
			this.panel1 = new System.Windows.Forms.Panel();
			this.btInstruction = new System.Windows.Forms.Button();
			this.button1 = new System.Windows.Forms.Button();
			this.tbXY = new System.Windows.Forms.TextBox();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.btInputXY = new System.Windows.Forms.Button();
			this.btSave = new System.Windows.Forms.Button();
			this.tbMacroName = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.btStop = new System.Windows.Forms.Button();
			this.btStart = new System.Windows.Forms.Button();
			this.tbScript = new System.Windows.Forms.TextBox();
			this.tabControl1.SuspendLayout();
			this.tabPage1.SuspendLayout();
			this.tabPage2.SuspendLayout();
			this.tabPage3.SuspendLayout();
			this.tabPage4.SuspendLayout();
			this.panel1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
			this.SuspendLayout();
			// 
			// timer1
			// 
			this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.Add(this.tabPage1);
			this.tabControl1.Controls.Add(this.tabPage2);
			this.tabControl1.Controls.Add(this.tabPage3);
			this.tabControl1.Controls.Add(this.tabPage4);
			this.tabControl1.Dock = System.Windows.Forms.DockStyle.Left;
			this.tabControl1.Location = new System.Drawing.Point(0, 0);
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(201, 433);
			this.tabControl1.TabIndex = 2;
			this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.Add(this.propertyGrid1);
			this.tabPage1.Location = new System.Drawing.Point(4, 22);
			this.tabPage1.Name = "tabPage1";
			this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage1.Size = new System.Drawing.Size(193, 407);
			this.tabPage1.TabIndex = 0;
			this.tabPage1.Text = "画面情報";
			this.tabPage1.UseVisualStyleBackColor = true;
			// 
			// propertyGrid1
			// 
			this.propertyGrid1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.propertyGrid1.Location = new System.Drawing.Point(3, 3);
			this.propertyGrid1.Name = "propertyGrid1";
			this.propertyGrid1.Size = new System.Drawing.Size(187, 401);
			this.propertyGrid1.TabIndex = 2;
			this.propertyGrid1.ToolbarVisible = false;
			// 
			// tabPage2
			// 
			this.tabPage2.Controls.Add(this.propertyGrid2);
			this.tabPage2.Location = new System.Drawing.Point(4, 22);
			this.tabPage2.Name = "tabPage2";
			this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage2.Size = new System.Drawing.Size(193, 407);
			this.tabPage2.TabIndex = 1;
			this.tabPage2.Text = "設定";
			this.tabPage2.UseVisualStyleBackColor = true;
			// 
			// propertyGrid2
			// 
			this.propertyGrid2.Dock = System.Windows.Forms.DockStyle.Fill;
			this.propertyGrid2.Location = new System.Drawing.Point(3, 3);
			this.propertyGrid2.Name = "propertyGrid2";
			this.propertyGrid2.Size = new System.Drawing.Size(187, 401);
			this.propertyGrid2.TabIndex = 3;
			this.propertyGrid2.ToolbarVisible = false;
			this.propertyGrid2.PropertyValueChanged += new System.Windows.Forms.PropertyValueChangedEventHandler(this.propertyGrid2_PropertyValueChanged);
			// 
			// tabPage3
			// 
			this.tabPage3.Controls.Add(this.lbMacroList);
			this.tabPage3.Location = new System.Drawing.Point(4, 22);
			this.tabPage3.Name = "tabPage3";
			this.tabPage3.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage3.Size = new System.Drawing.Size(193, 407);
			this.tabPage3.TabIndex = 2;
			this.tabPage3.Text = "マクロ一覧";
			this.tabPage3.UseVisualStyleBackColor = true;
			// 
			// lbMacroList
			// 
			this.lbMacroList.Dock = System.Windows.Forms.DockStyle.Fill;
			this.lbMacroList.FormattingEnabled = true;
			this.lbMacroList.ItemHeight = 12;
			this.lbMacroList.Location = new System.Drawing.Point(3, 3);
			this.lbMacroList.Name = "lbMacroList";
			this.lbMacroList.Size = new System.Drawing.Size(187, 401);
			this.lbMacroList.TabIndex = 0;
			this.lbMacroList.SelectedIndexChanged += new System.EventHandler(this.lbMacroList_SelectedIndexChanged);
			// 
			// tabPage4
			// 
			this.tabPage4.Controls.Add(this.lbTempleteList);
			this.tabPage4.Location = new System.Drawing.Point(4, 22);
			this.tabPage4.Name = "tabPage4";
			this.tabPage4.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage4.Size = new System.Drawing.Size(193, 407);
			this.tabPage4.TabIndex = 3;
			this.tabPage4.Text = "テンプレート";
			this.tabPage4.UseVisualStyleBackColor = true;
			// 
			// lbTempleteList
			// 
			this.lbTempleteList.Dock = System.Windows.Forms.DockStyle.Fill;
			this.lbTempleteList.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
			this.lbTempleteList.FormattingEnabled = true;
			this.lbTempleteList.ItemHeight = 32;
			this.lbTempleteList.Location = new System.Drawing.Point(3, 3);
			this.lbTempleteList.Name = "lbTempleteList";
			this.lbTempleteList.Size = new System.Drawing.Size(187, 401);
			this.lbTempleteList.TabIndex = 0;
			this.lbTempleteList.DrawItem += new System.Windows.Forms.DrawItemEventHandler(this.lbTempleteList_DrawItem);
			this.lbTempleteList.DoubleClick += new System.EventHandler(this.lbTempleteList_DoubleClick);
			// 
			// panel1
			// 
			this.panel1.Controls.Add(this.btInstruction);
			this.panel1.Controls.Add(this.button1);
			this.panel1.Controls.Add(this.tbXY);
			this.panel1.Controls.Add(this.pictureBox1);
			this.panel1.Controls.Add(this.btInputXY);
			this.panel1.Controls.Add(this.btSave);
			this.panel1.Controls.Add(this.tbMacroName);
			this.panel1.Controls.Add(this.label1);
			this.panel1.Controls.Add(this.btStop);
			this.panel1.Controls.Add(this.btStart);
			this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
			this.panel1.Location = new System.Drawing.Point(201, 0);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(426, 93);
			this.panel1.TabIndex = 3;
			// 
			// btInstruction
			// 
			this.btInstruction.Location = new System.Drawing.Point(276, 39);
			this.btInstruction.Name = "btInstruction";
			this.btInstruction.Size = new System.Drawing.Size(62, 22);
			this.btInstruction.TabIndex = 9;
			this.btInstruction.Text = "命令一覧";
			this.btInstruction.UseVisualStyleBackColor = true;
			this.btInstruction.Click += new System.EventHandler(this.btInstruction_Click);
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(276, 12);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(62, 22);
			this.button1.TabIndex = 8;
			this.button1.Text = "削除";
			this.button1.UseVisualStyleBackColor = true;
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// tbXY
			// 
			this.tbXY.Location = new System.Drawing.Point(8, 57);
			this.tbXY.Name = "tbXY";
			this.tbXY.Size = new System.Drawing.Size(100, 19);
			this.tbXY.TabIndex = 7;
			// 
			// pictureBox1
			// 
			this.pictureBox1.Location = new System.Drawing.Point(344, 12);
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.Size = new System.Drawing.Size(64, 64);
			this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			this.pictureBox1.TabIndex = 6;
			this.pictureBox1.TabStop = false;
			this.pictureBox1.Click += new System.EventHandler(this.pictureBox1_Click);
			// 
			// btInputXY
			// 
			this.btInputXY.Location = new System.Drawing.Point(8, 35);
			this.btInputXY.Name = "btInputXY";
			this.btInputXY.Size = new System.Drawing.Size(62, 22);
			this.btInputXY.TabIndex = 5;
			this.btInputXY.Text = "XY入力";
			this.btInputXY.UseVisualStyleBackColor = true;
			this.btInputXY.Click += new System.EventHandler(this.btInputXY_Click);
			// 
			// btSave
			// 
			this.btSave.Location = new System.Drawing.Point(208, 13);
			this.btSave.Name = "btSave";
			this.btSave.Size = new System.Drawing.Size(62, 22);
			this.btSave.TabIndex = 4;
			this.btSave.Text = "保存";
			this.btSave.UseVisualStyleBackColor = true;
			this.btSave.Click += new System.EventHandler(this.btSave_Click);
			// 
			// tbMacroName
			// 
			this.tbMacroName.Location = new System.Drawing.Point(55, 14);
			this.tbMacroName.Name = "tbMacroName";
			this.tbMacroName.Size = new System.Drawing.Size(147, 19);
			this.tbMacroName.TabIndex = 3;
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(6, 17);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(43, 12);
			this.label1.TabIndex = 2;
			this.label1.Text = "マクロ名";
			// 
			// btStop
			// 
			this.btStop.BackColor = System.Drawing.Color.Lime;
			this.btStop.Location = new System.Drawing.Point(195, 39);
			this.btStop.Name = "btStop";
			this.btStop.Size = new System.Drawing.Size(75, 43);
			this.btStop.TabIndex = 1;
			this.btStop.Text = "停止";
			this.btStop.UseVisualStyleBackColor = false;
			this.btStop.Click += new System.EventHandler(this.btStop_Click);
			// 
			// btStart
			// 
			this.btStart.Location = new System.Drawing.Point(114, 41);
			this.btStart.Name = "btStart";
			this.btStart.Size = new System.Drawing.Size(75, 41);
			this.btStart.TabIndex = 0;
			this.btStart.Text = "実行";
			this.btStart.UseVisualStyleBackColor = true;
			this.btStart.Click += new System.EventHandler(this.btStart_Click);
			// 
			// tbScript
			// 
			this.tbScript.Dock = System.Windows.Forms.DockStyle.Fill;
			this.tbScript.Font = new System.Drawing.Font("ＭＳ ゴシック", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
			this.tbScript.Location = new System.Drawing.Point(201, 93);
			this.tbScript.Multiline = true;
			this.tbScript.Name = "tbScript";
			this.tbScript.Size = new System.Drawing.Size(426, 340);
			this.tbScript.TabIndex = 4;
			// 
			// frmMain
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(627, 433);
			this.Controls.Add(this.tbScript);
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.tabControl1);
			this.Name = "frmMain";
			this.Text = "Wurmマクロのまーくん ver0.1";
			this.tabControl1.ResumeLayout(false);
			this.tabPage1.ResumeLayout(false);
			this.tabPage2.ResumeLayout(false);
			this.tabPage3.ResumeLayout(false);
			this.tabPage4.ResumeLayout(false);
			this.panel1.ResumeLayout(false);
			this.panel1.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion
		private System.Windows.Forms.Timer timer1;
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.PropertyGrid propertyGrid1;
		private System.Windows.Forms.TabPage tabPage2;
		private System.Windows.Forms.PropertyGrid propertyGrid2;
		private System.Windows.Forms.TabPage tabPage3;
		private System.Windows.Forms.ListBox lbMacroList;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.Button btSave;
		private System.Windows.Forms.TextBox tbMacroName;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Button btStop;
		private System.Windows.Forms.Button btStart;
		private System.Windows.Forms.TextBox tbScript;
		private System.Windows.Forms.Button btInputXY;
		private System.Windows.Forms.TextBox tbXY;
		private System.Windows.Forms.PictureBox pictureBox1;
		private System.Windows.Forms.Button btInstruction;
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.TabPage tabPage4;
		private System.Windows.Forms.ListBox lbTempleteList;
	}
}

