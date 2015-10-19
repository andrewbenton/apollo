using Gee;
using Json;

using apollo.behavioral;

int main(string[] args)
{
    BehavioralTreeSet bts = new BehavioralTreeSet();

    const string echo_node_json = """{ "name" : "echo_node", "text" : "My name is [${user}] - ${name}" }""";

    Json.Parser en_parser = new Json.Parser();

    try
    {
        en_parser.load_from_data(echo_node_json);
    }
    catch(Error err)
    {
        stderr.printf("ERROR: %s\n", err.message);
        return 1;
    }

    Json.Node? node = en_parser.get_root();

    EchoNode en = new EchoNode();
    if(!en.configure(node.get_object()))
        stderr.printf("Configuration for EchoNode failed.\n");

    bts.add_node(en);

    bts.register_tree("test", en.name);

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
    ctx.blackboard["name"] = GLib.Environment.get_real_name();

    StatusValue status = StatusValue.INVALID;

    while((status = ctx.run()) == StatusValue.RUNNING);

    stdout.printf("final status: %s\n", status.to_string());

    if(status == StatusValue.SUCCESS)
        return 0;
    else
        return 1;
}
