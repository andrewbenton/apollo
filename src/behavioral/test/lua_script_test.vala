using Gee;
using Json;
using Lua;

using apollo.behavioral;

int main(string[] args)
{
    BehavioralTreeSet bts = new BehavioralTreeSet();

    const string lua_node_json = """{ "name" : "lua_node", "load-list" : [ "inner-value", "nil-value" ], "script" : "print(blackboard['inner-value'], blackboard['nil-value'])" }""";

    Json.Parser ln_parser = new Json.Parser();

    try
    {
        ln_parser.load_from_data(lua_node_json);
    }
    catch(Error err)
    {
        stderr.printf("ERROR: %s\n", err.message);
        return 1;
    }

    Json.Node? node = ln_parser.get_root();

    LuaNode ln = new LuaNode();
    if(!ln.configure(node.get_object()))
        stderr.printf("Configuration of LuaNode failed.\n");

    bts.add_node(ln);

    bts.register_tree("test", ln.name);

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

    var vm = new LuaVM();
    vm.open_libs();

    Value v = Value(typeof(LuaVM));
    v.set_pointer(vm);

    ctx.blackboard[LuaNodeContext.LUA_BLACKBOARD_KEY] = v;
    ctx.blackboard["inner-value"] = "Hello from loaded variable!";

    StatusValue status = StatusValue.INVALID;

    while((status = ctx.run()) == StatusValue.RUNNING);

    stdout.printf("final status: %s\n", status.to_string());

    if(status == StatusValue.SUCCESS)
        return 0;
    else
        return 1;
}
