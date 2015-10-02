using Gee;

namespace apollo.behavioral
{
    public abstract class NodeContext
    {
        public Node parent { get; protected set; }

        public void own(Node parent)
        {
            this.parent = parent;
        }

        public abstract StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next);

        public abstract void send(StatusValue status, HashMap<string, GLib.Value?> blackboard);
    }
}
