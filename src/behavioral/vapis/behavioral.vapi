namespace apollo.behavioral
{
    [PrintfFormat]
    [CCode(cheader_filename="behavioral_utils.h", cname="log_fubar")]
    public void log_fubar(string fmt, ...);

    [PrintfFormat]
    [CCode(cheader_filename="behavioral_utils.h", cname="log_err")]
    public void log_err(string fmt, ...);

    [PrintfFormat]
    [CCode(cheader_filename="behavioral_utils.h", cname="log_warn")]
    public void log_warn(string fmt, ...);

    [PrintfFormat]
    [CCode(cheader_filename="behavioral_utils.h", cname="log_info")]
    public void log_info(string fmt, ...);

    [CCode(cheader_filename="behavioral_utils.h", cname="HAS_COLOR")]
    public const bool HAS_COLOR;

    public class Colors
    {
        [CCode(cheader_filename="behavioral_utils.h", cname="MAGENTA")]
        public const string MAGENTA;
        [CCode(cheader_filename="behavioral_utils.h", cname="ORANGE")]
        public const string ORANGE;
        [CCode(cheader_filename="behavioral_utils.h", cname="GREEN")]
        public const string GREEN;
        [CCode(cheader_filename="behavioral_utils.h", cname="BLUE")]
        public const string BLUE;
        [CCode(cheader_filename="behavioral_utils.h", cname="PURPLE")]
        public const string PURPLE;
        [CCode(cheader_filename="behavioral_utils.h", cname="WHITE")]
        public const string WHITE;
        [CCode(cheader_filename="behavioral_utils.h", cname="RESET")]
        public const string RESET;
    }
}
