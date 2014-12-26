describe "EntitySet" do
  describe "paged result" do
    it "should enumerate single page results" do
      api = double("api")
      allow(api).to receive(:json).and_return({'items' => [1,2]})

      results = HubClient::EntitySet.new(api, "/entity_set_path").paged_where()

      expect(results.to_a).to eq([1,2])
    end

    it "should enumerate multiple page results" do
      api = double("api")
      allow(api).to receive(:json).and_return(
        {'items' => [1,2], 'next_page' => '#next'},
        {'items' => [3,4], 'next_page' => '#next'},
        {'items' => [5,6]}
      )

      results = HubClient::EntitySet.new(api, "/entity_set_path").paged_where()

      expect(results.to_a).to eq([1,2,3,4,5,6])
    end
  end
end
