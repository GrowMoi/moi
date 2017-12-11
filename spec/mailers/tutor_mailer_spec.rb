require "rails_helper"

RSpec.describe TutorMailer, :type => :mailer do
  let(:client) { build :user, role: :cliente }
  let(:tutor) { build :user, role: :tutor }
  let(:achievement) { build :tutor_achievement}
  let(:mail) { TutorMailer.achievement_notification(tutor, client, achievement) }

  it 'send email whit subject' do
		expect(mail.subject).to eql(I18n.t("tutor_mailer.achievement_notification.subject"))
	end

  it 'renders the receiver email' do
    expect(mail.to).to eql([tutor.email])
  end

	it 'renders the sender email' do
    expect(mail.from).to eql(['moi@example.com'])
  end

	it 'have client info' do
    expect(mail.body.encoded).to have_text(client.name)
  end

  it 'have achievement info' do
    expect(mail.body.encoded).to have_text(achievement.name)
	end
end
