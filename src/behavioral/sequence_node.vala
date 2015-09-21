using Gee;
using Json;

namespace apollo.behavioral
{
    public class SequenceNode : Node
    {
        private Json.Object properties;

        public SequenceNode()
        {
            this.properties = null;
        }

        public override bool configure(Json.Object properties)
        {
            this.properties = properties;
            return true;
        }

        public override NodeContext create_context() throws BehavioralTreeError
        {
            Json.Node seq = null;
            Json.Node nod = null;

            if(this.properties.has_member("sequence"))
            {
                seq = this.properties.get_member("sequence");
                switch(seq.get_node_type())
                {
                    case NodeType.ARRAY:
                        //to string all, then return as string[]
                        Json.Array arr = seq.get_array();
                        uint arr_len = arr.get_length();

                        string[] child_nodes = new string[0];

                        arr.foreach_element((arr, idx, node) =>
                        {
                            child_nodes += node.get_string();
                        });

                        return new SequenceNodeContext(this, child_nodes);
                    case NodeType.VALUE:
                        //if string, pass, else fail
                        string str = seq.get_string();
                        return new SequenceNodeContext(this, str.split(","));
                    default:
                        throw new BehavioralTreeError.MISSING_OR_MALFORMED_PROPERTY("The property \"%s\" was in the wrong format on the node \"%s\".".printf("sequence", this.name));
                }
            }
            else
            {
                throw new BehavioralTreeError.MISSING_OR_MALFORMED_PROPERTY("The property \"%s\" was missing from theo node \"%s\".".printf("sequence", this.name));
            }
        }
    }
}
