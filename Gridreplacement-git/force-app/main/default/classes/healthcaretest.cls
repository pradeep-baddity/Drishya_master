@Istest
public class healthcaretest {
       	public static Opportunity newOpp{set; get;}
        public static Opportunity newOpp1{set; get;}
        public static void insertrecords(){
        
                       Account acc = new Account();
                       acc.Name = 'Test Account';
                       //acc.CurrencyIsoCode ='USD - U.S.Dollar';
                       insert acc;
                       system.debug('Account -->'+acc);
           
          			   newOpp                              = new Opportunity();
                       newOpp.recordtypeid                 = '012U0000000Mdat';
                       newOpp.Name                         = 'Test HC record' ;
                       newOpp.AccountId                    = acc.id;
                       newOpp.Healthcare_Solutions2__c     = 'Healthcare-IT Services :1458' ;
                       newOpp.Healthcare_Solutions__c      = 'Advisory – Lawson';
                       newOpp.Type                         = 'Extension Opportunity';
                       newOpp.Estimated_Duration__c        = 2;
                       newOpp.AutoCreateRenewal__c         = false;
                       newOpp.StageName                    = 'Exploration (0% - 39%)';
                       newOpp.Probability                  = 10;
                       //date newDate                        = (opp.closeDate).addMonths((Integer)opp.Estimated_Duration__c);
                       newOpp.CloseDate                    = system.today()+5 ;
                       newOpp.Amount                       = 700000; 
                       newOpp.LeadSource                   = 'Marketing Campaign / Sales Initiative';
                       insert newOpp;
           				newOpp.AutoCreateRenewal__c = true;
          				update newOpp;
           
					   newOpp1                              = new Opportunity();
                       newOpp1.recordtypeid                 = '012U0000000Mdat';
                       newOpp1.Name                         = 'Test HC record - Auto Extension' ;
                       newOpp1.AccountId                    = newOpp.AccountId;
                       newOpp1.Healthcare_Solutions2__c     = newOpp.Healthcare_Solutions2__c ;
                       newOpp1.Healthcare_Solutions__c      = newOpp.Healthcare_Solutions__c;
                       newOpp1.type                         = 'Extension Opportunity';
                       newOpp1.Estimated_Duration__c        = newOpp.Estimated_Duration__c;
                       newOpp1.AutoCreateRenewal__c         = false;
                       newOpp1.StageName                    = 'Exploration (0% - 39%)';
                       newOpp1.Probability                  = 10;
                       date newDate                         = (newOpp.closeDate).addMonths((Integer)newOpp.Estimated_Duration__c);
                       newOpp1.CloseDate                    = newDate ;
                       date newDate1                        = (newOpp.closeDate).addMonths((Integer)newOpp.Estimated_Duration__c);
                       newOpp1.Effective_Date__c            = newDate1 ;
                       date newDate2                        = (newOpp1.Effective_Date__c).addMonths((Integer)newOpp.Estimated_Duration__c);
                       newOpp1.AddOnUpSaleEndDate__c        = newDate2 ;
                       newOpp1.Amount                       = newOpp.Amount; 
                       newOpp1.LeadSource                   = newOpp.LeadSource;
						insert newOpp1;
        }
        
        Public static testmethod void insertrecordsnew(){
        insertrecords();
        }
        
        

}