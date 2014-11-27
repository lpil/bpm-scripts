#!/usr/bin/env ruby

require 'shellwords'
require 'thread'

def calculate_bpm(file, bot_bpm = 135, top_bpm = 250, force = false)
  `bpm-tag -m #{bot_bpm} -x #{top_bpm}#{' -f' if force} #{file.shellescape}`
end

def ensure_bpm_tag_is_installed
  abort "Mark Hill's bpm-tag doesn't seem to be installed." unless
    system('which bpm-tag > /dev/null 2>&1')
end

def find_files(filetypes)
  Dir.glob('**/*').select do |f|
    # Filter out directories
    (!File.directory? f) &&

      # Filter out files with incorrect extensions (i.e. not mp3, etc)
      (filetypes.any? { |extension| f.downcase.end_with? extension }) &&

      # Filter out files that have the BPM in the name
      (!f.match(/.+\(\d{2,4}.?\d{0,4} BPM\).\w+\z/))
  end
end

def process_files(files, num_threads)
  puts "#{files.size} tracks to process"

  queue = Queue.new
  files.each { |file| queue << file }

  Thread.abort_on_exception = true
  threads = []

  num_threads.times do
    threads << Thread.new do
      while (file = queue.pop(true) rescue false)
        puts calculate_bpm(file)
      end
    end
  end

  threads.each(&:join)
end
