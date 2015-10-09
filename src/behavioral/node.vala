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
        public virtual bool configure(Json.Object? properties = null)
        {
            bool passing = true;

            ParamSpec[] specs = this.get_class().list_properties();

            if(null == properties)
                return (0 == specs.length);

            foreach(ParamSpec spec in specs)
            {
                string name = spec.get_name();
                Type spec_type = spec.value_type;

                if(properties.has_member(name))
                {
                    Json.Node node = properties.get_member(name);

                    if(spec_type == node.get_value_type())
                    {
                        this.set_property(name, node.get_value());
                    }
                    else if(Value.type_transformable(node.get_value_type(), spec_type))
                    {
                        Value store = Value(spec_type);

                        node.get_value().transform(ref store);

                        this.set_property(name, store);
                    }
                    else
                    {
                        passing = false;
                    }
                }
                else
                {
                    passing = false;
                }
            }

            return passing;
        }

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
