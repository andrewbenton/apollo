using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Evaluate child nodes while the success values are not failing.
     */
    public class ShortcutAndNode : apollo.behavioral.Node
    {

        /**
         * The children that will be run by the shortcut node.
         */
        public GLib.Array<string> children { get; protected set; }

        /**
         * Create the shortcut node with no name and no children.
         */
        public ShortcutAndNode()
        {
            this.name = "";
            this.children = new GLib.Array<string>();
        }

        /**
         * Create the node context and link it to the current ShortcutAndNode.
         *
         * @return {@link ShortcutAndNodeContext} and link it to this node for execution.
         */
        public override NodeContext create_context() throws BehavioralTreeError
        {
            ShortcutAndNodeContext sanc = new ShortcutAndNodeContext();
            sanc.own(this);
            return sanc;
        }
    }
}
