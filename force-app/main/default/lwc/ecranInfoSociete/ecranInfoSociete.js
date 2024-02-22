import { LightningElement, api, wire } from "lwc";
import getExistingData from "@salesforce/apex/DataController.getOldData";

export default class EcranInfoSociete extends LightningElement {
  //  @track accounts;
  @api siret;
  existingData;
  @wire(getExistingData, { siret: "$siret" })
  wiredExistingData({ error, data }) {
    if (data) {
      this.existingData = data;
      // this.existingData =data.map((account, index) => ({
      //     ...account,
      //     visualPickerId: this.getVisualPickerId(index),
      //     BillingStreet:account.BillingStreet,
      //     BillingCity:account.BillingCity,
      //     BillingState:account.BillingState,
      //     BillingPostalCode:account.BillingPostalCode,
      //     BillingCountry:account.BillingCountry,
      //     CreatedDate:account.CreatedDate,
      //     Effectif_Max:account.Effectif_Max,
      //     Effectif_Min:account.Effectif_Min,
      //     Siret:account.Siret,
      //     SIREN:account.SIREN,
      //     Code_NAF:account.Code_NAF,
      // }));
    } else if (error) {
      console.error("Error fetching data: ", error);
      this.existingData = [];
    }
  }

  // @wire(getNewData)
  // wiredNewData({ error, data }) {
  //     if (data) {
  //         this.newData = data;
  //     } else if (error) {
  //         // Gérer l'erreur
  //     }
  // }

  getVisualPickerId(index) {
    return `visual-picker-${index}`;
  }
}
