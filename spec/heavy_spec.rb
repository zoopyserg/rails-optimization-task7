RSpec.describe 'Heavy Tests' do
  it 'performs a heavy computation' do
    result = (1..10_000_000).reduce(:+)
    expect(result).to eq(50_000_005_000_000)
  end

  it 'allocates a large amount of memory' do
    array = Array.new(10_000_000) { rand }
    expect(array.size).to eq(10_000_000)
  end

  it 'performs a large number of file writes' do
    File.open('large_file.txt', 'w') do |f|
      1_000_000.times { f.puts "This is a test line." }
    end
    expect(File.size('large_file.txt')).to be > 0
    File.delete('large_file.txt')
  end
end
