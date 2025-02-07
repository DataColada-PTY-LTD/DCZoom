/******************************************************************************************************************
    Class Name  : SFZoom_SettingsController
    Description : This  is Parent LWC responsible for saving configuration details for Salesforce and Zoom Integration.
    Date        : 02 Jan 2024.
    Author       : D. K. Sinha
*******************************************************************************************************************/
import { LightningElement, track } from 'lwc';
import createZoomConfigurationSettings from '@salesforce/apex/SFZoom_SettingsController.createZoomConfigurationSettings';
import getZoomConfigurationSettings from '@salesforce/apex/SFZoom_SettingsController.getZoomConfigurationSettings';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ZoomSettingsPanel extends LightningElement {
  @track currentContent = 'Credentials';
  @track selectedItem = 'credentials';
  @track isCredentials = true;
  @track isSetting = false;
  @track isNotification = false;
  @track isMeeting = false;
  @track isWebinar = false;
  @track showButtons = false;
  @track isEditMode = false;
  @track isOAuth = false;
  @track zoomConfigData = {};
  
  showToast(title, message, variant) {
    const toastEvent = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant,
    });
    this.dispatchEvent(toastEvent);
  }
  
  connectedCallback() {
    console.log('isCredentials:', this.isCredentials);
    //** Fetch Zoom configuration settings when the component loads
    getZoomConfigurationSettings()
      .then((data) => {
        if (data) {
          this.zoomConfigData = data;
          console.log('Zoom Configuration Settings:', JSON.stringify(this.zoomConfigData));
        }
      })
      .catch((error) => {
        console.log('Error fetching Zoom Configuration Settings:', error);
      });
  }

  handleSelect(event) {
    const selectedName = event.detail.name;
    this.selectedItem = selectedName;
    //**  Update currentContent based on the selected item
    this.currentContent = selectedName.charAt(0).toUpperCase() + selectedName.slice(1);
    this.isOAuth = selectedName === 'OAuth';
    //**  Update visibility flags for child component
    this.isCredentials = selectedName === 'credentials';
    this.isSetting = selectedName === 'setting';
    this.isNotification = selectedName === 'notification';
    this.isMeeting = selectedName === 'meeting';
    this.isWebinar = selectedName === 'webinar';
  }

  // **Method to apply class conditionally based on selected item
  get credentialsClass() {
    return this.selectedItem === 'credentials' ? 'selected-item vertical-panel-text-color' : '';
  }

  get oAuthClass() {
    return this.selectedItem === 'OAuth' ? 'selected-item vertical-panel-text-color' : '';
  }

  get settingsClass() {
    return this.selectedItem === 'setting' ? 'selected-item vertical-panel-text-color' : '';
  }

  get notificationClass() {
    return this.selectedItem === 'notification' ? 'selected-item vertical-panel-text-color' : '';
  }

  get meetingClass() {
    return this.selectedItem === 'meeting' ? 'selected-item vertical-panel-text-color' : '';
  }
  get webinarClass() {
    return this.selectedItem === 'webinar' ? 'selected-item vertical-panel-text-color' : '';
  }


  handleEdit() {
    this.showButtons = true;
    this.isEditMode = true;
  }
  
  handleCancel() {
    this.showButtons = false;
    this.isEditMode = false;

    const childComponents = this.template.querySelectorAll('c-zoom-settings-card, c-zoom-oauth-card');

    // ** Reset each child component's inputs using the original data from the Apex controller
    childComponents.forEach((child) => {
      if (child) {
        child.setValuesFromData();
      }
    });
  }


  
  handleSave() {

    // ** Query all child components
    const childComponents = this.template.querySelectorAll('c-zoom-settings-card, c-zoom-oauth-card');

    let isAllValid = true;
    const allValues = {};

    childComponents.forEach((child) => {
      if (child) {
        const { isValid, values } = child.validateInputsAndGetValues();

        if (isValid) {
          console.log('Inputs are valid for child:', values);
          // ** Merge child values into allValues
          Object.assign(allValues, values);
        } else {
          console.log('Validation failed in a child component.');
          // ** Mark as invalid if any child fails validation
          isAllValid = false; 
        }
      }
    });

    if (isAllValid) {
      // ** If all validations pass, proceed to save and exit edit mode
      this.isEditMode = false;
      this.showButtons = false;

      console.log('All inputs are valid, combined values:', allValues);
      console.log('All inputs are valid, combined values:', JSON.stringify(allValues));
      createZoomConfigurationSettings({ inputValues: allValues })
        .then(result => {
          console.log('result====>:', result);
          if (result == true) {
            this.showToast('Success', 'Settings saved successfully!', 'success');
          }else{
            this.showToast('Error', 'Error saving record: ', 'error');
          }
         
        })
        .catch(error => {
          // this.showToast('Error', error.body.message, 'error');
          console.log('Error while removing Learner (updating end date of Program Enrolment) records: ', JSON.stringify(error.body));
          this.showToast('Error', 'Error saving record: ' + error.body.message, 'error');
        });
     
    } else {
      this.isEditMode = true;
      this.showButtons = true;
      this.showToast('Error', 'Please fill in all required fields.', 'error');
      console.log('Validation failed in one or more child components.');
      
    }
  }

}