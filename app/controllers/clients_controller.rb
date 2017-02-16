# frozen_string_literal: true
class ClientsController < ApplicationController
  before_action :find_client, only: [:update, :destroy]

  def index
    @clients = Client.order(:name)
  end

  def create
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        format.js {}
      else
        format.js { "console.log('Error saving client: #{@client.errors}');" }
      end
    end
  end

  def update
    @client.assign_attributes(client_params)
    respond_to do |format|
      if @client.save
        format.js {}
      else
        format.js { "console.log('Error saving client: #{@client.errors}');" }
      end
    end
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.js {}
    end
  end

  private

    def find_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name)
    end
end
