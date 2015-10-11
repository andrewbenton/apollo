using Gee;

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
                return new TreeContext(this, this.tree_map[tree_name], max_iters);
            }
            else
            {
                throw new BehavioralTreeError.NO_SUCH_TREE("No such tree named \"%s\" exists.".printf(tree_name));
            }
        }
    }
}
