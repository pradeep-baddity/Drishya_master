/*
Name : CRM_TestFactory
CreatedBy : Kartikey Kulkarni
Last Modified By : Kartikey Kulkarni
Created Date : 28/05/2019
Last Modified Date : 30/05/2019
*/

@isTest
public class CRM_TestFactory {
    
    public static SObject createSObject(SObject sObj, Boolean doInsert) {
        SObject retObject = createSObject(sObj);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }
    
    public static SObject createSObject(SObject sObj) {
        // Check what type of object we are creating and add any defaults that are needed.
        String objectName = String.valueOf(sObj.getSObjectType());
        // Construct the default values class. Salesforce doesn't allow '__' in class names
        String defaultClassName = 'AVE_TestFactory.' + objectName.replaceAll('__(c|C)$|__', '') + 'Defaults';
        // If there is a class that exists for the default values, then use them
        if (Type.forName(defaultClassName) != null) {
            sObj = createSObject(sObj, defaultClassName);
        }
        return sObj;
    }
    
    public static SObject createSObject(SObject sObj, String defaultClassName) {
        // Create an instance of the defaults class so we can get the Map of field defaults
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            Throw new TestFactoryException('Invalid defaults class.');
        }
        FieldDefaults defaults = (FieldDefaults)t.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }
    
    public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
        SObject retObject = createSObject(sObj, defaultClassName);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }
    
    public static SObject[] createSObjectList(List<SObject> objs, Boolean doInsert) {
        if (doInsert) {
            insert objs;
        }
        return objs;
    }
    
    private static void addFieldDefaults(SObject sObj, Map<Schema.SObjectField, Object> defaults) {
        // Loop through the map of fields and if they weren't specifically assigned, fill them.
        Map<String, Object> populatedFields = sObj.getPopulatedFieldsAsMap();
        
        for (Schema.SObjectField field : defaults.keySet()) {
            if (!populatedFields.containsKey(String.valueOf(field))) {
                sObj.put(field, defaults.get(field));
            }
        }
    }
    
    // Update SObject
    public static SObject updateSObject(SObject sObj) {
        update sObj;
        return sObj;
    }    
    
    // Delete SObject
    public static void deleteSObject(SObject sObj) {
        delete sObj;
    } 
    
    public class TestFactoryException extends Exception {}
    
    // Use the FieldDefaults interface to set up values you want to default in for all objects.
    public Interface FieldDefaults {
        Map<Schema.SObjectField, Object> getFieldDefaults();
    }
    
    // Default data for Account
    public class AccountDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Account.Name => 'NONE (Do Not Edit)',
                    Account.Industry => 'Education'
                    };
                        }
    }
    
    // Default data for Contact
    public class ContactDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Contact.FirstName => 'Kartikey',                         
                    Contact.LastName => 'Kulkarni',                                   
                    Contact.Email => 'kkulkarni@huronConsultingGroup.com',             
                    Contact.Phone => '(610) 888-8046',
					Contact.Job_Function__c => 'Admissions',
					Contact.Job_Level__c => 'Dean'                
                    };
                        }
    }
    
    // Default data for Product2
    public class Product2Defaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Product2.Name  => 'Education Workday N/A Release Management ERP', 
                    Product2.CanUseRevenueSchedule => true
                    
                    };
                        }
    }
    
    // Default data for Standard Price Book
    Id pricebookId = Test.getStandardPricebookId();
    
    // Default data for Custom Price Book
    
    // Default data for PricebookEntry    
    public class PricebookEntryDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                PricebookEntry.Pricebook2Id  => 'Add value in the class',   //add value in the class                      
                    PricebookEntry.Product2Id  => 'Add value in the class',	//add value in the class
                    PricebookEntry.UnitPrice => 12000,
                    PricebookEntry.CurrencyIsoCode => 'USD',
                    PricebookEntry.IsActive => true
                    };
                        }
    }
    
    // Default data for Opportunity
    public class OpportunityDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                Opportunity.Pricebook2Id  => 'Add value in the class',   //add value in the class                      
                    Opportunity.recordtypeid  => 'Add value in the class',	//add value in the class
                    Opportunity.AccountId => 'Add value in the class',   //add value in the class
                    Opportunity.EPM_Sales_Lead__c => 'Add value in the class',   //add value in the class
                    Opportunity.Name => 'Google',
                    Opportunity.CurrencyIsoCode => 'USD',
                    Opportunity.ES_A_BDM_Role__c => 'Change Order',
                    Opportunity.closeDate => System.today()+5,
                    Opportunity.Estimated_Start_Date__c => System.today()+10,
                    Opportunity.Estimated_Duration__c => 3,
                    Opportunity.Oppty_Product_schedule_created__c => false,
                    Opportunity.Industry__c => 'Agriculture',
                    Opportunity.EPM_Region__c => 'Higher Ed',
                    Opportunity.Pricing_Review_Status__c => 'Not Submitted',
                    Opportunity.StageName => 'Prospect (0-14%)',
                    Opportunity.amount => 5000
                    };
                        }
    }
    
    // Default data for OpportunityLineItem
    public class OpportunityLineItemDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            //system.de
            return new Map<Schema.SObjectField, Object> {
                OpportunityLineItem.OpportunityId => 'Add value in the class',   //add value in the class
                    OpportunityLineItem.Product2Id => 'Add value in the class',   //add value in the class
                    OpportunityLineItem.Offering__c => 'Capital Advisory',

                    OpportunityLineItem.Amount__c => 200
            };
        }
    }
    
    // Default data for OpportunityContactRole
    public class OpportunityContactRoleDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                OpportunityContactRole.ContactId => 'Add value in the class',   //add value in the class
                    OpportunityContactRole.OpportunityId => 'Add value in the class',   //add value in the class
                    OpportunityContactRole.Role => 'Decision Maker',
                    OpportunityContactRole.IsPrimary => true
            };
        }
    }
    
    // Default data for OpportunityLineItemSchedule
    public class OpportunityLineItemScheduleDefaults implements FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                OpportunityLineItemSchedule.OpportunityLineItemId  => 'Add value in the class',   //add value in the class
                    //OpportunityLineItemSchedule.Quantity => 2.0,   //add value in the class
                    OpportunityLineItemSchedule.ScheduleDate => System.today()+10,
                    OpportunityLineItemSchedule.Type => 'Revenue',
                    OpportunityLineItemSchedule.Revenue => '' //add value in the class
            };
        }
    }
    
    // Default data for User
    public class UserDefaults implements FieldDefaults {
        String userProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;
        
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object> {
                User.Email => 'kkulkarni@huronconsultinggroup.com',
                    User.ProfileId => 'Add value in the class',   //add value in the class
                    User.Username => 'kkulkarni@huronconsultinggroup.com.test',
                    User.LastName => 'Kulkarni',
                    User.Alias => 'Test',
                    User.CommunityNickname => 'Test',
                    User.TimeZoneSidKey => 'Asia/Kolkata',
                    User.LocaleSidKey => 'en_IN',
                    User.EmailEncodingKey => 'ISO-8859-1',
                    User.LanguageLocaleKey => 'en_US'    
                    };
                        }
    }
    
    //Default 
}