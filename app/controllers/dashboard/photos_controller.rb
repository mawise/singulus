# frozen_string_literal: true

module Dashboard
  # Manages photos.
  class PhotosController < DashboardController
    before_action :authenticate_user!

    before_action :find_photo, only: %i[show edit update destroy]

    def index
      @photos = Photo.order(created_at: :desc).page(params[:page])
    end

    def new
      @photo = Photo.new
    end

    def create
      @photo = Photo.new(create_params)
      if @photo.save
        redirect_to dashboard_photo_path(@photo), notice: 'Photo was successfully created'
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @photo.update(update_params)
        redirect_to dashboard_photo_path(@photo), notice: 'Photo was successfully updated'
      else
        render :edit
      end
    end

    def destroy
      @photo.destroy
      redirect_to dashboard_photos_path
    end

    private

    def find_photo
      @photo = Photo.find(params[:id])
    end

    def create_params
      params.require(:photo).permit(:file, :alt)
    end

    def update_params
      params.require(:photo).permit(:alt, :post_id)
    end
  end
end
