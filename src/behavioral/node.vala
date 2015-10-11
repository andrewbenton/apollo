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

                    switch(node.get_node_type())
                    {
                        case NodeType.VALUE:
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
                            break;
                        case NodeType.ARRAY:
                            Json.Array jsn_array = node.get_array();

                            //if(typeof(Gee.Collection) == spec_type)
                            if(spec_type.is_a(typeof(Gee.Collection)))
                            {
                                var collection_member = GLib.Object.@new(spec_type);

                                var boxed = (Gee.Collection<string>)collection_member;

                                foreach(Json.Node n in jsn_array.get_elements())
                                {
                                    if(n.get_node_type() == NodeType.VALUE)
                                    {
                                        GLib.Value val = n.get_value();
                                        GLib.Value str_val = GLib.Value(typeof(string));

                                        if(val.type() == typeof(string))
                                        {
                                            val.transform(ref str_val);
                                        }
                                        else if(Value.type_transformable(val.type(), typeof(string)))
                                        {
                                            val.transform(ref str_val);
                                        }
                                        else
                                        {
                                            log_warn("Unable to transform type[%s] to string.\n", val.type().name());
                                        }

                                        boxed.add(str_val.dup_string());
                                    }
                                    else
                                    {
                                        log_warn("Unable to handle non-value json node type.\n");
                                    }
                                }

                                this.set_property(name, collection_member);
                            }
                            else if(typeof(GLib.List) == spec_type)
                            {
                                GLib.List<string> list_member = new GLib.List<string>();
                                foreach(Json.Node n in jsn_array.get_elements())
                                {
                                    if(n.get_node_type() == NodeType.VALUE)
                                    {
                                        GLib.Value val = n.get_value();
                                        GLib.Value str_val = GLib.Value(typeof(string));

                                        if(val.type() == typeof(string))
                                        {
                                            val.transform(ref str_val);
                                        }
                                        else if(Value.type_transformable(val.type(), typeof(string)))
                                        {
                                            val.transform(ref str_val);
                                        }
                                        else
                                        {
                                            log_warn("Unable to transform type[%s] to string.\n", val.type().name());
                                        }

                                        list_member.append(str_val.dup_string());
                                    }
                                    else
                                    {
                                        log_warn("Unable to handle non-value json node type.\n");
                                    }
                                }

                                this.set_property(name, list_member);
                            }
                            else if(typeof(GLib.Array) == spec_type)
                            {
                                GLib.Array<string> array_member = new GLib.Array<string>();
                                foreach(Json.Node n in jsn_array.get_elements())
                                {
                                    if(n.get_node_type() == NodeType.VALUE)
                                    {
                                        GLib.Value val = n.get_value();
                                        GLib.Value str_val = GLib.Value(typeof(string));

                                        if(val.type() == typeof(string))
                                        {
                                            val.transform(ref str_val);
                                        }
                                        else if(Value.type_transformable(val.type(), typeof(string)))
                                        {
                                            val.transform(ref str_val);
                                        }
                                        else
                                        {
                                            log_warn("Unable to transform type[%s] to string.\n", val.type().name());
                                        }

                                        array_member.append_val(str_val.dup_string());
                                    }
                                    else
                                    {
                                        log_warn("Unable to handle non-value json node type.\n");
                                    }
                                }

                                this.set_property(name, array_member);
                            }
                            else
                            {
                                log_err("Unsupported member type: %s\n", spec_type.name());
                                passing = false;
                            }
                            break;
                        default:
                            log_err("Unable to read member: %s\n", name);
                            passing = false;
                            break;
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
         * Checks that the state of the node to see if the configuration is good.  The expected BehavioralTreeSet for the Node to run against is passed in as well so that names of the sub-nodes can be checked.
         *
         * @param bts The tree set that this node is expected to run against.
         * @return Return whether the node is in a good state for use in the tree.
         */
        public virtual bool validate(BehavioralTreeSet bts)
        {
            return true;
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
