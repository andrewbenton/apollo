using Gee;
using Json;
using Lua;

namespace apollo.behavioral
{
    public class LuaNodeContext : apollo.behavioral.NodeContext
    {
        public const string LUA_BLACKBOARD_KEY = "_LUA_VM";

        private static GLib.Type TYPE_BOOL = typeof(bool);
        private static GLib.Type TYPE_INT8 = typeof(int8);
        private static GLib.Type TYPE_UINT8 = typeof(uint8);
        private static GLib.Type TYPE_UCHAR = typeof(uchar);
        private static GLib.Type TYPE_INT = typeof(int);
        private static GLib.Type TYPE_UINT = typeof(uint);
        private static GLib.Type TYPE_INT64 = typeof(int64);
        private static GLib.Type TYPE_UINT64 = typeof(uint64);
        private static GLib.Type TYPE_LONG = typeof(long);
        private static GLib.Type TYPE_ULONG = typeof(ulong);
        private static GLib.Type TYPE_FLOAT = typeof(float);
        private static GLib.Type TYPE_DOUBLE = typeof(double);
        private static GLib.Type TYPE_STRING = typeof(string);
        private static GLib.Type TYPE_POINTER = typeof(void*);

        public LuaNodeContext()
        {
        }

        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            next = null;
            LuaNode lp = this.parent as LuaNode;

            if(!blackboard.has_key(LUA_BLACKBOARD_KEY))
                return StatusValue.FAILURE;

            GLib.Value? val = blackboard[LUA_BLACKBOARD_KEY];

            if(val == null)
                return StatusValue.FAILURE;

            unowned string script = lp.script;

            if(val.type() != typeof(LuaVM))
                return StatusValue.FAILURE;

            unowned LuaVM vm = (LuaVM)val.peek_pointer();

            vm.new_table();

            foreach(string key in lp.load_list)
            {
                log_info("Attepting to load key[%s]\n", key);
                vm.push_string(key);
                if(blackboard.has_key(key))
                {
                    val = blackboard[key];

                    if(val == null)
                    {
                        vm.push_nil();
                    }
                    else
                    {
                        log_info("blackboard[%s].type() = %s\n", key, blackboard[key].type().name());
                             if(val.type() == TYPE_BOOL)
                            vm.push_boolean((int)val.get_boolean());
                        else if(val.type() == TYPE_UINT8)
                            vm.push_string((string)(new uint8[2] { val.get_schar(), '\0' }));
                        else if(val.type() == TYPE_INT8)
                            vm.push_integer((int)val.get_schar());
                        else if(val.type() == TYPE_UCHAR)
                            vm.push_string((string)(new uint8[2] { val.get_uchar(), '\0' }));
                        else if(val.type() == TYPE_INT)
                            vm.push_integer(val.get_int());
                        else if(val.type() == TYPE_UINT)
                            vm.push_number((double)val.get_uint());
                        else if(val.type() == TYPE_LONG)
                            vm.push_number((double)val.get_long());
                        else if(val.type() == TYPE_ULONG)
                            vm.push_number((double)val.get_ulong());
                        else if(val.type() == TYPE_INT64)
                            vm.push_number((double)val.get_int64());
                        else if(val.type() == TYPE_UINT64)
                            vm.push_number((double)val.get_uint64());
                        else if(val.type() == TYPE_FLOAT)
                            vm.push_number((double)val.get_float());
                        else if(val.type() == TYPE_DOUBLE)
                            vm.push_number(val.get_double());
                        else if(val.type().is_object())
                            vm.push_lightuserdata(val.get_pointer());
                        else if(val.type() == TYPE_STRING)
                            vm.push_string(val.dup_string());
                        else if(val.type() == TYPE_POINTER && val.fits_pointer())
                            vm.push_lightuserdata(val.get_pointer());
                        else
                            vm.push_nil();
                    }
                }
                else
                {
                    log_warn("Desired key to load, %s, is not set.\n", key);
                    vm.push_nil();
                }
                vm.raw_set(-3);
            }

            vm.set_global("blackboard");

            if(!vm.do_string(script))
                return StatusValue.SUCCESS;

            return StatusValue.FAILURE;
        }

        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackboard)
        {
            //this shouldn't be called
        }
    }
}
