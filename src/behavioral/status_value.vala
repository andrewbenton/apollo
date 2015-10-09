namespace apollo.behavioral
{
    /**
     * The return value from the execution of a node or the tree.
     *
     * author: Andrew Benton
     */
    public enum StatusValue
    {
        /**
         * The indicated node is not a valid node
         */
        INVALID,

        /**
         * The execution of the node or tree was successful
         */
        SUCCESS,
        /**
         * The node or tree failed in execution
         */
        FAILURE,
        /**
         * The previously executed node requires the creation of a child node
         */
        CALL_DOWN,

        /**
         * The behavioral tree or node require further run calls to finish
         */
        RUNNING,
        /**
         * The behavioral tree has completed execution
         */
        FINISHED;

        /**
         * Create the string representation of the status enum.
         *
         * @return representation of the enum value
         */
        public string to_string()
        {
            switch(this)
            {
                case StatusValue.INVALID:   return "INVALID";
                case StatusValue.SUCCESS:   return "SUCCESS";
                case StatusValue.FAILURE:   return "FAILURE";
                case StatusValue.CALL_DOWN: return "CALL_DOWN";
                case StatusValue.RUNNING:   return "RUNNING";
                case StatusValue.FINISHED:  return "FINISHED";
                default:                    return "<UNKNOWN>";
            }
        }
    }
}
