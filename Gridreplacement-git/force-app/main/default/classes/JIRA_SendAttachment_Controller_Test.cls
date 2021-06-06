/**
Class Name   : JIRA_SendAttachment_Controller_Test
@Description : when ever an new attachment is created ,send an email to case followers along with the attachment.
Created By   : Pradeep Baddity. 
Created On   : 11/09/2020
============================================================================================================
Story         Changed By             Date                     Desc
============================================================================================================
18154           -                   11/09/2020                sending Attachment

============================================================================================================
*/
@istest(seealldata=false)
public class JIRA_SendAttachment_Controller_Test {
@TestVisible static Messaging.SingleEmailMessage Message = new Messaging.SingleEmailMessage();
 public static  testmethod void testMethod1()
    {
        set<id> ids =new set<id>();
        Case c = new Case();
        C.Status = 'New';
        C.Origin = 'Phone';
         C.Jira_Additional_Email__c='abc@gmail.com,xyz@gmail.com';
        insert c;
        ids.add(c.id);
        
        JIRA_SendAttachmentController.sendEmailonAttachment(ids);
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=c.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
    Attachment  attachData = new Attachment();
          attachData.Name='Unit Test Attachment'; 
    Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body'); 
    attachData.body=bodyBlob1; 
        attachData.parentId=c.id;
        attachData.IsPrivate=false;
        insert attachdata;
    }
    static public void sendEmail() {
    message.setTargetObjectId(UserInfo.getUserId());
    message.setSaveAsActivity(false);
    message.setSubject('dear diary');
    message.setPlainTextBody('he who controls the spice');
    Messaging.sendEmail(new List<Messaging.Email>{Message});
}
 
}