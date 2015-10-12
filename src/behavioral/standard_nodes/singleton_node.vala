using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Check to see if this singleton node has already been visited.  If this is the first visit, the child node will be explored, otherwise it will return.
     */
    public class SingletonNode : apollo.behavioral.Node
    {
        /**
         * The generated GUID for the node.  This may be upserted by the JSON configuration.
         */
        public string guid { get; protected set; }
        /**
         * The name of the child node to be executed.
         */
        public string child { get; protected set; }

        /**
         * Create the singleton node with no name, a random guid, and no child.
         */
        public SingletonNode()
        {
            this.name = "";
            this.guid = GLib.Random.int_range(0, int32.MAX).to_string();
            this.child = "";
        }

        /**
          Create the singleton node context and link it to the current node.
         *
         * @return {@link SingletonNodeContext} and link it to this node for execution.
         */
        public override NodeContext create_context() throws BehavioralTreeError
        {
            SingletonNodeContext snc = new SingletonNodeContext();
            snc.own(this);
            return snc;
        }
    }
}
