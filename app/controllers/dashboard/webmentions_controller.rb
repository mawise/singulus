# frozen_string_literal: true

module Dashboard
  # Manages webmentions.
  class WebmentionsController < DashboardController
    before_action :find_webmention, only: %i[show approve deny destroy]

    def index
      @webmentions = Webmention.order(created_at: :desc).page(params[:page])
    end

    def show; end

    def approve
      if @webmention.update(status: 'approved')
        flash[:notice] = 'Webmention has been approved.'
      else
        flash[:alert] = 'Approving webmention failed.'
      end
      redirect_to dashboard_webmention_path(@webmention)
    end

    def deny
      if @webmention.update(status: 'denied')
        flash[:notice] = 'Webmention has been denied.'
      else
        flash[:alert] = 'Approving webmention failed.'
      end
      redirect_to dashboard_webmention_path(@webmention)
    end

    def destroy
      @webmention.destroy
      flash[:notice] = 'Webmention has been deleted.'
      redirect_to dashboard_webmentions_path
    end

    private

    def find_webmention
      @webmention = Webmention.find(params[:id])
    end
  end
end
