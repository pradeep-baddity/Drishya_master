@isTest
    public class ProductMapAssignment_TestClass {

        @isTest public static void autoMapProductTest() {
            
            List<OpportunityLineItem> oplList = new List<OpportunityLineItem>();
            List<OpportunityLineItem> opListNew = new List<OpportunityLineItem>();
            list<MetadataLoader__c> offmap = new list<MetadataLoader__c>();
            
            Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Healthcare Opportunities').getRecordTypeId();
           
            user u = [select id from user where id = '0050B000007vgOS'];
            system.runas(u){

            Account acc =  new Account();
            acc.Name = 'Test Acc';
            //acc.EBLModel__c = 'Acute';
            //acc.Industry = 'Healthcare';
            Insert acc;
            
            Account acc1 =  new Account();
            acc1.Name = 'Test Acc';
            //acc.EBLModel__c = 'Acute';
            acc1.Industry = 'Healthcare';
            Insert acc1;
            
            Id pricebookId = Test.getStandardPricebookId();
            system.debug('pricebookId -->'+pricebookId);
            
            Pricebook2 pb2 = new Pricebook2();
            pb2.name = 'Business A Price Book';
            pb2.IsActive = true;
            insert pb2;
            
            Product2 svc2 = new Product2();
            svc2.name = 'Analytics - Core';
            svc2.IsActive = true;
            svc2.CanUseRevenueSchedule = true;
            insert svc2;
            
            //*Standard pricebook entry
            PricebookEntry pbe2 = new PricebookEntry();
            pbe2.Pricebook2Id = Test.getStandardPricebookId(); 
            pbe2.Product2Id = svc2.id;
            pbe2.UnitPrice = 1;
            pbe2.CurrencyIsoCode  = 'USD';
            pbe2.IsActive = true;
            insert pbe2;
            
            PricebookEntry pbe3 = new PricebookEntry();
            //*Standard forecasting pricebook entry
            pbe3.Pricebook2Id = pb2.id;
            pbe3.Product2Id = svc2.id;
            pbe3.IsActive = true;
            pbe3.CurrencyIsoCode  = 'USD';
            pbe3.UnitPrice = 1;
            insert pbe3;
            
            Opportunity opp = new Opportunity ();
            opp.Name = 'test opp';
            opp.AccountId = acc.Id;
            opp.Amount = 1234;
            opp.StageName = 'Prospect (0-14%)';
            opp.Probability = 0.5;
            opp.CloseDate = System.today()+11;
            Insert opp;
            opp.Name = 'test oppty';
            Id recTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' And Name='Healthcare Software'].Id;
            opp.RecordTypeId = recTypeId;
            Update opp;
            
            Opportunity opp1 = new Opportunity ();
            opp1.Name = 'test opp';
            opp1.AccountId = acc1.Id;
            opp1.Amount = 1234;
            opp1.Industry__c = 'Healthcare';
            opp1.StageName = 'Prospect (0-14%)';
            opp1.Probability = 0.5;
            opp1.CloseDate = System.today()+11;
            Insert opp1;
                system.debug('opp1--'+opp1);
            opp1.Name = 'test oppty123';
            Id recTypeId1 = [Select Id From RecordType where sobjecttype = 'Opportunity' And Name='Healthcare Software'].Id;
            opp1.RecordTypeId = recTypeId1;
            Update opp1;
            
            MetadataLoader__c md1 = new MetadataLoader__c();
            md1.Offering__c = 'Capital Advisory';
            md1.ServiceLine_or_product__c = 'Growth';
            md1.geography__c = 'US';
            md1.practice__c= 'Business Advisory';
            md1.Elite_Department__c= 'Business Advisory-Capital Advisory';
            md1.Elite_ServiceLine_Id__c ='FIN05';
            md1.Elite_Department_Id__c = '1150';
            md1.NameKeyValue__c = 'Capital AdvisoryGrowthUSBusiness Advisory';
            insert md1;
            system.debug('md1--'+md1);
            
            MetadataLoader__c md2 = new MetadataLoader__c();
            md2.Offering__c = 'Valuation';
            md2.ServiceLine_or_product__c = 'Valuation';
            md2.Module_or_Accelerator__c = 'Energy';
            md2.geography__c = 'US';
            md2.practice__c= 'Business Advisory';
            md2.Elite_Department__c= 'Business Advisory-Capital Advisory';
            md2.Elite_ServiceLine_Id__c ='FIN05';
            md2.Elite_Department_Id__c = '1150';
            md2.NameKeyValue__c = 'ValuationValuationUSEnergyBusiness Advisory';
            insert md2;
            
            MetadataLoader__c md3 = new MetadataLoader__c();
            md3.Offering__c = 'Technology - SIS';
            md3.ServiceLine_or_product__c = 'PeopleSoft';
            md3.Module_or_Accelerator__c = 'Student';
            md3.geography__c = 'US';
            md3.practice__c= 'Education';
            md3.Elite_Department__c= 'Business Advisory-Capital Advisory';
            md3.Elite_ServiceLine_Id__c ='FIN05';
            md3.Elite_Department_Id__c = '1150';
            md3.industry__c = 'Healthcare';
            md3.NameKeyValue__c = 'Technology - SISPeopleSoftUSStudentHealthcareEducation';
            insert md3;
            
                        
            
            
            OpportunityLineItem op1 = new OpportunityLineItem();
            op1.Offering__c = 'Capital Advisory';
            op1.Service_Line_or_Product__c = 'Growth';
            //op1.Module_or_Accelerator2__c='Energy';
            op1.OpportunityId = opp.Id;
            op1.Product2Id = svc2.Id;
            op1.Amount__c = 12334;
            op1.PricebookEntryId = pbe3.Id;
            op1.geography__c = 'US';
            op1.practice__c = '';
            Insert op1;
            
            OpportunityLineItem op2 = new OpportunityLineItem();
            op2.Offering__c = 'Valuation';
            op2.Service_Line_or_Product__c = 'Valuation';
            op2.Module_or_Accelerator2__c='Energy';
            op2.OpportunityId = opp.Id;
            op2.Product2Id = svc2.Id;
            op2.Amount__c = 12334;
            op2.PricebookEntryId = pbe3.Id;
            op2.geography__c = 'US';
            op2.practice__c = '';
            Insert op2;
            
            OpportunityLineItem op3 = new OpportunityLineItem();
            op3.Offering__c = 'Technology - SIS';
            op3.Service_Line_or_Product__c = 'PeopleSoft';
            op3.Module_or_Accelerator2__c='Student';
            op3.OpportunityId = opp1.Id;
            op3.Product2Id = svc2.Id;
            op3.Amount__c = 12334;
            op3.PricebookEntryId = pbe3.Id;
            op3.geography__c = 'US';
            op3.practice__c = '';
            Insert op3;
            system.debug('op3--'+op3);
            
           
           list<Id> oplist = new list<Id>();
            
            
            
           oplist.add(op1.id);
            oplist.add(op2.id);
            oplist.add(op3.id);
        
          
           ProductMapAssignment.autoMapProduct(oplist);
           
             
        }
        }
        
    }