public with sharing class opportunityproductdepartment {
    
    public static void departmentupdateonproduct(list<opportunitylineitem> oppline)
    {
        for(OpportunityLineItem op : oppline)
        {
            if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsHostingUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c  = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMData GovernanceCanada')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-EPM-Data Governance-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMData GovernanceIndia')
            {
                op.Elite_Department_ID__c = '6212';
                op.Elite_Department__c = 'BA-ES&A-EPM-Data Governance-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMData GovernanceUS')
            {
                op.Elite_Department_ID__c = '1424';
                op.Elite_Department__c = 'BA-ES&A-EPM-Data Governance-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPARPA ImplementationCanada')
            {
                op.Elite_Department_ID__c = '7142';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPARPA ImplementationIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPARPA ImplementationUS')
            {
                op.Elite_Department_ID__c = '1504';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPAHostingCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPAHostingIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPAHostingUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPAManaged ServicesCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPAManaged ServicesIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPASoftware SalesCanada')
            {
                op.Elite_Department_ID__c = '7142';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPAManaged ServicesUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPASoftware SalesIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - RPASoftware SalesUS')
            {
                op.Elite_Department_ID__c = '1504';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-US';
                
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMFinancial CloseCanada')
            {
                op.Elite_Department_ID__c = '7142';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMFinancial CloseIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMFinancial CloseUS')
            {
                op.Elite_Department_ID__c = '1504';
                op.Elite_Department__c = 'BA-ES&A-EPM-Close-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMInfrastructure & IntegrationCanada')
            {
                op.Elite_Department_ID__c = '7148';
                op.Elite_Department__c = 'BA-ES&A-Infra&Integration-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMInfrastructure & IntegrationIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Infra&Integration-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMInfrastructure & IntegrationUS')
            {
                op.Elite_Department_ID__c = '1511';
                op.Elite_Department__c = 'BA-ES&A-Infra&Integration-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMManaged ServicesCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMManaged ServicesIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMManaged ServicesUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMHostingCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMHostingIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMHostingUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMPlanning & StrategyCanada')
            {
                op.Elite_Department_ID__c = '7141';
                op.Elite_Department__c = 'BA-ES&A-EPM-P&S-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMPlanning & StrategyIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-EPM-P&S-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMPlanning & StrategyUS')
            {
                op.Elite_Department_ID__c = '1503';
                op.Elite_Department__c = 'BA-ES&A-EPM-P&S-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMProfitabilityCanada')
            {
                op.Elite_Department_ID__c = '7143';
                op.Elite_Department__c = 'BA-ES&A-EPM-Profitability-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMProfitabilityIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-EPM-Profitability-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMProfitabilityUS')
            {
                op.Elite_Department_ID__c = '1505';
                op.Elite_Department__c = 'BA-ES&A-EPM-Profitability-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPOracle CloudCanada')
            {
                op.Elite_Department_ID__c = '7140';
                op.Elite_Department__c = 'BA-ES&A-ERP-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPOracle CloudIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-ERP-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPOracle CloudUS')
            {
                op.Elite_Department_ID__c = '1422';
                op.Elite_Department__c = 'BA-ES&A-ERP-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPWorkdayCanada')
            {
                op.Elite_Department_ID__c = '1423';
                op.Elite_Department__c = 'BA-ES&A-Workday-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPWorkdayIndia')
            {
                op.Elite_Department_ID__c = '1423';
                op.Elite_Department__c = 'BA-ES&A-Workday-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPWorkdayUS')
            {
                op.Elite_Department_ID__c = '1423';
                op.Elite_Department__c = 'BA-ES&A-Workday-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPPeopleSoftCanada')
            {
                op.Elite_Department_ID__c = '7140';
                op.Elite_Department__c = 'BA-ES&A-ERP-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPPeopleSoftIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-ERP-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPPeopleSoftUS')
            {
                op.Elite_Department_ID__c = '1422';
                op.Elite_Department__c = 'BA-ES&A-ERP-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPOtherCanada')
            {
                op.Elite_Department_ID__c = '7140';
                op.Elite_Department__c = 'BA-ES&A-ERP-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPOtherIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-ERP-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPOtherUS')
            {
                op.Elite_Department_ID__c = '1422';
                op.Elite_Department__c = 'BA-ES&A-ERP-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPManaged ServicesCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPManaged ServicesIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPManaged ServicesUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPHostingCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPHostingIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - ERPHostingUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMSalesforceIndia')
            {
                op.Elite_Department_ID__c = '6202';
                op.Elite_Department__c = 'BA-ES&A-Salesforce India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMSalesforceCanada')
            {
                op.Elite_Department_ID__c = '7161';
                op.Elite_Department__c = 'BA-ES&A-Salesforce-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMSalesforceUS')
            {
                op.Elite_Department_ID__c = '1416';
                op.Elite_Department__c = 'BA-ES&A-Salesforce-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMHostingCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMHostingIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMHostingUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMManaged ServicesCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMManaged ServicesIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - CRMManaged ServicesUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsPower BICanada')
            {
                op.Elite_Department_ID__c = '7146';
                op.Elite_Department__c ='BA-ES&A-BI-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsPower BIIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-BI-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsPower BIUS')
            {
                op.Elite_Department_ID__c = '1509';
                op.Elite_Department__c = 'BA-ES&A-BI-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsTableauCanada')
            {
                op.Elite_Department_ID__c = '7146';
                op.Elite_Department__c = 'BA-ES&A-BI-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsTableauIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-BI-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsTableauUS')
            {
                op.Elite_Department_ID__c = '1509';
                op.Elite_Department__c = 'BA-ES&A-BI-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsOracle CloudCanada')
            {
                op.Elite_Department_ID__c = '7146';
                op.Elite_Department__c = 'BA-ES&A-BI-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsOracle CloudIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-BI-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsOracle CloudUS')
            {
                op.Elite_Department_ID__c = '1509';
                op.Elite_Department__c = 'BA-ES&A-BI-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsHostingCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsHostingIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsHostingUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsManaged ServicesCanada')
            {
                op.Elite_Department_ID__c = '7147';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-Canada';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsManaged ServicesIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-India';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - BI & AnalyticsManaged ServicesUS')
            {
                op.Elite_Department_ID__c = '1510';
                op.Elite_Department__c = 'BA-ES&A-Managed Svcs-US';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMWorkdayCanada')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = '';
            }
            else if(op.Elite_Dept_Formula__c == 'Technology - EPMWorkdayIndia')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c= '';
            }
            else if (op.Elite_Dept_Formula__c == 'Technology - EPMWorkdayUS')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c = '';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyBusiness Development StrategyUK')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c  = 'BA-Life Sciences Strategy UK';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyCommercial StrategyUS')
            {
                op.Elite_Department_ID__c = '1360';
                op.Elite_Department__c  = 'BA-Life Sciences Strategy US';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyCommercial StrategyUK')
            {
                op.Elite_Department_ID__c = '2503';
                op.Elite_Department__c  = 'BA-Life Sciences Strategy UK';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyCorporate and Franchise StrategyUS')
            {
                op.Elite_Department_ID__c = '1360';
                op.Elite_Department__c  = 'BA-Life Sciences Strategy US';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyCorporate and Franchise StrategyUK')
            {
                op.Elite_Department_ID__c = '2503';
                op.Elite_Department__c  = 'BA-Life Sciences Strategy UK';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyDigital Solutions & TechnologyUK')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c  = '';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyDigital Solutions & TechnologyUS')
            {
                op.Elite_Department_ID__c = '';
                op.Elite_Department__c  = '';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyDrug Safety and RegulatoryUK')
            {
                op.Elite_Department_ID__c = '2501';
                op.Elite_Department__c  = 'BA-Life Sciences Access UK';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyDrug Safety and RegulatoryUS')
            {
                op.Elite_Department_ID__c = '1445';
                op.Elite_Department__c  = 'BA-Life Sciences Access US';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyMarket Access and PricingUK')
            {
                op.Elite_Department_ID__c = '2501';
                op.Elite_Department__c  = 'BA-Life Sciences Access UK';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyMarket Access and PricingUS')
            {
                op.Elite_Department_ID__c = '1445';
                op.Elite_Department__c  = 'BA-Life Sciences Access US';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyOrganization & Innovation DevelopmentUK')
            {
                op.Elite_Department_ID__c = '2501';
                op.Elite_Department__c  = 'BA-Life Sciences Access UK';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyOrganization & Innovation DevelopmentUS')
            {
                op.Elite_Department_ID__c = '1445';
                op.Elite_Department__c  = 'BA-Life Sciences Access US';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyResearch & Development StrategyUS')
            {
                op.Elite_Department_ID__c = '1360';
                op.Elite_Department__c  = 'BA-Life Sciences Strategy US';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyResearch & Development StrategyUK')
            {
                op.Elite_Department_ID__c = '2503';
                op.Elite_Department__c  = 'BA-Life Sciences Strategy UK';
            }
            else if(op.Elite_Dept_Formula__c == 'StrategyDigital Solutions & TechnologyUKiDetailAid')
            {
                op.Elite_Department_ID__c = '2502';
                op.Elite_Department__c  = 'BA-Life Sciences- iDetailAid UK';
            }else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryCommercial Dispute AdvisoryUS')
        {
            op.Elite_Department_ID__c = '1101';
            op.Elite_Department__c  = 'Business Advisory-Financial Advisory US';
            op.Elite_Service_Line__c ='Commercial Dispute Advisory';
            op.Elite_Service_Line_ID__c='FIN03';
            

        } 
else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryPerformance ImprovementUS')
        {
            op.Elite_Department_ID__c = '1101';
            op.Elite_Department__c  = 'Business Advisory-Financial Advisory US';
            op.Elite_Service_Line__c ='Performance Improvement';
            op.Elite_Service_Line_ID__c='FIN02';
        }
        else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryRestructuring & TurnaroundUS')
        {
            op.Elite_Department_ID__c = '1101';
            op.Elite_Department__c  = 'Business Advisory-Financial Advisory US';
            op.Elite_Service_Line__c ='Performance Improvement';
            op.Elite_Service_Line_ID__c='FIN02';
        }
        else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryOtherUS')
        {
            op.Elite_Department_ID__c = '1101';
            op.Elite_Department__c  = 'Business Advisory-Financial Advisory US';
            op.Elite_Service_Line__c ='Other';
            op.Elite_Service_Line_ID__c='FIN16';
        }
            //commented since no dependency on capital advisory
     /**   else if(op.Elite_Dept_Formula__c == 'Capital AdvisoryGrowthUS')
        {
            op.Elite_Department_ID__c = '1150';
            op.Elite_Department__c  = 'Business Advisory-Capital Advisory';
            op.Elite_Service_Line__c ='Capital Advisory';
            op.Elite_Service_Line_ID__c='FIN05';
        } 
        else if(op.Elite_Dept_Formula__c == 'Capital AdvisorySpecial SituationsUS')
        {
            op.Elite_Department_ID__c = '1150';
            op.Elite_Department__c  = 'Business Advisory-Capital Advisory';
            op.Elite_Service_Line__c ='Capital Advisory';
            op.Elite_Service_Line_ID__c='FIN05';
        } **/
        else if(op.Elite_Dept_Formula__c == 'ValuationValuationUS')
        {
            op.Elite_Department_ID__c = '1316';
            op.Elite_Department__c  = 'Business Advisory-Valuation';
            op.Elite_Service_Line__c ='Valuation';
            op.Elite_Service_Line_ID__c='VAL01';
        } /** //commented since no dependency on capital advisory
       else if(op.Elite_Dept_Formula__c == 'Capital AdvisoryGrowthCanada')
        {
            op.Elite_Department_ID__c = '7102';
            op.Elite_Department__c  = 'Business Advisory-Financial Advis-Canada';
            
            
        }
        else if(op.Elite_Dept_Formula__c == 'Capital AdvisorySpecial SituationsCanada')
        {
            op.Elite_Department_ID__c = '7102';
            op.Elite_Department__c  = 'Business Advisory-Financial Advis-Canada';
            op.Elite_Service_Line__c ='Capital Advisory';
            op.Elite_Service_Line_ID__c='FIN05';
        } **/
        else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryCommercial Dispute AdvisoryCanada')
        {
            op.Elite_Department_ID__c = '7102';
            op.Elite_Department__c  = 'Business Advisory-Financial Advis-Canada';
            op.Elite_Service_Line__c ='Commercial Dispute Advisory';
            op.Elite_Service_Line_ID__c='FIN03';
        }
        else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryPerformance ImprovementCanada')
        {
            op.Elite_Department_ID__c = '7102';
            op.Elite_Department__c  = 'Business Advisory-Financial Advis-Canada';
            op.Elite_Service_Line__c ='Performance Improvement';
            op.Elite_Service_Line_ID__c='FIN02';
        }
        else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryRestructuring & TurnaroundCanada')
        {
            op.Elite_Department_ID__c = '7102';
            op.Elite_Department__c  = 'Business Advisory-Financial Advis-Canada';
             op.Elite_Service_Line__c ='Restructuring & Turnaround';
            op.Elite_Service_Line_ID__c='FIN01';
        }
        else if(op.Elite_Dept_Formula__c == 'Financial AdvisoryOtherCanada')
        {
            op.Elite_Department_ID__c = '7102';
            op.Elite_Department__c  = 'Business Advisory-Financial Advis-Canada';
            op.Elite_Service_Line__c ='Other';
            op.Elite_Service_Line_ID__c='FIN16';
        }
        else{}
        }
        System.debug('oppline   '+oppline);
        /*====Module or Accelerator=================================================================================*/
        for(OpportunityLineItem opp : oppline)
        {
            if(opp.Module_or_Accelerator2__c == 'Data Resource Management')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Data Governance';
                opp.Elite_Service_Line_ID__c = 'EPM35';
            }
            else if(opp.Module_or_Accelerator2__c =='Data Resource Governance')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Data Governance';
                opp.Elite_Service_Line_ID__c = 'EPM35';
            }
            else if(opp.Module_or_Accelerator2__c =='UiPath')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='RPA')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Managed Services';
                opp.Elite_Service_Line_ID__c = 'EPM37';
            }
            else if(opp.Module_or_Accelerator2__c =='Automation Anywhere')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='Blue Prism')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='Olive')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Account Reconciliation and Close (ARC)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Hyperion Financial Management (HFM)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Financial Close and Consolidation Cloud (FCCS)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='OneStream')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-OneStream';
                opp.Elite_Service_Line_ID__c = 'EPM46';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Tax Reporting Cloud Service (TRCS)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Financial Close-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM23';
            }
            else if(opp.Module_or_Accelerator2__c =='Infrastructure & Integration')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Infstr & Integ';
                opp.Elite_Service_Line_ID__c = 'EPM27';
            }
            else if(opp.Module_or_Accelerator2__c =='EPM')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Managed Services';
                opp.Elite_Service_Line_ID__c = 'EPM37';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Planning and Budgeting Cloud (PBCS)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Planning & Strategy-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM30';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Enterprise Planning and Budgeting Cloud Service (EPBCS)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Planning & Strategy-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM30';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Hyperion Strategic Finance (HSF)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Planning & Strategy-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM30';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Crystal Ball')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Planning & Strategy-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM30';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Strategy Management (SM)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Planning & Strategy-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM30';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Hyperion Profitability and Cost Management (HPCM)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Planning & Strategy-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM30';
            }
            else if(opp.Module_or_Accelerator2__c =='Anaplan')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Planning & Strategy-Anaplan';
                opp.Elite_Service_Line_ID__c = 'EPM47';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Profitability and Cost Management Cloud (PCMCS)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Profitability';
                opp.Elite_Service_Line_ID__c = 'EPM16';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Financial Services Analytical Applications (OFSAA)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Profitability';
                opp.Elite_Service_Line_ID__c = 'EPM16';
            }
            else if(opp.Module_or_Accelerator2__c =='Funds Transfer Pricing (FTP)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Profitability';
                opp.Elite_Service_Line_ID__c = 'EPM16';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Financial Services Data Foundation (FSDF)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Profitability';
                opp.Elite_Service_Line_ID__c = 'EPM16';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Financial Services Crime and Compliance Management (FCCM)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Profitability';
                opp.Elite_Service_Line_ID__c = 'EPM16';
            }
            else if(opp.Module_or_Accelerator2__c =='Oracle - Financial Services Balance Sheet Planning (BSP)')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Profitability';
                opp.Elite_Service_Line_ID__c = 'EPM16';
            }
            else if(opp.Module_or_Accelerator2__c =='Financials')
            {
                opp.Elite_Service_Line__c = 'ES&A-ERP-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM15';
            }
            else if(opp.Module_or_Accelerator2__c =='HCM')
            {
                opp.Elite_Service_Line__c = 'ES&A-ERP-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM15';
            }
            else if(opp.Module_or_Accelerator2__c =='Procurement')
            {
                opp.Elite_Service_Line__c = 'ES&A-ERP-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM15';
            }
            else if(opp.Module_or_Accelerator2__c =='Supply Chain')
            {
                opp.Elite_Service_Line__c = 'ES&A-ERP-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM15';
            }
            else if(opp.Module_or_Accelerator2__c =='NetSuite')
            {
                opp.Elite_Service_Line__c = 'ES&A-ERP-Oracle';
                opp.Elite_Service_Line_ID__c = 'EPM15';
            }
            else if(opp.Module_or_Accelerator2__c =='ERP')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Managed Services';
                opp.Elite_Service_Line_ID__c = 'EPM37';
            }
            else if(opp.Module_or_Accelerator2__c =='Sales Cloud')
            {
                opp.Elite_Service_Line__c = 'ES&A-Salesforce';
                opp.Elite_Service_Line_ID__c = 'EPM33';
            }
            else if(opp.Module_or_Accelerator2__c =='Service Cloud')
            {
                opp.Elite_Service_Line__c = 'ES&A-Salesforce';
                opp.Elite_Service_Line_ID__c = 'EPM33';
            }
            else if(opp.Module_or_Accelerator2__c =='Marketing Cloud')
            {
                opp.Elite_Service_Line__c = 'ES&A-Salesforce';
                opp.Elite_Service_Line_ID__c = 'EPM33';
            }
            else if(opp.Module_or_Accelerator2__c =='Health Cloud')
            {
                opp.Elite_Service_Line__c = 'ES&A-Salesforce';
                opp.Elite_Service_Line_ID__c = 'EPM33';
            }
            else if(opp.Module_or_Accelerator2__c =='Other')
            {
                opp.Elite_Service_Line__c = 'ES&A-Salesforce';
                opp.Elite_Service_Line_ID__c = 'EPM33';
            }
            else if(opp.Module_or_Accelerator2__c =='CRM')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Managed Services';
                opp.Elite_Service_Line_ID__c = 'EPM37';
            }
            else if(opp.Module_or_Accelerator2__c =='Power BI')
            {
                opp.Elite_Service_Line__c = 'ES&A-BIA';
                opp.Elite_Service_Line_ID__c = 'EPM36';
            }
            else if(opp.Module_or_Accelerator2__c =='Tableau')
            {
                opp.Elite_Service_Line__c = 'ES&A-BIA';
                opp.Elite_Service_Line_ID__c = 'EPM36';
            }
            else if(opp.Module_or_Accelerator2__c =='OBIEE')
            {
                opp.Elite_Service_Line__c = 'ES&A-BIA';
                opp.Elite_Service_Line_ID__c = 'EPM36';
            }
            else if(opp.Module_or_Accelerator2__c =='Essbase')
            {
                opp.Elite_Service_Line__c = 'ES&A-BIA';
                opp.Elite_Service_Line_ID__c = 'EPM36';
            }
            else if(opp.Module_or_Accelerator2__c =='BIA')
            {
                opp.Elite_Service_Line__c = 'ES&A-EPM-Managed Services';
                opp.Elite_Service_Line_ID__c = 'EPM37';
            }
            else if(opp.Module_or_Accelerator2__c =='Adaptive Insights')
            {
                opp.Elite_Service_Line__c = '';
                opp.Elite_Service_Line_ID__c = '';
            }
            else if(opp.Module_or_Accelerator2__c =='Commercial Due Diligence')
            {
                opp.Elite_Service_Line__c = '';
                opp.Elite_Service_Line_ID__c = '';
            }
            else if(opp.Module_or_Accelerator2__c =='Forecasting')
            {
                opp.Elite_Service_Line__c = '';
                opp.Elite_Service_Line_ID__c = '';
            }
            else if(opp.Module_or_Accelerator2__c =='Landscape Assessment')
            {
                opp.Elite_Service_Line__c = '';
                opp.Elite_Service_Line_ID__c = '';
            }
            else if(opp.Module_or_Accelerator2__c =='Screening/Asset Identelse ification and prioritization (Multi-Attribute Decision Analysis (MADA))')
            {
                opp.Elite_Service_Line__c = '';
                opp.Elite_Service_Line_ID__c = '';
            }
            else if(opp.Module_or_Accelerator2__c =='Commercial Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial Strategy';
                opp.Elite_Service_Line_ID__c = 'LS001';
            }
            else if(opp.Module_or_Accelerator2__c =='Competitive Simulation')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial - Competitive Simulation';
                opp.Elite_Service_Line_ID__c = 'LS020';
            }
            else if(opp.Module_or_Accelerator2__c =='Customer Support')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial - Customer Support';
                opp.Elite_Service_Line_ID__c = 'LS025';
            }
            else if(opp.Module_or_Accelerator2__c =='Launch/MKT Planning')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial - Launch/Mkt Planning';
                opp.Elite_Service_Line_ID__c = 'LS021';
            }
            else if(opp.Module_or_Accelerator2__c =='LCM')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial - LCM';
                opp.Elite_Service_Line_ID__c = 'LS022';
            }
            else if(opp.Module_or_Accelerator2__c =='Market Assessment')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial - Market Assessment';
                opp.Elite_Service_Line_ID__c = 'LS023';
            }
            else if(opp.Module_or_Accelerator2__c =='TPP Development')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial - TPP development';
                opp.Elite_Service_Line_ID__c = 'LS024';
            }
            else if(opp.Module_or_Accelerator2__c =='CDx Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-Commercial-CDx Strategy';
                opp.Elite_Service_Line_ID__c = 'LS037';
            }
            else if(opp.Module_or_Accelerator2__c =='Corporate Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-Corporate - Corporate Strategy';
                opp.Elite_Service_Line_ID__c = 'LS028';
            }
            else if(opp.Module_or_Accelerator2__c =='Franchise Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-Corporate - Franchise Strategy';
                opp.Elite_Service_Line_ID__c = 'LS026';
            }
            else if(opp.Module_or_Accelerator2__c =='Portfolio Planning')
            {
                opp.Elite_Service_Line__c = 'LS-Corporate - Portfolio Planning';
                opp.Elite_Service_Line_ID__c = 'LS027';
            }
            else if(opp.Module_or_Accelerator2__c =='Digital')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Digital';
                opp.Elite_Service_Line_ID__c = 'LS006';
            }
            else if(opp.Module_or_Accelerator2__c =='Digital MA Tools')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Digital MA Tools';
                opp.Elite_Service_Line_ID__c = 'LS007';
            }
            else if(opp.Module_or_Accelerator2__c =='iDetailAid')
            {
                opp.Elite_Service_Line__c = 'ES&A-BIA';
                opp.Elite_Service_Line_ID__c = 'EPM36';
            }
            else if(opp.Module_or_Accelerator2__c =='Evidence Generation')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Evidence Generation';
                opp.Elite_Service_Line_ID__c = 'LS008';
            }
            else if(opp.Module_or_Accelerator2__c =='Risk & Regulatory Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Benefit: Risk and Regulatory Strategy';
                opp.Elite_Service_Line_ID__c = 'LS004';
            }
            else if(opp.Module_or_Accelerator2__c =='Risk Minimization Implementation')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Risk Minimisation  Implementation';
                opp.Elite_Service_Line_ID__c = 'LS013';
            }
            else if(opp.Module_or_Accelerator2__c =='Safety Process')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Safety Process';
                opp.Elite_Service_Line_ID__c = 'LS014';
            }
            else if(opp.Module_or_Accelerator2__c =='Tracking')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Tracking';
                opp.Elite_Service_Line_ID__c = 'LS015';
            }
            else if(opp.Module_or_Accelerator2__c =='MA Excellence')
            {
                opp.Elite_Service_Line__c = 'LS-PW-MA Excellence';
                opp.Elite_Service_Line_ID__c = 'LS010';
            }
            else if(opp.Module_or_Accelerator2__c =='Pricing & MEA')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Pricing and MEA';
                opp.Elite_Service_Line_ID__c = 'LS012';
            }
            else if(opp.Module_or_Accelerator2__c =='Value Comms')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Value Comms';
                opp.Elite_Service_Line_ID__c = 'LS016';
            }
            else if(opp.Module_or_Accelerator2__c =='Value Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Value Strategy';
                opp.Elite_Service_Line_ID__c = 'LS017';
            }
            else if(opp.Module_or_Accelerator2__c =='Capability Design & Development')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Capability Design and Development';
                opp.Elite_Service_Line_ID__c = 'LS005';
            }
            else if(opp.Module_or_Accelerator2__c =='Learning Strategy & Tactics')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Learning Strategy and Tactics';
                opp.Elite_Service_Line_ID__c = 'LS009';
            }
            else if(opp.Module_or_Accelerator2__c =='Organizational Design & Development')
            {
                opp.Elite_Service_Line__c = 'LS-PW-Organisational Design and Development';
                opp.Elite_Service_Line_ID__c = 'LS011';
            }
            else if(opp.Module_or_Accelerator2__c =='Clinical Dev Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-R&D - Clinical Dev Strategy';
                opp.Elite_Service_Line_ID__c = 'LS032';
            }
            else if(opp.Module_or_Accelerator2__c =='Companion Dx')
            {
                opp.Elite_Service_Line__c = 'LS-R&D - Companion Dx';
                opp.Elite_Service_Line_ID__c = 'LS033';
            }
            else if(opp.Module_or_Accelerator2__c =='Conference Coverage')
            {
                opp.Elite_Service_Line__c = 'LS-R&D - Conference Coverage';
                opp.Elite_Service_Line_ID__c = 'LS034';
            }
            else if(opp.Module_or_Accelerator2__c =='Optimization')
            {
                opp.Elite_Service_Line__c = 'LS-R&D Optimization';
                opp.Elite_Service_Line_ID__c = 'LS018';
            }
            else if(opp.Module_or_Accelerator2__c =='Platform Strategy')
            {
                opp.Elite_Service_Line__c = 'LS-R&D - Platform Strategy';
                opp.Elite_Service_Line_ID__c = 'LS035';
            }
            else if(opp.Module_or_Accelerator2__c =='R&D')
            {
                opp.Elite_Service_Line__c = '';
                opp.Elite_Service_Line_ID__c = '';
            }
            
            else{}
            
        }
    }
    
}