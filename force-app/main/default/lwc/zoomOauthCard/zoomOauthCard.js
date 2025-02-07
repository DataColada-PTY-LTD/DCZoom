/******************************************************************************************************************
    Class Name  : SFZoom_SettingsController
    Description : This  is Child LWC responsible for saving configuration details for Salesforce and Zoom Integration.
    Date        : 02 Jan 2024.
    Author       : D. K. Sinha
*******************************************************************************************************************/
import { LightningElement, api, track } from 'lwc';
import getOAuthTestResponse from '@salesforce/apex/SFZoom_SettingsController.getOAuthTestResponse';

export default class ZoomOauthCard extends LightningElement {
  @api accountIdValue = '';
  @api clientIdValue = '';
  @api clientSecretValue = '';
  @api webhookSecretTokenValue = '';
  @api enableOAuthValue = false;

  @track isDisabled = true;
  @track showAccountId = true;
  @track showClientId = true;
  @track showClientSecret = true;
  @track showWebhookToken = true;
  @track testResult;
  @track serverResponse;
  @api configData;
  @api isEditMode = false;

  get isDisabledButton() {
    return !this.isEditMode;
  }
  connectedCallback() {
    console.log('enableOAuthValue===> :', this.enableOAuthValue);
    console.log('configData:', JSON.stringify(this.configData));
    this.enableOAuthValue = this.configData.Oauth_Connection__c ? this.configData.Oauth_Connection__c : false;
    this.accountIdValue = this.configData.Oauth_Account_Id__c ? this.configData.Oauth_Account_Id__c : '';
    this.clientSecretValue = this.configData.Oauth_client_secret__c ? this.configData.Oauth_client_secret__c : '';
    this.clientIdValue = this.configData.Oauth_Client_Id__c ? this.configData.Oauth_Client_Id__c : '';
    this.webhookSecretTokenValue = this.configData.Zoom_Webhook_Secret_Token__c ? this.configData.Zoom_Webhook_Secret_Token__c : '';
    // this.storeOriginalValues();
  }
  //** Computed properties for input types and icons
  get accountIdInputType() {
    return this.showAccountId ? 'password' : 'text';
  }
  get clientIdInputType() {
    return this.showClientId ? 'password' : 'text';
  }

  get clientSecretInputType() {
    return this.showClientSecret ? 'password' : 'text';
  }

  get webhookTokenInputType() {
    return this.showWebhookToken ? 'password' : 'text';
  }

  get accountIdIconName() {
    return this.showAccountId ? 'utility:hide' : 'utility:preview';
  }
  get clientIdIconName() {
    return this.showClientId ? 'utility:hide' : 'utility:preview';
  }
  get clientSecretIconName() {
    return this.showClientSecret ? 'utility:hide' : 'utility:preview';
  }

  get webhookTokenIconName() {
    return this.showWebhookToken ? 'utility:hide' : 'utility:preview';
  }

  get testResultClass() {
    return this.testResult === 'PASS' ? 'slds-text-color_success' : 'slds-text-color_error';
  }

  //** Handlers for toggling visibility

  toggleAccountIdVisibility() {
    this.showAccountId = !this.showAccountId;
  }
  toggleClientIdVisibility() {
    console.log('toggleClientIdVisibility==');
    this.showClientId = !this.showClientId;
  }

  toggleClientSecretVisibility() {
    this.showClientSecret = !this.showClientSecret;
  }

  toggleWebhookTokenVisibility() {
    this.showWebhookToken = !this.showWebhookToken;
  }

  handleInputChange(event) {
    const fieldName = event.target.name;
    const value = event.target.type === 'checkbox' || event.target.type === 'toggle' ? event.target.checked : event.target.value;

    switch (fieldName) {
      case 'enableOAuth':
        console.log('value=== Enable Aouth:', value);
        this.enableOAuthValue = value;
        this.isDisabled = !value;
        break;
      case 'accountId':
        this.accountIdValue = value;
        break;
      case 'clientId':
        this.clientIdValue = value;
        break;
      case 'clientSecret':
        this.clientSecretValue = value;
        break;
      case 'webhookSecretToken':
        this.webhookSecretTokenValue = value;
        break;
      default:
        break;
    }
    console.log('this.enableOAuthValue:', this.enableOAuthValue);
    console.log('this.accountIdValue:', this.accountIdValue);
    console.log('this.clientIdValue:', this.clientIdValue);
    console.log('this.clientSecretValue:', this.clientSecretValue);
    console.log('this.webhookSecretTokenValue:', this.webhookSecretTokenValue);
    console.log('value:', value);
  }

    /**
     * History:
     * 13-01-2025 datacolada  , connecting to the auth server and testing if we can get a token
     */
  startOAuthTest() {
      this.serverResponse = null;
      this.testResult = null;

      getOAuthTestResponse().then((result) => {
          this.serverResponse = result;
          this.testResult = result.includes('Error') ? 'FAIL' : 'PASS' ;
      })
      .catch((error) => {
          this.testResult = 'Fail';
          this.serverResponse = 'Error: ' + error.body.message;
    });
  }

  @api
  validateInputsAndGetValues() {
    const inputs = this.template.querySelectorAll('lightning-input ,input');
    let isValid = true;
    const values = {};
    console.log('inputs=====>:', JSON.stringify(inputs));
    inputs.forEach((input) => {
      console.log('input====>:', input);
      console.log('input.name====>:', input.name);
      console.log('input.value====>:', input.value);
      if (!input.reportValidity()) {
        isValid = false;
      }
      //**  Capture input values by their `name` attribute
      // values[input.name] = input.value;
      if (input.type === 'checkbox' || input.type === 'toggle') {
        values[input.name] = input.checked; 
      } else {
        values[input.name] = input.value;
      }
      console.log('Captured value for:', input.name, '=>', values[input.name]);
    });

    return { isValid, values };
  }

  @api
  setValuesFromData() {
    this.connectedCallback();
  }
}
