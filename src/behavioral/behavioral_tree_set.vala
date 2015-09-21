using Gee;

namespace apollo.behavioral
{
    public class BehavioralTreeSet
    {
        private HashMap<string, string> tree_map; /*names of the trees*/
        private HashMap<string, Node> node_map;   /*names of the nodes*/

        public BehavioralTreeSet()
        {
            this.tree_map = new HashMap<string, string>();
            this.node_map = new HashMap<string, Node>();
        }

        public Node get(string node_name)
        {
            return this.node_map[node_name];
        }

        public bool contains(string node_name)
        {
            return (this.node_map[node_name] != null);
        }

        public void register_tree(string tree_name, string root)
        {
            this.tree_map[tree_name] = root;
        }

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
