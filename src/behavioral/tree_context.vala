using Gee;

namespace apollo.behavioral
{
    public class TreeContext
    {
        public LinkedList<NodeContext> stack;
        public string root;
        public BehavioralTreeSet bts;
        public uint max_iters { get; set; }
        public StatusValue status { get; private set; }

        internal TreeContext(BehavioralTreeSet bts, string root, uint max_iters = 1)
        {
            if(max_iters < 1)
                max_iters = 1;

            this.stack = new LinkedList<NodeContext>();
            this.root = root;
            this.bts = bts;
            this.max_iters = max_iters;
            this.status = StatusValue.FINISHED;
        }

        public StatusValue run()
        {
            //if the stack is emtpy, start over
            if(this.stack.size < 1)
            {
                this.stack.offer_head(bts[root].create_context());
            }

            int i = 0;
            NodeContext nc = null;
            StatusValue status = StatusValue.INVALID;
            string next = null;
            Node n = null;

            //run while there is a context to process and you have not exceeded your limit
            while(
                    this.stack.size > 0 &&
                    (i++ < this.max_iters || this.max_iters < 1)
                 )
            {
                nc = this.stack.peek_head();

                status = nc.call(out next);

                this.status = status;

                switch(status)
                {
                    case StatusValue.SUCCESS:
                    case StatusValue.FAILURE:
                        this.stack.poll_head();
                        if(this.stack.size > 0)
                        {
                            this.stack.peek_head().send(status);
                        }
                        else
                        {
                            return status;
                        }
                        break;
                    case StatusValue.RUNNING:
                        return status;
                    case StatusValue.CALL_DOWN:
                        n = this.bts[next];
                        assert(n != null);
                        this.stack.offer_head(n.create_context());
                        break;
                }
            }

            if(this.stack.size < 1)
                this.status = StatusValue.FINISHED;
            else
                this.status = StatusValue.RUNNING;
            return StatusValue.RUNNING;
        }
    }
}
