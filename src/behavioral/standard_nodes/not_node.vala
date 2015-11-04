using Gee;
using Json;

namespace apollo.behavioral
{

    /**
     * Invert the success status of the child node.
     */
    public class NotNode : apollo.behavioral.Node
    {
        /**
         * The name of the child node that will be run.
         */
        public string child { get; protected set; }

        /**
         * Create the not node.
         */
        public NotNode()
        {
            this.init();
        }

        public override void init()
        {
            this.name = "";
            this.child = "";
        }

        /**
         * Create the context for the NotNode.
         *
         * @return {@link NotNodeContext} to be used on the stack.
         * @throws BehavioralTreeError Could be thrown in creation of the NotNodeContext, but unlikely.
         */
        public override NodeContext create_context() throws BehavioralTreeError
        {
            NotNodeContext nnc = new NotNodeContext();
            nnc.own(this);
            return nnc;
        }
    }
}
