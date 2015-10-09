using Gee;
using Json;

namespace apollo.behavioral
{
    /**
     * The node represents an unrealized entry in a behavioral tree.
     *
     * author: Andrew Benton
     */
    public abstract class Node : GLib.Object
    {
        /**
         * The name of the node.
         */
        public string name { get; protected set; }

        /**
         * Configures the node based on a json object if one is provided.
         *
         * @param properties The Json object that is used to generate the settings for the object.
         * @return True if the configuration was successful.
         */
        public abstract bool configure(Json.Object? properties = null);

        /**
         * Create a context for use on the behavior tree evaluation stack
         *
         * @return The newly created NodeContext
         *
         * @throws BehavioralTreeError Usually thrown in the configuration was successful syntactically, but bad logically.
         */
        public abstract NodeContext create_context() throws BehavioralTreeError;
    }
}
