using Gee;

namespace apollo.behavioral
{
    /**
     * The representation of the node in the tree while it is on the execution stack.
     *
     * Author: Andrew Benton
     */
    public abstract class NodeContext
    {
        /**
         * The node that created this context.
         */
        public Node parent { get; protected set; }

        /**
         * Causes a node to take ownership of a context.
         *
         * @param parent The node that will own this context
         */
        public void own(Node parent)
        {
            this.parent = parent;
        }

        /**
         * Run the node and return a status value.  If the result is a CALL_DOWN, then set `next` to the name of the node.
         *
         * @param blackboard Map of values that the contexts can access and modify.
         * @param next Destination of the names of nodes to CALL_DOWN to.
         * @return Status of the execution of the node.
         */
        public abstract StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next);

        /**
         * Send a return status to the context.  This may either be from the node itself, or from a child node.
         *
         * @param status Result from this node's execution, or a child node's execution.
         * @param blackboard Map of values to access and modify.
         */
        public abstract void send(StatusValue status, HashMap<string, GLib.Value?> blackboard);
    }
}
