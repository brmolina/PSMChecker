public class TriggerBypass {
	public static Boolean bypass = false;
    
    public static void setDoNotRunTrigger(){
        bypass = true;
    }
    
    public static Boolean doNotBypassTrigger(){
        return !bypass;
    }
}