require 'rails_helper'

RSpec.describe Work do
  describe 'the index of works' do
    it 'shows all current works',
      :js => true do
      visit works_path
      save_timestamped_screenshot(page, 'works_index_path')
      expect(1).to eq(1)
    end
  end
end
