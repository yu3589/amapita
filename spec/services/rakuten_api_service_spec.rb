require 'rails_helper'

RSpec.describe RakutenApiService do
  describe '楽天APIの検索' do
    let(:service) { described_class.new }

    context 'APIリクエストが成功する場合' do
      it '商品情報を取得できること' do
        mock_item = {
          "itemName" => "テストチョコレート",
          "itemUrl" => "https://example.com/item/1",
          "shopName" => "テストショップ",
          "mediumImageUrls" => [
            { "imageUrl" => "https://example.com/image.jpg" }
          ]
        }
        allow(RakutenWebService::Ichiba::Item).to receive(:search)
          .and_return([ mock_item ])
        results = service.search('チョコレート')
        expect(results).to be_an(Array)
        expect(results.size).to eq 1
        expect(results.first["name"]).to eq "テストチョコレート"
        expect(results.first["url"]).to eq "https://example.com/item/1"
        expect(results.first["shopName"]).to eq "テストショップ"
        expect(results.first["imageUrl"]).to eq "https://example.com/image.jpg"
      end
    end

    context 'APIがタイムアウトした場合' do
      it '空配列を返すこと' do
        allow(RakutenWebService::Ichiba::Item).to receive(:search)
          .and_raise(Timeout::Error)
        results = service.search('チョコレート')
        expect(results).to eq []
      end
    end

    context 'APIのレスポンスが不正な形式の場合' do
      it '空配列を返すこと' do
        allow(RakutenWebService::Ichiba::Item).to receive(:search)
          .and_raise(JSON::ParserError.new('unexpected token'))
        results = service.search('チョコレート')
        expect(results).to eq []
      end
    end

    context 'キーワードが空の場合' do
      it 'nilを返すこと' do
        expect(service.search(nil)).to be_nil
        expect(service.search("")).to be_nil
      end
    end
  end
end
