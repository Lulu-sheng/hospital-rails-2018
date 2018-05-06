import React from 'react'
class MentorType extends React.Component { 
  render() {
    return (
      <div>
  <div className="Polaris-Labelled__LabelWrapper">
    <div className="Polaris-Label"><label id="TextField19Label" for="TextField19" className="Polaris-Label__Text">Personalized Message</label></div>
  </div>
  <div className="Polaris-TextField Polaris-TextField--multiline"><textarea id="TextField19" name="email_text" className="Polaris-TextField__Input" aria-labelledby="TextField19Label" aria-invalid="false"></textarea>
    <div className="Polaris-TextField__Backdrop"></div>
    <div aria-hidden="true" className="Polaris-TextField__Resizer">
      <div className="Polaris-TextField__DummyInput"><br/></div>
      <div className="Polaris-TextField__DummyInput"><br/></div>
    </div>
  </div>

      <div class="Polaris-Labelled__HelpText" id="TextField20HelpText">If a message is not provided, a custom email will be sent</div>
      </div>
    ); 
  }
}
export default MentorType
