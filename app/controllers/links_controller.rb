# frozen_string_literal: true

# Serves and manages links.
class LinksController < ApplicationController
  def index
    redirect_to URI(Rails.configuration.x.site.url).to_s
  end

  def show
    @link = Link.find_by(name: params[:id])
    if @link.present?
      redirect_to URI(@link.target_url).to_s
    else
      render :not_found, status: :not_found
    end
  end
end
