class UsersController < Clearance::UsersController
  if respond_to?(:before_action)
    before_action :redirect_signed_in_users, only: [:create, :new]
    skip_before_action :require_login, only: [:create, :new], raise: false
    skip_before_action :authorize, only: [:create, :new], raise: false
  else
    before_filter :redirect_signed_in_users, only: [:create, :new]
    skip_before_filter :require_login, only: [:create, :new], raise: false
    skip_before_filter :authorize, only: [:create, :new], raise: false
  end

  def show
    if signed_in?
      @user = User.find(current_user.id)
    else
      redirect_to sign_in_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user]
      params[:user].delete(:password) if params[:user][:password].blank?
      if @user.update(user_params)
        redirect_to user_path(@user)
      else
        redirect_to edit_user_path(@user)
      end
    else
      @user.remove_profile_photo!
      @user.save
      redirect_to user_path(@user)
    end
  end

  def new
    @user = User.new
    render template: "users/new"
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  private

  def avoid_sign_in
    warn "[DEPRECATION] Clearance's `avoid_sign_in` before_filter is " +
      "deprecated. Use `redirect_signed_in_users` instead. " +
      "Be sure to update any instances of `skip_before_filter :avoid_sign_in`" +
      " or `skip_before_action :avoid_sign_in` as well"
    redirect_signed_in_users
  end

  def redirect_signed_in_users
    if signed_in?
      redirect_to Clearance.configuration.redirect_url
    end
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def user_params
    params.require(:user).permit(:email, :password, :last_name, :first_name, :phone, :gender, :birthday, :profile_photo)
  end

end
