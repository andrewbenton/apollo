using Gee;
using Json;

namespace apollo.behavioral
{
    /**
     * Evaluate child nodes while returned values are failing.
     */
    public class ShortcutOrNode : apollo.behavioral.Node
    {

        /**
         * The children that will be run by the shortcut node.
         */
        public GLib.Array<string> children { get; protected set; }

        /**
         * Creates the shortcut node with no name and no children.
         */
        public ShortcutOrNode()
        {
            this.name = "";
            this.children = new GLib.Array<string>();
        }

        /**
         * Create the node context and link it to the current ShortcutOrNode.
         *
         * @return {@link ShortcutOrNodeContext} and link it to this node for execution.
         */
        public override NodeContext create_context() throws BehavioralTreeError
        {
            ShortcutOrNodeContext sanc = new ShortcutOrNodeContext();
            sanc.own(this);
            return sanc;
        }
    }
}
