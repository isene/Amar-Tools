def town_relations(town_file)
	abort("No such Town file!") unless File.exist?(town_file)

	town = ""
	File.open(town_file) do |fl|
		town = fl.read
	end
	t = town.gsub(/ \[.*/, '')
	t.sub!(/^.*\n\n/, '')
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

	begin
		begin
			File.delete("town.dot")
		rescue
		end
		File.open("town.dot", File::CREAT|File::EXCL|File::RDWR, 0644) do |fl|
			fl.write dot_text
		end
		`dot -Tpng town.dot -o town.png`
		puts "Graph file written."
	rescue
		 puts "Error! No graph file written."
	end
end
