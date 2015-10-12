using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Executes child nodes while the child nodes return success values.  As soon as one fails, return failure.  If none fail, return success.
     */
    public class ShortcutAndNodeContext : apollo.behavioral.NodeContext
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
         * Create the shortcut and node.
         */
        public ShortcutAndNodeContext()
        {
            this.idx = 0;
            this.success = true;
        }

        /**
         * Call the context.  If there are child nodes to be called, then call down to them. If a child node has failed, then return failure.
         *
         * @param blackboard Unused by this node.
         * @param next The name of child nodes that should be called.
         * @return The status of the call.
         */
        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            ShortcutAndNode san = (ShortcutAndNode)this.parent;

            if(this.success)
            {
                if(this.idx < san.children.length)
                {
                    next = san.children.index(this.idx);
                    this.idx++;
                    return StatusValue.CALL_DOWN;
                }
                else
                {
                    next = null;
                    this.idx = 0;
                    return StatusValue.SUCCESS;
                }
            }
            else
            {
                next = null;
                this.idx = 0;
                return StatusValue.FAILURE;
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
            if(status != StatusValue.SUCCESS)
                this.success = false;
        }
    }
}
