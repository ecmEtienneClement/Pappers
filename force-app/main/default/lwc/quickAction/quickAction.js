import { LightningElement, api, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import SirenField from "@salesforce/schema/Account.SIREN__c";
import SiretField from "@salesforce/schema/Account.Siret__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const FIELDS = [SirenField, SiretField];

export default class QuickAction extends LightningElement {
  @api recordId;
  siren;
  siret;
  nextComponent = false;
  // isModalOpen = false;
  // isSecondModalOpen = false;

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  accountRecord({ error, data }) {
    if (data) {
      this.siren = getFieldValue(data, SirenField);
      this.siret = getFieldValue(data, SiretField);
      this.notifyUser();
    } else if (error) {
      this.showToast(
        "Erreur",
        "Erreur lors de la récupération des données de compte.",
        "error"
      );
    }
  }
  connectedCallback() {
    console.log("iciiiiii");
  }
  notifyUser() {
    if (this.siren && this.siret) {
      this.showToast("Succès", "SIREN et SIRET trouvés.", "success");
    } else if (this.siren) {
      this.showToast("Succès", "SIREN trouvé.", "success");
    } else if (this.siret) {
      this.showToast("Succès", "SIRET trouvé.", "success");
    } else {
      this.showToast(
        "Information",
        "Ni SIREN ni SIRET n'ont été trouvés.",
        "warning"
      );
    }
  }

  openModal() {
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
  }

  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
      })
    );
  }

  handleCloseNextComponent() {
    this.nextComponent = false;
  }

  handleConfirmModalSecondaire(event) {
    const selectedOption = event.detail.selectedOption;
    // Traitez l'option sélectionnée
    this.isSecondModalOpen = false;
  }
  handleNextComponent() {
    this.nextComponent = true;
  }
}
