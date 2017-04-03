#!/usr/local/bin/ruby -w

require 'httparty'

fail "First arg must be a time interval to wait (in minutes)" if ARGV[0].nil?
fail "Second arg must be a string to scan the frontpage for" if ARGV[1].nil?

def check
    puts "Checking HN"
    response = HTTParty.get('https://news.ycombinator.com')
    puts "Got result; scanning"
    body = response.body
    matches = body.scan(/#{ARGV[1]}/i)
    if matches.length > 0
        message = "Saw #{ARGV[1]}!"
        puts message
        `say #{message}`
        return true
    end
    puts "No matches found"
end

loop do
    answer = check
    exit if answer
    downtime = (ARGV[0].to_f * 60).to_i
    puts "Will check again in #{ARGV[0]} minutes"
    sleep downtime
end
