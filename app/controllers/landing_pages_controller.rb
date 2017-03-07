# frozen_string_literal: true
class LandingPagesController < ApplicationController
  before_action :find_landing_page, only: [:edit, :update, :destroy]
  before_action :find_unused_tags, only: [:new, :edit]

  def index
    @landing_pages = LandingPage.joins(:tag).order('tags.name ASC')
  end

  def new
    @landing_page = LandingPage.new
    @landing_page.build_tag
  end

  def create
    @landing_page = LandingPage.new(landing_page_params)
    if @landing_page.save
      redirect_to landing_pages_path, notice: 'Landing page was created.'
    else
      flash[:error] = @landing_page.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @unused_tags << @landing_page.tag
  end

  def update
    if @landing_page.update_attributes(landing_page_params)
      redirect_to landing_pages_path, notice: 'Landing page was updated.'
    else
      flash[:error] = @landing_page.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @landing_page.destroy
      flash[:notice] = 'Landing page was deleted.'
    else
      flash[:error] = 'Problem deleting landing page.'
    end

    redirect_to landing_pages_path
  end

  private

    def find_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    def find_unused_tags
      @unused_tags = Tag.where.not(name: LandingPage.joins(:tag).pluck(:name))
    end

    def landing_page_params
      params.require(:landing_page).permit(:lede, :image, tag_attributes: [:name])
    end
end
