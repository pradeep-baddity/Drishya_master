import { LightningElement, track} from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getSaveReliefItems from '@salesforce/apex/Covid19CaresActController.getSaveReliefItems';
import getMetadataHeadings from '@salesforce/apex/Covid19CaresActController.getMetadataHeadings';
import getMetadataHelpText from '@salesforce/apex/Covid19CaresActController.getMetadataHelpText';
import updateLead from '@salesforce/apex/Covid19CaresActController.updateLead';
import getFieldSets from '@salesforce/apex/Covid19CaresActController.getFieldSets';
import getCheckExistingLead from '@salesforce/apex/Covid19CaresActController.getCheckExistingLead';
import { loadStyle , loadScript} from 'lightning/platformResourceLoader';
import COVID19_Form_CustomCSS from '@salesforce/resourceUrl/COVID19_Form_CustomCSS';
import keyDefinitions from '@salesforce/resourceUrl/StimulusReliefGatewayDefinitions';
import FORM_FACTOR from '@salesforce/client/formFactor';
export default class Covid19CaresAct extends LightningElement {
    /* TODO:
        - Check In Results
        - Application Guidance on Results page
        - Duplicate Leads?
        - Print Cleanup
    */
    currentPage = 1;
    maxPages = 4;
    userLookupRecord = {};
    submissionRecord = {};
    leadRecord = {};
    isLoading = false;
    reliefItems = [];
    reliefColumns;
    headings = {};
    helpText = {};
    moreInfoColumns = [];
    generalInformationFields=[];
    leadInformationFields=[];
    booleanColumns = [];
    errorMessage;
    setLeadId = false;
    formHash;
    isDuplicateLead = false;
    duplicateLeadRecord;
    moreInforomationId;
    minColumnWidth = 125;
    pardotIframe;
    pardotIframeReloaded = false;
    pardotURL;
    initializeResultsTable = false;
    resultsTable;
    existingLead = false;
    connectedCallback(){
        loadStyle(this, COVID19_Form_CustomCSS);
        loadStyle(this, 'https://cdn.datatables.net/v/dt/jq-3.3.1/dt-1.10.20/af-2.3.4/b-1.6.1/b-print-1.6.1/cr-1.5.2/fc-3.3.0/fh-3.1.6/kt-2.5.1/r-2.2.3/rg-1.1.1/rr-1.2.6/sc-2.0.1/sp-1.0.1/sl-1.3.1/datatables.min.css');
        loadScript(this, 'https://cdn.datatables.net/v/dt/jq-3.3.1/dt-1.10.20/af-2.3.4/b-1.6.1/b-print-1.6.1/cr-1.5.2/fc-3.3.0/fh-3.1.6/kt-2.5.1/r-2.2.3/rg-1.1.1/rr-1.2.6/sc-2.0.1/sp-1.0.1/sl-1.3.1/datatables.min.js')
        getMetadataHeadings().then((headings)=>{
            this.headings = JSON.parse(headings);
            if(this.headings.minColumnWidth){
                this.minColumnWidth = parseInt(this.headings.minColumnWidth.Heading__c);
            }
        });
        let promises = [];
        promises.push(getMetadataHelpText().then((helpText)=>{
            this.helpText = JSON.parse(helpText);
        }));
        promises.push(getFieldSets().then((fieldSetsJSON)=>{
            let fieldSets = JSON.parse(fieldSetsJSON);
            
            //Submission Fields - Used on General Information Page
            let newGeneralInformationFields = []
            fieldSets.submission.forEach((field)=>{
                newGeneralInformationFields.push({fieldPath: field.fieldPath, required: field.required});
            });
            this.generalInformationFields = newGeneralInformationFields;
            
            //Lead Fields - Used on Lead Information Page
            let newLeadInformationFields = []
            fieldSets.lead.forEach((field)=>{
                newLeadInformationFields.push({fieldPath: field.fieldPath, required: field.required});
            });
            this.leadInformationFields = newLeadInformationFields;
            
            //Relief Items - Used in Results Page
            let newReliefColumns = [];
            let newBooleanColumns = []
            fieldSets.reliefItems.forEach((field)=>{
                // newReliefColumns.push({label: field.label, fieldName: field.fieldPath, wrapText: 'true', type: 'text'});
                newReliefColumns.push({data: field.fieldPath, title: field.label, type: 'text', defaultContent: ""});
                if(field.type == 'boolean'){
                    newBooleanColumns.push(field.fieldPath);
                }
            });
            let newMoreInfoColumns = [];
            fieldSets.moreInfo.forEach((field)=>{
                newMoreInfoColumns.push({fieldPath: field.fieldPath});
            });
            
            // newReliefColumns.push({label: 'More Information', type: 'button', typeAttributes: {label: 'More Information', variant: 'Neutral', name: 'moreinformation',}, initialWidth: 165 })
            newReliefColumns.push({orderable:false, searchable: false, width: 165, data:null, render: function(data,type,row){return '<button class="slds-button slds-button_neutral" name="moreinformation">More Information</button>'}})
            this.reliefColumns = newReliefColumns;
            this.moreInfoColumns = newMoreInfoColumns;
            this.booleanColumns = newBooleanColumns;
        }));
        Promise.all(promises).then(()=>{
            let newGeneralInformationFields = []
            this.generalInformationFields.forEach((field)=>{
                if(this.helpText && this.helpText.COVID_19_Submission__c && this.helpText.COVID_19_Submission__c[field.fieldPath]){
                    field.helpText = this.helpText.COVID_19_Submission__c[field.fieldPath];
                    field.hasHelpText = true;
                }else{
                    field.hasHelpText = false;
                }
                newGeneralInformationFields.push(field);
            });
            this.generalInformationFields = newGeneralInformationFields;
            let newLeadInformationFields = [];
            this.leadInformationFields.forEach((field)=>{
                if(this.helpText && this.helpText.Lead && this.helpText.Lead[field.fieldPath]){
                    field.helpText = this.helpText.Lead[field.fieldPath];
                }
                newLeadInformationFields.push(field);
            });
            this.leadInformationFields = newLeadInformationFields;
        });
    }
    renderedCallback(){
        const resultsTableDiv = this.template.querySelector('.resultsTableDiv')
        if(this.initializeResultsTable == false && typeof jQuery != 'undefined' && resultsTableDiv){
            jQuery(resultsTableDiv).append('<table class="resultsTable display" style="width:100%" lwc:dom="manual"></table>')
        }
        const table = this.template.querySelector('.resultsTable');
        if(this.initializeResultsTable == false && table && typeof jQuery != 'undefined'){
            this.initializeResultsTable = true;
            this.resultsTable = jQuery(table).DataTable({
                destroy: true,
                data: this.reliefItems,
                columns: this.reliefColumns,
                paging: false,
                scrollY: 400,
                scrollX: (FORM_FACTOR == 'Large' ? false : '100vw'),
                scrollCollapse: true,
                dom:'lBftipr',
                buttons: {
                    dom: {
                      button: {
                        className: ''
                      }
                    },
                buttons: [
                    {
                        text: 'Print Results',
                            // extend: 'print',
                            exportOptions: {columns: ':not(:last)'},
                            className: 'slds-button slds-button_neutral',
                            self: this,
                            header: true,
                            action: function ( e, dt, node, config ) {
                                var data = dt.buttons.exportData(
                                    jQuery.extend( {decodeEntities: false}, config.exportOptions ) // XSS protection
                                );
                                var exportInfo = dt.buttons.exportInfo( config );
                                var columnClasses = dt
                                    .columns( config.exportOptions.columns )
                                    .flatten()
                                    .map( function (idx) {
                                        return dt.settings()[0].aoColumns[dt.column(idx).index()].sClass;
                                    } )
                                    .toArray();
                        
                                var addRow = function ( d, tag ) {
                                    var str = '<tr>';
                        
                                    for ( var i=0, ien=d.length ; i<ien ; i++ ) {
                                        // null and undefined aren't useful in the print output
                                        var dataOut = d[i] === null || d[i] === undefined ?
                                            '' :
                                            d[i];
                                        var classAttr = columnClasses[i] ?
                                            'class="'+columnClasses[i]+'"' :
                                            '';
                        
                                        str += '<'+tag+' '+classAttr+'>'+dataOut+'</'+tag+'>';
                                    }
                        
                                    return str + '</tr>';
                                };
                        
                                // Construct a table for printing
                                var html = '<table class="'+dt.table().node().className+'">';
                        
                                if ( config.header ) {
                                    html += '<thead>'+ addRow( data.header, 'th' ) +'</thead>';
                                }
                        
                                html += '<tbody>';
                                for ( var i=0, ien=data.body.length ; i<ien ; i++ ) {
                                    html += addRow( data.body[i], 'td' );
                                }
                                html += '</tbody>';
                        
                                if ( config.footer && data.footer ) {
                                    html += '<tfoot>'+ addRow( data.footer, 'th' ) +'</tfoot>';
                                }
                                html += '</table>';
                        
                                let content =
                                    '<h1>'+(exportInfo.title || '')+'</h1>'+
                                    '<div>'+(exportInfo.messageTop || '')+'</div>'+
                                    html+
                                    '<div>'+(exportInfo.messageBottom || '')+'</div>';
                                content = btoa(unescape(encodeURIComponent(content)));
                                var vfWindow = config.self.template.querySelector('iframe').contentWindow;
                                vfWindow.postMessage(content, config.self.headings.Community_URL.Heading__c);

                            }
                        }
                    ]
                }
            });
            let self = this;
            jQuery('.resultsTable tbody').on( 'click', 'button', function () {
                self.handleResultsAction(self.resultsTable.row( $(this).parents('tr') ).data());
            } );
        }
    }
    nextPage(){
        this.errorMessage = undefined;
        if(this.isUserLookup){
            this.template.querySelector('[data-id="userLookupSubmit"]').click();
        }else if(this.isGeneralInformation){
            this.template.querySelector('[data-id="generalSubmit"]').click();
        }else if(this.isLeadInformation){
            this.template.querySelector('[data-id="leadSubmit"]').click();
        }else if(this.currentPage < this.maxPages){
            this.currentPage++;
        }
    }
    previousPage(){
        this.errorMessage = undefined;
        if(this.isResultsPage){
            if(this.resultsTable){
                this.resultsTable.destroy();
                this.resultsTable = undefined;
            }
        }
        if(this.isClickInPage){//More Information Page
            this.initializeResultsTable = false;
        }
        if(this.currentPage > 1){
            this.currentPage-=(this.isResultsPage && this.existingLead ? 2 : 1);
        }
    }
    handleFieldChange(e){
        if(e.currentTarget.fieldName && e.currentTarget.dataset && e.currentTarget.dataset.object){
            this[e.currentTarget.dataset.object][e.currentTarget.fieldName] = e.target.value;
        }
    }
    handleCheckboxChange(e){
        if(e.currentTarget.name && e.currentTarget.dataset && e.currentTarget.dataset.object){
            this[e.currentTarget.dataset.object][e.currentTarget.name] = e.target.checked;
        }
    }
    handleUserLookupSubmit(e){
        e.preventDefault();
        if(this.userLookupRecord.agreeDisclaimer === true){
            this.isLoading = true;
            const fields = e.detail.fields;
            this.leadRecord.Email = fields.Email;
            this.leadInformationFields.forEach((field)=>{
                if(field.fieldPath == 'Email'){
                    field.value = fields.Email;
                }
            })
            getCheckExistingLead({email:fields.Email}).then((resultsJSON)=>{
                const results = JSON.parse(resultsJSON);
                if(results.leadId){
                    this.existingLead = true;
                    this.setLeadId = false;
                    this.submissionRecord = results.submission || {};
                    this.leadRecord.Id = results.leadId;
                }else{
                    this.existingLead = false;
                    this.submissionRecord = {};
                    this.leadRecord.Id = undefined;
                }
                this.isLoading = false;
                this.currentPage++;
            });
        }else{
            this.template.querySelector('[data-id="agreeDisclaimerUserLookup"]').classList.add('slds-has-error');
            this.errorMessage = 'Complete all required fields before proceeding.';
        }
    }
    handleGeneralSubmit(e){
        e.preventDefault();
        if(this.submissionRecord.agreeDisclaimer === true){
            this.template.querySelector('[data-id="generalInformation"]').submit(e.detail.fields);
            this.isLoading = true;
        }else{
            this.template.querySelector('[data-id="agreeDisclaimer"]').classList.add('slds-has-error');
            this.errorMessage = 'Complete all required fields before proceeding.';
        }
    }
    handleGeneralSuccess(e){
        this.submissionRecord['Id'] = e.detail.id;
        this.isLoading = false;
        if(this.existingLead){
            this.handleLeadSuccess({leadId:this.leadRecord.Id, duplicateLead:false});
        }else{
            this.currentPage++;
        }
    }
    
    handleLeadSubmit(e){
        e.preventDefault();
        if(this.leadRecord.agreeDisclaimer === true){
            this.isLoading = true;
            const fields = e.detail.fields;
            let fieldsMap = new Map();
            for(let [key, value] of Object.entries(fields)){
                if(fields.hasOwnProperty(key)){
                    fieldsMap.set(key, value);
                }
            }
            this.leadInformationFields.forEach((field)=>{
                if (fieldsMap.has(field.fieldPath)) {
                    field.value = fieldsMap.get(field.fieldPath);
                }
            });
            if(this.isDuplicateLead && (this.leadRecord.LastName != this.duplicateLeadRecord.LastName || this.leadRecord.Email != this.duplicateLeadRecord.email)){
                this.leadRecord.Id = undefined;
                this.formHash = undefined;
            }
            if(this.leadRecord.Id){
                fields['Id'] = this.leadRecord.Id;
            }
            updateLead({leadParams: JSON.stringify(fields), hash: this.formHash}).then((result)=>{this.handleLeadSuccess(JSON.parse(result));}).catch((e)=>{console.log(e)});
        }else{
            this.template.querySelector('[data-id="agreeDisclaimerLead"]').classList.add('slds-has-error');
            this.errorMessage = 'Complete all required fields before proceeding.';
        }
    }
    handleLeadSuccess(input){
        if(input.error){
            this.errorMessage = input.error;
        }else{
            if(input.duplicateLead){
                this.isDuplicateLead = true;
                this.setLeadId = false;
                this.duplicateLeadRecord = JSON.parse(JSON.stringify(this.leadRecord));
            }
            if(input.duplicateLead !== true && this.isDuplicateLead === true){
                this.setLeadId = false;
                this.isDuplicateLead = false;
            }
            if(this.setLeadId !== true){
                const fields = {Id: this.submissionRecord.Id, Lead__c: input.leadId};
                this.setLeadId = true;
                updateRecord({fields});
                this.formHash = input.hash;
            }
            this.generatePardotURL();
            this.leadRecord['Id'] = input.leadId;
            this.isLoading = false;
            this.initializeResultsTable = false;
            this.fetchReliefItems();
        }
    }
    fetchReliefItems(){
        this.isLoading = true;
        getSaveReliefItems({inputParams:JSON.stringify(this.submissionRecord)}).then((reliefItems)=>{
            let newReliefItems = JSON.parse(reliefItems);
            this.booleanColumns.forEach((field)=>{
                newReliefItems.forEach((relief)=>{
                    relief[field] = relief[field] == true ? 'Yes' : 'No';
                })
            });
            this.reliefItems = newReliefItems;
            this.isLoading = false;
            this.currentPage+=(this.existingLead ? 2 : 1);;
        });
    }
    handleResultsAction(row){
        this.moreInforomationId = row.Id;
        if(this.resultsTable){
            this.resultsTable.destroy();
            this.resultsTable = undefined;
        }
        this.currentPage = this.maxPages+1;
    }
    generatePardotURL(){
        if(this.hasPardotURL == true){
            let newPardotURL = this.headings.Pardot_URL.Heading__c;
            for(let key in this.leadRecord){
                if(this.leadRecord.hasOwnProperty(key)){
                    let regex = new RegExp('\{'+key+'\}', 'ig');
                    newPardotURL = newPardotURL.replace(regex, encodeURI(this.leadRecord[key]));
                }
            }
            this.pardotURL = newPardotURL;
        }
    }
    printResults(){
        window.print();
    }
    // goToLast(){
    //     getSaveReliefItems({inputParams:JSON.stringify(this.submissionRecord)}).then((reliefItems)=>{
    //         let newReliefItems = JSON.parse(reliefItems);
    //         this.booleanColumns.forEach((field)=>{
    //             newReliefItems.forEach((relief)=>{
    //                 relief[field] = relief[field] == true ? 'Yes' : 'No';
    //             })
    //         });
    //         this.reliefItems = newReliefItems;
    //         this.isLoading = false;
    //         this.currentPage = 4;
    //     });
    // }
    get isFirstPage(){
        return this.currentPage === 1;
    }
    get isLastPage(){
        return this.currentPage >= this.maxPages
    }
    get isUserLookup(){
        return this.currentPage === 1;
    }
    get isGeneralInformation(){
        return this.currentPage === 2;
    }
    get isLeadInformation(){
        return this.currentPage === 3;
    }
    get isResultsPage(){
        return this.currentPage === 4;
    }
    get isClickInPage(){
        return this.currentPage === this.maxPages+1;
    }
    get nextButtonText(){
        return this.isLeadInformation ? 'Submit' : 'Next';
    }
    get previousButtonText(){
        return this.isClickInPage ? 'Back to Results' : 'Previous';
    }
    get userLookupHeading(){
        return this.headings.User_Lookup_Header ? this.headings.User_Lookup_Header.Heading__c : '';
    }
    get userLookupFooter(){
        return this.headings.User_Lookup_Footer ? this.headings.User_Lookup_Footer.Heading__c : '';
    }
    get generalInformationHeading(){
        return this.headings.General_Information_Header ? this.headings.General_Information_Header.Heading__c : '';
    }
    get formTitle(){
        return this.headings.Form_Title ? this.headings.Form_Title.Heading__c : '';
    }
    get generalInformationFooter(){
        return this.headings.General_Information_Footer ? this.headings.General_Information_Footer.Heading__c : '';
    }
    get leadInformationHeading(){
        return this.headings.Lead_Information_Heading ? this.headings.Lead_Information_Heading.Heading__c : '';
    }
    get leadInformationFooter(){
        return this.headings.Lead_Information_Footer ? this.headings.Lead_Information_Footer.Heading__c : '';
    }
    get resultsHeading(){
        return this.headings.Results_Heading ? this.headings.Results_Heading.Heading__c : '';
    }
    get showErrorMessage(){
        return this.errorMessage !== '' && this.errorMessage !== undefined && this.errorMessage !== null;
    }
    get hasPardotURL(){
        return (this.headings && this.headings.Pardot_URL && this.headings.Pardot_URL.Heading__c && this.existingLead === false) ? true : false; 
    }
    get keyDefinitionsLabel(){
        return this.headings.Key_Definitions ? this.headings.Key_Definitions.Heading__c : '';
    }
    get globalHeader(){
        return this.headings.Global_Header ? this.headings.Global_Header.Heading__c : '';
    }
    get keyDefinitionsLink(){
        return keyDefinitions;
    }

    get printIFrameURL(){
        return this.headings.Community_URL.Heading__c + '/apex/Covid19Printer'
    }

    get hasPrintURL(){
        return this.headings && this.headings.Community_URL ? true : false;
    }
}