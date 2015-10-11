using Gee;
using Json;

namespace apollo.behavioral
{
    public class ShortcutOrNode : apollo.behavioral.Node
    {
        public GLib.Array<string> children { get; protected set; }

        public ShortcutOrNode()
        {
            this.name = "";
            this.children = new GLib.Array<string>();
        }

        public override NodeContext create_context() throws BehavioralTreeError
        {
            ShortcutOrNodeContext sanc = new ShortcutOrNodeContext();
            sanc.own(this);
            return sanc;
        }
    }
}
