class ThemeKitController < ActionController::Base
  def index
    @theme_kit = ThemeKit.new
    flash_now!(:notice, :success, :warning, :error)
  end
end
