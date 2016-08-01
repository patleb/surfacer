class UIKitController < ApplicationController
  def index
    @ui_kit = UIKit.new
    flash_now!(:notice, :success, :warning, :error)
  end
end
