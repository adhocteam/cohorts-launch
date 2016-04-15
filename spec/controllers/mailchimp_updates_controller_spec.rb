# == Schema Information
#
# Table name: mailchimp_updates
#
#  id          :integer          not null, primary key
#  raw_content :text(65535)
#  email       :string(255)
#  update_type :string(255)
#  reason      :string(255)
#  fired_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe MailchimpUpdatesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # MailchimpUpdate. As you add validations to MailchimpUpdate, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip('Add a hash of attributes valid for your model')
  }

  let(:invalid_attributes) {
    skip('Add a hash of attributes invalid for your model')
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MailchimpUpdatesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  # gotta login! though, we may not qant to do this for all tests...
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    sign_in :user, user # sign_in(scope, resource)
  end

  describe 'GET #index' do
    it 'assigns all mailchimp_updates as @mailchimp_updates' do
      mailchimp_update = MailchimpUpdate.create! valid_attributes
      get :index, {}
      expect(assigns(:mailchimp_updates)).to eq([mailchimp_update])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested mailchimp_update as @mailchimp_update' do
      mailchimp_update = MailchimpUpdate.create! valid_attributes
      get :show, { id: mailchimp_update.to_param }
      expect(assigns(:mailchimp_update)).to eq(mailchimp_update)
    end
  end

  describe 'GET #new' do
    it 'assigns a new mailchimp_update as @mailchimp_update' do
      get :new, {}
      expect(assigns(:mailchimp_update)).to be_a_new(MailchimpUpdate)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested mailchimp_update as @mailchimp_update' do
      mailchimp_update = MailchimpUpdate.create! valid_attributes
      get :edit, { id: mailchimp_update.to_param }
      expect(assigns(:mailchimp_update)).to eq(mailchimp_update)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new MailchimpUpdate' do
        expect {
          post :create, { mailchimp_update: valid_attributes }
        }.to change(MailchimpUpdate, :count).by(1)
      end

      it 'assigns a newly created mailchimp_update as @mailchimp_update' do
        post :create, { mailchimp_update: valid_attributes }
        expect(assigns(:mailchimp_update)).to be_a(MailchimpUpdate)
        expect(assigns(:mailchimp_update)).to be_persisted
      end

      it 'redirects to the created mailchimp_update' do
        post :create, { mailchimp_update: valid_attributes }
        expect(response).to redirect_to(MailchimpUpdate.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved mailchimp_update as @mailchimp_update' do
        post :create, { mailchimp_update: invalid_attributes }
        expect(assigns(:mailchimp_update)).to be_a_new(MailchimpUpdate)
      end

      it "re-renders the 'new' template" do
        post :create, { mailchimp_update: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested mailchimp_update' do
        mailchimp_update = MailchimpUpdate.create! valid_attributes
        put :update, { id: mailchimp_update.to_param, mailchimp_update: new_attributes }
        mailchimp_update.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested mailchimp_update as @mailchimp_update' do
        mailchimp_update = MailchimpUpdate.create! valid_attributes
        put :update, { id: mailchimp_update.to_param, mailchimp_update: valid_attributes }
        expect(assigns(:mailchimp_update)).to eq(mailchimp_update)
      end

      it 'redirects to the mailchimp_update' do
        mailchimp_update = MailchimpUpdate.create! valid_attributes
        put :update, { id: mailchimp_update.to_param, mailchimp_update: valid_attributes }
        expect(response).to redirect_to(mailchimp_update)
      end
    end

    context 'with invalid params' do
      it 'assigns the mailchimp_update as @mailchimp_update' do
        mailchimp_update = MailchimpUpdate.create! valid_attributes
        put :update, { id: mailchimp_update.to_param, mailchimp_update: invalid_attributes }
        expect(assigns(:mailchimp_update)).to eq(mailchimp_update)
      end

      it "re-renders the 'edit' template" do
        mailchimp_update = MailchimpUpdate.create! valid_attributes
        put :update, { id: mailchimp_update.to_param, mailchimp_update: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested mailchimp_update' do
      mailchimp_update = MailchimpUpdate.create! valid_attributes
      expect {
        delete :destroy, { id: mailchimp_update.to_param }
      }.to change(MailchimpUpdate, :count).by(-1)
    end

    it 'redirects to the mailchimp_updates list' do
      mailchimp_update = MailchimpUpdate.create! valid_attributes
      delete :destroy, { id: mailchimp_update.to_param }
      expect(response).to redirect_to(mailchimp_updates_url)
    end
  end
end
