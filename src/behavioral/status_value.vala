namespace apollo.behavioral
{
    public enum StatusValue
    {
        INVALID,

        SUCCESS,
        FAILURE,
        CALL_DOWN,

        RUNNING,
        FINISHED;

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
