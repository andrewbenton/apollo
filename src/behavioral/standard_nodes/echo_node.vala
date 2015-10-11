using Gee;
using Json;

namespace apollo.behavioral
{
    public class EchoNode : apollo.behavioral.Node
    {
        public string text { get; protected set; }

        public EchoNode()
        {
            this.text = "";
        }

        public override bool validate(BehavioralTreeSet bts)
        {
            return this.text != null && this.text != "";
        }

        public override NodeContext create_context() throws BehavioralTreeError
        {
            EchoNodeContext enc = new EchoNodeContext();
            enc.own(this);
            return enc;
        }
    }
}
