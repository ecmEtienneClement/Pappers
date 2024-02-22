import LightningModal from "lightning/modal";
import { api } from "lwc";

export default class ModalFindAccount extends LightningModal {
  @api account;
  nameSiret;
  connectedCallback() {
    if (this.account) {
      this.nameSiret =
        this.account.BillingAddress.country + " " + this.account.Siret__c;
    }
  }
  //
  handleClick() {
    this.close("bien");
  }
}
