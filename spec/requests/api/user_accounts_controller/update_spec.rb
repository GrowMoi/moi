require "rails_helper"

RSpec.describe Api::Users::AccountsController,
               type: :request do
  describe "#update" do
    it "persists attrs" do
      me = create :user
      login_as me
      params = {
        account: {
          username: 'moi.user.updated',
          age: 15,
          city: 'Loja',
          country: 'Ecuador1',
          school: 'myschool',
          authorization_key: 'numbers'
        }
      }
      put '/api/users/account', params
      me.reload
      expect(response.code).to eq("202")
      params[:account].keys.each do |attribute|
        expect(me.send(attribute)).to eq(params[:account][attribute])
      end
    end
  end
end
