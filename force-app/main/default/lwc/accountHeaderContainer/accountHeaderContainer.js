import { LightningElement } from "lwc";

export default class AccountHeaderContainer extends LightningElement {
  //
  search(evt) {
    let detail = evt.target.value;
    if (!detail) {
      // Cette partie restaur les accounts apres la recherche si le user efface les params de recherche
      detail = false;
    }
    const customeEvt = new CustomEvent("search", {
      detail
    });
    this.dispatchEvent(customeEvt);
  }
}
