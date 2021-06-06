public class BacklogGeneratorController{
	
	private static CommonLoggingUtils log = CommonLoggingUtils.getInstance();
	@testVisible private static Boolean throwTestExceptions = false;
	
	public Opportunity opp { get; set; }
	
	// Constructor for visualforce page
	public BacklogGeneratorController(ApexPages.StandardSetController stdController) {
		
		String oppId = ApexPages.currentPage().getParameters().get('id');
		opp = QueryOpportunity(oppId);
		
	}
	// Constructor for other apex classes
	public BacklogGeneratorController() {}
	
	
	public Opportunity QueryOpportunity(Id oppId) {
		Opportunity retObj = null;
		retObj = [	SELECT 
						Id
						,Name
						,Estimated_Start_Date__c
						,Estimated_Duration__c
						,Unified_Amount_for_Backlog_Spreading__c
						,Spread_Fees_Evenly__c
                  		,CloseDate
                  		
					FROM Opportunity WHERE Id = :oppId][0];
		return retObj;
	}
	
	// HELPER METHODS -----------------------------/
	private Date getStartDate(Opportunity o) {
		 if (o.Estimated_Start_Date__c != null){
            return getStartDate(o.Estimated_Start_Date__c);}
            else {
                return getstartdate(o.CloseDate);
            }
	}
	@testVisible private Date getStartDate(Date oppEstimatedStartDate) {
		Date retObj = Date.today().toStartOfMonth();
		
		if (oppEstimatedStartDate != null) {
			retObj = oppEstimatedStartDate.toStartOfMonth();
		}
		return retObj;
	}
	private List<Date> getDateList(Opportunity o) {
		Date startDate = getStartDate(o);
		Integer duration = (o.Estimated_Duration__c != null) ? o.Estimated_Duration__c.intValue() : 0;
		
		return getDateList(startDate, duration);
	}
	@testVisible private List<Date> getDateList(Date startDate, Integer estDuration) {
		List<Date> retObj = new List<Date>();
		retObj.add(startDate);
				
		if (estDuration != null && estDuration >= 1) {
			for (Integer i = 1; i < estDuration; i++) {
				Date next = startDate.addMonths(i);
				retObj.add(next);
			}
		}
            
		return retObj;
	}
	
	// Validates if backlogs are able to be generated per business requirements
	public ValidationResult ValidateGeneratable(Opportunity o) {
		ValidationResult retObj = new ValidationResult();
		retObj.IsValid = true;
		
		if (!VerifyNoExistingBacklogs(o)) {
			retObj.IsValid = false;
			retObj.ReasonMsg = 'Cannot create new backlog because one already exists!';
			
		}

		return retObj;
	}
		
	public Boolean VerifyNoExistingBacklogs(Opportunity o) {
		Integer count = [	SELECT 
								COUNT()
							FROM Backlog__c
							WHERE Opportunity__c = :o.Id];

		if (count == 0) {
			return true;
		} 
		return false;
	}
	
	// MAIN METHODS ----------------------------------/
	public Backlog__c[] GenerateBacklogs(Id oppId) {
		Opportunity opp = QueryOpportunity(oppId);
		return GenerateBacklogs(opp);
	}
	public Backlog__c[] GenerateBacklogs(Opportunity o) {
		Backlog__c[] retObj = new Backlog__c[]{};
		
		List<Date> dates = getDateList(o);
		for (Integer i = 0; i < dates.size(); i++) {
			Backlog__c bl = new Backlog__c();
			bl.Name 			= Datetime.newInstance(dates.get(i), Time.newInstance(12,0,0,0)).format('MMMM yyyy');
			bl.Opportunity__c 	= o.Id;
			bl.Date__c 			= dates.get(i);

			if (o.Spread_Fees_Evenly__c) {
				bl.Projected_Amount__c =  ((decimal)o.Unified_Amount_for_Backlog_Spreading__c / (decimal)dates.size()).setScale(2);
			}
			retObj.add(bl);
		}
		
		return retObj;
	}
	
	// Returns a map where keys need to be upserted and values need to be purged
	public Map<Backlog__c[], Backlog__c[]> GenerateSyncronizedBacklogs(Backlog__c[] existingBacklogs, Opportunity o, Boolean respreadFees) {
		Map<Backlog__c[], Backlog__c[]> retObj = new Map<Backlog__c[], Backlog__c[]>();
		Backlog__c[] upsertArray = new Backlog__c[]{};
		Backlog__c[] deletionArray = new Backlog__c[]{};

		// Compare new list with old list, keeping the ones from the old list that have the same date
		Map<Date, Backlog__c> oldMap = new Map<Date, Backlog__c>();
		for (Backlog__c oldBL : existingBacklogs) {
			oldMap.put(oldBL.Date__c, oldBL);
		}
		
		Backlog__c[] newBacklogList = GenerateBacklogs(o);
		Map<Date, Backlog__c> newMap = new Map<Date, Backlog__c>();
		for (Backlog__c newBL : newBacklogList) {
			// Ignore projected amounts
			newBL.Projected_Amount__c = null;
			newMap.put(newBL.Date__c, newBL);
		}
		
		// Build upsert list
		Decimal numWithoutActuals = 0;
		for (Date newDate : newMap.keySet()) {
			if (oldMap.containsKey(newDate)) {
				Backlog__c oldBL = oldMap.get(newDate);
				
				if (!oldBL.Has_Actuals__c) { numWithoutActuals++; }
				upsertArray.add(oldBL);
				
				System.debug(CommonConstants.DEBUG_PREFIX + 'Old backlog ' + newDate + ' is being added to upsert array');
			} else {
				Backlog__c newBL = newMap.get(newDate);
				
				if (!newBL.Has_Actuals__c) { numWithoutActuals++; }
				upsertArray.add(newBL);
				
				System.debug(CommonConstants.DEBUG_PREFIX + 'New backlog ' + newDate + ' is being added to upsert array');
			}
		}
		
		// Recalculate projected amount if desired
		if (respreadFees) {
			
			Decimal sumActuals = 0;
			for (Backlog__c bl : upsertArray) {
				if (bl.Has_Actuals__c) sumActuals += bl.Actual_Amount__c;
			}
			
			for (Backlog__c bl : upsertArray) {
				if (bl.Has_Actuals__c == false) {
					bl.Projected_Amount__c = ((Decimal)(o.Unified_Amount_for_Backlog_Spreading__c-sumActuals) / numWithoutActuals).setScale(2);
				}
			}
		}
		
		// Build deletion list
		for (Date oldDate : oldMap.keySet()) {
			if (!newMap.containsKey(oldDate)) {
				deletionArray.add(oldMap.get(oldDate));
				System.debug(CommonConstants.DEBUG_PREFIX + 'Old backlog ' + oldDate + ' is being added to deletion array');
			}
		}
		
		retObj.put(upsertArray, deletionArray);
		return retObj;
	}
	
	// PAGE ACTIONS ------------------------------/
	public PageReference GoBack() {
		
		PageReference pg = new ApexPages.StandardController(opp).view();
        pg.setRedirect(true);
        return pg;
	}
	
	public PageReference GoToBacklogManager() {
		
		PageReference pg = Page.BacklogManager;
		pg.getParameters().put('id',opp.Id);
		pg.setRedirect(true);
		return pg;
	}
	
	public PageReference InsertNewBacklogsAndRedirect(){
		
		try {
			if (Test.isRunningTest() && throwTestExceptions) {
				Integer lolmath = 1/0;
			}
			
			// Validate
			ValidationResult vr = ValidateGeneratable(opp);
			if (!vr.IsValid) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, vr.ReasonMsg));
				return null;
			}
			
			Backlog__c[] newBacklogs = GenerateBacklogs(opp);
			insert newBacklogs;
			
			PageReference pg = Page.BacklogManager;
			pg.getParameters().put('id',opp.Id);
			pg.setRedirect(true);
			return pg;
			
		} catch (Exception e) {
			log.LogApexException(e, 'On BacklogGenerator visualforce page for Opportunity Id=' + opp.Id);
			ApexPages.addmessage(CommonLoggingUtils.ConvertExceptionToPageMessage(e));
			
			return null;
			
		} finally {
			log.Flush();
		}
		
	}
	
	// Return object for the ValidateConditions validation method
	public class ValidationResult {
		public Boolean IsValid { get; set; }
		public String ReasonMsg { get; set; }
	}
}