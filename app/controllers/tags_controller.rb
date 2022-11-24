class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
    @tags.load
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_url, notice: "#{t(:tag)} #{t(:created_notice)}" }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: "#{t(:tag)} #{t(:updated_notice)}" }
        format.json { render :show, status: :ok, location: @tag }
      else
        set_tag_data
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: "#{t(:tag)} #{t(:deleted_notice)}" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tags_path
  end

  # Only allow a list of trusted parameters through.
  def tag_params
    translated_attributes = I18n.available_locales.map do |locale|
      [:"name_#{Mobility.normalize_locale(locale)}"]
    end.flatten
    params.require(:practice).permit(*translated_attributes, :id)
  end
end