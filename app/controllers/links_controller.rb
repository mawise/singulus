# frozen_string_literal: true

# Serves and manages links.
class LinksController < ApplicationController
  def show
    @link = Link.find_by(name: params[:id])
    if @link.present?
      redirect_to URI(@link.target_url).to_s
    else
      render :not_found, status: :not_found
    end
  end
end
