require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "バリデーションチェック" do
    it "有効な投稿が作成できること" do
      post = create(:post)
      expect(post).to be_valid
    end

    it "sweetness_ratingが存在する場合、有効であること" do
      post = create(:post, sweetness_rating: :perfect_sweetness)
      expect(post).to be_valid
    end

    it "sweetness_ratingがnilの場合、無効であること" do
      post = build(:post, sweetness_rating: nil)
      expect(post).to be_invalid
    end

    it "sweetness_ratingがnilの場合、エラーメッセージが適切に設定されること" do
      post = build(:post, sweetness_rating: nil)
      post.valid?
      expect(post.errors[:sweetness_rating]).to include("を選んでください")
    end

    it "post_sweetness_scoreが存在する場合、有効であること" do
      post = create(:post)
      post.build_post_sweetness_score(
        sweetness_strength: 3,
        aftertaste_clarity: 3,
        natural_sweetness: 3,
        coolness: 3,
        richness: 3
      )
      expect(post).to be_valid
    end

    it "post_sweetness_scoreがnilの場合、無効であること" do
      post = build(:post)
      post.post_sweetness_score = nil
      expect(post).to be_invalid
    end

    it "post_sweetness_scoreがnilの場合、エラーメッセージが適切に設定されること" do
      post = build(:post)
      post.post_sweetness_score = nil
      post.valid?
      expect(post.errors[:post_sweetness_score]).to include("を入力してください")
    end

    it "statusが存在する場合、有効であること" do
      post = create(:post, status: :publish)
      expect(post).to be_valid
    end

    it "statusがnilの場合、無効であること" do
      post = build(:post, status: nil)
      expect(post).to be_invalid
    end

    it "statusがnilの場合、エラーメッセージが適切に設定されること" do
      post = build(:post, status: nil)
      post.valid?
      expect(post.errors[:status]).to include("を入力してください")
    end

    it "reviewが500文字以内であること" do
      post = create(:post, review: "a" * 500)
      expect(post).to be_valid
    end

    it "reviewが501文字以上の場合無効であること" do
      post = build(:post, review: "a" * 501)
      expect(post).to be_invalid
      expect(post.errors[:review]).to include("は500文字以内で入力してください")
    end
  end

  describe "アソシエーションチェック" do
    it "userに属していること" do
      association = Post.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it "productに属していること" do
      association = Post.reflect_on_association(:product)
      expect(association.macro).to eq :belongs_to
    end

    it "post_sweetness_scoreを持つこと" do
      association = Post.reflect_on_association(:post_sweetness_score)
      expect(association.macro).to eq :has_one
    end

    it "複数のlikesを持つこと" do
      association = Post.reflect_on_association(:likes)
      expect(association.macro).to eq :has_many
    end

    it "複数のcommentsを持つこと" do
      association = Post.reflect_on_association(:comments)
      expect(association.macro).to eq :has_many
    end
  end
end
