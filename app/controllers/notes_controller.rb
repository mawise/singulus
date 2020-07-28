# frozen_string_literal: true

# Supports CRUD activities for notes.
class NotesController < ApplicationController
  before_action :authenticate_user!

  before_action :find_note, only: %i[show edit update destroy]

  def index
    @notes = Note.order(published_at: :desc).page(params[:page])
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    @note.author = current_user
    @note.published_at = Time.now.utc
    if save_note
      PublishWorker.perform_async('create', 'note', @note.id)
      redirect_to note_path(@note), notice: 'Note was successfully created'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @note.update(note_params)
      PublishWorker.perform_async('update', 'note', @note.id)
      redirect_to note_path(@note), notice: 'Note was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    DeleteWorker.perform_async(@note.attributes)
    redirect_to notes_path
  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def save_note
    on_retry = proc do |_, _try, _, _|
      Rails.logger.info('Collison generating short_uid, trying again')
    end
    Retriable.retriable on: [ActiveRecord::RecordNotUnique], on_retry: on_retry do
      @note.save
    end
  end

  def note_params
    params.permit(note: %i[content]).fetch(:note, {})
  end
end
