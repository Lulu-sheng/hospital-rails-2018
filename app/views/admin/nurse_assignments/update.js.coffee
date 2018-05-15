your_patients = document.getElementById("your-patients") 
your_patients.innerHTML = "<%= j render_if_have_patients @user_nurse, 'admin/partials/your_patients', {user: @user_nurse}%>"


notice = document.getElementsByClassName("banner-style")[0]
if notice
  notice.style.display = "none"

main = document.getElementsByTagName("main")[0]
main.innerHTML = "<%= j render template: 'admin/patients/index', layout: false %>"
