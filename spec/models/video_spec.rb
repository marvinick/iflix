require 'spec_helper'

describe Video do
  it 'saves itself' do
    video = Video.new(title: "monk", description: "a nice show!")
    video.save
    expect(Video.first).to eq(video)
  end
end