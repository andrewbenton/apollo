using Gee;
using Json;

namespace apollo.behavioral
{
    public class EchoNodeContext : apollo.behavioral.NodeContext
    {
        public EchoNodeContext()
        {
        }

        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            EchoNode en = this.parent as EchoNode;

            next = null;

            stdout.printf("[%s] => %s\n", en.name, en.text);

            return StatusValue.SUCCESS;
        }

        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackoard)
        {
            log_err("Reached EchoNodeContext.send() which should not be possible.");
        }
    }
}
