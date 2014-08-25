require_relative "rsyncru/version"

require 'json'
require 'rsync'


def rsync_prm(prm)
  pre_option = "-narv"

  src = prm["src"]
  dest = prm["dest"]

  Rsync.run(pre_option, src, dest) do |result|
    puts "rsync #{src} #{dest}"
    if result.success?
      puts "OK"
      puts result.raw
      changes = result.changes
      changes.each do |change|
         puts "#{change.filename} (#{change.summary})"
      end
    else
      puts result.error
    end
  end

end

module Rsyncru

open("./rsync_multi.json"){|fp|
	jd = JSON.load(fp)
	prms = jd["prms"]

	prms.each {|prm|
		rsync_prm(prm)
	}

}


end


