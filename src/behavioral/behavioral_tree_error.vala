namespace apollo.behavioral
{

    /**
     * Indicates an error within the creation or use of the apollo behavioral tree.
     *
     * Author: Andrew Benton
     */
    public errordomain BehavioralTreeError
    {
        /**
         * The error that occured does not have a proper classification.
         */
        UNKNOWN,
        /**
         * The attempted tree does not exist in the tree context.
         */
        NO_SUCH_TREE,
        /**
         * During node configuration loading, a necessary property was missing or improperly formatted.
         */
        MISSING_OR_MALFORMED_PROPERTY
    }
}
