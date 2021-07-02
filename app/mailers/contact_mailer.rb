class ContactMailer < ApplicationMailer
    def feed_notification(feed)
      @feed = feed
      mail to: @feed.user.email, subject: "お問い合わせの確認メール"
    end
  end