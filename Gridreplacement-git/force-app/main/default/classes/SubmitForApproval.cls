public with sharing class SubmitForApproval {    
    public PageReference submit() {
        // the record ids will be passed as a comma-separated list into the "id" parameter
        String idsString = ApexPages.currentPage().getParameters().get('id'); 
        if (String.isNotEmpty(idsString)) {
            List<Id> ids = (List<Id>)idsString.split(',');
            
            for (Id recordId : ids) try {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(recordId);
                Approval.ProcessResult result = Approval.process(req);
            }
            
            catch(DmlException e) {System.debug('The following exception has occurred: ' + e.getMessage());
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your Sales Credit must include a Discovery and a Sales team role. Discovery roll-up must be less than or equal to 100%. Sales Team roll-up must equal 0% or 100-200%. For the EDU practice Signer must equal 100%.'));
                                  return null;}

        }
        
        // TODO add an apex success message which will be surfaced on the VF page
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Submitted Successfully.Thank you!'));
        return null;
    }
}