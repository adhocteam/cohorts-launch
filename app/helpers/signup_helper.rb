# frozen_string_literal: true
module SignupHelper
  def signup_lede
    if @landing_page && @landing_page.lede.present?
      @landing_page.lede
    else
      'Join Cohorts, a group of people who earn money by giving feedback on government websites'
    end
  end

  def signup_image
    @landing_page.image if @landing_page && @landing_page.image.present?
  end
end
