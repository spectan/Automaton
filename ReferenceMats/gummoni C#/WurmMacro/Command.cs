using System;
using System.Text;
using System.Linq;
using System.Reflection;
using System.ComponentModel;
using System.Collections.Generic;

namespace WurmMacro
{
	public class Command
	{
		[Browsable(false)]
		public MethodInfo minfo { get; }

		[DisplayName("命令")]
		public string CommandName => minfo.Name;

		[DisplayName("命令説明")]
		public string DisplayName { get; }

		[DisplayName("説明")]
		public string Comment { get; }

		[DisplayName("使い方")]
		public string Description { get; }


		/// <summary>
		/// コンストラクタ処理
		/// </summary>
		/// <param name="minfo"></param>
		public Command(MethodInfo minfo)
		{
			this.minfo = minfo;
			DisplayName = minfo.GetCustomAttribute<DisplayNameAttribute>().DisplayName;
			Description = minfo.GetCustomAttribute<DescriptionAttribute>().Description;
			Comment = minfo.GetCustomAttribute<CommentAttribute>().Comment;
		}

		public void Execute(object handler, string[] parameters)
		{
			//minfo.Invoke(handler, new object[] { Enum.Parse(typeof(VirtualKeys), parameters[0]) });
			//minfo.Invoke(handler, new object[] { parameters[0] });
			var prm = minfo.GetParameters();
			var args = new object[prm.Length];
			var len = prm.Length;

			for (var idx = 0; idx < len; idx++)
			{
				if (typeof(int) == prm[idx].ParameterType)
				{
					args[idx] = int.Parse(parameters[idx]);
				}
				else
				{
					args[idx] = parameters[idx];
				}
			}
			minfo.Invoke(handler, args);
		}
	}

	public static class MethodInfoExtensions
	{
		public static T GetCustomAttribute<T>(this MethodInfo minfo)
		{
			return (T)minfo.GetCustomAttributes(false).Where(_ => _.GetType() == typeof(T)).FirstOrDefault();
		}
	}

	public class CommandComparer : IComparer<Command>
	{
		public int Compare(Command x, Command y)
		{
			var xx = x.CommandName;
			var yy = y.CommandName;
			return string.Compare(xx, yy);
		}
	}

}
