using Gee; using Json;

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
         * Initialize the structures in the object that are needed by the configuration step.
         */
        public abstract void init();

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

            if(this.get_type().is_a(typeof(Json.Serializable)))
            {
                Json.Serializable ser_self = this as Json.Serializable;

                assert(ser_self != null);

                foreach(ParamSpec spec in specs)
                {
                    string name = spec.get_name();
                    Value val;
                    passing &= ser_self.deserialize_property(name, out val, spec, properties.get_member(name));
                    ser_self.set_property(spec, val);
                }

                return passing;
            }

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
                                Gee.Collection<string> boxed;
                                log_info("Attempting to create Gee.Collection of type: %s\n", spec_type.name());

                                if(spec_type == typeof(Gee.ArrayList))
                                {
                                    boxed = new Gee.ArrayList<string>();
                                    log_info("Created ArrayList at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.ArrayQueue))
                                {
                                    boxed = new Gee.ArrayQueue<string>();
                                    log_info("Created ArrayQueue at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.ConcurrentList))
                                {
                                    boxed = new Gee.ConcurrentList<string>();
                                    log_info("Created ConcurrentList at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.HashSet))
                                {
                                    boxed = new Gee.HashSet<string>();
                                    log_info("Created HashSet at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.HashMultiSet))
                                {
                                    boxed = new Gee.HashMultiSet<string>();
                                    log_info("Created HashMultiSet at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.LinkedList))
                                {
                                    boxed = new Gee.LinkedList<string>();
                                    log_info("Created LinkedList at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.PriorityQueue))
                                {
                                    boxed = new Gee.PriorityQueue<string>();
                                    log_info("Created PriorityQueue at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.TreeMultiSet))
                                {
                                    boxed = new Gee.TreeMultiSet<string>();
                                    log_info("Created TreeMultiSet at %p\n", (void*)boxed);
                                }
                                else if(spec_type == typeof(Gee.TreeSet))
                                {
                                    boxed = new Gee.TreeSet<string>();
                                    log_info("Created TreeSet at %p\n", (void*)boxed);
                                }
                                else
                                {
                                    boxed = null;
                                    log_err("Unsupported Gee.Collection type: %s\n", spec_type.name());
                                }

                                if(null != boxed)
                                {
                                    log_info("Created Gee.Collection of type: %s\n", boxed.get_type().name());

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

                                            log_info("Adding \"%s\" to Collection\n", (string)str_val);
                                            boxed.add((string)str_val);
                                        }
                                        else
                                        {
                                            log_warn("Unable to handle non-value json node type.\n");
                                        }
                                    }

                                    var col = GLib.Object.@new(spec_type);

                                    col = boxed;

                                    this.set_property(name, col);
                                }
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

                                        log_info("Adding \"%s\" to GLib.List\n", (string)str_val);
                                        list_member.append((string)str_val);
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
                                            continue;
                                        }

                                        log_info("Adding \"%s\" to GLib.Array\n", (string)str_val);
                                        array_member.append_val((string)str_val);
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
                        case NodeType.OBJECT:
                            Json.Object obj = node.get_object();

                            if(spec_type.is_a(typeof(Gee.Map)))
                            {
                                Gee.Map<string, string> map;

                                if(spec_type == typeof(Gee.HashMap))
                                {
                                    map = new Gee.HashMap<string, string>();
                                    log_info("Created %s at %p\n", map.get_type().name(), (void*)map);
                                }
                                else if(spec_type == typeof(Gee.TreeMap))
                                {
                                    map = new Gee.TreeMap<string, string>();
                                    log_info("Created %s at %p\n", map.get_type().name(), (void*)map);
                                }
                                else
                                {
                                    map = null;
                                    log_err("Unsupported Gee.Map type: %s\n", spec_type.name());
                                }

                                if(map != null)
                                {
                                    foreach(string member in obj.get_members())
                                    {
                                        Json.Node n = (Json.Node)obj.get_member(member);

                                        if(n.get_node_type() == NodeType.VALUE)
                                        {
                                            GLib.Value val = n.get_value();
                                            GLib.Value str_val = GLib.Value(typeof(string));

                                            if(val.type() == typeof(string))
                                                val.transform(ref str_val);
                                            else if(Value.type_transformable(val.type(), typeof(string)))
                                                val.transform(ref str_val);
                                            else
                                            {
                                                log_warn("Unable to transform type[%s] to string.\n", val.type().name());
                                                continue;
                                            }

                                            log_info("Adding \"(%s, %s)\" to Gee.Map\n", member, (string)str_val);
                                            map.@set(member, (string)str_val);
                                        }
                                        else
                                        {
                                            log_warn("Unable to extract data from %s[%s] because it is not a value type.\n", name, member);
                                        }
                                    }

                                    var boxed = GLib.Object.@new(spec_type);

                                    boxed = map;

                                    this.set_property(name, boxed);
                                }
                            }
                            else if(typeof(GLib.HashTable) == spec_type)
                            {
                                var table = new HashTable<string, string>(str_hash, str_equal);

                                foreach(string member in obj.get_members())
                                {
                                    Json.Node n = (Json.Node)obj.get_member(member);

                                    if(n.get_node_type() == NodeType.VALUE)
                                    {
                                        GLib.Value val = n.get_value();
                                        GLib.Value str_val = GLib.Value(typeof(string));

                                        if(val.type() == typeof(string))
                                            val.transform(ref str_val);
                                        else if(Value.type_transformable(val.type(), typeof(string)))
                                            val.transform(ref str_val);
                                        else
                                        {
                                            log_warn("Unable to transform type[%s] to string.\n", val.type().name());
                                            continue;
                                        }

                                        log_info("Adding \"(%s, %s)\" to GLib.HashTable.\n", member, (string)str_val);
                                        table.@set(member, (string)str_val);
                                    }
                                    else
                                    {
                                        log_warn(@"Unable to extract data from %s[%s] because it is not a value type.\n", name, member);
                                    }
                                }

                                this.set_property(name, table);
                            }
                            else
                            {
                                log_err("Unsupported member type for %s: %s\n", name, spec_type.name());
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
                    log_err("Member %s is not available in the Json Object\n", name);
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
