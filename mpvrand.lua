--[[ run with
	mpv --playlist=/explicit/path/to/playlist --lua=~/.config/mpv/mpvrand.lua --fullscreen --shuffle --no-osc --no-sub --no-audio --no-config --loop=inf --no-border
	or something ]]

--[[ playlist can quickly be made with something like
	find "$PWD" -iregex ".*\.\(mkv\|avi\|mp4\|vob\|mov\)" > playlist	
	]]

function next()
	mp.command("playlist_next")
end

function seek_and_wait()
	mp.set_property_number("time-pos", math.random(1, position_cap))
	mp.add_timeout(rand_play_length, next)
end

function gen_position()
	rand_min = 10
	rand_max = 30
	rand_play_length = math.random(rand_min, rand_max)
	length = mp.get_property_number("length", 0)
	if length == 0 then	--catches videos of no length (or returns of nil) and skips them - consider adding removal of item from playlist
		next()
	else
		if rand_play_length >= length then	--catches short videos
			if rand_min >= length then	--catches really short videos
				rand_play_length = math.random(1, length)
			else
				rand_play_length = math.random(rand_min, length)
			end
		end
		position_cap = length - rand_play_length
		if position_cap < 1 then	--catches when things above don't work as expected
			next()
		else
			seek_and_wait()
		end
	end
end

mp.register_event("start-file", gen_position)
mp.register_event("end-file", next)
