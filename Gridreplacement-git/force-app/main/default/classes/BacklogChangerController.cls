public class BacklogChangerController{
    
    private static CommonLoggingUtils log = CommonLoggingUtils.getInstance();
    private ApexPages.StandardSetController stdController;
    private static Integer TABLE_PAGE_SIZE = 12;
    public boolean refreshpage {get; set;}
        
    
   
    
    @testVisible private static Boolean doThrowTestExceptions = false;
    @testVisible private static Boolean doPretendDMLErrors = false;
    @testVisible private static Boolean doForceSyncDMLPath1 = false;
    @testVisible private static Boolean doForceSyncDMLPath2 = false;
    @testVisible private static Boolean doForceSyncDMLPath3 = false;
    
    
    public Opportunity Opportunity { get; set; }
    @testVisible private ApexPages.StandardSetController BacklogSetController {
        get {
            if (BacklogSetController == null) {
                BacklogSetController = InitBacklogSetController();
            }
            return BacklogSetController;
        }
        set;
    }
    public List<Backlog__c> getBacklogSet() {
        List<Backlog__c> retObj = new List<Backlog__c>();
        if (BacklogSetController != null) {
            retObj = (List<Backlog__c>)BacklogSetController.getRecords();
            
            
        }
        return retObj;
    }
    public List<Backlog__c> getFullBacklogSet() {
        List<Backlog__c> retObj = new List<Backlog__c>();
        
        if (BacklogSetController != null) {
            Integer initialPageSize = BacklogSetController.getPageSize();
            Integer initialPageNumber = BacklogSetController.getPageNumber();
            
            BacklogSetController.setPageSize(BacklogSetController.getResultSize());
            retObj.addAll((List<Backlog__c>)BacklogSetController.getRecords());
            BacklogSetController.setPageSize(initialPageSize);
            BacklogSetController.setPageNumber(initialPageNumber);
        }
        return retObj;
    }
    public List<Backlog__c> getProtoBacklog() {
        List<Backlog__c> retObj = new List<Backlog__c>();
        if (BacklogSetController != null) {
            retObj.add((Backlog__c)BacklogSetController.getRecord());
        }
        return retObj;
    }
    
    // Constructor
    public BacklogChangerController(ApexPages.StandardSetController stdController) {
        this.stdController = stdController;
        this.Opportunity = InitPageOpportunity();
        this.TopBlockMessageBinder = new PageMessageBinder();
        this.BottomBlockMessageBinder = new PageMessageBinder();
        log.SetAdditionalInfoOverride('On BacklogManager visualforce page for Opportunity Id=' + Opportunity.Id);
        
        
        refreshPage=false;
        
        
    }
    
    // PAGE METHODS
    private Opportunity InitPageOpportunity() {
        
        Id OppId = ApexPages.currentPage().getParameters().get('id');
        Opportunity retObj = [  SELECT
                                    Id
                                    ,Name
                                    ,Amount
                                    ,Current_Contract_Amount__c
                                    ,Unified_Amount_for_Backlog_Spreading__c
                                    ,CloseDate
                                    ,Spread_Fees_Evenly__c
                                    ,Estimated_Duration__c
                                    ,Estimated_Start_Date__c
                                    ,Sales_Credit_Employee_Count__c
                                    ,Actuals_with_Projected__c
                                    ,Account.Name
                                    ,Engagement_Number__c
                                    ,Client_Name__c
                                    ,Engagement_Name__c
                                    ,IsClosed
                                    ,Backlog_Fields_Check__c
                                    ,Backlog_link__c
                                    ,type
                                    
                                FROM Opportunity
                                WHERE Id = :OppId][0];
        return retObj;
    }
    
    private ApexPages.StandardSetController InitBacklogSetController() {
        Database.QueryLocator query = Database.getQueryLocator([SELECT
                                                                    Id
                                                                    ,Name
                                                                    ,Opportunity__c
                                                                    ,Type__c
                                                                    ,Date__c
                                                                    ,Projected_Amount__c
                                                                    ,Actual_Amount__c
                                                                    ,Has_Actuals__c
                                                                                                                            
                                                                FROM Backlog__c 
                                                                WHERE Opportunity__c = :Opportunity.Id
                                                                ORDER BY Date__c asc]);
        
        ApexPages.StandardSetController retObj = new ApexPages.StandardSetController(query);
        retObj.setPageSize(TABLE_PAGE_SIZE);
        return retObj;
    }
    
    private void SaveChanges(List<Backlog__c> backlogs) {
        try {
            if (Test.isRunningTest() && doThrowTestExceptions) { Integer lolmath = 1/0; }
            
            CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseUpsert(backlogs, true);
            if (results.numFail > 0 || (Test.isRunningTest() && doPretendDMLErrors)) {
                BottomBlockMessageBinder.Clear();
                BottomBlockMessageBinder.ShowError('Exception occurred while saving backlogs!', String.join(results.failMessages.values(), '<br/>'));
            } else {
                BottomBlockMessageBinder.Clear();
                BottomBlockMessageBinder.ShowSuccess('Backlogs Saved');
            }
            
        } catch (Exception e) {
            log.LogApexException(e);
            ApexPages.addmessage(CommonLoggingUtils.ConvertExceptionToPageMessage(e));
            
        } finally {
            log.Flush();
        }
    }
    
    // PUBLIC PAGE PROPERTIES -----------------------/
    
    public PageMessageBinder TopBlockMessageBinder { get; set; }
    public PageMessageBinder BottomBlockMessageBinder { get; set; }
    public Integer DateShiftInMonths { get; set; }
    public Boolean RespreadFees { 
        get {
            if (RespreadFees == null) {
                RespreadFees = true;
            }
            return RespreadFees;
        }
        set; 
    }
    
    // SET CONTROLLER EXPOSURE ----------------------------/
    
    // PROPERTIES
    public Boolean HasNext { get { return BacklogSetController.getHasNext(); }}
    public Boolean HasPrev { get { return BacklogSetController.getHasPrevious(); }}
    public Integer PageNum { 
        get { return BacklogSetController.getPageNumber(); }
        set {
            BacklogSetController.setPageNumber(value);
        }
    }
    public Integer PageSize {
        get { return BacklogSetController.getPageSize(); }
        set { 
            BacklogSetController.setPageSize(value);
        }
    }
    public Boolean HasBacklogs { get { return (NumRecs > 0) ? true : false; } }
    public Integer NumRecs { get { return BacklogSetController.getResultSize(); }}
    public String NumRecStr {
        get {
            if (NumRecs == 1) {
                return '1 record';
            } else {
                return NumRecs + ' records';
            }
        }
    }
    public Integer NumPages {
        get {
            Integer numPages = (Math.ceil(((Double)NumRecs / (Double)PageSize))).intValue();
            return numPages;
        }
    }
    public Integer FirstRecOnPage {
        get {
            if (PageNum > 1) {
                return PageSize*(PageNum-1)+1;
            } else {
                return 1;
            }
        }
    }
    public Integer NumRecsOnPage {
        get {
            return BacklogSetController.getRecords().size();
        }
    }
    public Integer LastRecOnPage {
        get {
            return FirstRecOnPage + NumRecsOnPage - 1;
        }
    }
    
    // METHODS
    public void GoToFirst() { BacklogSetController.first(); }
    public void GoToPrevious() { BacklogSetController.previous(); }
    public void GoToNext() { BacklogSetController.next(); }
    public void GoToLast() { BacklogSetController.last(); }
    
    

    // BUTTONS -------------------------------------------/
    
    public System.PageReference DoNothing() {
        return null;
    }
    
    public System.PageReference Regenerate() {

        try {
            if (Test.isRunningTest() && doThrowTestExceptions) { Integer lolmath = 1/0; }
            
            BacklogGeneratorController c = new BacklogGeneratorController();
            Backlog__c[] backlogs = c.GenerateBacklogs(Opportunity);
            
            CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseUpsert(backlogs, true);
            if (results.numFail > 0 || (Test.isRunningTest() && doPretendDMLErrors)) {
                BottomBlockMessageBinder.ShowError('Exception occurred while inserting new backlogs!', String.join(results.failMessages.values(), '<br/>'));
            } else {
                BottomBlockMessageBinder.Clear();
            }
            
        } catch (Exception e) {
            log.LogApexException(e);
            ApexPages.addmessage(CommonLoggingUtils.ConvertExceptionToPageMessage(e));
            
        } finally {
            log.Flush();
        }
        BacklogSetController = null;
        return null;
    }
    
    public System.PageReference DeleteAll() {
        try {
            if (Test.isRunningTest() && doThrowTestExceptions) { Integer lolmath = 1/0; }
            
            CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseDelete(getFullBacklogSet(), true);
            if (results.numFail > 0 || (Test.isRunningTest() && doPretendDMLErrors)) {
                BottomBlockMessageBinder.ShowError('Exception occurred while deleting backlogs!', String.join(results.failMessages.values(), '<br/>'));
            } else {
                BottomBlockMessageBinder.Clear();
            }

        } catch (Exception e) {
            log.LogApexException(e);
            ApexPages.addmessage(CommonLoggingUtils.ConvertExceptionToPageMessage(e));
            
        } finally {
            log.Flush();
        }
        BacklogSetController = null;
        return null;
    }
    
    public System.PageReference SaveChanges() {

        SaveChanges(getBacklogSet());
        BacklogSetController = null;
        return null;    
    }
   
     public System.PageReference updateamount() {
        
        // Set savepoint
        Savepoint sp1 = Database.setSavepoint();
        
        try {
            if (Test.isRunningTest() && doThrowTestExceptions) { Integer lolmath = 1/0; }
            
            // 1. Save updates to opportunity fields
            CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseUpsert(new Opportunity[]{Opportunity}, true);
            if (results.numFail > 0 || (Test.isRunningTest() && doForceSyncDMLPath1)) {
                TopBlockMessageBinder.ShowError('Exception occurred while syncronizing backlogs!', String.join(results.failMessages.values(), '<br/>'));
                return null;
            }}
                catch (Exception e) {
            log.LogApexException(e);
            ApexPages.addmessage(CommonLoggingUtils.ConvertExceptionToPageMessage(e));
            Database.rollback(sp1);}
         finally {
             log.Flush();}
         BacklogSetController = null;
        return null;
    }
    
    public System.PageReference  cancelando(){
        
        Task newTask = new Task(Description = 'Please update backlog of the listed opportunity',
                                        Priority = 'Normal', 
                                        Status = 'Not Started', 
                                        Subject = 'Update Opportunity Backlog', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        ActivityDate = System.today()+5,
                                        WhatID = opportunity.id,
                                        Ownerid = UserInfo.getUserId() 
                                           );             
                insert newTask;
        
        // Set savepoint
        opportunity.Backlog_Fields_Check__c = False;
        Savepoint sp3 = Database.setSavepoint();
        
        
        
        
        try {
            if (Test.isRunningTest() && doThrowTestExceptions) { Integer lolmath = 1/0; }
            
            // 1. Save updates to opportunity fields
            CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseUpsert(new Opportunity[]{Opportunity}, true);
            
            if (results.numFail > 0 || (Test.isRunningTest() && doForceSyncDMLPath1)) {
                TopBlockMessageBinder.ShowError('Exception occurred while syncronizing backlogs!', String.join(results.failMessages.values(), '<br/>'));
                return null;
            }

           
            
            

         

          } catch (Exception e) {
            log.LogApexException(e);
            ApexPages.addmessage(CommonLoggingUtils.ConvertExceptionToPageMessage(e));
            Database.rollback(sp3);
            
        } finally {
            log.Flush();
        }
        BacklogSetController = null;
        refreshPage=true;
        return null;
    }
    
    public System.PageReference SyncronizeNewProjections() {
        
        // Set savepoint
        opportunity.Backlog_Fields_Check__c = False;
        Savepoint sp = Database.setSavepoint();
        
        
        
        
        try {
            if (Test.isRunningTest() && doThrowTestExceptions) { Integer lolmath = 1/0; }
            
            // 1. Save updates to opportunity fields
            CommonDMLUtils.DmlResults results = CommonDMLUtils.SafeDatabaseUpsert(new Opportunity[]{Opportunity}, true);
            
            if (results.numFail > 0 || (Test.isRunningTest() && doForceSyncDMLPath1)) {
                TopBlockMessageBinder.ShowError('Exception occurred while syncronizing backlogs!', String.join(results.failMessages.values(), '<br/>'));
                return null;
            }

            // 2. Get syncronized backlogs
            BacklogGeneratorController c = new BacklogGeneratorController();
            Map<Backlog__c[], Backlog__c[]> syncResults = c.GenerateSyncronizedBacklogs(getFullBacklogSet(), Opportunity, RespreadFees);
            Backlog__c[] toBeUpserted = new List<Backlog__c[]>(syncResults.keySet())[0];
            Backlog__c[] toBeDeleted = syncResults.values()[0];
            
            // 2.5 Perform validation
            for (Backlog__c deletionCandidate : toBeDeleted) {
                if (deletionCandidate.Actual_Amount__c != null) {
                    TopBlockMessageBinder.ShowError('Cannot make update that would result in backlogs with populated Actual Amount fields being deleted');
                    Database.rollback(sp);
                    return null;
                } 
            }

            // 4. Upsert new backlog list
            results = CommonDMLUtils.SafeDatabaseUpsert(toBeUpserted, true);
            if (results.numFail > 0 || (Test.isRunningTest() && doForceSyncDMLPath3)) {
                TopBlockMessageBinder.ShowError('Exception occurred while syncronizing backlogs!', String.join(results.failMessages.values(), '<br/>'));
                Database.rollback(sp);
                return null;
            }

            // 3. Delete existing backlogs that are no longer needed
            results = CommonDMLUtils.SafeDatabaseDelete(toBeDeleted, true);
            if (results.numFail > 0 || (Test.isRunningTest() && doForceSyncDMLPath2)) {
                TopBlockMessageBinder.ShowError('Exception occurred while syncronizing backlogs!', String.join(results.failMessages.values(), '<br/>'));
                Database.rollback(sp);
                return null;
            }
            TopBlockMessageBinder.Clear();
            
        } catch (Exception e) {
            log.LogApexException(e);
            ApexPages.addmessage(CommonLoggingUtils.ConvertExceptionToPageMessage(e));
            Database.rollback(sp);
            
        } finally {
            log.Flush();
        }
        BacklogSetController = null;
        refreshPage=true;
        return null;
    }
    
    
    
    public System.PageReference ApplyMassUpdate() {
                
        if (BacklogSetController != null) {
            Backlog__c proto = (Backlog__c)BacklogSetController.getRecord();
            List<Backlog__c> all = null;
            
            if (proto.Projected_Amount__c != null) {
                all = getFullBacklogSet();
                
                for (Backlog__c record : all) {
                    if (record.Has_Actuals__c == false) {
                        record.Projected_Amount__c = proto.Projected_Amount__c;
                    }
                }
            }
            
            SaveChanges(all);
        }
        BacklogSetController = null;
        return null;
    }
    
    
 
    
    
    // PAGE HELPER CLASSES ----------------------/
    public class PageMessageBinder {
        public String Severity { get; set; }
        public String Title { get; set; }
        public String Message { get; set; }
        public Boolean Show { get; set; }
        
        public void ShowError(String title, String message) {
            ShowError(message);
            this.Title = title;
        }
        public void ShowError(String message) {
            this.Severity = ApexPages.Severity.ERROR.name();
            this.Title = 'Error:';
            this.Message = message;
            this.Show = true;
        }
        public void ShowSuccess(String title, String message) {
            ShowSuccess(message);
            this.Title = title;
        }
        public void ShowSuccess(String message) {
            this.Severity = ApexPages.Severity.CONFIRM.Name();
            this.Title = 'Success:';
            this.Message = message;
            this.Show = true;
        }
        public void Clear() {
            this.Show = false;
        }
    }


}