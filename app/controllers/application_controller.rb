class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]

  protected
  def after_sign_in_path_for(resource)
    current_user
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
