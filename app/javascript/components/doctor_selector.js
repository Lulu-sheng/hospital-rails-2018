import React from 'react'

import NotMentorType from './NotMentorType'
import MentorType from './MentorType'

class DoctorSelector extends React.Component { 
  // constructor is fired before the event handler will be fired
  constructor(props) {
    super(props);
    this.onDoctorSelected = this.onDoctorSelected.bind(this); 
    // this is set to the object when in the context of a constructor,
    // now bind the method to this object
    this.state = { selectedDoctorType: null }; // initialize our state
  }

  onDoctorSelected(event) {
    this.setState({ selectedDoctorType: event.target.value });
  }
  render() {
    const options = this.props.doctors.map((doctor) => <option key={doctor.value.toString()} value={doctor.value}>{doctor.name}</option>);

    let DoctorTypeCustomComponent = MentorType;
    for (let doctor of this.props.doctors) {
      if (doctor.value == this.state.selectedDoctorType && doctor.is_student)
        DoctorTypeCustomComponent = NotMentorType
    }

    return (
      <div>
      <select onChange={this.onDoctorSelected} name="patient[doctor_id]">
      {options}
      </select>
      <DoctorTypeCustomComponent />
      </div>
    );
  }
}

export default DoctorSelector
