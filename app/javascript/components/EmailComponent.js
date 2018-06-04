import React from 'react'
class EmailComponent extends React.Component { 
  render() {
    return (
      <div>
  <div className="Polaris-Labelled__LabelWrapper">
    <div className="Polaris-Label"><label id="TextField19Label" htmlFor="TextField19" className="Polaris-Label__Text">{I18n.t("patients.form.personalized_message")}</label></div>
  </div>
  <div className="Polaris-TextField Polaris-TextField--multiline"><textarea id="TextField19" name="email_text" className="Polaris-TextField__Input" aria-labelledby="TextField19Label" aria-invalid="false"></textarea>
    <div className="Polaris-TextField__Backdrop"></div>
    <div aria-hidden="true" className="Polaris-TextField__Resizer">
      <div className="Polaris-TextField__DummyInput"><br/></div>
      <div className="Polaris-TextField__DummyInput"><br/></div>
    </div>
  </div>

      <div className="Polaris-Labelled__HelpText" id="TextField20HelpText">{I18n.t("patients.form.text_box_explanation")}</div>
      </div>
    ); 
  }
}
export default EmailComponent
