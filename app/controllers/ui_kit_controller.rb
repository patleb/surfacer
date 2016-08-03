class UIKitController < ActionController::Base
  def index
    @ui_kit = UIKit.new
    flash_now!(:notice, :success, :warning, :error)
  end
end
