using Gee;
using Json;

using apollo.behavioral;

int main(string[] args)
{
    BehavioralTreeSet bts = new BehavioralTreeSet();

    var jcn = new JsonConfNode();

    Json.Object conf = new Json.Object();
    conf.set_string_member("name", "json-config-object");
    conf.set_string_member("text", "hello world!");

    Json.Generator gen = new Json.Generator();
    Json.Node wrapper = new Json.Node(Json.NodeType.OBJECT);
    wrapper.set_object(conf);
    gen.set_root(wrapper);

    stdout.printf("JsonConfNode Object:\n%s\n", gen.to_data(null));

    assert(jcn.configure() == false);

    assert(jcn.configure(conf) == true);

    bts.add_node_with_name("json", jcn);

    bts.register_tree("test", "json");

    TreeContext ctx;

    try
    {
        ctx = bts.create_tree("test", 1);
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

public class JsonConfNode : apollo.behavioral.Node
{
    public string text { get; protected set; }

    public JsonConfNode()
    {
        this.init();
    }

    public override void init()
    {
        this.name = "";
        this.text = "";
    }

    public override NodeContext create_context() throws BehavioralTreeError
    {
        JsonConfNodeContext jcnc = new JsonConfNodeContext();
        jcnc.own(this);
        return jcnc;
    }
}

public class JsonConfNodeContext : apollo.behavioral.NodeContext
{
    public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
    {
        stdout.printf("[%s] => text: %s\n", this.parent.name, ((JsonConfNode)this.parent).text);
        next = null;
        return StatusValue.SUCCESS;
    }

    public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
    {
    }
}
