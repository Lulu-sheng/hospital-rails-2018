your_patients = document.getElementById("your-patients") 
your_patients.innerHTML = "<%= j render_if_have_patients @user_nurse, 'partials/your_patients', {user: @user_nurse, new_patient_name: @new_patient_name}%>"


notice = document.getElementsByClassName("banner-style")[0]
if notice
  notice.style.display = "none"

main = document.getElementsByTagName("main")[0]
main.innerHTML = "<%= j render template: 'patients/index', layout: false %>"
