class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CurrentUser

  # instantiate @user_nurse
  before_action :set_user
  before_action :authorize
  before_action :set_locale

  # implement a number of default options that all
  # url_for-based methods will use
  def default_url_options
    { locale: I18n.locale }
  end

  protected
  def set_locale
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale]) 
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
          "#{params[:locale]} translation not available"
        logger.error flash.now[:notice] 
      end
    end
  end

  def authorize
    if session[:nurse_id].nil?
      flash[:warning] = 'Please log in'
      redirect_to login_url
    end
  end
end
