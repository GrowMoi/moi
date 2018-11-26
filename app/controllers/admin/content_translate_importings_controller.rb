require 'pry'
module Admin
  class ContentTranslateImportingsController < AdminController::Base

    def new
      @content_importing = ContentImporting.new
    end

  end
end
