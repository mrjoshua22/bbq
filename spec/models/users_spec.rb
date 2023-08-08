require "rails_helper"

describe User, type: :model do
  describe '.from_omniauth' do
    context 'when user signs in with github' do
      let(:access_token) do
        access_token = double(:access_token)

        allow(access_token).to receive_messages(
          provider: 'github',
          info: {
            'email' => 'sample@mail.com',
            'urls' => { 'GitHub'=>'https://github.com/github_user', 'Blog'=>'' }
          }
        )

        access_token
      end

      context 'when user is not found' do
        let(:user) { User.from_omniauth(access_token) }

        it { expect(user).to be_persisted }
        it { expect(user.email).to eq('sample@mail.com') }
        it { expect(user.provider).to eq('github') }
        it { expect(user.url).to eq('https://github.com/github_user') }
      end

      context 'when user if found by email' do
        let!(:existing_user) { create(:user, email: 'sample@mail.com') }
        let!(:some_other_user) { create(:user) }

        it { expect(User.from_omniauth(access_token)).to eq(existing_user) }
      end
    end

    context 'when user signs in with vkontakte' do
      let(:access_token) do
        access_token = double(:access_token)

        allow(access_token).to receive_messages(
          provider: 'vkontakte',
          info: { 'urls' => { 'Vkontakte'=>'https://vk.com/vk_user' }}
        )

        access_token
      end

      context 'when user is not found' do
        let(:user) { User.from_omniauth(access_token) }

        it { expect(user).to be_persisted }
        it { expect(user.provider).to eq('vkontakte') }
        it { expect(user.url).to eq('https://vk.com/vk_user') }
      end

      context 'when user if found by url' do
        let!(:existing_user) { create(:user, url: 'https://vk.com/vk_user') }
        let!(:some_other_user) { create(:user) }

        it { expect(User.from_omniauth(access_token)).to eq(existing_user) }
      end
    end
  end
end
