using Gee;
using Json;

namespace apollo.behavioral
{
    public class ShortcutOrNodeContext : apollo.behavioral.NodeContext
    {
        public int idx { get; protected set; }
        public bool success { get; protected set; }

        public ShortcutOrNodeContext()
        {
            this.idx = 0;
            this.success = false;
        }

        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            ShortcutOrNode son = (ShortcutOrNode)this.parent;

            if(this.success)
            {
                next = null;
                return StatusValue.SUCCESS;
            }
            else
            {
                if(this.idx < son.children.length)
                {
                    next = son.children.index(this.idx);
                    this.idx++;
                    return StatusValue.CALL_DOWN;
                }
                else
                {
                    next = null;
                    return StatusValue.FAILURE;
                }
            }
        }

        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackblard)
        {
            if(status == StatusValue.SUCCESS)
                this.success = true;
        }
    }
}
