# Weather to Latex function
def weather_out_latex(w,type)

type == "web" ? t = "/" : t = ""

bgc = ["ffffff", "ffffff", "ffffff", "80d55b", "eab8f5", "bd98f3", "98e3f3", "afafaf", "dcb796", "ad9d8f", "e9e4b0", "ffc37d", "6f6f6f", "525252"]

l = <<LATEXSTART 
%Created by npcg, see: https://github.com/isene/npcg
\\documentclass[14pt,a4paper]{article}
\\usepackage[margin=2cm]{geometry}
\\usepackage{graphicx}
\\usepackage[dvipsnames]{xcolor}
\\definecolor{#{w.month_n}}{HTML}{#{bgc[w.month_n]}}
\\usepackage{pdfpages}
LATEXSTART

l += <<LATEXTABLESTART
\\begin{document}
\\makeatletter
\\setlength{\\@fptop}{0pt}
\\makeatother
\\begin{table}
\\begin{center}
\\fcolorbox{black}{#{w.month_n}}{\\begin{minipage}[c][0.6cm][c]{\\linewidth}\\begin{center}{\\LARGE \\textsf{#{$Month[w.month_n]}}}\\end{center}\\end{minipage}}\\\\
\\smallskip
\\fbox{\\begin{tabular}{| p{2cm} | p{2cm} | p{2cm} | p{2cm} | p{2cm} | p{2cm} | p{2cm} |}
LATEXTABLESTART

# Create each cell; tc = table cell
tc = []
w.day.each_with_index do |d,i|
	imgflag = false
	tc[i]  = "\\vspace{0.02cm}"
	tc[i] += "\\raisebox{1ex}{{\\bfseries{\\large #{i+1}}}}"
	tc[i] += "\\hfill"
	if d.special != ""
		g = d.special.delete(' ').downcase
		tc[i] += "\\includegraphics[width=0.5cm]{#{t}images/gods/#{g}.png}"
		imgflag = true
	end
	unless w.month_n == 0
		if i == 0
			tc[i] += " \\includegraphics[width=0.47cm]{#{t}images/moon/0.png}"; imgflag = true
		elsif i == 7
			tc[i] += " \\includegraphics[width=0.47cm]{#{t}images/moon/1.png}"; imgflag = true
		elsif i == 14
			tc[i] += " \\includegraphics[width=0.47cm]{#{t}images/moon/2.png}"; imgflag = true
		elsif i == 21
			tc[i] += " \\includegraphics[width=0.47cm]{#{t}images/moon/3.png}"; imgflag = true
		end
	end
	tc[i] += "\\includegraphics[width=0.5cm]{#{t}images/weather/blank.png}" if imgflag == false
	tc[i] += "\\vspace{0.3cm}"
	tc[i] += "\\newline"
	tc[i] += "\\includegraphics[width=0.9cm]{#{t}images/weather/weather#{d.weather}.png}"
	tc[i] += "\\hfill"
	tc[i] += "\\includegraphics[width=0.9cm]{#{t}images/weather/wind#{d.wind}.png}"
end

#Display each cell
j = 0
l += "\\hline\n"
4.times do
	6.times do
    l += "#{tc[j]} & "
		j += 1
	end
	l += "#{tc[j]} \\\\\n"
	l += "\\hline\n"
	j += 1
end

l += <<LATEXTABLEEND
\\end{tabular}}
\\end{center}
\\end{table}
LATEXTABLEEND

l += "\\end{document}"

File.delete("weather.tex") if File.exists?("weather.tex")
begin
	File.write("weather.tex", l, perm: 0644)
rescue
	puts "Error writing file weather.tex"
end

system "clear" if t == ""

File.delete("weather.pdf") if File.exists?("weather.pdf")
if File.exists?("weather.tex")
	`pdflatex -interaction nonstopmode weather.tex` 
	if File.exists?("weather.pdf")
		puts "Weather file created: weather.pdf" 
	else
		puts "Weather file not created!" 
	end
end

gets if t == ""

end
