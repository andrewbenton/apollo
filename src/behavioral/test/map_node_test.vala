using Gee;
using Json;

using apollo.behavioral;

int main(string[] args)
{
    Test.init(ref args);

    add_gee_map_test();
    add_glib_hashtable_test();

    return Test.run();
}

void add_gee_map_test()
{
    Test.add_func(Environment.get_current_dir(), () =>
            {
                const string gee_json = """{ "name" : "gee_hashmap_node", "map" : { "library" : "gee", "class" : "hashmap" } }""";

                Json.Parser jp = new Json.Parser();

                try
                {
                    jp.load_from_data(gee_json);
                }
                catch(Error err)
                {
                    stderr.printf("ERROR: %s\n", err.message);
                    Test.fail();
                    return;
                }

                Json.Node? node = jp.get_root();

                GeeJsonConfNode gn = new GeeJsonConfNode();
                if(!gn.configure(node.get_object()))
                {
                    stderr.printf("Configuration of GeeJsonConfNode failed\n");
                    Test.fail();
                    return;
                }

                if(gn.map["library"] != "gee")
                    Test.fail();

                if(gn.map["class"] != "hashmap")
                    Test.fail();
            });
}

void add_glib_hashtable_test()
{
    Test.add_func(Environment.get_current_dir(), () =>
            {
                const string glib_json = """{ "name" : "glib_hashtable_node", "map" : { "library" : "glib", "class" : "hashtable" } }""";

                Json.Parser jp = new Json.Parser();

                try
                {
                    jp.load_from_data(glib_json);
                }
                catch(Error err)
                {
                    stderr.printf("ERROR: %s\n", err.message);
                    Test.fail();
                    return;
                }

                Json.Node? node = jp.get_root();

                GLibJsonConfNode gn = new GLibJsonConfNode();
                if(!gn.configure(node.get_object()))
                {
                    stderr.printf("Configuration of GLibJsonConfNode failed\n");
                    Test.fail();
                    return;
                }

                if(gn.map["library"] != "glib")
                    Test.fail();

                if(gn.map["class"] != "hashtable")
                    Test.fail();
            });
}

public class GeeJsonConfNode : apollo.behavioral.Node
{
    public Gee.HashMap<string, string> map { get; protected set; }

    public GeeJsonConfNode()
    {
        this.init();
    }

    public override void init()
    {
        this.name = "";
        this.map = new Gee.HashMap<string, string>();
    }

    public override NodeContext create_context() throws BehavioralTreeError
    {
        GeeJsonConfNodeContext gjcn = new GeeJsonConfNodeContext();
        gjcn.own(this);
        return gjcn;
    }
}

public class GLibJsonConfNode : apollo.behavioral.Node
{
    public GLib.HashTable<string, string> map { get; protected set; }

    public GLibJsonConfNode()
    {
        this.init();
    }

    public override void init()
    {
        this.name = "";
        this.map = new HashTable<string, string>(str_hash, str_equal);
    }

    public override NodeContext create_context() throws BehavioralTreeError
    {
        GLibJsonConfNodeContext gjcn = new GLibJsonConfNodeContext();
        gjcn.own(this);
        return gjcn;
    }
}

public class GeeJsonConfNodeContext : apollo.behavioral.NodeContext
{
    public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
    {
        GeeJsonConfNode gp = this.parent as GeeJsonConfNode;

        if(gp != null)
        {
            stdout.printf("Map:\n");
            foreach(string key in gp.map.keys)
            {
                stdout.printf("\t[%s] => %s\n", key, gp.map[key]);
            }
        }

        return StatusValue.SUCCESS;
    }

    public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
    {
    }
}

public class GLibJsonConfNodeContext : apollo.behavioral.NodeContext
{
    public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
    {
        GLibJsonConfNode gp = this.parent as GLibJsonConfNode;

        if(gp != null)
        {
            stdout.printf("Map:\n");
            foreach(string key in gp.map.get_keys())
            {
                stdout.printf("\t[%s] => %s\n", key, gp.map[key]);
            }
        }

        return StatusValue.SUCCESS;
    }

    public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
    {
    }
}
