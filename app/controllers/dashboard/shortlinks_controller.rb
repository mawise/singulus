# frozen_string_literal: true

module Dashboard
  # Manages shortlinks.
  class ShortlinksController < DashboardController
    before_action :find_shortlink, only: %i[show edit update destroy]

    def index
      @shortlinks = Shortlink.order(created_at: :desc).page(params[:page])
    end

    def new
      @shortlink = Shortlink.new
    end

    def create
      @shortlink = Shortlink.new(shortlink_params)
      if @shortlink.save
        redirect_to dashboard_shortlink_path(@shortlink), notice: 'Shortlink was successfully created'
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @shortlink.update(shortlink_params)
        redirect_to dashboard_shortlink_path(@shortlink), notice: 'Shortlink was successfully updated'
      else
        render :edit
      end
    end

    def destroy
      @shortlink.destroy
      redirect_to dashboard_shortlinks_path
    end

    private

    def find_shortlink
      @shortlink = Shortlink.find(params[:id])
    end

    def shortlink_params
      params.require(:shortlink).permit(:link, :target_url, :title, :tag_names, :expires_in)
    end
  end
end
