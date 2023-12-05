# SoqlForLoop

The test should be run on a new sandbox/scratchorg as it will consume a lot of the storage available :)


Step 1: 

Create a field for the object Case :
type richtext
length 130 000
name : VeryLongText


Step 2 :
Launch the command line below 3 times (can not be done at once , cpu limit issue) :
// create 1000 case records and store a 50000 caracters text in the VeryLongText__c field
SoqlLoopExample.createRecords(1000,50000);

Testing and using the demo :

you can run the following method , arguments is always the number of records to process in the query : 

// will show how quickly apex is consuming memory when executing soql query
SoqlLoopExample.displayChunckSizeOf200Records(300);

// will show why this type of algorythm should never be used if possible. works while above an average 400 records
SoqlLoopExample.worseMethod(300);

// will show the limit of this algorythm (still the one to prefer 99% of the time) . works while above an average 1400 records
SoqlLoopExample.worseMethod(300);

// Show the only use case where the "for(List<Case> subCases : [SELECT Id,veryLongText__c from Case limit :nbRecords]){" is really useful. You can put 5000 == all records, the method will run
SoqlLoopExample.correctMethod(300);

