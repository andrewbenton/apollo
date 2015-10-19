using Gee;
using Json;
using apollo.behavioral;

int main()
{
    const string not_echo_a_json  = """{ "name" : "not_a", "child" : "echo_a" }""";

    const string echo_node_a_json = """{ "name" : "echo_a", "text" : "Hit node \"a\"" }""";

    const string echo_node_b_json = """{ "name" : "echo_b", "text" : "Hit node \"b\"" }""";

    const string sc_or_json       = """{ "name" : "shortcut_node", "children" : ["not_a", "echo_b"] }""";

    Json.Parser not_parser = new Json.Parser();
    Json.Parser a_parser   = new Json.Parser();
    Json.Parser b_parser   = new Json.Parser();
    Json.Parser sc_parser  = new Json.Parser();

    try
    {
        not_parser.load_from_data(not_echo_a_json);
    }
    catch(Error e)
    {
        stderr.printf("ERROR: %s\n", e.message);
    }

    try
    {
        a_parser.load_from_data(echo_node_a_json);
    }
    catch(Error e)
    {
        stderr.printf("ERROR: %s\n", e.message);
        return 1;
    }

    try
    {
        b_parser.load_from_data(echo_node_b_json);
    }
    catch(Error e)
    {
        stderr.printf("ERROR: %s\n", e.message);
        return 1;
    }

    try
    {
        sc_parser.load_from_data(sc_or_json);
    }
    catch(Error e)
    {
        stderr.printf("ERROR: %s\n", e.message);
        return 1;
    }

    Json.Node? not_node = not_parser.get_root();
    Json.Node? a_node   = a_parser.get_root();
    Json.Node? b_node   = b_parser.get_root();
    Json.Node? sc_node  = sc_parser.get_root();

    BehavioralTreeSet bts = new BehavioralTreeSet();

    NotNode nn = new NotNode();
    if(!nn.configure(not_node.get_object()))
        stderr.printf("Configuration for NotNode(EchoNode A) failed.\n");

    EchoNode ena = new EchoNode();
    if(!ena.configure(a_node.get_object()))
        stderr.printf("Configuration for EchoNode A failed.\n");

    EchoNode enb = new EchoNode();
    if(!enb.configure(b_node.get_object()))
        stderr.printf("Configuration for EchoNode B failed.\n");

    ShortcutAndNode san = new ShortcutAndNode();
    if(!san.configure(sc_node.get_object()))
        stderr.printf("Configuration for ShortcutAndNode failed.\n");

    bts.add_node(nn);
    bts.add_node(ena);
    bts.add_node(enb);
    bts.add_node(san);

    bts.register_tree("test", "shortcut_node");

    TreeContext ctx;

    try
    {
        ctx = bts.create_tree("test", 10);
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
