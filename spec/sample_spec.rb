require 'sample'

RSpec.describe Sample do
  describe '.hello' do
    it 'returns Hello, World!' do
      expect(Sample.hello).to eq('Hello, World!')
    end
  end
end
