using Gee;
using Json;
using Lua;

namespace apollo.behavioral
{
    public class LuaNode : apollo.behavioral.Node
    {
        public string script { get; protected set; }

        public LinkedList<string> load_list { get; protected set; }

        //use direct hash and direct equal
        public LuaNode()
        {
            this.script == "";
            this.load_list = new LinkedList<string>();
        }

        public override bool validate(BehavioralTreeSet bts)
        {
            if(script == null)
                return false;
            if(script.strip() == "")
                return false;

            LuaVM tmpvm = new LuaVM();

            int rc = tmpvm.load_string(this.script);

            if(rc != LuaVMStatus.OK)
                return false;

            return true;
        }

        public override NodeContext create_context() throws BehavioralTreeError
        {
            LuaNodeContext lnc = new LuaNodeContext();
            lnc.own(this);
            return lnc;
        }
    }
}
