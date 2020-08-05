# frozen_string_literal: true

# Serves and manages shortlinks.
class ShortlinksController < ApplicationController
  def show
    @shortlink = Shortlink.find_by(link: params[:id])
    if @shortlink.present?
      redirect_to @shortlink.target_url
    else
      render :not_found, status: :not_found
    end
  end
end
