require 'rails_helper'
include WorksHelper

describe WorksHelper, type: :helper do
  it "should format a list properly" do
    instruments = [
      [1, "violin", 300],
      [1, "cello", 320],
      [1, "piano", 400]
    ]
    expect(oxford_list(instruments))
        .to match(/violin, cello, and piano/)
  end
end
