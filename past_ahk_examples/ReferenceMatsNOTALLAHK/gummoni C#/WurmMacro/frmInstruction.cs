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
	public partial class frmInstruction : Form
	{
		public frmInstruction()
		{
			InitializeComponent();
		}

		TTS tts { get; }
		public frmInstruction(TTS tts, Command[] commands)
		{
			InitializeComponent();
			dataGridView1.DataSource = commands;
			this.tts = tts;
		}

		private void dataGridView1_SelectionChanged(object sender, EventArgs e)
		{
			var rows = dataGridView1.SelectedRows;
			if (null == rows) return;
			if (0 == rows.Count) return;
            var idx = rows[0].Index;
			var command = ((Command[])dataGridView1.DataSource)[idx];
			tts.Speak(command.CommandName);
		}
	}
}
