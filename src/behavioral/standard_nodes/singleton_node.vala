using Gee;
using Json;

namespace apollo.behavioral
{
    public class SingletonNode : apollo.behavioral.Node
    {
        public string guid { get; protected set; }
        public string child { get; protected set; }

        public SingletonNode()
        {
            this.name = "";
            this.guid = GLib.Random.int_range(0, int32.MAX).to_string();
            this.child = "";
        }

        public override NodeContext create_context() throws BehavioralTreeError
        {
            SingletonNodeContext snc = new SingletonNodeContext();
            snc.own(this);
            return snc;
        }
    }
}
