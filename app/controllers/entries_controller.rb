class EntriesController < ApplicationController
  before_action :authenticate_user!

  before_action :find_entry, only: %i[show edit update destroy]

  def index
    @entries = Entry.order(published_at: :desc, created_at: :desc).page(params[:page])
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.author = current_user
    @entry.published_at = Time.now.utc
    if @entry.save_unique
      PublishWorker.perform_async('create', @entry.id)
      redirect_to entry_path(@entry), notice: 'Entry was successfully created'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @entry.update(entry_params)
      PublishWorker.perform_async('update', @entry.id)
      redirect_to entry_path(@entry), notice: 'Entry was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @entry.destroy
    DeleteWorker.perform_async(@entry.id, @entry.hugo_source_path)
    redirect_to entries_path
  end

  private

  def find_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:name, :content, :summary)
  end
end
