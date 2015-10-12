using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * A context for a node that is only ever executed once.  Subsequent visits will not call the child.
     */
    public class SingletonNodeContext : apollo.behavioral.NodeContext
    {
        /**
         * Whether the child node succeeded.
         */
        public bool success { get; protected set; }

        /**
         * Create the singleton node context.
         */
        public SingletonNodeContext()
        {
            this.success = false;
        }

        /**
         * Call the context.  If this is the first global call, call down.
         *
         * @param blackboard Where the GUID value is read from
         * @param next The name of the child node, if one is to be called.
         * @return The status of the call.
         */
        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            SingletonNode sp = (SingletonNode)this.parent;

            bool visited = false;
            if(blackboard[sp.guid] != null)
                visited = blackboard[sp.guid].get_boolean();

            if(visited)
            {
                next = null;
                if(this.success)
                    return StatusValue.SUCCESS;
                else
                    return StatusValue.FAILURE;
            }
            else
            {
                blackboard[sp.guid].set_boolean(true);
                next = sp.child;
                return StatusValue.CALL_DOWN;
            }
        }

        /**
         * Send the status of the child node's execution.
         *
         * @param status The status from the child node.
         * @param blackboard The blackboard for the context.
         */
        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
        {
            if(status == StatusValue.SUCCESS)
                this.success = true;
        }
    }
}
