using Gee;
using Json;

namespace apollo.behavioral
{
    public class NotNode : apollo.behavioral.Node
    {
        public string child { get; protected set; }

        public NotNode()
        {
            this.name = "";
            this.child = "";
        }

        public override NodeContext create_context() throws BehavioralTreeError
        {
            NotNodeContext nnc = new NotNodeContext();
            nnc.own(this);
            return nnc;
        }
    }
}
