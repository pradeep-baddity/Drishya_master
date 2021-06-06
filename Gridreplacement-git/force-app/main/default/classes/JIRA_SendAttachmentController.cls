public class JIRA_SendAttachmentController {
    
     
     public static void sendEmailonAttachment(set<id> setParentId)
    {
        Messaging.SingleEmailMessage message;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        List<Messaging.Emailfileattachment> fileAttachments = new    List<Messaging.Emailfileattachment>();   
        List<id> ContentDocumentids =new List<id>();
        List<id> casecreator_id= new List<id>();
        List<String> casecreatorEmail= new List<String>();
        //System.debug('casecreatorEmail--->'+casecreatorEmail[0]);
       //  id loggedownerid=UserInfo.getUserID();
          Id profileId=userinfo.getProfileId();
         if(profileId=='00eU0000000eA2b')
         {
             System.debug('Profile id----->'+profileId);
             List<EntitySubscription> casecreator_List=  [ SELECT id,CreatedById,ParentId FROM EntitySubscription where  ParentId IN :setParentId];
           //  for(EntitySubscription casecreator_itr : casecreator_List )
           //  {
             //}
         }
               /* List<user> casecreatoremail_list=    [select id,email from user where id in : casecreator_id];
        for(user casecreatoremail_itr : casecreatoremail_list)
        {
            casecreatorEmail.add(casecreatoremail_itr.email);
        }   */
        List<case>   lCase=  [SELECT Id,Jira_Additional_Email__c,Account.Name,Contact.Name,ContactId,CaseNumber,Subject,LastModifiedBy.Name,status,jira_Severity__c,Description,Created_By_Full_Name__c,Owner.Name FROM Case WHERE Id IN: setParentId];
        List<ContentDocumentLink> caseasattachments= [SELECT ContentDocument.CreatedDate,ContentDocumentId,Id,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE LinkedEntityId = :setParentId];
        System.debug('caseasattachments---->'+caseasattachments);
      //  Map<Id, DateTime> mapRecodToNoteCreatedDate = new Map<Id, DateTime> ();
   List<ContentDocumentLink>  cdl=  [SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId ='5006s000003xwCDAAY' ];
     System.debug('cdl----->'+cdl);
        System.debug('cdl date 1------>'+cdl[0].ContentDocument.createdDate);
         System.debug('cdl date 2------>'+cdl[1].ContentDocument.createdDate);
          System.debug('cdl date 3------>'+cdl[2].ContentDocument.createdDate);
              for(ContentDocumentLink itr_case_attach :caseasattachments)
        {
         
            ContentDocumentids.add(itr_case_attach.ContentDocumentId);
        }
        
        for(ContentVersion cversion : [SELECT title,PathOnClient, ContentDocument.CreatedDate, FileType,versiondata FROM contentversion WHERE ContentDocumentId IN :ContentDocumentids])
        {
            System.debug('cversion--created date-->'+cversion.ContentDocument.CreatedDate);
              System.debug('is this executing');
              blob Attbody = cversion.versiondata;
              system.debug('body : '+Attbody+'-----------'+cversion.title);
              system.Debug('PathOnClient------'+cversion.PathOnClient);
			  Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
              //efa.setContentType('application/vnd.ms-excel');
              //efa.setFileName('ele_app.xlsx');
            
			 efa.setFileName(cversion.title+'.'+cversion.FileType);
               System.debug('File Type------> '+cversion.FileType);
                   
              
			  efa.setBody(Attbody);
			  fileAttachments.add(efa); 
              //message.setFileAttachments(fileAttachments);
        } 
        
        
        for(case tCase : lCase)
        {
               if(String.isBlank(tCase.Jira_Additional_Email__c))
                continue;
               
                string plainTextBody = tCase.casenumber+' has been updated with the following attachment(s): '+'\n\n'
                    +'Company:'+tCase.Account.Name +'\n'
                    +'Contact Name:'+tCase.Contact.Name +'\n'
                    +'Case Number:'+tCase.casenumber +'\n'
                    +'Created by:'+tCase.Created_By_Full_Name__c+'\n'
                    +'Case Owner:'+tCase.Owner.Name+'\n'
                    +'Subject:'+tCase.Subject+'\n'
                    +'Status:'+tCase.Status+'\n'
                    +'Severity:'+tCase.jira_Severity__c+'\n'
                    +'Description:'+tCase.Description+'\n';
                message = new Messaging.SingleEmailMessage();
                message.toAddresses= tCase.Jira_Additional_Email__c.split(',');
               // message.toAddresses=casecreatorEmail;
                System.debug('==>'+ message.toAddresses);
                message.subject = ' Case Attachment(s): ' + ' ' + '['+ tCase.CaseNumber + ']' + '['+tCase.Subject+']';
                message.setPlainTextBody(plainTextBody);
                System.debug('File Attachments---->'+fileAttachments);
               message.setFileAttachments(fileAttachments);
                messages.add(message);
         }
        if(!messages.isEmpty())
        {
          Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
          System.debug('Email Sent Result ==>'+ results);
        }
  }
  
}