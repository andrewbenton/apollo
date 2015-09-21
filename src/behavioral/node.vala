using Gee;
using Json;

namespace apollo.behavioral
{
    public abstract class Node
    {
        public string name { get; private set; }

        public abstract bool configure(Json.Object properties);

        public abstract NodeContext create_context() throws BehavioralTreeError;
    }
}
