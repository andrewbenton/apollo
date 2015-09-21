using Gee;

namespace apollo.behavioral
{
    public class SequenceNodeContext : NodeContext
    {
        private string[] sequence;
        private int idx;
        private bool failed_child;

        public SequenceNodeContext(SequenceNode parent, string[] sequence)
        {
            this.parent = parent;
            this.sequence = sequence;
            this.idx = 0;
            this.failed_child = false;
        }

        public override StatusValue call(out string next)
        {
            if(this.failed_child)
            {
                next = null;
                return StatusValue.FAILURE;
            }

            if(this.idx < this.sequence.length)
            {
                next = this.sequence[this.idx];
                return StatusValue.CALL_DOWN;
            }
            else
            {
                next = null;
                return StatusValue.SUCCESS;
            }
        }

        public override void send(StatusValue status)
        {
            if(status == StatusValue.SUCCESS ||
               status == StatusValue.RUNNING)
                this.idx++;
            else
                this.failed_child = true;
        }
    }
}
