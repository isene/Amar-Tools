# Weather to Latex function
def weather_out_latex(w)
l = <<LATEXSTART 
%Created by npcg, see: https://github.com/isene/npcg
\\documentclass[10pt,a4paper,usenames]{article}
\\usepackage[margin=2cm]{geometry}
\\usepackage[utf8]{inputenc}
\\usepackage[english]{babel}
\\usepackage[T1]{fontenc}
\\usepackage{alltt}
\\usepackage{fancyhdr}
\\pagestyle{fancy}
\\fancyhead[RO]{\\raggedleft Weather - for Amar RPG}
\\fancyfoot{}
\\usepackage{pdfpages}
\\begin{document}
LATEXSTART

l += <<LATEXTABLESTART
\\begin{table}[h!]
\\begin{center}
\\caption{#{$a}}
\\label{tab:table1}
\\begin{tabular}{l|l|l|l|l|l|l|}
LATEXTABLESTART

c = []
i = 0
4.times do
	6.times do
    l += "#{@c[i]} & "
		i += 1
	end
	l += "#{@c[i]} \\\\\n"
	i += 1
	l += "\\hline\n"
end

l += <<LATEXTABLEEND
\\end{tabular}
\\end{center}
\\end{table}
LATEXTABLEEND

l += "\\end{document}"
end
