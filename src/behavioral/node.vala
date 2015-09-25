using Gee;
using Json;

namespace apollo.behavioral
{
    public abstract class Node : GLib.Object
    {
        public string name { get; protected set; }

        public abstract bool configure(Json.Object? properties = null);

        public abstract NodeContext create_context() throws BehavioralTreeError;
    }
}
