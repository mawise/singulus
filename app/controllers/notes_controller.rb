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
    if @note.save
      redirect_to note_path(@note), notice: 'Note was successfully created'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @note.update(note_params)
      redirect_to note_path(@note), notice: 'Note was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_path
  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.permit(note: %i[content]).fetch(:note, {})
  end
end
