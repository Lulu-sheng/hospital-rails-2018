module ApplicationHelper
  def render_if_have_patients(user, partial, locals)
    unless user.nurse_assignments.where(end_date:nil).empty?
      render partial: partial, locals: locals
    end
  end
end
