using Gee;
using Json;

namespace apollo.behavioral
{
    public class ShortcutAndNodeContext : apollo.behavioral.NodeContext
    {
        public int idx { get; protected set; }
        public bool success { get; protected set; }

        public ShortcutAndNodeContext()
        {
            this.idx = 0;
            this.success = true;
        }

        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            ShortcutAndNode san = (ShortcutAndNode)this.parent;

            if(this.success)
            {
                if(this.idx < san.children.length)
                {
                    next = san.children.index(this.idx);
                    this.idx++;
                    return StatusValue.CALL_DOWN;
                }
                else
                {
                    next = null;
                    return StatusValue.SUCCESS;
                }
            }
            else
            {
                next = null;
                return StatusValue.FAILURE;
            }
        }

        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackblard)
        {
            if(status != StatusValue.SUCCESS)
                this.success = false;
        }
    }
}
