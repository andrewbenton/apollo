namespace apollo.behavioral
{
    public abstract class NodeContext
    {
        public Node parent { get; protected set; }

        public abstract StatusValue call(out string next);

        public abstract void send(StatusValue status);
    }
}
