# frozen_string_literal: true

# Serves and manages links.
class LinksController < ApplicationController
  def show
    @link = Link.find_by(link: params[:id])
    if @link.present?
      redirect_to @link.target_url
    else
      render :not_found, status: :not_found
    end
  end
end
