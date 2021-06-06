/**
Class Name   : JIRA_SendAttachment
@Description : when ever an new attachment is created ,send an email to case followers along with the attachment.
Created By   : Pradeep Baddity. 
Created On   : 09/09/2020
============================================================================================================
Story         Changed By             Date                     Desc
============================================================================================================
18154           -                   09/09/2020             Initial creation

============================================================================================================
*/

trigger JIRA_SendAttachment on ContentDocumentLink (after insert)
{
   String tempParentId;
   Set<Id> setParentId = new Set<Id>();
  
 for (ContentDocumentLink cdl : trigger.new ) 
 {
      tempParentId = cdl.LinkedEntityId;
	        	if (tempParentId.left(3) =='500')
                {
				   setParentId.add(cdl.LinkedEntityId);
                    System.debug('=======>'+cdl.ContentDocument.CreatedDate);
                     
			    }
 }
 if(setParentId.size()>0)
  {
     JIRA_SendAttachmentController.sendEmailonAttachment(setParentId);
  }    
  
}