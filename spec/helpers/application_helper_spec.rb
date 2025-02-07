require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it "can create the composer menu" do
    if !ENV['FILE_HOST'].nil?
      @original_file_host = ENV['FILE_HOST']
    else
      ENV['FILE_HOST'] = 'sowash.com'
      @original_file_host = nil
    end
    if !ENV['FILE_ROOT'].nil?
      @original_file_root = ENV['FILE_ROOT']
    else
      ENV['FILE_ROOT'] = 'graphics/menu'
      @original_file_root = nil
    end
    sheetmusic_prompt = composer_menu_prompts[:sheetmusic]
    expect(sheetmusic_prompt[0]).to match(
      /sowash\.com\/graphics\/menu\/menu2a\.gif/
    )
    ENV['FILE_HOST'] = @original_file_host
    ENV['FILE_ROOT'] = @original_file_root
  end
end
