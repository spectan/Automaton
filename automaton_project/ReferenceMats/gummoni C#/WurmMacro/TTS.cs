//using SpeechLib;
using System.Speech.Synthesis;
using System.Windows.Forms;

namespace WurmMacro
{
	public class TTS
	{
		//SpVoice VoiceSpeeach { get; } = new SpVoice();
		SpeechSynthesizer VoiceSpeeach { get; } = new SpeechSynthesizer();
		public bool IsSpeach { get; set; }

		public void Speak(string message)
		{
			if (IsSpeach)
			{
				//VoiceSpeeach.Speak(message, SpeechVoiceSpeakFlags.SVSFlagsAsync);
				VoiceSpeeach.SpeakAsync(message);
            }
		}

		public void Show(string message)
		{
			Speak(message);
			MessageBox.Show(message);
		}

	}
}
