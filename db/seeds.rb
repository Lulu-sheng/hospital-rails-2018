# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

NurseAssignment.destroy_all
Patient.destroy_all
EmployeeRecord.destroy_all
Doctor.destroy_all
Nurse.destroy_all
Room.destroy_all

# Create doctors and establish any mentorship associations
doctor1 = Doctor.create(specialty:'family', received_license:'20121212')
doctor2 = doctor1.student_doctors.build(specialty:'pediatrics', received_license:'20171212')
doctor2.save
doctor3 = doctor1.student_doctors.build(specialty:'plastic', received_license:'20161212')
doctor3.save

# Create employee records corresponding to the doctors
doctor1record = doctor1.build_employee_record(email: "lulu@gmail.com", salary: 300000, name:"Lulu Sheng")
doctor1record.save
doctor2record = doctor2.build_employee_record(email: "justin@gmail.com", salary: 200000, name: "Justin Wong")
doctor2record.save
doctor3record = doctor3.build_employee_record(email: "emily@gmail.com", salary: 100000, name:"Emily Smith")
doctor3record.save

# Create rooms
room1 = Room.create(wing:'north', floor:2, number:215, vip: true)
room2 = Room.create(wing:'south', floor:3, number:325, vip: true)
room3 = Room.create(wing:'north', floor:2, number:207, vip: true)
room4 = Room.create(wing:'west', floor:2, number:217, vip: true)

# Create nurses
nurse1 = Nurse.create(night_shift:true, hours_per_week:25, date_of_certification:'20180101')
nurse2 = Nurse.create(night_shift:false, hours_per_week:15, date_of_certification:'20170101')
nurse3 = Nurse.create(night_shift:true, hours_per_week:35, date_of_certification:'20160101')
nurse4 = Nurse.create(night_shift:false, hours_per_week:40, date_of_certification:'20150101')

# Create employee records corresponding to each nurse
nurse1record = nurse1.build_employee_record(email: "bob@gmail.com", salary: 100000, name:"Bob Joe")
nurse1record.save
nurse2record = nurse2.build_employee_record(email: "grace@gmail.com", salary: 80000, name: "Grace Jane")
nurse2record.save
nurse3record = nurse3.build_employee_record(email: "helen@gmail.com", salary: 90000, name:"Helen Gupta")
nurse3record.save
nurse4record = nurse4.build_employee_record(email: "jimmy@gmail.com", salary: 70000, name:"Jimmy Zhang")
nurse4record.save

# Create patients and assign them to doctors and rooms
patient1 = doctor1.patients.build(name: 'Keith Hunts', admitted_on:'20180101', emergency_contact:'Stephanie Myers', blood_type:'O', room: room1)
# patient1 = doctor1.patients.build(name: 'Keith Hunts', admitted_on:'20180101', emergency_contact:'Stephanie Myers', blood_type:'O', room_id: 2)
patient1.save
patient2 = doctor2.patients.build(name: 'Tessa Tran', admitted_on:'20180223', emergency_contact:'Eliza Tran', blood_type:'AB', room: room2)
patient2.save
patient3 = doctor2.patients.build(name: 'Mark Matthews', admitted_on:'20180302', emergency_contact:'Melissa Matthews', blood_type:'B', room: room3)
patient3.save

# Set up nurse to patient assignment
NurseAssignment.create(patient: patient1, nurse: nurse1, start_date: '20150101', end_date: '')
NurseAssignment.create(patient: patient1, nurse: nurse2, start_date: '20150101', end_date: '')
NurseAssignment.create(patient: patient2, nurse: nurse3, start_date: '20150101', end_date: '')
NurseAssignment.create(patient: patient3, nurse: nurse4, start_date: '20150101', end_date: '')
# d.student_doctors.select(:specialty).find(8) and NOT .find(8).select(:specialty)

