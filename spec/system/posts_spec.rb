require 'rails_helper'

RSpec.describe "Posts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  describe '新規商品登録およびレビュー作成' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit new_post_path
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
        expect(current_path).to eq '/users/sign_in'
      end
    end

    context 'ログインしている場合' do
      before do
        login(user)
      end

      context '新規商品登録フォーム表示' do
        before do
          visit new_post_path
        end

        it 'フォームが表示されること' do
          expect(current_path).to eq new_post_path
          expect(page).to have_content('商品名')
          expect(page).to have_content('メーカー')
          expect(page).to have_content('カテゴリ')
          expect(page).to have_content('商品の画像')
          expect(page).to have_button('投稿する')
        end
      end

      context 'フォームの入力値が正常' do
        before do
          create(:category, name: 'チョコレート', slug: 'chocolate')
          visit new_post_path
        end

        it '商品の新規登録およびレビュー投稿が成功する' do
          fill_in '商品名', with: 'test_product'
          fill_in 'メーカー', with: 'test_manufacturer'
          select 'チョコレート', from: 'カテゴリ'
          choose '公開'
          choose 'あまピタッ！'
          choose 'post[post_sweetness_score_attributes][sweetness_strength]', option: '1'
          choose 'post[post_sweetness_score_attributes][aftertaste_clarity]', option: '1'
          choose 'post[post_sweetness_score_attributes][natural_sweetness]', option: '1'
          choose 'post[post_sweetness_score_attributes][coolness]', option: '1'
          choose 'post[post_sweetness_score_attributes][richness]', option: '1'
          fill_in 'レビュー', with: 'フォームの入力値が正常の場合、投稿が成功'
          click_button '投稿する'
          expect(current_path).to eq post_path(Post.last)
          expect(page).not_to have_css("img[src*='lock-key']")
          expect(page).to have_content('test_manufacturer')
          expect(page).to have_content('test_product')
          expect(page).to have_content(user.name)
          expect(page).to have_content('あまピタッ！')
          expect(page).to have_css('#radarChart')
          expect(page).to have_content('フォームの入力値が正常の場合、投稿が成功')
        end
      end

      context 'フォームの入力値が不正' do
        before do
          visit new_post_path
        end

        it '商品名が未入力の場合、エラーメッセージが表示される' do
          fill_in 'メーカー', with: 'test_manufacturer'
          click_button '投稿する'
          expect(page).to have_content('商品名を入力してください')
          expect(page).to have_current_path(posts_path)
        end
      end

      context '非公開投稿' do
        before do
          create(:category, name: 'チョコレート', slug: 'chocolate')
          visit new_post_path
        end

        it '鍵アイコンが表示される' do
          fill_in '商品名', with: 'test_product'
          fill_in 'メーカー', with: 'test_manufacturer'
          select 'チョコレート', from: 'カテゴリ'
          choose '非公開'
          choose 'あまピタッ！'
          choose 'post[post_sweetness_score_attributes][sweetness_strength]', option: '1'
          choose 'post[post_sweetness_score_attributes][aftertaste_clarity]', option: '1'
          choose 'post[post_sweetness_score_attributes][natural_sweetness]', option: '1'
          choose 'post[post_sweetness_score_attributes][coolness]', option: '1'
          choose 'post[post_sweetness_score_attributes][richness]', option: '1'
          click_button '投稿する'
          expect(page).to have_content '非公開で投稿を作成しました'
          expect(page).to have_css("img[src*='lock-key']")
        end
      end

      context '既存商品へのレビュー' do
        let!(:product) { create(:product) }

        before do
          visit new_post_path(product_id: product.id)
        end

        it '既存商品に紐づいたレビューが作成され、商品は増えない' do
          fill_in 'レビュー', with: '既存商品へのレビュー'
          choose '公開'
          choose 'あまピタッ！'
          choose 'post[post_sweetness_score_attributes][sweetness_strength]', option: '3'
          choose 'post[post_sweetness_score_attributes][aftertaste_clarity]', option: '3'
          choose 'post[post_sweetness_score_attributes][natural_sweetness]', option: '3'
          choose 'post[post_sweetness_score_attributes][coolness]', option: '3'
          choose 'post[post_sweetness_score_attributes][richness]', option: '3'
          expect {
            click_button '投稿する'
          }.to change(Post, :count).by(1)
           .and change(Product, :count).by(0)
          post = Post.last
          expect(post.product).to eq product
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content(product.name)
          expect(page).to have_content('既存商品へのレビュー')
        end
      end

      context '投稿の編集・削除権限' do
        it '他人の投稿では編集・削除ボタンが表示されないこと' do
          other_user = create(:user)
          post = create(:post, user: other_user)
          visit post_path(post)
          expect(page).not_to have_link('編集')
          expect(page).not_to have_link('削除')
        end
      end

      context '投稿の編集' do
        it '自分の投稿を編集できること' do
          post = create(:post, user: user)
          visit post_path(post)
          click_link '編集'
          choose 'あまピタッ！'
          choose 'post[post_sweetness_score_attributes][sweetness_strength]', option: '3'
          choose 'post[post_sweetness_score_attributes][aftertaste_clarity]', option: '3'
          choose 'post[post_sweetness_score_attributes][natural_sweetness]', option: '3'
          choose 'post[post_sweetness_score_attributes][coolness]', option: '3'
          choose 'post[post_sweetness_score_attributes][richness]', option: '3'
          fill_in 'レビュー', with: '投稿の更新'
          click_button '更新する'
          expect(page).to have_content '投稿を更新しました'
        end
      end

      context '投稿の削除' do
        it '自分の投稿を削除できること' do
          post = create(:post, user: user)
          visit post_path(post)
          click_link '削除'
          expect(current_path).to eq posts_path
          expect(page).to have_content '投稿を削除しました'
        end
      end
    end
  end
end
