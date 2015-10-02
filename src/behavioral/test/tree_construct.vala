using Gee;
using Json;

using apollo.behavioral;

int main(string[] args)
{
    BehavioralTreeSet bt = new BehavioralTreeSet();

    var echo = new EchoNode();
    echo.configure();

    bt.add_node("echo", echo);

    bt.register_tree("test", "echo");

    TreeContext ctx;

    try
    {
        ctx = bt.create_tree("test", 1);
    }
    catch(BehavioralTreeError bte)
    {
        stderr.printf("ERROR: %s\n", bte.message);
        return 1;
    }

    StatusValue status = StatusValue.INVALID;

    while((status = ctx.run()) == StatusValue.RUNNING);

    stdout.printf("final status: %s\n", status.to_string());

    return 0;
}

public class EchoNode : apollo.behavioral.Node
{
    public string echo_text { get; private set; }

    public EchoNode()
    {
        this.name = "";
        this.echo_text = "";
    }

    public override bool configure(Json.Object? properties = null)
    {
        this.echo_text = "My echo test text";
        return true;
    }

    public override NodeContext create_context() throws BehavioralTreeError
    {
        EchoNodeContext enc = new EchoNodeContext();
        enc.own(this);
        return enc;
    }
}

public class EchoNodeContext : apollo.behavioral.NodeContext
{
    public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
    {
        stdout.printf("echo: %s\n", ((EchoNode)this.parent).echo_text);
        next = null;
        return StatusValue.SUCCESS;
    }

    public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
    {
    }
}
