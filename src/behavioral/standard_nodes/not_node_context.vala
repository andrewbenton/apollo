using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Executes the child node and returns failure if the child returns success, and return success otherwise.
     */
    public class NotNodeContext : apollo.behavioral.NodeContext
    {
        /**
         * The returned value of the child.
         */
        public bool success { get; protected set; }
        /**
         * The state of the execution, whether the child node has been called and this is waiting for a return value.
         */
        public bool pending_child { get; protected set; }

        /**
         * Create the not node.
         */
        public NotNodeContext()
        {
            this.success = false;
            this.pending_child = false;
        }

        /**
         * Call the context.  If the child node has not yet been evaluated, then call down to that node.  If the node has been evaluated, return the inverse success value.
         *
         * @param blackboard Unused by this node.
         * @param next The name of the child node that will be called.
         * @return The status of the call.
         */
        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            NotNode nn = (NotNode)this.parent;

            if(this.pending_child)
            {
                next = null;
                this.pending_child = false;
                if(success)
                    return StatusValue.SUCCESS;
                else
                    return StatusValue.FAILURE;
            }
            else
            {
                //call_down to "next" and set pending
                this.pending_child = true;
                next = nn.child;
                return StatusValue.CALL_DOWN;
            }
        }

        /**
         * Send the status of the child node's execution.
         *
         * @param status The status of the child node.
         * @param blackboard The blackboard for the context.
         */
        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
        {
            if(status == StatusValue.SUCCESS)
                this.success = true;
            else
                this.success = false;
        }
    }
}
