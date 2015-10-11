using Gee;
using Json;

namespace apollo.behavioral
{
    public class SingletonNodeContext : apollo.behavioral.NodeContext
    {
        public bool success { get; protected set; }

        public SingletonNodeContext()
        {
            this.success = false;
        }

        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            SingletonNode sp = (SingletonNode)this.parent;

            bool visited = false;
            if(blackboard[sp.guid] != null)
                visited = blackboard[sp.guid].get_boolean();

            if(visited)
            {
                next = null;
                if(this.success)
                    return StatusValue.SUCCESS;
                else
                    return StatusValue.FAILURE;
            }
            else
            {
                blackboard[sp.guid].set_boolean(true);
                next = sp.child;
                return StatusValue.CALL_DOWN;
            }
        }

        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
        {
            if(status == StatusValue.SUCCESS)
                this.success = true;
        }
    }
}
