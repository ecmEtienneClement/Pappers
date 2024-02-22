import { LightningElement, api, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import SirenField from "@salesforce/schema/Account.SIREN__c";
import SiretField from "@salesforce/schema/Account.Siret__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const FIELDS = [SirenField, SiretField];

export default class StartSirenSiret extends LightningElement {
  @api recordId;
  siren;
  siret;
  nextComponent;
  pappersBtn;

  connectedCallback() {
    this.nextComponent = false;
    this.pappersBtn = true;
  }

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  accountRecord({ error, data }) {
    if (data) {
      this.siren = getFieldValue(data, SirenField);
      this.siret = getFieldValue(data, SiretField);
      this.verifySirenAndSiret();
    } else if (error) {
      this.showToast(
        "Erreur",
        "Erreur lors de la récupération des données de compte.",
        "error"
      );
    }
  }

  verifySirenAndSiret() {
    if (this.siren === null && this.siret === null) {
      this.pappersBtn = false;
      this.showToast(
        "Information",
        "Ce compte n'a pas de SIREN ni SIRET ",
        "warning"
      );
    }
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

  handleNextComponent() {
    this.nextComponent = true;
  }
}
