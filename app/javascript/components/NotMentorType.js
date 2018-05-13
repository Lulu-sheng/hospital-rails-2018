import React from 'react'
import NotEmailComponent from './NotEmailComponent'
import EmailComponent from './EmailComponent'

class NotMentorType extends React.Component { 
  constructor(props) {
    super(props);
    this.onEmailPressed = this.onEmailPressed.bind(this); 
    // this is set to the object when in the context of a constructor,
    // now bind the method to this object
    this.state = { email: null }; // initialize our state
  }

  onEmailPressed(event) {
    console.log(event.target.value);
    this.setState({ email: event.target.value });
  }

  render() {
    let EmailTextComponent = NotEmailComponent;
    if (this.state.email == 1)
      EmailTextComponent = EmailComponent;

    return (
      <div>
      <div className="Polaris-Banner Polaris-Banner--statusInfo" tabIndex="0" role="status" aria-live="polite" aria-labelledby="Banner5Heading" aria-describedby="Banner5Content">
  <div className="Polaris-Banner__Ribbon"><span className="Polaris-Icon Polaris-Icon--colorTealDark Polaris-Icon--hasBackdrop"><svg className="Polaris-Icon__Svg" viewBox="0 0 20 20"><g fillRule="evenodd"><circle cx="10" cy="10" r="9" fill="currentColor"></circle><path d="M10 0C4.486 0 0 4.486 0 10s4.486 10 10 10 10-4.486 10-10S15.514 0 10 0m0 18c-4.411 0-8-3.589-8-8s3.589-8 8-8 8 3.589 8 8-3.589 8-8 8m1-5v-3a1 1 0 0 0-1-1H9a1 1 0 1 0 0 2v3a1 1 0 0 0 1 1h1a1 1 0 1 0 0-2m-1-5.9a1.1 1.1 0 1 0 0-2.2 1.1 1.1 0 0 0 0 2.2"></path></g></svg></span></div>
  <div>
    <div className="Polaris-Banner__Heading" id="Banner5Heading">
      <p className="Polaris-Heading">{I18n.t("patients.form.student_notification_html")}</p>
    </div>
    <div className="Polaris-Banner__Content" id="Banner5Content">
      <p>{I18n.t("patients.form.confirmation_blurb_html")}</p>
      
      <label className="Polaris-Choice" htmlFor="Checkbox1">
      <span className="Polaris-Choice__Control">
      <div className="Polaris-Checkbox">
      <input onChange={this.onEmailPressed} id="Checkbox1" type="checkbox" className="Polaris-Checkbox__Input" name="email_check" aria-invalid="false" role="checkbox" aria-checked="false" value="1"/><div className="Polaris-Checkbox__Backdrop"></div><div className="Polaris-Checkbox__Icon"><span className="Polaris-Icon"><svg className="Polaris-Icon__Svg" viewBox="0 0 20 20"><g fillRule="evenodd"><path d="M8.315 13.859l-3.182-3.417a.506.506 0 0 1 0-.684l.643-.683a.437.437 0 0 1 .642 0l2.22 2.393 4.942-5.327a.437.437 0 0 1 .643 0l.643.684a.504.504 0 0 1 0 .683l-5.91 6.35a.437.437 0 0 1-.642 0"></path><path d="M8.315 13.859l-3.182-3.417a.506.506 0 0 1 0-.684l.643-.683a.437.437 0 0 1 .642 0l2.22 2.393 4.942-5.327a.437.437 0 0 1 .643 0l.643.684a.504.504 0 0 1 0 .683l-5.91 6.35a.437.437 0 0 1-.642 0"></path></g></svg></span></div></div></span><span className="Polaris-Choice__Label">{I18n.t("patients.form.compose")}</span></label>

      <EmailTextComponent />
    </div>
  </div>
</div>
      </div>
    ); 
  }
}
export default NotMentorType
