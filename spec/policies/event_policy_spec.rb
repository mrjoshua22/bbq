require "rails_helper"

describe EventPolicy do
  subject { described_class }

  let(:event_owner) { create(:user) }
  let(:random_user) { create(:user) }
  let(:event) { create(:event, user: event_owner) }

  permissions :create?, :new? do
    context "when user is anonymous" do
      let(:pundit_user) { UserContext.new(nil, nil, nil) }

      it { expect(subject).not_to permit(pundit_user, event) }
    end

    context "when user is signed in" do
      let(:pundit_user) { UserContext.new(random_user, nil, nil) }

      it { expect(subject).to permit(pundit_user, event) }
    end
  end

  permissions :update?, :edit?, :destroy? do
    context "when user is anonymous" do
      let(:pundit_user) { UserContext.new(nil, nil, nil) }

      it { expect(subject).not_to permit(pundit_user, event) }
    end

    context "when user is not event owner" do
      let(:pundit_user) { UserContext.new(random_user, nil, nil) }

      it { expect(subject).not_to permit(pundit_user, event) }
    end

    context "when user is event owner" do
      let(:pundit_user) { UserContext.new(event_owner, nil, nil) }

      it { expect(subject).to permit(pundit_user, event) }
    end

    permissions :show? do
      let(:protected_event) do
        create(:event, user: event_owner, pincode: '111' )
      end

      context "when user is anonymous" do
        context "when event has pincode" do
          context "when pincode is wrong" do
            let(:pundit_user) { UserContext.new(nil, {}, '123') }

            it { expect(subject).not_to permit(pundit_user, protected_event) }
          end

          context "when pincode is right" do
            let(:pundit_user) { UserContext.new(nil, {}, '111') }

            it { expect(subject).to permit(pundit_user, protected_event) }
          end

          context "when session contains pincode" do
            let(:pundit_user) do
              UserContext.new(
                nil,
                { "events_#{protected_event.id}_pincode" => '111' },
                nil
              )
            end

            it { expect(subject).to permit(pundit_user, protected_event) }
          end
        end

        context "when event doesn't have pincode" do
          let(:pundit_user) { UserContext.new(nil, nil, nil) }

          it { expect(subject).to permit(pundit_user, event) }
        end
      end

      context "when user is not event owner" do
        context "when event has pincode" do
          context "when user is subscriber" do
            let(:pundit_user) { UserContext.new(random_user, nil, nil) }
            let(:subscription) do
              Subscription.create(user: random_user, event: protected_event)
            end

            it { expect(subject).to permit(pundit_user, event) }
          end

          context "when user is not subscriber" do
            context "when pincode is wrong" do
              let(:pundit_user) { UserContext.new(random_user, {}, '123') }

              it { expect(subject).not_to permit(pundit_user, protected_event) }
            end

            context "when pincode is right" do
              let(:pundit_user) { UserContext.new(random_user, {}, '111') }

            it { expect(subject).to permit(pundit_user, protected_event) }
            end

            context "when session contains pincode" do
              let(:pundit_user) do
                UserContext.new(
                  random_user,
                  { "events_#{protected_event.id}_pincode" => '111' },
                  nil
                )
              end

              it { expect(subject).to permit(pundit_user, protected_event) }
            end
          end
        end

        context "when event doesn't have pincode" do
          let(:pundit_user) { UserContext.new(random_user, nil, nil) }

          it { expect(subject).to permit(pundit_user, event) }
        end
      end

      context "when user is event owner" do
        context "when event has pincode" do
          let(:pundit_user) { UserContext.new(event_owner, nil, nil) }

          it { expect(subject).to permit(pundit_user, protected_event) }
        end

        context "when event doesn't have pincode" do
          let(:pundit_user) { UserContext.new(event_owner, nil, nil) }

          it { expect(subject).to permit(pundit_user, event) }
        end
      end
    end
  end
end
