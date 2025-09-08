class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :authenticate_user!, only: %i[new create]
  skip_before_action :check_admin, only: %i[new create]
  layout "admin/layouts/application"

  def new;end

  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password]) && user.admin?
      sign_in(user)
      redirect_to admin_root_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user
      sign_out(current_user)
      redirect_to admin_login_path, notice: t(".success")
    else
      redirect_to admin_login_path, alert: t(".failure")
    end
  end
end
