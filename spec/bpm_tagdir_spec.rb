require_relative '../lib/bpm_tagdir'

describe '#calculate_bpm' do
  before :all do
    @file       = 'something.ogg'
    @bottom_bpm = 100
    @top_bpm    = 190
  end

  # FIXME
end

describe '#ensure_bpm_tag_is_installed' do
  # FIXME
end

describe '#find_files' do
  before :all do
    @filetypes = %w(ogg mp3)
    @files     = [
      '..',
      'some thing.ogg',
      'something.OGG',
      'something.txt',
      'something.mp3',
      'something mp3.txt',
      'mp3somethingmp3.txt',
      '../spec'
    ]
  end

  before :each do
    allow(Dir).to receive(:glob).and_return(@files)
  end

  it 'calls Dir.glob' do
    expect(Dir).to receive(:glob).with('**/*')
    find_files @filetypes
  end

  it 'returns an array' do
    expect(find_files @filetypes).to be_an_instance_of(Array)
  end

  context 'with wanted filetypes' do
    it 'retains them' do
      files = find_files @filetypes
      expect(files).to include('some thing.ogg')
      expect(files).to include('something.mp3')
    end

    it 'retains them, even if a different case' do
      files = find_files @filetypes
      expect(files).to include('something.OGG')
    end
  end

  context 'with unwanted filetypes' do
    it 'filters them out' do
      files = find_files @filetypes
      expect(files).not_to include('something.txt')
    end

    it 'filters even if they have the desired ext is in the name' do
      files = find_files @filetypes
      expect(files).not_to include('something mp3.txt')
      expect(files).not_to include('mp3somethingmp3.txt')
    end
  end

  context 'with directories' do
    it 'filters them out' do
      files = find_files @filetypes
      expect(files).not_to include('../spec')
      expect(files).not_to include('..')
    end
  end
end
