require "rails_helper"

describe User, type: :model do
  describe '.from_omniauth' do
    context 'when user signs in' do
      let(:token_with_email) do
        token = double(:token_with_email)

        allow(token).to receive_messages(
          provider: 'github',
          info: {
            'email' => 'sample@mail.com',
            'urls' => { 'GitHub'=>'https://github.com/github_user', 'Blog'=>'' }
          }
        )

        token
      end

      let(:no_email_token) do
        token = double(:no_email_token)

        allow(token).to receive_messages(
          provider: 'vkontakte',
          info: { 'urls' => { 'Vkontakte'=>'https://vk.com/vk_user' }}
        )

        token
      end

      context 'when user is not found' do
        let(:user) { User.from_omniauth(token_with_email) }

        it { expect(user).to be_persisted }
        it { expect(user.email).to eq('sample@mail.com') }
        it { expect(user.provider).to eq('github') }
        it { expect(user.url).to eq('https://github.com/github_user') }
      end

      context 'when user is found by email' do
        let!(:existing_user) { create(:user, email: 'sample@mail.com') }
        let!(:some_other_user) { create(:user) }

        it { expect(User.from_omniauth(token_with_email)).to eq(existing_user) }
      end

      context 'when user is found by url' do
        let!(:existing_user) { create(:user, url: 'https://vk.com/vk_user') }
        let!(:some_other_user) { create(:user) }

        it { expect(User.from_omniauth(no_email_token)).to eq(existing_user) }
      end
    end
  end
end
