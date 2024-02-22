import { LightningElement, api, track } from "lwc";

export default class ModalSecondaire extends LightningElement {
  nextComponent = false;
  @track options = [
    { label: "Enrichir la société", value: "option1" },
    { label: "Récupérer tous les établissements liés", value: "option2" }
  ];
  @track value = "";
  @api siren;
  @api siret;
  //  @track isEnrichirPappersModalOpen = false;

  handleSuivant() {
    this.nextComponent = true;
  }

  handleCloseModal() {
    this.isEnrichirPappersModalOpen = false;
  }

  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title,
        message,
        variant
      })
    );
  }
}
