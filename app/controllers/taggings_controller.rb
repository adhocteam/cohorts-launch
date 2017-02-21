# frozen_string_literal: true
# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  taggable_type :string(255)
#  taggable_id   :integer
#  created_by    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  tag_id        :integer
#

class TaggingsController < ApplicationController

  def create
    @tag = Tag.find_or_initialize_by(name: params[:tagging].delete(:name))
    @tag.created_by ||= current_user.id
    if @tag.name != ''
      @tagging = Tagging.new(taggable_type: params[:tagging][:taggable_type],
                             taggable_id: params[:tagging][:taggable_id],
                             tag: @tag)
    end
    if @tagging.with_user(current_user).save
      respond_to do |format|
        format.js {}
      end
    else
      respond_to do |format|
        format.js { render text: "console.log('tag save error')" }
      end
    end
  end

  def bulk_create
    @tag = Tag.where(name: tagging_params[:name]).first_or_create
    @tag.created_by ||= current_user.id
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

    # the methods=> :value is needed for tokenfield.
    # https://github.com/sliptree/bootstrap-tokenfield/issues/189
    render json: @tags.to_json(methods: [:value, :label, :type])
  end

  private

    def tagging_params
      params.require(:tagging).permit(:taggable_type, :taggable_id, :name, taggable_ids: [])
    end
end
