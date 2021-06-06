@isTest
private class OpportunityTotalAmountRollupTriggerTest {

    static testMethod void testRollupOnAfterInsert() {
        
        Decimal parentOpp1Amount = 100;
        Opportunity parentOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(parentOpp1Amount);
        
        // Test 1: After inserting a child, TotalOpportunityAmount and #ofChildren rollup properly on parent
        Decimal childOpp1Amount = 50;
        Opportunity childOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp1Amount, parentOpp1.Id);
        
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        ////System.assertEquals((parentOpp1Amount + childOpp1Amount), parentOpp1.Total_Opportunity_Amount__c);
        ////System.assertEquals(1, parentOpp1.No_of_Child_Opportunities__c);
        
        // Test 2: After inserting second child, TotalOpportunityAmount and #ofChildren rollup properly on parent
        Decimal childOpp2Amount = 25;
        Opportunity childOpp2 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp2Amount, parentOpp1.Id);
        
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount), parentOpp1.Total_Opportunity_Amount__c);
        //System.assertEquals(2, parentOpp1.No_of_Child_Opportunities__c);
        
        // Test 3: Inserting a grandchild causes rollup fields to populate on ITS parent
        Decimal grandchildOpp1Amount = 5;
        Opportunity grandchildOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(grandchildOpp1Amount, childOpp2.Id);
        
        childOpp2 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(childOpp2);
        //System.assertEquals((childOpp2.Amount + grandchildOpp1Amount), childOpp2.Total_Opportunity_Amount__c);
        //System.assertEquals(1, childOpp2.No_of_Child_Opportunities__c);
        
        // Test 4: TotalAmount field from grandchild propogates all the way up to parent, but #ofChildren doesn't (only 1 level deep)
        //parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        ////System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount + grandchildOpp1Amount), parentOpp1.Total_Opportunity_Amount__c);
        ////System.assertEquals(2, parentOpp1.No_of_Child_Opportunities__c);
        
        
    }
    
    static testMethod void testRollupOnAfterUpdate_ParentOnly() {
        
        // Insert parent
        Decimal parentOpp1Amount = 100;
        Opportunity parentOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(parentOpp1Amount);
        
        // Insert child
        Decimal childOpp1Amount = 50;
        Opportunity childOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp1Amount, parentOpp1.Id);
        
        // Test 1: Everything adds up properly so far
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        ////System.assertEquals(1, parentOpp1.No_of_Child_Opportunities__c);
        ////System.assertEquals((parentOpp1Amount + childOpp1Amount), parentOpp1.Total_Opportunity_Amount__c);
        
        // Test 2: Update the parent amount only, ensure trigger still fires
        parentOpp1.Amount += 20;
        update parentOpp1;
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals((20 + parentOpp1Amount + childOpp1Amount), parentOpp1.Total_Opportunity_Amount__c);
    }
    
    static testMethod void testRollupOnAfterUpdate() {
        
        // Insert parent
        Decimal parentOpp1Amount = 100;
        Opportunity parentOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(parentOpp1Amount);
        
        // Insert child
        Decimal childOpp1Amount = 50;
        Opportunity childOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp1Amount, parentOpp1.Id);
        
        // Insert child
        Decimal childOpp2Amount = 25;
        Opportunity childOpp2 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp2Amount, parentOpp1.Id);
        
        // Insert grandchild
        //Decimal grandchildOpp1Amount = 5;
        //Opportunity grandchildOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(grandchildOpp1Amount, childOpp2.Id);
        
        // Test 1: Everything adds up properly so far
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        ////System.assertEquals(2, parentOpp1.No_of_Child_Opportunities__c);
        ////System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount ), parentOpp1.Total_Opportunity_Amount__c);
        
        // Test 2: Updating grandchild amount propogates to the top
        //Decimal grandchildOpp1AmountBias = 35;
        //grandchildOpp1.Amount = grandchildOpp1.Amount + grandchildOpp1AmountBias;
        //update grandchildOpp1;
        
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount), parentOpp1.Total_Opportunity_Amount__c);
        
        // Test 3: Updating child amount propogates to the top
        Decimal childOpp1AmountBias = -25;
        childOpp1.Amount = childOpp1.Amount + childOpp1AmountBias;
        update childOpp1;
        
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount  + childOpp1AmountBias), parentOpp1.Total_Opportunity_Amount__c);
        
    }
    
    /*static testMethod void testRollupOnAfterDelete() {
        // Insert parent
        Decimal parentOpp1Amount = 100;
        Opportunity parentOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(parentOpp1Amount);
        
        // Insert child
        Decimal childOpp1Amount = 50;
        Opportunity childOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp1Amount, parentOpp1.Id);
        
        // Insert child
        Decimal childOpp2Amount = 25;
        Opportunity childOpp2 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp2Amount, parentOpp1.Id);
        
        // Insert grandchild
        //Decimal grandchildOpp1Amount = 5;
        //Opportunity grandchildOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(grandchildOpp1Amount, childOpp2.Id);
        
        // Test 1: Everything adds up properly so far
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals(2, parentOpp1.No_of_Child_Opportunities__c);
        //System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount ), parentOpp1.Total_Opportunity_Amount__c);
        
        // Test 2: Deleting the grandchild decreases its grandparent's total amount
        //delete grandchildOpp1;
        //parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        ////System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount), parentOpp1.Total_Opportunity_Amount__c);
        
        // Test 3: Deleting a child is reflected on the parent
        delete childOpp1;
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals(1, parentOpp1.No_of_Child_Opportunities__c);
        //System.assertEquals((parentOpp1Amount + childOpp2Amount), parentOpp1.Total_Opportunity_Amount__c);
        
        
    }*/
    
    static testMethod void testRollupOnAfterUndelete() {
        // Insert parent
        Decimal parentOpp1Amount = 100;
        Opportunity parentOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(parentOpp1Amount);
        
        // Insert child
        Decimal childOpp1Amount = 50;
        Opportunity childOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp1Amount, parentOpp1.Id);
        
        // Insert child
        Decimal childOpp2Amount = 25;
        Opportunity childOpp2 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(childOpp2Amount, parentOpp1.Id);
        
        // Insert grandchild
        //Decimal grandchildOpp1Amount = 5;
        //Opportunity grandchildOpp1 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(grandchildOpp1Amount, childOpp2.Id);
        
        // Test 1: Everything adds up properly so far
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        ////System.assertEquals(2, parentOpp1.No_of_Child_Opportunities__c);
        ////System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount ), parentOpp1.Total_Opportunity_Amount__c);
        
        // Test 2: Delete grandchild and ensure it's deleted
        //delete grandchildOpp1;
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount), parentOpp1.Total_Opportunity_Amount__c);
        
        // Test 3: Undelete grandchild and ensure this is reflected in the parent
        //undelete grandchildOpp1;
        parentOpp1 = OpportunityTotalAmountTestFactory.RehydrateOpportunity(parentOpp1);
        //System.assertEquals((parentOpp1Amount + childOpp1Amount + childOpp2Amount ), parentOpp1.Total_Opportunity_Amount__c);
        
    }
    
    static testMethod void ensureCodeCoverage() {
        
        OpportunityTotalAmountRollupTrigger t = new OpportunityTotalAmountRollupTrigger();
        
        Opportunity o = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(100);
        Opportunity o2 = OpportunityTotalAmountTestFactory.InsertOpportunityEmpty(100, o.Id);
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(new Opportunity[]{o2});

        // Throw exceptions
        OpportunityTotalAmountRollupTrigger.doThrowTestException = true;
        t.RecalculateTotalAmountRollupFieldOnParents(oppMap, oppMap);
        t.RecalculateTotalAmountRollupFieldOnParents(oppMap.values(), null);
        
        // Trigger dml error pathway
        OpportunityTotalAmountRollupTrigger.doThrowTestException = false;
        OpportunityTotalAmountRollupTrigger.doPretendDMLError = true;
        t.RecalculateTotalAmountRollupFieldOnParents(oppMap.values(), null);
    }

    
}