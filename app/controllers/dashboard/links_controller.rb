# frozen_string_literal: true

module Dashboard
  # Manages links.
  class LinksController < DashboardController
    before_action :find_link, only: %i[show edit update destroy]

    def index
      @links = Link.order(created_at: :desc).page(params[:page])
    end

    def new
      @link = Link.new
    end

    def create
      @link = Link.new(link_params)
      if @link.save
        redirect_to dashboard_link_path(@link), notice: 'Link was successfully created'
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @link.update(link_params)
        redirect_to dashboard_link_path(@link), notice: 'Link was successfully updated'
      else
        render :edit
      end
    end

    def destroy
      @link.destroy
      redirect_to dashboard_links_path
    end

    private

    def find_link
      @link = Link.find(params[:id])
    end

    def link_params
      params.require(:name).permit(:name, :target_url, :title, :tag_names, :expires_in)
    end
  end
end
