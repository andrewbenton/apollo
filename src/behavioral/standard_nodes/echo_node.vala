using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Evaluates the text and echos out the evaluated string.
     */
    public class EchoNode : apollo.behavioral.Node
    {
        /**
         * Text to be evaluated.
         */
        public string text { get; protected set; }

        /**
         * Create a new echo node.
         */
        public EchoNode()
        {
            this.text = "";
        }

        /**
         * Validate the node based off of the format string.
         *
         * @param bts Behavioral tree set that will be used for evaluation.
         * @return Validity of the configured node
         */
        public override bool validate(BehavioralTreeSet bts)
        {
            return this.text != null && this.text != "";
        }

        /**
         * Create context from the echo node.
         *
         * @return {@link NodeContext} to be used on the stack.
         * @throws BehavioralTreeError Could be thrown in creation of the EchoNodeContext
         */
        public override NodeContext create_context() throws BehavioralTreeError
        {
            EchoNodeContext enc = new EchoNodeContext();
            enc.own(this);
            return enc;
        }
    }
}
