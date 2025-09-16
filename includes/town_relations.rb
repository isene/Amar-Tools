# The function for generating relationship maps for inhabitants
# of a castle/village/town/city

def town_relations(town_file)
	town_file = fix_town_file(town_file)

	town = File.read(town_file)

	if town.match(/#1:/)
		t = town.gsub(/ \[.*/, '')
		t.sub!(/^.*#1:/m, '#1:')
		t.sub!(/\n\n###.*$/, '')
		t.gsub!(/#\d+:.*\n/, '')
		t.gsub!(/  +/, '')
		h = t.split("\n\n")
		house = []
		h.each_with_index do |item, index|
			house[index] = item.split("\n")
		end
		persons = []
		i = 0
		house.each_with_index do |item, index|
			item.each do |p|
				persons[i] = p + "\n##{index+1}"
				i += 1
			end
		end
		persons.map! { |p| p.sub!(/ \(/, "\n(") }
		persons.map! { |p| p.gsub!(/\n/, '\\n') }
		persons.map! { |p| "\"" + p + "\"" }
	else
		persons = town.split("\n")
	end

	dot_text =  <<DOTSTART
	digraph town {
	rankdir="LR"
	splines=true
	overlap=false
	edge [ fontsize=8 len=1 arrowhead="none"]
	fixedsize=true
DOTSTART

	i = 0
	persons.length.times do
		p = persons.dup
		cur = p[i]
		p.delete(p[i])
		r = rand(6) - 2
		r = 0 if r < 0
		r.times do
			dot_text += cur
			line = rand(5) - 2
			dot_text += " -> "
			dot_text += p.sample
			dot_text += " [color=\"red\"]" if line < 0
			dot_text += "\n"
		end
		i += 1
	end
	dot_text += "}"

	$town_png = File.dirname(town_file) + "/" + File.basename(town_file, ".*") + ".png"
	town_dot  = File.dirname(town_file) + "/" + File.basename(town_file, ".*") + ".dot"
	File.delete($town_png) if File.exist?($town_png)
	File.delete(town_dot) if File.exist?(town_dot)

	begin
		File.write(town_dot, dot_text, perm: 0644)
		# Silent - no puts in TUI mode
	rescue
		# Silent error - no puts in TUI mode
	end
	begin
		`dot -Tpng #{town_dot} -o #{$town_png}`
		# Silent - no puts in TUI mode
	rescue
		# Silent error - no puts in TUI mode
	end
end

# Function to generate a text file of the relationships
def town_dot2txt(town_file)
	town_file = fix_town_file(town_file)
	town_name = File.basename(town_file, ".*").gsub(/([[:upper:]])/, ' \1').sub(/ /, '')

	town_dot_file = File.dirname(town_file) + "/" + File.basename(town_file, ".*") + ".dot"
	$townrel_file = File.dirname(town_file) + "/" + File.basename(town_file, ".*") + "_relations.txt"

	townrel = ""
	File.open(town_dot_file) do |fl|
		townrel += fl.read
	end

	townrel.sub!(/^.*true\n/m, '')
	townrel.gsub!(/\\n/, ', ')
	t = townrel
	t.each_line do |line|
		if / \[color=\"red\"\]/ =~ line
			new_line = line.sub(/ \[color=\"red\"\]/, '')
		else
			new_line = line.sub(/->/, '+>')
		end
		townrel.sub!(line, new_line)
	end
	townrel.gsub!(/\"/, '')
	townrel.gsub!(/\n}/, '')
	townrel =	"#{town_name} relationships:\n\n" + townrel
	
	File.delete($townrel_file) if File.exist?($townrel_file)
	begin
		File.open($townrel_file, File::CREAT|File::EXCL|File::RDWR, 0644) do |fl|
			fl.write townrel
		end
		# Silent - no puts in TUI mode
	rescue
		# Silent error - no puts in TUI mode
	end
end

# Simple function to ensure proper path and extension of a town input file
def fix_town_file(town_file)
	town_file = "saved/" + town_file if File.dirname(town_file) == "."
	town_file = File.basename(town_file) + ".npc" if File.basename(town_file, ".*") == File.basename(town_file)
	abort("No such Town file!") unless File.exist?(town_file)
	return town_file
end
