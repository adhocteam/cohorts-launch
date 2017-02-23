# frozen_string_literal: true
class FormsController < ApplicationController
  before_action :set_form, only: [:show, :edit, :update]

  # GET /forms
  # GET /forms.json
  def index
    @forms = Form.where(hidden: false)
  end

  def update_from_wufoo
    Form.update_forms
    redirect_to action: :index
  end

  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html do
          flash[:notice] = "\"#{@form.name}\" hidden."
          redirect_to action: :index
        end
        format.json { head :no_content }
      else
        format.html { redirect_to action: :index }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.require(:form).permit(:hidden)
    end
end
