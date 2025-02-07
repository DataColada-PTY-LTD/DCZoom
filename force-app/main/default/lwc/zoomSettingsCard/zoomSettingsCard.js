/******************************************************************************************************************
    Class Name  : SFZoom_SettingsController
    Description : This  is Child LWC responsible for saving configuration details for Salesforce and Zoom Integration.
    Date        : 02 Jan 2024.
    Author       : D. K. Sinha
*******************************************************************************************************************/
import { LightningElement, track, api } from 'lwc';

export default class ZoomSettingsCard extends LightningElement {

  //** Track variables for input fields
  @track zoomUrlValue = '';
  @track zoomUserEmailValue = '';
  @track siteURLValue = '';
  @track zoomAccUserIdValue = '';
  @track cryptoKeyValue = '';
  @track zoomApiPageSzValue = '';

  @track emailSenderNameValue = '';
  @track fromEmailAddValue = '';
  @track enforceLoginValue = false;
  @track thankEmailNotifyValue = false;
  @track shareSurveyLinkValue = false;
  @track shareRecUrlValue = false;

  @track minMeetDurationValue = '';
  @track maxMeetDurationValue = '';
  @track joinBeforeHostValue = false;
  @track startPartVideoValue = false;

  @track allowAttendesValue = false;
  @track byDefaultBroadValue = false;
  @track startVideoHostJoinValue = false;
  @track startVideoPaneJoinValue = false;

  //**  Flags to control template rendering
  @api credentials ;
  @api setting = false;
  @api notification = false;
  @api meeting = false;
  @api webinar = false;
  @api isEditMode = false;
  // @api configData;
 

  @api
  set configData(value) {
    if (value) {
      this._configData = value;
      this.initializeFields();
    }
  }

  get configData() {
    return this._configData;
  }
  
  
  get isDisabled() {
    return !this.isEditMode;
  }

  connectedCallback() { 
    
  }

  
  

  initializeFields() {
    console.log('configData===>:', JSON.stringify(this.configData));
    this.zoomUrlValue = this.configData.Zoom_URL__c ? this.configData.Zoom_URL__c : '';
    this.zoomUserEmailValue = this.configData.Zoom_Integration_User_Email__c ? this.configData.Zoom_Integration_User_Email__c : '';
    this.siteURLValue = this.configData.Site_URL__c ? this.configData.Site_URL__c : '';
    this.zoomAccUserIdValue = this.configData.Zoom_Account_User_Id__c ? this.configData.Zoom_Account_User_Id__c : '';
    this.cryptoKeyValue = this.configData.Crypto_Key__c ? this.configData.Crypto_Key__c : '';

    this.zoomApiPageSzValue = this.configData.Zoom_API_Page_Size__c ? this.configData.Zoom_API_Page_Size__c : '';
    this.emailSenderNameValue = this.configData.Email_Sender_Name__c ? this.configData.Email_Sender_Name__c : '';
    this.fromEmailAddValue = this.configData.From_Email_Address__c ? this.configData.From_Email_Address__c : '';
    this.enforceLoginValue = this.configData.Enforce_Login__c ? this.configData.Enforce_Login__c : false;
    this.thankEmailNotifyValue = this.configData.Send_Thank_you_email_notification__c ? this.configData.Send_Thank_you_email_notification__c : false;

    this.shareSurveyLinkValue = this.configData.Share_Survey_Link__c ? this.configData.Share_Survey_Link__c : false;
    this.shareRecUrlValue = this.configData.Share_Recording_URL__c ? this.configData.Share_Recording_URL__c : false;
    this.minMeetDurationValue = this.configData.Minimum_Meeting_Duration__c ? this.configData.Minimum_Meeting_Duration__c : '';
    this.maxMeetDurationValue = this.configData.Maximum_Meeting_Duration__c ? this.configData.Maximum_Meeting_Duration__c : '';
    this.joinBeforeHostValue = this.configData.Join_Before_Host__c ? this.configData.Join_Before_Host__c : false;

    this.startPartVideoValue = this.configData.Start_Participant_Video_on_Join__c ? this.configData.Start_Participant_Video_on_Join__c : false;
    this.allowAttendesValue = this.configData.Allow_Multiple_Devices__c ? this.configData.Allow_Multiple_Devices__c : false;
    this.byDefaultBroadValue = this.configData.Host_Video__c ? this.configData.Host_Video__c : false;
    this.startVideoHostJoinValue = this.configData.HD_Video__c ? this.configData.HD_Video__c : false;
    this.startVideoPaneJoinValue = this.configData.Panelist_Video__c ? this.configData.Panelist_Video__c : false;
    // this.storeOriginalValues();
    
  }

  handleInputClick(event) {
    const inputName = event.target.name;
    console.log(`Input clicked: ${inputName}`);

    // Perform specific actions based on the input name
    switch (inputName) {
      case 'zoomUrl':
        console.log('Zoom URL field clicked');
        break;
      case 'zoomEmail':
        console.log('Zoom Email field clicked');
        break;
      case 'siteUrl':
        console.log('Site URL field clicked');
        break;
      default:
        console.log('Other field clicked');
    }
  }
  handleInputchange(event) {
    const fieldName = event.target.name;
    const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;

    switch (fieldName) {
      case 'zoomUrl':
        this.zoomUrlValue = value;
        break;
      case 'zoomUserEmail':
        this.zoomUserEmailValue = value;
        break;
      case 'siteURL':
        this.siteURLValue = value;
        break;
      case 'zoomAccUserId':
        this.zoomAccUserIdValue = value;
        break;
      case 'cryptoKey':
        this.cryptoKeyValue = value;
        break;
      case 'zoomApiPageSz':
        this.zoomApiPageSzValue = value;
        break;
      case 'emailSenderName':
        this.emailSenderNameValue = value;
        break;
      case 'fromEmailAdd':
        this.fromEmailAddValue = value;
        break;
      case 'enforceLogin':
        this.enforceLoginValue = value;
        break;
      case 'thankEmailNotify':
        this.thankEmailNotifyValue = value;
        break;
      case 'shareSurveyLink':
        this.shareSurveyLinkValue = value;
        break;
      case 'shareRecUrl':
        this.shareRecUrlValue = value;
        break;
      case 'minMeetDuration':
        this.minMeetDurationValue = value;
        break;
      case 'maxMeetDuration':
        this.maxMeetDurationValue = value;
        break;
      case 'joinBeforeHost':
        this.joinBeforeHostValue = value;
        break;
      case 'startPartVideo':
        this.startPartVideoValue = value;
        break;
      case 'allowAttendes':
        this.allowAttendesValue = value;
        break;
      case 'byDefaultBroad':
        this.byDefaultBroadValue = value;
        break;
      case 'startVideoHostJoin':
        this.startVideoHostJoinValue = value;
        break;
      case 'startVideoPaneJoin':
        this.startVideoPaneJoinValue = value;
        break;
      default:
        console.error('Unknown field:', fieldName);
    }

    //** Log the field name and its updated value
    console.log(`Field updated: ${fieldName}, Value: ${value}`);
  }


  @api
  validateInputsAndGetValues() {
    const inputs = this.template.querySelectorAll('lightning-input');
    let isValid = true;
    const values = {};

    inputs.forEach((input) => {
      // **Capture input values
      if (input.type === 'checkbox' || input.type === 'toggle') {
        values[input.name] = input.checked;
      } else {
        values[input.name] = input.value;
      }

      // **Trigger validation only for required fields
      if (input.required) {
        if (!input.reportValidity()) {
          isValid = false;
          console.log(`Validation failed for required field: ${input.name}`);
        }
      }

      console.log('Captured value for:', input.name, '=>', values[input.name]);
    });

    return { isValid, values };
  }

  @api
  setValuesFromData() {
    this.initializeFields();
  }
}