class ApplicationController < ActionController::Base

  include SimpleCaptcha::ControllerHelpers

  protect_from_forgery
  after_filter :event_user
  before_filter :set_locale

  private
  # For gem 'devise' (after 'login/logout' path)
  def after_sign_out_path_for(resource_or_scope)
    if resource_class == User
      Resque.enqueue(UserEvents,
                     {user_id: current_user.id,
                      kind: 'sign_out',
                      kind_id: current_user.id
                     })
      root_path
    else
      root_path
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_class == AdminUser
      admin_dashboard_path
    else
      Resque.enqueue(UserEvents,
                     {user_id: current_user.id,
                      kind: 'sign_in',
                      kind_id: current_user.id
                     })
      categories_path
    end
  end

  def event_user
    if !!current_user
      if 'index show'.include?(params[:action].to_s)
        Resque.enqueue(UserEventNavigation,
                       {url: request.original_url.to_s,
                        user_id: current_user.id.to_s,
                        created_at: DateTime.now
                       })
      end
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    if I18n.locale == I18n.default_locale
      return {locale: nil}
    else
      return {locale: I18n.locale}
    end
  end

end