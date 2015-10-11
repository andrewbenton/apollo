using Gee;
using Json;

namespace apollo.behavioral
{
    public class ShortcutAndNode : apollo.behavioral.Node
    {
        public GLib.Array<string> children { get; protected set; }

        public ShortcutAndNode()
        {
            this.name = "";
            this.children = new GLib.Array<string>();
        }

        public override NodeContext create_context() throws BehavioralTreeError
        {
            ShortcutAndNodeContext sanc = new ShortcutAndNodeContext();
            sanc.own(this);
            return sanc;
        }
    }
}
