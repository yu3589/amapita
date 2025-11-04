require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    it "有効なユーザーが作成できること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前が必須であること" do
      user_without_name = build(:user, name: nil)
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to eq [ "を入力してください" ]
    end

    it "名前が20文字以内であること" do
      user_20_chars = build(:user, name: "a" * 20)
      expect(user_20_chars).to be_valid
    end

    it "名前が21文字以上の場合無効であること" do
      user_21_chars = build(:user, name: "a" * 21)
      expect(user_21_chars).to be_invalid
      expect(user_21_chars.errors[:name]).to include("は20文字以内で入力してください")
    end

    it "メールアドレスが必須であること" do
      user_without_email = build(:user, email: nil)
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to eq [ "を入力してください", "は不正な値です" ]
    end

    it "同じメールアドレスでユーザーを作成できないこと" do
      user1 = create(:user, email: "test@example.com")
      user2 = build(:user, email: user1.email)
      expect(user2).to be_invalid
      expect(user2.errors[:email]).to eq [ "が登録できませんでした。入力内容をご確認ください" ]
    end

    it "同じprovider内でuidがユニークであること" do
      user3 = create(:user, provider: "google_oauth2", uid: "123456789")
      user4 = build(:user, provider: "google_oauth2", uid: "123456789")
      expect(user4).to be_invalid
      expect(user4.errors[:uid]).to eq [ "が登録できませんでした。入力内容をご確認ください" ]
    end
  end
end
