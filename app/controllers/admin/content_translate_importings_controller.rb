module Admin
  class ContentTranslateImportingsController < AdminController::Base

    def new
      @content_translate_importing = ContentImporting.new
    end

    def create
      @content_translate_importing = ContentImporting.new(content_importing_params)
      @content_translate_importing.user = current_user
      @content_translate_importing.kind = 'translate'
      if @content_translate_importing.save
        redirect_to admin_content_importings_path,
          notice: I18n.t("views.content_importings.created")
      else
        render :new
      end
    end

    private

    def content_importing_params
      params.require(:content_importing).permit(:file, :kind)
    end
  end
end
