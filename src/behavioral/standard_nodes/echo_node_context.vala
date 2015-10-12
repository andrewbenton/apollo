using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Expand the variables from the blackboard and print the output string.
     */
    public class EchoNodeContext : apollo.behavioral.NodeContext
    {

        /**
         * Create the context for execution.
         */
        public EchoNodeContext()
        {
        }

        /**
         * Expand the variables in the text from values in the blackboard.  No child nodes can be called.
         *
         * @param blackboard Provides variables for text expansion.
         * @param next Unused.
         * @return The status of execution.
         */
        public override StatusValue call(HashMap<string, GLib.Value?> blackboard, out string next)
        {
            EchoNode en = this.parent as EchoNode;

            next = null;

            StringBuilder sb = new StringBuilder();

            unowned string template_text = en.text;
            int last_idx = 0, new_start = 0, new_end = 0;

            while(true)
            {
                last_idx = new_end;
                new_start = template_text.index_of("${", last_idx);
                new_end = template_text.index_of("}", new_start);

                if(new_start > 0 && new_end > 0)
                {
                    string key = template_text[new_start+2:new_end];

                    log_warn("adding: %s\n", template_text[last_idx:new_start]);
                    sb.append(template_text[last_idx:new_start]);

                    //use same behavior as bash where default of key is empty
                    if(blackboard.has_key(key))
                    {
                        log_warn("adding: %s\n", value_to_string(blackboard[key]));
                        sb.append(value_to_string(blackboard[key]));
                    }

                    new_end++;

                    if(new_end == template_text.length)
                        break;
                }
                else
                {
                    log_warn("adding: %s\n", template_text[last_idx:template_text.length]);
                    sb.append(template_text[last_idx:template_text.length]);
                    break;
                }
            }

            stdout.printf("[%s] => %s\n", en.name, sb.str);

            return StatusValue.SUCCESS;
        }

        /**
         * Create a string from a nullable GLib.Value.
         */
        private static string value_to_string(GLib.Value? val)
        {
            if(val == null)
                return "";
            else
            {
                if(Value.type_transformable(val.type(), typeof(string)))
                {
                    GLib.Value tval = GLib.Value(typeof(string));
                    val.transform(ref tval);
                    return tval.dup_string();
                }
                else
                {
                    return "[(GLib.Value)%p]".printf((void*)val);
                }
            }
        }

        /**
         * This function should be unused.  The echo node supports no child nodes.
         */
        public override void send(StatusValue status, HashMap<string, GLib.Value?> blackoard)
        {
            log_err("Reached EchoNodeContext.send() which should not be possible.");
        }
    }
}
