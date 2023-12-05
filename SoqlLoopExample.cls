public class SoqlLoopExample {
    
    
    /*
     * Business Requirement :
     * To be able to update in mass the value of veryLongText__c by adding a text to the existing one
     * methods below will show how apex react and why the instruction below become mandatory (except this type of use case, it's useless)
		for(List<Case> subCases : [SELECT Id,veryLongText__c from Case limit :nbRecords]){
     */
    
    
    /*
     	HOW TO USE : 
		call the method belows ,  change the number of records to test and see how the limit behave.
		below 500 , all methods will work  
		below 1500 , betterMethod and correctMethod will work
		above around 1500 records, only betterMethod will work (it will work even if we had 10 000 records)
		
		SoqlLoopExample.displayChunckSizeOf200Records(300);
		SoqlLoopExample.worseMethod(300);
		SoqlLoopExample.betterMethod(300);
		SoqlLoopExample.correctMethod(300);
	*/
    
    static Integer counter=0;
    // change the value above if you want to display more or less systemDebug for heapSize
    static Integer counterEveryXRecords=50;

    
    
    
    public static void displayChunckSizeOf200Records(Integer nbRecords){
        List<Case> cases = [SELECT Id,veryLongText__c from Case limit :nbRecords];
        displayLimit('memory size for 200 records');
    }
    
    public static void worseMethod(Integer nbRecords){
        List<Case> cases = [SELECT Id,veryLongText__c from Case limit :nbRecords];
        for(Case aCase : cases){
            aCase.veryLongText__c+='test';
            if(counter>counterEveryXRecords){
		        displayLimit('memory during loop execution');
                counter=0;
            }
            counter++;
        }
        // we should update our sobject. Not done to improve performance of the demo
		//update cases;
	    displayLimit('memory after loop execution');
    }
    
    public static void betterMethod(Integer nbRecords){
        List<Case> cases = new List<Case>();
        for(Case aCase : [SELECT Id,veryLongText__c from Case limit :nbRecords]){
            aCase.veryLongText__c+='test';
            cases.add(aCase);
            if(counter>counterEveryXRecords){
		        displayLimit('memory during loop execution');
                counter=0;
            }
            counter++;
        }
        
        displayLimit('memory after loop execution');

        // we should update our sobject. Not done to improve performance of the demo
		// update cases;
    }


    public static void correctMethod(Integer nbRecords){
        for(List<Case> subCases : [SELECT Id,veryLongText__c from Case limit :nbRecords]){
            for(Case aCase : subCases){
	            aCase.veryLongText__c+='test';
                // we should update our sobject. Not done to improve performance of the demo
                // update cases;
            }
	        displayLimit('memory during loop execution');
        }
        displayLimit('memory after loop execution');
    }
    
    public static void createRecords(Integer nbRecords,Integer fieldSize){
        List<Case> cases = new List<Case>();
        for(Integer i=0;i<nbRecords;i++){
            cases.add(new Case(veryLongText__c=generateRandomString(fieldSize,true)));
        }
        insert cases;
    }
    
    static String randStr;
    public static String generateRandomString(Integer len,boolean reuse)
    {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        if(!reuse||randStr==null){
            randStr='';
            while (randStr.length() < len) {
               Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
               randStr += chars.substring(idx, idx+1);
            }
        }
        return randStr; 
    }
    
    
    
    private static void displayLimit(String msg){
        System.debug(msg);
		system.debug(FileSizeToString(Limits.getHeapSize())+'/'+FileSizeToString(Limits.getLimitHeapSize()));
    }
    
    public static String FileSizeToString(Integer Value)
        {
            /* string representation if a file's size, such as 2 KB, 4.1 MB, etc */
            if (Value < 1024)
              return string.valueOf(Value) + ' Bytes';
            else
            if (Value >= 1024 && Value < (1024*1024))
            {
              //KB
              Decimal kb = Decimal.valueOf(Value);
              kb = kb.divide(1024,2);
              return string.valueOf(kb) + ' KB';
            }
            else
            if (Value >= (1024*1024) && Value < (1024*1024*1024))
            {
              //MB
              Decimal mb = Decimal.valueOf(Value);
              mb = mb.divide((1024*1024),2);
              return string.valueOf(mb) + ' MB';
            }
            else
            {
              //GB
              Decimal gb = Decimal.valueOf(Value);
              gb = gb.divide((1024*1024*1024),2);
             
              return string.valueOf(gb) + ' GB';
            }    
        }

}
