# frozen_string_literal: true
class TaggingsController < ApplicationController

  def create
    unless (@tag = Tag.find_by('lower(name) = ?', tagging_params[:name].downcase))
      @tag = Tag.create(name: tagging_params[:name])
      @tag.created_by ||= current_user.id
    end
    @tagging = Tagging.new(taggable_type: params[:tagging][:taggable_type],
                           taggable_id: params[:tagging][:taggable_id],
                           tag: @tag)
    if @tagging.with_user(current_user).save
      respond_to do |format|
        format.js {}
      end
    else
      respond_to do |format|
        format.js { render text: "console.log('tag save error (tag may already exist)')" }
      end
    end
  end

  def bulk_create
    unless (@tag = Tag.where('lower(name) = ?', tagging_params[:name].downcase).first)
      @tag = Tag.create(name: tagging_params[:name])
      @tag.created_by ||= current_user.id
    end
    if @tag.name != ''
      tagging_params[:taggable_ids].each do |id|
        @tagging = Tagging.where(taggable_type: tagging_params[:taggable_type],
                               taggable_id: id,
                               tag: @tag).first_or_create
      end
    end
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    @tagging = Tagging.find(params[:id])

    if @tagging.destroy
      respond_to do |format|
        format.js {}
      end
    else
      respond_to do |format|
        format.js { render text: "alert('failed to destroy tag.')" }
      end
    end
  end

  def search
    @tags = Tag.where('name like ?', "%#{params[:q]}%").
            order(taggings_count: :desc)
    render json: @tags.to_json(methods: [:value, :label, :type])
  end

  private

    def tagging_params
      params.require(:tagging).permit(:taggable_type, :taggable_id, :name, taggable_ids: [])
    end
end
