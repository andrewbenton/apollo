using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Executes child nodes while the child nodes return failure values.  As soon as one succeeds, return success.  If none succeed, return failure.
     */
    public class ShortcutOrNodeContext : apollo.behavioral.NodeContext
    {
        /**
         * The index of the current child node.
         */
        public int idx { get; protected set; }
        /**
         * The running status of the child nodes.
         */
        public bool success { get; protected set; }

        /**
         * Create the shortcut or node.
         */
        public ShortcutOrNodeContext()
        {
            this.idx = 0;
            this.success = false;
        }

        /**
         * Call the context.  If there are child nodes to be called, then call down to them.  If a child node has succeeded, then return success.
         *
         * @param blackboard Unused by this node.
         * @param next The name of child nodes that should be called.
         * @return The status of the call.
         */
        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            ShortcutOrNode son = (ShortcutOrNode)this.parent;

            if(this.success)
            {
                next = null;
                this.idx = 0;
                return StatusValue.SUCCESS;
            }
            else
            {
                if(this.idx < son.children.length)
                {
                    next = son.children.index(this.idx);
                    this.idx++;
                    return StatusValue.CALL_DOWN;
                }
                else
                {
                    next = null;
                    this.idx = 0;
                    return StatusValue.FAILURE;
                }
            }
        }

        /**
         * Send the status of the child node's execution.
         *
         * @param status The status of the child node's execution.
         * @param blackboard The blackboard for the context.
         */
        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
        {
            if(status == StatusValue.SUCCESS)
                this.success = true;
        }
    }
}
