import { LightningElement, api } from "lwc";

const c_textAlign = "slds-text-align_center";
export default class CardShowMessage extends LightningElement {
  //var for icon
  icon;
  @api iconCategory;
  @api iconName;
  @api iconColor;
  @api iconBg;
  //var for message and background
  @api message;
  @api theme;
  //var for padding
  @api paddingVertical;
  @api paddingHorizontal;
  //var for text
  @api centerText;
  @api bolderText;

  //
  renderedCallback() {
    //var for dom
    let domMessage = this.template.querySelector(".message");
    let domMessageText = this.template.querySelector(".message-text");
    // let styleLightning = this.template.querySelector("lightning-card").style;
    let styleIcon = this.template.querySelector("lightning-icon").style;

    //Replace \n white <br/> in show message
    if (this.message) {
      while (this.message.includes("\\n")) {
        // eslint-disable-next-line @lwc/lwc/no-api-reassignments
        this.message = this.message.replace("\\n", "<br/>");
      }
    }

    //Category and Name icon
    this.icon = this.iconCategory + this.iconName;

    //Set icon color
    styleIcon.setProperty("--iconColor", this.iconColor);
    styleIcon.setProperty("--iconBg", this.iconBg);

    //Set theme background
    this.template.querySelector(".message").classList.add(this.theme);

    //Set padding Vertical
    domMessageText.classList.add(this.paddingVertical);

    //Set padding Horizontal
    domMessageText.classList.add(this.paddingHorizontal);

    //set bolder text
    // eslint-disable-next-line no-unused-expressions
    this.bolderText
      ? (domMessage.style.fontWeight = "bold")
      : (domMessage.style.fontWeight = "");

    //Set text align
    // eslint-disable-next-line no-unused-expressions
    this.centerText
      ? domMessageText.classList.add(c_textAlign)
      : domMessage.classList.remove(c_textAlign);
  }
}
