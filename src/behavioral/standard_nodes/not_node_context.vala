using Gee;
using Json;

namespace apollo.behavioral
{
    public class NotNodeContext : apollo.behavioral.NodeContext
    {
        public bool success { get; protected set; }
        public bool pending_child { get; protected set; }

        public NotNodeContext()
        {
            this.success = false;
            this.pending_child = false;
        }

        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            NotNode nn = (NotNode)this.parent;

            if(this.pending_child)
            {
                next = null;
                this.pending_child = false;
                if(success)
                    return StatusValue.SUCCESS;
                else
                    return StatusValue.FAILURE;
            }
            else
            {
                //call_down to "next" and set pending
                this.pending_child = true;
                next = nn.child;
                return StatusValue.CALL_DOWN;
            }
        }

        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
        {
            if(status == StatusValue.SUCCESS)
                this.success = true;
            else
                this.success = false;
        }
    }
}
