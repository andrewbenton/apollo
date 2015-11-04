using Gee;
using Json;

using apollo.behavioral;

int main(string[] args)
{
    BehavioralTreeSet bt = new BehavioralTreeSet();

    var seq = new SeqNode();
    var noda = new EchoNodeA();
    var nodb = new EchoNodeB();

    seq.configure();
    noda.configure();
    nodb.configure();

    bt.add_node_with_name("top", seq);
    bt.add_node_with_name("SubNodeA", noda);
    bt.add_node_with_name("SubNodeB", nodb);

    bt.register_tree("test", "top");

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

    if(status == StatusValue.SUCCESS)
        return 0;
    else
        return 1;
}

public class EchoNodeA : apollo.behavioral.Node
{
    public string echo_text { get; private set; }

    public EchoNodeA()
    {
        this.init();
    }

    public override void init()
    {
        this.name = "EchoNodeA";
        this.echo_text = "SubNode A";
    }

    public override bool configure(Json.Object? properties = null)
    {
        return true;
    }

    public override NodeContext create_context() throws BehavioralTreeError
    {
        EchoNodeAContext enc = new EchoNodeAContext();
        enc.own(this);
        return enc;
    }
}

public class EchoNodeB : apollo.behavioral.Node
{
    public string echo_text { get; private set; }

    public EchoNodeB()
    {
        this.init();
    }

    public override void init()
    {
        this.name = "EchoNodeB";
        this.echo_text = "SubNode B";
    }

    public override bool configure(Json.Object? properties = null)
    {
        return true;
    }

    public override NodeContext create_context() throws BehavioralTreeError
    {
        EchoNodeBContext enc = new EchoNodeBContext();
        enc.own(this);
        return enc;
    }
}

public class EchoNodeAContext : apollo.behavioral.NodeContext
{
    public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
    {
        stdout.printf("echo: %s\n", ((EchoNodeA)this.parent).echo_text);
        next = null;
        return StatusValue.SUCCESS;
    }

    //send is a no-op
    public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
    {
    }
}

public class EchoNodeBContext : apollo.behavioral.NodeContext
{
    public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
    {
        stdout.printf("echo: %s\n", ((EchoNodeB)this.parent).echo_text);
        next = null;
        return StatusValue.SUCCESS;
    }

    //send is a no-op
    public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
    {
    }
}

public class SeqNode : apollo.behavioral.Node
{
    public string[] children { get; set; }

    public SeqNode()
    {
        this.init();
    }

    public override void init()
    {
        this.name = "SeqNode";
        this.children =  new string[] { "SubNodeA", "SubNodeB" };
    }

    public override bool configure(Json.Object? properties = null)
    {
        return true;
    }

    public override NodeContext create_context() throws BehavioralTreeError
    {
        SeqNodeContext snc = new SeqNodeContext();
        snc.own(this);
        return snc;
    }
}

public class SeqNodeContext : apollo.behavioral.NodeContext
{
    private int idx;
    private bool good;

    public SeqNodeContext()
    {
        this.idx = 0;
        this.good = true;
    }

    /**
     * Try to call child nodes until a failure or the sequence finishes.
     *
     * @param next The CALL_DOWN destination that should be called.
     * @return The status of the call.
     */
    public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
    {
        string[] p_children = ((SeqNode)this.parent).children;

        if(this.good)
        {
            if(this.idx < p_children.length)
            {
                next = p_children[this.idx];
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

    /**
     * Set the status of the context to failed in the case that one of the sequence has failed.
     *
     * @param status The status of the child node that is calling up to this context
     */
    public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
    {
        if(status == StatusValue.FAILURE)
            this.good = false;
    }
}
