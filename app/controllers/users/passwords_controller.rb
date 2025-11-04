# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    begin
      self.resource = resource_class.send_reset_password_instructions(resource_params)
    # SMTP障害・通信エラー対応
    rescue StandardError => e
      Rails.logger.error("Password reset failed: #{e.class} - #{e.message}")
    end
    # paranoidモードでは常に成功メッセージを表示
    flash[:notice] = t("devise.passwords.send_paranoid_instructions")
    redirect_to new_user_session_path
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_user_session_path
  end
end
