public class OfferingWrapper {
    @AuraEnabled public Boolean isSelected;
    @AuraEnabled public String offeringName;
    @AuraEnabled public String Expertise;
    @AuraEnabled public String Capability;
    @AuraEnabled public String Service;
    @AuraEnabled public String TechnologyVendor;
    @AuraEnabled public String TechnologyCapability;
    @AuraEnabled public String TechnologyModule;
    @AuraEnabled public OpportunityLineItem optyLine;
    @AuraEnabled public Decimal duration;
    @AuraEnabled public Decimal salesPrice;
    //number, String, array, object, 'true', 'false' or 'null'
    public OfferingWrapper(String offeringName, string Expertise,String Capability,String Service,String TechnologyVendor,String TechnologyCapability,
                           String TechnologyModule,OpportunityLineItem optyLine, Decimal duration ,Decimal salesPrice){
                               this.offeringName = offeringName;
                               this.Expertise = Expertise;
                               this.Capability = Capability;
                               this.Service = Service;
                               this.TechnologyVendor = TechnologyVendor;
                               this.TechnologyCapability = TechnologyCapability;
                               this.TechnologyModule = TechnologyModule;
                               
                               this.duration = duration;
                               this.optyLine = optyLine;
                               this.salesPrice = salesPrice;
                               this.isSelected = false;
                               
                               
                           }
}