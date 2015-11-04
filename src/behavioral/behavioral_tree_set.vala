using Gee;
using Json;

namespace apollo.behavioral
{
    /**
     * Contains all information needed to construct behavioral trees and their contexts.
     *
     */
    public class BehavioralTreeSet
    {
        private HashMap<string, string> tree_map; /*names of the trees*/
        private HashMap<string, Node> node_map;   /*names of the nodes*/

        /**
         * Create the containing context for the behavioral trees.
         */
        public BehavioralTreeSet()
        {
            this.tree_map = new HashMap<string, string>();
            this.node_map = new HashMap<string, Node>();
        }

        /**
         * Gets a named node from the internal map.
         *
         * @param node_name The name of the node to retrieve.
         * @return The node mapped by node_name or null if the map is invalid.
         */
        public Node get(string node_name)
        {
            return this.node_map[node_name];
        }

        /**
         * Check to see if the node_name is registered
         *
         * @param node_name The name of the node to check for.
         * @return True only if the node is mapped.
         */
        public bool has_node(string node_name)
        {
            return (this.node_map[node_name] != null);
        }

        /**
         * Check to see if tree_name is a valid registered tree with a valid node.
         *
         * @param tree_name The name of the tree to check.
         * @return True only if the tree map is valid and the listed root node exists.
         */
        public bool has_tree(string tree_name)
        {
            if(this.tree_map[tree_name] != null)
                return (this.node_map[this.tree_map[tree_name]] != null);
            else
                return false;
        }

        /**
         * Register a node its internal name.
         *
         * @param node The instantiated node to be registered.  The registration name will be derived from this node.
         */
        public void add_node(Node node)
        {
            this.node_map[node.name] = node;
        }

        /**
         * Register a node with a designated name.
         *
         * @param node_name The name that the node will be mapped with.
         * @param node The instantiated node to be registered.
         */
        public void add_node_with_name(string node_name, Node node)
        {
            this.node_map[node_name] = node;
        }

        /**
         * Register a map between a tree name and the name of a root node.
         *
         * @param tree_name The desired name of the tree
         * @param root The registered name of the target node
         */
        public void register_tree(string tree_name, string root)
        {
            this.tree_map[tree_name] = root;
        }

        /**
         * Create a {@link TreeContext} based of of the tree_name.  It will run for max_iters per call to its {@link apollo.behavioral.TreeContext.run} method.
         *
         * @param tree_name Name of the tree context to be generated.  It must be valid.
         * @param max_iters The maximum number of iterations per call to {@link apollo.behavioral.TreeContext.run}
         * @return The valid created tree context
         *
         * @throws BehavioralTreeError Whenever creation of the tree context fails, or the name was invalid
         */
        public TreeContext create_tree(string tree_name, uint max_iters) throws BehavioralTreeError
        {
            if(this.tree_map.has_key(tree_name))
            {
                string root_node = this.tree_map[tree_name];
                if(!this.node_map.has_key(root_node))
                {
                    throw new BehavioralTreeError.NO_SUCH_NODE("No such node named \"%s\" exists to root the tree \"%s\"".printf(root_node, tree_name));
                }

                return new TreeContext(this, this.tree_map[tree_name], max_iters);
            }
            else
            {
                throw new BehavioralTreeError.NO_SUCH_TREE("No such tree named \"%s\" exists.".printf(tree_name));
            }
        }

        private Json.Object? treat_member_translation(string node_name, Json.Node node, out string type)
        {
            const string NODE_TYPE_NAME = "type";
            type = null;
            if(node.get_node_type() == NodeType.OBJECT)
            {
                Json.Object obj = node.get_object();

                if(!obj.has_member(NODE_TYPE_NAME))
                {
                    log_err("Object does not contain a node type.\n");
                    return null;
                }

                if(obj.get_member(NODE_TYPE_NAME).get_node_type() != NodeType.VALUE)
                {
                    log_err("Objects member, %s, is not a value type.\n", NODE_TYPE_NAME);
                    return null;
                }

                Value type_value = Value(typeof(string));
                Value inner_type_value = obj.get_member(NODE_TYPE_NAME).get_value();

                if(!Value.type_transformable(inner_type_value.type(), type_value.type()))
                {
                    log_err("Objects member, %s, cannot be translated to a string type from a %s type.\n", NODE_TYPE_NAME, inner_type_value.type().name());
                    return null;
                }

                inner_type_value.transform(ref type_value);

                type = type_value.get_string().dup();
                log_info("Extracted node type to be created as [%s].\n", type);
                //log_info("Extracted node type to be created as [%s].\n", type_value.get_string());

                obj.remove_member(NODE_TYPE_NAME);

                log_info("Pushing name \"%s\" inside object.\n", node_name);
                obj.set_string_member("name", node_name);

                return obj;
            }
            else
            {
                log_err("Unable to handle node configuration of a non-object type.\n");
                return null;
            }
        }

        public bool load_json_from_string(string json_data)
        {
            const string TREES_NODE_NAME = "trees";

            Json.Parser parser = new Json.Parser();
            try
            {
                parser.load_from_data(json_data);

                Json.Node? root = parser.get_root();

                bool success = true;

                if(root.get_node_type() == NodeType.OBJECT)
                {
                    Json.Object obj = root.get_object();

                    Json.Node nod = null;
                    Json.Object nodo = null;

                    if(obj.has_member(TREES_NODE_NAME))
                    {
                        nod = obj.get_member(TREES_NODE_NAME);
                        if(nod.get_node_type() == NodeType.OBJECT)
                        {
                            nodo = nod.get_object();
                            foreach(string tree_name in nodo.get_members())
                            {
                                Json.Node tree_name_node = nodo.get_member(tree_name);

                                if(tree_name_node.get_node_type() == NodeType.VALUE)
                                {
                                    Value node_value = tree_name_node.get_value();
                                    Value val = Value(typeof(string));

                                    if(Value.type_transformable(node_value.type(), val.type()))
                                    {
                                        success &= node_value.transform(ref val);

                                        //this.register_tree(tree_name, val.strdup_contents());
                                        this.register_tree(tree_name, val.get_string().dup());
                                    }
                                    else
                                    {
                                        log_warn("Unable to convert value at %s.%s to a string\n", TREES_NODE_NAME, tree_name);
                                    }
                                }
                                else
                                {
                                    log_warn("Unable to handle non-value node types for tree names\n");
                                }
                            }
                        }
                        else
                        {
                            log_warn("The tree map must be a json object.\n");
                        }

                        obj.remove_member(TREES_NODE_NAME);
                    }

                    foreach(string mem in obj.get_members())
                    {
                        string type_name;

                        Json.Object? trans = this.treat_member_translation(mem, obj.get_member(mem), out type_name);

                        if(trans != null && type_name != null)
                        {
                            GLib.Type type = GLib.Type.from_name(type_name);

                            if(((ulong)type) == 0)
                            {
                                log_err("Failed to find type \"%s\"\n", type_name);
                                success &= false;
                                continue;
                            }

                            GLib.Object gen_object = GLib.Object.@new(type);

                            if(gen_object == null)
                            {
                                log_err("Failed to create node \"%s\" of type \"%s\"\n", mem, type_name);
                                success &= false;
                            }

                            apollo.behavioral.Node gen_node = gen_object as apollo.behavioral.Node;

                            if(gen_node == null)
                            {
                                log_err("Generated node \"%s\" of type \"%s\", is not a descendant of apollo.behavioral.Node and cannot be used.\n", mem, type_name);
                                success  &= false;
                            }

                            gen_node.init();

                            bool rc = gen_node.configure(trans);

                            if(rc)
                            {
                                this.add_node_with_name(mem, gen_node);
                            }
                            else
                            {
                                log_err("Configuration for node \"%s\" failed.\n", mem);
                            }

                            success &= rc;
                        }
                        else
                        {
                            log_err("Unable to translate member \"%s\" to a behavioral tree node configuration.\n", mem);
                            success &= false;
                        }
                    }

                    return success;
                }
                else
                {
                    log_err("Top level json node must be an object\n");
                    return false;
                }
            }
            catch(Error e)
            {
                log_err("Unable to parse json data: %s\n", e.message);
                return false;
            }
        }

        public bool load_json_from_file(string file_name)
        {
            string str = null;
            try
            {
                FileUtils.get_contents(file_name, out str);
                bool rc = this.load_json_from_string(file_name);
                if(!rc)
                    log_err("Unable to read json data from %s\n", file_name);
                return rc;
            }
            catch(FileError e)
            {
                log_err("ERROR: %s\n", e.message);
                return false;
            }
        }
    }
}
