using Gee;
using Json;

using apollo.behavioral;

int main(string[] args)
{

    string json_doc =
"""
{
    "echo_node" :
    {
        "type": "%s",
        "text": "Hello, ${user}!\n"
    },
    "trees" :
    {
        "test": "echo_node"
    }
}
""".printf(typeof(apollo.behavioral.EchoNode).name());

    stdout.printf("Test will attempt to load and run a \"%s\" from a json doc.\n", typeof(apollo.behavioral.EchoNode).name());

    stdout.printf("Generated JSON Doc:\n%s\n", json_doc);

    BehavioralTreeSet bts =  new BehavioralTreeSet();

    bts.load_json_from_string(json_doc);

    TreeContext ctx;

    try
    {
        ctx = bts.create_tree("test", 10);
    }
    catch(BehavioralTreeError err)
    {
        stderr.printf("ERROR: %s\n", err.message);
        return 1;
    }

    ctx.blackboard["user"] = GLib.Environment.get_user_name();

    StatusValue status = StatusValue.INVALID;

    status = ctx.run();

    stdout.printf("final status: %s\n", status.to_string());

    if(status == StatusValue.SUCCESS)
        return 0;
    else
        return 1;
}
